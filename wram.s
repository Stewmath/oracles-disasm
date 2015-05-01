
.define paletteFadeCounter $c2ff

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

.define paletteFadeMode $c4ab
.define paletteFadeSpeed $c4ac
.define paletteFadeBG1  $c4b1
.define paletteFadeSP1  $c4b2
.define paletteFadeBG2  $c4b3
.define paletteFadeSP2  $c4b4

; Global flags (like for ricky sidequest) around $c640
; At least I know $c646 is a global flag


.define numEmberSeeds   $c6b9

.define linkHealth  $c6aa
.define numRupees   $c6ad
.define numBombs    $c6b0
.define activeRing $c6cb

; (Global?) flags at c6d0
.define wGlobalFlags $c6d0


.define wOam $cb00

.define textIndex   $cba2
.define textIndex_l $cba2
.define textIndex_h $cba3

; Point to respawn after falling in hole or w/e
.define linkRespawnY    $cc21
.define linkRespawnX    $cc22

.define activeGroup     $cc2d
.define loadingMap      $cc2f
.define activeMap       $cc30
.define activeCollisions $cc33

; Don't know what the distinction for these 2 is
.define activeMusic     $cc35
.define activeMusic2	$cc46

; Write $0b to here to force link to continue moving
.define forceMovementTrigger $cc4f
; Write the number of pixels link should move into here
.define forceMovementLength  $cc51


.define swordDisabledCounter $cc59

.define numTorchesLit $cc8f

; The tile link is standing on
.define activeTilePos   $cc99
.define activeTileIndex $cc9a

; Keeps track of which switches are set (buttons on the floor)
.define activeTriggers $cca0

; Color of the rotating cube (0-2)
; Bit 7 gets set when the torches are lit
.define rotatingCubeColor   $ccad

.define rotatingCubePos     $ccae

; When set to 0, scrolling stops in big areas.
.define scrollMode $cd00

; cd18 - related to screen shaking
.define screenShakeCounterY $cd18
.define screenShakeCounterX $cd19

.define numEnemies $cdd1

; This variable seems to be set when a switch is hit
; Persists between rooms?
.define switchState $cdd3


.define linkFacingDir  $d008
.define linkInvincibilityCounter $d02b
