
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


.define wNumEmberSeeds   $c6b9

.define wLinkHealth  $c6aa
.define wNumRupees   $c6ad
.define wNumBombs    $c6b0
.define wActiveRing $c6cb

; (Global?) flags at c6d0
.define wGlobalFlags $c6d0


.define wOam $cb00

.define wTextIndex   $cba2
.define wTextIndex_l $cba2
.define wTextIndex_h $cba3

; Point to respawn after falling in hole or w/e
.define wLinkRespawnY    $cc21
.define wLinkRespawnX    $cc22

.define wActiveGroup     $cc2d
.define wLoadingMap      $cc2f
.define wActiveMap       $cc30
.define wActiveCollisions $cc33

; Don't know what the distinction for these 2 is
.define wActiveMusic     $cc35
.define wActiveMusic2	$cc46

; Write $0b to here to wForce wLink to continue moving
.define wForceMovementTrigger $cc4f
; Write the wNumber of pixels wLink should move into here
.define wForceMovementLength  $cc51


.define wSwordDisabledCounter $cc59

.define wNumTorchesLit $cc8f

; The tile wLink is standing on
.define wActiveTilePos   $cc99
.define wActiveTileIndex $cc9a

; Keeps track of which switches are set (buttons on the floor)
.define wActiveTriggers $cca0

; Color of the wRotating cube (0-2)
; Bit 7 gets set when the torches are lit
.define wRotatingCubeColor   $ccad

.define wRotatingCubePos     $ccae

; When set to 0, scrolling stops in big areas.
.define wScrollMode $cd00

; cd18 - related to screen shaking
.define wScreenShakeCounterY $cd18
.define wScreenShakeCounterX $cd19

.define wNumEnemies $cdd1

; This variable seems to be set when a switch is hit
; Persists between rooms?
.define wSwitchState $cdd3


.define w1LinkFacingDir  $d008
.define w1LinkInvincibilityCounter $d02b
