sounddeStart:

sounddeChannel0:
sounddeChannel1:
sounddeChannel4:
sounddeChannel6:
	cmdff


sound97Start:
sounda1Start:
soundadStart:
soundb6Start:

sound97Channel2:
sound97Channel7:
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

sound41Start:
sound42Start:

sound41Channel0:
sound41Channel1:
sound41Channel4:
sound41Channel6:
sound42Channel0:
sound42Channel1:
sound42Channel4:
sound42Channel6:
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

soundd5Start:
soundd5Channel2:
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

sound43Start:
sound44Start:
sound45Start:

sound43Channel0:
sound43Channel1:
sound43Channel4:
sound43Channel6:
sound44Channel0:
sound44Channel1:
sound44Channel4:
sound44Channel6:
sound45Channel0:
sound45Channel1:
sound45Channel4:
sound45Channel6:
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

sound1bStart:

sound24Start:

sound26Start:

sound27Start:

sound31Start:

sound38Start:

sound46Start:

sound1bChannel6:
sound24Channel6:
sound26Channel6:
sound27Channel6:
sound31Channel4:
sound31Channel6:
sound38Channel6:
sound46Channel6:
	cmdff

sound20Start:

sound20Channel1:
	vibrato $00
	env $0 $00
	duty $02
musicf4007:
	vol $0
	note gs3 $20
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $04
	rest $02
	vol $1
	note e4  $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note g4  $04
	rest $04
	vol $3
	note g4  $04
	rest $04
	vol $6
	note g4  $04
	rest $04
	vol $3
	note g4  $04
	rest $04
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $04
	vol $1
	note fs4 $04
	rest $1c
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $04
	rest $06
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $04
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $04
	vol $1
	note fs4 $04
	rest $1c
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $04
	rest $06
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $04
	vol $6
	note g4  $04
	rest $04
	vol $3
	note g4  $04
	rest $04
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note e4  $18
	vol $3
	note e4  $08
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note g4  $18
	vol $3
	note g4  $08
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note e4  $14
	vol $3
	note e4  $0c
	rest $20
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note g4  $04
	rest $04
	vol $3
	note g4  $04
	rest $04
	vol $6
	note g4  $04
	rest $04
	vol $3
	note g4  $04
	rest $04
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $24
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $04
	rest $06
	vol $6
	note a4  $05
	rest $03
	vol $3
	note a4  $05
	rest $03
	vol $6
	note b4  $05
	rest $03
	vol $3
	note b4  $05
	rest $03
	vol $6
	note c5  $05
	rest $03
	vol $3
	note c5  $05
	rest $03
	vol $6
	note d5  $05
	rest $03
	vol $3
	note d5  $05
	rest $03
	vol $6
	note c5  $05
	rest $03
	vol $3
	note c5  $05
	rest $23
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $04
	rest $06
	vol $6
	note c5  $04
	rest $04
	vol $3
	note c5  $04
	rest $04
	vol $6
	note b4  $04
	rest $04
	vol $3
	note b4  $04
	rest $04
	vol $6
	note a4  $04
	rest $04
	vol $3
	note a4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note g4  $08
	note fs4 $08
	note e4  $08
	note d4  $08
	note e4  $30
	vol $3
	note e4  $10
	vol $1
	note e4  $08
	rest $18
	goto musicf4007
	cmdff

sound20Channel0:
	vibrato $00
	env $0 $00
	duty $02
musicf4298:
	vol $0
	note gs3 $20
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $06
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $24
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $04
	rest $06
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $24
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $06
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note c4  $14
	vol $3
	note c4  $0c
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note d4  $18
	vol $3
	note d4  $08
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note c4  $14
	vol $3
	note c4  $0c
	rest $20
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $06
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $24
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $04
	rest $06
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note f4  $04
	rest $04
	vol $3
	note f4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $24
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $04
	rest $06
	vol $6
	note a4  $04
	rest $04
	vol $3
	note a4  $04
	rest $04
	vol $6
	note g4  $04
	rest $04
	vol $3
	note g4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note a3  $04
	rest $04
	vol $3
	note a3  $04
	rest $84
	goto musicf4298
	cmdff

sound20Channel4:
musicf4503:
	duty $0e
	note a2  $20
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $3c
	note b2  $20
	note c3  $20
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $0c
	note b3  $04
	rest $0c
	note b3  $04
	rest $0c
	note a3  $04
	rest $0c
	note a3  $04
	rest $0c
	note b3  $04
	rest $0c
	note a2  $20
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $1c
	note b2  $3c
	rest $04
	note b2  $20
	note a2  $12
	rest $0e
	note a2  $08
	rest $08
	note b2  $1c
	rest $04
	note g2  $04
	rest $0c
	note a2  $14
	rest $0c
	note a2  $20
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $1c
	note b2  $14
	rest $0c
	note e3  $05
	rest $0b
	note d3  $05
	rest $0b
	note c3  $20
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $1c
	note b2  $20
	note e2  $0d
	rest $03
	note g2  $0d
	rest $03
	note a2  $20
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	duty $0e
	note c4  $04
	duty $0f
	note c4  $0c
	duty $0e
	note e3  $04
	duty $0f
	note e3  $0c
	duty $0e
	note e3  $04
	duty $0f
	note e3  $0c
	duty $0e
	note c3  $04
	duty $0f
	note c3  $0c
	duty $0e
	note c3  $04
	duty $0f
	note c3  $0c
	duty $0e
	note a2  $04
	duty $0f
	note a2  $0c
	duty $0e
	note d3  $20
	note a2  $08
	rest $08
	note fs2 $20
	note a2  $08
	rest $08
	note d2  $20
	goto musicf4503
	cmdff

sound20Channel6:
musicf460f:
	vol $5
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	goto musicf460f
	cmdff

sound21Start:

sound21Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musicf47e4:
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $04
	vol $6
	note d4  $03
	vol $3
	note d4  $04
	vol $6
	note d4  $03
	vol $3
	note d4  $04
	vol $6
	note f4  $54
	vibrato $01
	env $0 $00
	vol $5
	note f4  $1c
	vol $1
	note f4  $1c
	vibrato $e1
	env $0 $00
	vol $6
	note e4  $2a
	vol $3
	note e4  $0e
	vol $6
	note ds4 $0e
	note a3  $07
	rest $03
	vol $3
	note a3  $04
	note ds4 $0e
	note a3  $07
	rest $03
	vol $1
	note a3  $04
	note ds4 $0e
	note a3  $07
	rest $03
	vol $0
	note a3  $04
	note ds4 $0e
	note a3  $07
	rest $03
	vol $0
	note a3  $04
	vol $6
	note ds4 $0e
	note a4  $07
	rest $03
	vol $3
	note a4  $04
	vol $5
	note ds5 $0e
	note a5  $07
	rest $03
	vol $2
	note a5  $04
	vol $3
	note ds4 $0e
	note a4  $07
	rest $03
	vol $1
	note a4  $04
	vol $2
	note ds5 $0e
	note a5  $07
	rest $03
	vol $1
	note a5  $04
	vol $6
	note f4  $07
	rest $03
	vol $3
	note f4  $04
	vol $6
	note f4  $03
	vol $3
	note f4  $04
	vol $6
	note f4  $03
	vol $3
	note f4  $04
	vol $6
	note gs4 $54
	vibrato $01
	env $0 $00
	vol $4
	note gs4 $38
	vol $2
	note gs4 $1c
	vibrato $e1
	env $0 $00
	vol $6
	note g4  $0e
	note gs4 $07
	note g4  $07
	note fs4 $0e
	note cs4 $07
	rest $03
	vol $3
	note cs4 $04
	note fs4 $0e
	note cs4 $07
	rest $03
	vol $1
	note cs4 $04
	note fs4 $0e
	note cs4 $07
	rest $03
	vol $0
	note cs4 $04
	note fs4 $0e
	note cs4 $07
	rest $03
	vol $0
	note cs4 $04
	vol $6
	note g4  $0e
	note cs4 $07
	rest $03
	vol $3
	note cs4 $04
	note g4  $0e
	note cs4 $07
	rest $03
	vol $1
	note cs4 $04
	vol $6
	note g4  $0e
	note cs5 $07
	rest $03
	vol $3
	note cs5 $04
	note g4  $0e
	note cs5 $07
	rest $03
	vol $1
	note cs5 $04
	vol $6
	note a4  $07
	note e5  $07
	note a5  $07
	rest $03
	vol $3
	note a5  $04
	vol $6
	note a4  $07
	note e5  $07
	note a5  $07
	rest $03
	vol $3
	note a5  $04
	vol $6
	note as4 $07
	note f5  $07
	note as5 $07
	rest $03
	vol $3
	note as5 $07
	rest $19
	vol $6
	note a4  $07
	note e5  $07
	note a5  $07
	rest $03
	vol $3
	note a5  $04
	vol $6
	note a4  $07
	note e5  $07
	note a5  $07
	rest $03
	vol $3
	note a5  $04
	vol $6
	note gs5 $07
	note gs4 $03
	rest $04
	note gs4 $07
	rest $03
	vol $3
	note gs4 $07
	rest $19
	vol $6
	note a4  $07
	note e5  $07
	vol $6
	note a5  $07
	rest $03
	vol $3
	note a5  $04
	vol $6
	note as4 $07
	note f5  $07
	note as5 $07
	rest $03
	vol $3
	note as5 $04
	vol $6
	note b4  $07
	note fs5 $07
	note b5  $07
	rest $03
	vol $3
	note b5  $04
	vol $6
	note c5  $07
	note g5  $07
	note c6  $07
	rest $03
	vol $3
	note c6  $04
	vol $6
	note d6  $07
	note cs6 $07
	note ds6 $07
	note d6  $07
	note cs6 $07
	note c6  $07
	note d6  $07
	note cs6 $07
	note c6  $07
	note b5  $07
	note cs6 $07
	note c6  $07
	note b5  $07
	note as5 $07
	note c6  $07
	note b5  $07
	goto musicf47e4
	cmdff

sound21Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicf497c:
	vol $6
	note a2  $07
	rest $07
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note cs3 $07
	vol $3
	note b2  $07
	vol $6
	note ds3 $07
	note e3  $07
	note cs3 $07
	note e3  $07
	note ds3 $07
	note e3  $07
	note d3  $07
	note f3  $07
	note e3  $07
	note f3  $07
	note d3  $07
	note f3  $07
	note e3  $07
	note f3  $07
	note cs3 $07
	note e3  $07
	note ds3 $07
	note e3  $07
	note cs3 $07
	note e3  $07
	note ds3 $07
	note e3  $07
	note c3  $07
	note ds3 $07
	note d3  $07
	note ds3 $07
	note c3  $07
	note ds3 $07
	note d3  $07
	note ds3 $07
	note cs3 $07
	note e3  $07
	note ds3 $07
	note e3  $07
	note d3  $07
	note f3  $07
	note e3  $07
	note f3  $07
	note ds3 $07
	note fs3 $07
	note f3  $07
	note fs3 $07
	note e3  $07
	note g3  $07
	vol $6
	note fs3 $07
	note g3  $07
	note as5 $07
	note a5  $07
	note b5  $07
	note as5 $07
	note a5  $07
	note gs5 $07
	note as5 $07
	note a5  $07
	note gs5 $07
	note g5  $07
	note a5  $07
	note gs5 $07
	note g5  $07
	note fs5 $07
	note gs5 $07
	note g5  $07
	goto musicf497c
	cmdff

sound21Channel4:
musicf4b82:
	duty $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note a1  $03
	rest $04
	note a1  $03
	rest $0b
	note a1  $03
	rest $04
	note a1  $03
	rest $04
	note a1  $07
	rest $07
	note a1  $03
	rest $04
	note as1 $03
	rest $04
	note as1 $07
	rest $07
	note as1 $03
	rest $04
	note as1 $03
	rest $04
	note as1 $02
	rest $05
	note as1 $02
	rest $05
	note as1 $03
	rest $04
	note a1  $03
	rest $04
	note a1  $03
	rest $0b
	note a1  $03
	rest $04
	note a1  $03
	rest $04
	note a1  $07
	rest $07
	note a1  $03
	rest $04
	note gs1 $03
	rest $04
	note gs1 $07
	rest $07
	note gs1 $03
	rest $04
	note gs1 $03
	rest $04
	note gs1 $02
	rest $05
	note gs1 $02
	rest $05
	note gs1 $03
	rest $04
	note a1  $03
	rest $04
	note a1  $07
	rest $07
	note a1  $03
	rest $04
	note as1 $03
	rest $04
	note as1 $07
	rest $07
	note as1 $03
	rest $04
	note b1  $03
	rest $04
	note b1  $07
	rest $07
	note b1  $03
	rest $04
	note c2  $03
	rest $04
	note c2  $07
	rest $07
	note c2  $07
	note cs2 $07
	note d2  $07
	note c2  $07
	note cs2 $07
	note b1  $07
	note c2  $07
	note as1 $07
	note b1  $07
	note a1  $07
	note as1 $07
	note gs1 $07
	note a1  $07
	note g1  $07
	note gs1 $07
	note fs1 $07
	note g1  $07
	goto musicf4b82
	cmdff

sound21Channel6:
musicf4cbe:
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	goto musicf4cbe
	cmdff

sound24Channel1:
	cmdff

sound24Channel0:
	cmdff

sound24Channel4:
	cmdff

sound23Start:

sound23Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musicf4ea0:
	vol $6
	note a2  $0e
	note gs2 $08
	note a2  $0e
	note b2  $08
	note c3  $0e
	note b2  $08
	note c3  $0e
	note d3  $08
	note ds3 $0e
	note e3  $08
	note ds3 $0e
	note e3  $08
	rest $2c
	note a4  $0e
	note gs4 $08
	note a4  $0e
	note gs4 $08
	note g4  $0e
	note fs4 $08
	note g4  $0e
	note fs4 $08
	note f4  $0e
	note e4  $08
	note f4  $0e
	note e4  $08
	rest $2c
	note e5  $0e
	note ds5 $08
	note e5  $0e
	note ds5 $08
	note d5  $0e
	note cs5 $08
	note d5  $0e
	note cs5 $08
	note c5  $0e
	note b4  $08
	note c5  $0e
	note b4  $08
	note as4 $0e
	note a4  $08
	note as4 $0e
	vol $6
	note a4  $08
	note gs4 $2c
	note f4  $16
	note gs4 $0e
	note f4  $08
	note e4  $07
	rest $1d
	note d4  $08
	note c4  $07
	rest $0f
	note b3  $07
	rest $0f
	vol $6
	note e4  $0e
	note ds4 $08
	note e4  $0e
	note ds4 $08
	note e4  $07
	rest $04
	vol $3
	note e4  $07
	rest $04
	vol $6
	note a4  $07
	rest $04
	vol $3
	note a4  $07
	rest $04
	vol $6
	note ds4 $0e
	note d4  $08
	note ds4 $0e
	note d4  $08
	rest $03
	vol $3
	note d4  $08
	rest $03
	vol $1
	note d4  $08
	rest $16
	vol $6
	note e4  $0e
	note ds4 $08
	note e4  $0e
	note ds4 $08
	note e4  $07
	rest $04
	vol $3
	note e4  $07
	rest $04
	vol $6
	note a4  $07
	rest $04
	vol $3
	note a4  $07
	rest $04
	vol $6
	note c5  $0e
	note gs4 $08
	note c5  $0e
	note gs4 $08
	rest $03
	vol $3
	note gs4 $08
	rest $03
	vol $1
	note gs4 $08
	rest $16
	vol $6
	note a4  $0e
	note gs4 $08
	note a4  $0e
	note gs4 $08
	note a4  $07
	rest $04
	vol $3
	note a4  $07
	rest $04
	vol $6
	note c5  $07
	rest $04
	vol $3
	note c5  $07
	rest $04
	vol $6
	note gs4 $0e
	note g4  $08
	note gs4 $0e
	note g4  $08
	rest $03
	vol $3
	note g4  $08
	rest $03
	vol $1
	note g4  $08
	rest $16
	vol $6
	note a4  $0e
	note gs4 $08
	note a4  $0e
	note gs4 $08
	note a4  $07
	rest $04
	vol $3
	note a4  $07
	rest $04
	vol $6
	note e5  $07
	rest $04
	vol $3
	note e5  $07
	rest $04
	vol $6
	note ds5 $0e
	note e5  $08
	note f5  $0e
	note e5  $08
	rest $03
	vol $3
	note e5  $08
	rest $03
	vol $1
	note e5  $08
	rest $24
	vol $6
	note a4  $08
	note e4  $0e
	rest $03
	vol $3
	note e4  $05
	vol $6
	note e4  $0e
	note ds4 $08
	rest $03
	vol $3
	note ds4 $08
	rest $03
	vol $6
	note d4  $08
	note c4  $07
	rest $04
	vol $3
	note c4  $07
	rest $04
	vol $6
	note c4  $0e
	note b3  $08
	rest $03
	vol $3
	note b3  $08
	rest $03
	vol $6
	note e4  $08
	note ds4 $0e
	note e4  $08
	note a4  $07
	rest $04
	vol $3
	note a4  $03
	vol $6
	note e5  $08
	note ds5 $0e
	rest $03
	vol $3
	note ds5 $05
	vol $6
	note ds5 $0e
	note d5  $08
	rest $03
	vol $3
	note d5  $08
	rest $03
	vol $6
	note d5  $08
	note c5  $07
	rest $04
	vol $3
	note c5  $07
	rest $04
	vol $6
	note c5  $0e
	note b4  $08
	rest $03
	vol $3
	note b4  $08
	rest $03
	vol $6
	note e4  $03
	rest $05
	note e4  $07
	rest $04
	vol $3
	note e4  $03
	vol $6
	note e4  $08
	note f4  $16
	note e4  $07
	rest $04
	vol $3
	note e4  $07
	rest $04
	vol $6
	note g4  $16
	note e4  $07
	rest $04
	vol $3
	note e4  $07
	rest $04
	vol $6
	note f4  $16
	note e4  $07
	rest $04
	vol $3
	note e4  $07
	rest $04
	vol $6
	note g4  $16
	note e4  $07
	rest $04
	vol $3
	note e4  $07
	rest $5c
	vol $6
	note e4  $07
	note gs4 $07
	note as4 $08
	note gs4 $07
	note as4 $07
	note d5  $08
	note as4 $07
	note d5  $07
	note e5  $08
	note d5  $07
	note e5  $07
	note as5 $08
	goto musicf4ea0
	cmdff

sound23Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicf509b:
	vol $1
	note a2  $0b
	vol $3
	note a2  $0e
	note gs2 $08
	note a2  $0e
	note b2  $08
	note c3  $0e
	note b2  $08
	note c3  $0e
	note d3  $08
	note ds3 $0e
	note e3  $08
	note ds3 $0e
	note e3  $08
	rest $2c
	note a4  $0e
	note gs4 $08
	note a4  $0e
	note gs4 $08
	note g4  $0e
	note fs4 $08
	note g4  $0e
	note fs4 $08
	note f4  $0e
	note e4  $08
	note f4  $0e
	note e4  $08
	rest $21
	vol $6
	note a4  $2c
	note gs4 $2c
	note g4  $2c
	note fs4 $2c
	note f4  $2c
	note d4  $2c
	note b3  $07
	rest $07
	vol $3
	note b3  $08
	rest $07
	vol $1
	note b3  $07
	rest $08
	vol $6
	note gs3 $07
	rest $07
	vol $3
	note gs3 $08
	rest $07
	vol $1
	note gs3 $07
	rest $13
	vol $3
	note e4  $0e
	note ds4 $08
	note e4  $0e
	note ds4 $08
	note e4  $07
	rest $04
	vol $1
	note e4  $07
	rest $04
	vol $3
	note a4  $07
	rest $04
	vol $1
	note a4  $07
	rest $04
	vol $3
	note ds4 $0e
	note d4  $08
	note ds4 $0e
	note d4  $08
	rest $03
	vol $1
	note d4  $08
	rest $03
	vol $0
	note d4  $08
	rest $16
	vol $3
	note e4  $0e
	note ds4 $08
	note e4  $0e
	note ds4 $08
	note e4  $07
	rest $04
	vol $1
	note e4  $07
	rest $04
	vol $3
	note a4  $07
	rest $04
	vol $1
	note a4  $07
	rest $04
	vol $3
	note c5  $0e
	note gs4 $08
	note c5  $0e
	note gs4 $08
	rest $03
	vol $1
	note gs4 $08
	rest $03
	vol $0
	note gs4 $08
	rest $16
	vol $3
	note a4  $0e
	note gs4 $08
	note a4  $0e
	note gs4 $08
	note a4  $07
	rest $04
	vol $1
	note a4  $07
	rest $04
	vol $3
	note c5  $07
	rest $04
	vol $1
	note c5  $07
	rest $04
	vol $3
	note gs4 $0e
	note g4  $08
	note gs4 $0e
	note g4  $08
	rest $03
	vol $1
	note g4  $08
	rest $03
	vol $0
	note g4  $08
	rest $16
	vol $3
	note a4  $0e
	note gs4 $08
	note a4  $0e
	note gs4 $08
	note a4  $07
	rest $04
	vol $1
	note a4  $07
	rest $04
	vol $3
	note e5  $07
	rest $04
	vol $1
	note e5  $07
	rest $04
	vol $3
	note ds5 $0e
	note e5  $08
	note f5  $0e
	note e5  $08
	rest $03
	vol $1
	note e5  $08
	rest $03
	vol $0
	note e5  $08
	rest $24
	vol $3
	note a4  $08
	note e4  $0e
	rest $03
	vol $1
	note e4  $05
	vol $3
	note e4  $0e
	note ds4 $08
	rest $03
	vol $1
	note ds4 $08
	rest $03
	vol $3
	note d4  $08
	note c4  $07
	rest $04
	vol $1
	note c4  $07
	rest $04
	vol $3
	note c4  $0e
	note b3  $08
	rest $03
	vol $1
	note b3  $08
	rest $03
	vol $3
	note e4  $08
	note ds4 $0b
	vol $6
	note c5  $07
	rest $04
	vol $3
	note c5  $03
	vol $6
	note c5  $08
	note b4  $0e
	rest $03
	vol $3
	note b4  $05
	vol $6
	note b4  $0e
	note as4 $08
	rest $03
	vol $3
	note as4 $08
	rest $03
	vol $6
	note as4 $08
	note gs4 $07
	rest $04
	vol $3
	note gs4 $07
	rest $04
	vol $6
	note gs4 $0e
	note e4  $08
	rest $03
	vol $3
	note e4  $08
	rest $03
	vol $6
	note c4  $03
	rest $05
	note c4  $07
	rest $04
	vol $3
	note c4  $03
	vol $6
	note c4  $08
	vol $6
	note cs4 $16
	note c4  $07
	rest $04
	vol $3
	note c4  $07
	rest $04
	vol $6
	note ds4 $16
	note c4  $07
	rest $04
	vol $3
	note c4  $07
	rest $04
	vol $6
	note cs4 $16
	note c4  $07
	rest $04
	vol $3
	note c4  $07
	rest $04
	vol $6
	note ds4 $16
	note c4  $07
	rest $04
	vol $3
	note c4  $07
	rest $67
	note e4  $07
	note gs4 $07
	note as4 $08
	note gs4 $07
	note as4 $07
	note d5  $08
	note as4 $07
	note d5  $07
	note e5  $08
	note d5  $07
	note e5  $04
	goto musicf509b
	cmdff

sound23Channel4:
musicf5283:
	duty $0e
	note a1  $07
	rest $25
	note f2  $07
	rest $25
	note ds2 $24
	note e2  $08
	duty $0f
	note e2  $08
	rest $06
	duty $0e
	note e2  $08
	note fs2 $0e
	note gs2 $08
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note b1  $24
	note e2  $08
	duty $0f
	note e2  $08
	rest $06
	duty $0e
	note e3  $08
	note ds3 $0e
	note d3  $08
	note c3  $0e
	note b2  $08
	note c3  $0e
	note b2  $08
	note as2 $0e
	note a2  $08
	note as2 $0e
	note a2  $08
	note gs2 $0e
	note g2  $08
	note gs2 $0e
	note g2  $08
	note fs2 $0e
	note f2  $08
	note fs2 $0e
	note f2  $08
	note e2  $2c
	note f2  $2c
	note fs2 $2c
	note gs2 $2c
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note ds2 $24
	note e2  $08
	duty $0f
	note e2  $08
	rest $06
	duty $0e
	note e2  $16
	note fs2 $03
	note gs2 $05
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note ds2 $0e
	note e2  $08
	note ds2 $0e
	note e2  $08
	duty $0f
	note e2  $08
	rest $06
	duty $0e
	note e2  $16
	note fs2 $03
	note gs2 $05
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note d2  $24
	note ds2 $08
	duty $0f
	note ds2 $08
	rest $06
	duty $0e
	note e2  $16
	note fs2 $03
	note gs2 $05
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note ds2 $0e
	note e2  $08
	note f2  $0e
	note e2  $08
	duty $0f
	note e2  $08
	rest $0e
	duty $0e
	note e2  $16
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note d2  $24
	note e2  $08
	duty $0f
	note e2  $08
	rest $24
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	rest $08
	duty $0e
	note d2  $0e
	note e2  $08
	duty $0f
	note e2  $08
	rest $24
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $a2
	duty $0e
	note ds2 $0e
	note e2  $08
	note ds2 $0e
	note e2  $08
	note c3  $0e
	note b2  $08
	duty $0f
	note b2  $08
	rest $06
	duty $0e
	note as2 $60
	goto musicf5283
	cmdff

sound23Channel6:
musicf5403:
	rest $ff
	rest $ff
	rest $28
	vol $4
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $3
	note $2a $24
	vol $3
	note $2a $08
	vol $2
	note $2e $16
	vol $3
	note $2a $42
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	vol $3
	note $2a $08
	vol $2
	note $2e $16
	vol $0
	vol $3
	note $2a $16
	vol $4
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	vol $3
	vol $3
	note $2a $08
	vol $4
	vol $2
	note $2e $16
	rest $16
	vol $4
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	vol $3
	vol $3
	note $2a $08
	vol $4
	vol $2
	note $2e $16
	rest $16
	vol $4
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	vol $3
	vol $3
	note $2a $08
	vol $4
	vol $2
	note $2e $16
	rest $16
	vol $4
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	vol $3
	vol $3
	note $2a $08
	vol $4
	vol $2
	note $2e $16
	rest $16
	vol $4
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	vol $3
	vol $3
	note $2a $08
	vol $4
	vol $2
	note $2e $16
	vol $2
	note $2e $16
	vol $3
	note $2a $0e
	vol $3
	note $2a $08
	vol $2
	note $2e $16
	vol $3
	note $2a $0e
	vol $3
	note $2a $08
	vol $2
	note $2e $16
	vol $3
	note $2a $0e
	vol $3
	note $2a $08
	vol $2
	note $2e $16
	vol $3
	note $2a $0e
	vol $3
	note $2a $08
	vol $2
	note $2e $0e
	vol $3
	note $2a $08
	vol $3
	note $2a $0e
	vol $3
	note $2a $08
	vol $3
	note $2a $0e
	vol $3
	note $2a $16
	vol $3
	note $2a $16
	vol $3
	note $2a $08
	vol $3
	note $2a $07
	vol $3
	note $2a $07
	vol $3
	note $2a $08
	vol $3
	note $2a $07
	vol $3
	note $2a $07
	vol $3
	note $2a $08
	vol $3
	note $2a $07
	vol $3
	note $2a $07
	vol $3
	note $2a $08
	goto musicf5403
	cmdff

sound1bChannel1:
musicf54fb:
	vibrato $00
	env $0 $05
	duty $02
	vol $6
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	vibrato $e1
	env $0 $00
	note e4  $4b
	vibrato $01
	env $0 $00
	vol $3
	note e4  $0f
	vibrato $e1
	env $0 $00
	vol $6
	note ds4 $4b
	vibrato $01
	env $0 $00
	vol $3
	note ds4 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note d4  $4b
	vibrato $01
	env $0 $00
	vol $3
	note d4  $0f
	vibrato $e1
	env $0 $00
	vol $6
	note cs4 $4b
	vibrato $01
	env $0 $00
	vol $3
	note cs4 $0f
	vibrato $00
	env $0 $03
	vol $6
	note c4  $0f
	note g3  $0f
	note fs3 $0f
	note c4  $0f
	note g3  $0f
	note fs3 $0f
	vol $5
	note c5  $0f
	note g4  $0f
	note fs4 $0f
	note c5  $0f
	note g4  $0f
	note fs4 $0f
	env $0 $04
	vol $4
	note c6  $0f
	note g5  $0f
	vol $4
	note fs5 $0f
	vol $4
	note c6  $0f
	note g5  $0f
	vol $4
	note fs5 $0f
	env $0 $05
	vol $3
	note c7  $0f
	note g6  $0f
	note fs6 $0f
	vol $3
	note c7  $0f
	note g6  $0f
	note fs6 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note d4  $4b
	vibrato $01
	env $0 $00
	vol $3
	note d4  $0f
	vibrato $e1
	env $0 $00
	vol $6
	note cs4 $4b
	vibrato $01
	env $0 $00
	vol $3
	note cs4 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note c4  $4b
	vibrato $01
	env $0 $00
	vol $3
	note c4  $0f
	vibrato $e1
	env $0 $00
	vol $6
	note b3  $4b
	vibrato $01
	env $0 $00
	vol $3
	note b3  $0f
	vibrato $00
	env $0 $03
	vol $6
	note a3  $0f
	note e3  $0f
	note ds3 $0f
	note a3  $0f
	note e3  $0f
	note ds3 $0f
	vol $5
	note a4  $0f
	note e4  $0f
	note ds4 $0f
	note a4  $0f
	note e4  $0f
	note ds4 $0f
	env $0 $04
	vol $4
	note a5  $0f
	note e5  $0f
	note ds5 $0f
	note a5  $0f
	note e5  $0f
	note ds5 $0f
	env $0 $05
	vol $3
	note a6  $0f
	note e6  $0f
	note ds6 $0f
	note a6  $0f
	note e6  $0f
	note ds6 $0f
	goto musicf54fb
	cmdff

sound1bChannel0:
musicf56b1:
	vibrato $00
	env $0 $05
	duty $02
	vol $1
	note ds5 $0f
	vol $3
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	vol $4
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note cs5 $0f
	vol $4
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note b3  $3c
	vibrato $01
	env $0 $00
	vol $3
	note b3  $1e
	vibrato $e1
	env $0 $00
	vol $6
	note as3 $3c
	vibrato $01
	env $0 $00
	vol $3
	note as3 $1e
	vibrato $e1
	env $0 $00
	vol $6
	note a3  $3c
	vibrato $01
	env $0 $00
	vol $3
	note a3  $1e
	vibrato $e1
	env $0 $00
	vol $6
	note gs3 $3c
	vibrato $01
	env $0 $00
	vol $3
	note gs3 $1e
	rest $0f
	vibrato $00
	env $0 $03
	vol $4
	note c4  $0f
	note g3  $0f
	note fs3 $0f
	note c4  $0f
	note g3  $0f
	note fs3 $0f
	vol $3
	note c5  $0f
	vol $3
	note g4  $0f
	note fs4 $0f
	note c5  $0f
	note g4  $0f
	note fs4 $0f
	vol $2
	note c6  $0f
	vol $2
	note g5  $0f
	note fs5 $0f
	note c6  $0f
	note g5  $0f
	note fs5 $0f
	vol $1
	note c7  $0f
	vol $1
	note g6  $0f
	vol $1
	note fs6 $0f
	vol $1
	note c7  $0f
	vol $1
	note g6  $0f
	vibrato $e1
	env $0 $00
	vol $6
	note as2 $3c
	vibrato $01
	env $0 $00
	vol $3
	note as2 $1e
	vibrato $e1
	env $0 $00
	vol $6
	note a2  $3c
	vibrato $01
	env $0 $00
	vol $3
	note a2  $1e
	vibrato $e1
	env $0 $00
	vol $6
	note gs2 $3c
	vibrato $01
	env $0 $00
	vol $3
	note gs2 $1e
	vibrato $e1
	env $0 $00
	vol $6
	note g2  $3c
	vibrato $01
	env $0 $00
	vol $3
	note g2  $1e
	rest $0b
	vibrato $00
	env $0 $03
	vol $3
	note a3  $0f
	note e3  $0f
	note ds3 $0f
	note a3  $0f
	note e3  $0f
	vol $2
	note ds3 $0f
	note a4  $0f
	note e4  $0f
	note ds4 $0f
	note a4  $0f
	note e4  $0f
	note ds4 $0f
	vol $2
	note a5  $0f
	note e5  $0f
	note ds5 $0f
	vol $2
	note a5  $0f
	note e5  $0f
	note ds5 $0f
	vol $1
	note a6  $0f
	note e6  $0f
	vol $1
	note ds6 $0f
	note a6  $0f
	vol $1
	note e6  $0f
	note ds6 $04
	goto musicf56b1
	cmdff

sound1bChannel4:
musicf586a:
	duty $0e
	note gs2 $a5
	note ds2 $0f
	duty $0e
	note gs2 $08
	duty $0f
	note gs2 $07
	duty $0e
	note gs2 $08
	duty $0f
	note gs2 $07
	duty $0e
	rest $96
	note g2  $a5
	note cs2 $0f
	duty $0e
	note g2  $08
	duty $0f
	note g2  $07
	duty $0e
	note g2  $08
	duty $0f
	note g2  $07
	duty $0e
	rest $96
	note gs2 $a5
	note ds3 $0f
	duty $0e
	note gs2 $08
	duty $0f
	note gs2 $07
	duty $0e
	note gs2 $08
	duty $0f
	note gs2 $07
	duty $0e
	rest $96
	note g2  $a5
	note cs3 $0f
	duty $0e
	note g2  $08
	duty $0f
	note g2  $07
	duty $0e
	note g2  $08
	duty $0f
	note g2  $07
	duty $0e
	rest $96
	note gs2 $2a
	rest $03
	note gs2 $0f
	rest $0f
	note gs2 $07
	rest $08
	note gs2 $07
	rest $08
	note gs2 $19
	rest $05
	note gs2 $19
	rest $05
	note gs2 $07
	rest $08
	note gs2 $07
	rest $08
	note gs2 $19
	rest $05
	note gs2 $19
	rest $05
	note gs2 $07
	rest $08
	note gs2 $07
	rest $08
	note gs2 $19
	rest $05
	note gs2 $19
	rest $05
	note gs2 $0f
	note fs2 $2a
	rest $03
	note fs2 $0f
	rest $0f
	note fs2 $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $0f
	note f3  $07
	rest $08
	note f3  $19
	rest $05
	note f3  $19
	rest $05
	note f3  $0f
	note e3  $07
	rest $08
	note e3  $19
	rest $05
	note e3  $19
	rest $05
	note e3  $07
	rest $08
	note ds3 $07
	rest $08
	note ds3 $19
	rest $05
	note ds3 $19
	rest $05
	note ds3 $07
	rest $08
	note d3  $07
	rest $08
	note d3  $19
	rest $05
	note d3  $19
	rest $05
	note d3  $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $07
	rest $08
	goto musicf586a
	cmdff

sound26Channel1:
	vibrato $00
	env $0 $00
	duty $01
musicf59c8:
	vol $6
	note ds5 $0e
	note d5  $07
	rest $03
	vol $3
	note d5  $04
	vol $6
	note cs5 $07
	rest $03
	vol $3
	note cs5 $04
	vol $6
	note c5  $07
	rest $03
	vol $3
	note c5  $07
	rest $04
	vol $1
	note c5  $07
	vol $6
	note b4  $0e
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $6
	note cs5 $07
	rest $03
	vol $3
	note cs5 $04
	vol $6
	note ds5 $0e
	note fs5 $07
	rest $03
	vol $3
	note fs5 $04
	vol $6
	note ds5 $07
	note d5  $07
	note cs5 $07
	note b4  $07
	rest $07
	vol $3
	note b4  $07
	vol $6
	note b4  $0e
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $6
	note cs5 $07
	rest $03
	vol $3
	note cs5 $04
	vol $6
	note ds5 $0e
	note d5  $07
	rest $03
	vol $3
	note d5  $04
	vol $6
	note cs5 $07
	rest $03
	vol $3
	note cs5 $04
	vol $6
	note c5  $07
	rest $03
	vol $3
	note c5  $07
	rest $04
	vol $1
	note c5  $07
	vol $6
	note b4  $0e
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $6
	note cs5 $07
	rest $03
	vol $3
	note cs5 $07
	rest $04
	vol $1
	note cs5 $07
	duty $02
	vol $7
	note fs6 $07
	rest $03
	vol $3
	note fs6 $04
	vol $7
	note fs6 $07
	vol $6
	note f6  $07
	note fs6 $07
	note f6  $07
	vol $6
	note fs6 $07
	rest $03
	vol $3
	note fs6 $04
	vol $6
	note f6  $07
	rest $03
	vol $3
	note f6  $04
	vol $6
	note fs6 $07
	rest $03
	vol $3
	note fs6 $07
	rest $04
	vol $1
	note fs6 $07
	duty $01
	vol $6
	note ds5 $0e
	note d5  $07
	rest $03
	vol $3
	note d5  $04
	vol $6
	note cs5 $07
	rest $03
	vol $3
	note cs5 $04
	vol $6
	note c5  $07
	rest $03
	vol $3
	note c5  $07
	rest $04
	vol $1
	note c5  $07
	vol $6
	note b4  $0e
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $6
	note cs5 $07
	rest $03
	vol $3
	note cs5 $04
	vol $6
	note ds5 $0e
	note fs5 $07
	rest $03
	vol $3
	note fs5 $04
	vol $6
	note ds5 $07
	note d5  $07
	note cs5 $07
	note b4  $07
	rest $03
	vol $3
	note b4  $07
	rest $04
	vol $6
	note b4  $0e
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $6
	note cs5 $07
	rest $03
	vol $3
	note cs5 $04
	vol $6
	note ds5 $0e
	note d5  $07
	rest $03
	vol $3
	note d5  $04
	vol $6
	note cs5 $07
	rest $03
	vol $3
	note cs5 $04
	vol $6
	note c5  $07
	rest $03
	vol $3
	note c5  $07
	rest $04
	vol $1
	note c5  $07
	vol $6
	note b4  $07
	rest $03
	vol $3
	note b4  $04
	vol $6
	note c5  $07
	note cs5 $07
	vol $6
	note d5  $07
	note ds5 $07
	rest $0e
	duty $02
	vol $7
	note as6 $07
	rest $03
	vol $3
	note as6 $04
	vol $7
	note as6 $07
	vol $6
	note a6  $07
	note as6 $07
	note a6  $07
	vol $6
	note as6 $07
	rest $03
	vol $3
	note as6 $04
	vol $6
	note a6  $07
	rest $03
	vol $3
	note a6  $04
	vol $6
	note as6 $07
	rest $03
	vol $3
	note as6 $07
	rest $04
	vol $1
	note as6 $06
	rest $01
	duty $01
	goto musicf59c8
	cmdff

sound26Channel0:
	vibrato $00
	env $0 $00
	duty $01
musicf5b5b:
	vol $0
	note gs3 $0e
	vol $6
	note gs3 $0e
	note b3  $0e
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	vol $6
	note gs3 $0e
	note b3  $0e
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	vol $6
	note gs3 $0e
	note b3  $0e
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	vol $6
	note gs3 $0e
	note b3  $0e
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	vol $6
	note gs3 $0e
	note b3  $0e
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	vol $6
	note gs3 $0e
	note b3  $0e
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	duty $02
	vol $6
	note ds6 $07
	rest $03
	vol $3
	note ds6 $04
	vol $6
	note ds6 $07
	note d6  $07
	note ds6 $07
	note d6  $07
	note ds6 $07
	rest $03
	vol $3
	note ds6 $04
	vol $6
	note d6  $07
	rest $03
	vol $3
	note d6  $04
	vol $6
	note ds6 $07
	rest $03
	vol $3
	note ds6 $07
	rest $04
	vol $1
	note ds6 $07
	rest $0e
	duty $01
	vol $6
	note gs3 $0e
	note b3  $0e
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	vol $6
	note gs3 $0e
	note b3  $0e
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	vol $6
	note gs3 $0e
	note b3  $0e
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	vol $6
	note gs3 $0e
	note b3  $0e
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	vol $6
	note gs3 $0e
	note b3  $0e
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	vol $6
	note gs3 $0e
	note b3  $0e
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	duty $02
	vol $6
	note fs6 $07
	rest $03
	vol $3
	note fs6 $04
	vol $6
	note fs6 $07
	note f6  $07
	note fs6 $07
	note f6  $07
	note fs6 $07
	rest $03
	vol $3
	note fs6 $04
	vol $6
	note f6  $07
	rest $03
	vol $3
	note f6  $04
	vol $6
	note fs6 $07
	rest $03
	vol $3
	note fs6 $07
	rest $04
	vol $1
	note fs6 $06
	rest $01
	duty $01
	goto musicf5b5b
	cmdff

sound26Channel4:
musicf5c94:
	duty $0e
	note e3  $05
	duty $0f
	note e3  $0f
	rest $08
	duty $0e
	note b3  $05
	duty $0f
	note b3  $0f
	rest $08
	duty $0e
	note b2  $05
	duty $0f
	note b2  $0f
	rest $08
	duty $0e
	note b3  $05
	duty $0f
	note b3  $0f
	rest $08
	duty $0e
	note e3  $05
	duty $0f
	note e3  $0f
	rest $08
	duty $0e
	note b3  $05
	duty $0f
	note b3  $0f
	rest $08
	duty $0e
	note b2  $05
	duty $0f
	note b2  $0f
	rest $08
	duty $0e
	note b3  $05
	duty $0f
	note b3  $0f
	rest $08
	duty $0e
	note e3  $05
	duty $0f
	note e3  $0f
	rest $08
	duty $0e
	note b3  $05
	duty $0f
	note b3  $0f
	rest $08
	duty $0e
	note b2  $05
	duty $0f
	note b2  $0f
	rest $08
	duty $0e
	note b3  $05
	duty $0f
	note b3  $0f
	rest $08
	duty $0e
	note e3  $15
	duty $0f
	note e3  $07
	duty $0e
	note b2  $07
	duty $0f
	note b2  $07
	duty $0e
	note e3  $15
	duty $0f
	note e3  $07
	duty $0e
	note ds3 $07
	duty $0f
	note ds3 $07
	duty $0e
	note e3  $07
	duty $0f
	note e3  $0e
	rest $07
	duty $0e
	note e3  $05
	duty $0f
	note e3  $0f
	rest $08
	duty $0e
	note b3  $05
	duty $0f
	note b3  $0f
	rest $08
	duty $0e
	note b2  $05
	duty $0f
	note b2  $0f
	rest $08
	duty $0e
	note b3  $05
	duty $0f
	note b3  $0f
	rest $08
	duty $0e
	note e3  $05
	duty $0f
	note e3  $0f
	rest $08
	duty $0e
	note b3  $05
	duty $0f
	note b3  $0f
	rest $08
	duty $0e
	note b2  $05
	duty $0f
	note b2  $0f
	rest $08
	duty $0e
	note b3  $05
	duty $0f
	note b3  $0f
	rest $08
	duty $0e
	note e3  $05
	duty $0f
	note e3  $0f
	rest $08
	duty $0e
	note b3  $05
	duty $0f
	note b3  $0f
	rest $08
	duty $0e
	note b2  $05
	duty $0f
	note b2  $0f
	rest $08
	duty $0e
	note b3  $05
	duty $0f
	note b3  $0f
	rest $08
	duty $0e
	note e3  $15
	duty $0f
	note e3  $07
	duty $0e
	note b2  $07
	duty $0f
	note b2  $07
	duty $0e
	note e3  $1c
	duty $0e
	note b2  $07
	duty $0f
	note b2  $07
	duty $0e
	note e3  $07
	duty $0f
	note e3  $0e
	rest $07
	goto musicf5c94
	cmdff

sound27Channel1:
	vibrato $e1
	env $0 $00
	duty $01
musicf5dde:
	vol $6
	note b4  $2a
	note gs4 $0e
	note e4  $0e
	note b3  $0e
	note c4  $2a
	note e4  $0e
	note g4  $0e
	note c5  $0e
	note b4  $0a
	rest $04
	duty $02
	note b5  $03
	note as5 $04
	note b5  $03
	note as5 $04
	note b5  $03
	rest $04
	vol $3
	note b5  $03
	rest $04
	vol $6
	note b6  $03
	note as6 $04
	note b6  $03
	note as6 $04
	note b6  $03
	rest $04
	vol $3
	note b6  $03
	rest $04
	duty $01
	vol $6
	note b3  $0e
	note c4  $0b
	rest $03
	duty $02
	note c5  $03
	note b4  $04
	note c5  $03
	note b4  $04
	note c5  $03
	rest $04
	vol $3
	note c5  $03
	rest $04
	vol $6
	note c6  $03
	note b5  $04
	note c6  $03
	note b5  $04
	note c6  $03
	rest $04
	vol $3
	note c6  $03
	rest $12
	duty $01
	vol $6
	note b4  $2a
	note gs4 $0e
	note e4  $0e
	note gs4 $0e
	note a4  $07
	note gs4 $07
	note a4  $07
	note gs4 $07
	note a4  $0e
	note b4  $0e
	note c5  $0e
	note a4  $0e
	note b4  $07
	rest $03
	vol $3
	note b4  $04
	vol $6
	note e5  $07
	note ds5 $07
	note e5  $07
	rest $03
	vol $3
	note e5  $04
	vol $6
	note gs4 $07
	rest $03
	vol $3
	note gs4 $04
	vol $6
	note a4  $07
	rest $03
	vol $3
	note a4  $04
	vol $6
	note as4 $07
	rest $03
	vol $3
	note as4 $04
	vol $6
	note b4  $07
	note a4  $07
	note gs4 $07
	note fs4 $07
	note e4  $23
	vibrato $01
	env $0 $00
	vol $3
	note e4  $15
	vibrato $e1
	env $0 $00
	vol $6
	note g4  $38
	note e4  $1c
	note fs4 $07
	rest $03
	vol $3
	note fs4 $04
	duty $02
	vol $6
	note b5  $07
	note as5 $07
	note b5  $07
	rest $03
	vol $3
	note b5  $04
	vol $6
	note b6  $07
	note as6 $07
	note b6  $07
	rest $03
	vol $3
	note b6  $07
	rest $0b
	duty $01
	vol $6
	note g4  $2a
	note e4  $0e
	note c4  $0e
	note g4  $07
	vol $3
	note g4  $07
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $04
	duty $02
	vol $6
	note b4  $03
	note as4 $04
	note b4  $03
	note as4 $04
	note b4  $07
	rest $03
	vol $3
	note b4  $04
	vol $6
	note b5  $03
	note as5 $04
	note b5  $03
	note as5 $04
	note b5  $07
	rest $03
	vol $3
	note b5  $07
	rest $0b
	duty $01
	vol $6
	note ds5 $07
	rest $03
	vol $3
	note ds5 $07
	vol $6
	note cs5 $04
	note ds5 $03
	note cs5 $04
	note b4  $07
	rest $03
	vol $3
	note b4  $07
	rest $19
	vol $6
	note b4  $07
	rest $03
	vol $3
	note b4  $04
	vol $6
	note d5  $07
	rest $03
	vol $3
	note d5  $07
	vol $6
	note c5  $04
	note d5  $03
	note c5  $04
	note b4  $07
	rest $03
	vol $3
	note b4  $07
	rest $19
	vol $6
	note b4  $07
	rest $03
	vol $3
	note b4  $04
	duty $02
	vol $6
	note e5  $07
	rest $03
	vol $3
	note e5  $04
	vol $6
	note ds5 $03
	note e5  $04
	note ds5 $03
	note e5  $04
	note as4 $03
	note b4  $04
	note as4 $03
	note b4  $04
	rest $03
	vol $3
	note b4  $04
	rest $07
	vol $6
	note fs4 $03
	note g4  $04
	note fs4 $03
	note g4  $04
	rest $03
	vol $3
	note g4  $04
	rest $07
	vol $6
	note ds4 $03
	note e4  $04
	note ds4 $03
	note e4  $04
	rest $03
	vol $3
	note e4  $04
	rest $07
	duty $01
	vol $6
	note b3  $0e
	note cs4 $0e
	note d4  $0e
	note ds4 $0e
	goto musicf5dde
	cmdff

sound27Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicf5f9d:
	cmdfd $ff
	vol $0
	note gs3 $bd
	vol $3
	note b5  $03
	note as5 $04
	vol $3
	note b5  $03
	note as5 $04
	vol $3
	note b5  $03
	rest $04
	vol $1
	note b5  $03
	rest $04
	vol $3
	note b6  $03
	note as6 $04
	note b6  $03
	note as6 $04
	vol $3
	note b6  $03
	rest $04
	vol $1
	note b6  $03
	rest $20
	vol $3
	note c5  $03
	note b4  $04
	note c5  $03
	note b4  $04
	note c5  $03
	rest $04
	vol $1
	note c5  $03
	rest $04
	vol $3
	note c6  $03
	note b5  $04
	vol $3
	note c6  $03
	note b5  $04
	note c6  $03
	rest $04
	vol $1
	note c6  $03
	rest $ff
	rest $c5
	vol $3
	note b5  $07
	note as5 $07
	note b5  $07
	rest $03
	vol $1
	note b5  $04
	vol $3
	note b6  $07
	note as6 $07
	note b6  $07
	rest $03
	vol $1
	note b6  $07
	rest $58
	vol $3
	note fs4 $07
	rest $03
	vol $1
	note fs4 $07
	rest $04
	vol $3
	note b4  $03
	note as4 $04
	note b4  $03
	note as4 $04
	note b4  $07
	rest $03
	vol $1
	note b4  $04
	vol $3
	note b5  $03
	note as5 $04
	note b5  $03
	note as5 $04
	note b5  $07
	rest $03
	vol $1
	note b5  $07
	rest $2e
	cmdfd $00
	vol $6
	note cs6 $04
	note ds6 $05
	note cs6 $05
	note b5  $07
	rest $03
	vol $3
	note b5  $07
	rest $04
	vol $1
	note b5  $07
	rest $2a
	vol $6
	note c6  $04
	note d6  $05
	note c6  $05
	note b5  $07
	rest $03
	vol $3
	note b5  $07
	rest $04
	vol $1
	note b5  $07
	rest $15
	vol $3
	note ds5 $03
	note e5  $04
	note ds5 $03
	note e5  $04
	note as4 $03
	note b4  $04
	note as4 $03
	note b4  $04
	rest $03
	vol $1
	note b4  $04
	rest $07
	vol $3
	note fs4 $03
	note g4  $04
	note fs4 $03
	note g4  $04
	rest $03
	vol $1
	note g4  $04
	rest $07
	vol $3
	note ds4 $03
	note e4  $04
	note ds4 $03
	note e4  $04
	rest $03
	vol $1
	note e4  $04
	rest $38
	goto musicf5f9d
	cmdff

sound27Channel4:
musicf609e:
	duty $0e
	note e3  $1c
	duty $0e
	note b3  $07
	duty $0f
	note b3  $07
	rest $0e
	duty $0e
	note b3  $07
	duty $0f
	note b3  $07
	rest $0e
	duty $0e
	note f3  $1c
	duty $0e
	note a3  $07
	duty $0f
	note a3  $07
	rest $0e
	duty $0e
	note a3  $07
	duty $0f
	note a3  $07
	rest $0e
	duty $0e
	note e3  $1c
	duty $0f
	note e3  $0e
	rest $2a
	duty $0e
	note b2  $1c
	duty $0f
	note b2  $0e
	rest $2a
	duty $0e
	note e3  $1c
	duty $0e
	note b3  $07
	duty $0f
	note b3  $07
	rest $0e
	duty $0e
	note b3  $07
	duty $0f
	note b3  $07
	rest $0e
	duty $0e
	note f3  $1c
	note a3  $07
	duty $0f
	note a3  $07
	rest $0e
	duty $0e
	note a3  $07
	duty $0f
	note a3  $07
	rest $0e
	duty $0e
	note b2  $15
	duty $0f
	note b2  $0a
	rest $35
	duty $0e
	note b2  $0e
	note cs3 $07
	note ds3 $07
	note e3  $0e
	note b2  $0e
	note gs2 $0e
	note e2  $0e
	duty $0f
	note e2  $07
	rest $15
	duty $0e
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $0e
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $0e
	note b2  $07
	duty $0f
	note b2  $07
	rest $46
	duty $0e
	note c3  $1c
	note e3  $1c
	note g3  $1c
	note b2  $0e
	duty $0f
	note b2  $07
	rest $3f
	duty $0e
	note fs3 $38
	note b2  $07
	duty $0f
	note b2  $07
	rest $0e
	duty $0e
	note f3  $38
	duty $0e
	note b2  $07
	duty $0f
	note b2  $07
	rest $0e
	duty $0e
	note e3  $07
	duty $0f
	note e3  $07
	rest $46
	duty $0e
	note b2  $54
	goto musicf609e
	cmdff

sound1dStart:

sound1dChannel1:
	vibrato $e1
	env $0 $00
	duty $02
	vol $8
	note b2  $03
	vol $8
	note e3  $04
	note f3  $03
	note b3  $04
	note b3  $03
	vol $7
	note e4  $04
	note f4  $03
	note b4  $04
	vol $8
	note b4  $03
	vol $8
	note e5  $04
	note f5  $03
	note b5  $04
	note b5  $03
	vol $7
	note e6  $04
	note f6  $03
	note b6  $2c
	rest $02
	vol $5
	note b6  $02
	rest $02
	vol $4
	note b6  $03
	rest $02
	vol $4
	note b6  $02
	rest $03
musicf61c7:
	vol $7
	note f4  $0e
	note gs4 $0e
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $7
	note b4  $2a
	note gs4 $0e
	note f4  $0e
	note ds5 $07
	rest $03
	vol $3
	note ds5 $04
	vol $7
	note d5  $46
	vibrato $01
	env $0 $00
	vol $3
	note d5  $0e
	vibrato $e1
	env $0 $00
	vol $7
	note cs5 $0e
	note c5  $0e
	note b4  $0e
	note as4 $0e
	note gs4 $0e
	note g4  $1c
	vibrato $01
	env $0 $00
	vol $3
	note g4  $0e
	vibrato $e1
	env $0 $00
	vol $8
	note f4  $0e
	vol $8
	note g4  $04
	note gs4 $05
	note g4  $4b
	vibrato $01
	env $0 $00
	vol $4
	note g4  $0e
	vibrato $e1
	env $0 $00
	vol $8
	note f4  $0e
	note g4  $0e
	note f4  $0e
	note b3  $54
	vibrato $01
	env $0 $00
	vol $4
	note b3  $0e
	vibrato $e1
	env $0 $00
	vol $8
	note c4  $0e
	note d4  $0e
	note e4  $0e
	note f4  $0e
	note g4  $0e
	note gs4 $0e
	note as4 $0e
	vol $8
	note b4  $04
	note c5  $05
	note b4  $2f
	vibrato $01
	env $0 $00
	vol $4
	note b4  $0e
	vibrato $e1
	env $0 $00
	vol $8
	note gs4 $0e
	note g4  $0e
	note f4  $0e
	note e4  $07
	rest $03
	vol $4
	note e4  $04
	vol $8
	note g4  $46
	vibrato $01
	env $0 $00
	vol $4
	note g4  $1c
	vibrato $e1
	env $0 $00
	vol $8
	note f4  $0e
	note c4  $07
	note f4  $07
	note c4  $07
	note f4  $07
	note c4  $07
	rest $07
	vol $5
	note f4  $0e
	note c4  $07
	note f4  $07
	note c4  $07
	note f4  $07
	note c4  $07
	rest $07
	vol $8
	note e4  $0e
	note b3  $07
	note e4  $07
	note b3  $07
	note e4  $07
	note b3  $07
	rest $07
	vol $5
	note e4  $0e
	note b3  $07
	note e4  $07
	note b3  $07
	note e4  $07
	note b3  $07
	rest $07
	vol $8
	note f4  $0e
	note c4  $07
	note f4  $07
	note c4  $07
	note f4  $07
	vol $8
	note b4  $03
	vol $8
	note c5  $27
	vibrato $01
	env $0 $00
	vol $4
	note c5  $0e
	vibrato $e1
	env $0 $00
	vol $8
	note as4 $07
	note c5  $07
	note cs5 $0e
	note c5  $0e
	note as4 $0e
	note gs4 $0e
	note fs4 $0e
	vol $4
	note fs4 $0e
	vol $8
	note cs5 $0e
	vol $4
	note cs5 $0e
	vol $8
	note c5  $0e
	note f4  $07
	note c5  $07
	note f4  $07
	note c5  $07
	note f4  $07
	rest $07
	vol $5
	note c5  $0e
	note f4  $07
	note c5  $07
	note f4  $07
	note c5  $07
	note f4  $07
	rest $07
	vol $8
	note b4  $0e
	note e4  $07
	note b4  $07
	note e4  $07
	note b4  $07
	note e4  $07
	rest $07
	vol $5
	note b4  $0e
	note e4  $07
	note b4  $07
	note e4  $07
	note b4  $07
	note e4  $07
	rest $07
	vol $8
	note a4  $0e
	note d4  $07
	note f4  $07
	note d4  $07
	note f4  $07
	note d4  $0e
	vol $4
	note d4  $0e
	rest $1c
	vol $8
	note f5  $0e
	note fs5 $07
	rest $07
	vol $4
	note f5  $0e
	note fs5 $07
	rest $07
	vol $2
	note f5  $0e
	note fs5 $07
	rest $07
	vol $1
	note f5  $0e
	note fs5 $07
	rest $85
	goto musicf61c7
	cmdff

sound1dChannel0:
	vol $0
	note gs3 $09
	vibrato $e1
	env $0 $00
	duty $02
	vol $4
	note b2  $03
	note e3  $04
	note f3  $03
	note b3  $04
	note b3  $03
	note e4  $04
	note f4  $03
	note b4  $04
	note b4  $03
	note e5  $04
	note f5  $03
	note b5  $04
	note b5  $03
	note e6  $04
	note f6  $03
	note b6  $04
	rest $2f
musicf6377:
	vol $8
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note d3  $0e
	note ds3 $0e
	note d3  $0e
	note ds3 $0e
	note d3  $0e
	note ds3 $0e
	note cs3 $0e
	note d3  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note gs2 $0e
	note gs2 $0e
	note a2  $0e
	note a2  $0e
	note as2 $0e
	vol $8
	note gs3 $2a
	vol $4
	note gs3 $0e
	vol $8
	note gs3 $07
	rest $03
	vol $4
	note gs3 $04
	vol $8
	note gs3 $0e
	note c4  $0e
	note gs3 $0e
	note g3  $2a
	vol $4
	note g3  $0e
	vol $8
	note g3  $07
	rest $03
	vol $4
	note g3  $04
	vol $8
	note g3  $0e
	note as3 $0e
	note g3  $0e
	note gs3 $2a
	vol $4
	note gs3 $0e
	vol $8
	note gs3 $07
	rest $03
	vol $4
	note gs3 $04
	vol $8
	note gs3 $0e
	note c4  $0e
	note gs3 $0e
	note as3 $1c
	note b3  $1c
	note c4  $1c
	note d4  $0e
	note e4  $0e
	note f4  $07
	rest $03
	vol $4
	note f4  $07
	rest $04
	vol $2
	note f4  $07
	vol $8
	note gs3 $1c
	vol $4
	note gs3 $0e
	vol $8
	note c4  $0e
	note f4  $0e
	note gs4 $0e
	note g4  $07
	rest $03
	vol $4
	note g4  $07
	rest $04
	vol $2
	note g4  $07
	vol $8
	note g3  $1c
	vol $4
	note g3  $0e
	vol $8
	note b3  $0e
	note e4  $0e
	note g4  $0e
	note f3  $2a
	vol $4
	note f3  $0e
	vol $8
	note a3  $0e
	note d4  $0e
	note f4  $0e
	note a4  $0e
	note as4 $07
	rest $03
	vol $4
	note as4 $07
	rest $04
	vol $2
	note as4 $07
	rest $03
	vol $1
	note as4 $07
	rest $20
	vol $8
	note cs4 $0e
	note c4  $0e
	note b3  $0e
	vol $4
	note b3  $0e
	vol $8
	note b3  $0e
	note as3 $0e
	note a3  $0e
	vol $4
	note a3  $0e
	vol $8
	note a3  $0e
	note gs3 $0e
	note g3  $0e
	goto musicf6377
	cmdff

sound1dChannel4:
	duty $0e
	note b1  $70
musicf64b5:
	duty $01
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note gs2 $0e
	note fs2 $0e
	note g2  $0e
	note c2  $0e
	note cs2 $0e
	note c2  $0e
	note cs2 $0e
	note d2  $0e
	note ds2 $0e
	note e2  $0e
	note f2  $0e
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $15
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $15
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note g2  $07
	duty $0f
	note g2  $07
	duty $0e
	note g2  $15
	duty $0f
	note g2  $07
	duty $0e
	note g2  $07
	duty $0f
	note g2  $07
	duty $0e
	note c3  $07
	duty $0f
	note c3  $07
	duty $0e
	note c3  $15
	duty $0f
	note c3  $07
	duty $0e
	note c3  $07
	duty $0f
	note c3  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $15
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $15
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	duty $0e
	note d2  $07
	duty $0f
	note d2  $15
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	duty $0e
	note d2  $15
	duty $0f
	note d2  $07
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	duty $0e
	note c3  $07
	duty $0f
	note c3  $0e
	rest $07
	duty $0e
	note c2  $54
	duty $0f
	note c2  $0c
	rest $64
	goto musicf64b5
	cmdff

sound1dChannel6:
	rest $70
musicf66a1:
	vol $5
	note $26 $2a
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $0e
	note $26 $1c
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $2a
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $0e
	note $26 $1c
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $2a
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $0e
	note $26 $1c
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $2a
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $0e
	note $26 $1c
	note $26 $07
	note $26 $07
	note $26 $0e
	note $26 $0e
	note $26 $07
	note $26 $07
	note $26 $07
	note $26 $07
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $3
	note $2e $46
	vol $5
	note $26 $0e
	vol $4
	note $26 $2a
	vol $5
	note $26 $0e
	vol $4
	note $26 $2a
	vol $5
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	goto musicf66a1
	cmdff

sound46Channel1:
	vibrato $00
	env $0 $00
	duty $01
musicf685b:
	vol $6
	note b3  $2c
	note cs4 $42
	vol $3
	note cs4 $16
	vol $6
	note cs4 $2c
	note ds4 $42
	vol $3
	note ds4 $16
	vol $6
	note ds4 $2c
	note e4  $2c
	note g4  $2c
	note as4 $2c
	note cs5 $2c
	note e5  $2c
	note g5  $2c
	vol $6
	note as5 $03
	rest $03
	note d6  $05
	vol $4
	note as5 $03
	vol $6
	note as5 $03
	vol $4
	note d6  $05
	rest $03
	note as5 $03
	vol $6
	note as5 $05
	rest $07
	vol $4
	note as5 $04
	vol $6
	note as5 $03
	rest $03
	note d6  $05
	vol $4
	note as5 $03
	vol $6
	note as5 $03
	vol $4
	note d6  $05
	rest $03
	note as5 $03
	vol $6
	note as5 $05
	rest $07
	vol $4
	note as5 $04
	vol $6
	note as5 $03
	rest $03
	note d6  $05
	vol $4
	note as5 $03
	vol $6
	note as5 $03
	vol $4
	note d6  $05
	rest $03
	note as5 $03
	vol $6
	note as5 $05
	rest $07
	vol $4
	note as5 $04
	vol $6
	note as5 $03
	rest $03
	note d6  $05
	vol $4
	note as5 $03
	vol $6
	note as5 $03
	vol $4
	note d6  $05
	rest $03
	note as5 $03
	vol $6
	note as5 $05
	rest $07
	vol $4
	note as5 $04
	vol $6
	note d6  $0b
	note f6  $0b
	note gs6 $0b
	note c7  $0b
	rest $58
	vol $6
	note cs4 $2c
	note ds4 $42
	vol $3
	note ds4 $16
	vol $6
	note ds4 $2c
	note f4  $42
	vol $3
	note f4  $16
	vol $6
	note f4  $2c
	vol $6
	note fs4 $2c
	note a4  $2c
	note c5  $2c
	note ds5 $2c
	note fs5 $2c
	note a5  $2c
	note c6  $03
	rest $03
	note e6  $05
	vol $4
	note c6  $03
	vol $6
	note c6  $03
	vol $4
	note e6  $05
	rest $03
	note c6  $03
	vol $6
	note c6  $05
	rest $07
	vol $4
	note c6  $04
	vol $6
	note c6  $03
	rest $03
	note e6  $05
	vol $4
	note c6  $03
	vol $6
	note c6  $03
	vol $4
	note e6  $05
	rest $03
	note c6  $03
	vol $6
	note c6  $05
	rest $07
	vol $4
	note c6  $04
	vol $6
	note c6  $03
	rest $03
	note e6  $05
	vol $4
	note c6  $03
	vol $6
	note c6  $03
	vol $4
	note e6  $05
	rest $03
	note c6  $03
	vol $6
	note c6  $05
	rest $07
	vol $4
	note c6  $04
	vol $6
	note c6  $03
	rest $03
	note e6  $05
	vol $3
	note c6  $03
	vol $6
	note c6  $03
	vol $3
	note e6  $05
	rest $03
	note c6  $03
	vol $6
	note c6  $05
	rest $07
	vol $3
	note c6  $04
	vol $6
	note e6  $0b
	note g6  $0b
	note as6 $0b
	note c7  $0b
	rest $58
	goto musicf685b
	cmdff

sound46Channel0:
	vibrato $00
	env $0 $00
	duty $01
musicf6999:
	vol $7
	note fs3 $2c
	note gs3 $4d
	vol $3
	note gs3 $0b
	vol $7
	note gs3 $2c
	note as3 $4d
	vol $3
	note as3 $0b
	vol $7
	note as3 $2c
	note b3  $2c
	note d4  $2c
	note f4  $2c
	note gs4 $2c
	note b4  $2c
	note d5  $2c
	note e5  $b0
	rest $10
	vol $3
	note d6  $0b
	note f6  $0b
	note gs6 $0b
	note c7  $0b
	rest $48
	vol $6
	note gs3 $2c
	note as3 $4d
	vol $3
	note as3 $0b
	vol $6
	note as3 $2c
	note c4  $4d
	vol $3
	note c4  $0b
	vol $6
	note c4  $2c
	note cs4 $2c
	note e4  $2c
	note g4  $2c
	note as4 $2c
	note cs5 $2c
	note e5  $2c
	note fs5 $b0
	rest $10
	vol $3
	note e6  $0b
	note g6  $0b
	note as6 $0b
	note c7  $0b
	rest $48
	goto musicf6999
	cmdff

sound46Channel4:
musicf69f9:
	duty $0e
	note g2  $2c
	note a2  $42
	rest $16
	note a2  $2c
	note b2  $42
	rest $16
	note b2  $2c
	note c3  $2c
	note e3  $2c
	note g3  $2c
	note as3 $2c
	note cs4 $2c
	note e4  $2c
	note g4  $b0
	rest $84
	note a2  $2c
	note b2  $42
	rest $16
	note b2  $2c
	note cs3 $42
	rest $16
	note cs3 $2c
	note d3  $2c
	note fs3 $2c
	note a3  $2c
	note c4  $2c
	note ds4 $2c
	note fs4 $2c
	note a4  $b0
	rest $84
	goto musicf69f9
	cmdff

sound38Channel1:
musicf6a3b:
	vibrato $f1
	env $0 $00
	duty $02
	vol $6
	note as4 $0b
	note c5  $0b
	note cs5 $0b
	note ds5 $0b
	note f5  $2c
	note ds5 $16
	note gs5 $16
	note as5 $0b
	rest $05
	vol $3
	note as5 $06
	vol $6
	note f5  $0b
	note ds5 $0b
	note f5  $2c
	note ds5 $16
	note gs5 $16
	note c6  $03
	note cs6 $03
	note c6  $10
	note as5 $0b
	note gs5 $0b
	note f5  $0b
	rest $05
	vol $3
	note f5  $06
	vol $6
	note as5 $0b
	note gs5 $0b
	note f5  $16
	note ds5 $0b
	note cs5 $0b
	note as4 $0b
	rest $05
	vol $3
	note as4 $06
	vol $6
	note f5  $0b
	note ds5 $0b
	note f5  $2c
	vibrato $01
	env $0 $00
	vol $3
	note f5  $16
	vibrato $f1
	env $0 $00
	vol $6
	note as5 $0b
	rest $05
	vol $3
	note as5 $06
	vol $6
	note c6  $0b
	note cs6 $0b
	note ds6 $0b
	rest $05
	vol $3
	note ds6 $06
	vol $6
	note ds6 $21
	note c6  $0b
	note f6  $0b
	note ds6 $03
	note f6  $03
	note ds6 $05
	note cs6 $0b
	note c6  $0b
	note as5 $2c
	vibrato $01
	env $0 $00
	vol $3
	note as5 $0b
	vibrato $f1
	env $0 $00
	vol $6
	note c6  $0b
	note cs6 $0b
	note f6  $0b
	note g6  $0b
	note gs6 $05
	note g6  $06
	note f6  $0b
	note ds6 $0b
	note f6  $2c
	note ds6 $05
	rest $01
	vol $4
	note ds6 $07
	rest $01
	vol $3
	note ds6 $05
	rest $03
	vol $6
	note cs6 $05
	rest $01
	vol $4
	note cs6 $07
	rest $01
	vol $3
	note cs6 $05
	rest $03
	vol $6
	note c6  $05
	rest $01
	vol $4
	note c6  $07
	rest $01
	vol $3
	note c6  $05
	rest $03
	vol $6
	note as5 $05
	rest $01
	vol $3
	note as5 $07
	rest $01
	vol $3
	note as5 $05
	rest $03
	vol $6
	note as4 $16
	note f5  $16
	note ds5 $16
	note f5  $0b
	note fs5 $0b
	note gs5 $16
	vibrato $01
	env $0 $00
	vol $3
	note gs5 $16
	vol $1
	note gs5 $0b
	rest $0b
	vibrato $f1
	env $0 $00
	vol $6
	note as5 $16
	note f6  $0b
	rest $05
	vol $3
	note f6  $06
	vol $6
	note ds6 $0b
	note cs6 $0b
	note c6  $16
	note cs6 $16
	note c6  $16
	note as5 $0b
	note gs5 $0b
	note f5  $0b
	rest $05
	vol $3
	note f5  $06
	vol $6
	note as5 $0b
	note gs5 $0b
	note f5  $07
	rest $04
	note f5  $0b
	note ds5 $0b
	note cs5 $0b
	note as4 $05
	rest $01
	vol $5
	note as4 $07
	rest $01
	vol $4
	note as4 $05
	rest $03
	vol $6
	note f5  $05
	rest $01
	vol $4
	note f5  $07
	rest $01
	vol $3
	note f5  $05
	rest $03
	vol $6
	note as5 $05
	rest $06
	vol $5
	note as5 $05
	rest $06
	vol $4
	note as5 $05
	rest $27
	vol $6
	note as5 $0b
	note c6  $0b
	note cs6 $0b
	note ds6 $0b
	note f6  $0b
	rest $05
	vol $3
	note f6  $06
	vol $6
	note ds6 $0b
	note cs6 $0b
	note c6  $0b
	note as5 $0b
	note c6  $0b
	note as5 $0b
	note gs5 $0b
	note f5  $0b
	rest $05
	vol $3
	note f5  $0b
	rest $06
	vol $6
	note as5 $0b
	rest $05
	vol $3
	note as5 $06
	vol $6
	note f5  $16
	note ds6 $0b
	note cs6 $0b
	note c6  $0b
	note cs6 $05
	note c6  $06
	note as5 $0b
	note gs5 $0b
	note as5 $16
	note ds5 $0b
	note f5  $0b
	note ds5 $16
	note cs5 $07
	note ds5 $07
	note cs5 $08
	note c5  $07
	note cs5 $07
	note c5  $08
	note gs4 $07
	note as4 $07
	note gs4 $08
	note as4 $05
	rest $01
	vol $4
	note as4 $07
	rest $09
	vol $6
	note ds5 $05
	rest $01
	vol $4
	note ds5 $07
	rest $09
	vol $6
	note as5 $05
	rest $01
	vol $4
	note as5 $07
	rest $01
	vol $2
	note as5 $05
	rest $45
	goto musicf6a3b
	cmdff

sound38Channel0:
musicf6c10:
	vibrato $00
	env $0 $04
	duty $02
	vol $6
	note as3 $16
	note f4  $16
	note gs4 $16
	note f4  $16
	note c4  $16
	note f4  $16
	note cs4 $16
	note f4  $16
	note as4 $16
	note f4  $16
	note c4  $16
	note g4  $16
	note as3 $16
	note f4  $16
	note gs4 $16
	note f4  $16
	note gs3 $16
	note gs4 $16
	note fs3 $16
	note f4  $16
	note as4 $16
	note f4  $16
	note fs3 $16
	note f4  $16
	note f3  $16
	note gs4 $16
	note c5  $16
	note gs4 $16
	note f3  $16
	note gs4 $16
	note as3 $16
	note f4  $16
	note gs4 $16
	note cs4 $16
	note ds4 $16
	note cs4 $0b
	note c4  $0b
	note as3 $0b
	note c4  $0b
	note cs4 $0b
	note f4  $0b
	note as4 $16
	note f4  $16
	note g4  $16
	vol $6
	note f4  $0b
	note ds4 $0b
	vibrato $f1
	env $0 $00
	note fs4 $2c
	note f3  $58
	rest $16
	note fs3 $16
	note f3  $4d
	rest $0b
	note fs3 $2c
	note gs3 $2c
	note fs3 $2c
	note g3  $16
	note gs3 $0b
	rest $0b
	note gs3 $16
	vol $6
	note as3 $0b
	rest $0b
	note as3 $16
	note c4  $0b
	rest $0b
	note cs4 $16
	note as3 $16
	note c4  $16
	note ds4 $16
	note f4  $16
	note c4  $16
	note cs4 $16
	note f4  $16
	note as4 $16
	note f4  $16
	note ds4 $16
	note gs4 $16
	note f4  $16
	note gs4 $16
	note g4  $16
	note ds4 $16
	note f4  $16
	note cs4 $16
	note ds4 $16
	note as3 $16
	note as3 $16
	note c4  $0b
	note cs4 $0b
	note c4  $16
	note gs3 $16
	goto musicf6c10
	cmdff

sound38Channel4:
musicf6cd3:
	duty $0f
	rest $0b
	note as4 $0b
	note c5  $0b
	note cs5 $0b
	note ds5 $0b
	note f5  $2c
	note ds5 $16
	note gs5 $16
	note as5 $0b
	rest $0b
	note f5  $0b
	note ds5 $0b
	note f5  $2c
	note ds5 $16
	note gs5 $16
	note c6  $03
	note cs6 $03
	note c6  $10
	note as5 $0b
	note gs5 $0b
	note f5  $0b
	rest $0b
	note as5 $0b
	note gs5 $0b
	note f5  $16
	note ds5 $0b
	note cs5 $0b
	note as4 $0b
	rest $0b
	note f5  $0b
	note ds5 $0b
	note f5  $2c
	rest $16
	note as5 $0b
	rest $0b
	note c6  $0b
	note cs6 $0b
	note ds6 $0b
	rest $0b
	note ds6 $21
	note c6  $0b
	note f6  $0b
	note ds6 $03
	note f6  $03
	note ds6 $05
	note cs6 $0b
	note c6  $0b
	note as5 $2c
	note as5 $0b
	note c6  $0b
	note cs6 $0b
	note f6  $0b
	note g6  $0b
	note gs6 $05
	note g6  $06
	note f6  $0b
	note ds6 $0b
	note f6  $2c
	rest $4d
	duty $0e
	note cs3 $2c
	note c3  $16
	note ds3 $16
	note f3  $16
	note c3  $16
	rest $16
	note cs3 $16
	note c3  $16
	note c3  $16
	note f3  $16
	note c3  $16
	note cs3 $2c
	note c3  $2c
	note as2 $2c
	note ds3 $2c
	note as2 $2c
	note ds3 $16
	duty $0f
	note ds3 $0b
	rest $0b
	duty $0e
	note fs3 $2c
	note gs3 $58
	duty $0f
	note gs3 $16
	duty $0e
	note fs3 $16
	note gs3 $26
	duty $0f
	note gs3 $06
	duty $0e
	note gs3 $2c
	note as3 $2c
	note gs3 $2c
	note fs3 $2c
	note ds3 $58
	duty $0f
	note ds3 $16
	rest $16
	goto musicf6cd3
	cmdff

sound2bStart:

sound2bChannel1:
	vibrato $e1
	env $0 $00
	duty $02
	vol $6
	note fs2 $0e
	note g2  $03
	rest $01
	vol $3
	note g2  $04
	rest $01
	vol $1
	note g2  $05
	vol $6
	note fs3 $0e
	note g3  $03
	rest $01
	vol $3
	note g3  $04
	rest $01
	vol $1
	note g3  $05
	vol $6
	note fs4 $0e
	note g4  $03
	rest $01
	vol $3
	note g4  $04
	rest $01
	vol $1
	note g4  $05
	vol $6
	note fs5 $0e
	note g5  $03
	rest $01
	vol $3
	note g5  $04
	rest $01
	vol $1
	note g5  $05
	vol $6
	note fs3 $04
	note g3  $05
	note c4  $05
	note as3 $46
	vibrato $01
	env $0 $00
	vol $3
	note as3 $1c
	vol $1
	note as3 $0e
	rest $0e
	vibrato $e1
	env $0 $00
musicf6dfa:
	vol $6
	note c5  $09
	rest $07
	vol $3
	note c5  $09
	rest $03
	vol $6
	note c5  $09
	rest $05
	vol $3
	note c5  $04
	vol $6
	note c5  $0a
	note g5  $09
	rest $07
	vol $3
	note g5  $09
	rest $03
	vol $6
	note g5  $12
	rest $05
	note g5  $02
	note a5  $03
	note as5 $12
	note a5  $0a
	note g5  $12
	note f5  $0a
	note g5  $38
	vibrato $01
	env $0 $00
	vol $3
	note g5  $12
	vibrato $f1
	env $0 $00
	vol $6
	note c6  $05
	vol $3
	note c6  $05
	vol $6
	note c6  $0e
	vol $3
	note c6  $04
	vol $6
	note c6  $0a
	note g5  $09
	rest $09
	vol $3
	note g5  $0a
	vol $6
	note g5  $12
	note a5  $0a
	note as5 $12
	note a5  $0a
	note g5  $12
	note f5  $0a
	note e5  $12
	note f5  $0a
	note fs5 $12
	note g5  $0a
	note e5  $09
	rest $0e
	vol $3
	note e5  $05
	vol $6
	note c5  $09
	rest $0e
	vol $3
	note c5  $05
	vol $6
	note as4 $09
	rest $0e
	vol $3
	note as4 $05
	rest $12
	vol $6
	note e5  $13
	vol $3
	note e5  $09
	vol $6
	note e5  $0a
	note c5  $09
	rest $0e
	vol $3
	note c5  $05
	vol $6
	note as4 $09
	rest $0e
	vol $3
	note as4 $05
	rest $1c
	vol $6
	note e5  $09
	rest $0e
	vol $3
	note e5  $05
	vol $6
	note c5  $09
	rest $0e
	vol $3
	note c5  $05
	vol $6
	note as4 $09
	rest $0e
	vol $3
	note as4 $05
	vol $6
	note g4  $38
	vibrato $01
	env $0 $00
	vol $3
	note g4  $38
	rest $1c
	vibrato $f1
	env $0 $00
	vol $6
	note e5  $09
	rest $0e
	vol $3
	note e5  $05
	vol $6
	note c5  $09
	rest $0e
	vol $3
	note c5  $05
	vol $6
	note as4 $09
	rest $0e
	vol $3
	note as4 $05
	rest $12
	vol $6
	note e5  $13
	vol $3
	note e5  $09
	vol $6
	note e5  $0a
	note c5  $09
	rest $0e
	vol $3
	note c5  $05
	vol $6
	note as4 $09
	rest $0e
	vol $3
	note as4 $05
	rest $1c
	vol $6
	note e5  $09
	rest $0e
	vol $3
	note e5  $05
	vol $6
	note c5  $09
	rest $0e
	vol $3
	note c5  $05
	vol $6
	note as5 $12
	note a5  $0a
	rest $09
	vol $3
	note a5  $09
	vol $6
	note g5  $54
	vibrato $01
	env $0 $00
	vol $3
	note g5  $1c
	vol $1
	note g5  $09
	rest $01
	vibrato $f1
	env $0 $00
	goto musicf6dfa
	cmdff

sound2bChannel0:
	vibrato $e1
	env $0 $00
	duty $02
	vol $6
	note cs2 $0e
	note c2  $03
	rest $01
	vol $3
	note c2  $04
	rest $01
	vol $1
	note c2  $05
	vol $6
	note cs3 $0e
	note c3  $03
	rest $01
	vol $3
	note c3  $04
	rest $01
	vol $1
	note c3  $05
	vol $6
	note cs4 $0e
	note c4  $03
	rest $01
	vol $3
	note c4  $04
	rest $01
	vol $1
	note c4  $05
	vol $6
	note cs5 $0e
	note c5  $03
	rest $01
	vol $3
	note c5  $04
	rest $01
	vol $1
	note c5  $05
	vol $6
	note fs2 $04
	note g2  $05
	note c3  $05
	note as2 $46
	vibrato $01
	env $0 $00
	vol $3
	note as2 $1c
	vol $1
	note as2 $0e
	rest $0e
	vibrato $f1
	env $0 $00
musicf6f7c:
	rest $ff
	rest $47
	vol $6
	note fs3 $0a
	note g3  $12
	note fs3 $0a
	note g3  $12
	note fs3 $0a
	note g3  $0e
	rest $04
	note f3  $0a
	note e3  $12
	note d3  $0a
	note c3  $09
	rest $48
	vol $6
	note fs3 $03
	note g3  $07
	rest $04
	vol $3
	note fs3 $03
	note g3  $07
	rest $04
	vol $1
	note fs3 $03
	note g3  $07
	rest $41
	vol $6
	note fs3 $02
	note g3  $07
	note fs3 $03
	note g3  $07
	rest $04
	vol $3
	note fs3 $03
	note g3  $07
	rest $04
	vol $1
	note fs3 $03
	note g3  $07
	rest $72
	vol $6
	note b2  $09
	note ds3 $0a
	note g3  $09
	note b3  $09
	note ds4 $0a
	note g4  $2a
	note f4  $04
	note e4  $05
	note d4  $05
	note c4  $09
	rest $48
	note fs3 $03
	note g3  $07
	rest $04
	vol $3
	note fs3 $03
	note g3  $07
	rest $04
	vol $1
	note fs3 $03
	note g3  $07
	rest $41
	vol $6
	note fs4 $02
	note g4  $07
	note fs4 $03
	note g4  $07
	rest $04
	vol $3
	note fs4 $03
	note g4  $07
	rest $04
	vol $1
	note fs4 $03
	note g4  $07
	rest $d9
	goto musicf6f7c
	cmdff

sound2bChannel4:
	rest $ee
	duty $0e
	note g2  $03
	note f2  $04
	note ds2 $03
	note cs2 $04
musicf701b:
	duty $0e
	note c2  $07
	duty $0f
	note c2  $0e
	rest $23
	duty $0e
	note g2  $07
	duty $0f
	note g2  $0e
	rest $23
	duty $0e
	note as1 $07
	duty $0f
	note as1 $0e
	rest $23
	duty $0e
	note f2  $07
	duty $0f
	note f2  $0e
	rest $23
	duty $0e
	note c2  $07
	duty $0f
	note c2  $0e
	rest $23
	duty $0e
	note g2  $07
	duty $0f
	note g2  $0e
	rest $23
	duty $0e
	note d2  $07
	duty $0f
	note d2  $0e
	rest $35
	duty $0e
	note g2  $0a
	duty $0e
	note a2  $09
	duty $0f
	note a2  $09
	duty $0e
	note b2  $0a
	duty $0e
	note c2  $1c
	duty $0f
	note c2  $0e
	rest $0e
	duty $0e
	note g2  $07
	duty $0f
	note g2  $0e
	rest $23
	duty $0e
	note as2 $07
	duty $0f
	note as2 $0e
	rest $23
	duty $0e
	note f2  $07
	duty $0f
	note f2  $0e
	rest $23
	duty $0e
	note c3  $07
	duty $0f
	note c3  $0e
	rest $23
	duty $0e
	note as2 $07
	duty $0f
	note as2 $0e
	rest $07
	duty $0e
	note g2  $0e
	note g1  $04
	note b1  $05
	note ds2 $05
	duty $0e
	note g2  $38
	note fs2 $02
	duty $0e
	note g2  $07
	duty $0f
	note g2  $0e
	rest $21
	duty $0e
	note c3  $07
	duty $0f
	note c3  $0e
	rest $23
	duty $0e
	note g2  $07
	duty $0f
	note g2  $0e
	rest $23
	duty $0e
	note as2 $07
	duty $0f
	note as2 $0e
	rest $23
	duty $0e
	note f2  $07
	duty $0f
	note f2  $0e
	rest $23
	duty $0e
	note c3  $07
	duty $0f
	note c3  $0e
	rest $07
	duty $0e
	note c3  $07
	duty $0f
	note c3  $0e
	rest $07
	duty $0e
	note as2 $07
	duty $0f
	note as2 $0e
	rest $07
	duty $0e
	note g2  $2e
	note gs2 $0a
	note as2 $12
	note b2  $0a
	note cs3 $12
	note ds3 $0a
	note f3  $12
	note g3  $0a
	goto musicf701b
	cmdff

sound2bChannel6:
	rest $fc
musicf7125:
	vol $2
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	note $2e $12
	note $2a $0a
	note $2a $12
	note $2a $0a
	vol $2
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	note $2e $09
	rest $09
	note $2a $0a
	note $2a $12
	note $2a $0a
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	vol $2
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	vol $2
	note $2e $1c
	note $2a $1c
	note $2a $1c
	vol $2
	note $2e $1c
	rest $70
	vol $2
	note $2e $1c
	note $2a $1c
	vol $3
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	note $2e $1c
	vol $3
	note $2a $1c
	note $2e $1c
	note $2a $1c
	note $2a $1c
	note $2e $1c
	rest $70
	goto musicf7125
	cmdff

sound3fStart:

sound3fChannel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
	vol $5
	note d4  $2a
	vol $3
	note d4  $0e
	vol $5
	note g4  $54
	vibrato $01
	env $0 $00
	vol $3
	note g4  $1c
	vibrato $e1
	env $0 $00
	vol $5
	note d4  $1c
	note g4  $1c
	note f4  $0e
	note e4  $0e
	note f4  $1c
	note c4  $38
	vibrato $01
	env $0 $00
	vol $3
	note c4  $1c
	vibrato $e1
	env $0 $00
	vol $6
	note c4  $1c
	note f4  $1c
	note as4 $1c
	note gs4 $0e
	note fs4 $0e
	note gs4 $1c
	note ds4 $38
	vibrato $01
	env $0 $00
	vol $3
	note ds4 $1c
	vibrato $e1
	env $0 $00
	vol $6
	note ds4 $1c
	note gs4 $1c
	note cs5 $1c
	note b4  $0e
	note as4 $0e
	note b4  $1c
	note fs4 $38
	vibrato $01
	env $0 $00
	vol $4
	note fs4 $1c
	vibrato $e1
	env $0 $00
	vol $7
	note fs4 $1c
	vol $6
	note b4  $1c
	vol $9
	note e5  $1c
	vol $4
	note e5  $07
	rest $03
	vol $3
	note e5  $07
	rest $04
	vol $2
	note e5  $07
	duty $02
	vol $6
	note ds5 $15
	vol $4
	note ds5 $07
	vol $6
	note as4 $07
	rest $03
	vol $4
	note as4 $04
	vol $6
	note as5 $07
	rest $03
	vol $4
	note as5 $04
	vol $6
	note gs5 $1c
	note g5  $07
	rest $03
	vol $4
	note g5  $04
	vol $6
	note f5  $1c
	note cs5 $07
	rest $03
	vol $4
	note cs5 $04
	vol $6
	note ds5 $07
	note f5  $07
	note g5  $07
	rest $03
	vol $4
	note g5  $04
	vol $6
	note f5  $0e
	note ds5 $0e
	note cs5 $0e
	note f5  $0e
	note ds5 $1c
	vibrato $01
	env $0 $00
	vol $4
	note ds5 $1c
	vibrato $e1
	env $0 $00
	vol $6
	note ds5 $07
	note f5  $07
	note g5  $07
	note gs5 $07
	rest $03
	vol $4
	note gs5 $07
	rest $04
	vol $2
	note gs5 $07
	rest $03
	vol $1
	note gs5 $04
	vol $6
	note as5 $1c
	note ds6 $1c
	vol $4
	note ds6 $0e
	vol $6
	note f6  $0e
	note cs6 $0e
	note as5 $07
	note cs6 $07
	note ds6 $07
	note f6  $07
	note fs6 $07
	rest $03
	vol $4
	note fs6 $04
	vol $6
	note f6  $0e
	note ds6 $0e
	note cs6 $0e
	note as5 $0e
	rest $03
	vol $4
	note as5 $07
	rest $04
	vol $6
	note f6  $07
	rest $03
	vol $4
	note f6  $04
	vol $6
	note fs6 $07
	note gs6 $07
	note a6  $07
	rest $03
	vol $4
	note a6  $04
	vol $6
	note gs6 $0e
	note fs6 $0e
	note e6  $0e
	note d6  $0e
	note c6  $1c
	note b5  $07
	rest $03
	vol $4
	note b5  $04
	vol $6
	note a5  $1c
	note g5  $07
	rest $03
	vol $4
	note g5  $04
	vol $6
	note a5  $38
	vibrato $01
	env $0 $00
	vol $4
	note a5  $1c
	vibrato $e1
	vol $6
	note gs5 $1c
	vol $6
	note fs5 $07
	rest $03
	vol $3
	note fs5 $04
	vol $6
	note e5  $1c
	note d5  $07
	rest $03
	vol $3
	note d5  $04
	vol $6
	note e5  $46
	vibrato $01
	env $0 $00
	vol $3
	note e5  $0e
	vibrato $e1
	vol $6
	note b4  $07
	rest $07
	vol $4
	note b4  $07
	rest $07
	vol $2
	note b4  $07
	rest $07
	vol $1
	note b4  $07
	rest $07
	vibrato $e1
	env $0 $00
	vol $0
	note b4  $07
	rest $15
	vibrato $00
	duty $02
musicf731c:
	vol $5
	note e5  $05
	rest $05
	vol $7
	note d5  $05
	vol $3
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note b5  $05
	vol $4
	note g5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note e5  $05
	vol $4
	note a5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note g5  $05
	vol $7
	note c6  $05
	vol $4
	note a5  $05
	vol $7
	note b5  $05
	vol $4
	note c6  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note e5  $05
	vol $4
	note a5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note g5  $05
	vol $7
	note c6  $05
	vol $4
	note a5  $05
	vol $7
	note b5  $05
	vol $4
	note c6  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note e5  $05
	vol $4
	note a5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note g5  $05
	vol $7
	note c6  $05
	vol $4
	note a5  $05
	vol $7
	note b5  $05
	vol $4
	note c6  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note e5  $05
	vol $4
	note a5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note g5  $05
	vol $7
	note c6  $05
	vol $4
	note a5  $05
	vol $7
	note b5  $05
	vol $4
	note c6  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note e5  $05
	vol $4
	note a5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note g5  $05
	vol $7
	note c6  $05
	vol $4
	note a5  $05
	vol $7
	note b5  $05
	vol $4
	note c6  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note fs5 $05
	vol $4
	note a5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note b4  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note b4  $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note a5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note b4  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note b4  $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note fs5 $05
	vol $7
	note e5  $05
	vol $4
	note a5  $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note fs5 $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note fs5 $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note a5  $05
	vol $7
	note b5  $05
	vol $4
	note fs5 $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note fs5 $05
	vol $4
	note a5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note b4  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note b4  $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note fs5 $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note d6  $05
	vol $4
	note a5  $05
	vol $7
	note cs6 $05
	vol $4
	note d6  $05
	vol $7
	note b5  $05
	vol $4
	note cs6 $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note fs5 $05
	vol $4
	note a5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note b4  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note b4  $05
	goto musicf731c
	cmdff

sound3fChannel0:
	vol $0
	note gs3 $62
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
	vol $5
	note d5  $07
	note g5  $07
	note d6  $07
	rest $03
	vol $3
	note d6  $07
	rest $04
	vol $2
	note d6  $07
	rest $03
	vol $2
	note d6  $07
	rest $04
	vol $1
	note d6  $07
	rest $07
	duty $01
	vol $4
	note b3  $1c
	note d4  $1c
	note c4  $0e
	note b3  $0e
	note c4  $1c
	note g3  $1c
	vol $2
	note g3  $0e
	duty $02
	vol $5
	note c5  $07
	note f5  $07
	note c6  $07
	note f5  $07
	note c5  $07
	rest $03
	vol $4
	note c5  $07
	rest $04
	vol $3
	note c5  $07
	rest $03
	vol $2
	note c5  $07
	rest $04
	vol $1
	note c5  $07
	rest $31
	duty $01
	vol $5
	note ds4 $0e
	note cs4 $0e
	vol $5
	note ds4 $1c
	note as3 $1c
	vol $2
	note as3 $0e
	duty $02
	vol $5
	note ds5 $07
	note gs5 $07
	note cs6 $07
	rest $03
	vol $4
	note cs6 $07
	rest $04
	vol $3
	note cs6 $07
	rest $03
	vol $2
	note cs6 $07
	rest $04
	vol $1
	note cs6 $07
	rest $07
	duty $01
	vol $6
	note c4  $1c
	vol $7
	note f4  $1c
	vol $6
	note fs4 $0e
	note f4  $0e
	note fs4 $1c
	note cs4 $1c
	vol $4
	note cs4 $0e
	duty $02
	vol $6
	note fs5 $07
	note b5  $07
	vol $6
	note e6  $07
	rest $03
	vol $5
	note e6  $07
	rest $04
	vol $4
	note e6  $07
	rest $03
	vol $3
	note e6  $07
	rest $04
	vol $2
	note e6  $07
	rest $07
	vol $6
	note b3  $07
	vol $6
	note cs4 $07
	vol $7
	note ds4 $07
	vol $7
	note e4  $07
	vol $8
	note fs4 $07
	vol $8
	note gs4 $07
	vol $9
	note a4  $07
	vol $9
	note b4  $07
	vol $3
	note b4  $07
	rest $03
	vol $3
	note b4  $07
	rest $04
	vol $2
	note b4  $07
	vol $6
	note as4 $15
	vol $4
	note as4 $07
	vol $6
	note ds4 $07
	rest $03
	vol $4
	note ds4 $04
	vol $6
	note g4  $07
	rest $03
	vol $4
	note g4  $04
	vol $6
	note f4  $1c
	vol $4
	note f4  $0e
	vol $6
	note cs4 $1c
	note as3 $07
	rest $03
	vol $4
	note as3 $04
	vol $6
	note b3  $0e
	note ds4 $07
	rest $03
	vol $4
	note ds4 $04
	vol $6
	note cs4 $0e
	note b3  $0e
	note as3 $0e
	note cs4 $0e
	note as3 $0e
	vol $4
	note as3 $0e
	vol $6
	note ds3 $07
	note as3 $07
	note ds4 $03
	rest $04
	note ds4 $07
	note as4 $03
	rest $04
	note as4 $07
	note ds5 $03
	rest $04
	note ds5 $07
	rest $03
	vol $4
	note ds5 $07
	rest $04
	vol $2
	note ds5 $07
	rest $03
	vol $1
	note ds5 $04
	vol $6
	note ds5 $1c
	note fs5 $1c
	vol $4
	note fs5 $0e
	vol $6
	note cs5 $0e
	note as4 $1c
	note fs5 $07
	note gs5 $07
	note as5 $07
	rest $03
	vol $4
	note as5 $04
	vol $6
	note ds5 $0e
	note cs5 $0e
	note as4 $0e
	note ds5 $0e
	note f5  $0e
	note cs5 $0e
	note d5  $07
	note e5  $07
	note fs5 $07
	rest $03
	vol $4
	note fs5 $04
	vol $6
	note e5  $0e
	note cs5 $0e
	note b4  $0e
	note fs5 $0e
	note a5  $1c
	note g5  $07
	rest $03
	vol $4
	note g5  $04
	vol $6
	note f5  $1c
	note e5  $07
	rest $03
	vol $4
	note e5  $04
	vol $6
	note f5  $1c
	note e5  $0e
	note d5  $1c
	note c5  $0e
	note b4  $1c
	note a4  $07
	rest $03
	vol $4
	note a4  $04
	vol $6
	note gs4 $1c
	note fs4 $07
	rest $03
	vol $4
	note fs4 $04
	vol $6
	note gs4 $1c
	note a4  $07
	rest $03
	vol $4
	note a4  $04
	vol $6
	note gs4 $1c
	note fs4 $07
	rest $03
	vol $4
	note fs4 $04
	vol $6
	note gs4 $07
	rest $07
	vol $5
	note gs4 $07
	rest $07
	vol $3
	note gs4 $07
	rest $07
	vol $2
	note gs4 $07
	rest $07
	vol $1
	note gs4 $07
	rest $15
	vibrato $00
	duty $01
musicf78ef:
	rest $78
	vol $7
	note e3  $28
	note g3  $46
	vol $4
	note g3  $0a
	vol $7
	note e3  $28
	note g3  $28
	note a3  $28
	note c4  $28
	note b3  $28
	note g3  $28
	note a3  $28
	note e3  $50
	vol $4
	note e3  $14
	vol $7
	note d3  $05
	vol $4
	note d3  $05
	vol $7
	note d3  $05
	vol $4
	note d3  $05
	vol $7
	note e3  $78
	vol $4
	note e3  $1e
	vol $2
	note e3  $1e
	vol $1
	note e3  $14
	vol $7
	note a3  $28
	note c4  $46
	vol $4
	note c4  $0a
	vol $7
	note a3  $28
	note c4  $28
	note d4  $28
	note fs4 $28
	note a4  $28
	note c5  $28
	note b4  $5a
	vol $4
	note b4  $0a
	vol $7
	note a2  $05
	vol $4
	note a2  $05
	vol $7
	note a2  $05
	vol $4
	note a2  $05
	vol $7
	note b2  $78
	vol $4
	note b2  $1e
	vol $2
	note b2  $1e
	vol $1
	note b2  $1e
	vol $0
	note b2  $1e
	rest $78
	goto musicf78ef
	cmdff

sound3fChannel4:
	cmdf2
	duty $0e
	note g3  $07
	rest $07
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note f3  $07
	duty $0f
	note d3  $07
	duty $0e
	note ds3 $07
	duty $0f
	note f3  $07
	duty $0e
	note f3  $07
	duty $0f
	note ds3 $07
	duty $0e
	note c3  $07
	duty $0f
	note f3  $07
	duty $0e
	note f3  $07
	duty $0f
	note c3  $07
	duty $0e
	note ds3 $07
	duty $0f
	note f3  $07
	duty $0e
	note f3  $07
	duty $0f
	note ds3 $07
	duty $0e
	note c3  $07
	duty $0f
	note f3  $07
	duty $0e
	note f3  $07
	duty $0f
	note c3  $07
	duty $0e
	note ds3 $07
	duty $0f
	note f3  $07
	duty $0e
	note f3  $07
	duty $0f
	note ds3 $07
	duty $0e
	note c3  $07
	duty $0f
	note f3  $07
	duty $0e
	note gs3 $07
	duty $0f
	note c3  $07
	duty $0e
	note fs3 $07
	duty $0f
	note gs3 $07
	duty $0e
	note gs3 $07
	duty $0f
	note fs3 $07
	duty $0e
	note ds3 $07
	duty $0f
	note gs3 $07
	duty $0e
	note b3  $07
	duty $0f
	note ds3 $07
	duty $0e
	note as3 $07
	duty $0f
	note b3  $07
	duty $0e
	note b3  $07
	duty $0f
	note as3 $07
	duty $0e
	note fs3 $07
	duty $0f
	note b3  $07
	duty $0e
	note b3  $07
	duty $0f
	note fs3 $07
	duty $0e
	note as3 $07
	duty $0f
	note b3  $07
	duty $0e
	note b3  $07
	duty $0f
	note as3 $07
	duty $0e
	note fs3 $07
	duty $0f
	note b3  $07
	duty $0e
	note b3  $07
	duty $0f
	note fs3 $07
	duty $0e
	note as3 $07
	duty $0f
	note b3  $07
	duty $0e
	note b3  $07
	duty $0f
	note as3 $07
	duty $0e
	note fs3 $07
	duty $0f
	note b3  $07
	duty $0e
	note gs2 $07
	note a2  $07
	note b2  $07
	note cs3 $07
	note ds3 $07
	note e3  $07
	note fs3 $07
	note gs3 $07
	rest $1c
	note ds2 $15
	duty $0f
	note ds2 $0e
	duty $2c
	note ds2 $07
	duty $0e
	note ds2 $0e
	note cs2 $0e
	duty $0f
	note cs2 $0e
	duty $0e
	note cs2 $0e
	note f2  $0e
	note ds2 $0e
	note cs2 $0e
	note b1  $0e
	duty $0f
	note b1  $0e
	duty $0e
	note b1  $0e
	note as1 $1c
	note cs2 $0e
	note ds2 $15
	duty $0f
	note ds2 $07
	duty $0e
	note as1 $0e
	note ds2 $0e
	note as1 $0e
	note ds2 $0e
	note b1  $0e
	duty $0f
	note b1  $0e
	duty $0e
	note fs2 $1c
	note b2  $1c
	note as2 $1c
	note f2  $0e
	note as2 $0e
	duty $0f
	note as2 $0e
	duty $0e
	note f2  $0e
	note as1 $1c
	note cs2 $1c
	note f2  $1c
	note d2  $1c
	note e2  $1c
	duty $0f
	note e2  $0e
	duty $0e
	note e2  $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $23
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $0e
	note c2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $18
	duty $0f
	note e2  $04
	duty $0e
	note e2  $15
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $1c
	note b1  $0e
	note e2  $1c
	note gs2 $0e
	note e2  $1c
	rest $38
musicf7c09:
	rest $78
	duty $0e
	note a3  $28
	note d4  $46
	duty $17
	note d4  $0a
	duty $0e
	note a3  $28
	note d4  $28
	note e4  $28
	note g4  $28
	note fs4 $28
	note d4  $28
	note e4  $28
	note a3  $50
	duty $17
	note a3  $14
	duty $0e
	note a2  $05
	duty $17
	note a2  $05
	duty $0e
	note a2  $05
	duty $17
	note a2  $05
	duty $0e
	note a2  $78
	duty $17
	note a2  $1e
	duty $0f
	note a2  $1e
	duty $0c
	note a2  $14
	duty $0e
	note e4  $28
	note g4  $46
	duty $17
	note g4  $0a
	duty $0e
	note e4  $28
	note g4  $28
	note a4  $28
	note b4  $28
	note d5  $28
	note f5  $28
	note fs5 $5a
	duty $17
	note fs5 $0a
	duty $0e
	note e3  $05
	duty $17
	note e3  $05
	duty $0e
	note e3  $05
	duty $17
	note e3  $05
	duty $0e
	note fs3 $78
	duty $17
	note fs3 $1e
	duty $0f
	note fs3 $1e
	duty $0c
	note fs3 $1e
	duty $0c
	note fs3 $1e
	rest $78
	goto musicf7c09
	cmdff

sound3fChannel6:
	cmdf2
	vol $2
	note $2e $70
	note $2e $69
	vol $3
	note $2a $02
	vol $2
	note $2a $02
	vol $2
	note $2a $03
	vol $2
	note $2e $70
	note $2e $69
	vol $3
	note $2a $02
	vol $2
	note $2a $02
	vol $2
	note $2a $03
	vol $2
	note $2e $70
	vol $2
	note $2e $70
	note $2e $70
	note $2e $38
	vol $2
	note $2e $02
	vol $2
	note $2e $02
	vol $2
	note $2e $03
	vol $3
	note $2e $02
	vol $3
	note $2e $02
	vol $3
	note $2e $03
	vol $3
	note $2e $02
	vol $3
	note $2e $02
	vol $3
	note $2e $03
	vol $4
	note $2e $02
	vol $4
	note $2e $02
	vol $4
	note $2e $03
	vol $4
	note $2e $02
	vol $4
	note $2e $02
	vol $4
	note $2e $03
	vol $4
	note $2e $02
	vol $4
	note $2e $02
	vol $4
	note $2e $03
	vol $4
	note $2e $02
	vol $4
	note $2e $02
	vol $4
	note $2e $03
	vol $4
	note $2e $02
	vol $4
	note $2e $02
	vol $4
	note $2e $03
	vol $2
	note $2e $1c
	vol $4
	note $26 $1c
	note $26 $0e
	note $26 $0e
	vol $4
	note $26 $0e
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $2a
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $1c
	vol $4
	note $26 $0e
	note $26 $1c
	vol $4
	note $26 $0e
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $0e
	note $26 $0e
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $2
	note $26 $02
	vol $3
	note $26 $02
	vol $4
	note $26 $03
	vol $4
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $03
	vol $2
	note $2e $0e
	vol $4
	note $26 $07
	note $26 $07
	vol $2
	note $2e $1c
	vol $4
	note $26 $0e
	note $26 $07
	note $26 $07
	vol $2
	note $2e $0e
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $07
	vol $3
	note $2a $02
	vol $2
	note $2a $02
	vol $3
	note $2a $03
	vol $4
	note $26 $1c
	vol $2
	note $2e $0e
	vol $4
	note $26 $1c
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $2
	note $2e $1c
	vol $4
	note $26 $1c
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $02
	vol $4
	note $26 $02
	vol $3
	note $26 $03
	vol $3
	note $26 $02
	vol $2
	note $26 $02
	vol $2
	note $26 $03
	vol $2
	note $2e $1c
	note $2a $0e
	note $2e $15
	note $2a $07
	note $2a $0e
	note $2e $1c
	note $2a $07
	vol $2
	note $2a $0e
	vol $2
	note $2a $07
	note $2a $0e
	vol $2
	note $2a $0e
	vol $2
	note $2e $1c
	note $2e $2a
	rest $02
	note $2a $05
	note $2a $04
	note $2a $03
	note $2e $46
	rest $03
	note $2a $04
	note $2a $03
	note $2a $04
	vol $2
	note $2e $1c
	cmdff

sound31Channel1:
	vibrato $00
	env $0 $02
	cmdf2
	duty $02
	vol $6
	note b6  $02
	note as6 $02
	note b6  $03
	note as6 $02
	note b6  $07
	rest $28
	note c7  $02
	note b6  $02
	note c7  $03
	note b6  $02
	note c7  $07
	rest $3c
musicf7df7:
	vibrato $00
	env $0 $00
	duty $00
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	vol $3
	note d6  $05
	vol $6
	note d7  $05
	vol $3
	note d7  $05
	vol $6
	note d6  $05
	vol $3
	note d6  $05
	vol $6
	note d6  $05
	note ds6 $05
	note e6  $05
	note f6  $05
	note e6  $05
	note ds6 $05
	note d6  $05
	vol $3
	note d6  $05
	rest $0a
	vol $6
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	vol $3
	note d6  $05
	vol $6
	note d7  $05
	vol $3
	note d7  $05
	vol $6
	note d6  $05
	vol $3
	note d6  $05
	vol $6
	note d6  $05
	note ds6 $05
	note e6  $05
	note f6  $05
	note e6  $05
	note ds6 $05
	note d6  $05
	vol $3
	note d6  $05
	rest $0a
	vol $5
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	vol $2
	note cs6 $05
	rest $69
	vibrato $00
	env $0 $02
	duty $02
	vol $6
	note d7  $02
	note c7  $02
	note b6  $02
	note a6  $04
	note g6  $02
	note fs6 $02
	note e6  $02
	note d6  $0b
	rest $53
	vibrato $00
	env $0 $00
	duty $00
	goto musicf7df7
	cmdff

sound31Channel0:
	vibrato $00
	env $0 $02
	cmdf2
	duty $02
	vol $6
	note f6  $07
	rest $31
	note fs6 $07
	rest $45
musicf7ee1:
	vol $6
	note g4  $05
	rest $05
	note d5  $05
	rest $05
	note d4  $05
	rest $05
	note d5  $05
	rest $05
	note g4  $05
	rest $05
	note d5  $05
	rest $05
	note d4  $05
	rest $05
	note d5  $05
	rest $05
	note gs4 $05
	rest $05
	note ds5 $05
	rest $05
	note ds4 $05
	rest $05
	note ds5 $05
	rest $05
	note gs4 $05
	rest $05
	note ds5 $05
	rest $05
	note ds4 $05
	rest $05
	note ds5 $05
	rest $05
	note as4 $05
	rest $05
	note f5  $05
	rest $05
	note f4  $05
	rest $05
	note f5  $05
	rest $05
	note as4 $05
	rest $05
	note f5  $05
	rest $05
	note f4  $05
	rest $05
	note f5  $05
	rest $05
	note c5  $05
	rest $05
	note g5  $05
	rest $05
	note g4  $05
	rest $05
	note g5  $05
	rest $05
	note c5  $05
	rest $05
	note g5  $05
	rest $05
	note b4  $05
	rest $05
	note a4  $05
	rest $05
	vol $5
	note g4  $05
	rest $05
	note d5  $05
	rest $05
	note d4  $05
	rest $05
	note d5  $05
	rest $05
	note g4  $05
	rest $05
	note d5  $05
	rest $05
	note d4  $05
	rest $05
	note d5  $05
	rest $78
	vol $3
	note d7  $02
	note c7  $03
	note b6  $02
	note a6  $02
	note g6  $02
	note fs6 $04
	note e6  $02
	note d6  $0a
	rest $4e
	goto musicf7ee1
	cmdff

sound93Start:

sound93Channel2:
	duty $02
	vol $b
	note c8  $01
	vol $0
	rest $0b
	vol $b
	note c7  $01
	vol $0
	rest $03
	vol $b
	note f6  $01
	vol $0
	rest $03
	vol $b
	note c6  $01
	vol $0
	rest $04
	vol $b
	note as5 $01
	vol $0
	rest $04
	vol $b
	note f5  $01
	vol $0
	rest $05
	vol $b
	note d5  $01
	cmdff

sound94Start:

sound94Channel2:
	vol $e
	cmdf8 $10
	note f2  $11
	cmdff

sounda2Start:

sounda2Channel2:
	duty $02
	vol $9
	note gs5 $06
	vol $3
	note gs5 $06
	vol $9
	note as5 $06
	vol $3
	note as5 $06
	vol $9
	note b5  $06
	vol $3
	note b5  $06
	vol $9
	note fs6 $06
	vol $3
	note fs6 $06
	cmdff

sounda3Start:

sounda3Channel7:
	cmdf0 $90
	note $14 $01
	cmdf0 $00
	note $00 $01
	cmdf0 $22
	note $14 $02
	cmdff

sounda7Start:

sounda7Channel2:
	vol $d
	note c7  $01
	vol $0
	rest $01
	vol $3
	note c7  $01
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
.BANK $3e SLOT 1
.ORG 0

sound25Start:

sound28Start:

sound2fStart:

sound30Start:

sound37Start:

sound39Start:

sound3aStart:

sound3bStart:

sound3cStart:

sound47Start:

sound48Start:

sound49Start:

sound4bStart:

sound25Channel6:
sound28Channel6:
sound2fChannel0:
sound2fChannel4:
sound2fChannel6:
sound30Channel4:
sound30Channel6:
sound37Channel4:
sound39Channel6:
sound3aChannel6:
sound3bChannel0:
sound3bChannel1:
sound3bChannel4:
sound3bChannel6:
sound3cChannel6:
sound47Channel0:
sound47Channel1:
sound47Channel4:
sound47Channel6:
sound48Channel0:
sound48Channel1:
sound48Channel4:
sound48Channel6:
sound49Channel0:
sound49Channel1:
sound49Channel4:
sound49Channel6:
sound4bChannel0:
sound4bChannel1:
sound4bChannel4:
sound4bChannel6:
	cmdff

soundcaStart:

soundcaChannel2:
	duty $02
	vol $f
	cmdf8 $ee
	note e3  $02
	cmdf8 $00
	vol $f
	note a2  $01
	vol $f
	note a2  $04
	env $0 $01
	note as2 $0c
	cmdf8 $f6
	cmdff

soundcaChannel7:
	cmdf0 $f1
	note $54 $02
	cmdf0 $51
	note $25 $0a
	cmdff

soundc4Start:

soundc4Channel5:
	duty $0b
	note c3  $02
	cmdf8 $1e
	note c3  $05
	rest $05
	note c3  $02
	cmdf8 $1e
	note c3  $08
	cmdff

soundccStart:

soundccChannel2:
	duty $00
	vol $c
	note g7  $02
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	cmdff

soundcdStart:

soundcdChannel2:
	duty $01
	vol $0
	rest $03
	vol $c
	note a5  $01
	vol $d
	note g4  $01
	vol $e
	note c6  $01
	vol $a
	env $0 $01
	note c6  $08
	cmdff

soundcdChannel3:
	duty $00
	vol $0
	rest $03
	vol $d
	note g5  $03
	vol $a
	env $0 $01
	note g5  $08
	cmdff

soundcdChannel7:
	cmdf0 $a1
	note $07 $01
	cmdf0 $91
	note $14 $01
	cmdf0 $81
	note $15 $01
	cmdf0 $71
	note $16 $01
	cmdf0 $61
	note $17 $02
	cmdff

soundd6Start:

soundd7Start:

soundd8Start:

soundd9Start:

sounddaStart:

sounddbStart:

sounddcStart:

soundddStart:

soundd6Channel1:
soundd7Channel1:
soundd8Channel1:
soundd9Channel1:
sounddaChannel1:
sounddbChannel1:
sounddcChannel1:
soundddChannel1:
	cmdff

soundd6Channel0:
soundd7Channel0:
soundd8Channel0:
soundd9Channel0:
sounddaChannel0:
sounddbChannel0:
sounddcChannel0:
soundddChannel0:
	cmdff

soundd6Channel4:
soundd7Channel4:
soundd8Channel4:
soundd9Channel4:
sounddaChannel4:
sounddbChannel4:
sounddcChannel4:
soundddChannel4:
	cmdff

soundd6Channel6:
soundd7Channel6:
soundd8Channel6:
soundd9Channel6:
sounddaChannel6:
sounddbChannel6:
sounddcChannel6:
soundddChannel6:
	cmdff

sound39Channel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $00
musicf80d7:
	vol $6
	note cs4 $48
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $1
	note c4  $09
	vol $6
	note fs4 $12
	note g4  $09
	rest $04
	vol $3
	note g4  $05
	vol $6
	note gs4 $12
	note g4  $09
	rest $04
	vol $3
	note g4  $09
	rest $05
	vol $1
	note g4  $09
	rest $5a
	vol $6
	note cs4 $48
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $1
	note c4  $09
	vol $6
	note fs4 $12
	note g4  $09
	rest $04
	vol $3
	note g4  $05
	vol $6
	note as4 $0c
	note a4  $0c
	note gs4 $0c
	note g4  $09
	rest $04
	vol $3
	note g4  $09
	rest $05
	vol $1
	note g4  $09
	rest $48
	vol $6
	note c5  $48
	note fs4 $09
	rest $04
	vol $3
	note fs4 $09
	rest $05
	vol $1
	note fs4 $09
	vol $6
	note f4  $12
	note ds4 $09
	rest $04
	vol $3
	note ds4 $05
	vol $6
	note f4  $09
	note ds4 $09
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $1
	note c4  $09
	rest $36
	vol $6
	note f4  $12
	note ds4 $12
	note fs4 $0c
	note f4  $0c
	note ds4 $0c
	note f4  $12
	note ds4 $12
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $1
	note c4  $09
	vol $6
	note as3 $12
	note ds4 $12
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $1
	note c4  $09
	vol $6
	note as3 $09
	rest $04
	vol $3
	note as3 $09
	rest $05
	vol $1
	note as3 $09
	vol $6
	note e3  $48
	goto musicf80d7
	cmdff

sound39Channel0:
	cmdf2
	env $0 $02
	vol $9
musicf819f:
	note c2  $24
	note fs2 $09
	rest $09
	note fs2 $09
	rest $09
	note fs2 $09
	rest $3f
	note c2  $09
	rest $1b
	note fs2 $09
	rest $09
	note fs2 $04
	rest $05
	note fs2 $04
	rest $05
	note fs2 $04
	rest $20
	note c2  $04
	rest $05
	note c2  $04
	rest $05
	note c2  $04
	rest $0e
	note c2  $24
	note fs2 $09
	rest $09
	note fs2 $09
	rest $09
	note fs2 $09
	rest $1b
	note fs2 $09
	rest $1b
	note c2  $09
	rest $1b
	note fs2 $09
	rest $09
	note fs2 $04
	rest $05
	note fs2 $04
	rest $05
	note as2 $12
	note a2  $12
	note gs2 $12
	note g2  $12
	note c2  $51
	rest $09
	note fs2 $09
	note f2  $09
	note e2  $09
	note ds2 $09
	note d2  $09
	note cs2 $09
	note c2  $09
	rest $1b
	note fs2 $09
	rest $09
	note fs2 $04
	rest $05
	note fs2 $04
	rest $05
	note fs2 $09
	rest $1b
	note c2  $04
	rest $05
	note c2  $04
	rest $05
	note c2  $04
	rest $0e
	note c2  $24
	note fs2 $09
	rest $09
	note fs2 $09
	rest $09
	note fs2 $09
	rest $3f
	note c2  $09
	rest $1b
	note fs2 $09
	rest $09
	note fs2 $04
	rest $05
	note fs2 $04
	rest $05
	note as2 $48
	goto musicf819f
	cmdff

sound39Channel4:
	cmdf2
musicf824c:
	duty $17
	note g3  $48
	note fs3 $09
	duty $0c
	note fs3 $12
	rest $09
	duty $17
	note c4  $12
	note cs4 $09
	duty $0c
	note cs4 $09
	duty $17
	note d4  $12
	note cs4 $09
	duty $0c
	note cs4 $12
	rest $87
	duty $17
	note g3  $24
	note fs3 $09
	duty $0c
	note fs3 $12
	rest $09
	duty $17
	note c4  $12
	note cs4 $09
	duty $0c
	note d4  $09
	duty $17
	note e4  $0c
	note ds4 $0c
	note d4  $0c
	note cs4 $09
	duty $0c
	note cs4 $12
	rest $63
	duty $17
	note g4  $09
	note fs4 $09
	note f4  $09
	note e4  $09
	note ds4 $09
	note d4  $09
	note cs4 $09
	duty $0c
	note cs4 $12
	rest $09
	duty $17
	note b3  $12
	note a3  $09
	duty $0c
	note a3  $09
	duty $17
	note b3  $09
	note a3  $09
	note fs3 $09
	duty $17
	note fs3 $12
	rest $ff
	rest $84
	goto musicf824c
	cmdff

sound37Channel1:
	cmdff

sound37Channel0:
	cmdff

sound37Channel6:
	cmdff

sound30Channel1:
	cmdff

sound30Channel0:
	cmdff

sound2fChannel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf82d4:
	vol $c
	note c2  $04
	vol $5
	note c2  $08
	vol $2
	note c2  $04
	vol $c
	note fs2 $04
	vol $5
	note fs2 $08
	vol $2
	note fs2 $04
	vol $c
	note f2  $04
	vol $5
	note f2  $08
	vol $2
	note f2  $04
	rest $48
	vol $c
	note c2  $02
	vol $5
	note c2  $04
	vol $2
	note c2  $02
	vol $c
	note c2  $04
	vol $5
	note c2  $08
	vol $2
	note c2  $04
	vol $c
	note fs2 $04
	vol $5
	note fs2 $08
	vol $2
	note fs2 $04
	vol $c
	note f2  $04
	vol $5
	note f2  $04
	vol $c
	note b2  $04
	vol $5
	note b2  $08
	vol $2
	note b2  $04
	rest $f8
	goto musicf82d4
	cmdff
	cmdff
	cmdff
	cmdff

sound3cChannel1:
musicf8324:
	vibrato $00
	env $0 $05
	cmdf2
	duty $00
	vol $8
	note g6  $1e
	note d6  $0a
	note b5  $14
	note g5  $14
	note gs5 $28
	note ds6 $0a
	note c6  $0a
	note gs5 $0a
	note ds5 $0a
	note d5  $14
	note d6  $0a
	note b5  $0a
	note g5  $14
	note d5  $14
	note f5  $14
	note ds5 $0a
	note f5  $0a
	note d5  $28
	vol $3
	vibrato $00
	env $0 $03
	note cs5 $05
	rest $0f
	note d5  $05
	rest $0f
	note ds6 $05
	rest $0f
	note d6  $05
	rest $0f
	note cs6 $05
	rest $0f
	note d6  $05
	rest $0f
	note c6  $05
	rest $0f
	note cs6 $05
	rest $0f
	note b5  $05
	rest $0f
	note c6  $05
	rest $0f
	note as5 $05
	rest $0f
	note b5  $05
	rest $0f
	note a5  $05
	rest $05
	note as5 $05
	rest $05
	note gs5 $05
	rest $05
	note a5  $05
	rest $55
	vol $3
	note as7 $01
	note as5 $01
	cmdf8 $81
	note cs5 $03
	cmdf8 $00
	vol $0
	rest $05
	vol $3
	note as7 $01
	note as5 $01
	cmdf8 $81
	note cs5 $03
	cmdf8 $00
	vol $0
	rest $05
	goto musicf8324
	cmdff

sound3cChannel0:
musicf83b5:
	vibrato $00
	env $0 $02
	cmdf2
	duty $02
	vol $6
	note g3  $0a
	vol $3
	note g3  $0a
	vol $6
	note cs4 $0a
	vol $3
	note cs4 $0a
	vol $6
	note as4 $0a
	vol $3
	note as4 $0a
	vol $6
	note cs4 $0a
	vol $3
	note cs4 $0a
	vol $6
	note d3  $0a
	vol $3
	note d3  $0a
	vol $6
	note c4  $0a
	vol $3
	note c4  $0a
	vol $6
	note a4  $0a
	vol $3
	note a4  $0a
	vol $6
	note c4  $0a
	vol $3
	note c4  $0a
	vol $6
	note g3  $0a
	vol $3
	note g3  $0a
	vol $6
	note cs4 $0a
	vol $3
	note cs4 $0a
	vol $6
	note as4 $0a
	vol $3
	note as4 $0a
	vol $6
	note cs4 $0a
	vol $3
	note cs4 $0a
	vol $6
	note d3  $0a
	vol $3
	note d3  $0a
	vol $6
	note c4  $0a
	vol $3
	note c4  $0a
	vol $6
	note a4  $0a
	vol $3
	note a4  $0a
	vol $6
	note c4  $0a
	vol $3
	note c4  $0a
	vol $3
	rest $28
	note d6  $05
	rest $0f
	note cs6 $05
	rest $0f
	env $0 $03
	note c6  $05
	rest $0f
	note cs6 $05
	rest $0f
	note b5  $05
	rest $0f
	note c6  $05
	rest $0f
	note as5 $05
	rest $0f
	note b5  $05
	rest $0f
	note a5  $05
	rest $0f
	note as5 $05
	rest $0f
	note gs5 $05
	rest $0f
	note g5  $05
	rest $73
	goto musicf83b5
	cmdff

sound3cChannel4:
	cmdf2
musicf8456:
	duty $17
	rest $28
	note fs4 $05
	rest $05
	duty $0c
	note fs4 $03
	rest $07
	duty $17
	duty $0f
	note g7  $09
	rest $01
	note g7  $0a
	duty $17
	rest $28
	note f4  $05
	rest $05
	duty $0c
	note f4  $03
	rest $07
	duty $0f
	note g7  $09
	rest $01
	note g7  $0a
	duty $17
	rest $28
	note fs4 $05
	rest $05
	duty $0c
	note fs4 $03
	rest $07
	duty $0f
	note g7  $09
	rest $01
	note g7  $0a
	duty $17
	rest $28
	note f4  $05
	rest $05
	duty $0c
	note f4  $03
	rest $07
	duty $0f
	note g7  $09
	rest $01
	note g7  $0a
	rest $fa
	rest $82
	goto musicf8456
	cmdff

sound3dStart:

sound3dChannel1:
	vol $0
	note gs3 $c0
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musicf84c2:
	vol $7
	note d4  $08
	note f4  $08
	note d5  $08
	rest $04
	vol $3
	note d5  $08
	rest $04
	vol $1
	note d5  $08
	vol $7
	note d4  $08
	note f4  $08
	note d5  $08
	rest $04
	vol $3
	note d5  $08
	rest $04
	vol $1
	note d5  $08
	vol $7
	note e5  $10
	rest $04
	vol $3
	note e5  $04
	vol $7
	note f5  $08
	note e5  $08
	note f5  $08
	note e5  $08
	note c5  $08
	note a4  $10
	rest $02
	vol $3
	note a4  $08
	rest $02
	vol $1
	note a4  $04
	vol $7
	note a4  $10
	note d4  $10
	note f4  $08
	note g4  $08
	note a4  $20
	vol $3
	note a4  $10
	vol $7
	note a4  $10
	note d4  $10
	note f4  $08
	note g4  $08
	note e4  $20
	vol $3
	note e4  $10
	vol $7
	note d4  $08
	note f4  $08
	note d5  $08
	rest $04
	vol $3
	note d5  $08
	rest $04
	vol $1
	note d5  $08
	vol $7
	note d4  $08
	note f4  $08
	note d5  $08
	rest $04
	vol $3
	note d5  $08
	rest $04
	vol $1
	note d5  $08
	vol $7
	note e5  $10
	rest $04
	vol $3
	note e5  $04
	vol $7
	note f5  $08
	note e5  $08
	note f5  $08
	note e5  $08
	note c5  $08
	note a4  $10
	vol $3
	note a4  $10
	vol $7
	note a4  $10
	note d4  $10
	note f4  $08
	note g4  $08
	note a4  $10
	rest $06
	vol $3
	note a4  $08
	rest $02
	vol $7
	note a4  $10
	note d4  $50
	rest $70
	goto musicf84c2
	cmdff

sound3dChannel0:
	vol $0
	note gs3 $10
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	rest $08
	vol $6
	note e3  $08
	note b3  $18
	vol $3
	note b3  $08
	rest $10
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $1
	note c4  $04
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $1
	note c4  $04
	rest $08
	vol $6
	note e3  $08
	note b3  $18
	vol $3
	note b3  $08
musicf85ca:
	rest $10
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	rest $10
	vol $6
	note b3  $18
	vol $3
	note b3  $08
	rest $10
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $1
	note c4  $04
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $1
	note c4  $04
	rest $10
	vol $6
	note b3  $18
	vol $3
	note b3  $08
	rest $10
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	rest $10
	vol $6
	note a3  $18
	vol $3
	note a3  $08
	rest $10
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	rest $10
	vol $6
	note a3  $18
	vol $3
	note a3  $08
	rest $10
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	rest $10
	vol $6
	note b3  $18
	vol $3
	note b3  $08
	rest $10
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $1
	note c4  $04
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $1
	note c4  $04
	rest $10
	vol $6
	note b3  $18
	vol $3
	note b3  $08
	rest $10
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	rest $10
	vol $6
	note a3  $18
	vol $3
	note a3  $08
	rest $10
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
	rest $08
	vol $6
	note e3  $08
	note b3  $18
	vol $3
	note b3  $08
	rest $10
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $1
	note c4  $04
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $1
	note c4  $04
	rest $08
	vol $6
	note e3  $08
	note b3  $18
	vol $3
	note b3  $08
	goto musicf85ca
	cmdff

sound3dChannel4:
	cmdf2
	duty $17
	note d2  $10
	duty $17
	note f3  $04
	rest $0c
	duty $17
	note f3  $04
	rest $0c
	duty $17
	note e2  $10
	note g3  $20
	note f2  $10
	duty $17
	note a3  $04
	rest $0c
	duty $17
	note a3  $04
	rest $0c
	duty $17
	note e2  $10
	note g3  $20
musicf8741:
	note d2  $10
	note f3  $04
	rest $0c
	note f3  $04
	rest $0c
	note e2  $10
	note g3  $20
	note f2  $10
	note a3  $04
	rest $0c
	note a3  $04
	rest $0c
	note e2  $10
	note g3  $20
	note as2 $10
	note f3  $04
	rest $0c
	note f3  $04
	rest $0c
	note f2  $10
	note f3  $20
	note as2 $10
	note f3  $04
	rest $0c
	note f3  $04
	rest $0c
	note a2  $10
	note e3  $20
	note d2  $10
	note f3  $04
	rest $0c
	note f3  $04
	rest $0c
	note e2  $10
	note g3  $20
	note f2  $10
	note a3  $04
	rest $0c
	note a3  $04
	rest $0c
	note e2  $10
	note g3  $20
	note as2 $10
	note f3  $04
	rest $0c
	note f3  $04
	rest $0c
	note a2  $10
	note e3  $20
	note d2  $10
	note f3  $04
	rest $0c
	note f3  $04
	rest $0c
	note e2  $10
	note g3  $20
	note f2  $10
	note a3  $04
	rest $0c
	note a3  $04
	rest $0c
	note e2  $10
	note g3  $20
	goto musicf8741
	cmdff

sound3dChannel6:
	rest $10
	cmdf2
	cmdf2
	vol $3
	note $2a $10
	note $2a $10
	rest $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	rest $18
	note $2a $10
	note $2a $10
	rest $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	rest $07
musicf87e8:
	rest $11
	note $2a $10
	note $2a $10
	rest $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	rest $18
	note $2a $10
	note $2a $10
	rest $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	rest $18
	note $2a $10
	note $2a $10
	rest $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	rest $18
	note $2a $10
	note $2a $10
	rest $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	rest $18
	note $2a $10
	note $2a $10
	rest $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	rest $18
	note $2a $10
	note $2a $10
	rest $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	rest $18
	note $2a $10
	note $2a $10
	rest $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	rest $18
	note $2a $10
	note $2a $10
	rest $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	rest $18
	note $2a $10
	note $2a $10
	rest $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	rest $07
	goto musicf87e8
	cmdff

sound3eStart:

sound3eChannel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf8885:
	vol $0
	note gs3 $30
	vol $6
	note e4  $0d
	rest $03
	vol $3
	note e4  $02
	rest $02
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $10
	vol $6
	note d4  $08
	rest $02
	vol $3
	note d4  $04
	rest $02
	vol $6
	note c4  $08
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	rest $ae
	vol $6
	note e4  $05
	rest $03
	vol $6
	note e4  $05
	rest $03
	vol $6
	note e4  $05
	rest $05
	vol $3
	note e4  $04
	rest $02
	vol $6
	note e4  $05
	rest $05
	vol $3
	note e4  $04
	rest $02
	vol $6
	note d4  $05
	rest $03
	vol $3
	note d4  $04
	rest $04
	vol $6
	note c4  $05
	rest $03
	vol $3
	note c4  $04
	rest $04
	vol $2
	note c4  $02
	rest $5e
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $04
	rest $02
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $2
	note c4  $02
	rest $2e
	vol $6
	note e4  $0d
	rest $03
	note e4  $02
	rest $02
	vol $3
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $10
	vol $6
	note d4  $08
	rest $02
	vol $3
	note d4  $04
	rest $02
	vol $6
	note c4  $08
	rest $02
	vol $3
	note c4  $04
	rest $04
	vol $1
	note c4  $02
	rest $ac
	vol $6
	note e4  $05
	rest $03
	vol $6
	note e4  $05
	rest $03
	vol $6
	note e4  $05
	rest $05
	vol $3
	note e4  $04
	rest $02
	vol $6
	note e4  $05
	rest $05
	vol $3
	note e4  $04
	rest $02
	vol $6
	note d4  $05
	rest $03
	vol $3
	note d4  $04
	rest $04
	vol $6
	note c4  $05
	rest $03
	vol $3
	note c4  $04
	rest $04
	vol $2
	note c4  $02
	rest $5e
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $04
	rest $02
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $1
	note c4  $02
	rest $5e
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $02
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $02
	rest $06
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $02
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $02
	rest $46
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $02
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $02
	rest $06
	vol $1
	note c4  $02
	rest $5e
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $02
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $02
	rest $06
	vol $6
	note d4  $08
	rest $02
	vol $3
	note d4  $02
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $02
	rest $06
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $02
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $02
	rest $06
	vol $1
	note c4  $02
	rest $ff
	rest $ff
	rest $10
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note as4 $0c
	rest $01
	vol $3
	note as4 $03
	rest $02
	note as4 $02
	rest $0c
	vol $6
	note as4 $0a
	rest $02
	vol $1
	note as4 $04
	rest $02
	vol $3
	note as4 $02
	rest $06
	vol $2
	note as4 $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $34
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note as4 $0c
	rest $01
	vol $3
	note as4 $03
	rest $05
	vol $3
	note as4 $03
	rest $02
	vol $3
	note as4 $02
	rest $04
	vol $6
	note as4 $10
	rest $02
	vol $3
	note as4 $02
	rest $06
	note as4 $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	vol $0
	rest $ff
	vol $0
	rest $ff
	rest $36
	vol $6
	note e4  $0d
	rest $03
	note e4  $02
	rest $02
	vol $4
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $10
	vol $6
	note d4  $08
	rest $02
	vol $3
	note d4  $04
	rest $02
	vol $6
	note c4  $08
	rest $02
	vol $3
	note c4  $04
	rest $04
	vol $2
	note c4  $02
	rest $ac
	vol $6
	note e4  $05
	rest $03
	vol $6
	note e4  $05
	rest $03
	vol $6
	note e4  $05
	rest $05
	vol $3
	note e4  $04
	rest $02
	vol $6
	note e4  $05
	rest $05
	vol $3
	note e4  $04
	rest $02
	vol $6
	note d4  $05
	rest $03
	vol $3
	note d4  $04
	rest $04
	vol $6
	note c4  $05
	rest $03
	vol $3
	note c4  $04
	rest $04
	vol $2
	note c4  $02
	rest $4e
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note as4 $08
	rest $02
	vol $3
	note as4 $02
	rest $06
	note as4 $02
	rest $06
	note as4 $02
	rest $04
	vol $6
	note as4 $08
	rest $02
	vol $3
	note as4 $02
	rest $06
	vol $3
	note as4 $02
	rest $06
	vol $2
	note as4 $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $34
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note as4 $08
	rest $02
	vol $3
	note as4 $02
	rest $06
	vol $3
	note as4 $02
	rest $06
	vol $3
	note as4 $02
	rest $04
	vol $6
	note as4 $08
	rest $02
	vol $5
	note as4 $02
	rest $06
	vol $4
	note as4 $02
	rest $06
	vol $3
	note as4 $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	vol $0
	rest $ff
	vol $0
	rest $85
	goto musicf8885
	cmdff

sound3eChannel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf8c51:
	vol $6
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $04
	rest $04
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $04
	rest $04
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $04
	rest $04
	note g2  $18
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note g2  $08
	note as2 $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $04
	rest $04
	note g2  $10
	rest $10
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $20
	note e3  $08
	rest $08
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note g2  $08
	rest $08
	note as2 $10
	note c3  $08
	rest $08
	note as2 $10
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note as2 $10
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note as2 $10
	note c3  $08
	rest $08
	note as2 $10
	note c3  $08
	rest $08
	note e3  $10
	note c3  $08
	rest $18
	note g2  $10
	note as2 $10
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $10
	note c2  $08
	note e3  $18
	note g2  $04
	rest $04
	note g2  $08
	rest $08
	note g2  $08
	note as2 $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note c3  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $10
	rest $08
	note ds3 $08
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $10
	rest $10
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note c3  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $10
	rest $08
	note ds3 $08
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $18
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $04
	rest $04
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $04
	rest $04
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $20
	note e3  $08
	rest $08
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $08
	rest $08
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $10
	note c2  $08
	note e3  $18
	note g2  $08
	rest $10
	note g2  $08
	note as2 $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $08
	rest $08
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note c3  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $0a
	rest $0e
	note ds3 $08
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	goto musicf8c51
	cmdff

sound3eChannel4:
	cmdf2
musicf8fdd:
	duty $17
	rest $30
	note g3  $0d
	rest $23
	note f3  $08
	rest $08
	note e3  $08
	rest $b8
	note g3  $02
	rest $06
	note g3  $02
	rest $06
	note g3  $04
	rest $0c
	note g3  $04
	rest $0c
	note f3  $04
	rest $0c
	note e3  $04
	rest $6c
	note d3  $08
	rest $08
	note e3  $04
	rest $3c
	note g3  $0d
	rest $23
	note f3  $08
	rest $08
	note e3  $08
	rest $b8
	note g3  $02
	rest $06
	note g3  $02
	rest $06
	note g3  $04
	rest $0c
	note g3  $04
	rest $0c
	note f3  $04
	rest $0c
	note e3  $04
	rest $6c
	note d3  $08
	rest $08
	note e3  $04
	rest $6c
	note d3  $08
	rest $08
	note e3  $04
	rest $0c
	note d3  $08
	rest $08
	note e3  $04
	rest $4c
	note d3  $08
	rest $08
	note e3  $04
	rest $6c
	note f3  $06
	rest $0a
	note f3  $04
	rest $0c
	note f3  $06
	rest $0a
	note f3  $04
	rest $ff
	rest $ff
	rest $3e
	duty $17
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note g4  $0c
	rest $14
	note g4  $0a
	rest $16
	note f4  $08
	rest $08
	note e4  $08
	rest $38
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note g4  $0c
	rest $14
	note g4  $10
	rest $10
	note f4  $08
	rest $08
	note e4  $08
	rest $ff
	rest $ff
	rest $3a
	duty $17
	note g3  $0d
	rest $23
	note f3  $08
	rest $08
	note e3  $08
	rest $b8
	note g3  $04
	rest $04
	note g3  $04
	rest $04
	note g3  $08
	rest $08
	note g3  $08
	rest $08
	note f3  $08
	rest $08
	note e3  $08
	rest $58
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note g4  $08
	rest $18
	note g4  $08
	rest $18
	note f4  $08
	rest $08
	note e4  $08
	rest $38
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note g4  $08
	rest $18
	note g4  $08
	rest $18
	note f4  $08
	rest $08
	note e4  $08
	rest $ff
	rest $89
	goto musicf8fdd
	cmdff

sound3eChannel6:
	cmdf2
musicf9138:
	vol $6
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	goto musicf9138
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff

sound2aStart:

sound2aChannel1:
	vibrato $e1
	env $0 $00
	duty $01
	vol $6
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $6
	note as3 $09
	note c4  $90
	vibrato $01
	env $0 $00
	vol $4
	note c4  $24
	vol $2
	note c4  $12
	vibrato $e1
	env $0 $00
	vol $6
	note c4  $06
	rest $03
	vol $3
	note c4  $06
	rest $03
	vol $6
	note c4  $06
	rest $03
	vol $3
	note c4  $06
	rest $03
	vol $6
	note c4  $06
	rest $03
	vol $3
	note c4  $06
	rest $03
	vol $6
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $6
	note as3 $09
	note c4  $90
	vibrato $01
	env $0 $00
	vol $4
	note c4  $24
	vol $2
	note c4  $24
	vibrato $e1
	env $0 $00
	vol $6
	note f4  $06
	note g4  $06
	note gs4 $06
	note as4 $06
	note c5  $06
	note d5  $06
	vol $6
	note ds5 $09
	rest $04
	vol $3
	note ds5 $09
	rest $05
	vol $6
	note d5  $09
	note c5  $48
	vibrato $01
	env $0 $00
	vol $3
	note c5  $24
	vibrato $e1
	env $0 $00
	vol $6
	note g4  $12
	note gs4 $12
	note as4 $12
	note c5  $12
	note d5  $12
	note ds5 $12
	note f5  $12
	note fs5 $12
	note g5  $20
	vol $3
	note g5  $10
	vol $6
	note g5  $04
	rest $04
	note g5  $04
	rest $04
	note g5  $1c
	vol $3
	note g5  $0e
	vol $6
	note g5  $03
	rest $04
	note g5  $03
	rest $04
	note g5  $0e
	note g4  $02
	rest $02
	note g4  $03
	rest $02
	note g4  $02
	rest $03
	note a4  $04
	rest $05
	note a4  $05
	rest $04
	note a4  $05
	rest $05
	note b4  $0e
	vol $3
	note b4  $0e
	vol $6
	note g5  $1c
	vibrato $e1
	env $0 $00
musicf92ff:
	duty $02
	vol $6
	note c5  $07
	rest $03
	vol $3
	note c5  $07
	rest $04
	vol $1
	note c5  $07
	vol $6
	note g4  $2a
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $6
	note c5  $07
	note d5  $07
	note e5  $07
	note f5  $07
	note g5  $38
	vibrato $01
	env $0 $00
	vol $3
	note g5  $0e
	vol $1
	note g5  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note g5  $09
	note gs5 $09
	note as5 $0a
	note c6  $38
	vibrato $01
	env $0 $00
	vol $3
	note c6  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note c6  $0e
	note as5 $0e
	note gs5 $0e
	note as5 $07
	rest $07
	vol $3
	note as5 $07
	vol $6
	note gs5 $07
	note g5  $2a
	vibrato $01
	env $0 $00
	vol $3
	note g5  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note g5  $1c
	note f5  $07
	rest $07
	vol $3
	note f5  $07
	vol $6
	note g5  $07
	note gs5 $31
	vol $3
	note gs5 $07
	vol $6
	note g5  $0e
	note f5  $0e
	note ds5 $07
	rest $07
	vol $3
	note ds5 $07
	vol $6
	note f5  $07
	note g5  $38
	note f5  $0e
	note ds5 $0e
	note d5  $07
	rest $07
	vol $3
	note d5  $07
	vol $6
	note e5  $07
	note fs5 $2a
	note g5  $0e
	note a5  $0e
	note b5  $0e
	note c6  $62
	note d6  $07
	note c6  $07
	note b5  $54
	vibrato $01
	env $0 $00
	vol $3
	note b5  $1c
	vibrato $e1
	env $0 $00
	vol $6
	note c5  $07
	rest $07
	vol $3
	note c5  $07
	vol $6
	note g4  $03
	rest $04
	note g4  $2a
	vol $3
	note g4  $07
	vol $6
	note c5  $03
	rest $04
	note c5  $07
	note d5  $07
	note e5  $07
	note f5  $07
	note g5  $31
	vibrato $01
	env $0 $00
	vol $3
	note g5  $0e
	vol $1
	note g5  $07
	vibrato $e1
	env $0 $00
	vol $6
	note g5  $07
	rest $03
	vol $3
	note g5  $04
	vol $6
	note g5  $0e
	note gs5 $07
	note as5 $07
	note c6  $38
	vibrato $01
	env $0 $00
	vol $3
	note c6  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note c6  $04
	note d6  $05
	note c6  $05
	note as5 $03
	rest $07
	vol $3
	note as5 $04
	vol $6
	note gs5 $03
	rest $07
	vol $3
	note gs5 $04
	vol $6
	note as5 $0e
	rest $03
	vol $3
	note as5 $04
	vol $6
	note gs5 $07
	note g5  $2a
	vibrato $01
	env $0 $00
	vol $3
	note g5  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note g5  $1c
	note f5  $07
	rest $07
	vol $3
	note f5  $07
	vol $6
	note g5  $07
	note gs5 $1c
	vol $3
	note gs5 $0e
	vol $6
	note gs5 $04
	note as5 $05
	note gs5 $05
	note g5  $07
	rest $03
	vol $3
	note g5  $04
	vol $6
	note f5  $07
	rest $03
	vol $3
	note f5  $04
	vol $6
	note ds5 $07
	rest $03
	vol $3
	note ds5 $04
	vol $6
	note ds5 $07
	note f5  $07
	note g5  $1c
	vol $3
	note g5  $0e
	vol $6
	note g5  $04
	note gs5 $05
	note g5  $05
	note f5  $07
	rest $03
	vol $3
	note f5  $04
	vol $6
	note ds5 $07
	rest $03
	vol $3
	note ds5 $04
	vol $6
	note d5  $07
	rest $03
	vol $3
	note d5  $04
	vol $6
	note d5  $07
	note e5  $07
	note fs5 $07
	rest $03
	vol $3
	note fs5 $04
	vol $6
	note fs5 $07
	note g5  $07
	note a5  $07
	rest $03
	vol $3
	note a5  $04
	vol $6
	note a5  $07
	note b5  $07
	note c6  $07
	note b5  $07
	note c6  $07
	note d6  $07
	note ds6 $54
	vibrato $01
	env $0 $00
	vol $3
	note ds6 $0e
	vibrato $e1
	env $0 $00
	vol $6
	note f6  $07
	note ds6 $07
	note d6  $46
	vibrato $01
	env $0 $00
	vol $3
	note d6  $1c
	vol $1
	note d6  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note c6  $07
	rest $07
	vol $3
	note c6  $07
	vol $6
	note d6  $07
	note ds6 $23
	vol $3
	note ds6 $07
	vol $6
	note c6  $0e
	note d6  $0e
	note ds6 $0e
	note d6  $07
	rest $07
	vol $3
	note d6  $07
	vol $6
	note as5 $07
	note g5  $2a
	vol $3
	note g5  $0e
	vol $6
	note g5  $1c
	note gs5 $07
	rest $07
	vol $3
	note gs5 $07
	vol $6
	note as5 $07
	note c6  $23
	vol $3
	note c6  $07
	vol $6
	note gs5 $0e
	note as5 $0e
	note c6  $0e
	note as5 $07
	rest $07
	vol $3
	note as5 $07
	vol $6
	note gs5 $07
	note g5  $2a
	vol $3
	note g5  $0e
	vol $6
	note g5  $07
	rest $03
	vol $3
	note g5  $04
	vol $6
	note gs5 $07
	note g5  $07
	note f5  $07
	rest $07
	vol $3
	note f5  $07
	vol $6
	note g5  $07
	note gs5 $23
	vol $3
	note gs5 $07
	vol $6
	note f5  $0e
	note g5  $0e
	note gs5 $0e
	note g5  $15
	vol $3
	note g5  $07
	vol $6
	note ds5 $15
	vol $3
	note ds5 $07
	vol $6
	note c6  $1c
	vol $3
	note c6  $07
	vol $6
	note c6  $07
	note d6  $07
	note ds6 $07
	note d6  $07
	rest $07
	vol $3
	note d6  $07
	vol $6
	note a5  $03
	rest $04
	note a5  $2a
	vol $3
	note a5  $0e
	vol $6
	note d6  $0e
	note c6  $0e
	note b5  $07
	rest $07
	vol $3
	note b5  $07
	vol $6
	note g5  $07
	note g6  $2a
	note f6  $0e
	note ds6 $0e
	note d6  $0e
	note ds6 $07
	rest $07
	vol $3
	note ds6 $07
	vol $6
	note f6  $07
	note g6  $23
	vol $3
	note g6  $07
	vol $6
	note ds6 $0e
	note f6  $0e
	note g6  $0e
	note f6  $07
	rest $07
	vol $3
	note f6  $07
	vol $6
	note ds6 $07
	note d6  $2a
	vol $3
	note d6  $0e
	vol $6
	note d6  $1c
	note c6  $07
	rest $07
	vol $3
	note c6  $07
	vol $6
	note d6  $07
	note ds6 $23
	vol $3
	note ds6 $07
	vol $6
	note c6  $07
	note d6  $07
	note ds6 $07
	note f6  $07
	note g6  $07
	note gs6 $07
	note as6 $38
	vibrato $01
	env $0 $00
	vol $3
	note as6 $0e
	vol $1
	note as6 $0e
	vibrato $e1
	env $0 $00
	vol $6
	note as5 $1c
	vol $6
	note gs5 $07
	rest $07
	vol $3
	note gs5 $07
	vol $6
	note as5 $07
	note c6  $23
	vol $3
	note c6  $07
	vol $6
	note gs5 $0e
	note as5 $0e
	note c6  $0e
	note g5  $0e
	note fs5 $07
	note g5  $07
	note a5  $0e
	note g5  $07
	note a5  $07
	note b5  $0e
	note a5  $07
	note b5  $07
	note c6  $0e
	vol $6
	note b5  $07
	note c6  $07
	note d6  $2a
	vol $3
	note d6  $0e
	vol $6
	note g6  $23
	note f6  $07
	note ds6 $07
	note d6  $07
	note c6  $38
	vibrato $01
	env $0 $00
	vol $3
	note c6  $1c
	vol $1
	note c6  $0e
	rest $0e
	vibrato $e1
	env $0 $00
	goto musicf92ff
	cmdff

sound2aChannel0:
	vol $0
	note gs3 $5a
	vibrato $e1
	env $0 $00
	duty $01
	vol $6
	note e3  $09
	note f3  $09
	note g3  $09
	rest $04
	vol $3
	note g3  $05
	vol $6
	note g3  $09
	note a3  $09
	note as3 $12
	note a3  $06
	note as3 $06
	note a3  $06
	note g3  $12
	note f3  $12
	note e3  $12
	note d3  $12
	note c3  $12
	note d3  $12
	note e3  $09
	rest $04
	vol $3
	note e3  $09
	rest $05
	vol $6
	note d3  $09
	note e3  $90
	vol $4
	note e3  $24
	vol $2
	note e3  $24
	vol $6
	note gs3 $06
	note as3 $06
	note c4  $06
	note d4  $06
	note ds4 $06
	note f4  $06
	note g4  $09
	rest $04
	vol $3
	note g4  $09
	rest $05
	vol $6
	note f4  $09
	note ds4 $48
	vol $3
	note ds4 $12
	vol $6
	note ds4 $09
	note f4  $09
	note ds4 $12
	note f4  $12
	note g4  $12
	note gs4 $12
	note as4 $12
	note gs4 $12
	note as4 $12
	note c5  $12
	duty $02
	note b4  $08
	rest $04
	vol $3
	note b4  $08
	rest $04
	vol $1
	note b4  $08
	vol $6
	note g4  $20
	vol $3
	note g4  $0e
	vol $6
	note d4  $03
	rest $04
	note d4  $03
	rest $04
	note g4  $0e
	note d4  $03
	rest $04
	note d4  $03
	rest $04
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note d3  $07
	note e3  $07
	note f3  $07
	note g3  $07
	note a3  $07
	note as3 $07
	note b3  $07
	note a3  $07
	note b3  $07
	note c4  $07
	note d4  $07
	note e4  $07
	note f4  $07
	note g4  $07
musicf96e3:
	rest $38
	vibrato $e1
	env $0 $00
	note c4  $07
	rest $03
	vol $3
	note c4  $07
	rest $04
	vol $1
	note c4  $07
	vol $6
	note g3  $2a
	vibrato $01
	env $0 $00
	vol $3
	note g3  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note c4  $07
	note d4  $07
	note e4  $07
	note f4  $07
	note g4  $2a
	vibrato $01
	env $0 $00
	vol $3
	note g4  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note g4  $25
	note gs4 $09
	note g4  $0a
	note f4  $09
	note g4  $09
	note f4  $0a
	note ds4 $09
	note f4  $09
	note ds4 $0a
	note d4  $07
	rest $07
	vol $3
	note d4  $07
	vol $6
	note c4  $07
	note as3 $0e
	note ds4 $07
	note f4  $07
	note g4  $0e
	note ds4 $0e
	note as3 $0e
	note g3  $0e
	rest $2a
	note gs3 $07
	note as3 $07
	note c4  $38
	rest $2a
	note ds4 $07
	note d4  $07
	note ds4 $38
	note a3  $38
	note b3  $1c
	note c4  $1c
	note d4  $0a
	rest $04
	vibrato $00
	env $0 $02
	note g4  $03
	rest $01
	vol $5
	note g4  $04
	rest $01
	vol $4
	note g4  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note g4  $0e
	vibrato $00
	env $0 $02
	note c5  $03
	rest $01
	vol $5
	note c5  $04
	rest $01
	vol $4
	note c5  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note c5  $0e
	vibrato $00
	env $0 $02
	note d5  $03
	rest $01
	vol $5
	note d5  $04
	rest $01
	vol $4
	note d5  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note d5  $0e
	vibrato $00
	env $0 $02
	note g5  $03
	rest $01
	vol $5
	note g5  $04
	rest $01
	vol $4
	note g5  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note g5  $0e
	vibrato $00
	env $0 $02
	note d5  $03
	rest $01
	vol $5
	note d5  $04
	rest $01
	vol $4
	note d5  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note d5  $0e
	vibrato $00
	env $0 $02
	note c5  $03
	rest $01
	vol $5
	note c5  $04
	rest $01
	vol $4
	note c5  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note c5  $0e
	vibrato $00
	env $0 $02
	note g4  $03
	rest $01
	vol $5
	note g4  $04
	rest $01
	vol $4
	note g4  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note g4  $0e
	vibrato $00
	env $0 $02
	note d4  $03
	rest $01
	vol $5
	note d4  $04
	rest $01
	vol $4
	note d4  $03
	rest $3a
	vibrato $e1
	env $0 $00
	vol $6
	note e4  $1c
	note c4  $1c
	note g3  $15
	note c4  $03
	rest $04
	note c4  $07
	note d4  $07
	note e4  $07
	note f4  $07
	note g4  $2a
	vibrato $01
	env $0 $00
	vol $3
	note g4  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note g4  $2a
	note gs4 $07
	note g4  $07
	note f4  $0e
	note g4  $07
	note f4  $07
	note ds4 $0e
	note f4  $07
	note ds4 $07
	note d4  $07
	rest $07
	vol $3
	note d4  $07
	vol $6
	note c4  $07
	note as3 $07
	rest $03
	vol $3
	note as3 $04
	vol $6
	note ds4 $07
	note f4  $07
	note g4  $0e
	note ds4 $0e
	note as3 $0e
	note g3  $0e
	rest $2a
	note gs3 $07
	note as3 $07
	note c4  $1c
	vol $3
	note c4  $1c
	rest $2a
	vol $6
	note c4  $07
	note d4  $07
	note ds4 $1c
	vol $3
	note ds4 $1c
	rest $1c
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $04
	vol $6
	note d4  $07
	note e4  $07
	note fs4 $07
	rest $03
	vol $3
	note fs4 $04
	vol $6
	note fs4 $07
	note gs4 $07
	note a4  $07
	note gs4 $07
	note a4  $07
	note b4  $07
	note g3  $07
	note fs3 $07
	note g3  $07
	note a3  $07
	note b3  $07
	note a3  $07
	note b3  $07
	note c4  $07
	note d4  $07
	note cs4 $07
	note d4  $07
	note ds4 $07
	note f4  $07
	note e4  $07
	note f4  $07
	note g4  $07
	vol $6
	note gs4 $07
	note g4  $07
	note gs4 $07
	note as4 $07
	note c5  $07
	note b4  $07
	note c5  $07
	note d5  $07
	note ds5 $07
	note d5  $07
	note ds5 $07
	note f5  $07
	note g5  $03
	rest $04
	note g5  $07
	note a5  $07
	note b5  $07
	note ds5 $07
	rest $07
	vol $3
	note ds5 $07
	vol $6
	note f5  $07
	note g5  $1c
	vol $3
	note g5  $0e
	vol $6
	note ds5 $0e
	note f5  $0e
	note g5  $0e
	note f5  $07
	rest $07
	vol $3
	note f5  $07
	vol $6
	note d5  $07
	note as4 $0e
	note d5  $07
	note ds5 $07
	note f5  $0e
	note d5  $0e
	vol $6
	note as4 $0e
	note d5  $0e
	note c5  $38
	note d5  $1c
	note c5  $1c
	note d5  $07
	rest $07
	vol $3
	note d5  $07
	vol $6
	note c5  $07
	note as4 $0e
	note d5  $07
	note c5  $07
	note d5  $0e
	note as4 $0e
	note g4  $0e
	note d4  $0e
	note f4  $1c
	vol $3
	note f4  $0e
	vol $6
	note gs4 $07
	note g4  $07
	note gs4 $0e
	note g4  $0e
	note f4  $0e
	note g4  $07
	note gs4 $07
	note g4  $07
	note f4  $07
	note ds4 $1c
	note e4  $07
	note ds4 $07
	note d4  $07
	note cs4 $07
	note c4  $07
	rest $03
	vol $3
	note c4  $04
	vol $6
	note c4  $07
	note b3  $07
	note as3 $0e
	note a3  $1c
	vol $3
	note a3  $0e
	vibrato $00
	env $0 $02
	vol $6
	note d4  $03
	rest $01
	note d4  $04
	rest $01
	note d4  $03
	rest $02
	vibrato $e1
	env $0 $00
	note fs4 $0e
	note a4  $0e
	note fs5 $0e
	note ds5 $0e
	note g3  $07
	note gs3 $07
	note g3  $07
	note fs3 $07
	note g3  $07
	note a3  $07
	note b3  $07
	note c4  $07
	note d4  $07
	note ds4 $07
	note d4  $07
	note cs4 $07
	note d4  $07
	note ds4 $07
	note f4  $07
	note fs4 $07
	note g4  $23
	rest $07
	note g4  $03
	rest $04
	note g4  $03
	rest $04
	note g4  $2a
	vibrato $01
	env $0 $00
	vol $3
	note g4  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note g4  $1c
	vol $3
	note g4  $0e
	vol $6
	note g4  $07
	note c5  $07
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note g4  $0e
	note gs4 $0e
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note g4  $38
	note f4  $1c
	note c5  $1c
	note as4 $1c
	vol $3
	note as4 $0e
	vol $6
	note as4 $07
	note c5  $07
	note cs5 $07
	note c5  $07
	note as4 $07
	note gs4 $07
	note g4  $07
	note f4  $07
	note e4  $07
	note g4  $07
	note f4  $07
	rest $07
	vol $3
	note f4  $07
	vol $6
	note g4  $07
	note gs4 $0e
	note f4  $07
	note g4  $07
	note gs4 $07
	rest $03
	vol $3
	note gs4 $04
	vol $6
	note f4  $0e
	note g4  $0e
	note gs4 $0e
	note g4  $0e
	note fs4 $07
	note f4  $07
	note e4  $0e
	note ds4 $07
	note d4  $07
	note cs4 $0e
	note c4  $07
	note b3  $07
	note as3 $0e
	note a3  $07
	note gs3 $07
	note f3  $18
	rest $04
	note f3  $09
	note g3  $09
	note gs3 $0a
	note g3  $0e
	vol $3
	note g3  $0e
	vol $6
	note g3  $09
	note a3  $09
	note b3  $0a
	note c4  $0e
	vol $3
	note c4  $0e
	vol $6
	note g3  $0a
	rest $04
	note g3  $03
	rest $04
	note g3  $03
	rest $04
	note c4  $1c
	vibrato $01
	env $0 $00
	vol $3
	note c4  $0e
	rest $0e
	vibrato $e1
	env $0 $00
	goto musicf96e3
	cmdff

sound2aChannel4:
	rest $09
	duty $0f
	note c4  $04
	rest $17
	note as3 $09
	note c4  $b4
	rest $12
	note c4  $04
	rest $0e
	note c4  $04
	rest $0e
	note c4  $04
	rest $05
	duty $06
	note as2 $51
	rest $09
	note as2 $09
	note a2  $09
	note as2 $12
	note a2  $09
	note g2  $09
	note a2  $12
	note g2  $09
	note f2  $09
	note g2  $12
	note f2  $09
	note e2  $09
	note d2  $09
	note e2  $09
	note f2  $09
	note g2  $09
	note f2  $09
	note g2  $09
	note gs2 $09
	note as2 $09
	note gs2 $2d
	note c3  $09
	note ds3 $09
	note g3  $09
	note gs3 $09
	note g3  $09
	note gs3 $09
	note as3 $09
	note c4  $09
	note as3 $09
	note c4  $09
	note d4  $09
	note ds4 $09
	note d4  $09
	note c4  $09
	note as3 $09
	note gs3 $09
	note g3  $09
	note f3  $09
	note ds3 $09
	note d3  $09
	note c3  $09
	note as2 $09
	note gs2 $09
	note g2  $09
	note f2  $09
	note ds2 $09
	note d2  $09
	note g2  $10
	duty $0f
	note g2  $08
	rest $08
	duty $06
	note g2  $10
	duty $0f
	note g2  $08
	rest $08
	duty $06
	note a2  $0e
	duty $0f
	note a2  $07
	rest $07
	duty $06
	note a2  $0e
	duty $0f
	note a2  $07
	rest $07
	duty $06
	note as2 $0e
	duty $0f
	note as2 $07
	rest $07
	duty $06
	note as2 $0e
	duty $0f
	note as2 $07
	rest $07
	duty $06
	note b2  $0e
	duty $0f
	note b2  $07
	rest $07
	duty $06
	note g2  $15
	duty $0f
	note g2  $07
musicf9b43:
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note gs2 $07
	duty $0f
	note gs2 $07
	rest $0e
	duty $04
	note gs2 $07
	duty $0f
	note gs2 $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note g2  $1c
	duty $0f
	note g2  $07
	rest $07
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	rest $07
	duty $04
	note g2  $0e
	duty $0f
	note g2  $07
	rest $07
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	rest $07
	duty $04
	note g2  $11
	duty $0f
	note g2  $07
	rest $04
	duty $04
	note g2  $11
	duty $0f
	note g2  $07
	rest $04
	duty $04
	note a2  $11
	duty $0f
	note a2  $07
	rest $04
	duty $04
	note b2  $11
	duty $0f
	note b2  $07
	rest $04
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note g2  $07
	duty $0f
	note g2  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note g2  $07
	duty $0f
	note g2  $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note f2  $07
	duty $0f
	note f2  $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note f2  $07
	duty $0f
	note f2  $07
	rest $0e
	duty $04
	note gs2 $07
	duty $0f
	note gs2 $07
	rest $0e
	duty $04
	note gs2 $18
	duty $0f
	note gs2 $04
	duty $04
	note as2 $07
	rest $15
	note as2 $18
	duty $0f
	note as2 $04
	duty $04
	note ds3 $07
	duty $0f
	note ds3 $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note ds3 $07
	duty $0f
	note ds3 $07
	rest $0e
	duty $04
	note ds3 $1c
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note gs2 $07
	duty $0f
	note gs2 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $1c
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $18
	duty $0f
	note c3  $04
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note a2  $07
	duty $0f
	note a2  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note a2  $03
	duty $0f
	note a2  $04
	rest $07
	duty $04
	note a2  $07
	note gs2 $07
	note g2  $1c
	duty $0f
	note g2  $07
	rest $07
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	rest $07
	duty $04
	note g2  $11
	duty $0f
	note g2  $04
	rest $07
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	rest $07
	duty $04
	note g2  $1c
	note a2  $1c
	note as2 $1c
	note b2  $1c
	note c3  $1c
	duty $0f
	note c3  $07
	rest $07
	duty $04
	note c3  $03
	duty $0f
	note c3  $04
	duty $04
	note c3  $03
	duty $0f
	note c3  $04
	duty $04
	note c3  $03
	duty $0f
	note c3  $04
	rest $07
	duty $04
	note c3  $11
	duty $0f
	note c3  $07
	rest $04
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	duty $04
	note g2  $1c
	duty $0f
	note g2  $07
	rest $07
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	rest $07
	duty $04
	note g2  $11
	duty $0f
	note g2  $07
	rest $04
	duty $04
	note g2  $07
	duty $0f
	note g2  $07
	duty $04
	note gs2 $1c
	duty $0f
	note gs2 $07
	rest $07
	duty $04
	note gs2 $03
	duty $0f
	note gs2 $04
	duty $04
	note gs2 $03
	duty $0f
	note gs2 $04
	duty $04
	note as2 $03
	duty $0f
	note as2 $04
	rest $07
	duty $04
	note as2 $11
	duty $0f
	note as2 $07
	rest $04
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note ds2 $1c
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $1c
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note g2  $18
	duty $0f
	note g2  $04
	duty $04
	note a2  $18
	duty $0f
	note a2  $04
	duty $04
	note as2 $18
	duty $0f
	note as2 $04
	duty $04
	note b2  $18
	duty $0f
	note b2  $04
	duty $04
	note c3  $1f
	duty $0f
	note c3  $07
	rest $04
	duty $04
	note c3  $03
	duty $0f
	note c3  $04
	duty $04
	note c3  $03
	duty $0f
	note c3  $04
	duty $04
	note c3  $03
	duty $0f
	note c3  $04
	rest $07
	duty $04
	note c3  $15
	duty $0f
	note c3  $07
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	duty $04
	note as2 $1f
	duty $0f
	note as2 $07
	rest $04
	duty $04
	note as2 $03
	duty $0f
	note as2 $04
	duty $04
	note as2 $03
	duty $0f
	note as2 $04
	duty $04
	note as2 $03
	duty $0f
	note as2 $04
	rest $07
	duty $04
	note as2 $15
	duty $0f
	note as2 $07
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	duty $04
	note gs2 $1f
	duty $0f
	note gs2 $07
	rest $04
	duty $04
	note gs2 $03
	duty $0f
	note gs2 $04
	duty $04
	note gs2 $03
	duty $0f
	note gs2 $04
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	duty $04
	note as2 $11
	duty $0f
	note as2 $07
	rest $04
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	duty $04
	note g2  $1f
	duty $0f
	note g2  $07
	rest $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note cs3 $03
	duty $0f
	note cs3 $04
	rest $07
	duty $04
	note cs3 $11
	duty $0f
	note cs3 $07
	rest $04
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	duty $04
	note f2  $07
	duty $0f
	note f2  $07
	rest $0e
	duty $04
	note f2  $07
	duty $0f
	note f2  $07
	rest $0e
	duty $04
	note f2  $07
	duty $0f
	note f2  $07
	rest $0e
	duty $04
	note f2  $15
	duty $0f
	note f2  $07
	duty $04
	note c3  $1c
	note b2  $1c
	note as2 $1c
	note a2  $1c
	note gs2 $15
	duty $0f
	note gs2 $07
	duty $04
	note gs2 $15
	duty $0f
	note gs2 $07
	duty $04
	note g2  $18
	duty $0f
	note g2  $04
	duty $04
	note g2  $18
	duty $0f
	note g2  $04
	duty $04
	note c3  $0a
	duty $0f
	note c3  $07
	rest $0b
	duty $04
	note g2  $0a
	duty $0f
	note g2  $07
	rest $0b
	duty $04
	note c3  $1c
	duty $0f
	note c3  $07
	rest $15
	goto musicf9b43
	cmdff

sound2aChannel6:
	rest $ff
	rest $ff
	rest $ff
	rest $db
	vol $4
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $0e
	vol $3
	note $26 $04
	vol $3
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $03
	vol $3
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	note $26 $03
	vol $3
	note $26 $04
	vol $3
	note $26 $03
	vol $4
	note $26 $04
musicfa0d2:
	vol $3
	note $26 $1c
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $2a
	vol $3
	note $26 $04
	vol $3
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $0e
	note $26 $1c
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $04
	vol $2
	note $26 $05
	vol $3
	note $26 $05
	vol $3
	note $26 $04
	vol $3
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $0e
	note $26 $04
	vol $3
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $04
	vol $3
	note $26 $05
	note $26 $05
	note $26 $04
	vol $3
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $2a
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $2a
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $2a
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $2a
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $0e
	vol $3
	note $26 $03
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	note $26 $03
	vol $3
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $0e
	vol $3
	note $26 $04
	vol $3
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	vol $4
	note $26 $03
	vol $3
	note $26 $04
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $0e
	note $26 $1c
	goto musicfa0d2
	cmdff

sound2eStart:

sound2eChannel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicfa410:
	vol $6
	note b4  $0c
	note e4  $06
	note b4  $0c
	note e4  $06
	note b4  $24
	vol $3
	note b4  $18
	vol $6
	note as4 $0c
	note fs4 $06
	note as4 $0c
	note fs4 $06
	note as4 $24
	vol $3
	note as4 $18
	vol $6
	note b4  $0c
	note e4  $06
	note b4  $0c
	note e4  $06
	note b4  $24
	vol $3
	note b4  $18
	vol $6
	note as4 $06
	note b4  $06
	rest $03
	vol $3
	note b4  $03
	vol $6
	note c5  $06
	note cs5 $06
	rest $03
	vol $3
	note cs5 $03
	vol $6
	note d5  $06
	note ds5 $06
	rest $03
	vol $3
	note ds5 $03
	vol $6
	note e5  $06
	note f5  $06
	rest $03
	vol $3
	note f5  $03
	vol $6
	note fs5 $06
	note g5  $06
	note gs5 $06
	note a5  $06
	note b4  $0c
	note e4  $06
	note b4  $0c
	note e4  $06
	note b4  $24
	vol $3
	note b4  $18
	vol $6
	note as4 $0c
	note fs4 $06
	note as4 $0c
	note fs4 $06
	note as4 $24
	vol $3
	note as4 $18
	vol $6
	note b4  $0c
	note e4  $06
	note b4  $0c
	note e4  $06
	note b4  $24
	vol $3
	note b4  $18
	vol $6
	note a4  $06
	note as4 $06
	rest $03
	vol $3
	note as4 $03
	vol $6
	note b4  $06
	note c5  $06
	vol $6
	note cs5 $06
	note d5  $06
	note ds5 $06
	note e5  $1e
	vol $3
	note e5  $0c
	rest $06
	vol $6
	note c5  $12
	note g4  $12
	note c5  $0c
	note b4  $12
	note fs4 $06
	rest $03
	vol $3
	note fs4 $06
	rest $03
	vol $1
	note fs4 $06
	rest $06
	vol $6
	note c5  $12
	vol $6
	note g4  $12
	note c5  $0c
	note cs5 $12
	note gs5 $06
	rest $03
	vol $3
	note gs5 $06
	rest $03
	vol $1
	note gs5 $06
	rest $06
	vol $6
	note c5  $12
	note g4  $12
	note c5  $0c
	note b4  $18
	note ds5 $18
	note d5  $06
	note cs5 $06
	rest $03
	vol $3
	note cs5 $03
	vol $6
	note c5  $06
	note b4  $06
	rest $03
	vol $3
	note b4  $03
	vol $6
	note as4 $06
	note a4  $06
	rest $03
	vol $3
	note a4  $03
	vol $6
	note gs4 $06
	note g4  $06
	rest $03
	vol $3
	note g4  $03
	vol $6
	note g4  $06
	note fs4 $06
	note f4  $06
	note e4  $06
	note ds4 $48
	vol $3
	note ds4 $18
	rest $60
	goto musicfa410
	cmdff

sound2eChannel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicfa52d:
	vol $6
	note g4  $0c
	note b3  $06
	note g4  $0c
	note b3  $06
	note g4  $18
	note b3  $0c
	note e4  $0c
	note g4  $0c
	note fs4 $0c
	note as3 $06
	note fs4 $0c
	note as3 $06
	note fs4 $18
	note as4 $0c
	note a4  $0c
	note gs4 $0c
	note g4  $0c
	note b3  $06
	note g4  $0c
	note b3  $06
	note g4  $24
	vol $3
	note g4  $18
	vol $6
	note d4  $06
	note cs4 $06
	rest $03
	vol $3
	note cs4 $03
	vol $6
	note c4  $06
	note b3  $06
	rest $03
	vol $3
	note b3  $03
	vol $6
	note as3 $06
	note a3  $06
	rest $03
	vol $3
	note a3  $03
	vol $6
	note gs3 $06
	note g3  $06
	rest $03
	vol $3
	note g3  $03
	vol $6
	note fs3 $06
	note f3  $06
	note e3  $06
	note d3  $06
	note g4  $0c
	note b3  $06
	note g4  $0c
	note b3  $06
	note g4  $18
	note b3  $0c
	note e4  $0c
	note g4  $0c
	note fs4 $0c
	note as3 $06
	note fs4 $0c
	note as3 $06
	note fs4 $18
	note as4 $0c
	note a4  $0c
	note gs4 $0c
	note g4  $0c
	note b3  $06
	note g4  $0c
	note b3  $06
	note g4  $18
	note b3  $0c
	note e4  $0c
	note g4  $0c
	rest $60
	note g4  $12
	note e4  $12
	note g4  $0c
	note fs4 $12
	note ds4 $06
	rest $03
	vol $3
	note ds4 $06
	rest $03
	vol $1
	note ds4 $06
	rest $06
	vol $6
	note g4  $12
	note e4  $12
	note g4  $0c
	note fs4 $12
	note b4  $06
	rest $03
	vol $3
	note b4  $06
	rest $03
	vol $1
	note b4  $06
	rest $06
	vol $6
	note g4  $12
	note e4  $12
	note c4  $0c
	note b3  $0c
	note ds4 $0c
	note fs4 $0c
	note b4  $0c
	rest $60
	note ds4 $06
	note d4  $06
	rest $03
	vol $3
	note d4  $03
	vol $6
	note cs4 $06
	note c4  $06
	rest $03
	vol $3
	note c4  $03
	vol $6
	note b3  $06
	note as3 $06
	rest $03
	vol $3
	note as3 $03
	vol $6
	note a3  $06
	note gs3 $06
	rest $03
	vol $3
	note gs3 $03
	vol $6
	note g3  $06
	note fs3 $06
	note f3  $06
	note e3  $06
	rest $60
	goto musicfa52d
	cmdff

sound2eChannel4:
	cmdf2
musicfa633:
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note b3  $04
	duty $17
	note b3  $02
	duty $12
	note as3 $04
	duty $17
	note as3 $08
	duty $12
	note a3  $04
	duty $17
	note a3  $02
	duty $12
	note gs3 $04
	duty $17
	note gs3 $08
	duty $12
	note g3  $04
	duty $17
	note g3  $02
	duty $12
	note fs3 $04
	duty $17
	note fs3 $08
	duty $12
	note f3  $04
	duty $17
	note f3  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $08
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note d3  $04
	duty $17
	note d3  $02
	duty $12
	note cs3 $04
	duty $17
	note cs3 $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note as2 $04
	duty $17
	note as2 $08
	duty $12
	note a2  $04
	duty $17
	note a2  $02
	duty $12
	note gs2 $04
	duty $17
	note gs2 $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note f2  $04
	duty $17
	note f2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $08
	duty $12
	note f2  $04
	duty $17
	note f2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $08
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note d2  $04
	duty $17
	note d2  $08
	duty $12
	note cs2 $04
	duty $17
	note cs2 $02
	duty $12
	note c2  $04
	duty $17
	note c2  $08
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note ds3 $05
	duty $17
	note ds3 $13
	duty $12
	note b1  $48
	rest $60
	goto musicfa633
	cmdff

sound2eChannel6:
	cmdf2
musicfabfe:
	vol $5
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $5
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $4
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $4
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $2
	note $2a $06
	note $2a $0c
	note $2a $06
	note $2a $0c
	note $2a $06
	note $2a $0c
	vol $2
	note $2a $06
	note $2a $0c
	note $2a $06
	note $2a $06
	note $2a $06
	note $2a $06
	goto musicfabfe
	cmdff

sound3aChannel1:
	cmdff

sound3aChannel0:
	cmdff

sound3aChannel4:
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff

sound28Channel1:
	vibrato $00
	env $0 $00
	duty $01
musicfaffc:
	vol $0
	note gs3 $24
	vol $6
	note f4  $09
	rest $04
	vol $3
	note f4  $09
	rest $05
	vol $1
	note f4  $09
	rest $24
	vol $6
	note f4  $09
	rest $04
	vol $3
	note f4  $09
	rest $05
	vol $1
	note f4  $09
	rest $24
	vol $6
	note f4  $09
	rest $04
	vol $3
	note f4  $09
	rest $05
	vol $1
	note f4  $09
	vibrato $00
	env $0 $03
	duty $02
	vol $6
	note f5  $12
	note f5  $12
	note fs5 $12
	rest $36
	duty $01
	vibrato $00
	env $0 $00
	note f4  $09
	rest $04
	vol $3
	note f4  $09
	rest $05
	vol $1
	note f4  $09
	rest $24
	vol $6
	note f4  $09
	rest $04
	vol $3
	note f4  $09
	rest $05
	vol $1
	note f4  $09
	rest $24
	vol $6
	note f4  $09
	rest $04
	vol $3
	note f4  $09
	rest $05
	vol $1
	note f4  $09
	vibrato $00
	env $0 $03
	duty $02
	vol $6
	note f5  $12
	note f5  $12
	note fs5 $12
	rest $12
	vibrato $e1
	env $0 $00
	duty $01
	note e4  $36
	note d4  $12
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $1
	note c4  $09
	vol $6
	note b3  $09
	rest $04
	vol $3
	note b3  $09
	rest $05
	vol $1
	note b3  $09
	vol $6
	note as3 $48
	note a3  $09
	rest $04
	vol $3
	note a3  $09
	rest $05
	vol $1
	note a3  $09
	rest $24
	vol $6
	note gs3 $48
	note g3  $09
	rest $04
	vol $3
	note g3  $09
	rest $05
	vol $1
	note g3  $09
	rest $24
	vol $6
	note f3  $09
	rest $04
	vol $3
	note f3  $09
	rest $05
	vol $1
	note f3  $09
	vol $6
	note f3  $09
	note fs3 $09
	note f3  $09
	note fs3 $09
	rest $04
	vol $3
	note fs3 $09
	rest $05
	vol $6
	note f4  $09
	note fs4 $09
	note f4  $09
	note fs4 $09
	rest $04
	vol $3
	note fs4 $09
	rest $05
	vol $6
	note g4  $12
	note a4  $09
	note g4  $09
	note f4  $24
	note fs4 $09
	rest $04
	vol $3
	note fs4 $09
	rest $05
	vol $1
	note fs4 $09
	rest $24
	goto musicfaffc
	cmdff

sound28Channel0:
	vibrato $00
	env $0 $00
	duty $01
musicfb10b:
	vol $0
	note gs3 $24
	vol $6
	note d4  $09
	rest $04
	vol $3
	note d4  $09
	rest $05
	vol $1
	note d4  $09
	rest $24
	vol $6
	note d4  $09
	rest $04
	vol $3
	note d4  $09
	rest $05
	vol $1
	note d4  $09
	rest $24
	vol $6
	note d4  $09
	rest $04
	vol $3
	note d4  $09
	rest $05
	vol $1
	note d4  $09
	env $0 $03
	duty $02
	vol $6
	note d5  $12
	note d5  $12
	note ds5 $12
	rest $36
	vibrato $00
	env $0 $00
	duty $01
	note d4  $09
	rest $04
	vol $3
	note d4  $09
	rest $05
	vol $1
	note d4  $09
	rest $24
	vol $6
	note d4  $09
	rest $04
	vol $3
	note d4  $09
	rest $05
	vol $1
	note d4  $09
	rest $24
	vol $6
	note d4  $09
	rest $04
	vol $3
	note d4  $09
	rest $05
	vol $1
	note d4  $09
	vibrato $00
	env $0 $03
	duty $02
	vol $6
	note d5  $12
	note d5  $12
	note ds5 $12
	rest $ff
	rest $ff
	rest $e4
	vibrato $00
	env $0 $00
	duty $01
	goto musicfb10b
	cmdff

sound28Channel4:
musicfb193:
	duty $0e
	note b2  $24
	note f3  $12
	note fs3 $12
	note a3  $24
	note gs3 $12
	note g3  $12
	note f3  $24
	note fs3 $09
	duty $0f
	note fs3 $09
	rest $5a
	duty $0e
	note b2  $24
	note f3  $12
	note fs3 $12
	note a3  $09
	duty $0f
	note a3  $09
	duty $0e
	note a3  $12
	note gs3 $12
	note g3  $12
	note f3  $24
	note fs3 $09
	duty $0f
	note fs3 $09
	rest $5a
	duty $0e
	note g3  $36
	note fs3 $12
	note e3  $09
	duty $0f
	note e3  $09
	rest $12
	duty $0e
	note d3  $09
	duty $0f
	note d3  $09
	rest $12
	duty $0e
	note c3  $48
	note b2  $12
	rest $36
	note as2 $48
	note a2  $12
	rest $36
	note gs2 $48
	note fs2 $36
	duty $0f
	note fs2 $12
	duty $0e
	note c3  $31
	note b2  $05
	note as2 $04
	note a2  $05
	note gs2 $04
	note g2  $05
	note fs2 $09
	duty $0f
	note fs2 $09
	rest $12
	duty $0e
	note f2  $03
	note fs2 $09
	duty $0f
	note fs2 $09
	rest $0f
	duty $0e
	goto musicfb193
	cmdff

sound29Start:

sound29Channel1:
	vibrato $e1
	env $0 $00
	duty $02
	vol $6
	note g4  $18
	vol $3
	note g4  $08
	vol $6
	note g4  $0a
	note d4  $0b
	note g4  $0b
	note f4  $18
	vol $3
	note f4  $08
	vol $6
	note f4  $0a
	note g4  $0b
	note a4  $0b
	note as4 $18
	vol $3
	note as4 $08
	vol $6
	note as4 $0a
	note g4  $0b
	note as4 $0b
	note a4  $18
	vol $3
	note a4  $08
	vol $6
	note a4  $0a
	note as4 $0b
	note c5  $0b
	note d5  $40
	vibrato $01
	vol $3
	note d5  $20
	vibrato $e1
	vol $6
	note c5  $08
	rest $02
	note c5  $08
	rest $02
	note c5  $09
	rest $03
	note d5  $50
	vibrato $01
	vol $3
	note d5  $10
	vibrato $e1
	vol $6
	note c5  $0a
	note b4  $0b
	note a4  $0b
musicfb27e:
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $04
	vol $1
	note g4  $08
	vol $6
	note d4  $20
	vol $3
	note d4  $10
	vol $6
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note g4  $08
	note a4  $08
	note b4  $08
	note c5  $08
	note d5  $40
	vibrato $01
	vol $3
	note d5  $10
	vibrato $e1
	vol $6
	note d5  $08
	rest $04
	vol $3
	note d5  $04
	vol $6
	note d5  $0a
	note ds5 $0b
	note f5  $0b
	note g5  $40
	vibrato $01
	vol $3
	note g5  $10
	vibrato $e1
	vol $6
	note g5  $10
	note f5  $10
	note ds5 $10
	note f5  $08
	rest $04
	vol $3
	note f5  $08
	rest $04
	vol $6
	note ds5 $08
	note d5  $28
	vibrato $01
	vol $3
	note d5  $18
	vibrato $e1
	vol $6
	note d5  $0a
	note ds5 $0b
	note d5  $0b
	note c5  $08
	rest $04
	vol $3
	note c5  $04
	vol $6
	note c5  $08
	note d5  $08
	vol $6
	note ds5 $28
	vol $3
	note ds5 $08
	vol $6
	note ds5 $10
	note d5  $10
	note c5  $10
	note as4 $08
	rest $04
	vol $3
	note as4 $04
	vol $6
	note as4 $08
	note c5  $08
	note d5  $20
	vol $3
	note d5  $10
	vol $6
	note d5  $10
	note c5  $10
	note as4 $10
	note a4  $08
	rest $04
	vol $3
	note a4  $04
	vol $6
	note a4  $08
	note b4  $08
	note cs5 $20
	vibrato $01
	vol $3
	note cs5 $10
	vibrato $e1
	vol $6
	note cs5 $08
	note d5  $08
	note e5  $08
	note fs5 $08
	note g5  $08
	note a5  $08
	note fs5 $08
	rest $04
	vol $3
	note fs5 $04
	vol $6
	note d5  $02
	rest $02
	note d5  $04
	rest $02
	note d5  $02
	rest $04
	note e5  $08
	rest $02
	note e5  $08
	rest $02
	note e5  $09
	rest $03
	note fs5 $28
	vibrato $01
	vol $3
	note fs5 $18
	vibrato $e1
	vol $6
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $04
	vol $1
	note g4  $08
	vol $6
	note d4  $28
	vol $3
	note d4  $08
	vol $6
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note g4  $08
	note a4  $08
	note b4  $08
	note c5  $08
	note d5  $40
	vibrato $01
	vol $3
	note d5  $10
	vibrato $e1
	vol $6
	note d5  $08
	rest $04
	vol $3
	note d5  $04
	vol $6
	note d5  $0a
	note ds5 $0b
	note f5  $0b
	note g5  $48
	vibrato $01
	vol $3
	note g5  $08
	vibrato $e1
	vol $6
	note a5  $08
	note as5 $08
	note c6  $08
	note as5 $08
	note a5  $08
	note g5  $08
	note g5  $08
	rest $04
	vol $3
	note g5  $08
	rest $04
	vol $6
	note a5  $08
	note f5  $28
	vibrato $01
	env $0 $00
	vol $3
	note f5  $18
	vibrato $e1
	vol $6
	note d5  $0a
	note ds5 $0b
	note d5  $0b
	note c5  $08
	rest $04
	vol $3
	note c5  $04
	vol $6
	note c5  $08
	note d5  $08
	note ds5 $28
	vol $3
	note ds5 $08
	vol $6
	note ds5 $10
	note d5  $10
	note c5  $10
	note as4 $0a
	note a4  $0b
	note as4 $0b
	note c5  $0a
	note as4 $0b
	note c5  $0b
	note d5  $08
	rest $04
	vol $3
	note d5  $08
	rest $01
	vol $6
	note cs5 $08
	rest $03
	note d5  $0a
	note g5  $0b
	note as5 $0b
	rest $20
	note d5  $20
	note d6  $28
	note c6  $08
	note as5 $08
	note a5  $08
	note g5  $40
	vibrato $01
	vol $3
	note g5  $20
	vibrato $e1
	duty $00
	vol $8
	note d5  $0a
	note ds5 $0b
	note f5  $0b
	note g5  $08
	rest $04
	vol $3
	note g5  $08
	rest $04
	vol $1
	note g5  $08
	vol $8
	note d5  $20
	vibrato $01
	vol $3
	note d5  $18
	vibrato $e1
	vol $8
	note g5  $04
	rest $04
	note g5  $08
	note a5  $08
	note as5 $08
	note c6  $08
	note a5  $08
	rest $04
	vol $3
	note a5  $08
	rest $04
	vol $8
	note f5  $08
	note c5  $20
	vol $3
	note c5  $10
	vol $8
	note c5  $08
	note d5  $08
	note f5  $08
	note ds5 $08
	note d5  $08
	note c5  $08
	note d5  $08
	rest $04
	vol $3
	note d5  $08
	rest $04
	vol $1
	note d5  $08
	vol $8
	note g4  $20
	vol $3
	note g4  $10
	vol $8
	note g4  $08
	note fs4 $08
	note g4  $08
	note a4  $08
	note as4 $08
	note c5  $08
	note d5  $40
	vibrato $01
	vol $3
	note d5  $10
	vibrato $e1
	vol $8
	note d5  $10
	note cs5 $10
	note d5  $08
	rest $04
	vol $3
	note d5  $04
	vol $8
	note as5 $08
	rest $04
	vol $3
	note as5 $08
	rest $04
	vol $8
	note a5  $08
	note g5  $20
	vol $1
	note g5  $0a
	vol $8
	note d5  $06
	rest $05
	note d5  $05
	rest $06
	note d5  $0a
	note as4 $0b
	note g5  $0b
	note gs5 $08
	rest $04
	vol $3
	note gs5 $08
	rest $04
	vol $8
	note as5 $08
	note c6  $20
	vol $3
	note c6  $0a
	vol $8
	note c6  $08
	rest $02
	note d6  $09
	rest $03
	note ds6 $0a
	note f6  $0b
	note ds6 $0b
	note d6  $2a
	rest $06
	note d6  $05
	rest $03
	note d6  $05
	rest $03
	note d6  $2a
	rest $06
	note d6  $05
	rest $03
	note d6  $05
	rest $03
	note d6  $10
	vol $3
	note d6  $10
	duty $02
	vol $8
	note e5  $05
	rest $05
	note e5  $06
	rest $05
	note e5  $05
	rest $06
	note f5  $1a
	rest $06
	note fs5 $05
	rest $05
	note fs5 $06
	rest $05
	note fs5 $05
	rest $06
	goto musicfb27e
	cmdff

sound29Channel0:
	vibrato $00
	env $0 $00
	duty $02
	vol $6
	note as3 $40
	note a3  $40
	note g3  $40
	note f3  $40
	note ds3 $20
	note g3  $08
	rest $02
	note g3  $08
	rest $02
	note g3  $09
	rest $03
	note d4  $20
	note ds3 $08
	rest $02
	note ds3 $08
	rest $02
	note ds3 $09
	rest $03
	note d3  $10
	note g3  $08
	note a3  $08
	note d4  $10
	note g3  $08
	note a3  $08
	note d3  $1d
	rest $03
	note d3  $08
	rest $02
	note d3  $08
	rest $02
	note d3  $09
	rest $03
musicfb564:
	vol $0
	note gs3 $15
	note b3  $05
	rest $02
	vol $3
	note b3  $04
	vol $6
	note b3  $08
	note c4  $08
	note b3  $08
	note a3  $08
	note b3  $40
	vol $6
	note f4  $10
	note g4  $10
	note a4  $10
	note b4  $10
	note c5  $10
	note b4  $08
	rest $04
	vol $3
	note b4  $04
	vol $6
	note b4  $0a
	note c5  $0b
	note d5  $0b
	note ds5 $10
	vol $3
	note ds5 $05
	vol $6
	note as4 $05
	rest $02
	vol $3
	note as4 $04
	vol $6
	note as4 $08
	note c5  $08
	note as4 $08
	note a4  $08
	note as4 $0a
	rest $02
	vol $3
	note as4 $04
	vol $6
	note as4 $10
	note a4  $10
	note g4  $10
	note a4  $08
	rest $04
	vol $3
	note a4  $08
	rest $04
	vol $6
	note g4  $08
	note f4  $08
	rest $02
	note f4  $0b
	note g4  $0b
	note gs4 $10
	note g4  $10
	note f4  $0a
	note ds4 $0b
	note d4  $0b
	note ds4 $20
	vol $3
	note ds4 $10
	vol $6
	note ds4 $08
	note f4  $08
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note g4  $10
	note f4  $10
	note ds4 $10
	note d4  $20
	vol $3
	note d4  $10
	vol $6
	note d4  $08
	note ds4 $08
	note f4  $0a
	rest $06
	note f4  $10
	note ds4 $10
	note d4  $10
	note cs4 $20
	vol $3
	note cs4 $10
	vol $6
	note cs4 $08
	note d4  $08
	note e4  $10
	note fs4 $10
	vol $6
	note g4  $10
	vol $6
	note a4  $10
	note as4 $20
	note a4  $08
	rest $04
	vol $3
	note a4  $08
	rest $04
	vol $1
	note a4  $08
	vol $6
	note as4 $20
	note a4  $08
	rest $04
	vol $3
	note a4  $08
	rest $04
	vol $1
	note a4  $08
	vol $6
	note g5  $40
	note d5  $20
	note c5  $20
	note b4  $10
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note g4  $08
	note a4  $08
	note b4  $08
	note c5  $08
	note d5  $10
	note b4  $08
	rest $04
	vol $3
	note b4  $04
	vol $6
	note b4  $0a
	note c5  $0b
	note d5  $0b
	note ds5 $20
	note as4 $10
	note g4  $10
	note ds4 $10
	note as4 $10
	note a4  $10
	note g4  $10
	note a4  $08
	rest $04
	vol $3
	note a4  $08
	rest $04
	vol $6
	note g4  $08
	note f4  $05
	rest $03
	note f4  $10
	note g4  $08
	note f4  $30
	vol $3
	note f4  $10
	vol $6
	note ds4 $20
	vol $3
	note ds4 $10
	vol $6
	note f4  $10
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note g4  $10
	note f4  $10
	note ds4 $10
	note d4  $20
	note e4  $20
	note fs4 $20
	note g4  $20
	note a4  $10
	note as4 $10
	note a4  $10
	note g4  $10
	note fs4 $10
	note ds5 $10
	note d5  $10
	note fs4 $10
	note as4 $10
	note c5  $10
	note as4 $10
	note a4  $10
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note g3  $08
	note a3  $08
	note as3 $08
	note c4  $08
	note d4  $05
	note ds4 $05
	note f4  $06
	note as4 $08
	rest $04
	vol $3
	note as4 $08
	rest $04
	vol $6
	note a4  $08
	note g4  $20
	vol $3
	note g4  $18
	vol $6
	note d4  $08
	note g4  $08
	note f4  $08
	note g4  $08
	note a4  $08
	note c5  $08
	rest $04
	vol $3
	note c5  $08
	rest $04
	vol $6
	note as4 $08
	note a4  $08
	note as4 $08
	note a4  $08
	note g4  $08
	note f4  $30
	vol $3
	note f4  $10
	vol $6
	note g4  $18
	vol $3
	note g4  $08
	vol $6
	note d4  $20
	note c4  $20
	note f4  $10
	note g4  $10
	note d4  $18
	vol $3
	note d4  $08
	vol $6
	note g4  $08
	note a4  $08
	note as4 $08
	note c5  $08
	note d5  $10
	note as4 $10
	note a4  $10
	note as4 $10
	note d5  $08
	rest $04
	vol $3
	note d5  $08
	rest $04
	vol $6
	note c5  $08
	note as4 $18
	vol $3
	note as4 $10
	rest $02
	vol $6
	note as4 $06
	rest $05
	note as4 $05
	rest $06
	note as4 $0a
	note g4  $0b
	note d4  $0b
	note c4  $08
	rest $04
	vol $3
	note c4  $08
	rest $01
	vol $6
	note gs3 $08
	rest $03
	note gs3 $0a
	note ds3 $0b
	note gs3 $0b
	note c4  $0a
	note gs3 $0b
	note c4  $0b
	note ds4 $0a
	note c4  $0b
	note ds4 $0b
	note d4  $10
	note g4  $08
	note a4  $08
	note d5  $10
	note g4  $08
	note a4  $08
	note d4  $10
	note g3  $08
	note a3  $08
	note d3  $10
	note g2  $08
	note a2  $08
	note d3  $04
	note e3  $04
	vol $6
	note fs3 $04
	note g3  $04
	note a3  $04
	note as3 $04
	note c4  $04
	note d4  $04
	note g4  $05
	rest $05
	note g4  $06
	rest $05
	note g4  $05
	rest $06
	note a4  $1a
	rest $06
	note as4 $05
	rest $05
	note as4 $06
	rest $05
	note as4 $05
	rest $06
	goto musicfb564
	cmdff

sound29Channel4:
	duty $0e
	rest $ff
	rest $ff
	rest $02
musicfb7bb:
	duty $0e
	note g3  $80
	note f3  $80
	note ds3 $40
	note f3  $20
	note ds3 $20
	note d3  $40
	note g3  $40
	note c3  $30
	note g3  $10
	note c4  $30
	duty $17
	note c4  $10
	duty $0e
	note as2 $30
	note g3  $10
	note as3 $28
	duty $17
	note as3 $18
	duty $0e
	note a2  $20
	note b2  $20
	note c3  $20
	note cs3 $20
	note d3  $20
	rest $40
	note d2  $08
	rest $02
	note d2  $08
	rest $02
	note d2  $09
	rest $03
	note g2  $08
	duty $17
	note g2  $08
	duty $0e
	note g2  $18
	duty $17
	note g2  $08
	duty $0e
	note g2  $18
	duty $17
	note g2  $08
	duty $0e
	note g2  $18
	duty $17
	note g2  $08
	duty $0e
	note g2  $10
	duty $0e
	note f2  $08
	duty $17
	note f2  $08
	duty $0e
	note f2  $18
	duty $17
	note f2  $08
	duty $0e
	note f2  $18
	duty $17
	note f2  $08
	duty $0e
	note f2  $18
	duty $17
	note f2  $08
	duty $0e
	note f2  $10
	duty $0e
	note ds2 $08
	duty $17
	note ds2 $08
	duty $0e
	note ds2 $18
	duty $17
	note ds2 $08
	duty $0e
	note ds2 $10
	duty $0e
	note f2  $08
	duty $17
	note f2  $08
	duty $0e
	note f2  $1c
	duty $17
	note f2  $04
	duty $0e
	note ds2 $10
	duty $0e
	note d2  $08
	duty $17
	note d2  $08
	duty $0e
	note a2  $20
	note d3  $20
	note a2  $10
	note f2  $10
	note d2  $10
	note c2  $08
	note d2  $08
	note ds2 $18
	note d2  $08
	note ds2 $08
	note f2  $08
	note g2  $08
	note fs2 $08
	note g2  $08
	note a2  $08
	note as2 $08
	note c3  $08
	note as2 $08
	note a2  $08
	note g2  $10
	note gs2 $08
	note g2  $08
	note fs2 $10
	note g2  $08
	note fs2 $08
	note f2  $10
	note fs2 $08
	note f2  $08
	note e2  $10
	note f2  $08
	note e2  $08
	note ds2 $08
	duty $17
	note ds2 $08
	duty $0e
	note ds2 $1c
	duty $17
	note ds2 $04
	duty $0e
	note ds2 $05
	note f2  $05
	note ds2 $06
	duty $0e
	note d2  $14
	duty $17
	note d2  $0c
	duty $0e
	note d2  $08
	note a2  $08
	note d3  $08
	note d2  $08
	duty $0e
	note g2  $10
	duty $17
	note g2  $10
	duty $0e
	note g2  $08
	note a2  $08
	note g2  $08
	note fs2 $08
	note g2  $08
	note a2  $08
	note as2 $08
	note c3  $08
	note d3  $08
	note ds3 $08
	note f3  $08
	note g3  $08
	duty $0e
	note ds3 $20
	duty $17
	note ds3 $08
	duty $0e
	note as2 $08
	note ds3 $08
	note d3  $08
	note ds3 $10
	note as2 $10
	note a2  $10
	note g2  $10
	duty $0e
	note d2  $20
	duty $17
	note d2  $08
	duty $0e
	note f3  $04
	duty $17
	note f3  $04
	duty $0e
	note f3  $08
	note ds3 $08
	note d3  $20
	note d2  $20
	duty $0e
	note g2  $08
	duty $17
	note g2  $08
	duty $0e
	note g2  $1c
	duty $17
	note g2  $04
	duty $0e
	note g2  $10
	duty $0e
	note f2  $0c
	duty $17
	note f2  $04
	duty $0e
	note f2  $1c
	duty $17
	note f2  $04
	duty $0e
	note f2  $10
	duty $0e
	note e2  $08
	duty $17
	note e2  $08
	duty $0e
	note e2  $10
	duty $17
	note e2  $08
	duty $0e
	note e2  $08
	note f2  $08
	note e2  $08
	duty $0e
	note ds2 $1d
	duty $17
	note ds2 $03
	duty $0e
	note d2  $1d
	duty $17
	note d2  $03
	duty $0e
	note c2  $28
	note g2  $08
	note c3  $08
	note b2  $08
	note as2 $20
	note a2  $20
	note gs2 $0a
	note ds2 $0b
	note gs2 $0b
	note c3  $0a
	note gs2 $0b
	note c3  $0b
	note ds3 $0a
	note c3  $0b
	note ds3 $0b
	note gs3 $0a
	note ds3 $0b
	note gs3 $0b
	duty $0e
	note d3  $08
	duty $17
	note d3  $08
	duty $0e
	note d2  $18
	duty $17
	note d2  $08
	duty $0e
	note d2  $18
	duty $17
	note d2  $08
	duty $0e
	note d2  $18
	duty $17
	note d2  $08
	duty $0e
	note d2  $08
	duty $17
	note d2  $08
	duty $0e
	note d2  $20
	duty $0e
	note e2  $05
	duty $17
	note e2  $05
	duty $0e
	note e2  $06
	duty $17
	note e2  $05
	duty $0e
	note e2  $05
	duty $17
	note e2  $06
	duty $0e
	note f2  $1a
	duty $17
	note f2  $06
	duty $0e
	note fs2 $05
	duty $17
	note fs2 $05
	duty $0e
	note fs2 $06
	duty $17
	note fs2 $05
	duty $0e
	note fs2 $05
	duty $17
	note fs2 $06
	goto musicfb7bb
	cmdff

sound29Channel6:
	vol $6
	note $26 $38
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	vol $5
	note $26 $04
	vol $7
	note $26 $10
	vol $6
	note $26 $20
	note $26 $10
	note $26 $38
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	vol $5
	note $26 $04
	vol $7
	note $26 $10
	vol $6
	note $26 $20
	note $26 $10
	vol $7
	note $26 $30
	vol $4
	note $26 $05
	vol $5
	note $26 $05
	vol $5
	note $26 $06
	vol $6
	note $26 $10
	vol $6
	note $26 $20
	note $26 $10
	note $26 $10
	vol $4
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $4
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $04
	vol $5
	note $26 $04
	vol $4
	note $26 $04
	vol $4
	note $26 $04
	note $26 $04
	vol $4
	note $26 $04
	vol $5
	note $26 $04
	vol $7
	note $26 $04
musicfba80:
	vol $6
	note $26 $18
	vol $5
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $20
	note $26 $20
	note $26 $10
	vol $5
	note $26 $20
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $18
	vol $5
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $5
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $05
	vol $6
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $18
	vol $5
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $20
	note $26 $20
	note $26 $10
	vol $5
	note $26 $20
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $18
	vol $5
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $5
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $05
	vol $6
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $20
	note $26 $05
	vol $5
	note $26 $05
	vol $4
	note $26 $06
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $20
	vol $6
	note $26 $05
	note $26 $05
	note $26 $06
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $20
	vol $6
	note $26 $05
	note $26 $05
	note $26 $06
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $20
	vol $6
	note $26 $05
	note $26 $05
	note $26 $06
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $20
	vol $6
	note $26 $05
	note $26 $05
	note $26 $06
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $20
	vol $6
	note $26 $05
	note $26 $05
	note $26 $06
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $20
	vol $6
	note $26 $05
	note $26 $05
	note $26 $06
	note $26 $10
	vol $4
	note $26 $04
	vol $5
	note $26 $04
	vol $5
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $10
	vol $5
	note $26 $04
	vol $5
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $10
	vol $5
	note $26 $04
	vol $5
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $10
	note $26 $10
	note $26 $20
	note $26 $04
	vol $6
	note $26 $04
	vol $5
	note $26 $04
	vol $5
	note $26 $04
	note $26 $04
	vol $5
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $20
	note $26 $0a
	note $26 $0b
	note $26 $0b
	goto musicfba80
	cmdff

sound25Channel1:
	vibrato $00
	env $0 $04
	duty $02
musicfbd80:
	vol $8
	note c3  $0a
	rest $14
	note ds3 $14
	note c3  $0a
	rest $14
	note g2  $0a
	note as2 $14
	note b2  $0a
	note c3  $1e
	note ds3 $14
	note g3  $0a
	rest $14
	note g2  $0a
	note as2 $14
	note g2  $0a
	note c3  $1e
	note ds3 $14
	note c3  $0a
	rest $14
	note g2  $0a
	note as2 $14
	note b2  $0a
	note c3  $1e
	note ds3 $14
	note c3  $0a
	rest $14
	note c3  $0a
	note ds3 $14
	note g3  $0a
	note f3  $1e
	note a3  $14
	note c3  $0a
	rest $14
	note c3  $0a
	note ds3 $14
	note e3  $0a
	note f3  $1e
	note a3  $14
	note c3  $0a
	rest $14
	note c3  $0a
	note ds3 $14
	note e3  $0a
	note f3  $1e
	note a3  $14
	note c3  $0a
	rest $14
	note c3  $0a
	note ds3 $14
	note e3  $0a
	note f3  $1e
	note a3  $14
	note f3  $0a
	rest $14
	note f3  $0a
	note a3  $14
	note f3  $0a
	rest $14
	vibrato $00
	env $0 $00
	vol $6
	note g5  $0a
	note fs5 $0a
	rest $14
	note fs5 $14
	note f5  $0a
	rest $14
	note f5  $0a
	note e5  $0a
	rest $14
	note e5  $14
	note ds5 $0a
	rest $14
	note ds5 $0a
	note d5  $14
	vol $3
	note d5  $0a
	rest $14
	vol $6
	note as5 $0a
	note a5  $0a
	rest $14
	note a5  $14
	note gs5 $0a
	rest $14
	note gs5 $0a
	note g5  $0a
	rest $14
	note g5  $14
	note fs5 $0a
	rest $14
	note fs5 $0a
	note f5  $14
	vol $3
	note f5  $0a
	rest $14
	vol $6
	note c6  $0a
	note b5  $0a
	rest $14
	note b5  $14
	note as5 $0a
	rest $14
	note as5 $0a
	note a5  $0a
	rest $14
	note a5  $14
	note gs5 $0a
	rest $14
	note gs5 $0a
	note g5  $14
	vol $3
	note g5  $0a
	vibrato $00
	env $0 $03
	vol $6
	note fs5 $14
	rest $28
	note f5  $14
	rest $28
	note ds5 $14
	rest $28
	note d5  $14
	rest $28
	vibrato $00
	env $0 $04
	goto musicfbd80
	cmdff

sound25Channel0:
	vibrato $00
	env $0 $00
	duty $02
musicfbe80:
	vol $0
	note gs3 $ff
	rest $ff
	rest $ff
	rest $d7
	vol $6
	note ds5 $0a
	note d5  $0a
	rest $14
	note d5  $14
	note cs5 $0a
	rest $14
	note cs5 $0a
	note c5  $0a
	rest $14
	note c5  $14
	note b4  $0a
	rest $14
	note b4  $0a
	note as4 $14
	vol $3
	note as4 $0a
	rest $14
	vol $6
	note g5  $0a
	note fs5 $0a
	rest $14
	note fs5 $14
	note f5  $0a
	rest $14
	note f5  $0a
	note e5  $0a
	rest $14
	note e5  $14
	note ds5 $0a
	rest $14
	note ds5 $0a
	note d5  $14
	vol $3
	note d5  $0a
	rest $14
	vol $6
	note a5  $0a
	note gs5 $0a
	rest $14
	note gs5 $14
	note g5  $0a
	rest $14
	note g5  $0a
	note fs5 $0a
	rest $14
	note fs5 $14
	note f5  $0a
	rest $14
	note f5  $0a
	note e5  $14
	vol $3
	note e5  $0a
	vibrato $00
	env $0 $03
	vol $6
	note ds5 $14
	rest $28
	note d5  $14
	rest $28
	note c5  $14
	rest $28
	note b4  $14
	rest $28
	vibrato $00
	env $0 $00
	goto musicfbe80
	cmdff

sound25Channel4:
musicfbf0a:
	duty $0e
	note d4  $05
	note ds4 $2d
	note c4  $0a
	rest $32
	note g3  $0a
	note as3 $14
	note a3  $0a
	note as3 $14
	note a3  $0a
	note g3  $0a
	rest $14
	note f3  $0a
	rest $14
	note d4  $05
	note ds4 $2d
	note c4  $0a
	rest $32
	note g3  $0a
	note as3 $0a
	note a3  $0a
	note as3 $0a
	note a3  $0a
	note as3 $0a
	note a3  $0a
	note g3  $14
	note as3 $0a
	note c4  $0a
	rest $0a
	note ds4 $0a
	note e4  $05
	note f4  $2d
	note c4  $0a
	rest $32
	note d4  $0a
	note ds4 $14
	note d4  $0a
	note ds4 $14
	note d4  $0a
	note c4  $0a
	rest $14
	note as3 $0a
	rest $14
	note e4  $05
	note f4  $2d
	note a4  $0a
	rest $32
	note c5  $0a
	note ds5 $0a
	note d5  $0a
	note c5  $0a
	note ds5 $0a
	note d5  $0a
	note c5  $05
	rest $05
	note c5  $14
	note ds5 $0a
	note d5  $14
	note ds5 $0a
	duty $0e
	note g2  $3c
	duty $0f
	note g2  $14
	rest $78
	duty $0e
	note g2  $07
	duty $0f
	note g2  $03
	duty $0e
	note g2  $0f
	duty $0f
	note g2  $05
	duty $0e
	note g2  $07
	duty $0f
	note g2  $03
	duty $0e
	note gs2 $3c
	duty $0f
	note gs2 $14
	rest $78
	duty $0e
	note gs2 $07
	duty $0f
	note gs2 $03
	duty $0e
	note gs2 $0f
	duty $0f
	note gs2 $05
	duty $0e
	note gs2 $07
	duty $0f
	note gs2 $03
	duty $0e
	note g2  $3c
	duty $0f
	note g2  $14
	rest $be
	duty $0e
	note g2  $0f
	rest $2d
	duty $0e
	note g2  $0f
	rest $2d
	duty $0e
	note g2  $0f
	duty $0f
	note g2  $0f
	duty $0e
	note a2  $0f
	duty $0f
	note a2  $0f
	duty $0e
	note b2  $0f
	duty $0f
	note b2  $0f
	goto musicfbf0a
	cmdff


.ifdef BUILD_VANILLA
	.dsb 10 $ff
.endif
