; If adding/removing any music, remember to update soundChannelPointers.s, soundChannelData.s, and
; constants/common/music.s.
soundPointers:
	/* 0x00 */ m_soundPointer musNone
	/* 0x01 */ m_soundPointer musTitlescreen
	/* 0x02 */ m_soundPointer musMinigame
	/* 0x03 */ m_soundPointer musOverworld
	/* 0x04 */ m_soundPointer musOverworldPast
	/* 0x05 */ m_soundPointer musCrescent
	/* 0x06 */ m_soundPointer musEssence
	/* 0x07 */ m_soundPointer musAmbiPalace
	/* 0x08 */ m_soundPointer musNayru
	/* 0x09 */ m_soundPointer musGameover
	/* 0x0a */ m_soundPointer musLynnaCity
	/* 0x0b */ m_soundPointer musLynnaVillage
	/* 0x0c */ m_soundPointer musZoraVillage
	/* 0x0d */ m_soundPointer musEssenceRoom
	/* 0x0e */ m_soundPointer musIndoors
	/* 0x0f */ m_soundPointer musFairyFountain
	/* 0x10 */ m_soundPointer musGetEssence
	/* 0x11 */ m_soundPointer musFileSelect
	/* 0x12 */ m_soundPointer musMakuPath
	/* 0x13 */ m_soundPointer musSpiritsGrave
	/* 0x14 */ m_soundPointer musWingDungeon
	/* 0x15 */ m_soundPointer musMoonlitGrotto
	/* 0x16 */ m_soundPointer musSkullDungeon
	/* 0x17 */ m_soundPointer musCrownDungeon
	/* 0x18 */ m_soundPointer musMermaidsCave
	/* 0x19 */ m_soundPointer musJabuJabusBelly
	/* 0x1a */ m_soundPointer musAncientTomb
	/* 0x1b */ m_soundPointer musFinalDungeon
	/* 0x1c */ m_soundPointer musOnoxCastle
	/* 0x1d */ m_soundPointer musRoomOfRites
	/* 0x1e */ m_soundPointer musMakuTree
	/* 0x1f */ m_soundPointer musSadness
	/* 0x20 */ m_soundPointer musTriumphant
	/* 0x21 */ m_soundPointer musDisaster
	/* 0x22 */ m_soundPointer musUnderwater
	/* 0x23 */ m_soundPointer musPirates
	/* 0x24 */ m_soundPointer musSymmetryPresent
	/* 0x25 */ m_soundPointer musSymmetryPast
	/* 0x26 */ m_soundPointer musTokayHouse
	/* 0x27 */ m_soundPointer musRosaDate
	/* 0x28 */ m_soundPointer musBlackTower
	/* 0x29 */ m_soundPointer musCredits1
	/* 0x2a */ m_soundPointer musCredits2
	/* 0x2b */ m_soundPointer musMapleTheme
	/* 0x2c */ m_soundPointer musMapleGame
	/* 0x2d */ m_soundPointer musMiniboss
	/* 0x2e */ m_soundPointer musBoss
	/* 0x2f */ m_soundPointer musLadxSideview
	/* 0x30 */ m_soundPointer musFairyForest
	/* 0x31 */ m_soundPointer musCrazyDance
	/* 0x32 */ m_soundPointer musFinalBoss
	/* 0x33 */ m_soundPointer musTwinrova
	/* 0x34 */ m_soundPointer musGanon
	/* 0x35 */ m_soundPointer musRalph
	/* 0x36 */ m_soundPointer musCave
	/* 0x37 */ m_soundPointer mus37
	/* 0x38 */ m_soundPointer musZeldaSaved
	/* 0x39 */ m_soundPointer musGreatMoblin
	/* 0x3a */ m_soundPointer mus3a
	/* 0x3b */ m_soundPointer mus3b
	/* 0x3c */ m_soundPointer musSyrup
	/* 0x3d */ m_soundPointer mus3d
	/* 0x3e */ m_soundPointer musGoronCave
	/* 0x3f */ m_soundPointer musIntro1
	/* 0x40 */ m_soundPointer musIntro2
	/* 0x41 */ m_soundPointer mus41
	/* 0x42 */ m_soundPointer mus42
	/* 0x43 */ m_soundPointer mus43
	/* 0x44 */ m_soundPointer mus44
	/* 0x45 */ m_soundPointer mus45
	/* 0x46 */ m_soundPointer musBlackTowerEntrance
	/* 0x47 */ m_soundPointer mus47
	/* 0x48 */ m_soundPointer mus48
	/* 0x49 */ m_soundPointer mus49
	/* 0x4a */ m_soundPointer musPrecredits
	/* 0x4b */ m_soundPointer mus4b

	/* 0x4c */ m_soundPointer sndGetItem
	/* 0x4d */ m_soundPointer sndSolvePuzzle
	/* 0x4e */ m_soundPointer sndDamageEnemy
	/* 0x4f */ m_soundPointer sndChargeSword
	/* 0x50 */ m_soundPointer sndClink
	/* 0x51 */ m_soundPointer sndThrow
	/* 0x52 */ m_soundPointer sndBombLand
	/* 0x53 */ m_soundPointer sndJump
	/* 0x54 */ m_soundPointer sndOpenMenu
	/* 0x55 */ m_soundPointer sndCloseMenu
	/* 0x56 */ m_soundPointer sndSelectItem
	/* 0x57 */ m_soundPointer sndGainHeart
	/* 0x58 */ m_soundPointer sndClink2
	/* 0x59 */ m_soundPointer sndFallInHole
	/* 0x5a */ m_soundPointer sndError
	/* 0x5b */ m_soundPointer sndSolvePuzzle2
	/* 0x5c */ m_soundPointer sndEnergyThing
	/* 0x5d */ m_soundPointer sndSwordBeam
	/* 0x5e */ m_soundPointer sndGetSeed
	/* 0x5f */ m_soundPointer sndDamageLink
	/* 0x60 */ m_soundPointer sndHeartBeep
	/* 0x61 */ m_soundPointer sndRupee
	/* 0x62 */ m_soundPointer sndGohmaSpawnGel
	/* 0x63 */ m_soundPointer sndBossDamage
	/* 0x64 */ m_soundPointer sndLinkDead
	/* 0x65 */ m_soundPointer sndLinkFall
	/* 0x66 */ m_soundPointer sndText
	/* 0x67 */ m_soundPointer sndBossDead
	/* 0x68 */ m_soundPointer sndUnknown3
	/* 0x69 */ m_soundPointer sndUnknown4
	/* 0x6a */ m_soundPointer sndSlash
	/* 0x6b */ m_soundPointer sndSwordSpin
	/* 0x6c */ m_soundPointer sndOpenChest
	/* 0x6d */ m_soundPointer sndCutGrass
	/* 0x6e */ m_soundPointer sndEnterCave
	/* 0x6f */ m_soundPointer sndExplosion
	/* 0x70 */ m_soundPointer sndDoorClose
	/* 0x71 */ m_soundPointer sndMoveBlock
	/* 0x72 */ m_soundPointer sndLightTorch
	/* 0x73 */ m_soundPointer sndKillEnemy
	/* 0x74 */ m_soundPointer sndSwordSlash
	/* 0x75 */ m_soundPointer sndUnknown5
	/* 0x76 */ m_soundPointer sndShield
	/* 0x77 */ m_soundPointer sndDropEssence
	/* 0x78 */ m_soundPointer sndBoomerang
	/* 0x79 */ m_soundPointer sndBigExplosion
	/* 0x7a */ m_soundPointer snd7a
	/* 0x7b */ m_soundPointer sndMysterySeed
	/* 0x7c */ m_soundPointer sndAquamentusHover
	/* 0x7d */ m_soundPointer sndOpenGate
	/* 0x7e */ m_soundPointer sndSwitch
	/* 0x7f */ m_soundPointer sndMoveBlock2
	/* 0x80 */ m_soundPointer sndMinecart
	/* 0x81 */ m_soundPointer sndStrongPound
	/* 0x82 */ m_soundPointer sndRoller
	/* 0x83 */ m_soundPointer sndMagicPowder
	/* 0x84 */ m_soundPointer sndMenuMove
	/* 0x85 */ m_soundPointer sndScentSeed
	/* 0x86 */ m_soundPointer snd86
	/* 0x87 */ m_soundPointer sndSplash
	/* 0x88 */ m_soundPointer sndLinkSwim
	/* 0x89 */ m_soundPointer sndText2
	/* 0x8a */ m_soundPointer sndPieceOfPower
	/* 0x8b */ m_soundPointer sndFilledHeartContainer
	/* 0x8c */ m_soundPointer sndUnknown7
	/* 0x8d */ m_soundPointer sndTeleport
	/* 0x8e */ m_soundPointer sndSwitch2
	/* 0x8f */ m_soundPointer sndEnemyJump
	/* 0x90 */ m_soundPointer sndGaleSeed
	/* 0x91 */ m_soundPointer sndFairyCutscene
	/* 0x92 */ m_soundPointer snd92
	/* 0x93 */ m_soundPointer snd93
	/* 0x94 */ m_soundPointer snd94
	/* 0x95 */ m_soundPointer sndWarpStart
	/* 0x96 */ m_soundPointer sndGhost
	/* 0x97 */ m_soundPointer snd97
	/* 0x98 */ m_soundPointer sndPoof
	/* 0x99 */ m_soundPointer sndBaseball
	/* 0x9a */ m_soundPointer sndBecomeBaby
	/* 0x9b */ m_soundPointer sndJingle
	/* 0x9c */ m_soundPointer sndPickup
	/* 0x9d */ m_soundPointer sndFluteRicky
	/* 0x9e */ m_soundPointer sndFluteDimitri
	/* 0x9f */ m_soundPointer sndFluteMoosh
	/* 0xa0 */ m_soundPointer sndChicken
	/* 0xa1 */ m_soundPointer sndMonkey
	/* 0xa2 */ m_soundPointer sndCompass
	/* 0xa3 */ m_soundPointer sndLand
	/* 0xa4 */ m_soundPointer sndBeam
	/* 0xa5 */ m_soundPointer sndBreakRock
	/* 0xa6 */ m_soundPointer sndStrike
	/* 0xa7 */ m_soundPointer sndSwitchHook
	/* 0xa8 */ m_soundPointer sndVeranFairyAttack
	/* 0xa9 */ m_soundPointer sndDig
	/* 0xaa */ m_soundPointer sndWave
	/* 0xab */ m_soundPointer sndSwordObtained
	/* 0xac */ m_soundPointer sndShock
	/* 0xad */ m_soundPointer sndEchoes
	/* 0xae */ m_soundPointer sndCurrents
	/* 0xaf */ m_soundPointer sndAges
	/* 0xb0 */ m_soundPointer sndOpening
	/* 0xb1 */ m_soundPointer sndBigSword
	/* 0xb2 */ m_soundPointer sndMakuDisappear
	/* 0xb3 */ m_soundPointer sndRumble
	/* 0xb4 */ m_soundPointer sndFadeout
	/* 0xb5 */ m_soundPointer sndTingle
	/* 0xb6 */ m_soundPointer sndTokay
	/* 0xb7 */ m_soundPointer sndb7
	/* 0xb8 */ m_soundPointer sndRumble2
	/* 0xb9 */ m_soundPointer sndEndless
	/* 0xba */ m_soundPointer sndBeam1
	/* 0xbb */ m_soundPointer sndBeam2
	/* 0xbc */ m_soundPointer sndBigExplosion2
	/* 0xbd */ m_soundPointer sndbd
	/* 0xbe */ m_soundPointer sndVeranProjectile
	/* 0xbf */ m_soundPointer sndBlueStalfosCharge
	/* 0xc0 */ m_soundPointer sndTransform
	/* 0xc1 */ m_soundPointer sndRestore
	/* 0xc2 */ m_soundPointer sndFloodgates
	/* 0xc3 */ m_soundPointer sndRicky
	/* 0xc4 */ m_soundPointer sndDimitri
	/* 0xc5 */ m_soundPointer sndMoosh
	/* 0xc6 */ m_soundPointer sndDekuScrub
	/* 0xc7 */ m_soundPointer sndGoron
	/* 0xc8 */ m_soundPointer sndDing
	/* 0xc9 */ m_soundPointer sndCircling
	/* 0xca */ m_soundPointer sndca
	/* 0xcb */ m_soundPointer sndSeedShooter
	/* 0xcc */ m_soundPointer sndWhistle
	/* 0xcd */ m_soundPointer sndGoronDanceB
	/* 0xce */ m_soundPointer sndMakuTreePast
	/* 0xcf */ m_soundPointer sndcf
	/* 0xd0 */ m_soundPointer sndPirateBell
	/* 0xd1 */ m_soundPointer sndTimewarpInitiated
	/* 0xd2 */ m_soundPointer sndLightning
	/* 0xd3 */ m_soundPointer sndWind
	/* 0xd4 */ m_soundPointer sndTimewarpCompleted
	/* 0xd5 */ m_soundPointer sndd5
	/* 0xd6 */ m_soundPointer sndd6
	/* 0xd7 */ m_soundPointer sndd7
	/* 0xd8 */ m_soundPointer sndd8
	/* 0xd9 */ m_soundPointer sndd9
	/* 0xda */ m_soundPointer sndda
	/* 0xdb */ m_soundPointer snddb
	/* 0xdc */ m_soundPointer snddc
	/* 0xdd */ m_soundPointer snddd
	/* 0xde */ m_soundPointer sndde


; This should really be located in "soundChannelPointers.s" but it's positioned differently for
; some reason.
sndde:
	.db $00
	.dw snddeChannel0
	.db $01
	.dw snddeChannel1
	.db $04
	.dw snddeChannel4
	.db $06
	.dw snddeChannel6
	.db $ff

.ifdef BUILD_VANILLA
	; Unused data?
	.db $02
	.dw $59ff
	.db $03
	.dw $59ff
	.db $05
	.dw $59ff
	.db $07
	.dw $59ff
	.db $ff
.endif
