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
;  01: Small key falls here when [wNumEnemies] == 0
;  02: A chest appears here when [wNumEnemies] == 0
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

; Runs assembly code for specific dungeon events.
; Subid:
;   $00: Nothing
;   $01: d2: verify a 2x2 floor pattern, drop a key.
;   $02: d2: verify that a floor tile is red to open a door.
;   $03: Light torches when a colored cube rolls into this position.
;   $04: d2: Set torch color based on the color of the tile at this position.
;   $05: d2: Drop a small key here when a colored block puzzle has been solved.
;   $06: d2: Set trigger 0 when the colored flames are lit red.
;   $07: Toggle a bit in wSwitchState based on whether a toggleable floor tile at position
;        Y is blue. The bitmask to use is X.
;   $08: Toggle a bit in wSwitchState based on whether blue flames are lit. The bitmask to
;        use is X.
;   $09: d3: Drop a small key when 3 blocks have been pushed.
;   $0a: d3: When an orb is hit, spawn an armos, as well as interaction which will spawn
;            a chest when it's killed.
;   $0b: Unused? A chest appears when 4 torches in a diamond formation are lit?
;   $0c: d3: 4 armos spawn when trigger 0 is activated.
;   $0d: d3: Crystal breakage handler
;   $0e: d3: Small key falls when a block is pushed into place
;   $0f: d4: A door opens when a certain floor pattern is achieved
;   $10: d4: A small key falls when a certain froor pattern is achieved
;   $11: Tile-filling puzzle: when all the blue turns red, a chest will spawn here.
;   $12: d4: A chest spawns here when the torches light up with the color blue.
;   $13: d5: A chest spawns here when all the spaces around the owl statue are filled.
;   $14: d5: A chest spawns here when two blocks are pushed to the right places
;   $15: d5: Cane of Somaria chest spawns here when blocks are pushed into a pattern
;   $16: d5: Sets floor tiles to show a pattern when a switch is held down.
;   $17: Create a chest at position Y which appears when [wActiveTriggers] == X, but which
;        also disappears when the trigger is released.
;   $18: d3: Calculate the value for [wSwitchState] based on which crystals are broken.
;   $19: d1: Set trigger 0 when the colored flames are lit blue.
.define INTERACID_DUNGEON_EVENTS	$21

; When a tile at this position is jumped over, all colored floor tiles in the room change
; colors.
; Subid:
;  0: The "controller".
;  1: Instance that's spawned by the controller to perform the replacement.
.define INTERACID_FLOOR_COLOR_CHANGER	$22

; Extends or retracts a bridge when a bit in wSwitchState changes.
; Subid: bits 0-2: bit in wSwitchState to watch
; Y: YX position
; X: Index of bridge data
.define INTERACID_EXTENDABLE_BRIDGE	$23

; Controls a bit in wActiveTriggers based on various things.
; Subid:
;   bits 0-3: 0: Control a bit in wActiveTriggers based on wToggleBlocksState.
;             1: Control a bit in wActiveTriggers based on wSwitchState.
;             2: Control a bit in wActiveTriggers based on if [wNumLitTorches] == Y.
;   bits 4-6: A bit to check in wToggleBlocksState or wSwitchState (subids 0 and 1 only)
; Y: Number of torches to be lit (subid 2 only).
; X: a bitmask for wActiveTriggers (subid 2 only).
.define INTERACID_TRIGGER_TRANSLATOR	$24

; Keeps track of the yellow tile in the tile-filling puzzles and updates the floor color.
; Starting position is determined by Y and X.
; To complete the tile-filling puzzle, an interaction with id $2111 should also exist;
; that will spawn the chest.
.define INTERACID_TILE_FILLER		$25

; $26/$27 don't exist

; Valid subids: $00-$0a
.define INTERACID_BIPIN			$28

; subid does nothing.
.define INTERACID_ADLAR			$29

; Librarian at eyeglasses library.
; subid does nothing.
.define INTERACID_LIBRARIAN		$2a

; Valid subids: $00-$09
.define INTERACID_BLOSSOM		$2b

; The wallmaster used in black tower escape cutscene?
.define INTERACID_VERAN_CUTSCENE_WALLMASTER	$2c

; Veran's face used in cutscene just before final battle
.define INTERACID_VERAN_CUTSCENE_FACE	$2d

; Old man who gives or takes money. His position is hardcoded. Uses room flag $40.
; Subid: 0 gives 200 rupees, 1 takes 100 rupees.
.define INTERACID_OLD_MAN_WITH_RUPEES	$2e

; Plays MUS_NAYRU and lowers volume if GLOBALFLAG_INTRO_DONE is not set.
.define INTERACID_PLAY_NAYRU_MUSIC	$2f

; Subid:
;   0: human npc
;   1: goron npc
;   2: elder npc (biggoron's sword minigame)
;   3: controls the game itself
.define INTERACID_SHOOTING_GALLERY	$30

; Subid:
;   0: First meet at the start of the game
;   1: Talking after nayru is kidnapped
;   2: Credits cutscene
;   3: Saved Zelda cutscene?
;   4: Cutscene at black tower entrance where Impa warns about Ralph's heritage
;   5: Like subid 4, but for linked game
;   6: ?
;   7: Tells you that Zelda's been kidnapped by vire
;   8: ?
;   9: Tells you that Zelda's been kidnapped by twinrova
;   a: ? (doesn't have a script)
.define INTERACID_IMPA			$31

; A fake octorok.
; Subid:
;   0: Octorok attacking impa. (var03 is a value from 0-2 for the index.)
;   2: Great fairy turned into an octorok.
.define INTERACID_FAKE_OCTOROK		$32

; Not really the boss itself, but this basically "runs" the fight?
; Subid: this should be $ff; it's incremented each time an enemy is spawned to keep track
;        of the enemy index to spawn next.
.define INTERACID_SMOG_BOSS		$33

; The stone that's pushed at the start of the game. After it's moved, this stone is
; handled by PARTID_TRIFOCE_STONE instead.
.define INTERACID_TRIFORCE_STONE	$34

; The child that you name.
; subid: determines graphic.
;        0: hyperactive
;        1: shy
;        2: curious
;        3: slacker
;        4: warrior
;        5: arborist
;        6: singer
; var03: script index.
;        01-03: stage 4 (hyperactive/shy/curious)
;        04-06: stage 5
;        07-09: stage 6
;        0a-0d: stage 7 (slacker/warrior/arborist/singer)
;        0e-11: stage 8
;        12-15: stage 9
;        16-1c: unused?
.define INTERACID_CHILD			$35

; Subid:
;   00: Cutscene at the beginning of game (talking to Link, then gets posessed)
;   01: Cutscene in Ambi's palace after getting bombs
;   02: Cutscene on maku tree screen after being saved
;   03: Cutscene with Nayru and Ralph when Link exits the black tower
;   04: Cutscene at end of game with Ambi and her guards
;   05: ?
;   06: ?
;   07: Cutscene with the vision of Nayru teaching you Tune of Echoes
;   08: Cutscene after saving Zelda?
;   09: Cutscene where Ralph's heritage is revealed (unlinked?)
;   0a: Cutscene where Ralph's heritage is revealed (linked?)
;   0b: NPC after being saved
;   0c: NPC between being told about Ralph's heritage and beating Veran (linked?)
;   0d: NPC after Veran is beaten (linked)
;   0e: ?
;   0f: NPC after getting maku seed, but before being told about Ralph's heritage
;   10: Cutscene in black tower where Nayru/Ralph meet you to try to escape
;   11: Cutscene on white background with Din just before facing Twinrova
;   12: ?
;   13: NPC after completing game (singing to animals)
.define INTERACID_NAYRU			$36

; Subid:
;   00: Cutscene where Nayru gets posessed
;   01: Cutscene outside Ambi's palace before getting mystery seeds
;   02: Cutscene after Nayru is posessed
;   03: Cutscene after talking to Rafton
;   04: Cutscene on maku tree screen after saving Nayru
;   05: Cutscene in black tower where Nayru/Ralph meet you to try to escape
;   06: Cutscene at end of game with Ambi and her guards "confronting" Link
;   07: Cutscene postgame where they warp to the maku tree, Ralph notices the statue
;   08: Cutscene in credits where Ralph is training with his sword
;   09: Cutscene where Ralph charges in to Ambi's palace
;   0a: Cutscene where Ralph's about to charge into the black tower
;   0b: Cutscene where Ralph tells you about getting Tune of Currents
;   0c: Cutscene where Ralph confronts Ambi in black tower
;   0d: Cutscene where Ralph goes back in time
;   0e: Cutscene with Nayru and Ralph when Link exits the black tower
;   0f: Does nothing but stand there, facing right
;   10: Cutscene after talking to Cheval
;   11: NPC after finishing the game
;   12: NPC after beating Veran, before beating Twinrova in a linked game
.define INTERACID_RALPH			$37

.define INTERACID_VERAN_GHOST		$3e

.define INTERACID_SOLDIER		$40

; Subid:
;    0-2: pieces of triforce
;    8:   extra tree branches when scrolling up tree before titlescreen
.define INTERACID_TRIFORCE		$4a

.define INTERACID_AMBI			$4d

; A sword, as used by Ralph. Doesn't have collisions?
; Appears to check bit 7 of relatedObj1's animParameter to see when to do the sword swing
; animation.
.define INTERACID_SWORD			$5e

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

.define INTERACID_MOVING_PLATFORM	$79

; This interaction is created when "sent back by a strange force". It makes the entire
; screen turn into a giant sine wave.
.define INTERACID_SCREEN_DISTORTION	$7c

.define INTERACID_MINIBOSS_PORTAL	$7e

; subid: 0: A tiny sparkle that disappears in an instant.
;        4: A big, red-and-blue orb that's probably used with the maku seed or something?
.define INTERACID_SPARKLE		$84

.define INTERACID_MAKU_TREE_CHILD	$88

.define INTERACID_90			$90

; Bubbles created at random when swimming in a sidescrolling area
.define INTERACID_BUBBLE		$91

.define INTERACID_TWINROVA		$93

.define INTERACID_EXCLAMATION_MARK	$9f

; An image which moves up and to the left or right for 70 frames, then disappears.
; subid: 0: "Z" letter for a snoring character
;        1: A musical note
; var03: 0: Veer left
;        1: Veer right
.define INTERACID_FLOATING_IMAGE	$a0

.define INTERACID_TOUCHING_BOOK		$a5

; A flame used for the twinrova cutscenes (changes color based on parameters?)
.define INTERACID_TWINROVA_FLAME	$a9

; Decides which objects need to be spawned in the bipin/blossom family.
; Subid: 0 for left side of house, 1 for right side of house.
.define INTERACID_BIPIN_BLOSSOM_FAMILY_SPAWNER		$ac

.define INTERACID_ZELDA			$ad

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

; Play a harp song, and make music notes at Link's position. Used when Link learns a song.
;   Subid: song to play (0-2)
.define INTERACID_PLAY_HARP_SONG	$c5

; Creates an object of the given type with the given ID at every position where there's
; a tile of the specified index, then deletes itself.
; subid: tile index; an object will be spawned at each tile with this index.
; Y: ID of object to spawn
; X: bits 0-3: Subid of object to spawn
;    bits 4-7: object type (0=enemy, 1=part, 2=interaction)
.define INTERACID_CREATE_OBJECT_AT_EACH_TILEINDEX	$c7

.define INTERACID_d2			$d2

; Birds used while scrolling up the tree before the titlescreen
.define INTERACID_BIRD			$d3

; This is for the great fairy that cleans the sea. For great fairies that heal, see
; "ENEMYID_GREAT_FAIRY".
; Subid:
;   0: ?
;   1: cutscene after being healed from being an octorok
.define INTERACID_GREAT_FAIRY		$d5

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

; Eyeball that looks at Link
.define INTERACID_STATUE_EYEBALL	$e2

; Subid: value from 0-2
.define INTERACID_RAFT			$e6
