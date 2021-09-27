; Layout of wram.
;
; When 2 addresses are listed (ie. $c6b9/$c6b5), the first address is for ages, the second
; is for seasons. If only one is listed, assume it's for ages.
;
; The RAMSECTION names are referenced in the linkfiles (linkfile_ages, linkfile_seasons) in order to
; place them at the correct addresses. Their banks and slots are also set in the linkfile.

.RAMSECTION Wram0_c000

wMusicReadFunction: ; $c000
; Function copied to RAM to read a byte from another bank.
	dsb $14

wSoundFadeCounter: ; $c014
; When [wSoundFadeCounter]&[wSoundFadeSpeed] == 0, volume is incremented or decremented.
	db

wSoundFadeDirection: ; $c015
; $01 for fadeout (volume down), $0a for fadein
	db

wSoundFadeSpeed: ; $c016
	db

wLoadingSoundBank: ; $c017
; Used within the music playing functions
	db

wSoundTmp: ; $c018
; Initially used as the index of the sound to play, then as a channel index. Only used in
; one function.
	db

wSoundChannelValue: ; $c019
; This holds the priority of a channel being read, but only in one function.
	db

wSoundChannel: ; $c01a
; The sound channel being "operated on" for various functions.
	db

wSoundDisabled: ; $c01b
; All sound processing is disabled when this is nonzero
	db

wc01c: ; $c01c
	db

wSoundCmd: ; $c01d
	db

wSoundCmdEnvelope: ; $c01e
; This value goes straight to NR12/NR22
; In some situations it is also used to mark whether to reset / use the counter
; for the channel (NRx4)
	db

wSoundFrequencyL: ; $c01f
	db
wSoundFrequencyH: ; $c020
	db
wWaveformIndex: ; $c021
	db

wMusicVolume: ; $c022
; Basically the same as hMusicVolume, except this is only used in the music routines.
	db

wc023: ; $c023
; Relates to muting channel 3 when wMusicVolume is set to 0?
	db

wSoundVolume: ; $c024
; This value goes straight to NR50.
; Bits 0-2: left speaker, 4-6: right speaker (unless I mixed them up)
	db


wc025: ; $c025
	dsb 8

wc02d: ; $c02d
; This doesn't apply to channels 6 and 7?
	dsb 6

wChannelPitchShift: ; $c033
; An offset for wSoundFrequencyL,H
	dsb 6

wc039: ; $c039
; c039 might be related to the "counter" bit (NRx4)
	dsb 6

wc03f: ; $c03f
; c03f might be related to sweep
	dsb 6

wc045: ; $c045
	dsb 6
wChannelVibratos: ; $c04b
	dsb 6
wc051: ; $c051
	dsb 6
wChannelDutyCycles: ; $c057
	dsb 6

wc05d: ; $c05d
	dsb 4
wc061: ; $c061
	dsb 4
wChannelEnvelopes: ; $c065
	dsb 4
wChannelEnvelopes2: ; $c069
	dsb 4

wChannelsEnabled: ; $c06d
	dsb 8
wChannelWaitCounters: ; $c075
	dsb 8
wChannelVolumes: ; $c07d
	dsb 8

; $c085-$c09f unused?

.ENDS


; TODO: Make this a ramsection. Currently it creates annoying warnings when made a ramsection due to
; some strange arithmetic done between slots; the warning needs to be muted in wla-dx.
;.RAMSECTION Wram0_c0a0
.ENUM $c0a0

wMusicQueue: ; $c0a0
	dsb $10

; Stacks grow down on the gameboy. So the main stack is from $c0b0-$c10f?
wMainStack:		dsb $60
wMainStackTop:		.db	; $c110
wThread0Stack: 		dsb $70
wThread0StackTop: 	.db	; $c180
wThread1Stack: 		dsb $a0
wThread1StackTop: 	.db	; $c220
wThread2Stack: 		dsb $50
wThread2StackTop: 	.db	; $c270
wThread3Stack: 		dsb $50
wThread3StackTop: 	.db	; $c2c0

wc2c0:
	dsb $20

wThreadStateBuffer: ; $c2e0
; $20 byte buffer (with a few 2-byte gaps)
	dsb $20

.ENDE


.define NUM_THREADS	4

; Used for the intro
.define THREAD_0	<wThreadStateBuffer + 0*8

; Used for main game, file select screen
.define THREAD_1	<wThreadStateBuffer + 1*8

; Used for displaying text
.define THREAD_2	<wThreadStateBuffer + 2*8

; Used for handling palette fadeouts (basically always on?)
.define THREAD_3	<wThreadStateBuffer + 3*8


; Some of the 2-byte gaps in the wThreadStateBuffer are used for other purposes

.define wIntroStage	 wThreadStateBuffer + $6 ; $c2e6
.define wIntroVar	 wThreadStateBuffer + $7 ; $c2e7

; Game state.
; 0: Loading a room?
; 1: ?
; 2: Standard (the game is usually in this state)
; 3: Link is falling from the top of the screen (for the start of the game)
.define wGameState	 wThreadStateBuffer + $e ; $c2ee

; Writing a value here triggers a cutscene.
; (See constants/cutsceneIndices.s)
.define wCutsceneIndex		wThreadStateBuffer + $f ; $c2ef

; This is the amount to add to each color component to produce the "faded" palettes.
; Increase this enough and they'll be fully white.
.define wPaletteThread_fadeOffset	wThreadStateBuffer + $1f ; $c2ff


.RAMSECTION Wram0_c300

wBigBuffer: ; $c300
; General purpose $100 byte buffer. This has several, mutually exclusive uses:
; * Scripts that aren't in bank $C; the "loadscript" command loads $100 bytes into here to
;   allow script execution.
; * Screen waves; stores sinewave values used to make the screen wavy, ie. underwater.
; * Stores the layout for the room in d6 with the changing floor
	dsb $100

wVBlankFunctionQueue: ; $c400
	dsb $80

wKeysPressedLastFrame: ; $c480
	db
wKeysPressed: ; $c481
	db
wKeysJustPressed: ; $c482
	db
wAutoFireKeysPressed: ; $c483
	db
wAutoFireCounter: ; $c484
	db

wGfxRegs1: ; $c485
; Copied to wGfxRegsFinal prior to vblank.
	instanceof GfxRegsStruct
wGfxRegs2: ; $c48b
; Copied to wGfxRegs3 during vblank. Safe to modify from anywhere.
; Note: wGfxRegs2 and wGfxRegs3 can't cross pages (say, c2xx->c3xx)
	instanceof GfxRegsStruct
wGfxRegs3: ; $c491
; Used for the "actual game" (these are copied to the real registers during hblank after
; the status bar is drawn).
; Not safe to modify since the LCD interrupt could happen at any time.
	instanceof GfxRegsStruct
wGfxRegsFinal: ; $c497
; Copied over during vblank; during normal gameplay this will only affect the status bar?
	instanceof GfxRegsStruct

wVBlankChecker: ; $c49d
; Used by vblank wait loop
	db

wc49e: ; $c49e
	db

wGfxRegs6: ; $c49f
	instanceof GfxRegsStruct
wGfxRegs7: ; $c4a5
	instanceof GfxRegsStruct

wPaletteThread_mode: ; $c4ab
; Determines what the palette thread does. Generally, the game is inactive when this is
; nonzero.
; Valid values:
;  0: Do nothing
;  1: fadeout to white
;  2: fadein from white
;  3: fadeout to black
;  4: fadein from black
;  5: fadeout to black, stop at a specified amount
;  6: fadein from black, stop at a specified amount
;  7: fadein for a room (has an additional check for dark room)
;  8: fade between two palettes (only BG2-BG7; BG0-BG1 and OBJ palettes don't fade.)
;  9: fadeout to white (using delay from wPaletteThread_counter)
;  a: fadein from white (with delay)
;  b: fadeout to black (with delay)
;  c: fadein from black (with delay)
;  d: ages only?
;  e: ages only?
	db
wPaletteThread_speed: ; $c4ac
; Amount to increase/decrease wPaletteThread_fadeOffset by on each iteration of the
; palette thread
	db
wPaletteThread_updateRate: ; $c4ad
; The palette thread only updates once every X frames.
	db
wPaletteThread_parameter: ; $c4ae
; For palette modes 5/6, this is where to stop when fading in/out.
; For palette mode 7, this is 1 if the room fading in is dark?
	db
wPaletteThread_counter: ; $c4af
; For certain modes, this acts as delay to slow down the palette thread.
	db
wPaletteThread_counterRefill: ; $c4b0
; Refills wPaletteThread_counter when it reaches 0.
	db

; These are like the corresponding hram variables "hDirtyBgPalettes" etc, but they're not
; immediately checked; they're sometimes "or'd" with those variables?
wDirtyFadeBgPalettes: ; $c4b1
	db
wDirtyFadeSprPalettes: ; $c4b2
	db
wFadeBgPaletteSources: ; $c4b3
	db
wFadeSprPaletteSources: ; $c4b4
	db

wLockBG7Color3ToBlack: ; $c4b5
; If set to 1, color 3 of bg palette 7 is always black, regardless of palette fading.
; Used in the intro cutscene.
	db

wc4b6: ; $c4b6
; If bit 0 is set, objects don't get drawn.
	db

wRamFunction: ; $c4b7
; This is just a jp opcode
	dsb 3

wPuddleAnimationPointer: ; $c4ba
; This is a pointer to the oam data for the animation when you stand in a puddle. Updated
; every 16 frames.
	dw

; $c4bb-$c4bf unused?

.ENDS


.RAMSECTION Wram0_c4c0

wTerrainEffectsBuffer: ; $c4c0
; This might only be used for drawing objects' shadows, though in theory it could also be
; used to draw puddles and grass as objects walk over them.  Each entry is 4 bytes: Y, X,
; and an address in the "Special_Animations" section (bank $14).
	dsb $40

wObjectsToDraw: ; $c500
; A buffer keeping track of which objects to draw, in what order (first = highest
; priority). Each entry is 2 bytes, consisting of the address of high byte of the object's
; y-position.
;
; The entries are divided into 4 groups of 16. Each group corresponds to a value for the
; "object.visible" variable (value from 0-3). Lower values have higher draw priority.
;
; Must be aligned to $100 bytes.
	dsb $80

; $c580-$c5af unused?

.ENDS

; ========================================================================================
; Everything from this point ($c5b0) up to $caff goes into the save data ($550 bytes).
; ========================================================================================

.RAMSECTION Wram0_c5b0

wFileStart: ; $c5b0
; Start of file data (same address as checksum)
	.db

wFileChecksum: ; $c5b0
	dw

wSavefileString: ; $c5b2
; This string is checked to verify the save data.
; Seasons: "Z11216-0"
; Ages:    "Z21216-0"
	dsb 8

; $c5ba-$c5bf unused?

.ENDS


.RAMSECTION Wram0_c5c0

wUnappraisedRings: ; $c5c0
; List of unappraised rings. each byte always seems to have bit 6 set, indicating that the
; ring is unappraised. It probably gets unset the moment you appraise it, but only for
; a moment because then it disappears from this list.
	dsb $40

wUnappraisedRingsEnd: ; $c600
	.db

; ========================================================================================
; C6xx block: deals largely with inventory, also global flags
; ========================================================================================

wc600Block: ; $c600
	.db

; Addresses $c600-c615 are copied across the link cable when a "game link" is performed.

wGameID: ; $c600
; The unique game ID that is used to make secrets exclusive to a particular set of files.
; If 0, it's considered "not yet decided"?
; Otherwise, it's always between $0001-$7fff?
	dw

wLinkName: ; $c602
; 6 bytes, null terminated
	dsb 5

wLinkNameNullTerminator:
; This is read by unrelated things (item drop table) as a value which is assumed to always be 0.
	db

wc608: ; $c608
; This is always 1. Used as a dummy value in various places?
	db

wKidName: ; $c609
	dsb 6

wChildStatus: ; $c60f
	db

wAnimalCompanion: ; $c610
; $0b for ricky, $0c for dimitri, $0d for moosh (same as the SpecialObject id's for their
; corresponding objects)
	db

wWhichGame: ; $c611
; Always 0 for seasons, always 1 for ages.
; Used primarily (only?) for secret generation.
	db

wFileIsLinkedGame: ; $c612
; Copied to wIsLinkedGame
	db

wFileIsHeroGame: ; $c613
	db

wFileIsCompleted: ; $c614
	db

wObtainedRingBox: ; $c615
; Remembers whether you've obtained the ring box / friendship ring.
; There's also a global flag for this, so its only purpose may be keeping track of it for
; linked games?
	db


; END of $16 byte "file header" that gets copied over from file linking.


wRingsObtained: ; $c616
; Bitset of rings obtained
	dsb 8

wDeathCounter: ; $c61e
; 2-byte bcd number
	dw

wTotalEnemiesKilled: ; $c620
; Used for the Slayer's ring.
	dw

wPlaytimeCounter: ; $c622
	dsb 4

wTotalSignsDestroyed: ; $c626
; Used for the sign ring.
	db

wTotalRupeesCollected: ; $c627
; Used for the rupee ring. 2 bytes.
	dw

wTextSpeed: ; $c629
	db

wActiveLanguage: ; $c62a
; Doesn't do anything on the US version
	db

wDeathRespawnBuffer: ; $c62b
; $0c bytes
	INSTANCEOF DeathRespawnStruct

wLastAnimalMountPointY: ; $c638
; Looks like a component is set to $10 or $70 if the animal enters from
; a particular side. Not sure what it's used for.
	db
wLastAnimalMountPointX: ; $c639
	db

wMinimapGroup: ; $c63a/$c63a
; Like wActiveGroup, but for the minimap. Not updated in caves.
	db

wMinimapRoom: ; $c63b
; Analagous to wMinimapGroup
	db

wMinimapDungeonMapPosition: ; $c63c
	db
wMinimapDungeonFloor: ; $c63d
	db

.ifdef ROM_AGES

wPortalGroup: ; $c63e
; This is set to $ff at the beginning of the game, indicating there's no portal.
	db
wPortalRoom: ; $c63f
	db
wPortalPos: ; $c640
	db

.endif

wMapleKillCounter: ; $c641/$c63e
; Maple appears when this reaches 30 (15 with Maple's ring).
	db

wBoughtShopItems1: ; $c642/$c63f
; Bit 0: Bought ring box (ages) or satchel (seasons) upgrade from hidden shop.
; Bit 1: Bought gasha seed 1 from hidden shop.
; Bit 2: Bought gasha seed 2 from hidden shop.
; Bit 3: Bought ring (ages) or treasure map (seasons) from hidden shop.
; Bit 5: Bought gasha seed from normal shop (linked game only).
; Bit 7: Set the first time you talk to the shopkeeper for the chest game.
	db

wBoughtShopItems2: ; $c643/$c640
; Bit 0: Bought gasha seed from advance shop.
; Bit 1: Bought gba ring from advance shop.
; Bit 2: Bought random ring from advance shop.
; Bit 3: Set if the flute should be sold instead of hearts (calculated on the fly)
; Bit 4: Set iff link has bombchus (calculated on the fly)
; Bit 5: Set iff link doesn't have bombchus (calculated on the fly)
; Bit 6: Bought heart piece from hidden shop (ages only).
	db

wMapleState: ; $c644/$c641
; Bits 0-3: Number of maple encounters?
; Bit 4:    Set while touching book is being exchanged (unset at end of encounter)
; Bit 5:    Set if the touching book has been exchanged (permanently set)
; Bit 7:    Set if maple's heart piece has been obtained
	db

wBoughtSubrosianShopItems: ; $c645/$c642
; Bit 0: Bought Ribbon
; Bit 1: Bought piece of heart
; Bit 2: Bought bomb upgrade
; Bit 3: Bought gasha seed
; Bit 4: Bought ring 1
; Bit 5: Bought ring 2
; Bit 6: Bought ring 3
; Bit 7: Bought ring 4
; (Member's Card is considered "bought" if it's in your inventory)
	db

wCompanionStates: ; $c646
	.db

wRickyState: ; $c646/$c643
; bit 0: set if you've talked to Ricky about getting his gloves
;     5: set if you've returned Ricky's gloves
;     6: set when Ricky leaves you after obtaining island chart
;     7: set if you have Ricky's flute
	db
wDimitriState: ; $c647/$c644
; ages:
; bit 0: set if you've seen the initial cutscene of the tokays discussing eating dimitri
;     1: set if you've driven off the tokays harassing Dimitri
;     2:
;     5: set if you've talked to Dimitri after saving him from the tokays
;     6: set if Dimitri should disappear from Tokay Island.
;     7: set if you have Dimitri's flute
; seasons:
; bit 0: 1st bully in Spool/Sunken spoke (signal to 2nd to speak)
;     1: 2nd bully in Spool/Sunken spoke (signal to 3rd to speak)
;     2: 3rd bully in Spool/Sunken spoke (signal to 1st to prompt for payment)
;     3: set when Dimitri is saved from bullies in Spool/Sunken (signal to 2nd to speak)
;     4: after above, set by bully 2 (signal to 3rd to speak) / in Sunken, set by bully 3
;        (signal for all 3 to leave)
;     5: after above, set by bully 3 (signal for all 3 to leave) / set in moblin rest house
;        (signal for bullies to appear 2 screens left)
;     7: tutorial on Dimitri's usage given
	db
wMooshState: ; $c648/$c645
; ages:
; bit 5:
;     6: set if he's left after you finished helping him
;     7: set if you have Moosh's flute
; seasons:
; bit 0: attacked moblin bully
;     1: talked to Moosh after above
;     2: moblins lost and fleed
;     3: left after above, came back, and reinforcements arrived
;     4: ?
;     5: set if you have Moosh's flute
;     6: set if Moosh should disappear from mt. cucco
;     7: set after giving spring bananas to moosh
	db
wCompanionTutorialTextShown: ; $c649
; Bits here are used by INTERACID_COMPANION_TUTORIAL to remember which pieces of
; "tutorial" text have been seen.
; Bit 0: Ricky hopping over holes
; Bit 1: Ricky jumping over cliffs
; bit 2: Carrying Dimitri
; Bit 3: Dimitri swimming up waterfalls
; Bit 4: Moosh fluttering
; bit 5: Moosh's buttstomp
	db
wc64a: ; $c64a/$c647
	db
wc64b: ; $c64b
	db

wGashaSpotFlags:	 ; $c64c/$c649
; Bit 0 is set if you've harvested at least one gasha nut before. The first gasha nut
; always gives you a "class 1" ring (one of the weak, common ones).
; Bit 1 is set if you've obtained the heart piece from one of the gasha spots.
	db
wGashaSpotsPlantedBitset: ; $c64d/$c64a
; 2 bytes (1 bit for each spot)
	dsb NUM_GASHA_SPOTS/8
wGashaSpotKillCounters: ; $c64f/$c64c
; 16 bytes (1 byte for each spot)
	dsb NUM_GASHA_SPOTS

wGashaMaturity: ; $c65f/$c65c
; When this value is 300 or higher, you get the best prizes from gasha trees; otherwise,
; the prizes get progressively worse.
; Many things increase this (digging, getting essence, screen transitions), and it gets
; decreased by 200 when a gasha nut is harvested.
	dw

.ifdef ROM_AGES
wc661: ; $c661
	db
.else
ws_c65d: ; TODO: figure out what this is
	dsb 4
.endif

wDungeonVisitedFloors: ; $c662/$c662
; 1 byte per dungeon ($10 total). Each byte is a bitset of visited floors for a particular dungeon.
	dsb NUM_DUNGEONS

wDungeonSmallKeys: ; $c672/$c66e
; 1 byte per dungeon.
	dsb NUM_DUNGEONS

wDungeonBossKeys: ; $c682/$c67a
; Bitset of boss keys obtained
	dsb NUM_DUNGEONS_DIV_8

wDungeonCompasses: ; $c684/$c67c
; Bitset of compasses obtained
	dsb NUM_DUNGEONS_DIV_8

wDungeonMaps: ; $c686/$c67e
; Bitset of maps obtained
	dsb NUM_DUNGEONS_DIV_8

wInventoryB: ; $c688/$c680
	db
wInventoryA: ; $c689/$c681
	db
wInventoryStorage: ; $c68a/$c682
; $10 bytes
	dsb INVENTORY_CAPACITY

wObtainedTreasureFlags: ; $c69a/$c692
; Enough memory reserved for $80 treasures (though only about $68 are used)
	dsb $10

wLinkHealth: ; $c6aa/$c6a2
	db
wLinkMaxHealth: ; $c6ab/$c6a3
	db
wNumHeartPieces: ; $c6ac/$c6a4
	db

wNumRupees: ; $c6ad/$c6a5
	dw

.ifdef ROM_SEASONS
wNumOreChunks: ; $c6a7
	dw
.endif

wShieldLevel: ; $c6af/$c6a9
	db
wNumBombs: ; $c6b0/$c6aa
	db
wMaxBombs: ; $c6b1/$c6ab
	db
wSwordLevel: ; $c6b2/$c6ac
	db
wNumBombchus: ; $c6b3/$c6ad
	db
wSeedSatchelLevel: ; $c6b4/$c6ae
; Determines satchel capacity
	db
wFluteIcon: ; $c6b5/$c6af
; Determines icon + song, but not companion
	db

.ifdef ROM_AGES

wSwitchHookLevel: ; $c6b6
	db
wSelectedHarpSong: ; $c6b7
; 1 = Tune of Echoes;
; 2 = Tune of Currents;
; 3 = Tune of Ages
	db
wBraceletLevel: ; $c6b8
	db

.else; ROM_SEASONS

wObtainedSeasons: ; $c6b0
	db
wBoomerangLevel: ; $c6b1
	db
wMagnetGlovePolarity: ; $c6b2
; 0=S, 1=N
	db
wSlingshotLevel: ; $c6b3
	db
wFeatherLevel: ; $c6b4
	db

.endif

wNumEmberSeeds: ; $c6b9/$c6b5
	db
wNumScentSeeds: ; $c6ba/$c6b6
	db
wNumPegasusSeeds: ; $c6bb/$c6b7
	db
wNumGaleSeeds: ; $c6bc/$c6b8
	db
wNumMysterySeeds: ; $c6bd/$c6b9
	db
wNumGashaSeeds: ; $c6be/$c6ba
	db
wEssencesObtained: ; $c6bf/$c6bb
	db
wTradeItem: ; $c6c0
	db

.ifdef ROM_AGES

wc6c1: ; $c6c1
	db
wTuniNutState: ; $c6c2
; 0: broken
; 1: not in inventory (doing patch's game)
; 2: fixed (only within Link's inventory?)
	db
wNumSlates: ; $c6c3
; Slates used only in ages dungeon 8
	db

.else; ROM_SEASONS

wPirateBellState: ; -/$c6bd
	db
.endif

wSatchelSelectedSeeds: ; $c6c4/$c6be
	db
wShooterSelectedSeeds: ; $c6c5/$c6bf
; Can also be slingshot selected seeds for seasons
	db
wRingBoxContents: ; $c6c6/$c6c0
	dsb 5
wActiveRing: ; $c6cb/$c6c5
; When bit 6 is set, the ring is disabled?
	db
wRingBoxLevel: ; $c6cc/$c6c6
	db
wNumUnappraisedRingsBcd: ; $c6cd
	db
wNumRingsAppraised: ; $c6ce
; Once this reaches 100, Vasu gives you the 100th ring.
	db
wKilledGoldenEnemies: ; $c6cf/$c6c9
; Bit 0: killed golden octorok
; Bit 1: killed golden moblin
; Bit 2: killed golden darknut
; Bit 3: killed golden lynel
	db

wGlobalFlags: ; $c6d0/$c6ca
	dsb NUM_GLOBALFLAGS/8

wChildStage: ; $c6e0/$c6da
; Determines the "stage" of child's growth.
	db
wNextChildStage: ; $c6e1/$c6db
; The next stage of the child's growth. It will advance to this state after leaving the
; house and coming back a bit later.
	db
wc6e2: ; $c6e2/$c6dc
; Bit 0: Baby has been named
; Bit 1: Money has been given for doctor
; Bit 2: Advice has been given about how to get the baby to sleep
; Bit 3: You've told Blossom what kind of child you were
; Bit 4: Stage 6 done (answered a question from the child).
; Bit 5: Stage 8 done (depends on personality type)
	db
wChildStage8Response: ; $c6e3/$c6dd
; This is the response to the child's question or request at stage 8.
	db
wChildPersonality: ; $c6e4/$c6de
; When [wChildStage] >= 4, he starts developing a personality.
; For stages 4-6:
;   0: Hyperactive
;   1: Shy
;   2: Curious
; For stages 7+:
;   0: Slacker
;   1: Warrior
;   2: Arborist
;   3: Singer
	db
wc6e5: ; $c6e5/$c6df ; In seasons, growth of Maku tree
	db

.ifdef ROM_SEASONS

ws_c6e0: ; TODO: figure out what this is
	db

wInsertedJewels: ; -/$c6e1
; Bitset of jewels inserted into tarm ruins entrance.
	db

wNumTimesPlayedSubrosianDance: ; -/$c6e2
	db

wNumTimesPlayedStrangeBrothersGame: ; -/$c6e3
	db

wTalkedToPirationCaptainState: ; -/$c6e4
; 0: Not yet talked to him after D6 beaten
; 1: Talked to him without a bell
; 2: Talked to him with a bell (either rusty or fixed)
	db

.endif


wMakuMapTextPresent: ; $c6e6/$c6e5
; Low byte of text index (05XX) of text to show when selecting maku tree on map
	db

.ifdef ROM_AGES

wMakuMapTextPast: ; $c6e7
	db

wMakuTreeState: ; $c6e8
; Keeps track of what the Maku Tree says when you talk to her.
; 0: Haven't met yet
; 1: Disappeared from the present
	db

wJabuWaterLevel: ; $c6e9
; Bits 4-7: Remembers which buttons are pressed. Corresponds to same bits in wSwitchState.
; Bits 0-3: Actual water level (0 for drained, 2 for full)
	db

wWildTokayGameLevel: ; $c6ea
; Goes up to 4. (Level 0 is playing for the scent seedling.)
	db

wMakuTreeSeedSatchelXPosition: ; $c6eb
	db

wPirateShipRoom: ; $c6ec
; Low room index the pirate ship is in
	db
wPirateShipY: ; $c6ed
	db
wPirateShipX: ; $c6ee
	db
wPirateShipAngle: ; $c6ef
	db

wc6f0: ; $c6f0
	dsb $b

.endif ; ROM_AGES

wShortSecretIndex: ; $c6fb/$c6e6
; bits 0-3: index of a small secret?
; bits 4-5: indicates the game it's for, and whether it's a return secret or not?
; Also used as a placeholder in the "giveTreasure" function?
	db

wc6fc: ; $c6fc
	db

wSecretXorCipherIndex: ; $c6fd
; Value from 0-7 which tells the secret generator which xor cipher to use.
	db

wSecretType: ; $c6fe
; 0: game transfer secret
; 1: same? (unused?)
; 2: ring secret
; 3: 5-letter secret
	db

.ENDS

.define wSeedsAndHarpSongsObtained	wObtainedTreasureFlags+TREASURE_EMBER_SEEDS/8


.RAMSECTION Wram0_c700

; Flags shared for above water and underwater
wPresentRoomFlags: ; $c700
	dsb $100
wPastRoomFlags: ; $c800
	dsb $100

wGroup4Flags: ; $c900
	dsb $100
wGroup5Flags: ; $ca00
	dsb $100

.ENDS

; "group 2" = present underwater in Ages, or indoor rooms in Seasons (shared with subrosia map). Set
; room flags accordingly.
.ifdef ROM_AGES
	.define wGroup2Flags wPresentRoomFlags
.else
	.define wGroup2Flags wPastRoomFlags
.endif

.ifdef ROM_AGES
	; Steal 6 of the past room flags for vine seed positions.
	; (Only 5 vines exist, but 6 bytes are used?)
	.define wVinePositions wPastRoomFlags+$f0
.else; ROM_SEASONS
	; Steal 16 of subrosia's room flags for rupee room rupees gotten
	.define wD2RupeeRoomRupees wPastRoomFlags+$f0
	.define wD6RupeeRoomRupees wPastRoomFlags+$f8
.endif

; ========================================================================================
; $cb00: END of data that goes into the save file
; ========================================================================================

.RAMSECTION Wram0_cb00

wOam: ; $cb00
	dsb $a0
wOamEnd: ; $cba0
	.db

wTextIsActive: ; $cba0/$cba0
; Nonzero if text is being displayed.
; If $80, text has finished displaying while TEXTBOXFLAG_NONEXITABLE is set.
	db

wTextDisplayMode: ; $cba1
; $00: standard text
; $01: selecting an option
; $02: inventory screen / ring menu (instant drawing?)
	db

wTextIndex: ; $cba2
; Note that the text index is incremented by $400 before being written here.
; This is due to there being 4 dictionaries. Within text routines, this
; 4-higher value is used.
	.dw
wTextIndexL: ; $cba2
	db
wTextIndexH: ; $cba3
	db
wTextIndexH_backup: ; $cba4
	db

wSelectedTextOption: ; $cba5
; Selected option in a textbox, ie. yes/no
; Bit 7 can be set sometimes?
	db

wTextGfxColorIndex: ; $cba6
; What color text should be as it's read from the retrieveTextCharacter
; function. Values 0-2 set the text to those respective colors, while a value
; of 3 tells it to read in 2bpp format instead.
	db

wTextMapAddress: ; $cba7
; Where the tile map is for the text (always $98?)
	db

wTextNumberSubstitution: ; $cba8
; 2-byte BCD number that can be inserted into text.
; The shooting gallery keeps track of score here.
	dw

wcbaa: ; $cbaa
; cbaa/ab are similar to wTextNumberSubstitution, but possibly unused?
	dw

wTextboxPosition: ; $cbac
; Value from 0-6 determining the position of the textbox.
	db

wcbad: ; $cbad
; Used by syrup?
	db

wTextboxFlags: ; $cbae
	db

wTextSubstitutions: ; $cbaf
; $cbaf-cbb2; each byte is an index which can be used with text control code
; $F, when the parameter is $ff, $fe, $fd, or $fc. The text corresponding to
; the index is inserted into the textbox at that point.
	dsb 4


; Following variables are used for a variety of purposes.
; Each "union" entry uses the same space in RAM for different purposes.
; You'd use, for example, "wFileSelect.mode" to access a variable.

wMenuUnionStart:
	.db

; This union has both "file select" and "text input" stuff.
.union wFileSelect

	mode: ; $cbb3
		db
	mode2: ; $cbb4
		db
	cbb5 ; $cbb5
		db
	cbb6:
		db
	textInputMode: ; $cbb7
	; Bit 7 means secret entry?
	; $00 for link name input
	; $01 for kid name input
	; $80 for 5-letter secret input
	; $81 for ring secret input
	; $82 for secret input for new file
		db
	textInputMaxCursorPos: ; $cbb8
	; The number of characters that can be entered on a text input screen (minus one)
		db
	kanaMode: ; $cbb9
	; 0: hiragana, 1: katakana (japanese version only)
		db
	fontXor: ; $cbba
		db
	cursorOffset: ; $cbbb
		db
	cursorPos: ; $cbbc
		db
	cursorPos2: ; $cbbd
		db
	textInputCursorPos: ; $cbbe
		db
	linkTimer: ; $cbbf
		db
	cbc0: ; $cbc0
		db

.nextu wMapMenu

	mode: ; $cbb3
	; 0: present (overworld/underwater)
	; 1: past (overworld/underwater) or subrosia (seasons)
	; 2: dungeon
		db
	varcbb4: ; $cbb4
	; - Acts as a counter while scrolling between floors in dungeon map
		db
	currentRoom: ; $cbb5
	; Normally this is the current room index.
	; For dungeon maps, this is 0 when scrolling up, 1 when scrolling down.
		db
	cursorIndex: ; $cbb6
		db

	; Overworld only
	.union
		warpIndex: ; $cbb7
		; The index of the selected warp point in the gale seed menu.
			db
		cbb8:
			db
		popupState: ; $cbb9
		; Only used for overworld map.
		;   0: Icon is uninitialized
		;   1: Icon is popping in
		;   2: Icon is fully loaded
			db
		cbba: ; $cbba
			db
		popupY: ; $cbbb
		; Y position of the minimap's popup (ie. shows there's a house or gasha spot).
		; Not used in dungeon minimaps.
			db
		popupX: ; $cbbc
			db
		popupSize: ; $cbbd
		; This starts at 0 and increases until the popup icon reaches its full size (value 4).
			db
		popup1: ; $cbbe
			db
		popup2: ; $cbbf
			db
		popupIndex: ; $cbc0
		; Either 0 or 1 to determine whether to use popup1 or popup2.
			db
		drawWarpDestinations: ; $cbc1
		; Draws warp destinations for gale seed menu if nonzero.
			db
	; Dungeon only
	.nextu
		floorIndex: ; $cbb7
		; This counts from the top floor down, instead of bottom up like wDungeonFloor.
		; This is the floor being displayed, not the floor Link's on.
			db
		dungeonScrollY: ; $cbb8
			db
		dungeonCursorFlicker: ; $cbb9
		; Only used for dungeon map. Toggles from 0/1 to make the cursor visible or not.
			db
		visitedFloors: ; $cbba
		; Bitset of floors available to scroll through on minimap (before getting the map).
			db
		dungeonCursorIndex: ; $cbbb
			db
		linkFloor: ; $cbbc
		; Only used in dungeons
			db
	.endu

.nextu wRingMenu

	selectedRing: ; $cbb3
	; The ring which the cursor is hovering over (and is having its text displayed).
	; $FF for no ring.
		db
	ringListCursorIndex: ; $cbb4
	; Index of cursor in the ring list ($0-$f).
		db
	numPages: ; $cbb5
		db
	page: ; $cbb6
	; Value from 0-3, corresponding to the page in the ring menu.
		db
	cbb7: ; $cbb7
		db
	listCursorFlickerCounter: ; $cbb8
		db
	rupeeRefundValue:  ; $cbb9
	; Set to $07 (corresponds to 30 rupees) if you appraise a ring you already own.
		db
	tileMapIndex: ; $cbba
	; The ring menu cycles between the two tilemaps to provide the scrolling effect.
		db
	ringNameTextIndex: ; $cbbb
		db
	scrollDirection: ; $cbbc
	; $01 for right scrolling, $ff for left scrolling
		db
	ringBoxCursorIndex: ; $cbbd
	; The index of the cursor on the ring box.
		db
	boxCursorFlickerCounter: ; $cbbe
	; When $80 or above, the ring box cursor flickers. When $00, it's displayed constantly.
		db
	displayedRingNumberComparator: ; $cbbf
	; This is compared with ringListCursorIndex; when they differ, the displayed
	; ring number is updated.
		db
	descriptionTextIndex: ; $cbc0
		db
	textDelayCounter: ; $cbc1
	; When nonzero, this delay showing the text for a ring in the ring box.
		db
	textDelayCounter2: ; $cbc2
		db

.nextu wSaveQuitMenu

	state: ; $cbb3
		db
	gameOver: ; $cbb4
	; 0 if the menu was entered voluntarily; 1 if we got here from a game-over.
		db
	cursorIndex: ; $cbb5
	; Value from 0-2
		db
	delayCounter: ; $cbb6
		db

.nextu wSecretListMenu

	state: ; $cbb3
		db
	cbb4: ; $cbb4
		db
	numEntries: ; $cbb5
	; This is the maximum value (plus one) that the cursor can be in farore's secret list.
		db
	cursorIndex: ; $cbb6
		db
	scroll: ; $cbb7
	; This value is the index of the first entry listed at the top. Scrolling the menu down
	; increases this.
		db
	scrollSpeed: ; $cbb8
		db
	; $cbba: wFileSelect.fontXor

.nextu wFakeResetMenu

	state: ; $cbb3
		db
	delayCounter: ; $cbb4
		db

.nextu wIntro

	wcbb3:
		db
	wcbb4:
		db
	cinematicState: ; $cbb5
	; Value from 0-2:
	;   0: Link riding horse
	;   1: Link in temple approaching triforce
	;   2: Scrolling up the tree just before the titlescreen
		db
	cbb6:
		db
	frameCounter: ; $cbb7
	; Incremented once per frame while intro thread is running.
		db
	cbb8:
		db
	triforceState: ; $cbb9
	; This variable is used as communication between cutscene objects and the main code in the
	; "runIntroCinematic" function?
		db
	cbba:
		db

.nextu wInventory
	cbb3:
		db
	cbb4:
		db
	itemSubmenuIndex: ; $cbb5
	; Selection in submenus (seeds, harp)
		db
	cbb6:
		db
	selectedItem: ; $cbb7
		db
	cbb8:
		db
	submenu2CursorPos2: ; $cbb9
		db
	cbba:
		db
	activeText: ; $cbbb
		db
	cbbc: ; $cbbc
		db
	cbbe: ; $cbbd
		db
	itemSubmenuCounter: ; $cbbe
		db
	itemSubmenuMaxWidth: ; $cbbf
		db
	itemSubmenuWidth: ; $cbc0
		db
	cbc1:
		db

.nextu wGenericCutscene

	cbb3: ; $cbb3
	; A counter, often used with "flashScreen" function?
		db

	cbb4: ; $cbb4
		db

	cbb5: ; $cbb5
		db

	cbb6: ; $cbb6
		db

	cbb7: ; $cbb7
		db

	cbb8: ; $cbb8
		db

	cbb9: ; $cbb9
		db

	cbba: ; $cbba
		db

	cbbb: ; $cbbb
		db

	cbbc: ; $cbbc
		db

	cbbd: ; $cbbd
		db

	cbbe: ; $cbbe
		db

	cbbf: ; $cbbf
		db

	cbc0: ; $cbc0
		db

	cbc1: ; $cbc1
		db

	cbc2: ; $cbc2
		db

.nextu

	; TODO: replace all references to wTmpcbXX with meaningful names

	wTmpcbb3: ; $cbb3
		db

	wTmpcbb4: ; $cbb4
		db

	wTmpcbb5: ; $cbb5
	; Used for:
	; - Index of link's position on map
	; - Index of an interaction?
	; - Cutscene where a hand grabs you in the black tower
		db

	wTmpcbb6: ; $cbb6
	; Used for:
	; - Index of cursor on map
	; - Something in menus
		db

	wTmpcbb7: ; $cbb7
		db

	wTmpcbb8: ; $cbb8
	; Also used by:
	; * Black tower cutscene after d3?
		db

	wTmpcbb9: ; $cbb9
		db

	wTmpcbba: ; $cbba
		db

	wTmpcbbb: ; $cbbb
		db

	wTmpcbbc: ; $cbbc
		db

	wTmpcbbd: ; $cbbd
		db

	wTmpcbbe: ; $cbbe
		db

	wTmpcbbf: ; $cbbf
		db

	wTmpcbc0: ; $cbc0
		db

	wTmpcbc1: ; $cbc1
		db

	wTmpcbc2: ; $cbc2
		db

.endu

wMenuUnionEnd:
	.db

wUseSimulatedInput: ; $cbc3
; When set to $01, Link will perform "simulated" input, ie. in the opening cutscene.
; When set to $02, input is normal except that the direction buttons are reversed.
; When set to $ff (bit 7 set), the "getSimulatedInput" function does not read any more
; inputs, and will always return the last input read.
	db
wSimulatedInputCounter: ; $cbc4
	dw
wSimulatedInputBank: ; $cbc6
; $cbc6-$cbc8: 3-byte pointer
	db
wSimulatedInputAddressL: ; $cbc7
	db
wSimulatedInputAddressH: ; $cbc8
	db
wSimulatedInputValue: ; $cbc9
	db

wDisableLinkCollisionsAndMenu: ; $cbca
; Disables menu and link's collisions when nonzero.
; Set while warping, being shocked, getting essence, opening chest, playing harp/flute...
	db

wOpenedMenuType: ; $cbcb
; The "openMenu" function sets this variable to something.
;  $01: inventory
;  $02: map
;  $03: save/quit menu
;  $04: ring appraisal
;  $05: warp menu
;  $06: secret input
;  $07: child name input
;  $08: ring linking
;  $09: fake reset
;  $0a: farore's secret list
	db

wMenuLoadState: ; $cbcc
	db

wMenuActiveState: ; $cbcd
; When the inventory menu is open, this is 3 while it's scrolling, and 1 otherwise?
	db

wSubmenuState: ; $cbce
; Used for:
; - item submenus (selecting seed satchel, shooter, or harp).
; - scrolling between subscreens?
; - map screen
; - dungeon map: 0 when not scrolling; 1 when scrolling.
; - ring menu: 0 when selecting ring box rings, 1 when selecting something from the list.
	db

wInventorySubmenu: ; $cbcf/$cbcf
; Value from 0-2, one for each submenu on the inventory screen
	db

wInventorySubmenu0CursorPos: ; $cbd0
	db
wInventorySubmenu1CursorPos: ; $cbd1
	db
wInventorySubmenu2CursorPos: ; $cbd2
	db
wRingMenu_mode: ; $cbd3
; 0: display unappraised rings
; 1: display ring list
	db
wLastSecretInputLength: ; $cbd4
; This is compared with wFileSelect.textInputMaxCursorPos when a secret input menu is
; opened. If these variables differ, that must mean a different secret type is being
; entered, so the secret will be cleared before proceeding.
	db


wGfxRegs4: ; $cbd5
	INSTANCEOF GfxRegsStruct

wGfxRegs5: ; $cbdb
	INSTANCEOF GfxRegsStruct


wcbe1: ; $cbe1
; cbe1/2: screen scroll for menus?
	db
wcbe2: ; $cbe2
	db
wExtraBgPaletteHeader: ; $cbe3
; Palette header index to reload upon exiting a menu (separate from normal tileset
; palettes).
; In the ganon fight, this is used to keep track of the palette on the inverted
; control screen (background palette 7). This may be its only use.
	db
wDisplayedHearts: ; $cbe4
	db

.ifdef ROM_SEASONS
wDisplayedMoneyAddress: ; $cbe5
; Lower byte of "money" variable to print (either wNumRupees or wNumOreChunks)
	db
.endif

wDisplayedRupees: ; $cbe5/$cbe6
	dw

wDontUpdateStatusBar: ; $cbe7
; if nonzero, status bar doesn't get updated
	db

wcbe8: ; $cbe8
; Bit 7: whether status bar is reorganized for biggoron's sword maybe?
; Bit 0 set if status bar needs to be reorganized slightly for last row of hearts
	db

wStatusBarNeedsRefresh: ; $cbe9/$cbea
; Bit 0: A/B buttons need refresh?
; Bit 1: A/B button item count needs refresh? (ie. seed count)
; Bit 2: heart display needs refresh
; Bit 3: rupee count needs refresh
; Bit 4: small key count
	db


; The following "wBItem" and "wAItem" variables are loaded almost directly from the
; "treasureDisplayData" structure.

wBItemTreasure: ; $cbea
; wBItemTreasure: This is the treasure index used to determine the item's level / ammo
; count. Usually this is either $00 or equal to [wInventoryB], but not always - the seed
; satchel sets this to a different value for each seed type, for instance.
	db
wBItemSpriteAttribute1: ; $cbeb
	db
wBItemSpriteAttribute2: ; $cbec
	db
wBItemSpriteXOffset: ; $cbed
	db
wBItemDisplayMode: ; $cbee
; Whether to display item level, ammo, etc
	db

wAItemTreasure: ; $cbef
	db
wAItemSpriteAttribute1: ; $cbf0
	db
wAItemSpriteAttribute2: ; $cbf1
	db
wAItemSpriteXOffset: ; $cbf2
	db
wAItemDisplayMode: ; $cbf3
	db

.ENDS


.RAMSECTION Wram0_cc00

wcc00Block: ; $cc00
	.db

wFrameCounter: ; $cc00
; Value copied from low byte of wPlaytimeCounter
	db

wIsLinkedGame: ; $cc01
	db

wMenuDisabled: ; $cc02
; Set during screen transitions
	db

wCutsceneState: ; $cc03
	db

wCutsceneTrigger: ; $cc04/$cc04
; Gets copied to wCutsceneIndex. So, writing a value here triggers a cutscene.
; (See constants/cutsceneIndices.s)
	db

.ifdef ROM_AGES
wcc05: ; $cc05
; bit 0: if unset, prevents the room's object data from loading
; bit 1: if unset, prevents object pointers from loading (enemies & item drops)
; bit 2: if unset, prevents remembered Companions from loading
; bit 3: if unset, prevents Maple from loading
	db
.endif

wLoadedObjectGfxIndex: ; $cc06/$cc05
; An index for wLoadedObjectGfx. Keeps track of where to add the next thing to be
; loaded?
	db

wcc07: ; $cc07/$cc06
	db

wLoadedObjectGfx: ; $cc08/$cc07
; This is a data structure related to used sprites. Each entry is 2 bytes, and
; corresponds to an object gfx header loaded into vram at its corresponding position.
; Eg. Entry $cc08/09 is loaded at $8000, $cc0a/0b is loaded at $8200.
; Byte 0 is the index of the object gfx header (see objectGfxHeaders.s).
; Byte 1 is whether these graphics are currently in use?
	dsb $10
wLoadedObjectGfxEnd: ; $cc18/$cc17
	.db

wLoadedTreeGfxIndex: ; $cc18/$cc17
; This (along with wLoadedTreeGfxActive) is the same structure as the above buffer, but
; only for trees.
	db
wLoadedTreeGfxActive: ; $cc19/$cc18
	db

wcc1a: ; $cc1a
	db

; These are uncompressed gfx header indices.
; They're used for loading graphics for certain items (sword, cane, switch hook,
; boomerang... not bombs, seeds).
wLoadedItemGraphic1: ; $cc1b/$cc1a
	db
wLoadedItemGraphic2: ; $cc1c/$cc1b
	db

wEnemyIDToLoadExtraGfx: ; $cc1d/$cc1c
; An enemy can write its ID byte here to request that "extra graphics" get loaded for it.
; It will continue loading subsequent object gfx headers until the "stop" bit is encountered.
; Can't use this at the same time as "wInteractionIDToLoadExtraGraphics"?
	db
wInteractionIDToLoadExtraGfx: ; $cc1e/$cc1d
; Same as above, but for interactions.
	db

.ifdef ROM_SEASONS

wcc1e: ; -/$cc1e
; Unused?
	db
.endif

.ENDS


; This section is at a different location depending on the game.
; Ages: Starts at $cc1f. Appended to "Wram0_cc00" section just above
; Seasons: Starts at $cc3b. Appended to "Wram0_FloatingSection2" section.
;          (Addrs $cc1f-$cc3a are used but defined later, in the aforementioned section.)

.RAMSECTION Wram0_FloatingSection1

wcc1f: ; $cc1f/$cc3b
; Used in Seasons during a cutscene?
	dw

; Point to respawn after falling in hole or w/e
wLinkLocalRespawnY: ; $cc21/$cc3d
	db
wLinkLocalRespawnX: ; $cc22/$cc3e
	db
wLinkLocalRespawnDir: ; $cc23/$cc3f
	db


; These variables remember the location of your last mounted companion
; (ricky/dimitri/moosh or the raft; they overwrite each other)
wRememberedCompanionId: ; $cc24/$cc40
	db
wRememberedCompanionGroup: ; $cc25
	db
wRememberedCompanionRoom: ; $cc26
	db
wRememberedCompanionY: ; $cc27/$cc43
	db
wRememberedCompanionX: ; $cc28/$cc44
	db


; Dunno what the distinction is between these and wKeysPressed, wKeysJustPressed?
wGameKeysPressed: ; $cc29/$cc45
	db
wGameKeysJustPressed: ; $cc2a/$cc46
	db

wLinkAngle: ; $cc2b/$cc47
; Same as w1Link.angle? Set to $FF when not moving. Should always be a multiple of
; 4 (since d-pad input doesn't allow more fine-grained angles)
; This may correspond more to the direction button input than to the Link object in
; particular.
	db

wLinkObjectIndex: ; $cc2c/$cc48
; Usually $d0; set to $d1 while riding an animal, minecart
	db

wActiveGroup: ; $cc2d/$cc49
; Ages:
;   Groups 0-5 are the normal groups.
;   6-7 are the same as 4-5, except they are considered sidescrolling rooms.
; Seasons:
;   0: Overworld
;   1: Subrosia
;   2: Maku tree screens
;   3: Indoors (usually on a subrosia map)
;   4-5: Dungeons
;   6-7: Dungeons in sidescrolling mode?
	db

wRoomIsLarge: ; $cc2e/$cc4a
; $00 for normal-size rooms, $01 for large rooms
	db

wLoadingRoom: ; $cc2f/$cc4b
	db
wActiveRoom: ; $cc30/$cc4c
	db
wRoomPack: ; $cc31/$cc4d
	db

wRoomStateModifier: ; $cc32/$cc4e
; Can have values from 00-02: incremented by 1 when underwater, and when map flag 0 is
; set.
; Also set to $00-$02 depending on the animal companion region.
; Used by interaction 0 for conditional interactions.
; In seasons, this might determine the season?
	db

wActiveCollisions: ; $cc33/$cc4f
; wActiveCollisions should be a value from 0-5.
; 0: overworld, 1: indoors, 2: dungeons, 3: sidescrolling, 4: underwater, 5?
	db

wTilesetFlags: ; $cc34/$cc50
; See constants/areaFlags.
	db

wActiveMusic: ; $cc35/$cc51
; Don't know what the distinction for the 2 activeMusic's is
	db

wGrassAnimationModifier: ; $cc36/$cc52
; Change the color of the animation when objects walk in the grass. Unused in
; ages - it's meant to match the season.
; Valid values: $00 (green), $09 (blue), $1b (orange)
	db

wEyePuzzleTransitionCounter: ; $cc37/$cc53
; Used by the eye statue puzzle before the ganon/twinrova fight.
; Shares memory with wLostWoodsTransitionCounter1 below.
	.db

wLostWoodsTransitionCounter1: ; $cc37/$cc53
; Used for the screen transition leading north (to d6) in lost woods.
	db

wLostWoodsTransitionCounter2: ; $cc38/$cc54
; Used for the screen transition leading west (to sword upgrade) in lost woods.
	db

wDungeonIndex: ; $cc39/$cc55
; FF for overworld, other for mapped areas
	db

wDungeonMapPosition: ; $cc3a/$cc56
; Index on map for mapped areas (dungeons)
	db
wDungeonFloor: ; $cc3b/$cc57
; Index for w2DungeonLayout, possibly used for floors?
	db

wDungeonRoomProperties: ; $cc3c/$cc58
	db


wDungeonMapData: ; $cc3d
; 8 bytes of dungeonData copied to here
	.db

wDungeonFlagsAddressH: ; $cc3d/$cc59
; The high byte of the dungeon flags (wGroup4Flags/wGroup5Flags)
	db
wDungeonWallmasterDestRoom: ; $cc3e
; Warp destination index to use when a wallmaster grabs you
	db
wDungeonFirstLayout: ; $cc3f
; Index of dungeon layout data for first floor
	db
wDungeonNumFloors: ; $cc40
	db
wDungeonMapBaseFloor: ; $cc41
; Determines what the map will call the bottom floor (0 for "B3")
	db
wMapFloorsUnlockedWithCompass: ; $cc42
; Bitset of floors that are unlocked on the map with the compass
	db
wDungeonData6: ; $cc43
	db
wDungeonData7: ; $cc44
	db


wLoadingRoomPack: ; $cc45/$cc61
	db

wActiveMusic2: ; $cc46/$cc62
	db


wWarpDestVariables: ; $cc47/$cc63
	.db

wWarpDestGroup: ; $cc47/$cc63
; Group to warp to. If bit 7 is set, you warp directly to "wWarpDestGroup"/"wWarpDestRoom". If it is
; not set, then "wWarpDestRoom" is actually interpreted as an index for "warpDestTable"; the actual
; room value is written there shortly afterward.
	db
wWarpDestRoom: ; $cc48/$cc64
; This first holds the warp destination index, then (later) the room index.
	db
wWarpTransition: ; $cc49/$cc65
; Bits 0-3 are the half-byte given in WarpDest or StandardWarp macros. See "constants/transitions.s".
; Bit 6 determines link's direction for screen-edge warps (0 for up, 1 for down)?
; Bit 7 set if this is the "destination" part of the warp?
	db
wWarpDestPos: ; $cc4a/$cc66
	db
wWarpTransition2: ; $cc4b/$cc67
; wWarpTransition2 is set by code.
; Values for wWarpTransition2:
;   00: none
;   01: instant
;   03: fadeout
;   ff: exiting gale seed menu - prompts CUTSCENE_IN_GALE_SEED_MENU to not load room
; Bit 7 set for fadeout: fades out with delay
	db

wWarpDestVariablesEnd: ; $cc4c/$cc68
	.db

wcc4c: ; $cc4c/$cc68
	db

wSeedTreeRefilledBitset: ; $cc4d/$cc69
	dsb NUM_SEED_TREES/8

wLinkForceState: ; $cc4f/$cc6a
; When this is nonzero, Link's state (w1Link.state) is changed to this value.  Write $0b
; here (LINK_STATE_FORCE_MOVEMENT) to force him to move in a particular direction for
; [wLinkStateParameter] frames.
	db

wcc50: ; $cc50/$cc6b
;  LINK_STATE_04: bits 0-3: Link's animation (0 for LINK_ANIM_MODE_GETITEM1HAND;
;                                             1 for LINK_ANIM_MODE_GETITEM2HAND)
;                 bit 7: if set, don't revert to normal state even when wDisabledObjects
;                        is 0.
;  LINK_STATE_SQUISHED:
;                 Bits 0-6: If zero, he's squished hozontally, else vertically.
;                 Bit 7: If set, Link should die; otherwise he'll just respawn.
;  LINK_STATE_08: If nonzero, this sets Link's animation.
;  LINK_STATE_WARPING: ???
	db

wLinkStateParameter: ; $cc51/$cc6c
; Link's various states use this differently:
; $0a (LINK_STATE_WARPING): If bit 4 is set, the room Link warps to will not be marked as
;   "visited" (at least, for time-warp transitions).
; $0b (LINK_STATE_FORCE_MOVEMENT): This is the number of frames he will remain in that
;   state - effectively, the number of frames he will be forced to move in a particular
;   direction.
; This can be used for various other purposes depending on the state, though.
	db

wcc52: ; $cc52/$cc6d
; Used by LINK_STATE_04 to remember a previous animation?
	db

wHeartRingCounter: ; $cc53
; This counts up each frame while Link is moving. When it reaches a certain value
; (depending on the level of the ring), Link regains a small amount of health.
; It is 3 bytes large, apparently (24-bit).
	dsb 3

wDisableRingTransformations: ; $cc56
; When nonzero, Link appears in his normal form even when wearing a transformation ring.
; It will count down to 0, at which time transformations will be re-enabled.
	db

wLinkIDOverride: ; $cc57
; If nonzero, this overwrites "w1Link.id" at the start of the "updateSpecialObjects" func.
	db

wForceIcePhysics: ; $cc58
; When nonzero in a sidescrolling area, the tile below Link is considered to be an ice
; tile until he is no longer on solid ground.
	db

wSwordDisabledCounter: ; $cc59
	db

wLinkGrabState: ; $cc5a/$cc75
; Relates to whether Link is holding or trying to grab something.
; Bit 6 set when Link is grabbing, but not yet holding something?
; Some values:
;  $00 normally
;  $41 when grabbing something
;  $c2 when in the process of lifting something
;  $83 when holding something
	db

wLinkGrabState2: ; $cc5b/$cc76
; bit 7: set when pulling a lever?
; bits 4-6: weight of object (0-4 or 0-5?). (See _itemWeights.)
; bits 0-3: should equal 0, 4, or 8; determines where the grabbed object is placed
;           relative to Link. (See "updateGrabbedObjectPosition".)
	db


; cc5c-cce9 treated as a block: cleared when loading a room through "whiteout" transition


wLinkInAir: ; $cc5c/$cc77
; Bit 7: lock link's movement direction, prevent jumping. (Jumping down a cliff, using
;        gale seed, jumping into bed in Nayru's house, etc...)
; Bit 5: If set, Link's gravity is reduced
; Bit 1: set when link is jumping
; Bit 0: set when jumping down a cliff
; If nonzero, Link's knockback durations are halved.
	db

wLinkSwimmingState: ; $cc5d/$cc78
; Bit 7 is set when Link dives underwater.
; Bit 6 causes Link to drown (it's lava).
; Bits 0-3 hold a "state" which remembers whether Link is actually in the water, and
; whether he just entered or has been there for a few frames.
	db

wMagnetGloveState: ; $cc5e/$cc79
; Bit 6: Set while latched onto something (ignore holes, etc).
; Bit 1: Set based on glove's polarity.
	db

wLinkUsingItem1: ; $cc5f/$cc7a
; This is a bitset of special item objects ($d2-$d6) which are being used?
	db

wLinkTurningDisabled: ; $cc60/$cc7b
; Bit 7: set when Link presses the A button next to an object (ie. npc)
; When this is nonzero, Link's facing direction is locked (ie. using a sword).
	db

wLinkImmobilized: ; $cc61/$cc7c
; Set when link is using an item which immobilizes him. Each bit corresponds to
; a different item.
; Bit 4: Set when Link is falling down a hole
; Bit 5: Set every other frame while Link is latched by a gel
	db

wcc62: ; $cc62
	db

wcc63: ; $cc63/$cc7e
; $cc63: set when link is holding a sword out?
; When bit 7 is set, item usage is disabled; when it equals $ff, Link is forced to do
; a sword spin. Maybe used when getting the sword in Seasons?
	db

wBraceletGrabbingNothing: ; $cc64
; This is set to Link's direction (or'd with $80) when holding the bracelet and not
; grabbing anything. Used for the rollers in Seasons.
	db

wLinkPushingDirection: ; $cc65
; This is equal to w1Link.direction when he's pushing something.
; When he's not pushing something, this equals $ff.
	db

wForceLinkPushAnimation: ; $cc66/$cc81
; If $01, link always does a pushing animation; if bit 7 is set, he never does
	db

wcc67: ; $cc67
; when set, prevents Link from throwing an item.
; Used with dimitri?
	db

wLinkClimbingVine: ; $cc68/$cc83
; Set to $ff when link climbs certain ladders. Forces him to face upwards.
	db

.ifdef ROM_AGES
wLinkRaisedFloorOffset: ; $cc69
; This shifts the Y position at which link is drawn.
; Used by the raisable platforms in various dungeons.
; If nonzero, Link is allowed to walk on raised floors.
	db
.endif

wPushingAgainstTileCounter: ; $cc6a/$cc84
; Keeps track of how many frames Link has been pushing against a tile, ie. for push
; blocks, key doors, etc.
	db

wInstrumentsDisabledCounter: ; $cc6b/$cc85
; While this is nonzero, Link cannot play the harp or his flute.
; This is set during screen transitions, after closing the menu, and in a bunch of other
; places. It ticks down each frame.
	db

wPegasusSeedCounter: ; $cc6c
; Dust is created at Link's feet when bit 15 (bit 7 of the second byte) is set.
	dw

wWarpsDisabled: ; $cc6e
; Set while being grabbed by a wallmaster, grabbed by Veran spider form?
	db

wUsingShield: ; $cc6f/$cc89
; Nonzero if link is using a shield. If he is, the value is equal to [wShieldLevel].
	db


; Offset from link's position, used for collision calculations
wShieldY: ; $cc70/$cc8a
	db
wShieldX: ; $cc71
	db

wcc73: ; $cc73
	db
wcc72: ; $cc72
	db

wGrabbableObjectBuffer: ; $cc74
; $10 bytes (8 objects)
; List of pick-upable items. Used by shops, cane of somaria block.
; Each 2 bytes is a little-endian pointer to an object.
;
; When an object is grabbed:
; * state = 2
; * substate = 0
; * enabled |= 2 (allows it to persist across screens)
;
; substate is set to 2 when the object is thrown / released?
	dsb $10
wGrabbableObjectBufferEnd: ; $cc84
	.db

wcc84: ; $cc84/$cc9e
	db
wcc85: ; $cc85/$cc9f
; Relates to maple?
;
; If bit 7 is set, the lower 2 bits are a direction value. Enemies and item drops won't spawn on the
; next screen transition in that direction.
;
; If bit 7 is unset, but the value is nonzero, enemies and item drops don't spawn at all.
	db

wRoomEdgeY: ; $cc86/$cca0
	db
wRoomEdgeX: ; $cc87
	db

wSecretInputType: ; $cc88/$cca2
; $00: 20-char secret entry
; $02: 15-char secret entry
; $ff: 5-char secret entry
	db
wTextInputResult: ; $cc89/$cca3
; This is usually set to 0 on successful text input, 1 or failure.
; In the case of telling secrets to Farore, this actually returns the value of the input
; secret's "wShortSecretType".
	db

; Everything from $cc8a-$cce0 is cleared on screen transitions?

wDisabledObjects: ; $cc8a/$cca4
; Bit 0 disables link.
; Bit 1 disables interactions.
; Bit 2 disables enemies.
; Bit 4 disables items.
; Bit 5 set when being shocked? disables companions?
; Bit 7 disables link, companions, items, enemies, not interactions.
	db

wcc8b: ; $cc8b/$cca5
; Bit 0 set if items aren't being updated?
	db
wLinkCanPassNpcs: ; $cc8c/$cca6
; When nonzero, Link can pass through objects.
; Set when in a miniboss portal, using gale seeds, in a timewarp.
	db

wLinkPlayingInstrument: ; $cc8d/$cca7
; Nonzero while playing an instrument.
; Set to $ff when playing flute; otherwise, this is the value of wSelectedHarpSong.
; Copied to wLinkRidingObject?
	db

wEnteredWarpPosition: ; $cc8e/$cca8
; After certain warps and when falling down holes, this variable is set to Link's
; position. When it is set, the warp on that tile does not function.
; This prevents Link from instantly activating a warp tile when he spawns in.
; This is set to $ff when the above does not apply.
	db

wNumTorchesLit: ; $cc8f/$cca9
	db

wDisableWarpTiles: ; $cc90/$ccaa
; Disables warp tiles if nonzero?
	db

wDisableScreenTransitions: ; $cc91/$ccab
; If nonzero, screen transitions and diving don't work?
; Set when:
; - An animal companion (not dimitri) is drowning in water?
; - Ricky hops across a hole?
; - Ricky jumps up a cliff (but not down)?
; - Link jumps off a cliff where a screen transition will happen (a screen transition is
;   triggered manually)
; - Inside a cave in a waterfall (you must be on dimitri to warp out)
	db

wcc92: ; $cc92
; Bit 7 set when over a hole, first entering water, dismounting raft,
;       knockback when on raft, eaten by like-like...
; Bit 3 set when moving on a raft (allows screen transitions over water)
; Bit 2 set on conveyors?
	db

wcc93: ; $cc93/$ccad
; "Status" of door shutters?
	db

wScreenShakeMagnitude: ; $cc94/$ccae
; Affects how much the screen shakes when the "wScreenShakeCounter" variables are set.
; 0: 1-2 pixels
; 1: 1 pixel
; 2: 3 pixels
	db

wcc95: ; $cc95/$ccaf
; $cc95: Bits 0-3 unset when corresponding item is in use (w1ParentItem2/3/4)
; bit 4: Unset when in midair or swimming (in overworld, not underwater areas)?
; bit 5: Set when experiencing knockback?
; bit 7: Set when in a spinner or playing harp/flute (Link can't move or use items).
	db

wLinkRidingObject: ; $cc96/$ccb0
; When Link is riding an object, this is the index of that object (ie. raft, moving
; platforms, thwomps).
; The value of [wLinkPlayingInstrument] is also copied here each frame, though it may get
; overwritten with the index of an object Link is riding.
	db

wForceCompanionDismount: ; $cc97
; Write nonzero here to force dismount of a companion.
; (Gets ignored if the companion's "var38" variable is nonzero?)
	db

wDisallowMountingCompanion: ; $cc98/$ccb2
; $cc98: relates to switch hook
; If nonzero, can't mount animal companion?
	db

wActiveTilePos: ; $cc99/$ccb3
; The tile Link is standing on (not updated while in midair)
	db
wActiveTileIndex: ; $cc9a/$ccb4
	db

wStandingOnTileCounter: ; $cc9b/$ccb5
; This counter is used for certain tile types to help implement their behaviours.
; Ie. cracked floors use this as a counter until the floor breaks.
	db

wActiveTileType: ; $cc9c/$ccb6
; Different values for grass, stairs, water, etc
	db

wLastActiveTileType: ; $cc9d/$ccb7
; In top-down sections, this seems to remember the tile that Link stood on last frame.
; In sidescroll sections, however, this keeps track of the tile underneath Link instead.
	db

wIsTileSlippery: ; $cc9e/$ccb8
; Bit 6 is set if Link is on a slippery tile.
	db

wLinkOnChest: ; $cc9f
; Position of chest link is standing on ($00 doesn't count)
	db

wActiveTriggers: ; $cca0/$ccba
; Keeps track of which switches are set (buttons on the floor)
	db

; $cca1-$cca2: Changes behaviour of chests in shops? (For the chest game probably)
wcca1: ; $cca1/$ccbb
	db
wcca2: ; $cca2/$ccbc
; Position of a chest?
; When a nonzero value is written here, dormant armos statues with subid 0 begin moving?
	db

wChestContentsOverride: ; $cca3/$ccbd
; 2 bytes. When set, this overrides the contents of a chest.
; Used for farore's secrets, maybe also the chest minigame?
	dw

wEyePuzzleCorrectDirection: ; $cca5/$ccbe
; Correct direction to move in for the scrambled rooms in the final dungeon
	db
wBlockPushAngle: ; $cca6/$ccc0
; The angle a block is being pushed toward? bit 7 does something?
	db
wcca7: ; $cca7
	db
wcca8: ; $cca8/$ccc2
	db

.ifdef ROM_SEASONS ; TODO: related to springbloom flower state
wUnknown: ; -/$ccc3
	db
.endif

wTwinrovaTileReplacementMode: ; $cca9/$ccc4
; 0: Do nothing
; 1: Fill room with lava
; 2: Fill room with ice
; 3: ?
; 4+: Use "seizure tiles" (when controls are reversed in ganon fight)
	db
wccaa: ; $ccaa/$ccc5
	db


.ifdef ROM_AGES

wLever1PullDistance: ; $ccab
; Number of pixels out a lever has been pulled. Bit 7 set when fully pulled.
	db
wLever2PullDistance: ; $ccac
; Same as above but for a 2nd lever.
	db

wRotatingCubeColor: ; $ccad
; Color of the rotating cube (0: red, 1: yellow, 2: blue)
; Bit 7 gets set when the torches are lit
	db
wRotatingCubePos: ; $ccae
	db

.endif


wccaf: ; $ccaf/$ccc6
; Tile index being poked or slashed at?
	db
wccb0: ; $ccb0/$ccc7
; Tile position being poked or slashed at?
	db

wccb1: ; $ccb1
; Disables PARTID_BUTTON when nonzero?
	db

.ifdef ROM_AGES
wDisableWarps: ; $ccb2
; Used by INTERACID_BLACK_TOWER_DOOR_HANDLER to stop the warp from sending you anywhere.
	db
.endif

.ifdef ROM_SEASONS
wInBoxingMatch: ; -/$ccc9
	db
.endif

wAButtonSensitiveObjectList: ; $ccb3/$ccca
; List of objects which react to A button presses. Each entry is a pointer to
; their corresponding "Object.pressedAButton" variable.
	dsb $20
wAButtonSensitiveObjectListEnd: ; $ccd3
	.db

wInShop: ; $ccd3/$ccea
; When this is nonzero, it prevents Link from using items.
; Bit 1: Set while in a shop.
; Bit 2: Requests the tilemap for the items on display to be updated.
; Bit 7: Set while playing the chest game.
	db


.union
	wLinkPushingAgainstBedCounter: ; $ccd4
	; Counter for how many frames you've pushed against the bed in Nayru's house. Once
	; it reaches 90, Link jumps in.
		db
.nextu
	wShootingGalleryHitTargets: ; $ccd4
	; In the shooting gallery, bits 0-3 are set depending on what the first target hit
	; was? Bits 4-7 are also set in the same way for the second target?
		db
.nextu
	wccd4: ; $ccd4
	; Used in cutscene where maku sprout is attacked by moblins?
		db
.endu

wShootingGalleryccd5: ; $ccd5
; Shooting gallery: ?
; (Also used by target carts with INTERACID_TROY?)
	.db
wShopHaveEnoughRupees: ; $ccd5/$ccec
; Shop: Set to 0 if you have enough money for an item, 1 otherwise
; Also used by target carts?
	db

wShootingGalleryBallStatus: ; $ccd6
; Shooting gallery: bit 7 set when the ball goes out-of-bounds
	db


wInformativeTextsShown: ; $ccd7
; Keeps track of whether certain informative texts have been shown.
; ie. "This block has cracks in it" when pushing against a cracked block.
; This is also used to prevent Link from jumping into the bed in Nayru's house more than
; once.
;   Bit 0:
;   Bit 1: Boss key door (and bed in impa's house)
;   Bit 2: Keyblock
;   Bit 3: Pot
;   Bit 4: Cracked block
;   Bit 5: Cracked wall, unlit torch
;   Bit 6: Roller from Seasons
	db

wccd8: ; $ccd8/$ccef
; If nonzero, link can't use his sword. Relates to dimitri?
; Bit 5 set while latched by a gel or ages d1 miniboss
	db

wScentSeedActive: ; $ccd9/$ccf0
; Nonzero while scent seed is active?
	db

wIsSeedShooterInUse: ; $ccda/$ccf1
; Set when there is a seed shooter (or slingshot) seed on-screen
	db

wIsLinkBeingShocked: ; $ccdb/$ccf2
	db
wLinkShockCounter: ; $ccdc
	db

.ifdef ROM_AGES
wSwitchHookState: ; $ccdd
; Used when swapping with the switch hook
	db
.endif

wDiggingUpEnemiesForbidden: ; $ccde/$ccf4
	db

; Indices for w2ChangedTileQueue
wChangedTileQueueHead: ; $ccdf
	db
wChangedTileQueueTail: ; $cce0
	db

wcce1: ; $cce1/$ccf7
; This is used as a marker; all memory from "wDisabledObjects" to here is cleared in one
; spot (not including wcce1).
	db
wcce2: ; $cce2/$ccf8
	db
wcce3: ; $cce3/$ccf9
	db

; Indices for w2AnimationQueue
wAnimationQueueHead: ; $cce4
	db
wAnimationQueueTail: ; $cce5
	db

wLinkPathIndex: ; $cce6
; Used for the "FollowingLinkObject" to remember the position in the "w2LinkWalkPath"
; buffer.
	db

wFollowingLinkObjectType: ; $cce7/$ccfd
	db
wFollowingLinkObject: ; $cce8/$ccfe
	db

wcce9: ; $cce9/$ccff
; This might be a marker for the end of data in the $cc00 block?
	.db

.ENDS


; These $30 bytes at $cd00 are treated as a unit in a certain place
.define wScreenVariables.size $30


.RAMSECTION Wram0_cd00

wScreenVariables: ; $cd00
	.db

wScrollMode: ; $cd00
; Equals 1 under most normal circumstances
; Equals 8 while doing a normal screen transition
; When set to 0, scrolling stops in big areas.
; Bit 0 disables animations when unset, among other things apparently.
; When bit 1 is set link can't move.
; Bit 1 is set while a non-scrolling transition is taking place?
; Bit 2 is set while the screen is scrolling.
	db

wcd01: ; $cd01
; $cd01: 0 for large rooms, 1 for small rooms?
	db

wScreenTransitionDirection: ; $cd02
; See constants/directions.s for what the directions are.
; Set bit 7 to force a transition to occur.
	db

wcd03: ; $cd03
	db

wScreenTransitionState: ; $cd04
	db
wScreenTransitionState2: ; $cd05
	db
wScreenTransitionState3: ; $cd06
	db

wcd07: ; $cd07
	db

; These are used when the screen scrolls and the room is no longer drawn starting at
; position (0,0).
; They're probably also used when the screen shakes back and forth.
wScreenOffsetY: ; $cd08
	db
wScreenOffsetX: ; $cd09
	db


; Room dimensions measured in 8x8 tiles
wRoomWidth: ; $cd0a
	db
wRoomHeight: ; $cd0b
	db


; These determine where Link needs to walk to to start a screen transition.
; Similar to wRoomEdgeY/X, but used for different things.
wScreenTransitionBoundaryX: ; $cd0c
; Rightmost boundary
	db
wScreenTransitionBoundaryY: ; $cd0d
; Bottom-most boundary
	db


; Max values for hCameraY/X
wMaxCameraY: ; $cd0e
	db
wMaxCameraX: ; $cd0f
	db

wUniqueGfxHeaderAddress: ; $cd10
; 2 bytes; keeps track of which "entry"
; Shared memory with the variables below;
	.dw

wScreenScrollRow: ; $cd10
; Keeps track of the row (or column) of tiles being drawn while scrolling the screen.
; A value of "0" is the top or left of the room.
	db
wScreenScrollVramRow: ; $cd11
; The corresponding row (or column) to draw to in vram.
	db

wScreenScrollDirection: ; $cd12
; This is either $01 or $ff, corresponding to right/down or left/up.
	db

wScreenScrollCounter: ; $cd13
; Decremented once per row (or column). The transition finishes when this reaches 0.
; (This is used in a few other contexts, but the above is most significant.)
	db

wcd14: ; $cd14
; Value to add to SCY/SCX every frame?
	db

wScreenTransitionDelay: ; $cd15
; When nonzero, this forces Link to walk against the screen edge for this many frames
; before the screen transition starts.
; Jumping sets this to $04.
	db

wCameraFocusedObjectType: ; $cd16
	db
wCameraFocusedObject: ; $cd17
	db

wScreenShakeCounterY: ; $cd18
	db
wScreenShakeCounterX: ; $cd19
	db

wcd1a:
	; $cd1a-$cd1e unused?
	dsb 5

wObjectTileIndex: ; $cd1f
; This is set when calling "objectCheckIsOverHazard". Might be ages-exclusive?
	db

wTilesetUniqueGfx: ; $cd20
	db
wTilesetGfx: ; $cd21
	db
wTilesetPalette: ; $cd22
	db
wTilesetLayout: ; $cd23
	db
wTilesetLayoutGroup: ; $cd24
	db
wTilesetAnimation: ; $cd25
; Note: intro cutscene hardcoded to use animation $10
	db

wcd26: ; $cd26
	db
wcd27: ; $cd27
	db

wLoadedTilesetUniqueGfx: ; $cd28
	db
wLoadedTilesetPalette: ; $cd29
	db
wLoadedTilesetLayout: ; $cd2a
	db
wLoadedTilesetAnimation: ; $cd2b
	db
wLastToggleBlocksState: ; $cd2c
; Corresponds to wToggleBlocksState. This is used to detect changes to it.
	db
wDeleteEnergyBeads: ; $cd2d
; When nonzero, energy beads (part ID $53) delete themselves? Used when getting essence.
	db

; $cd2e-$cd2f unused?

.ENDS


.RAMSECTION Wram0_cd30

wAnimationState: ; $cd30
; Bits 0-3 determine whether to use animation data 1-4
; When bit 7 is set, all animations are forced to be updated regardless of
; counters.
; Bit 6 also does something
	db

wAnimationCounter1: ; $cd31
	db
wAnimationPointer1: ; $cd32
	dw
wAnimationCounter2: ; $cd34
	db
wAnimationPointer2: ; $cd35
	dw
wAnimationCounter3: ; $cd37
	db
wAnimationPointer3: ; $cd38
	dw
wAnimationCounter4: ; $cd3a
	db
wAnimationPointer4: ; $cd3b
	dw

; $cd3d-$cd3f unused?

.ENDS


.RAMSECTION Wram0_cd40

wTmpVramBuffer: ; $cd40
; Used temporarily for vram transfers, dma, etc.
	dsb $40


; Size of this differs between games.
.ifdef ROM_AGES
wStaticObjects: ; $cd80
	dsb $40
.else
wStaticObjects: ; $cd80
	dsb $80
.endif

.ENDS


; This section is at a different location depending on the game.
; Ages: Starts at $cdc0. Appended to "Wram0_cd40" section just above
; Seasons: Starts at $cc1f. Appended to "Wram0_cc00" section from a bit earlier.

.RAMSECTION Wram0_FloatingSection2

wEnemiesKilledList: ; $cdc0/$cc1f
; This remembers the enemies that have been killed in the last 8 visited rooms.
; 8 groups of 2 bytes:
;   b0: room index
;   b1: bitset of enemies killed (copied to wKilledEnemiesBitset when screen is loaded)
	dsb $10

wEnemiesKilledListTail: ; $cdd0/$cc2f
; This is the first available unused position in wEnemiesKilledList.
	db

wNumEnemies: ; $cdd1/$cc30
; Number of enemies on the screen. When this reaches 0, certain events trigger. Not all
; enemies count for this.
	db

wToggleBlocksState: ; $cdd2/$cc31
; State of the blocks that are toggled by the orbs.
; Persists between rooms within a dungeon.
	db

wSwitchState: ; $cdd3/$cc32
; Each bit keeps track of whether a certain switch has been hit.
; Persists between rooms within a dungeon.
	db

wSpinnerState: ; $cdd4/$cc33
; Used by INTERACID_SPINNER.
; Each bit holds the state of one spinner (0 for blue, 1 for red).
; Persists between rooms within a dungeon.
	db

wLinkDeathTrigger: ; $cdd5/$cc34
; Write anything here to make link die
	db
wGameOverScreenTrigger: ; $cdd6/$cc35
; Write anything here to open the Game Over screen
	db

wcdd7: ; $cdd7/$cc36
	db
wDimitriHitNpc: ; $cdd8/$cc37
; Nonzero if Dimitri hits an npc while being thrown.
	db
wcdd9: ; $cdd9
	db

.ifdef ROM_SEASONS
ws_cc39:
; Maku tree stage (largely depends on # of essences)
	db
.endif

wIsMaplePresent: ; $cdda/$cc3a
; Nonzero while maple is on the screen.
	db


.ifdef ROM_AGES

wcddb: ; $cddb
; Scratch variable for scripts?
	db

wLinkTimeWarpTile: ; $cddc
; This is set to Link's position (plus 1 so 0 is a special value) when he goes through time.
; When set, breakable tiles like bushes will be deleted so that Link doesn't get caught in
; an infinite time loop.
; When set, there will NOT be a time portal created where Link warps in. So, this is set
; in the following situations:
; - Tune of Echoes warp is entered
; - A temporary warp created by the Tune of Current/Ages is entered
; - Link is forced back when he attempts to warp into a wall or something
; It is NOT set when he plays the Tune of Currents/Ages.
	db

wcddd: ; $cddd
	db

wSentBackByStrangeForce: ; $cdde
; When set to $01, Link gets "sent back by a strange force" during a time warp.
	db

wcddf: ; $cddf
; Position value, similar to wLinkTimeWarpTile?
	db

wcde0: ; $cde0
; Nonzero while a timewarp is active?
	db

wPirateShipChangedTile: ; $cde1
; The pirate ship's YX value is written here when it changes tiles (when its X and
; Y position values are each centered on a tile).
	db

wMamamuDogLocation:
; Number from 0-3 for one of 4 possible screens.
	db

wcde3: ; $cde3
; Ages' version of Seasons' wcc1f. In both games, this is used solely as temporary
; storage for Link's equipped items during the credits cutscene (state 0). The items
; are given back to Link during credits cutscene state 3
	dw

; $cde5-$cdff unused?

.endif ; ROM_AGES
.ENDS


.RAMSECTION Wram0_ce00

wRoomCollisions: ; $ce00
; $10 bytes larger than it needs to be?
	dsb $c0
wRoomCollisionsEnd: ; $cec0
	.db

wTmpcec0: ; $cec0
	.db


; Data at $cec0-$ceff has several different uses depending on context.
; Aside from the uses listed below, it's also used for:
; * Functions which apply an object's speed ($cec0-$cec3)
; * Checking enough torches are lit to open a door ($cec0 only)
; * Unpacking secrets
wEnemyPlacement: instanceof EnemyPlacementStruct

.ENDS


.RAMSECTION Wram0_cee0

.union
	wShootingGalleryTileLayoutsToShow: ; $cee0
	; This consists of the numbers 0-9. As the game progresses, a number is read from
	; a random position in this buffer, then the buffer is decreased in size by one
	; and the value that was just read is overwritten. In this way, each game in the
	; shooting gallery will show each target layout exactly once.
	;
	; The goron dance also uses this in exactly the same way.
		dsb 10

.nextu

	wWizzrobePositionReservations: ; $cee0
	; Each 2 bytes are the position and object index of a wizzrobe. Keeps track of
	; their positions so multiple red wizzrobes don't spawn on top of each other.
	; A red could still spawn on top of a green, though.
		dsb $10
.endu

.ENDS



.RAMSECTION Wram0_cf00

wRoomLayout: ; $cf00
; $10 bytes larger than it needs to be; the row below the last row is reserved and filled
; with the value $00. (Same deal with the last column.) Some functions depend on this for
; out-of-bounds checking.
	dsb $c0
wRoomLayoutEnd: ; $cfc0
	.db

; $cfc0-$cfff are generally used as variables for scripts, with many uses.
; Aside from the enums below, here are some of their uses:
;
; $cfc0:
;  * Bit 0 is set whenever a keyhole in the overworld is opened. This triggers the
;    corresponding cutscene (which appears to be dependent on the room you're in).
;  * Set to nonzero by PARTID_SEED_ON_TREE to indicate that it's shown the "you can't
;    pick up these seeds" text
; $cfc1:
;  * Used by door controllers
; $cfd3:
;  * Used by the villagers' ball; alternates between 1 and 2 depending who's holding it
; $cfd5-$cfd6:
;  * Position value used for some cutscenes?
; $cfc8-$cfdf:
;  * A buffer used in events triggered by stuff falling down holes
; $cfdf:
;  * Cutscenes sometimes write $ff here to signal end? (Grandma object does anyway)
;
; Intro (animals listening to Nayru):
; * $cfd0: Cutscene state?
; * $cfde: Keeps track of which animals have been talked to on the nayru screen
;
; Wild tokay game:
;  * $cfc0: Set to 1 to delete the tokay "statues" in the present?
;  * $cfda/b: A pointer to an object?
;  * $cfdd: 5 if the prize will be a ring, 4 otherwise?
;  * $cfde: Set to $01 on success, $ff on failure
;  * $cfdf: Number of tokays remaining to be spawned
;
; Forest minigame:
;  * $cfd0: ?
;  * $cfd1: Bitset of discovered fairies?
;  * $cfd2: ?
;
; Goron who checks for the brother's emblem:
;  * $cfc0: Set to $01 if you've rejected his trade offer.

.union wTmpcfc0

; Uses of $cfc0 in "normal" gameplay
.union normal
	cfc0: ; $cfc0
		;  Bit 0 is set whenever a keyhole in the overworld is opened. This triggers the
		;  corresponding cutscene (which appears to be dependent on the room you're in).
		;  (TODO: replace "wTmpcfc0.genericCutscene.cfc0" with "wTmpcfc0.normal.cfc0" where
		;  appropriate)
		db
	doorControllerState: ; $cfc1
		db


; Uses of $cfc0 in shooting gallery
.nextu shootingGallery

	gameStatus: ; $cfc0
	; Set to 0 while game is running, 1 when it's finished
		db
	cfc1: ; $cfc1
		dsb $15
	isStrike: ; $cfd6
	; Set if the current shot was a strike
		db
	savedBItem: ; $cfd7
	; Saves Link's B button item
		db
	savedAItem: ; $cfd8
	; Saves Link's A button item
		db
	cfd9: ; $cfd9
		db
	cfda: ; $cfda
		db
	cfdb: ; $cfdb
		db
	disableGoronNpcs: ; $cfdc
	; Affects the goron npc? Set when doing the biggoron's sword version of the game?
		db
	useTileIndexData: ; $cfdd
	; Used as a parameter for a function.
		db
	remainingRounds: ; $cfde
	; The number of rounds remaining in the game.
		db
	targetLayoutIndex: ; $cfdf
	; The index of the layout to use for the targets (value from 0-9)
		db

.nextu goronDance

	filler1:
		dsb $11
	failureType: ; $cfd1
	; $00: Too early
	; $01: Too late
	; $02: Wrong move
		db
	danceAnimation:
	; Animation that all dancing gorons/subrosians should use.
		db
	linkJumping:
		db
	linkStartedDance:
	; Nonzero if Link has entered his first input this round
		db
	frameCounter:
	; Increments each frame, only whin "linkStartedDance" is nonzero.
		dw
	currentMove: ; $cfd7
	; $ff to stop?
		db
	consecutiveBPressCounter: ; $cfd8
		db
	cfd9: ; $cfd9
	; Set when failed a round?
		db
	roundIndex: ; $cfda
	; Value from $00-$08 ($08 means we're done)
		db
	numFailedRounds: ; $cfdb
		db
	beat: ; $cfdc
	; Current "beat" we're on ($00-$0f) in the current dancePattern
		db
	danceLevel: ; $cfdd
	; 0: platinum
	; 1: gold
	; 2: silver
	; 3: bronze
		db
	remainingRounds: ; $cfde
	; Same address as wTmpcfc0.shootingGallery.remainingRounds
		db
	dancePattern: ; $cfdf
	; Dance pattern (for this particular danceLevel). This is an index for a dance
	; pattern.
		db
	dataEnd:
		.db

.nextu targetCarts

	filler1: ; $cfc0
		dsb $14
	targetConfiguration: ; $cfd4
		db
	beganGameWithTroy:
	; Used by INTERACID_TROY (minigame for bombchus).
		db
	prizeIndex: ; $cfd6
		db
	savedBItem: ; $cfd7
		db
	savedAItem: ; $cfd8
		db
	savedNumScentSeeds: ; $cfd9
		db
	savedShooterSelectedSeeds: ; $cfda
		db
	beginGameTrigger: ; $cfdb
	; Write nonzero here to begin the game
		db
	cfdc: ; $cfdc
		db
	crystalsHitInFirstRoom: ; $cfdd
	; Bitset of crystals in the first room that were hit (so it's consistent when you
	; re-enter the room).
		db
	numTargetsHit: ; $cfde
		db
	cfdf:
	; Nonzero if entered the second room?
		db

.nextu bigBangGame

	gameStatus:
	; Set to 0 while game is running, 1 when it's finished
		db
	filler1:
		dsb $15
	prizeIndex: ; $cfd6
		db
	filler2:
		dsb $6

.nextu goronCutscenes

	; Stuff here relates to various goron cutscenes, and technically most of these
	; could be in separate unions of their own.

	goronGuardMovedAside:
	; Nonzero if the goron who checks for the brother's emblem has just moved aside?
		db
	filler1:
		dsb $1c
	elderVar_cfdd: ; $cfdd
		db
	cfde:
		db
	elder_stopFallingRockSpawner: ; $cfdf
		db

	dataEnd:
		.db

.nextu fairyHideAndSeek

	cfc0:
		dsb $10
	active: ; $cfd0
		db
	foundFairiesBitset: ; $cfd1
	; Bits 0-2 set if the corresponding fairies have been found.
		db
	cfd2:
		db

.nextu wildTokay

	inPresent: ; $cfc0
		db
	filler1:
		dsb $19
	activeMeatObject: ; $cfda
		dw
	cfdc: ; $cfdc
		db
	cfdd: ; $cfdd
		db
	cfde: ; $cfde
	; $00: still playing
	; $01: won game
	; $ff: failed game
		db
	cfdf: ; $cfdf
		db

.nextu genericCutscene

	state: ; $cfc0
		db
	cfc1: ; $cfc1
		dsb 5
	cfc6: ; $cfc6
		db
	filler1:
		dsb $09
	cfd0: ; $cfd0
	; Acts as a synchronization thing, ie. between objects?
		db
	cfd1: ; $cfd1
		db
	cfd2: ; $cfd2
		db
	cfd3: ; $cfd3
	; Link's position is stored here by INTERACID_HARDHAT_WORKER
		db
	cfd4: ; $cfd4
	; Link's direction is stored here by INTERACID_HARDHAT_WORKER
		db
	cfd5: ; $cfd5
	; Used as a position value? Maybe a focus position for npcs in certain cutscenes?
	; (see "objectWritePositionTocfd5")
		dw
	filler3:
		dsb 7
	cfde: ; $cfde
		db
	cfdf: ; $cfdf
		db

.nextu introCutscene

	state: ; $cfc0
		db
	filler1:
		dsb $10
	cfd1: ; $cfd1
		db

.nextu bombUpgradeCutscene

	state: ; $cfc0
		db

.nextu octogonBoss ; Persistent variables for octogon boss

	filler: ; $cfc0
		dsb $10
	loadedExtraGfx:  ; $cfd0
		db
	var03: ; $cfd1
		db
	direction: ; $cfd2
		db
	health: ; $cfd3
		db
	y: ; $cfd4
		db
	x: ; $cfd5
		db
	var30: ; $cfd6
		db
	posNeedsFixing: ; $cfd7
		db

.nextu patchMinigame

	filler: ; $cfc0
		dsb $10
	fixingSword: ; $cfd0
	; 0: Restoring tuni nut
	; 1: Restoring broken sword
		db
	swordLevel: ; $cfd1
	; Sword level to give (0 for L3, 1 for L2)
		db
	patchDownstairs: ; $cfd2
	; if $01, patch is in the downstairs room; $00, he's upstairs
		db
	wonMinigame: ; $cfd3
		db
	gameStarted: ; $cfd4
		db
	failedGame: ; $cfd5
		db
	screenFadedOut: ; $cfd6
	; This is set to $01 when the screen goes fully white after the game ends.
		db
	itemNameText: ; $cfd7
		db

	; for $cfd8-$cfd9, see "fallDownHoleEvent" below. (also used by toilet hand)

.nextu fallDownHoleEvent

	filler: ; $cfc0
		dsb $18
	cfd8: ; $cfd8
		dsb 8

.nextu carpenterSearch

	filler: ; $cfc0
		dsb $10

	; $10 bytes reserved
	cfd0:
	; State; 0 if haven't agreed to search;
	;        1 if agreed;
	;        further values are used to control the cutscene where the bridge is
	;        built.
		db
	carpentersFound:
	; Bits 2-4 set when the corresponding carpenters are found?
		dw

.nextu armosStatue
	filler: ; $cfc0
		dsb $10

	; The initial positions of all killed armos with subid 1 are recorded here. (Maybe
	; this is used in Seasons for the puzzle where you kill armos in order?)
	killedArmosPositions:
		dsb $10

.endu
.endu

.ENDS


; ========================================================================================
; Bank 1: objects
; Each object occupies $40 bytes in this bank. 4 main types:
; ITEMs		($dx00-$dx3f)
; INTERACtions	($dx40-$dx7f)
; ENEMYs	($dx80-$dxbf)
; PARTs		($dxc0-$dxff)
;
; There can also be special objects in the ITEM slots from $d000-$d53f,
; including link and his companions.
; ========================================================================================

.ENUM $d000 export
	w1Link:			instanceof SpecialObjectStruct

	; This is used for:
	; * Items from treasure chests
	; * Key door openers
	w1ReservedInteraction0:	instanceof InteractionStruct
.ENDE

.ENUM $d100 export
	w1Companion:		instanceof SpecialObjectStruct

	; This is used for:
	; * Blocks being pushed
	; * Glow behind essences
	; * Pirate ship (ages)
	w1ReservedInteraction1:	instanceof InteractionStruct
.ENDE

.ENUM $d200 export
	; Used for stuff Link holds?
	w1ParentItem2:		instanceof ItemStruct
.ENDE
.ENUM $d300 export
	; Used for projectiles like w1ParentItem4?
	w1ParentItem3:		instanceof ItemStruct
.ENDE
.ENUM $d400 export
	; Used for projectiles like w1ParentItem3?
	w1ParentItem4:		instanceof ItemStruct
.ENDE
.ENUM $d500 export
	; Used for flute, harp, shield?
	w1ParentItem5:		instanceof ItemStruct
.ENDE
.ENUM $d600 export
	w1WeaponItem:		instanceof ItemStruct
.ENDE

.ENUM $dc00 export
	; The item that Link is holding / throwing. Even if Link is holding some other
	; object like an enemy or Dimitri, this object still exists as ITEMID_BRACELET,
	; or at least it does while the object is being thrown. This invisible object will
	; copy its position to the actual object being thrown each frame, and update that
	; object's state accordingly (ie. ENEMYSTATE_GRABBED).
	w1ReservedItemC:	instanceof ItemStruct
.ENDE

.ENUM $dd00 export
	w1MagnetBall:       instanceof ItemStruct
.ENDE

.ENUM $de00 export
	; Doesn't have collisions? (comes after LAST_STANDARD_ITEM_INDEX)
	; Used to store positions for switch hook (ITEMID_SWITCH_HOOK_HELPER).
	w1ReservedItemE:	instanceof ItemStruct
.ENDE

.ENUM $df00 export
	; Used for puffs at Link's feet while using pegasus seeds
	w1ReservedItemF:	instanceof ItemStruct
.ENDE

; Some definitions for managing object indices in this bank

.define FIRST_ITEM_INDEX		$d6 ; First object that's actually an item
.define LAST_STANDARD_ITEM_INDEX	$dd ; Collisions don't check items $de and $df?

.define FIRST_DYNAMIC_ITEM_INDEX	$d7 ; First object slot for items that's dynamically allocated
.define LAST_DYNAMIC_ITEM_INDEX		$db

.define LAST_ITEM_INDEX			$df

; Index for weapon item being used (sword, cane, switch hook, etc)
.define WEAPON_ITEM_INDEX		$d6

; These are not dynamically allocated, presumably they have set purposes
.define ITEM_INDEX_dc		$dc
.define ITEM_INDEX_dd		$dd
.define ITEM_INDEX_de		$de
.define ITEM_INDEX_df		$df

; "Special" objects (occupy memory at $dx00-$dx3f), 0 <= x <= 5
.define LINK_OBJECT_INDEX	$d0
.define COMPANION_OBJECT_INDEX	$d1

.define FIRST_INTERACTION_INDEX		$d0
.define FIRST_DYNAMIC_INTERACTION_INDEX	$d2
.define LAST_INTERACTION_INDEX		$df

.define FIRST_ENEMY_INDEX		$d0
.define LAST_ENEMY_INDEX		$df

.define FIRST_PART_INDEX		$d0
.define LAST_PART_INDEX			$df

; Reserved interaction slots
.define PIRATE_SHIP_INTERACTION_INDEX	$d1

; ========================================================================================
; Bank 2: used for palettes & other things
; ========================================================================================

.RAMSECTION RAM_2 BANK 2 SLOT 3

; $d000 used as part of the routine for redrawing the collapsed d2 cave in the present
w2TmpGfxBuffer:			dsb $0800

; This is a list of values for scrollX or scrollY registers to make the screen turn all
; wavy (ie. in underwater areas).
w2WaveScrollValues:		dsb $80	; $d800/$d800

w2Filler7:			dsb $80

.ifdef ROM_SEASONS

w2Filler9:			dsb $80

.else; ROM_AGES

; Tree refill data also used for child and an event in room $2f7.
; Located elsewhere in seasons.
wxSeedTreeRefillData:		dsb NUM_SEED_TREES*8 ; 2:d900/3:dfc0

.endif

; Bitset of positions where objects (mostly npcs) are residing. When one of these bits is
; set, this will prevent Link from time-warping onto the corresponding tile.
w2SolidObjectPositions:			dsb $010 ; $d980

w2Filler6:			dsb $70

; Used as the "source" palette when fading between two sets of palettes
w2ColorComponentBuffer1:	dsb $090 ; $da00

; Keeps a history of Link's path when objects (Impa) are following Link.
; Consists of 16 entries of 3 bytes each: direction, Y position, X position.
w2LinkWalkPath:			dsb $030 ; $da90

w2ChangedTileQueue:		dsb $040 ; $dac0

; Used as the "destination" palette when fading between two sets of palettes
w2ColorComponentBuffer2:	dsb $090 ; $db00

w2AnimationQueue:		dsb $20	; $db90

w2Filler4:			dsb $50

; Each $40 bytes is one floor
w2DungeonLayout:	dsb $100	; $dc00

w2Filler2: dsb $100

w2GbaModePaletteData:	dsb $80		; $de00

; The "base" palettes on a screen.
w2TilesetBgPalettes:	dsb $40		; $de80
w2TilesetSprPalettes:	dsb $40		; $dec0

; The palettes that are copied over during vblank
w2BgPalettesBuffer:	dsb $40		; $df00
w2SprPalettesBuffer:	dsb $40		; $df40

; The "base" palettes have "fading" operations applied, and the result is written here.
w2FadingBgPalettes:	dsb $40		; $df80
w2FadingSprPalettes:	dsb $40		; $dfc0

.ENDS

; ========================================================================================
; Bank 3: tileset data
; ========================================================================================

.RAMSECTION RAM_3 BANK 3 SLOT 3

; 8 bytes per tile: 4 for tile indices, 4 for tile attributes
w3TileMappingData:	dsb $800	; $d000

; Room tiles in a format which can be written straight to vram. Each row is $20 bytes.
; TODO: Contrast with w4TileMap
w3VramTiles:		dsb $300	; $d800

; Each byte is the collision mode for that tile.
; The lower 4 bits seem to indicate which quarters are solid.
w3TileCollisions:	dsb $100	; $db00

; Analagous to w3VramTiles. Contains the attributes to write to vram. $100 bytes.
w3VramAttributes:	.db		; $dc00

; Indices for tileMappingTable. 2 bytes per tile, $200 bytes total.
; Shares memory with "w3VramAttributes" above. This is only used temporarily when loading
; tilesets.
w3TileMappingIndices:	dsb $200	; $dc00


; Most likely unused
w3Filler2:		dsb $100

w3RoomLayoutBuffer:	dsb $c0	; $df00

.ifdef ROM_SEASONS
; Located elsewhere in ages
wxSeedTreeRefillData:		dsb NUM_SEED_TREES*8 ; 2:d900/3:dfc0
.endif

.ENDS

; ========================================================================================
; Bank 4
; ========================================================================================

.define SERIAL_WRAM_BANK 4

.RAMSECTION Ram_4 BANK 4 SLOT 3

.union
	w4RandomBuffer:		dsb $100	; $d000-$d0ff
.nextu
	w4TileMap:		dsb $240	; $d000-$d23f
.endu

w4StatusBarTileMap:		dsb $40		; $d240
w4PaletteData:			dsb $40		; $d280
w4Filler3:			dsb $40
w4SavedOam:			dsb $a0		; $d300
w4TmpRingBuffer			dsb NUM_RINGS	; $d3a0
w4SubscreenTextIndices:		dsb $20		; $d3e0: stores subscreen text indices
w4AttributeMap:			dsb $240	; $d400-$d640
w4StatusBarAttributeMap:	dsb $40		; $d640

; Icon graphics for the two equipped items
w4ItemIconGfx:			dsb $80		; $d680

w4Filler5:			dsb $80

; File info for file select screen, either from this cartridge or copied over from another one
w4FileDisplayVariables:		INSTANCEOF FileDisplayStruct 3	; $d780

w4Filler7:			dsb 8

; Used as a buffer for up to 3 names? (3 * 6 bytes)
w4NameBuffer:			dsb $20		; $d7a0

w4SecretBuffer:			dsb $20		; $d7c0
w4Filler8:			dsb $20

w4SavedVramTiles:		dsb $180	; $d800

w4d980:				db		; $d980

; Index of next byte to send in the packet being sent
w4PacketByteIndex:		db		; $d981

w4PacketChecksum:		db		; $d982

w4d983:				db		; $d983

w4d984:				db		; $d984

w4DisableLinkTimeout:		db		; $d985

; When this reaches 5, the game gives up trying to communicate.
w4LinkRetryCounter:		db		; $d986

; Number of bytes left to be sent/received in the packet
w4NumPacketBytes:		db		; $d987

; Can be $00 (not sending), $01 (sending), or $80?
w4WaitingForNextByte:		db		; $d988
w4FileLinkTimer:		dw		; $d989
w4d98b:				db		; $d98b
w4d98c:				db		; $d98c

; TODO: Rename this? It seems to be a temporary buffer. Sometimes it consists of the first $16 bytes
; of a file ($c600-$c615) copied across the link cable.
w4RingFortuneStuff:		dsb $16*3	; $d98d

w4Filler1:			dsb $16		; $d9cf

; First byte should be the length of the packet (including itself).
w4PacketBuffer:			dsb $21b	; $d9e5

w4GfxBuf1:			dsb $200	; $dc00
w4GfxBuf2:			dsb $200	; $de00

.ENDS

; ========================================================================================
; Bank 5
; ========================================================================================

.RAMSECTION Ram_5 BANK 5 SLOT 3

w5NameEntryCharacterGfx:	dsb $800 ; $d000

.ENDS

; ========================================================================================
; Bank 6
; ========================================================================================

.RAMSECTION Ram_6 BANK 6 SLOT 3

w6Filler1:                      dsb $3c0

w6d3c0:                         dsb $40  ; $d3c0

w6Filler2:                      dsb $200

w6SpecialObjectGfxBuffer:       dsb $100 ; $d600

w6Filler3:                      dsb $c0

w6d7c0:                         dsb $40 ; $d7c0

w6Filler4:                      dsb $400

w6TileBuffer:                   dsb $200 ; $dc00
w6AttributeBuffer:              dsb $200 ; $de00

.ENDS

; ========================================================================================
; Bank 7: used for text
; ========================================================================================

.define TEXT_BANK $07

.RAMSECTION RAM_7 BANK 7 SLOT 3

w7TextboxMap: ; $d000
; Mapping for textbox. Goes with w7TextboxAttributes.
; Each row is $20 bytes, and there are 5 rows. So this should take $a0 bytes, but it seems to have
; room for an extra row.
	dsb $c0

w7TextDisplayState: ; $d0c0
	db

w7d0c1: ; $d0c1
; When bit 0 is set, text skips to the end of a line (A or B was pressed)
; When bit 2 is set, an "\opt()" command has been encountered.
; When bit 3 is set, an option prompt has already been shown?
; When bit 4 is set, an extra text index will be shown when this text is done.
; See _getExtraTextIndex.
; When bit 5 is set, it shows the heart icon like when you get a piece of heart.
	db

w7TextStatus: ; $d0c2
; This is $00 when the text is done, $01 when a newline is encountered, and $ff for anything else?
	db

w7SoundEffect: ; $d0c3
; A sound effect that's played once
	db

w7TextSound: ; $d0c4
; The sound that each character makes as it's displayed
	db

w7CharacterDisplayLength: ; $d0c6
; How many frames each character is displayed for before the next appears
	db

w7CharacterDisplayTimer: ; $d0c6
; The timer until the next character will be displayed
	db

w7TextAttribute: ; $d0c7
; The attribute byte for subsequent characters. This is the byte that is written into vram bank 1,
; which determines which palette to use and stuff like that.
	db

w7TextArrowState: ; $d0c8
; Whether or not the little red arrow in the bottom-right is being displayed.
; This can be eiher $02 (not displayed) or $03 (displayed).
; This changes every 16 frames.
	db

w7TextboxPosBank: ; $d0c9
; w7TextboxPosBank/w7TextboxPos specify where the tilemap for the textbox is located. It points to
; the start of the row where it should be displayed.
	db
w7TextboxPos: ; $d0ca
	dw

w7d0cc: ; $d0cc
; Low byte of where to save the tiles under the textbox?
	db

w7d0cd: ; $d0cd
	db

w7d0ce: ; $d0ce
	db

w7d0cf: ; $d0cf
	db

w7NextTextColumnToDisplay: ; $d0d0
; The next column of text to be shown
	db

w7d0d1: ; $d0d1
	db

w7TextGfxSource: ; $d0d2
; This variable is used by the retrieveTextCharacter function.
; 0: read a normal character
; 1: read a kanji
; 2: read a trade item symbol
	db

w7d0d3: ; $d0d3
; Textbox position?
	db

w7ActiveBank: ; $d0d4
	db
w7TextAddress: ; $d0d5
; Address of text being read
	dw

w7TextSlowdownTimer: ; $d0d7
; d0d7: counter for how long to slow down the text? (Used for getting essences)
	db

w7TextboxVramPos: ; $d0d8
; Similar to w7TextboxPos, but this points to the vram where it ends up.
	dw

w7d0da: ; $d0da
	dsb 4

w7InvTextScrollTimer: ; $d0de
	db
w7InvTextSpaceCounter: ; $d0df
; Number of spaces to be inserted before looping back to the start of the text.
	db

w7TextboxOptionPositions: ; $d0e0
; This is 8 bytes. Each byte correspond to a position for an available option in the text prompt.
; The bytes can be written straight to w7TextboxMap as the indices for the tiles that would normally
; be in those positions. They can also be converted into an INDEX for w7TextboxMap with the
; _getAddressInTextboxMap function.
	dsb 8

w7SelectedTextOption: ; $d0e8
; Note that this is distinct from wSelectedTextOption, but they behave very
; similarly. This is just used internally in text routines.
	db

w7SelectedTextPosition: ; $d0e9
; The corresponding value from w7TextboxOptionPositions.
	db

w7d0ea: ; $d0ea
	db

w7TextboxTimer: ; $d0eb
; Number of frames until the textbox closes itself.
	db

w7TextIndexL_backup: ; $d0ec
	db

w7InvTextSpacesAfterName: ; $d0ed
; How many spaces to put after the name of the item (for the inventory menu).
; This is calculated so that the item name appears in the middle.
	db

w7TextSoundCooldownCounter: ; $d0ee
; Frame counter until the next time a character should play its sound effect.
; While nonzero, the text scrolling sound doesn't play (although explicit sound
; effects do play).
	db

w7d0ef: ; $d0ef
	db

w7TextTableAddr: ; $d0f0
	dw
w7TextTableBank: ; $d0f2
	db

w7d0f3: ; $d0f3
	dsb $d

w7TextboxAttributes: ; $d100
; This goes with w7TextboxMap, so it should be the same size.
	dsb $c0

w7TextStack: ; $d1c0
; $20 bytes total, 4 bytes per entry. When looking up a word in a dictionary, this remembers the
; position it left off at.
; Entry format:
;   b0: bank of text where it left off
;   b1/2: address of text where it left off
;   b3: high byte of text index
	dsb $20

w7d1e0: ; $d1e0
	dsb $20

w7TextGfxBuffer:
; Holds a line of text graphics.
	dsb $200

w7LineTextBuffer: ; $d400
; The text for the line
	dsb $10

w7LineAttributesBuffer: ; $d410
; The attributes for the line
	dsb $10

w7LineDelaysBuffer: ; $d420
; The number of frames each character is displayed before the next appears.
	dsb $10

w7LineSoundsBuffer: ; $d430
; The sound each character will play as it's displayed.
	dsb $10

w7LineSoundEffectsBuffer: ; $d440
; Sound effects created by the "sfx" command (ie. goron noise)
	dsb $10

w7LineAdvanceableBuffer: ; $d450
; Bit 0 of a byte in this buffer is set if the text can be advanced with the A/B buttons.
	dsb $10

w7TextVariablesEnd: ; $d460
; Everything from the start of the bank ($d000) up to here is cleared when "initTextbox" is called.
	.db


w7SecretText1: ; $d460
	dsb $c

w7SecretText2: ; $d46c
	dsb $c

w7SecretGenerationBuffer: ; $d478
; This is a 20-byte buffer containing the symbols generated so far (byte form, not ascii).
; Each symbol is 6 bits long (value from $00-$3f).
; When encoding data into a secret, bits are inserted one at a time to the end of this buffer,
; causing all existing data to be shifted forward by one bit.
	dsb 20

.ENDS


.define w7d5e0 $d5e0 ; ?


.RAMSECTION RAM_7_Extra BANK 7 SLOT 3

w7d800:
; Used for a lot of various graphical storage things?
	dsb $800

.ENDS
