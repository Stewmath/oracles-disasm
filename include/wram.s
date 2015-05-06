
.define wPaletteFadeCounter $c2ff

.ENUM $c480
	wKeysPressedLastFrame: ; c480
		db
	wKeysPressed: ; c481
		db
	wKeysJustPressed: ; c482
		db
	wAutoFireKeysPressed: ; c483
		db
	wAutoFireCounter ; c484
		db
.ENDE

.define wPaletteFadeMode $c4ab
.define wPaletteFadeSpeed $c4ac
.define wPaletteFadeBG1  $c4b1
.define wPaletteFadeSP1  $c4b2
.define wPaletteFadeBG2  $c4b3
.define wPaletteFadeSP2  $c4b4

; Global flags (like for ricky sidequest) around $c640
; At least I know $c646 is a global flag


; Seems like activeGroup, except indoor areas don't change it
; Dungeons are correct though
.define wVirtualGroup $c63a
; Used for minimap coordinates
.define wVirtualMap $c63b

.define wNumEmberSeeds   $c6b9

.define wLinkHealth  $c6aa
.define wNumRupees   $c6ad
.define wNumBombs    $c6b0
.define wActiveRing $c6cb

; (Global?) flags at c6d0
.define wGlobalFlags $c6d0

.define wPresentMapFlags $c700
.define wPastMapFlags $c800


.define wOam $cb00

.define wTextIndex   $cba2
.define wTextIndex_l $cba2
.define wTextIndex_h $cba3

; cc08-cc17 - some kind of data structure related to used sprites?
; 43 - weird old man
; 44 - zora
; 78 - gale seed
; 8f = octorok
; 90 = moblin

; Point to respawn after falling in hole or w/e
.define wLinkRespawnY    $cc21
.define wLinkRespawnX    $cc22

.define wActiveGroup     $cc2d
.define wLoadingMap      $cc2f
.define wActiveMap       $cc30
; Can have values from 00-02: incremented by 1 when underwater, and when map flag 0 is set
; Used by interaction 0 for conditional interactions
.define wRoomStateModifier $cc32
.define wActiveCollisions $cc33
.define wMapProperties	$cc34

; Don't know what the distinction for these 2 is
.define wActiveMusic     $cc35
.define wActiveMusic2	$cc46

; Write $0b to here to force link to continue moving
.define wForceMovementTrigger $cc4f
; Write the wNumber of pixels link should move into here
.define wForceMovementLength  $cc51


.define wSwordDisabledCounter $cc59

.define wNumTorchesLit $cc8f

; The tile wLink is standing on
.define wActiveTilePos   $cc99
.define wActiveTileIndex $cc9a

; Keeps track of which switches are set (buttons on the floor)
.define wActiveTriggers $cca0

; Color of the rotating cube (0-2)
; Bit 7 gets set when the torches are lit
.define wRotatingCubeColor   $ccad

.define wRotatingCubePos     $ccae

; When set to 0, scrolling stops in big areas.
.define wScrollMode $cd00
.define wDirectionEnteredFrom $cd02

; cd18 - related to screen shaking
.define wScreenShakeCounterY $cd18
.define wScreenShakeCounterX $cd19

.define wNumEnemies $cdd1

; This variable seems to be set when a switch is hit
; Persists between rooms?
.define wSwitchState $cdd3


.define wTmpNumEnemies $cec1
.define wTmpEnemyPos $cec2

.define w1LinkFacingDir  $d008
.define w1LinkInvincibilityCounter $d02b


; Interaction variables (objects in dx40-dx7f)
.define INTERAC_ENABLED		$40
.define INTERAC_ID		$41
.define INTERAC_INITIALIZED	$44
.define INTERAC_Y		$4a
.define INTERAC_YH		$4b
.define INTERAC_X		$4c
.define INTERAC_XH		$4d
.define INTERAC_Z		$4e
.define INTERAC_ZH		$4f
.define INTERAC_SPEED		$50
.define INTERAC_SPEED_Z		$54
.define INTERAC_SCRIPTPTR	$58

; 70 used by showText; if nonzero, the byte in 70 replaces whatever upper byte you use in a showText opcode.
; $71 may be used by checkabutton?
.define INTERAC_TEXTID      $72

; Enemy variables (objects in dx80-dxbf)
.define ENEMY_ENABLED       $80
.define ENEMY_ID            $81
.define ENEMY_SUBID         $82
.define ENEMY_STATE         $84
.define ENEMY_COUNTER1      $86
.define ENEMY_DIRECTION     $89
.define ENEMY_Y		$8a
.define ENEMY_YH	$8b
.define ENEMY_X		$8c
.define ENEMY_XH	$8d
.define ENEMY_Z		$8e
.define ENEMY_ZH	$8f
.define ENEMY_RELATEDOBJ1   $96
.define ENEMY_RELATEDOBJ2   $98
.define ENEMY_VISIBLE       $9a ; More than just visibility

; A4 - used by pumpkin head, at least, when the ghost dies
; A5 - collision properties? determines whether you'll get damaged?
.define ENEMY_COLLIDERADIUSY    $a6
.define ENEMY_COLLIDERADIUSX    $a7
.define ENEMY_DAMAGE        $a8
.define ENEMY_HEALTH        $a9
.define ENEMY_FROZEN_TIMER  $ae


; Part variables (objects in dxc0-dxff)
.define PART_ID             $c1
.define PART_STATE          $c4
.define PART_DIRECTION      $c9
.define PART_Y			$ca
.define PART_YH			$cb
.define PART_X			$cc
.define PART_XH			$cd
.define PART_Z			$ce
.define PART_ZH			$cf
.define PART_RELATEDOBJ1    $d6
.define PART_RELATEDOBJ2    $d8
.define PART_DAMAGE         $e8

; General definitions for objects
.define OBJ_ID              $01
.define OBJ_SUBID           $02
.define OBJ_Y			$0a
.define OBJ_YH			$0b
.define OBJ_X			$0c
.define OBJ_XH			$0d
.define OBJ_Z			$0e
.define OBJ_ZH			$0f
.define OBJ_STATE           $04
.define OBJ_RELATEDOBJ1     $16
.define OBJ_RELATEDOBJ2     $18
.define OBJ_HEALTH          $29
