; Function copied to RAM to read a byte from another bank. $14 bytes reserved.
.define wMusicReadFunction	$c000

 ; When [wSoundFadeCounter]&[wSoundFadeSpeed] == 0, volume is incremented or decremented.
.define wSoundFadeCounter	$c014
.define wSoundFadeDirection	$c015 ; $01 for fadeout (volume down), $0a for fadein
.define wSoundFadeSpeed		$c016

; Used within the music playing functions
.define wLoadingSoundBank	$c017

; Initially used as the index of the sound to play, then as a channel index. Only used in
; one function.
.define wSoundTmp		$c018
; This holds the priority of a channel being read, but only in one function.
.define wSoundChannelValue	$c019

; The sound channel being "operated on" for various functions.
.define wSoundChannel		$c01a

; All sound processing is disabled when this is nonzero
.define wSoundDisabled		$c01b

.define wSoundCmd		$c01d
; This value goes straight to NR12/NR22
; In some situations it is also used to mark whether to reset / use the counter
; for the channel (NRx4)
.define wSoundCmdEnvelope	$c01e

.define wSoundFrequencyL	$c01f
.define wSoundFrequencyH	$c020

.define wWaveformIndex		$c021

; Basically the same as hMusicVolume, except this is only used in the music routines.
.define wMusicVolume		$c022

; Relates to muting channel 3 when wMusicVolume is set to 0?
.define wC023			$c023

; This value goes straight to NR50.
; Bits 0-2: left speaker, 4-6: right speaker (unless I mixed them up)
.define wSoundVolume		$c024

.define wC025			$c025
.define wC02d			$c02d

; An offset for wSoundFrequencyL,H
.define wChannelPitchShift $c033

; c039 might be related to the "counter" bit (NRx4)
.define wC039 $c039

; c03f might be related to sweep
.define wC03f $c03f

.define wC045 $c045
.define wChannelVibratos $c04b
.define wC051 $c051
.define wChannelDutyCycles $c057

.define wC05d $c05d
.define wC061 $c061
.define wChannelEnvelopes $c065
.define wChannelEnvelopes2 $c069
; $8 bytes each
.define wChannelsEnabled $c06d
.define wChannelWaitCounters $c075
.define wChannelVolumes $c07d

; $10 bytes
.define wMusicQueue $c0a0

; Stacks grow down on the gameboy. So the main stack is from $c0b0-$c10f?
.define wMainStackTop $c110
.define wThread0StackTop $c180
.define wThread1StackTop $c220
.define wThread2StackTop $c270
.define wThread3StackTop $c2c0

; $20 byte buffer (with a few 2-byte gaps)
.define wThreadStateBuffer $c2e0

.define NUM_THREADS	4

; Used for the intro
.define THREAD_0	<wThreadStateBuffer + 0*8
; Used for main game, file select screen
.define THREAD_1	<wThreadStateBuffer + 1*8
; Used for displaying text
.define THREAD_2	<wThreadStateBuffer + 2*8
; Used for handling palette fadeouts (basically always on?)
.define THREAD_3	<wThreadStateBuffer + 3*8

.define wIntroStage	wThreadStateBuffer + 6
.define wIntroVar	wThreadStateBuffer + 7

.define wC2ee		wThreadStateBuffer + $e
; Writing a value here triggers a cutscene.
.define wCutsceneIndex	$c2ef

.define wPaletteFadeCounter $c2ff

; General purpose $100 byte buffer (used for scripts, underwater waves maybe?)
.define wBigBuffer	$c300

; Dunno how big this buffer is
.define wVBlankFunctionQueue	$c400

.enum $c480
	wKeysPressedLastFrame: 	db ; c480
	wKeysPressed: 		db ; c481
	wKeysJustPressed: 	db ; c482
	wAutoFireKeysPressed: 	db ; c483
	wAutoFireCounter: 	db ; c484

; Note: wGfxRegs2 and wGfxRegs3 can't cross pages (say, c2xx->c3xx)
	wGfxRegs1:	instanceof GfxRegsStruct	; $c485
	wGfxRegs2:	instanceof GfxRegsStruct	; $c48b
	wGfxRegs3:	instanceof GfxRegsStruct	; $c491
	wGfxRegsFinal:	instanceof GfxRegsStruct	; $c497
.ende
; Enum end at $c49d

; Used by vblank wait loop
.define wVBlankChecker	$c49d

.enum $c49f
	wGfxRegs6	instanceof GfxRegsStruct ; $c49f
	wGfxRegs7	instanceof GfxRegsStruct ; $c4a5
.ende

.define wPaletteFadeMode $c4ab
.define wPaletteFadeSpeed $c4ac
.define wC4ad		 $c4ad
.define wPaletteFadeState $c4ae
.define wC4af		 $c4af
.define wC4b0		 $c4b0
.define wPaletteFadeBG1	$c4b1
.define wPaletteFadeSP1	$c4b2
.define wPaletteFadeBG2	$c4b3
.define wPaletteFadeSP2	$c4b4
.define wC4b5		$c4b5

; If bit 0 is set, objects don't get drawn.
.define wC4b6		$c4b6

; This is just a jp opcode afaik
.define wRamFunction	$c4b7

; This is a pointer to the oam data for the animation when you stand in
; a puddle. Updated every 16 frames.
.define wPuddleAnimationPointer	$c4ba

; This might only be used for drawing objects' shadows, though in theory it
; could also be used to draw puddles and grass as objects walk over them.
; Each entry is 4 bytes: Y, X, and an address in the "Special_Animations"
; section (bank $14).
.define wTerrainEffectsBuffer	$c4c0

; A $40 byte buffer keeping track of which objects to draw, in what order
; (first = highest priority). Each entry is 2 bytes, consisting of the address
; of high byte of the object's y-position.
.define wObjectsToDraw	$c500

; ========================================================================================
; Everything from this point ($c5b0) up to $caff goes into the save data ($550 bytes).
; ========================================================================================

; Start of file data (same address as checksum)
.define wFileStart		$c5b0

.define wFileChecksum		$c5b0 ; 2 bytes

; This string is checked to verify the save data.
; Seasons: "Z11216-0"
; Ages:    "Z21216-0
; (8 bytes)
.define wSavefileString		$c5b2

; List of unappraised rings. each byte always seems to have bit 6 set, indicating that the
; ring is unappraised. It probably gets unset the moment you appraise it, but only for
; a moment because then it disappears from this list.
.define wUnappraisedRings	$c5c0 ; $40 bytes
.define wUnappraisedRingsEnd	$c600

; ========================================================================================
; C6xx block: deals largely with inventory, also global flags
; ========================================================================================

.define wC600Block $c600

; $c600-c615 treated as a block in at least one place (game link)

; 6 bytes, null terminated
.define wLinkName		$c602

; This is always 1. Used as a dummy value in various places?
.define wC608			$c608

.define wKidName		$c609
.define wC60f			$c60f

; $0b for ricky, $0c for dimitri, $0d for moosh (same as the SpecialObject id's for their
; corresponding objects)
.define wAnimalRegion		$c610

; Always $01?
.define wC611			$c611

; Copied to wIsLinkedGame
.define wFileIsLinkedGame	$c612
.define wFileIsHeroGame		$c613
.define wFileIsCompleted	$c614
; Remembers whether you've obtained the ring box.
; There's also a global flag for this, so its only purpose may be keeping track of it for
; linked games?
.define wObtainedRingBox	$c615
; 8 bytes ($c616-$c61d)
.define wRingsObtained		$c616
; 2-byte bcd number
.define wDeathCounter		$c61e
; Used for the Slayer's ring. 2 bytes.
.define wTotalEnemiesKilled	$c620
; 4 bytes
.define wPlaytimeCounter $c622
; Used for the sign ring.
.define wTotalSignsDestroyed $c626
; Used for the rupee ring. 2 bytes.
.define wTotalRupeesCollected $c627
.define wTextSpeed	$c629
.define wActiveLanguage $c62a ; Doesn't do anything on the US version

.enum $c62b

; $0c bytes
wDeathRespawnBuffer:	INSTANCEOF DeathRespawnStruct

.ende
; Ends at $c638

; Looks like a component is set to $10 or $70 if the animal enters from
; a particular side. Not sure what it's used for.
.define wLastAnimalMountPointY	$c638
.define wLastAnimalMountPointX	$c639

; Like wActiveGroup and wActiveRoom, but for the minimap. Not updated in caves.
.define wMinimapGroup $c63a
.define wMinimapRoom $c63b

.define wPortalGroup	$c63e
.define wPortalRoom	$c63f
.define wPortalPos	$c640
.define wMapleKillCounter $c641

; Lower 4 bits mark the items bought from the hidden shop
.define wHiddenShopItemsBought	$c642

; $c646 related to ricky sidequest?

; $c647 bit 6: relates to raft

; Bit 0 is set if you've harvested at least one gasha nut before. The first gasha nut
; always gives you a "class 1" ring (one of the weak, common ones).
; Bit 1 is set if you've obtained the heart piece from one of the gasha spots.
.define wGashaSpotFlags	$c64c
; 2 bytes (1 bit for each spot)
.define wGashaSpotsPlantedBitset $c64d
; 16 bytes (1 byte for each spot)
.define wGashaSpotKillCounters $c64f

; This is a counter which many things (digging, getting hearts, getting a gasha nut)
; increment or decrement. Not sure what it's used for, or if it's used at all.
; 16-bit value.
.define wC65f		$c65f

; 1 byte per dungeon. Each byte is a bitset of visited floors for a particular dungeon.
.define wDungeonVisitedFloors		$c662

; 1 byte per dungeon. Uses $10 bytes max
.define wDungeonSmallKeys	$c672

; Bitset of boss keys obtained
.define wDungeonBossKeys	$c682
; Bitset of compasses obtained
.define wDungeonCompasses	$c684
; Bitset of maps obtained
.define wDungeonMaps		$c686

.define wInventoryB	$c688
.define wInventoryA	$c689
; $10 bytes
.define wInventoryStorage	$c68a

.define wObtainedTreasureFlags	$c69a
; Ends at $c6a5
.define wSeedsAndHarpSongsObtained	$c69e

.define wLinkHealth	$c6aa
.define wLinkMaxHealth	$c6ab
.define wNumHeartPieces	$c6ac
.define wNumRupees	$c6ad

.define wShieldLevel		$c6af
.define wNumBombs		$c6b0
.define wMaxBombs		$c6b1
.define wSwordLevel		$c6b2
.define wNumBombchus		$c6b3
.define wSeedSatchelLevel	$c6b4 ; Determines satchel capacity
.define wFluteIcon		$c6b5 ; Determines icon + song, but not companion
.define wSwitchHookLevel	$c6b6
.define wSelectedHarpSong	$c6b7
.define wBraceletLevel		$c6b8
.define wNumEmberSeeds		$c6b9
.define wNumScentSeeds		$c6ba
.define wNumPegasusSeeds	$c6bb
.define wNumGaleSeeds		$c6bc
.define wNumMysterySeeds	$c6bd
.define wNumGashaSeeds		$c6be
.define wEssencesObtained	$c6bf
.define wTradeItem		$c6c0
.define wC6c1			$c6c1
.define wTuniNutState		$c6c2 ; 0: broken, 2: fixed (only within Link's inventory?)
.define wNumSlates		$c6c3 ; Slates used only in ages dungeon 8
.define wSatchelSelectedSeeds	$c6c4
.define wShooterSelectedSeeds	$c6c5
.define wRingBoxContents	$c6c6
.define wActiveRing		$c6cb ; When bit 6 is set, the ring is disabled?
.define wRingBoxLevel		$c6cc
.define wNumUnappraisedRingsBcd	$c6cd

.define wGlobalFlags 		$c6d0

.define wC6e0			$c6e0
.define wC6e1			$c6e1
.define wC6e2			$c6e2

.define wC6e6			$c6e6
.define wC6e7			$c6e7

; Keeps track of what the Maku Tree says when you talk to her.
.define wMakuTreeState		$c6e8

; This almost certainly does more than control the water level.
.define wJabuWaterLevel	$c6e9

.define wPirateShipRoom			$c6ec ; Low room index the pirate ship is in
.define wPirateShipY			$c6ed
.define wPirateShipX			$c6ee
.define wPirateShipAngle		$c6ef

.define wC6fb		$c6fb

; Flags shared for above water and underwater
.define wPresentRoomFlags $c700
.define wPastRoomFlags $c800

; Steal 6 of the past room flags for vine seed positions
.define wVinePositions $c8f0

.define wGroup4Flags	$c900
.define wGroup5Flags	$ca00

; ========================================================================================
; $cb00: END of data that goes into the save file
; ========================================================================================

.define wOam $cb00
.define wOamEnd $cba0

; Nonzero if text is being displayed.
; If $80, text has finished displaying while TEXTBOXFLAG_NONEXITABLE is set.
.define wTextIsActive	$cba0

; $00: standard text
; $01: selecting an option
; $02: inventory screen
.define wTextDisplayMode $cba1

; Note that the text index is incremented by $400 before being written here.
; This is due to there being 4 dictionaries. Within text routines, this
; 4-higher value is used.
.define wTextIndex	$cba2
.define wTextIndexL	$cba2
.define wTextIndexH	$cba3
.define wTextIndexH_backup $cba4

; Selected option in a textbox, ie. yes/no
.define wSelectedTextOption $cba5

; What color text should be as it's read from the retrieveTextCharacter
; function. Values 0-2 set the text to those respective colors, while a value
; of 3 tells it to read in 2bpp format instead.
.define wTextGfxColorIndex $cba6

; Where the tile map is for the text (always $98?)
.define wTextMapAddress	$cba7

; 2-byte BCD number that can be inserted into text.
.define wTextNumberSubstitution $cba8

; cbaa/ab are similar to wTextNumberSubstitution, but possibly unused?

; Value from 0-6 determining the position of the textbox.
.define wTextboxPosition $cbac

.define wTextboxFlags	$cbae

; $cbaf-cbb2; each byte is an index which can be used with text control code
; $F, when the parameter is $ff, $fe, $fd, or $fc. The text corresponding to
; the index is inserted into the textbox at that point.
.define wTextSubstitutions $cbaf

; Used for a variety of purposes
; cbb3-cbc2 are sometimes cleared togother

.define wTmpCbb3		$cbb3
 .define wFileSelectMode	wTmpCbb3

.define wTmpCbb4		$cbb4
 .define wFileSelectMode2	wTmpCbb4
; Used for:
; - Index of link's position on map
; - Index of an interaction?
.define wTmpCbb5		$cbb5
 ; Selection in submenus (seeds, harp)
 .define wItemSubmenuIndex	wTmpCbb5

; Used for:
; - Index of cursor on map
; - Something in menus
.define wTmpCbb6	$cbb6

.define wTmpCbb7		$cbb7
 ; $00 for link name input, $01 for kid name input, $82 for secret input for new file
 .define wTextInputMode		wTmpCbb7
 .define wInventorySelectedItem	wTmpCbb7

.define wTmpCbb8		$cbb8
 .define wTextInputMaxCursorPos	wTmpCbb8

.define wTmpCbb9		$cbb9
 .define wInventorySubmenu2CursorPos2 wTmpCbb9

.define wTmpCbba		$cbba
 .define wFileSelectFontXor	wTmpCbba

.define wTmpCbbb			$cbbb
 .define wFileSelectCursorOffset	wTmpCbbb
 .define wInventoryActiveText		wTmpCbbb

.define wTmpCbbc		$cbbc
 .define wFileSelectCursorPos	wTmpCbbc

.define wTmpCbbd		$cbbd
 .define wFileSelectCursorPos2	wTmpCbbd

.define wTmpCbbe		$cbbe
 .define wTextInputCursorPos	wTmpCbbe
 .define wItemSubmenuCounter	wTmpCbbe

.define wTmpCbbf		$cbbf
 .define wItemSubmenuMaxWidth	wTmpCbbf
 .define wFileSelectLinkTimer	wTmpCbbf

.define wItemSubmenuWidth	$cbc0

; When set to $01, Link will perform "simulated" input, ie. in the opening cutscene.
; When set to $02, input is normal except that the direction buttons are reversed.
; When set to $ff (bit 7 set), the "getSimulatedInput" function does not read any more
; inputs, and will always return the last input read.
.define wUseSimulatedInput	$cbc3

; 2 bytes
.define wSimulatedInputCounter	$cbc4

; $cbc6-$cbc8: 3-byte pointer
.define wSimulatedInputBank	$cbc6
.define wSimulatedInputAddressL	$cbc7
.define wSimulatedInputAddressH	$cbc8

.define wSimulatedInputValue	$cbc9

; Related to the switch hook?
.define wCbca		$cbca

; $01: inventory
; $02: map
; $03: save/quit menu
.define wOpenedMenuType		$cbcb

.define wMenuLoadState		$cbcc
.define wMenuActiveState	$cbcd
; State for item submenus (selecting seed satchel, shooter, or harp)
.define wItemSubmenuState	$cbce
; Value from 0-2, one for each submenu on the inventory screen
.define wInventorySubmenu	$cbcf

.define wInventorySubmenu0CursorPos	$cbd0
.define wInventorySubmenu1CursorPos	$cbd1
.define wInventorySubmenu2CursorPos	$cbd2

.ENUM $cbd5
	wGfxRegs4:	INSTANCEOF GfxRegsStruct	; $cbd5
	wGfxRegs5:	INSTANCEOF GfxRegsStruct	; $cbdb
.ENDE

; cbe1/2: screen scroll for menus?
; cbe3: palette header index for menus?

.define wDisplayedHearts	$cbe4
.define wDisplayedRupees	$cbe5 ; 2 bytes

; if nonzero, status bar doesn't get updated
.define wDontUpdateStatusBar	$cbe7

; Bit 7: whether status bar is reorganized for biggoron's sword maybe?
; Bit 0 set if status bar needs to be reorganized slightly for last row of hearts
.define wCbe8			$cbe8

; Bit 0: A/B buttons need refresh?
; Bit 1: A/B button item count needs refresh? (ie. seed count)
; Bit 2: heart display needs refresh
; Bit 3: rupee count needs reflesh
; Bit 4: small key count
.define wStatusBarNeedsRefresh	$cbe9


; The following "wBItem" and "wAItem" variables are loaded almost directly from the
; "treasureDisplayData" structure.

; This is the treasure index used to determine the item's level / ammo count.
; Usually this is either $00 or equal to [wInventoryB], but not always - the seed satchel
; sets this to a different value for each seed type, for instance.
.define wBItemTreasure		$cbea

.define wBItemSpriteAttribute1	$cbeb
.define wBItemSpriteAttribute2	$cbec
.define wBItemSpriteXOffset	$cbed
.define wBItemDisplayMode	$cbee ; Whether to display item level, ammo count, etc

; See wBItemTreasure.
.define wAItemTreasure		$cbef

.define wAItemSpriteAttribute1	$cbf0
.define wAItemSpriteAttribute2	$cbf1
.define wAItemSpriteXOffset	$cbf2
.define wAItemDisplayMode	$cbf3

.define wCc00Block	$cc00

; Value copied from low byte of wPlaytimeCounter
.define wFrameCounter	$cc00
.define wIsLinkedGame	$cc01
.define wMenuDisabled	$cc02

; $cc05:
;  bit 0: if set, prevents the room's object data from loading
;  bit 2: if set, prevents remembered Companions from loading
;  bit 3: if set, prevents Maple from loading

; An index for wLoadedNpcGfx. Keeps track of where to add the next thing to be
; loaded?
.define wLoadedNpcGfxIndex	$cc06

; This is a data structure related to used sprites. Each entry is 2 bytes, and
; corresponds to an npc gfx header loaded into vram at its corresponding
; position.
; Eg. Entry $cc08/09 is loaded at $8000, $cc0a/0b is loaded at $8200.
; Byte 0 is the index of the npc header (see npcGfxHeaders.s).
; Byte 1 is whether these graphics are currently in use?
.define wLoadedNpcGfx		$cc08
.define wLoadedNpcGfxEnd	$cc18

; This is the same structure as the above buffer, but only for trees.
.define wLoadedTreeGfxIndex	$cc18
.define wLoadedTreeGfxActive	$cc19

; These are uncompressed gfx header indices.
; They're used for loading graphics for certain items (sword, cane, switch hook,
; boomerang... not bombs, seeds).
.define wLoadedItemGraphic1	$cc1b
.define wLoadedItemGraphic2	$cc1c

; $cc1e: an interaction's id gets written here? Relates to wLoadedTreeGfxIndex?

; Point to respawn after falling in hole or w/e
.define wLinkLocalRespawnY	$cc21
.define wLinkLocalRespawnX	$cc22
.define wLinkLocalRespawnDir	$cc23

; These variables remember the location of your last mounted companion
; (ricky/dimitri/moosh or the raft; they overwrite each other)
.define wRememberedCompanionId			$cc24
.define wRememberedCompanionGroup		$cc25
.define wRememberedCompanionRoom		$cc26
.define wRememberedCompanionY			$cc27
.define wRememberedCompanionX			$cc28

; Dunno what the distinction is between these and wKeysPressed,
; wKeysJustPressed?
.define wGameKeysPressed			$cc29
.define wGameKeysJustPressed			$cc2a

; Same as w1Link.angle? Set to $FF when not moving. Should always be a multiple of
; 4 (since d-pad input doesn't allow more fine-grained angles)
.define wLinkAngle	$cc2b

; Usually $d0; set to $d1 while riding an animal, minecart
.define wLinkObjectIndex $cc2c

; Groups 0-5 are the normal groups.
; 6-7 are the same as 4-5, except they are considered sidescrolling rooms.
.define wActiveGroup	$cc2d

; $00 for normal-size rooms, $01 for large rooms
.define wRoomIsLarge	$cc2e

.define wLoadingRoom      $cc2f
.define wActiveRoom       $cc30
.define wRoomPack		$cc31

; Can have values from 00-02: incremented by 1 when underwater, and when map flag 0 is
; set.
; Also set to $00-$02 depending on the animal companion region.
; Used by interaction 0 for conditional interactions
.define wRoomStateModifier $cc32
; wActiveCollisions should be a value from 0-5.
; 0: overworld, 1: indoors, 2: dungeons, 3: sidescrolling, 4: underwater, 5?
.define wActiveCollisions $cc33
.define wAreaFlags	$cc34

; Don't know what the distinction for the 2 activeMusic's is
.define wActiveMusic     $cc35

; Change the color of the animation when objects walk in the grass. Unused in
; ages - it's meant to match the season.
; Valid values: $00 (green), $09 (blue), $1b (orange)
.define wGrassAnimationModifier	$cc36

; Used by the eye statue puzzle before the ganon/twinrova fight
.define wEyePuzzleCounter $cc37

; FF for overworld, other for mapped areas
.define wDungeonIndex $cc39

; Index on map for mapped areas (dungeons)
.define wDungeonMapPosition	$cc3a
; Index for w2DungeonLayout, possibly used for floors?
.define wDungeonFloor		$cc3b

.define wDungeonRoomProperties	$cc3c

; 8 bytes of dungeonData copied to here
.define wDungeonMapData		$cc3d

; The high byte of the dungeon flags (wGroup4Flags/wGroup5Flags)
.define wDungeonFlagsAddressH	$cc3d

; Warp destination index to use when a wallmaster grabs you
.define wDungeonWallmasterDestRoom	$cc3e

.define wDungeonFirstLayout	$cc3f ; Index of dungeon layout data for first floor
.define wDungeonNumFloors	$cc40
.define wDungeonMapBaseFloor	$cc41 ; Determines what the map will call the bottom floor (0 for "B3")
.define wMapFloorsUnlockedWithCompass	$cc42 ; Bitset of floors that are unlocked on the map with the compass
.define wDungeonData6	$cc43
.define wDungeonData7	$cc44

.define wLoadingRoomPack	$cc45

.define wActiveMusic2	$cc46


.define wWarpDestVariables $cc47
.define wWarpDestVariables.size $05

; Like wActiveGroup, except among other things, bit 7 can be set. Dunno what
; that means.
.define wWarpDestGroup	$cc47
.define wWarpDestIndex	$cc48 ; This first holds the warp destination index, then the room index.
.define wWarpTransition	$cc49
.define wWarpDestPos	$cc4a
.define wWarpTransition2	$cc4b

; wWarpTransition is the half-byte given in WarpDest or StandardWarp macros.
; wWarpTransition2 is set by code.
;
; Values for wWarpTransition2:
; 00: none
; 01: instant
; 03: fadeout

; 2 bytes.
.define wSeedTreeRefilledBitset	$cc4d

; When this is nonzero, Link's state (w1Link.state) is changed to this value.  Write $0b
; here (LINK_STATE_FORCE_MOVEMENT) to force him to move in a particular direction for
; [wLinkStateParameter] frames.
.define wLinkForceState $cc4f

; $cc50:
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
.define wLinkStateParameter  $cc51

; $cc52: Used by LINK_STATE_04 to remember a previous animation?

; This counts up each frame while Link is moving. When it reaches a certain value
; (depending on the level of the ring), Link regains a small amount of health.
; It is 3 bytes large, apparently (24-bit).
.define wHeartRingCounter	$cc53

; When nonzero, Link appears in his normal form even when wearing a transformation ring.
; It will count down to 0, at which time transformations will be re-enabled.
.define wDisableRingTransformations $cc56

; If nonzero, this overwrites "w1Link.id" at the start of the "updateSpecialObjects" func.
.define wLinkIDOverride		$cc57

; When nonzero in a sidescrolling area, the tile below Link is considered to be an ice
; tile until he is no longer on solid ground.
.define wForceIcePhysics	$cc58

.define wSwordDisabledCounter	$cc59

; Relates to whether Link is holding or trying to grab something.
; Bit 6 set when Link is grabbing, but not yet holding something?
; Some values:
;  $00 normally
;  $41 when grabbing something
;  $c2 when in the process of lifting something
;  $83 when holding something
.define wLinkGrabState		$cc5a

; bit 7: set when pulling a lever?
; bits 4-6: weight of object (0-4 or 0-5?). (See _itemWeights.)
; bits 0-3: should equal 0, 4, or 8; determines where the grabbed object is placed
;           relative to Link. (See "updateGrabbedObjectPosition".)
.define wLinkGrabState2		$cc5b

; cc5c-cce9 treated as a block

; Bit 7: lock link's movement direction, prevent jumping
; Bit 5: If set, Link's gravity is reduced
; Bit 1: set when link is jumping
; Bit 0: set when jumping down a cliff
; If nonzero, Link's knockback durations are halved.
.define wLinkInAir		$cc5c

; Bit 7 is set when Link dives underwater.
; Bit 6 causes Link to drown.
; Bits 0-3 hold a "state" which remembers whether Link is actually in the water, and
; whether he just entered or has been there for a few frames.
.define wLinkSwimmingState	$cc5d

; $cc5e: Makes Link get stuck in a "punching" / using item animation?
; If bit 6 is set, Link ignores holes.

; This is a bitset of special item objects ($d2-$d5) which are being used?
.define wLinkUsingItem1		$cc5f

; Bit 7: set when Link presses the A button next to an object (ie. npc)
; When this is nonzero, Link's facing direction is locked (ie. using a sword).
.define wLinkTurningDisabled	$cc60

; Set when link is using an item which immobilizes him. Each bit corresponds to
; a different item.
; Bit 4: Set when Link is falling down a hole
.define wLinkImmobilized	$cc61

; $cc63: set when link is holding a sword out?
; When bit 7 is set, item usage is disabled; when it equals $ff, Link is forced to do
; a sword spin. Maybe used when getting the sword in Seasons?

; This is equal to w1Link.direction when he's pushing something.
; When he's not pushing something, this equals $ff.
.define wLinkPushingDirection	$cc65

; $cc66: if $01, link always does a pushing animation; if bit 7 is set, he never does
.define wForceLinkPushAnimation	$cc66

; $cc68: set to $ff when link climbs certain ladders. Forces him to face
; upwards.
.define wLinkClimbingVine	$cc68

; This shifts the Y position at which link is drawn.
; Used by the raisable platforms in various dungeons.
; If nonzero, Link is allowed to walk on raised floors.
.define wLinkRaisedFloorOffset	$cc69

; Keeps track of how many frames Link has been pushing against a tile, ie. for push
; blocks, key doors, etc.
.define wPushingAgainstTileCounter	$cc6a

; While this is nonzero, Link cannot play the harp or his flute.
; This is set during screen transitions, after closing the menu, and in a bunch of other
; places. It ticks down each frame.
.define wInstrumentsDisabledCounter	$cc6b

; 2 bytes.
; Dust is created at Link's feet when bit 15 (bit 7 of the second byte) is set.
.define wPegasusSeedCounter	$cc6c

; Set while being grabbed by a wallmaster, grabbed by Veran spider form?
.define wWarpsDisabled		$cc6e

; Nonzero if link is using a shield. If he is, the value is equal to [wShieldLevel].
.define wUsingShield		$cc6f

; Offset from link's position, used for collision calculations
.define wShieldY		$cc70
.define wShieldX		$cc71

; $10 bytes (8 objects)
; List of pick-upable items. Used by shops, cane of somaria block.
; Each 2 bytes is a little-endian pointer to an object.
;
; When an object is grabbed:
; * state = 2
; * state2 = 0
; * enabled |= 2
.define wGrabbableObjectBuffer		$cc74
.define wGrabbableObjectBufferEnd	$cc84

.define wRoomEdgeY		$cc86
.define wRoomEdgeX		$cc87

; Related to whether a valid secret was entered?
.define wSecretInputResult	$cc89

; Bit 0 disables link.
; Bit 1 disables interactions.
; Bit 2 disables enemies.
; Bit 4 disables items.
; Bit 5 set when being shocked?
; Bit 7 disables link, items, enemies, not interactions.
.define wDisabledObjects		$cc8a

; Set when playing an instrument. Copied to wPlayingInstrument2?
.define wPlayingInstrument1	$cc8d

; After certain warps and when falling down holes, this variable is set to Link's
; position. When it is set, the warp on that tile does not function.
; This prevents Link from instantly activating a warp tile when he spawns in.
.define wEnteredWarpPosition	$cc8e

.define wNumTorchesLit $cc8f

; $cc91: if nonzero, screen transitions via diving don't work

; $cc92: Bit 7 set when over a hole, first entering water, dismounting raft,
;              knockback when on raft...
;        Bit 3 set when moving on a raft (allows screen transitions over water)
;        Bit 2 set on conveyors?

; Affects how much the screen shakes when the "wScreenShakeCounter" variables are set.
; 0: 1-2 pixels
; 1: 1 pixel
; 2: 3 pixels
.define wScreenShakeMagnitude	$cc94

; $cc95: something to do with items being used (like wLinkUsingItem1, 2)
; If bit 7 is set, link can't move or use items.

; If nonzero, Link is basically invincible. Copied from wPlayingInstrument1?
.define wPlayingInstrument2	$cc96

; $cc98: relates to switch hook

; The tile Link is standing on
.define wActiveTilePos   $cc99
.define wActiveTileIndex $cc9a

; This counter is used for certain tile types to help implement their behaviours.
; Ie. cracked floors use this as a counter until the floor breaks.
.define wStandingOnTileCounter	$cc9b

; Different values for grass, stairs, water, etc
.define wActiveTileType		$cc9c

; In top-down sections, this seems to remember the tile that Link stood on last frame.
; In sidescroll sections, however, this keeps track of the tile underneath Link instead.
.define wLastActiveTileType	$cc9d

; Bit 6 is set if Link is on a slippery tile.
.define wIsTileSlippery	$cc9e

; Position of chest link is standing on ($00 doesn't count)
.define wLinkOnChest	$cc9f

; Keeps track of which switches are set (buttons on the floor)
.define wActiveTriggers $cca0

; $cca1-$cca2: Changes behaviour of chests in shops? (For the chest game probably)

; 2 bytes. When set, this overrides the contents of a chest. Probably used in the chest
; minigame?
.define wChestContentsOverride	$cca3

; $cca9: relates to ganon/twinrova fight somehow
; $ccab: used for pulling levers?

; Color of the rotating cube (0-2)
; Bit 7 gets set when the torches are lit
.define wRotatingCubeColor   $ccad
.define wRotatingCubePos     $ccae

; $ccaf: tile index being poked or slashed at?
; $ccb0: tile position being poken or slashed at?

; Not sure what purpose this is for
.define wDisableWarps	$ccb2

; List of objects which react to A button presses. Each entry is a pointer to
; their corresponding "Object.pressedAButton" variable.
.define wAButtonSensitiveObjectList	$ccb3
.define wAButtonSensitiveObjectListEnd	wAButtonSensitiveObjectList+$20

; Set when in a shop, prevents Link from using items
.define wInShop		$ccd3

; $ccd4 seems to be used for multiple purposes.
; One of them is as a counter for how many frames you've pushed against the bed in Nayru's
; house. Once it reaches 90, Link jumps in.
.define wLinkPushingAgainstBedCounter $ccd4

; Keeps track of whether certain informative texts have been shown.
; ie. "This block has cracks in it" when pushing against a cracked block.
; This is also used to prevent Link from jumping into the bed in Nayru's house more than
; once.
.define wInformativeTextsShown	$ccd7

; $ccd8: if nonzero, link can't use his sword. Relates to dimitri?

.define wIsSeedShooterInUse	$ccda ; Set when there is a seed shooter seed on-screen
.define wIsLinkBeingShocked	$ccdb
.define wLinkShockCounter	$ccdc
.define wSwitchHookState	$ccdd ; Used when swapping with the switch hook

; Indices for w2ChangedTileQueue
.define wChangedTileQueueHead	$ccdf
.define wChangedTileQueueTail	$cce0

; Indices for w2AnimationQueue
.define wAnimationQueueHead	$cce4
.define wAnimationQueueTail	$cce5

; Used for the "FollowingLinkObject" to remember the position in the "w2LinkWalkPath"
; buffer.
.define wLinkPathIndex			$cce6

.define wFollowingLinkObjectType	$cce7
.define wFollowingLinkObject		$cce8

; This might be a marker for the end of data in the $cc00 block?
.define wCCE9			$cce9

; Next $30 bytes are treated as a unit in a certain place
.define wScreenVariables $cd00
.define wScreenVariables.size $30

; Equals 1 under most normal circumstances
; Equals 8 while doing a normal screen transition
; When set to 0, scrolling stops in big areas.
; Bit 0 disables animations when unset, among other things apparently.
; When bit 1 is set link can't move.
; Bit 2 is set when link is doing a walk-out-of-screen transition.
; Bit 7 is set while the screen is scrolling or text is on the screen
.define wScrollMode $cd00

; $cd01: 0 for large rooms, 1 for small rooms?
; See constants/directions.s for what the directions are.
; Set bit 7 to force a transition to occur.
.define wScreenTransitionDirection $cd02

.define wScreenTransitionState	$cd04
.define wScreenTransitionState2	$cd05
.define wScreenTransitionState3	$cd06

; These are used when the screen scrolls and the room is no longer drawn starting at
; position (0,0).
; They're probably also used when the screen shakes back and forth.
.define wScreenOffsetY	$cd08
.define wScreenOffsetX	$cd09

; Room dimensions measured in 8x8 tiles
.define wRoomWidth		$cd0a
.define wRoomHeight		$cd0b

; These determine where Link needs to walk to to start a screen transition.
; Similar to wRoomEdgeY/X, but used for different things.
.define wScreenTransitionBoundaryX		$cd0c ; Rightmost boundary
.define wScreenTransitionBoundaryY		$cd0d ; Bottom-most boundary

; Max values for hCameraY/X
.define wMaxCameraY	$cd0e
.define wMaxCameraX	$cd0f

; $cd0d, cd0f: Y positions of something?

; 2 bytes; keeps track of which "entry"
; Shared memory with the variables below; 
.define wUniqueGfxHeaderAddress		$cd10

; Keeps track of the row (or column) of tiles being drawn while scrolling the screen.
; A value of "0" is the top or left of the room.
.define wScreenScrollRow		$cd10
; The corresponding row (or column) to draw to in vram.
.define wScreenScrollVramRow		$cd11

; This is either $01 or $ff, corresponding to right/down or left/up.
.define wScreenScrollDirection		$cd12

; Decremented once per row (or column). The transition finishes when this reaches 0.
; (This is used in a few other contexts, but the above is most significant.)
.define wScreenScrollCounter		$cd13

; $cd14: Value to add to SCY/SCX every frame?

; When nonzero, this forces Link to walk against the screen edge for this many frames
; before the screen transition starts.
; Jumping sets this to $04.
.define wScreenTransitionDelay		$cd15

.define wCameraFocusedObjectType	$cd16
.define wCameraFocusedObject		$cd17

.define wScreenShakeCounterY	$cd18
.define wScreenShakeCounterX	$cd19

; This is set when calling "objectCheckIsOverPit".
.define wObjectTileIndex	$cd1f

.define wAreaUniqueGfx	$cd20
.define wAreaGfx	$cd21
.define wAreaPalette	$cd22
.define wAreaTileset	$cd23
.define wAreaLayoutGroup $cd24
.define wAreaAnimation	$cd25

.define wLoadedAreaUniqueGfx	$cd28
.define wLoadedAreaPalette	$cd29
.define wLoadedAreaTileset	$cd2a
.define wLoadedAreaAnimation	$cd2b

; Bits 0-3 determine whether to use animation data 1-4
; When bit 7 is set, all animations are forced to be updated regardless of
; counters.
; Bit 6 also does something
.define wAnimationState		$cd30

.define wAnimationCounter1	$cd31
.define wAnimationPointer1	$cd32
.define wAnimationCounter2	$cd34
.define wAnimationPointer2	$cd35
.define wAnimationCounter3	$cd37
.define wAnimationPointer3	$cd38
.define wAnimationCounter4	$cd3a
.define wAnimationPointer4	$cd3b

; Used temporarily for vram transfers, dma, etc.
.define wTmpVramBuffer		$cd40

.define wStaticObjects		$cd80
.define wStaticObjects.size	$40

; Number of enemies on the screen. When this reaches 0, certain events trigger. Not all
; enemies count for this.
.define wNumEnemies $cdd1

; State of the blocks that are toggled by the orbs
.define wToggleBlocksState	$cdd2

; Each bit keeps track of whether a certain switch has been hit.
; Persists between rooms?
.define wSwitchState $cdd3

; Write anything here to make link die
.define wLinkDeathTrigger	$cdd5
; Write anything here to open the Game Over screen
.define wGameOverScreenTrigger	$cdd6

; Nonzero while maple is on the screen.
.define wIsMaplePresent		$cdda

; This is set to Link's position (plus 1 so 0 is a special value) when he goes through time.
; When set, breakable tiles like bushes will be deleted so that Link doesn't get caught in
; an infinite time loop.
; When set, there will NOT be a time portal created where Link warps in. So, this is set
; in the following situations:
; - Tune of Echoes warp is entered
; - A temporary warp created by the Tune of Current/Ages is entered
; - Link is forced back when he attempts to warp into a wall or something
; It is NOT set when he plays the Tune of Currents/Ages.
.define wLinkTimeWarpTile	$cddc

; When set to $01, Link gets "sent back by a strange force" during a time warp.
.define wSentBackByStrangeForce	$cdde

; Position value, similar to wLinkTimeWarpTile?
.define wcddf			$cddf

.define wcde0			$cde0

; The pirate ship's YX value is written here when it changes tiles (when its X and
; Y position values are each centered on a tile).
.define wPirateShipChangedTile	$cde1

; $cde3-4: Temporary copies of wcde3?

.define wRoomCollisions		$ce00
.define wRoomCollisionsEnd	$ceb0

.define wTmpCec0 $cec0
.define wTmpNumEnemies $cec1
.define wTmpEnemyPos $cec2

.define wRandomEnemyPlacementAttemptCounter	$cecf

.define wRoomLayout	$cf00
.define wRoomLayoutEnd	$cfb0

; Used in the cutscene after jabu as a sort of cutscene state thing?
; Also used by scripts, possibly just as a scratch variable?
; Also, bit 0 is set whenever a keyhole in the overworld is opened. This triggers the
; corresponding cutscene (which appears to be dependent on the room you're in).
.define wCFC0		$cfc0
; Another cutscene thing?
.define wCFC1		$cfc1

.define wCFD0		$cfd0

; 8 byte buffer of some kind
; Used in events triggered by stuff falling down holes
.define wCFD8		$cfd8
; cfde: used to check how many guys have been talked to in the intro on the nayru screen?

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

w2Unknown2:			dsb $80	; $d800

w2Filler7:			dsb $80

; Tree refill data also used for child and an event in room $2f7
w2SeedTreeRefillData:		dsb $080 ; $d900

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

w4TileMap:		dsb $240	; $d000-$d240
w4StatusBarTileMap:	dsb $40		; $d240
w4PaletteData:		dsb $40		; $d280
w4Filler3:		dsb $40
w4SavedOam:		dsb $a0		; $d300
w4TmpRingBuffer		dsb NUM_RINGS		; $d3a0
w4Unknown1:		dsb $20		; $d3e0

w4AttributeMap:		dsb $240	; $d400-$d640
w4StatusBarAttributeMap:	dsb $40		; $d640

; Icon graphics for the two equipped items
w4ItemIconGfx:		dsb $80		; $d680

w4Filler5:		dsb $80

w4FileDisplayVariables:		INSTANCEOF FileDisplayStruct 3	; $d780

w4Filler7:		dsb 8

w4NameBuffer:		dsb 6		; $d7a0
w4Filler6:		dsb $1a
w4SecretBuffer:		dsb $20		; $d7c0
w4Filler8:		dsb $20

w4SavedVramTiles:	dsb $180	; $d800

w4Filler1:		dsb $280
w4GfxBuf1:		dsb $200	; $dc00
w4GfxBuf2:		dsb $200	; $de00

.ENDS

; ========================================================================================
; Bank 5
; ========================================================================================

.RAMSECTION "Ram 5" BANK 5 SLOT 3

w5NameEntryCharacterGfx:	dsb $100	; $d000

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
