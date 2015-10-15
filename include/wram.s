.STRUCT GfxRegs
	LCDC	db
	SCY	db
	SCX	db
	WINY	db
	WINX	db
	LYC	db
.ENDST
.define GfxRegs.size 6


.define wStackTop $c110

; $20 byte buffer?
.define wC2e0 $c2e0

.define wPaletteFadeCounter $c2ff

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
.define wPaletteFadeState $c4ae
.define wPaletteFadeBG1  $c4b1
.define wPaletteFadeSP1  $c4b2
.define wPaletteFadeBG2  $c4b3
.define wPaletteFadeSP2  $c4b4

; This is just a jp opcode afaik
.define wRamFunction	$c4b7

.define wActiveLanguage $c62a ; Doesn't do anything on the US version
.define wLinkDeathRespawnBuffer	$c62b

; Seems like activeGroup, except indoor areas don't change it
; Dungeons are correct though
.define wVirtualGroup $c63a
; Used for minimap coordinates
.define wVirtualRoom $c63b

; Global flags (like for ricky sidequest) around $c640
; At least I know $c646 is a global flag

.define wQuestItemFlags	$c69a

.define wLinkHealth  $c6aa
.define wNumRupees   $c6ad
.define wNumBombs    $c6b0
.define wNumEmberSeeds   $c6b9
.define wActiveRing $c6cb

.define wGlobalFlags $c6d0

; Flags shared for above water and underwater
.define wPresentRoomFlags $c700
.define wPastRoomFlags $c800

.define wGroup4Flags	$c900
.define wGroup5Flags	$ca00

.define wOam $cb00

.define wTextIndex   $cba2
.define wTextIndex_l $cba2
.define wTextIndex_h $cba3

.ENUM $cbd5
	wGfxRegs4:	INSTANCEOF GfxRegs	; $cbd5
	wGfxRegs5:	INSTANCEOF GfxRegs	; $cbdb
.ENDE

; cc08-cc17 - some kind of data structure related to used sprites?
; 43 - weird old man
; 44 - zora
; 78 - gale seed
; 8f = octorok
; 90 = moblin

; Point to respawn after falling in hole or w/e
.define wLinkRespawnY	$cc21
.define wLinkRespawnX	$cc22
.define wLinkRespawnDir	$cc23

; Always $d0?
.define wLinkObjectIndex $cc2c

.define wActiveGroup     $cc2d
.define wLoadingRoom      $cc2f
.define wActiveRoom       $cc30
; Can have values from 00-02: incremented by 1 when underwater, and when map flag 0 is set
; Used by interaction 0 for conditional interactions
.define wRoomStateModifier $cc32
.define wActiveCollisions $cc33
.define wRoomProperties	$cc34

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

.define wRoomDungeonProperties	$cc3c

; 8 bytes of dungeonData copied to here
.define wDungeonMapData		$cc3d

.define wDungeonMinimapSomething $cc3d
; Index of dungeon layout data for first floor
.define wDungeonFirstLayout	$cc3f
.define wDungeonNumFloors	$cc40

.define wActiveMusic2	$cc46

.define wWarpDestGroup	$cc47
.define wWarpDestIndex	$cc48
.define wWarpTransition	$cc49


; Write $0b to here to force link to continue moving
.define wForceMovementTrigger $cc4f
; Write the number of pixels link should move into here
.define wForceMovementLength  $cc51


.define wSwordDisabledCounter $cc59

.define wNumTorchesLit $cc8f

; The tile Link is standing on
.define wActiveTilePos   $cc99
.define wActiveTileIndex $cc9a

; Position of chest link is standing on ($00 doesn't count)
.define wLinkOnChest	$cc9f

; Keeps track of which switches are set (buttons on the floor)
.define wActiveTriggers $cca0

; Color of the rotating cube (0-2)
; Bit 7 gets set when the torches are lit
.define wRotatingCubeColor   $ccad
.define wRotatingCubePos     $ccae

; Indices for w2AnimationQueue
.define wAnimationQueueHead	$cce4
.define wAnimationQueueTail	$cce5


; When set to 0, scrolling stops in big areas.
; Equals 1 under most normal circumstances
; When bit 1 is set link can't move.
; Equals 8 while doing a normal screen transition
; Bit 7 is set while the screen is scrolling or text is on the screen
.define wScrollMode $cd00

.define wDirectionEnteredFrom $cd02

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
; When bit 7 is set, all animations are forced to be updated regardless of counters
.define wAnimationState		$cd30

.define wAnimationCounter1	$cd31
.define wAnimationPointer1	$cd32
.define wAnimationCounter2	$cd34
.define wAnimationPointer2	$cd35
.define wAnimationCounter3	$cd37
.define wAnimationPointer3	$cd38
.define wAnimationCounter4	$cd3a
.define wAnimationPointer4	$cd3b

.define wNumEnemies $cdd1

; Each bit keeps track of whether a certain switch has been hit
; Persists between rooms?
.define wSwitchState $cdd3


.define wTmpNumEnemies $cec1
.define wTmpEnemyPos $cec2

.define wRoomCollisions	$ce00
.define wRoomLayout	$cf00

; Bank 1: objects

.define w1LinkState	$d004
.define w1LinkFacingDir	$d008
.define w1LinkYH	$d00b
.define w1LinkXH	$d00d
.define w1LinkInvincibilityCounter $d02b

; Bank 2: used for palettes & other things

.RAMSECTION "RAM 2" BANK 2 SLOT 2+2

w2Filler1: dsb $0b00
w2Filler3: dsb $0090

w2AnimationQueue:	dsb $20	; $db90

w2Filler4: dsb $50

; Though it's only $40 bytes large, dc40 and onward may represent other
; layouts?
w2DungeonLayout:	dsb $100	; $dc00

w2Filler2: dsb $0180

w2AreaBgPalettes:	dsb $40		; $de80
w2AreaSprPalettes:	dsb $40		; $dec0
w2BgPalettesBuffer:	dsb $40		; $df00
w2SprPalettesBuffer:	dsb $40		; $df40

.ENDS

; Bank 3: tileset data
;
.RAMSECTION "RAM 3" BANK 3 SLOT 3+2

; 8 bytes per tile: 4 for tile indices, 4 for tile attributes
w3TileMappingData:	dsb $800	; $d000

w3Filler1:		dsb $300

; Each byte is the collision mode for that tile.
; The lower 4 bits seem to indicate which quarters are solid.
w3TileCollisions:	dsb $100	; $db00

; Indices for tileMappingTable
w3TileMappingIndices:	dsb $200	; $dc00

.ENDS

; Bank 7: used for text

.define w7TextTableAddr $d0f0
.define w7TextTableBank $d0f2


; Interaction variables (objects in dx40-dx7f)
.define INTERAC_ENABLED		$40
.define INTERAC_ID		$41
.define INTERAC_SUBID		$42
.define INTERAC_INITIALIZED	$44
.define INTERAC_DIRECTION	$48
.define INTERAC_Y		$4a
.define INTERAC_YH		$4b
.define INTERAC_X		$4c
.define INTERAC_XH		$4d
.define INTERAC_Z		$4e
.define INTERAC_ZH		$4f
.define INTERAC_SPEED		$50
.define INTERAC_SPEED_Z		$54
.define INTERAC_SCRIPTPTR	$58
.define INTERAC_ANIMCOUNTER	$60
; 70 used by showText; if nonzero, the byte in 70 replaces whatever upper byte you use in a showText opcode.
; $71 may be used by checkabutton?
.define INTERAC_TEXTID		$72

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
.define PART_ID			$c1
.define PART_STATE		$c4
.define PART_DIRECTION		$c9
.define PART_Y			$ca
.define PART_YH			$cb
.define PART_X			$cc
.define PART_XH			$cd
.define PART_Z			$ce
.define PART_ZH			$cf
.define PART_RELATEDOBJ1	$d6
.define PART_RELATEDOBJ2	$d8
.define PART_DAMAGE		$e8

; General definitions for objects
.define OBJ_ID			$01
.define OBJ_SUBID		$02
.define OBJ_STATE		$04
.define OBJ_DIRECTION		$08
.define OBJ_MOVINGDIRECTION	$09
.define OBJ_Y			$0a
.define OBJ_YH			$0b
.define OBJ_X			$0c
.define OBJ_XH			$0d
.define OBJ_Z			$0e
.define OBJ_ZH			$0f
.define OBJ_SPEED		$10
.define OBJ_SPEED_Z		$14
.define OBJ_RELATEDOBJ1		$16
.define OBJ_RELATEDOBJ2		$18
.define OBJ_VISIBLE		$1a
.define OBJ_ANIMCOUNTER		$20
.define OBJ_HEALTH		$29

; Link-specific variables

; Used as a counter for harp warps, and is 1 when link is doing
; a walk-off-screen transition
.define LINK_WARP_VAR		$05
.define LINK_WARP_VAR_2		$06
.define LINK_ANIM_MODE		$30
