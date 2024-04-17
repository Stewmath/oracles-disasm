.BANK $40 SLOT 1
.ORG 0
; MUSIC: Moved from Bank $39
snddeStart:

snddeChannel0:
snddeChannel1:
snddeChannel4:
snddeChannel6:
	cmdff

; MUSIC: Moved from Bank $39
snd97Start:
sndadStart:
sndb6Start:

snd97Channel2:
snd97Channel7:
sndadChannel2:
sndadChannel7:
sndb6Channel2:
sndb6Channel7:
bank40ChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank40ChannelFallback


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

; MUSIC: Added Ages music
	.include "audio/mus/ages/ambiPalace.s"
	.include "audio/mus/ages/ancientTomb.s"
	.include "audio/mus/ages/blackTower.s"
	.include "audio/mus/ages/crescent.s"
	.include "audio/mus/ages/crownDungeon.s"
	.include "audio/mus/ages/fairyForest.s"
	.include "audio/mus/ages/jabuJabusBelly.s"

.BANK $41 SLOT 1
.ORG 0

bank41ChannelFallBack:
    cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank41ChannelFallBack

	.include "audio/mus/ages/lynnaCity.s"
	.include "audio/mus/ages/lynnaVillage.s"
	.include "audio/mus/ages/makuPath.s"
	.include "audio/mus/ages/mermaidsCave.s"
	.include "audio/mus/ages/moonlitGrotto.s"
	.include "audio/mus/ages/nayru.s"
	.include "audio/mus/ages/overworldPast.s"
	.include "audio/mus/ages/ralph.s"
	.include "audio/mus/ages/skullDungeon.s"
	.include "audio/mus/ages/spiritsGrave.s"
	.include "audio/mus/ages/symmetryPast.s"
	.include "audio/mus/ages/symmetryPresent.s"
	.include "audio/mus/ages/tokayHouse.s"
	.include "audio/mus/ages/underwater.s"
	.include "audio/mus/ages/wingDungeon.s"
; MUSIC: Custom music
	.include "audio/mus/custom/sanctuary.s"

.BANK $42 SLOT 1
.ORG 0

bank42ChannelFallBack:
    cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank42ChannelFallBack
; MUSIC: Ages music
	.include "audio/mus/ages/zoraVillage.s"
; MUSIC: Custom music
	.include "audio/mus/custom/inTheFields.s"
	.include "audio/mus/custom/linebeck.s"
	.include "audio/mus/custom/sacredGrove.s"
	.include "audio/mus/custom/gerudoValley.s"
	.include "audio/mus/custom/lostWoods.s"
	.include "audio/mus/custom/fallingRain.s"
	.include "audio/mus/custom/kassThemeShort.s"
	.include "audio/mus/custom/theGreatPalace.s"
	

.BANK $43 SLOT 1
.ORG 0

bank43ChannelFallBack:
    cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank43ChannelFallBack
	.include "audio/mus/custom/dragonRoostIsland.s"
	.include "audio/mus/custom/attackingVahNaboris.s"
	.include "audio/mus/custom/overthereStair.s"
	.include "audio/mus/custom/lightWorldDungeon.s"

.undefine MUSIC_CHANNEL_FALLBACK