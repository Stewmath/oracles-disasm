.STRUCT GfxRegs
	LCDC	db
	SCY	db
	SCX	db
	WINY	db
	WINX	db
	LYC	db
.ENDST
.define GfxRegs.size 6

.STRUCT DeathRespawnBuffer
	group		db
	room		db
	stateModifier	db
	facingDir	db
	y		db
	x		db
	cc24		db
	cc25		db
	cc26		db
	linkObjectIndex	db
	cc27		db
	cc28		db
.ENDST
.define DeathRespawnBuffer.size $0c

.define wMusicReadFunction $c000

; Used within the music playing functions
.define wLoadingSoundBank $c017
; Initially used as the index of the sound to play
.define wSoundChannel $c018
.define wSoundChannelValue $c019
.define wSoundChannel2 $c01a

.define wSoundCmd	$c01d
; This value goes straight to NR12/NR22
; In some situations it is also used to mark whether to reset / use the counter
; for the channel
.define wSoundCmdEnvelope $c01e

.define wSoundFrequencyL $c01f
.define wSoundFrequencyH $c020

; This value goes straight to NR50.
; Bits 0-2: left speaker, 4-6: right speaker (unless I mixed them up)
.define wSoundVolume	$c024

; An offset for wSoundFrequencyL,H
.define wC033 $c033

.define wC039 $c039
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

.define wPaletteFadeCounter $c2ff

; General purpose $100 byte buffer (used for scripts, underwater waves maybe?)
.define wBigBuffer	$c300

; Dunno how big this buffer is
.define wVBlankFunctionQueue	$c400

.ENUM $c480
	wKeysPressedLastFrame: 	db ; c480
	wKeysPressed: 		db ; c481
	wKeysJustPressed: 	db ; c482
	wAutoFireKeysPressed: 	db ; c483
	wAutoFireCounter: 	db ; c484

; Note: wGfxRegs2 and wGfxRegs3 can't cross pages (say, c2xx->c3xx)
	wGfxRegs1:	INSTANCEOF GfxRegs	; $c485
	wGfxRegs2:	INSTANCEOF GfxRegs	; $c48b
	wGfxRegs3:	INSTANCEOF GfxRegs	; $c491
	wGfxRegsFinal:	INSTANCEOF GfxRegs	; $c497
.ENDE
; Enum end at $c49d

; Used by vblank wait loop
.define wVBlankChecker	$c49d

; There may be yet another GfxRegs at c4a5

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

; This is just a jp opcode afaik
.define wRamFunction	$c4b7

; A $40 byte buffer keeping track of which objects to draw, in what order
; (first = highest priority). Each entry is 2 bytes, consisting of the address
; of high byte of the object's y-position.
.define wObjectsToDraw	$c500

; $40 bytes
.define wUnappraisedRings	$c5c0

; ==========================================================================================
; C6xx block: deals largely with inventory, also global flags
; ==========================================================================================

; 6 bytes, null terminated
.define wLinkName		$c602
; $c608 ?
.define wKidName		$c609
; $c60f ?

.define wAnimalRegion		$c610
; Copied to wIsLinkedGame
.define wFileIsLinkedGame	$c612

; 8 bytes
.define wRingsObtained		$c616

; 4 bytes
.define wPlaytimeCounter $c622

.define wTextSpeed	$c629
.define wActiveLanguage $c62a ; Doesn't do anything on the US version

.enum $c62b

; $0c bytes
wDeathRespawnBuffer:	INSTANCEOF DeathRespawnBuffer

.ende
; Ends at $c638

; Looks like a component is set to $10 or $70 if the animal enters from
; a particular side.
.define wAnimalEntryY	$c638
.define wAnimalEntryX	$c639

; Like wActiveGroup and wActiveRoom, but for the minimap. Not updated in caves.
.define wVirtualGroup $c63a
.define wVirtualRoom $c63b

.define wPortalGroup	$c63e
.define wPortalRoom	$c63f
.define wPortalPos	$c640

; Lower 4 bits mark the items bought from the hidden shop
.define wHiddenShopItemsBought	$c642

; Global flags (like for ricky sidequest) around $c640
; At least I know $c646 is a global flag

; C662 and onwards are bitsets representing visited dungeon floors or something?
.define wC662		$c662

.define wNumSmallKeys	$c675

; Bitset of compasses obtained?
.define wCompassFlags		$c684

.define wInventoryB	$c688
.define wInventoryA	$c689
; $10 bytes
.define wInventoryStorage	$c68a

; Consider renaming to secondaryItemsObtained or something
.define wQuestItemFlags	$c69a
; Ends at $c6a5
.define wSeedsObtained	$c69e

.define wLinkHealth	$c6aa
.define wLinkNumHearts	$c6ab
.define wNumHeartPieces	$c6ac
.define wNumRupees	$c6ad

.define wSwordLevel	$c6af
.define wNumBombs	$c6b0

.define wShieldLevel		$c6b2
.define wNumBombchus		$c6b3
.define wFluteIcon		$c6b5
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

.define wSatchelSelectedSeeds	$c6c4
.define wShooterSelectedSeeds	$c6c5
.define wRingBoxContents	$c6c6
.define wActiveRing		$c6cb
.define wRingBoxLevel		$c6cc
.define wNumUnappraisedRingsBcd	$c6cd

.define wGlobalFlags $c6d0

; This almost certainly does more than control the water level.
.define wJabuWaterLevel	$c6e9

.define wC6ed	$c6ed

; Flags shared for above water and underwater
.define wPresentRoomFlags $c700
.define wPastRoomFlags $c800

; Steal 6 of the past room flags for vine seed positions
.define wVinePositions $c8f0

.define wGroup4Flags	$c900
.define wGroup5Flags	$ca00

.define wOam $cb00
.define wOamEnd $cba0

; Nonzero if text is being displayed.
; If $80, text has finished displaying while TEXTBOXFLAG_NONEXITABLE is set.
.define wTextIsActive	$cba0

.define wTextIndex	$cba2
.define wTextIndex_l	$cba2
.define wTextIndex_h	$cba3

.define wTextboxFlags	$cbae

; Used for a variety of purposes
.define wTmpCbb3		$cbb3
 .define wFileSelectMode	wTmpCbb3

.define wTmpCbb4		$cbb4
 .define wFileSelectMode2	wTmpCbb4
; Used for:
; - Index of link's position on map
; - Selection in submenus (seeds)
; - Index of an interaction?
.define wTmpCbb5	$cbb5

; Used for:
; - Index of cursor on map
; - Something in menus
.define wTmpCbb6	$cbb6

.define wTmpCbbb			$cbbb
 .define wFileSelectCursorOffset	wTmpCbbb

.define wTmpCbbc		$cbbc
 .define wFileSelectCursorPos	wTmpCbbc

.define wTmpCbbd		$cbbd
 .define wFileSelectCursorPos2	wTmpCbbd

.define wCbca		$cbca
.define wCbcb		$cbcb
.define wCbcc		$cbcc

.ENUM $cbd5
	wGfxRegs4:	INSTANCEOF GfxRegs	; $cbd5
	wGfxRegs5:	INSTANCEOF GfxRegs	; $cbdb
.ENDE

.define wDisplayedHearts	$cbe4
.define wDisplayedRupees	$cbe5 ; 2 bytes
.define wStatusBarNeedsRefresh	$cbe9

; cc08-cc17 - some kind of data structure related to used sprites?
; 43 - weird old man
; 44 - zora
; 78 - gale seed
; 8f = octorok
; 90 = moblin

; Value copied from low byte of wPlaytimeCounter
.define wFrameCounter	$cc00
.define wIsLinkedGame	$cc01
.define wMenuDisabled	$cc02

; $cca9: relates to ganon/twinrova fight somehow

; Point to respawn after falling in hole or w/e
.define wLinkLocalRespawnY	$cc21
.define wLinkLocalRespawnX	$cc22
.define wLinkLocalRespawnDir	$cc23
.define wCc24			$cc24
.define wCc25			$cc25
.define wCc26			$cc26
.define wCc27			$cc27
.define wCc28			$cc28

; Always $d0?
.define wLinkObjectIndex $cc2c

.define wActiveGroup     $cc2d
.define wLoadingRoom      $cc2f
.define wActiveRoom       $cc30
.define wRoomPack		$cc31
; Can have values from 00-02: incremented by 1 when underwater, and when map flag 0 is set
; Used by interaction 0 for conditional interactions
.define wRoomStateModifier $cc32
; wActiveCollisions should be a value from 0-5.
; 0: overworld, 1: indoors, 2: dungeons, 3: sidescrolling, 4: underwater, 5?
.define wActiveCollisions $cc33
.define wAreaFlags	$cc34

; Don't know what the distinction for the 2 activeMusic's is
.define wActiveMusic     $cc35

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

.define wDungeonMinimapSomething $cc3d
.define wDungeonDatacc3e	$cc3e
; Index of dungeon layout data for first floor
.define wDungeonFirstLayout	$cc3f
.define wDungeonNumFloors	$cc40
.define wCc41	$cc41
.define wCc42	$cc42

.define wLoadingRoomPack	$cc45

.define wActiveMusic2	$cc46


.define wWarpDestVariables $cc47
.define wWarpDestVariables.size $05

; Like wActiveGroup, except among other things, bit 7 can be set. Dunno what
; that means.
.define wWarpDestGroup	$cc47
.define wWarpDestIndex	$cc48
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
; Bit 0 must be set to receive treasure from a goron in the mountains.
.define wUnknownBitset	$cc4d

; Write $0b to here to force link to continue moving
.define wForceMovementTrigger $cc4f
; Write the number of pixels link should move into here
.define wForceMovementLength  $cc51


.define wSwordDisabledCounter	$cc59

.define wCc5a	$cc5a

; cc5c-cce9 treated as a block

; Bit 7: lock link's movement direction
; Bit 0: set when jumping down a cliff
.define wLinkControl		$cc5c

; 2 bytes
.define wPegasusSeedCounter	$cc6c
; Not sure what uses this or what its Deeper Meaning is
.define wWarpsDisabled		$cc6e

; TODO: look into what different values for this.
; $01 and $80 both freeze him in place.
; $02 disables interactions.
.define wLinkCantMove		$cc8a

.define wUnknownPosition	$cc8e

.define wNumTorchesLit $cc8f

; The tile Link is standing on
.define wActiveTilePos   $cc99
.define wActiveTileIndex $cc9a

; Different values for grass, stairs, water, etc
.define wActiveTileType		$cc9c
.define wLastActiveTileType	$cc9d

; Position of chest link is standing on ($00 doesn't count)
.define wLinkOnChest	$cc9f

; Keeps track of which switches are set (buttons on the floor)
.define wActiveTriggers $cca0

; Color of the rotating cube (0-2)
; Bit 7 gets set when the torches are lit
.define wRotatingCubeColor   $ccad
.define wRotatingCubePos     $ccae

; Not sure what purpose this is for
.define wDisableWarps	$ccb2

; List of objects which react to A button presses. Each entry is a pointer to
; the object's ABUTTONPRESSED variable.
.define wAButtonSensitiveObjectList	$ccb3
.define wAButtonSensitiveObjectListEnd	wAButtonSensitiveObjectList+$20

.define wCcd3		$ccd3

.define wIsLinkBeingShocked	$ccdb
.define wLinkShockCounter	$ccdc

; Indices for w2AnimationQueue
.define wAnimationQueueHead	$cce4
.define wAnimationQueueTail	$cce5

; cce7: object type, cce8: object index

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

.define wDirectionEnteredFrom $cd02

; $cd0d, cd0f: Y positions of something?

.define wCameraFocusedObjectType	$cd16
.define wCameraFocusedObject		$cd17

.define wScreenShakeCounterY $cd18
.define wScreenShakeCounterX $cd19

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

; cd40, cd60 used for certain dma transfers

; $cd80-$cdff treated as a unit, a function clears this memory area
.define wCd80Variables		$cd80
.define wCd80Variables.size	$40

.define wNumEnemies $cdd1

; State of the blocks that are toggled by the orbs
.define wToggleBlocksState	$cdd2

; Each bit keeps track of whether a certain switch has been hit
; Persists between rooms?
.define wSwitchState $cdd3

; Write anything to here to make link die
.define wLinkDeathTrigger	$cdd5

; Link's position (plus 1 so 0 is a special value) when he gets sent back from
; an attempt to travel through time. When set, breakable tiles like bushes will
; be deleted so that Link doesn't get caught in an infinite time loop.
.define wLinkTimeWarpTile	$cddc


.define wRoomCollisions	$ce00

.define wTmpNumEnemies $cec1
.define wTmpEnemyPos $cec2

.define wRoomLayout	$cf00
.define wRoomLayoutEnd	$cfb0

; Used in the cutscene after jabu as a sort of cutscene state thing?
; Also used by scripts, possibly just as a scratch variable?
.define wCFC0		$cfc0
; Another cutscene thing?
.define wCFC1		$cfc1

; 8 byte buffer of some kind
; Used in events triggered by stuff falling down holes
.define wCFD8		$cfd8

; Bank 1: objects

.define w1LinkEnabled	$d000
.define w1LinkState	$d004
.define w1LinkFacingDir	$d008
.define w1LinkYH	$d00b
.define w1LinkXH	$d00d
.define w1LinkZH	$d00f
.define w1LinkInvincibilityCounter $d02b

; There's another link (or something) sometimes in the $d1 slot?

.define w1Link2Enabled	$d100
.define w1Link2State	$d104
.define w1Link2FacingDir	$d108
.define w1Link2YH	$d10b
.define w1Link2XH	$d10d
.define w1Link2ZH	$d10f
.define w1Link2InvincibilityCounter $d12b


.define LINK_OBJECT_INDEX	$d0
.define LINK_OBJECT_INDEX_2	$d1
.define FIRST_INTERACTION_INDEX	$d2
.define FIRST_ITEM_INDEX	$d6
.define FIRST_ENEMY_INDEX	$d0
.define FIRST_PART_INDEX	$d0


; Bank 2: used for palettes & other things

.RAMSECTION "RAM 2" BANK 2 SLOT 2+2

w2Filler1:			dsb $0800

w2Unknown2:			dsb $80	; $d800

w2Filler7:			dsb $80

w2Unknown3:			dsb $080 ; $d900
w2Unknown1:			dsb $010 ; $d980

w2Filler6:			dsb $70

w2ColorComponentBuffer1:	dsb $090 ; $da00
w2Unknown5: 			dsb $070 ; $da90
w2ColorComponentBuffer2:	dsb $090 ; $db00

w2AnimationQueue:		dsb $20	; $db90

w2Filler4:			dsb $50

; Though it's only $40 bytes large, dc40 and onward may represent other
; layouts?
w2DungeonLayout:	dsb $100	; $dc00

w2Filler2: dsb $0180

w2AreaBgPalettes:	dsb $40		; $de80
w2AreaSprPalettes:	dsb $40		; $dec0
w2BgPalettesBuffer:	dsb $40		; $df00
w2SprPalettesBuffer:	dsb $40		; $df40

w2Filler5: dsb $3e

w2Dfbe:			db	; $dfbe
w2Dfbf:			db	; $dfbf

.ENDS

; Bank 3: tileset data
;
.RAMSECTION "RAM 3" BANK 3 SLOT 3+2

; 8 bytes per tile: 4 for tile indices, 4 for tile attributes
w3TileMappingData:	dsb $800	; $d000

; Room tiles in a format which can be written straight to vram. Each row is $20
; bytes.
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

; Bank 7: used for text

.define w7TextTableAddr $d0f0
.define w7TextTableBank $d0f2


; Interaction variables (objects in dx40-dx7f)
.define INTERAC_ENABLED		$40
.define INTERAC_ID		$41
.define INTERAC_SUBID		$42
.define INTERAC_43		$43
.define INTERAC_STATE		$44
.define INTERAC_STATE_2		$45

; Maybe not specifically for checkabutton? checkabutton doesn't work until
; these variables count down to zero.
.define INTERAC_COUNTER1	$46
.define INTERAC_COUNTER2	$47

.define INTERAC_DIRECTION	$48
.define INTERAC_MOVINGDIRECTION	$49
.define INTERAC_Y		$4a
.define INTERAC_YH		$4b
.define INTERAC_X		$4c
.define INTERAC_XH		$4d
.define INTERAC_Z		$4e
.define INTERAC_ZH		$4f
.define INTERAC_SPEED		$50
.define INTERAC_SPEED_Z		$54
.define INTERAC_RELATEDOBJ	$56
.define INTERAC_SCRIPTPTR	$58
.define INTERAC_VISIBLE		$5a
.define INTERAC_5B		$5b
.define INTERAC_5E		$5e
.define INTERAC_ANIMCOUNTER	$60
.define INTERAC_61		$61
.define INTERAC_ANIMPOINTER	$62
.define INTERAC_COLLIDERADIUSY	$66
.define INTERAC_COLLIDERADIUSX	$67

; $70 used by showText; if nonzero, INTERAC_TEXTID replaces whatever upper byte you use in a showText opcode.
.define INTERAC_USETEXTID	$70
; $70 might have a second purpose?
.define INTERAC_70		$70

.define INTERAC_PRESSEDABUTTON	$71
; $71 might have a second purpose?
.define INTERAC_71		$71

; 2 bytes
.define INTERAC_TEXTID		$72

.define INTERAC_72		$72
.define INTERAC_73		$73
.define INTERAC_74		$74
.define INTERAC_SCRIPT_RET	$75
.define INTERAC_75		$75
.define INTERAC_76		$76
.define INTERAC_77		$77
.define INTERAC_78		$78
.define INTERAC_79		$79
.define INTERAC_7a		$7a
.define INTERAC_7b		$7b
.define INTERAC_7c		$7c
.define INTERAC_7d		$7d
.define INTERAC_7e		$7e
.define INTERAC_7f		$7f

; Enemy variables (objects in dx80-dxbf)
.define ENEMY_ENABLED		$80
.define ENEMY_ID		$81
.define ENEMY_SUBID		$82
.define ENEMY_STATE		$84
.define ENEMY_COUNTER1		$86
.define ENEMY_DIRECTION		$88
.define ENEMY_Y			$8a
.define ENEMY_YH		$8b
.define ENEMY_X			$8c
.define ENEMY_XH		$8d
.define ENEMY_Z			$8e
.define ENEMY_ZH		$8f
.define ENEMY_SPEED_Z		$94
.define ENEMY_RELATEDOBJ1	$96
.define ENEMY_RELATEDOBJ2	$98
.define ENEMY_VISIBLE		$9a ; More than just visibility
.define ENEMY_ANIMCOUNTER	$a0
; A4 - used by pumpkin head, at least, when the ghost dies
; A5 - collision properties? determines whether you'll get damaged?
.define ENEMY_COLLIDERADIUSY	$a6
.define ENEMY_COLLIDERADIUSX	$a7
.define ENEMY_DAMAGE		$a8
.define ENEMY_HEALTH		$a9
.define ENEMY_FROZEN_TIMER	$ae


; Part variables (objects in dxc0-dxff)
.define PART_ENABLED		$c0
.define PART_ID			$c1
.define PART_STATE		$c4
.define PART_DIRECTION		$c9
.define PART_Y			$ca
.define PART_YH			$cb
.define PART_X			$cc
.define PART_XH			$cd
.define PART_Z			$ce
.define PART_ZH			$cf
.define PART_ANIMCOUNTER	$e0
.define PART_ANIMPOINTER	$e2
.define PART_RELATEDOBJ1	$d6
.define PART_RELATEDOBJ2	$d8
.define PART_DAMAGE		$e8

; General definitions for objects
.define OBJ_ENABLED		$00
.define OBJ_ID			$01
.define OBJ_SUBID		$02
.define OBJ_STATE		$04
.define OBJ_STATE_2		$05
.define OBJ_COUNTER1		$06
.define OBJ_COUNTER2		$07
.define OBJ_DIRECTION		$08
.define OBJ_MOVINGDIRECTION	$09
.define OBJ_Y			$0a
.define OBJ_YH			$0b
.define OBJ_X			$0c
.define OBJ_XH			$0d
.define OBJ_Z			$0e
.define OBJ_ZH			$0f
.define OBJ_SPEED		$10
.define OBJ_SPEED_TMP		$11
.define OBJ_12			$12
.define OBJ_SPEED_Z		$14
.define OBJ_RELATEDOBJ1		$16
.define OBJ_RELATEDOBJ2		$18
; Bit 7 of OBJ_VISIBLE tells if it's visible, bits 0-1 determine its priority,
; bit 6 appears to do something also
.define OBJ_VISIBLE		$1a

.define OBJ_ANIMCOUNTER		$20
.define OBJ_ANIMPOINTER		$22
.define OBJ_COLLIDERADIUSY	$26
.define OBJ_COLLIDERADIUSX	$27
.define OBJ_DAMAGE		$28
.define OBJ_HEALTH		$29
.define OBJ_35			$35
.define OBJ_36			$36

; Link-specific variables

; Used as a counter for harp warps, and is 1 when link is doing
; a walk-off-screen transition
.define LINK_WARP_VAR		$05
.define LINK_WARP_VAR_2		$06
.define LINK_2B			$2b
.define LINK_2D			$2d
.define LINK_ANIM_MODE		$30
