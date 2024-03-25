.BANK $40 SLOT 1
.ORG 0
; MUSIC: Moved from Bank $39
snddeStart:

snddeChannel0:
snddeChannel1:
snddeChannel4:
snddeChannel6:
	cmdff

bank40ChannelFallback:
	cmdff
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank40ChannelFallback


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

sndb7Start:
sndb7Channel2:
	cmdff
sndb7Channel7:
	cmdff

	.include "audio/sfx/common/veranFairyAttack.s"
	.include "audio/sfx/common/rumble2.s"
	.include "audio/sfx/common/warpStart.s"
	.include "audio/sfx/common/endless.s"
	.include "audio/sfx/common/bigExplosion2.s"

sndbdStart:
sndbdChannel2:
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

; MUSIC: Added Seasons music
	.include "audio/mus/seasons/ancientRuins.s"
	.include "audio/mus/seasons/carnival.s"
	.include "audio/mus/seasons/dancingDragonDungeon.s"
	.include "audio/mus/seasons/explorersCrypt.s"
	.include "audio/mus/seasons/gnarledRootDungeon.s"
	.include "audio/mus/seasons/herosCave.s"

.BANK $41 SLOT 1
.ORG 0

bank41ChannelFallBack:
    cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank41ChannelFallBack

	.include "audio/mus/seasons/hideAndSeek.s"
	.include "audio/mus/seasons/horonVillage.s"
	.include "audio/mus/seasons/poisonMothsLair.s"
	.include "audio/mus/seasons/samasaDesert.s"
	.include "audio/mus/seasons/snakesRemains.s"
	.include "audio/mus/seasons/songOfStorms.s"
	.include "audio/mus/seasons/subrosia.s"
	.include "audio/mus/seasons/subrosianDance.s"
	.include "audio/mus/seasons/subrosianShop.s"
	.include "audio/mus/seasons/sunkenCity.s"
	.include "audio/mus/seasons/swordAndShieldMaze.s"
	.include "audio/mus/seasons/tarmRuins.s"
	.include "audio/mus/seasons/templeRemains.s"
	.include "audio/mus/seasons/unicornsCave.s"
	.include "audio/mus/seasons/unused1.s"
	.include "audio/mus/seasons/unused2.s"
; MUSIC: Custom music


.BANK $42 SLOT 1
.ORG 0

bank42ChannelFallBack:
    cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank42ChannelFallBack
	.include "audio/mus/custom/linebeck.s"
	.include "audio/mus/custom/inTheFields.s"
	.include "audio/mus/custom/sacredGrove.s"
	.include "audio/mus/custom/gerudoValley.s"
	.include "audio/mus/custom/lostWoods.s"
	.include "audio/mus/custom/dragonRoostIsland.s"
	.include "audio/mus/custom/sanctuary.s"