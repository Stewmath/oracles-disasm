.enum $c000

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

.ende

.enum $c0a0

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

.ende

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

.define wPaletteFadeCounter	wThreadStateBuffer + $1f ; $c2ff


.enum $c300

wBigBuffer: ; $c300
; General purpose $100 byte buffer (used for scripts, underwater waves maybe?)
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
	instanceof GfxRegsStruct
wGfxRegs2: ; $c48b
; Note: wGfxRegs2 and wGfxRegs3 can't cross pages (say, c2xx->c3xx)
	instanceof GfxRegsStruct
wGfxRegs3: ; $c491
	instanceof GfxRegsStruct
wGfxRegsFinal: ; $c497
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

wPaletteFadeMode: ; $c4ab/$c4ab
	db
wPaletteFadeSpeed: ; $c4ac
	db
wc4ad: ; $c4ad
	db
wPaletteFadeState: ; $c4ae
	db
wc4af: ; $c4af
	db
wc4b0: ; $c4b0
	db
wPaletteFadeBG1: ; $c4b1
	db
wPaletteFadeSP1: ; $c4b2
	db
wPaletteFadeBG2: ; $c4b3
	db
wPaletteFadeSP2: ; $c4b4
	db
wc4b5: ; $c4b5
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

.ende


.enum $c4c0

wTerrainEffectsBuffer: ; $c4c0
; This might only be used for drawing objects' shadows, though in theory it could also be
; used to draw puddles and grass as objects walk over them.  Each entry is 4 bytes: Y, X,
; and an address in the "Special_Animations" section (bank $14).
	dsb $40

wObjectsToDraw: ; $c500
; A $40 byte buffer keeping track of which objects to draw, in what order (first = highest
; priority). Each entry is 2 bytes, consisting of the address of high byte of the object's
; y-position.
	dsb $40

wc540:
; $c540-$c5af unused?
	dsb $70

.ende

; ========================================================================================
; Everything from this point ($c5b0) up to $caff goes into the save data ($550 bytes).
; ========================================================================================

.enum $c5b0

wFileStart: ; $c5b0
; Start of file data (same address as checksum)
	.db

wFileChecksum: ; $c5b0
	dw

wSavefileString: ; $c5b2
; This string is checked to verify the save data.
; Seasons: "Z11216-0"
; Ages:    "Z21216-0
	dsb 8

; $c5ba-$c5bf unused?

.ende


.enum $c5c0

wUnappraisedRings: ; $c5c0
; List of unappraised rings. each byte always seems to have bit 6 set, indicating that the
; ring is unappraised. It probably gets unset the moment you appraise it, but only for
; a moment because then it disappears from this list.
	dsb $40

wUnappraisedRingsEnd: ; $c600
	.db


.ende

; ========================================================================================
; C6xx block: deals largely with inventory, also global flags
; ========================================================================================

.enum $c600 export

wc600Block: ; $c600
	.db

; $c600-c615 treated as a block in at least one place (game link)

wc600: ; $c600
	db
wc601: ; $c601
	db

wLinkName: ; $c602
; 6 bytes, null terminated
	dsb 6

wc608: ; $c608
; This is always 1. Used as a dummy value in various places?
	db

wKidName: ; $c609
	dsb 6

wc60f: ; $c60f
	db

wAnimalRegion: ; $c610
; $0b for ricky, $0c for dimitri, $0d for moosh (same as the SpecialObject id's for their
; corresponding objects)
	db

wc611: ; $c611
; Always $01?
	db

wFileIsLinkedGame: ; $c612
; Copied to wIsLinkedGame
	db

wFileIsHeroGame: ; $c613
	db

wFileIsCompleted: ; $c614
	db

wObtainedRingBox: ; $c615
; Remembers whether you've obtained the ring box.
; There's also a global flag for this, so its only purpose may be keeping track of it for
; linked games?
	db

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

wc637: ; $c637
	db

wLastAnimalMountPointY: ; $c638
; Looks like a component is set to $10 or $70 if the animal enters from
; a particular side. Not sure what it's used for.
	db
wLastAnimalMountPointX: ; $c639
	db

wMinimapGroup: ; $c63a
; Like wActiveGroup, but for the minimap. Not updated in caves.
	db

wMinimapRoom: ; $c63b
; Analagous to wMinimapGroup
	db

wMinimapDungeonMapPosition: ; $c63c
	db
wMinimapDungeonFloor: ; $c63d
	db

wPortalGroup: ; $c63e
	db
wPortalRoom: ; $c63f
	db
wPortalPos: ; $c640
	db

wMapleKillCounter: ; $c641
	db

wHiddenShopItemsBought: ; $c642
; Lower 4 bits mark the items bought from the hidden shop
	db

wc643: ; $c643
	db
wc644: ; $c644
	db
wc645: ; $c645
	db
wc646: ; $c646
; $c646 related to ricky sidequest?
	db
wc647: ; $c647
; $c647 bit 6: relates to raft
	db
wc648: ; $c648
	db
wc649: ; $c649
	db
wc64a: ; $c64a
	db
wc64b: ; $c64b
	db

wGashaSpotFlags	 ; $c64c
; Bit 0 is set if you've harvested at least one gasha nut before. The first gasha nut
; always gives you a "class 1" ring (one of the weak, common ones).
; Bit 1 is set if you've obtained the heart piece from one of the gasha spots.
	db
wGashaSpotsPlantedBitset ; $c64d
; 2 bytes (1 bit for each spot)
	dsb NUM_GASHA_SPOTS/8
wGashaSpotKillCounters: ; $c64f
; 16 bytes (1 byte for each spot)
	dsb NUM_GASHA_SPOTS

wc65f: ; $c65f
; This is a counter which many things (digging, getting hearts, getting a gasha nut)
; increment or decrement. Not sure what it's used for, or if it's used at all.
	dw

wc661: ; $c661
	db

wDungeonVisitedFloors: ; $c662
; 1 byte per dungeon ($10 total). Each byte is a bitset of visited floors for a particular dungeon.
	dsb NUM_DUNGEONS

wDungeonSmallKeys: ; $c672
; 1 byte per dungeon.
	dsb NUM_DUNGEONS

wDungeonBossKeys: ; $c682
; Bitset of boss keys obtained
	dsb NUM_DUNGEONS/8

wDungeonCompasses: ; $c684/$c67c
; Bitset of compasses obtained
	dsb NUM_DUNGEONS/8

wDungeonMaps: ; $c686
; Bitset of maps obtained
	dsb NUM_DUNGEONS/8

wInventoryB: ; $c688
	db
wInventoryA: ; $c689
	db
wInventoryStorage: ; $c68a
; $10 bytes
	dsb INVENTORY_CAPACITY

wObtainedTreasureFlags: ; $c69a
; Enough memory reserved for $80 treasures (though only about $68 are used)
	dsb $10

wLinkHealth: ; $c6aa
	db
wLinkMaxHealth: ; $c6ab
	db
wNumHeartPieces: ; $c6ac
	db

wNumRupees: ; $c6ad
	dw

.ifdef ROM_SEASONS
wNumOreChunks:
; This might be before wNumRupees, not sure yet
	dw
.endif

wShieldLevel: ; $c6af
	db
wNumBombs: ; $c6b0
	db
wMaxBombs: ; $c6b1
	db
wSwordLevel: ; $c6b2
	db
wNumBombchus: ; $c6b3
	db
wSeedSatchelLevel: ; $c6b4
; Determines satchel capacity
	db
wFluteIcon: ; $c6b5
; Determines icon + song, but not companion
	db
wSwitchHookLevel: ; $c6b6
	db
wSelectedHarpSong: ; $c6b7
	db
wBraceletLevel: ; $c6b8
	db
wNumEmberSeeds: ; $c6b9
	db
wNumScentSeeds: ; $c6ba
	db
wNumPegasusSeeds: ; $c6bb
	db
wNumGaleSeeds: ; $c6bc
	db
wNumMysterySeeds: ; $c6bd
	db
wNumGashaSeeds: ; $c6be
	db
wEssencesObtained: ; $c6bf
	db
wTradeItem: ; $c6c0
	db
wc6c1: ; $c6c1
	db
wTuniNutState: ; $c6c2
; 0: broken, 2: fixed (only within Link's inventory?)
	db
wNumSlates: ; $c6c3
; Slates used only in ages dungeon 8
	db
wSatchelSelectedSeeds: ; $c6c4
	db
wShooterSelectedSeeds: ; $c6c5
	db
wRingBoxContents: ; $c6c6
	dsb 5
wActiveRing: ; $c6cb
; When bit 6 is set, the ring is disabled?
	db
wRingBoxLevel: ; $c6cc
	db
wNumUnappraisedRingsBcd: ; $c6cd
	db
wc6ce: ; $c6ce
	db
wc6cf: ; $c6cf
	db

wGlobalFlags: ; $c6d0
	dsb NUM_GLOBALFLAGS/8

wc6e0: ; $c6e0
	db
wc6e1: ; $c6e1
	db
wc6e2: ; $c6e2
	db
wc6e3: ; $c6e3
	db
wc6e4: ; $c6e4
	db
wc6e5: ; $c6e5
	db
wc6e6: ; $c6e6
	db
wc6e7: ; $c6e7
	db

wMakuTreeState: ; $c6e8
; Keeps track of what the Maku Tree says when you talk to her.
	db

wJabuWaterLevel: ; $c6e9
; This almost certainly does more than control the water level.
	db

wc6ea: ; $c6ea
	db
wc6eb: ; $c6eb
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

wc6fb: ; $c6fb
	db

.ende

.define wSeedsAndHarpSongsObtained	wObtainedTreasureFlags+TREASURE_EMBER_SEEDS/8


.enum $c700

; Flags shared for above water and underwater
wPresentRoomFlags: ; $c700
	dsb $100
wPastRoomFlags: ; $c800
	dsb $100

wGroup4Flags: ; $c900
	dsb $100
wGroup5Flags: ; $ca00
	dsb $100

.ende

; Steal 6 of the past room flags for vine seed positions
.define wVinePositions wPastRoomFlags+$f0

; ========================================================================================
; $cb00: END of data that goes into the save file
; ========================================================================================

.enum $cb00 export

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
; $02: inventory screen
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
	dw

wcbaa: ; $cbaa
; cbaa/ab are similar to wTextNumberSubstitution, but possibly unused?
	dw

wTextboxPosition: ; $cbac
; Value from 0-6 determining the position of the textbox.
	db

wcbad: ; $cbad
	db

wTextboxFlags: ; $cbae
	db

wTextSubstitutions: ; $cbaf
; $cbaf-cbb2; each byte is an index which can be used with text control code
; $F, when the parameter is $ff, $fe, $fd, or $fc. The text corresponding to
; the index is inserted into the textbox at that point.
	dsb 4


; Following variables are used for a variety of purposes.
; cbb3-cbc2 are sometimes cleared together.

wFileSelectMode:
	.db
wMinimapDisplayMode:
; 0: present (overworld/underwater)
; 1: past (overworld/underwater)
; 2: dungeon
	.db
wTmpcbb3: ; $cbb3
	db

wFileSelectMode2:
	.db
wMinimapVarcbb4:
	.db
wTmpcbb4: ; $cbb4
	db

wItemSubmenuIndex:
; Selection in submenus (seeds, harp)
	.db
wMinimapDisplayCurrentRoom:
	.db
wTmpcbb5: ; $cbb5
; Used for:
; - Index of link's position on map
; - Index of an interaction?
	db

wMinimapCursorIndex:
	.db
wTmpcbb6: ; $cbb6
; Used for:
; - Index of cursor on map
; - Something in menus
	db

wTextInputMode:
 ; $00 for link name input, $01 for kid name input, $82 for secret input for new file
	.db
wInventorySelectedItem:
	.db
wTmpcbb7: ; $cbb7
	db

wTextInputMaxCursorPos:
	.db
wTmpcbb8: ; $cbb8
	db

wInventorySubmenu2CursorPos2:
	.db
wMinimapPopupState:
; 0: Icon is uninitialized
; 1: Icon is popping in
; 2: Icon is fully loaded
	.db
wTmpcbb9: ; $cbb9
	db

wFileSelectFontXor:
	.db
wTmpcbba: ; $cbba
	db

wFileSelectCursorOffset:
	.db
wInventoryActiveText:
	.db
wMinimapPopupY:
; Y position of the minimap's popup (ie. shows there's a house or gasha spot)
	.db
wTmpcbbb: ; $cbbb
	db

wFileSelectCursorPos:
	.db
wMinimapPopupX:
	.db
wTmpcbbc: ; $cbbc
	db

wFileSelectCursorPos2:
	.db
wMinimapPopupSize:
; This starts at 0 and increases until the popup icon reaches its full size (value 4).
	.db
wTmpcbbd: ; $cbbd
	db

wTextInputCursorPos:
	.db
wItemSubmenuCounter:
	.db
wMinimapPopup1:
	.db
wTmpcbbe: ; $cbbe
	db

wItemSubmenuMaxWidth:
	.db
wFileSelectLinkTimer:
	.db
wMinimapPopup2:
	.db
wTmpcbbf: ; $cbbf
	db

wItemSubmenuWidth:
	.db
wMinimapPopupIndex:
; Either 0 or 1 to determine whether to use wMinimapPopup1 or wMinimapPopup2.
	.db
wTmpcbc0: ; $cbc0
	db

wcbc1: ; $cbc1
	db

wcbc2: ; $cbc2
	db


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

wcbca: ; $cbca
; Related to the switch hook?
	db

wOpenedMenuType: ; $cbcb
; The "openMenu" function sets this variable to something.
;  $01: inventory
;  $02: map
;  $03: save/quit menu
;  $04: ring appraisal
;  $05: warp menu
;  $06: secret input
;  $07: name input
;  $08: linking
;  $09: fake reset
;  $0a: secret list
	db

wMenuLoadState: ; $cbcc
	db

wMenuActiveState: ; $cbcd
	db

wItemSubmenuState: ; $cbce
; State for item submenus (selecting seed satchel, shooter, or harp)
; Also used on the map screen.
	db

wInventorySubmenu: ; $cbcf
; Value from 0-2, one for each submenu on the inventory screen
	db

wInventorySubmenu0CursorPos: ; $cbd0
	db
wInventorySubmenu1CursorPos: ; $cbd1
	db
wInventorySubmenu2CursorPos: ; $cbd2
	db
wcbd3: ; $cbd3
	db
wcbd4: ; $cbd4
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
wcbe3: ; $cbe3
; cbe3: palette header index for menus?
	db
wDisplayedHearts: ; $cbe4
	db
wDisplayedRupees: ; $cbe5
	dw

wDontUpdateStatusBar: ; $cbe7
; if nonzero, status bar doesn't get updated
	db

wcbe8: ; $cbe8
; Bit 7: whether status bar is reorganized for biggoron's sword maybe?
; Bit 0 set if status bar needs to be reorganized slightly for last row of hearts
	db

wStatusBarNeedsRefresh: ; $cbe9
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

.ende

.enum $cc00 export

wcc00Block: ; $cc00
	.db

wFrameCounter: ; $cc00
; Value copied from low byte of wPlaytimeCounter
	db

wIsLinkedGame: ; $cc01
	db

wMenuDisabled: ; $cc02/$cc02
	db

wCutsceneState: ; $cc03
	db

wCutsceneTrigger: ; $cc04
; Gets copied to wcutsceneIndex. So, writing a value here triggers a cutscene.
; (See constants/cutsceneIndices.s)
	db

wcc05: ; $cc05
; bit 0: if set, prevents the room's object data from loading
; bit 2: if set, prevents remembered Companions from loading
; bit 3: if set, prevents Maple from loading
	db

wLoadedNpcGfxIndex: ; $cc06
; An index for wLoadedNpcGfx. Keeps track of where to add the next thing to be
; loaded?
	db

wcc07: ; $cc07
	db

wLoadedNpcGfx: ; $cc08
; This is a data structure related to used sprites. Each entry is 2 bytes, and
; corresponds to an npc gfx header loaded into vram at its corresponding
; position.
; Eg. Entry $cc08/09 is loaded at $8000, $cc0a/0b is loaded at $8200.
; Byte 0 is the index of the npc header (see npcGfxHeaders.s).
; Byte 1 is whether these graphics are currently in use?
	dsb $10
wLoadedNpcGfxEnd: ; $cc18
	.db

wLoadedTreeGfxIndex: ; $cc18
; This (along with wLoadedTreeGfxActive) is the same structure as the above buffer, but
; only for trees.
	db
wLoadedTreeGfxActive: ; $cc19
	db

wcc1a: ; $cc1a
	db

; These are uncompressed gfx header indices.
; They're used for loading graphics for certain items (sword, cane, switch hook,
; boomerang... not bombs, seeds).
wLoadedItemGraphic1: ; $cc1b
	db
wLoadedItemGraphic2: ; $cc1c
	db

wcc1d: ; $cc1d
	db
wcc1e: ; $cc1e
; an interaction's id gets written here? Relates to wLoadedTreeGfxIndex?
	db
wcc1f: ; $cc1f
	db
wcc20: ; $cc20
	db

; Point to respawn after falling in hole or w/e
wLinkLocalRespawnY: ; $cc21
	db
wLinkLocalRespawnX: ; $cc22
	db
wLinkLocalRespawnDir: ; $cc23
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
wGameKeysPressed: ; $cc29
	db
wGameKeysJustPressed: ; $cc2a
	db

wLinkAngle: ; $cc2b
; Same as w1Link.angle? Set to $FF when not moving. Should always be a multiple of
; 4 (since d-pad input doesn't allow more fine-grained angles)
	db

wLinkObjectIndex: ; $cc2c/$cc48
; Usually $d0; set to $d1 while riding an animal, minecart
	db

wActiveGroup: ; $cc2d/$cc49
; Groups 0-5 are the normal groups.
; 6-7 are the same as 4-5, except they are considered sidescrolling rooms.
	db

wRoomIsLarge: ; $cc2e
; $00 for normal-size rooms, $01 for large rooms
	db

wLoadingRoom: ; $cc2f
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

wActiveCollisions: ; $cc33
; wActiveCollisions should be a value from 0-5.
; 0: overworld, 1: indoors, 2: dungeons, 3: sidescrolling, 4: underwater, 5?
	db

wAreaFlags: ; $cc34/$cc50
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
wDungeonFloor: ; $cc3b
; Index for w2DungeonLayout, possibly used for floors?
	db

wDungeonRoomProperties: ; $cc3c/$cc58
	db


wDungeonMapData: ; $cc3d
; 8 bytes of dungeonData copied to here
	.db

wDungeonFlagsAddressH: ; $cc3d
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


wWarpDestVariables: ; $cc47
	.db

wWarpDestGroup: ; $cc47/$cc63
; Like wActiveGroup, except among other things, bit 7 can be set. Dunno what
; that means.
	db
wWarpDestIndex: ; $cc48/$cc64
; This first holds the warp destination index, then the room index.
	db
wWarpTransition: ; $cc49/$cc65
; Bits 0-3 are the half-byte given in WarpDest or StandardWarp macros.
; Bit 6 determines link's direction for screen-edge warps?
; Bit 7 set if this is the "destination" part of the warp?
	db
wWarpDestPos: ; $cc4a/$cc66
	db
wWarpTransition2: ; $cc4b/$cc67
; wWarpTransition2 is set by code.
; Values for wWarpTransition2:
; 00: none
; 01: instant
; 03: fadeout
	db

wWarpDestVariablesEnd: ; $cc4c
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
;  LINK_STATE_04: determines Link's animation?
;  LINK_STATE_SQUISHED:
;                 Bits 0-6: If zero, he's squished hozontally, else vertically.
;                 Bit 7: If set, Link should die; otherwise he'll just respawn.
;  LINK_STATE_08: Affects Link's animation?
;  LINK_STATE_WARPING: ???

; Link's various states use this differently:
; $0a (LINK_STATE_WARPING): If bit 4 is set, the room Link warps to will not be marked as
;   "visited" (at least, for time-warp transitions).
; $0b (LINK_STATE_FORCE_MOVEMENT): This is the number of frames he will remain in that
;   state - effectively, the number of frames he will be forced to move in a particular
;   direction.
; This can be used for various other purposes depending on the state, though.
	db

wLinkStateParameter: ; $cc51/$cc6c
	db

wcc52: ; $cc52
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

wLinkGrabState2: ; $cc5b
; bit 7: set when pulling a lever?
; bits 4-6: weight of object (0-4 or 0-5?). (See _itemWeights.)
; bits 0-3: should equal 0, 4, or 8; determines where the grabbed object is placed
;           relative to Link. (See "updateGrabbedObjectPosition".)
	db


; cc5c-cce9 treated as a block


wLinkInAir: ; $cc5c
; Bit 7: lock link's movement direction, prevent jumping
; Bit 5: If set, Link's gravity is reduced
; Bit 1: set when link is jumping
; Bit 0: set when jumping down a cliff
; If nonzero, Link's knockback durations are halved.
	db

wLinkSwimmingState: ; $cc5d
; Bit 7 is set when Link dives underwater.
; Bit 6 causes Link to drown.
; Bits 0-3 hold a "state" which remembers whether Link is actually in the water, and
; whether he just entered or has been there for a few frames.
	db

wcc5e: ; $cc5e
	db

wLinkUsingItem1: ; $cc5f
; $cc5e: Makes Link get stuck in a "punching" / using item animation?
; If bit 6 is set, Link ignores holes.

; This is a bitset of special item objects ($d2-$d5) which are being used?
	db

wLinkTurningDisabled: ; $cc60
; Bit 7: set when Link presses the A button next to an object (ie. npc)
; When this is nonzero, Link's facing direction is locked (ie. using a sword).
	db

wLinkImmobilized: ; $cc61
; Set when link is using an item which immobilizes him. Each bit corresponds to
; a different item.
; Bit 4: Set when Link is falling down a hole
	db

wcc62: ; $cc62
	db

wcc63: ; $cc63
; $cc63: set when link is holding a sword out?
; When bit 7 is set, item usage is disabled; when it equals $ff, Link is forced to do
; a sword spin. Maybe used when getting the sword in Seasons?
	db

wBraceletGrabbingNothing: ; $cc64
; This is set to Link's direction (or'd with $80) when holding the bracelet and not
; grabbing anything. Probably used for the rollers in Seasons
	db

wLinkPushingDirection: ; $cc65
; This is equal to w1Link.direction when he's pushing something.
; When he's not pushing something, this equals $ff.
	db

wForceLinkPushAnimation: ; $cc66
; If $01, link always does a pushing animation; if bit 7 is set, he never does
	db

wcc67: ; $cc67
; when set, prevents Link from throwing an item.
	db

wLinkClimbingVine: ; $cc68
; Set to $ff when link climbs certain ladders. Forces him to face upwards.
	db

wLinkRaisedFloorOffset: ; $cc69
; This shifts the Y position at which link is drawn.
; Used by the raisable platforms in various dungeons.
; If nonzero, Link is allowed to walk on raised floors.
	db

wPushingAgainstTileCounter: ; $cc6a
; Keeps track of how many frames Link has been pushing against a tile, ie. for push
; blocks, key doors, etc.
	db

wInstrumentsDisabledCounter: ; $cc6b
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

wUsingShield: ; $cc6f
; Nonzero if link is using a shield. If he is, the value is equal to [wShieldLevel].
	db


; Offset from link's position, used for collision calculations
wShieldY: ; $cc70
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
; * state2 = 0
; * enabled |= 2
	dsb $10
wGrabbableObjectBufferEnd: ; $cc84
	.db

wcc84: ; $cc84
	db
wcc85: ; $cc85
	db

wRoomEdgeY: ; $cc86
	db
wRoomEdgeX: ; $cc87
	db

wcc88: ; $cc88
	db
wSecretInputResult: ; $cc89
; Related to whether a valid secret was entered?
	db

wDisabledObjects: ; $cc8a
; Bit 0 disables link.
; Bit 1 disables interactions.
; Bit 2 disables enemies.
; Bit 4 disables items.
; Bit 5 set when being shocked?
; Bit 7 disables link, items, enemies, not interactions.
	db

wcc8b: ; $cc8b
	db
wcc8c: ; $cc8c
	db

wPlayingInstrument1: ; $cc8d
; Set when playing an instrument. Copied to wPlayingInstrument2?
	db

wEnteredWarpPosition: ; $cc8e
; After certain warps and when falling down holes, this variable is set to Link's
; position. When it is set, the warp on that tile does not function.
; This prevents Link from instantly activating a warp tile when he spawns in.
; This is set to $ff when the above does not apply.
	db

wNumTorchesLit: ; $cc8f
	db

wcc90: ; $cc90
	db

wcc91: ; $cc91
; If nonzero, screen transitions and diving don't work?
	db

wcc92: ; $cc92
; Bit 7 set when over a hole, first entering water, dismounting raft,
;       knockback when on raft...
; Bit 3 set when moving on a raft (allows screen transitions over water)
; Bit 2 set on conveyors?
	db

wcc93: ; $cc93
	db

wScreenShakeMagnitude: ; $cc94
; Affects how much the screen shakes when the "wScreenShakeCounter" variables are set.
; 0: 1-2 pixels
; 1: 1 pixel
; 2: 3 pixels
	db

wcc95: ; $cc95
; $cc95: something to do with items being used (like wLinkUsingItem1, 2)
; If bit 7 is set, link can't move or use items.
	db

wPlayingInstrument2: ; $cc96
; If nonzero, Link is basically invincible. Copied from wPlayingInstrument1?
	db

wcc97: ; $cc97
	db

wcc98: ; $cc98
; $cc98: relates to switch hook
	db

; The tile Link is standing on
wActiveTilePos: ; $cc99
	db
wActiveTileIndex: ; $cc9a
	db

wStandingOnTileCounter: ; $cc9b
; This counter is used for certain tile types to help implement their behaviours.
; Ie. cracked floors use this as a counter until the floor breaks.
	db

wActiveTileType: ; $cc9c
; Different values for grass, stairs, water, etc
	db

wLastActiveTileType: ; $cc9d
; In top-down sections, this seems to remember the tile that Link stood on last frame.
; In sidescroll sections, however, this keeps track of the tile underneath Link instead.
	db

wIsTileSlippery: ; $cc9e
; Bit 6 is set if Link is on a slippery tile.
	db

wLinkOnChest: ; $cc9f
; Position of chest link is standing on ($00 doesn't count)
	db

wActiveTriggers: ; $cca0
; Keeps track of which switches are set (buttons on the floor)
	db

; $cca1-$cca2: Changes behaviour of chests in shops? (For the chest game probably)
wcca1: ; $cca1
	db
wcca2: ; $cca2
	db

wChestContentsOverride: ; $cca3
; 2 bytes. When set, this overrides the contents of a chest. Probably used in the chest
; minigame?
	dw

wcca5: ; $cca5
	db
wcca6: ; $cca6
	db
wcca7: ; $cca7
	db
wcca8: ; $cca8
	db
wcca9: ; $cca9
; $cca9: relates to ganon/twinrova fight somehow
	db
wccaa: ; $ccaa
	db
wccab: ; $ccab
; $ccab: used for pulling levers?
	db
wccac: ; $ccac
	db

wRotatingCubeColor: ; $ccad
; Color of the rotating cube (0-2)
; Bit 7 gets set when the torches are lit
	db
wRotatingCubePos: ; $ccae
	db

wccaf: ; $ccaf
; Tile index being poked or slashed at?
	db
wccb0: ; $ccb0
; Tile position being poked or slashed at?
	db

wccb1: ; $ccb1
	db

wDisableWarps: ; $ccb2
; Not sure what purpose this is for
	db

wAButtonSensitiveObjectList: ; $ccb3
; List of objects which react to A button presses. Each entry is a pointer to
; their corresponding "Object.pressedAButton" variable.
	dsb $20
wAButtonSensitiveObjectListEnd: ; $ccd3
	.db

wInShop: ; $ccd3
; Set when in a shop, prevents Link from using items
	db

wLinkPushingAgainstBedCounter: ; $ccd4
; $ccd4 seems to be used for multiple purposes.
; One of them is as a counter for how many frames you've pushed against the bed in Nayru's
; house. Once it reaches 90, Link jumps in.
	db

wccd5: ; $ccd5
	db
wccd6: ; $ccd6
	db

wInformativeTextsShown: ; $ccd7
; Keeps track of whether certain informative texts have been shown.
; ie. "This block has cracks in it" when pushing against a cracked block.
; This is also used to prevent Link from jumping into the bed in Nayru's house more than
; once.
	db

wccd8: ; $ccd8
; If nonzero, link can't use his sword. Relates to dimitri?
	db

wccd9: ; $ccd9
; Nonzero while scent seed is active?
	db

wIsSeedShooterInUse: ; $ccda
; Set when there is a seed shooter seed on-screen
	db

wIsLinkBeingShocked: ; $ccdb
	db
wLinkShockCounter: ; $ccdc
	db

wSwitchHookState: ; $ccdd
; Used when swapping with the switch hook
	db

wccde: ; $ccde
	db

; Indices for w2ChangedTileQueue
wChangedTileQueueHead: ; $ccdf
	db
wChangedTileQueueTail: ; $cce0
	db

wcce1: ; $cce1
	db
wcce2: ; $cce2
	db
wcce3: ; $cce3
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
wFollowingLinkObject: ; $cce8
	db

wcce9: ; $cce9
; This might be a marker for the end of data in the $cc00 block?
	.db

.ende


; These $30 bytes at $cd00 are treated as a unit in a certain place
.define wScreenVariables.size $30

.enum $cd00 export

wScreenVariables: ; $cd00
	.db

wScrollMode: ; $cd00
; Equals 1 under most normal circumstances
; Equals 8 while doing a normal screen transition
; When set to 0, scrolling stops in big areas.
; Bit 0 disables animations when unset, among other things apparently.
; When bit 1 is set link can't move.
; Bit 2 is set when link is doing a walk-out-of-screen transition.
; Bit 7 is set while the screen is scrolling or text is on the screen
	db

wcd01: ; $cd01
; $cd01: 0 for large rooms, 1 for small rooms?
; See constants/directions.s for what the directions are.
; Set bit 7 to force a transition to occur.
	db

wScreenTransitionDirection: ; $cd02/$cd02
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
; This is set when calling "objectCheckIsOverPit". Might be ages-exclusive?
	db

wAreaUniqueGfx: ; $cd20
	db
wAreaGfx: ; $cd21
	db
wAreaPalette: ; $cd22
	db
wAreaTileset: ; $cd23
	db
wAreaLayoutGroup: ; $cd24
	db
wAreaAnimation: ; $cd25
	db

wcd26: ; $cd26
	db
wcd27: ; $cd27
	db

wLoadedAreaUniqueGfx: ; $cd28
	db
wLoadedAreaPalette: ; $cd29
	db
wLoadedAreaTileset: ; $cd2a
	db
wLoadedAreaAnimation: ; $cd2b
	db
wLastToggleBlocksState: ; $cd2c
; Corresponds to wToggleBlocksState. This is used to detect changes to it.
	db
wcd2d: ; $cd2d
	db

; $cd2e-$cd2f unused?

.ende


.enum $cd30 export

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

.ende

.enum $cd40 export

wTmpVramBuffer: ; $cd40
; Used temporarily for vram transfers, dma, etc.
	dsb $40

wStaticObjects: ; $cd80
; Note: this is $40 bytes, but Seasons will actually read $80 bytes in the
; "findFreeStaticObjectSlot" function?
	dsb $40

wcdc0: ; $cdc0
	dsb $10

wcdd1: ; $cdd1
	db

wNumEnemies: ; $cdd1
; Number of enemies on the screen. When this reaches 0, certain events trigger. Not all
; enemies count for this.
	db

wToggleBlocksState: ; $cdd2
; State of the blocks that are toggled by the orbs
	db

wSwitchState: ; $cdd3
; Each bit keeps track of whether a certain switch has been hit.
; Persists between rooms?
	db

wcdd4: ; $cdd4
	db

wLinkDeathTrigger: ; $cdd5
; Write anything here to make link die
	db
wGameOverScreenTrigger: ; $cdd6
; Write anything here to open the Game Over screen
	db

wcdd7: ; $cdd7
	db
wcdd8: ; $cdd8
	db
wcdd9: ; $cdd9
	db

wIsMaplePresent: ; $cdda
; Nonzero while maple is on the screen.
	db

wcddb: ; $cddb
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

; $cde3-4: Used for storing items for blaino boxing minigame?
wcde3: ; $cde3
	db
wcde4: ; $cde4
	db

; $cde5-$ceff unused?

.ende

.define wStaticObjects.size	$40


.enum $ce00

wRoomCollisions: ; $ce00
; $10 bytes larger than it needs to be?
	dsb $c0
wRoomCollisionsEnd: ; $cec0
	.db

wTmpcec0: ; $cec0
	db
wTmpNumEnemies: ; $cec1
	db
wTmpEnemyPos: ; $cec2
	db
wcec3: ; $cec3
	db
wcec4: ; $cec4
	db
wcec5: ; $cec5
	db
wcec6: ; $cec6
	db
wcec7: ; $cec7
	db
wcec8: ; $cec8
	db
wcec9: ; $cec9
	db
wceca: ; $ceca
	db
wcecb: ; $cecb
	db
wcecc: ; $cecc
	db
wcecd: ; $cecd
	db
wcece: ; $cece
	db
wRandomEnemyPlacementAttemptCounter: ; $cecf
	db

.ende

.enum $cf00

wRoomLayout: ; $cf00
; $10 bytes larger than it needs to be?
	dsb $c0
wRoomLayoutEnd: ; $cfc0
	.db

wcfc0: ; $cfc0
; Used in the cutscene after jabu as a sort of cutscene state thing?
; Also used by scripts, possibly just as a scratch variable?
; Also, bit 0 is set whenever a keyhole in the overworld is opened. This triggers the
; corresponding cutscene (which appears to be dependent on the room you're in).
	db
wcfc1: ; $cfc1
; Another cutscene thing?
	db

wcfc2: ; $cfc2
	dsb $e

wcfd0: ; $cfd0
	db
wcfd1: ; $cfd1
	db
wcfd2: ; $cfd2
	db
wcfd3: ; $cfd3
	db
wcfd4: ; $cfd4
	db
wcfd5: ; $cfd5
	db
wcfd6: ; $cfd6
	db
wcfd7: ; $cfd7
	db

wcfd8: ; $cfd8
; 8 byte buffer of some kind
; Used in events triggered by stuff falling down holes
	dsb 8

; cfde: used to check how many guys have been talked to in the intro on the nayru screen?

.ende

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

.ENUM $d000
	w1Link:			instanceof SpecialObjectStruct
	; This is used for:
	; * Items from treasure chests
	; * Key door openers
	w1ReservedInteraction0:	instanceof InteractionStruct
.ENDE

.ENUM $d100
	w1Companion:		instanceof SpecialObjectStruct
	w1ReservedInteraction1:	instanceof InteractionStruct
.ENDE

.ENUM $d200
	; Used for stuff Link holds?
	w1ParentItem2:		instanceof ItemStruct
.ENDE
.ENUM $d300
	; Used for projectiles like w1ParentItem4?
	w1ParentItem3:		instanceof ItemStruct
.ENDE
.ENUM $d400
	; Used for projectiles like w1ParentItem3?
	w1ParentItem4:		instanceof ItemStruct
.ENDE
.ENUM $d500
	; Used for flute, harp, shield?
	w1ParentItem5:		instanceof ItemStruct
.ENDE
.ENUM $d600
	w1WeaponItem:		instanceof ItemStruct
.ENDE

.ENUM $dc00
	; The item that Link is holding / throwing?
	w1ReservedItemC:	instanceof ItemStruct
.ENDE

.ENUM $de00
	; Doesn't have collisions? (comes after LAST_STANDARD_ITEM_INDEX)
	; Used to store positions for switch hook (ITEMID_SWITCH_HOOK_HELPER).
	w1ReservedItemE:	instanceof ItemStruct
.ENDE

.ENUM $df00
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

.define FIRST_ENEMY_INDEX		$d0
.define LAST_ENEMY_INDEX		$df

.define FIRST_PART_INDEX		$d0

; Reserved interaction slots
.define PIRATE_SHIP_INTERACTION_INDEX	$d1

; ========================================================================================
; Bank 2: used for palettes & other things
; ========================================================================================

.RAMSECTION "RAM 2" BANK 2 SLOT 3

; $d000 used as part of the routine for redrawing the collapsed d2 cave in the present
w2Filler1:			dsb $0800

; This is a list of values for scrollX or scrollY registers to make the screen turn all
; wavy (ie. in underwater areas).
w2WaveScrollValues:		dsb $80	; $d800/$d800

w2Filler7:			dsb $80

; Tree refill data also used for child and an event in room $2f7
w2SeedTreeRefillData:		dsb NUM_SEED_TREES*8 ; $d900/3:dfc0

; Bitset of positions where objects (mostly npcs) are residing. When one of these bits is
; set, this will prevent Link from time-warping onto the corresponding tile.
w2SolidObjectPositions:			dsb $010 ; $d980

w2Filler6:			dsb $70

w2ColorComponentBuffer1:	dsb $090 ; $da00

; Keeps a history of Link's path when objects (Impa) are following Link.
; Consists of 16 entries of 3 bytes each: direction, Y position, X position.
w2LinkWalkPath:			dsb $030 ; $da90

w2ChangedTileQueue:		dsb $040 ; $dac0
w2ColorComponentBuffer2:	dsb $090 ; $db00

w2AnimationQueue:		dsb $20	; $db90

w2Filler4:			dsb $50

; Each $40 bytes is one floor
w2DungeonLayout:	dsb $100	; $dc00

w2Filler2: dsb $100

w2GbaModePaletteData:	dsb $80		; $de00

w2AreaBgPalettes:	dsb $40		; $de80
w2AreaSprPalettes:	dsb $40		; $dec0

w2BgPalettesBuffer:	dsb $40		; $df00
w2SprPalettesBuffer:	dsb $40		; $df40

w2FadingBgPalettes:	dsb $40		; $df80
w2FadingSprPalettes:	dsb $40		; $dfc0

.ENDS

; ========================================================================================
; Bank 3: tileset data
; ========================================================================================

.RAMSECTION "RAM 3" BANK 3 SLOT 3

; 8 bytes per tile: 4 for tile indices, 4 for tile attributes
w3TileMappingData:	dsb $800	; $d000

; Room tiles in a format which can be written straight to vram. Each row is $20 bytes.
w3VramTiles:		dsb $100	; $d800

w3Filler1:		dsb $200

; Each byte is the collision mode for that tile.
; The lower 4 bits seem to indicate which quarters are solid.
w3TileCollisions:	dsb $100	; $db00

; Indices for tileMappingTable. 2 bytes each, $100 tiles total.
w3TileMappingIndices:	dsb $200	; $dc00

; Analagous to w3VramTiles. Contains the attributes to write to vram.
; Same memory used as w3TileMappingIndices.
; w3VramAttributes:	dsb $200	; $dc00

w3Filler2:		dsb $100

w3RoomLayoutBuffer:	dsb $100	; $df00

.ENDS

; ========================================================================================
; Bank 4
; ========================================================================================

.RAMSECTION "Ram 4" BANK 4 SLOT 3

w4TileMap:			dsb $240	; $d000-$d240
w4StatusBarTileMap:		dsb $40		; $d240
w4PaletteData:			dsb $40		; $d280
w4Filler3:			dsb $40
w4SavedOam:			dsb $a0		; $d300
w4TmpRingBuffer			dsb NUM_RINGS		; $d3a0
w4Unknown1:			dsb $20		; $d3e0
w4AttributeMap:			dsb $240	; $d400-$d640
w4StatusBarAttributeMap:	dsb $40		; $d640

; Icon graphics for the two equipped items
w4ItemIconGfx:			dsb $80		; $d680

w4Filler5:			dsb $80

w4FileDisplayVariables:		INSTANCEOF FileDisplayStruct 3	; $d780

w4Filler7:			dsb 8

w4NameBuffer:			dsb 6		; $d7a0
w4Filler6:			dsb $1a
w4SecretBuffer:			dsb $20		; $d7c0
w4Filler8:			dsb $20

w4SavedVramTiles:		dsb $180	; $d800

w4Filler1:			dsb $280
w4GfxBuf1:			dsb $200	; $dc00
w4GfxBuf2:			dsb $200	; $de00

.ENDS

; ========================================================================================
; Bank 5
; ========================================================================================

.RAMSECTION "Ram 5" BANK 5 SLOT 3

w5NameEntryCharacterGfx:	dsb $100	; $d000

.ENDS

; ========================================================================================
; Bank 6
; ========================================================================================

.RAMSECTION "Ram 6" BANK 6 SLOT 3

w6Filler1:			dsb $600

w6SpecialObjectGfxBuffer:	dsb $100	; $d600

.ENDS

; ========================================================================================
; Bank 7: used for text
; ========================================================================================

.define TEXT_BANK $07

; Mapping for textbox. Goes with w7TextboxAttributes.
; Each row is $20 bytes, and there are 5 rows. So this should take $a0 bytes.
.define w7TextboxMap	$d000

.define w7TextDisplayState $d0c0

; When bit 0 is set, text skips to the end of a line (A or B was pressed)
; When bit 3 is set, an option prompt has already been shown?
; When bit 4 is set, an extra text index will be shown when this text is done.
; See _getExtraTextIndex.
; When bit 5 is set, it shows the heart icon like when you get a piece of heart.
.define w7d0c1		$d0c1

; This is $00 when the text is done, $01 when a newline is encountered, and $ff
; for anything else?
.define w7TextStatus		$d0c2

; w7SoundEffect is a one-off sound effect, while w7TextSound is the sound that
; each character makes as it's displayed.
.define w7SoundEffect	$d0c3
.define w7TextSound	$d0c4

; How many frames each character is displayed for before the next appears
.define w7CharacterDisplayLength	$d0c5
; The timer until the next character will be displayed
.define w7CharacterDisplayTimer		$d0c6

; The attribute byte for subsequent characters. This is the byte that is
; written into vram bank 1, which determines which palette to use and stuff
; like that.
.define w7TextAttribute	$d0c7

; Whether or not the little red arrow in the bottom-right is being displayed.
; This can be eiher $02 (not displayed) or $03 (displayed).
; This changes every 16 frames.
.define w7TextArrowState $d0c8

; These 3 bytes specify where the tilemap for the textbox is located. It points
; to the start of the row where it should be displayed.
.define w7TextboxPosBank $d0c9
.define w7TextboxPosL	$d0ca
.define w7TextboxPosH	$d0cb
; d0cc: low byte of where to save the tiles under the textbox?
.define w7d0cc		$d0cc

; The next column of text to be shown
.define w7NextTextColumnToDisplay	$d0d0

; This variable is used by the retrieveTextCharacter function.
; 0: read a normal character
; 1: read a kanji
; 2: read a trade item symbol
.define w7TextGfxSource	$d0d2

; Textbox position?
.define w7d0d3		$d0d3

.define w7ActiveBank	$d0d4
; d0d5/6: address of text being read?
.define w7TextAddressL	$d0d5
.define w7TextAddressH	$d0d6

; d0d7: counter for how long to slow down the text? (Used for getting essences)
.define w7TextSlowdownTimer $d0d7

; Similar to w7TextboxPos, but this points to the vram where it ends up.
.define w7TextboxVramPosL $d0d8
.define w7TextboxVramPosH $d0d9

.define w7InvTextScrollTimer	$d0de
; Number of spaces to be inserted before looping back to the start of the text.
.define w7InvTextSpaceCounter	$d0df

; This is 8 bytes. Each byte correspond to a position for an available option
; in the text prompt.
; The bytes can be written straight to w7TextboxMap as the indices for the
; tiles that would normally be in those positions. They can also be converted
; into an INDEX for w7TextboxMap with the _getAddressInTextboxMap function.
.define w7TextboxOptionPositions $d0e0

; Note that this is distinct from wSelectedTextOption, but they behave very
; similarly. This is just used internally in text routines.
.define w7SelectedTextOption	$d0e8
; The corresponding value from w7TextboxOptionPositions.
.define w7SelectedTextPosition		$d0e9

.define w7d0ea		$d0ea

; Number of frames until the textbox closes itself.
.define w7TextboxTimer		$d0eb
.define w7TextIndexL_backup			$d0ec

; How many spaces to put after the name of the item.
; This is calculated so that the item name appears in the middle.
.define w7InvTextSpacesAfterName	$d0ed

; Frame counter until the next time a character should play its sound effect.
; While nonzero, the text scrolling sound doesn't play (although explicit sound
; effects do play).
.define w7TextSoundCooldownCounter	$d0ee

.define w7d0ef		$d0ef

.define w7TextTableAddr $d0f0
.define w7TextTableBank $d0f2

; How big is this?
.define w7TextboxAttributes	$d100

; $20 bytes total, 4 bytes per entry. When looking up a word in a dictionary,
; this remembers the position it left off at.
; b0: bank of text where it left off
; b1/2: address of text where it left off
; b3: high byte of text index
.define w7TextStack	$d1c0

; Holds a line of text graphics. $200 bytes.
.define w7TextGfxBuffer $d200

; The text for the line
.define w7LineTextBuffer	$d400
; The attributes for the line
.define w7LineAttributesBuffer $d410
; The number of frames each character is displayed before the next appears.
.define w7LineDelaysBuffer	$d420
; The sound each character will play as it's displayed.
.define w7LineSoundsBuffer	$d430
; Sound effects created by the "sfx" command (ie. goron noise)
.define w7LineSoundEffectsBuffer	$d440
; Bit 0 of a byte in this buffer is set if the text can be advanced with the
; A/B buttons.
.define w7LineAdvanceableBuffer		$d450

.define w7SecretBuffer1		$d460
.define w7SecretBuffer2		$d46c
; Manually define the bank number for now
.define :w7SecretBuffer1	$07

; $d5e0: Used at some point for unknown purpose
