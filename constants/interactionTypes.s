; The first $c interactions consist of various animations.
; SubID:
;  Bit 0 - flicker to create transparency
;  Bit 7 - disable sound effect
.define INTERACID_GRASSDEBRIS		$00
.define INTERACID_REDGRASSDEBRIS	$01
.define INTERACID_GREENPOOF		$02
.define INTERACID_SPLASH		$03
.define INTERACID_LAVASPLASH		$04
.define INTERACID_PUFF			$05
.define INTERACID_ROCKDEBRIS		$06
.define INTERACID_CLINK			$07
.define INTERACID_KILLENEMYPUFF		$08
.define INTERACID_SNOWDEBRIS		$09
.define INTERACID_SHOVELDEBRIS		$0a
.define INTERACID_0B			$0b
.define INTERACID_ROCKDEBRIS2		$0c
.define INTERACID_0D			$0d ; stub
.define INTERACID_0E			$0e ; stub

; SubID:
;  0: fall down hole effect
;  1: pegasus seed "dust" effect?
; Var03:
;  Bit 7 - disable sound effect
.define INTERACID_FALLDOWNHOLE		$0f

.define INTERACID_FARORE		$10
; SubID: xy
;  y=0: "Parent" interaction
;  y=1: "Children" sparkles
;  x: for y=1, this sets the sparkle's initial angle
.define INTERACID_FARORE_MAKECHEST	$11

; SubID:
;  00: Show text on entering dungeon; also initializes toggle blocks, switches, and loads
;      static objects.
;  01: Small key falls when [wNumEnemies] == 0
;  02: A chest appears when [wNumEnemies] == 0
;  03: Set room flag $80 when [wNumEnemies] == 0
;  04: Create a staircase when [wNumEnemies] == 0 (and set room flag $80).
;      This will search the room for tiles with indices between $40-$43, and create
;      staircase tiles at those positions.
.define INTERACID_DUNGEON_STUFF		$12

; When [wNumEnemies] == [subid], the block at this position can be pushed, and wNumEnemies
; will set to 0 (which may trigger a door opening). This increments wNumEnemies when it
; spawns.
.define INTERACID_PUSHBLOCK_TRIGGER	$13

; This interaction is created at $d140 (w1ReservedInteraction1) when a block/pot/etc is
; pushed.
.define INTERACID_PUSH_BLOCK		$14

; Controls the red/yellow/blue floor tiles that toggle when jumped over.
; Subid:
;   0: "Parent" interaction; constantly checks Link's position and spawns subid1 when
;      appropriate.
;   1: Toggles tile at position [var03] when Link lands, then deletes itself.
.define INTERACID_TOGGLE_FLOOR		$15

.define INTERACID_MINECART		$16

; This shows a key or boss key sprite when opening a door.
; SubID is the tile index of the door being opened.
.define INTERACID_DUNGEON_KEY_SPRITE	$17

; This is used when opening keyholes in the overworld.
; SubID is the treasure index of the key being used, minus $42 (TREASURE_GRAVEYARD_KEY,
; the first one).
.define INTERACID_OVERWORLD_KEY_SPRITE	$18

; For torch puzzles.
; Subid: initial orientation of cube (0-5)
.define INTERACID_COLORED_CUBE		$19

; A flame that appears when the colored cube is put in the right place.
.define INTERACID_COLORED_CUBE_FLAME	$1a

; Subid:
;   bits 0-2: bit in wSwitchState which controls the gate
;   bits 4-7: 0: barrier extends left
;             2: barrier extends right
.define INTERACID_MINECART_GATE		$1b

; The book on farore's desk
.define INTERACID_FARORES_MEMORY	$1c

; This works as both a door opener and closer.
; Y: used for Y/X position
; X: value from 0-7 corresponding to a bit in wActiveTriggers (for subids $04-$07)
;
; angle: $00,$02,$04,$06 for small keys in respective directions;
;        $08,$0a,$0c,$0e for boss doors;
;        $10,$12,$14,$16 for shutters;
;        $18,$1a,$1c,$1e for minecart shutters.
;
; subid: $00: open based on angle (see above)
;        $04-$07: door controlled by wActiveTriggers (switches, buttons)
;        $08-$0b: door shuts until [wNumEnemies] == 0
;        $0c-$0f: minecart doors
;        $10-$13: door closes and stays shut once Link moves away from it
;        $14: door opens when 2 torches are lit (up)
;        $15: door opens when 2 torches are lit (left)
;        $16: door opens when 1 torch is lit (down)
;        $17: door opens when 1 torch is lit (left)
.define INTERACID_DOOR_CONTROLLER	$1e

; Subid: 0: trigger a warp when Link dives here. (X should be 0 or 1, indicating where
;           to warp to, while Y is the short-form position.)
;        1: Trigger a warp at the top of a waterfall (only if riding dimitri)
;        2: Trigger a warp in a cave in a waterfall (only if riding Dimitri)
.define INTERACID_SPECIAL_WARP		$1f

; Runs a dungeon-specific script. Subid is the script index.
.define INTERACID_DUNGEON_SCRIPT	$20

.define INTERACID_SOLDIER		$40

; Subid:
;    0-2: pieces of triforce
;    8:   extra tree branches when scrolling up tree before titlescreen
.define INTERACID_TRIFORCE		$4a

; The subid and var03 determine what treasure Link will get, and how it behaves.
; See constants/treasure.s and data/treasureData.s.
.define INTERACID_TREASURE		$60

; When subid=$80, this spawns in your animal companion (used after playing the flute)
.define INTERACID_COMPANION_SPAWNER	$67

; Subid:
;   0: link riding horse
;   1: link on horse neighing
;   2: cliff that horse stands on in temple shot
;   3: link on horse (closeup)
;   4: "sparkle" on closeup of link's face
;   5: birds
.define INTERACID_INTRO_SPRITE		$75

; This interaction is created when "sent back by a strange force". It makes the entire
; screen turn into a giant sine wave.
.define INTERACID_SCREEN_DISTORTION	$7c

; subid: 0: A tiny sparkle that disappears in an instant.
;        4: A big, red-and-blue orb that's probably used with the maku seed or something?
.define INTERACID_SPARKLE		$84

.define INTERACID_MAKU_TREE_CHILD	$88

.define INTERACID_90			$90

; Bubbles created at random when swimming in a sidescrolling area
.define INTERACID_BUBBLE		$91

.define INTERACID_EXCLAMATION_MARK	$9f

; An image which moves up and to the left or right for 70 frames, then disappears.
; subid: 0: "Z" letter for a snoring character
;        1: A musical note
; var03: 0: Veer left
;        1: Veer right
.define INTERACID_FLOATING_IMAGE	$a0

.define INTERACID_TOUCHING_BOOK		$a5

; A flame used for the twinrova cutscenes (changes color based on parameters?)
.define INTERACID_TWINROVA_FLAME		$a9

; Used for the credits text in between the mini-cutscenes.
.define INTERACID_CREDITS_TEXT_HORIZONTAL	$ae
; Used for the credits after the cutscenes.
.define INTERACID_CREDITS_TEXT_VERTICAL	$af

; Energy thing that appears when you enter the final dungeon for the first time
.define INTERACID_FINAL_DUNGEON_ENERGY	$b5

; SubID: a unique value from $0-$f used as an index for wGashaSpot variables
.define INTERACID_GASHA_SPOT		$b6

; These are little hearts that float up when Zelda kisses Link in the ending cutscene.
.define INTERACID_KISS_HEART		$b7

.define INTERACID_BB			$bb

; Banana carried by Moosh in credits cutscene. Maybe also the obtainable banana in seasons?
.define INTERACID_BANANA		$c0

.define INTERACID_PIRATE_SHIP		$c2

.define INTERACID_d2			$d2

; Birds used while scrolling up the tree before the titlescreen
.define INTERACID_BIRD			$d3

; Subid is the index of the secret (value of "wShortSecretIndex"?). This either creates
; a chest or just gives the item to Link (if it's an upgrade).
.define INTERACID_FARORE_GIVEITEM	$d9

; The warp animation that occurs when entering a time portal.
; SubID: 0: Initiating a warp (entered a portal from the source screen)
;        1: Completing a warp (warping in to the destination screen)
.define INTERACID_TIMEWARP		$dd

; A time portal created with the Tune of Currents or Tune of Ages.
; (TODO: wrap in ifdef)
.define INTERACID_TIMEPORTAL		$de

.ifdef ROM_SEASONS
.define INTERACID_DE			$de
.endif

; Blurb that displays the season/era at the top of the screen when entering an area.
.define INTERACID_ERA_OR_SEASON_INFO	$e0

; Creates a time portal when the Tune of Echoes is played.
.define INTERACID_TIMEPORTAL_SPAWNER	$e1

; Subid: value from 0-2
.define INTERACID_RAFT			$e6
