; This is a list of all interactions in the game.
;
; The comments here should describe the "interface" of the objects; that is, what
; variables are important to initialize when creating them. Additional comments about
; internal variables used by the objects may be found next to their code (search for
; a label of the form "interactionCodeXX", where XX is their ID).
;
; COMMENT FORMAT:
;   LynnaLab parses the comments to glean information about interactions. When a line
;   starts with ";;", every subsequent line that starts with ";" is considered
;   documentation until the next uncommented line. Within here, the description can be
;   typed, or fields can be entered with "@field{value}".
;
;   Field list (case-insensitive):
;   * postype: Affects how to determine the object's position.
;       "normal" = Y and X positions are treated normally (default).
;       "short" = both Y and X positions are stored in Y variable.
;       "none" = this object doesn't have anything resembling a position.
;   * palette: Palette header to load. Most sprites use palettes 0-5, which are always the
;              same, but some object use slots 6-7 for custom palettes. These objects
;              should use this field.
;
;  You might also see some manual newline ("\n") entries sometimes since making the
;  comments pretty in both the GUI and in plaintext format is hard...


; ==============================================================================
; Common interactions (exist in ages and seasons)
; ==============================================================================

;;
; Interactions $00-$0c consist of various animations.
;
; @subid{Bit 0: Flicker to create transparency\n
;        Bit 7: Disable sound effect}
.define INTERAC_GRASSDEBRIS $00
.define INTERAC_REDGRASSDEBRIS $01
.define INTERAC_GREENPOOF $02
.define INTERAC_SPLASH $03
.define INTERAC_LAVASPLASH $04
.define INTERAC_PUFF $05
.define INTERAC_ROCKDEBRIS $06
.define INTERAC_CLINK $07
.define INTERAC_KILLENEMYPUFF $08
.define INTERAC_SNOWDEBRIS $09
.define INTERAC_SHOVELDEBRIS $0a
.define INTERAC_0b $0b ; Blue oval thing used by ENEMY_EYESOAR_CHILD when spawning
.define INTERAC_ROCKDEBRIS2 $0c

.define INTERAC_STUB_0d $0d
.define INTERAC_STUB_0e $0e

;;
; When this is spawned, counter2 sometimes contains the ID of the object that fell in the
; hole? This is then used with "fall down hole events" (in patch's and toilet rooms).
;
; @subid_00{Fall down hole effect}
; @subid_01{Pegasus seed or knockback "dust" effect?}
; @var03{Bit 7: disable sound effect}
.define INTERAC_FALLDOWNHOLE $0f

;;
; Farore.
.define INTERAC_FARORE $10

;;
; Objects related to the mini-cutscenes where Farore spawns a chest.
;
; SubID Format: $ab
;
; b=0: "Parent" interaction\n
; b=1: "Children" sparkles
;
; a: for b=1, this sets the sparkle's initial angle
.define INTERAC_FARORE_MAKECHEST $11

;;
; Various generic events used in dungeons.
;
; @subid_00{Show text on entering dungeon; also initializes toggle blocks, switches, and loads
;       static objects.}
; @subid_01{Small key falls here when [wNumEnemies] == 0}
; @subid_02{A chest appears here when [wNumEnemies] == 0}
; @subid_03{Set room flag $80 when [wNumEnemies] == 0}
; @subid_04{Create a staircase when [wNumEnemies] == 0 (and set room flag $80).
;       This will search the room for tiles with indices between $40-$43, and create
;       staircase tiles at those positions.}
; @subid_05{Something seasons-specific}
.define INTERAC_DUNGEON_STUFF $12

;;
; When [wNumEnemies] == [subid], the block at this position can be pushed, and wNumEnemies
; will set to 0 (which may trigger a door opening). This increments wNumEnemies when it
; spawns.
.define INTERAC_PUSHBLOCK_TRIGGER $13

;;
; This interaction is created at $d140 (w1ReservedInteraction1) when a block/pot/etc is
; pushed.
.define INTERAC_PUSHBLOCK $14

;;
; A minecart you can mount (gets replaced with SPECIALOBJECT_MINECART once you start
; riding)
.define INTERAC_MINECART $16

;;
; This shows a key or boss key sprite when opening a door.
; SubID is the tile index of the door being opened.
.define INTERAC_DUNGEON_KEY_SPRITE $17

;;
; This is used when opening keyholes in the overworld.
; SubID is the treasure index of the key being used, minus $42 (TREASURE_FIRST_KEY).
.define INTERAC_OVERWORLD_KEY_SPRITE $18

;;
; The book on farore's desk
.define INTERAC_FARORES_MEMORY $1c

;;
; This works as both a door opener and closer.
;
; angle: $00,$02,$04,$06 for small keys in respective directions;\n
;        $08,$0a,$0c,$0e for boss doors;\n
;        $10,$12,$14,$16 for shutters;\n
;        $18,$1a,$1c,$1e for minecart shutters.
;
; @Y{Used for Y/X position}
; @X{Value from 0-7 corresponding to a bit in wActiveTriggers (for subids $04-$07)}
;
; @subid_00{open based on angle (see above)}
; @subid_04-07{door controlled by wActiveTriggers (switches, buttons)}
; @subid_08-0b{door shuts until [wNumEnemies] == 0}
; @subid_0c-0f{minecart doors}
; @subid_10-13{door closes and stays shut once Link moves away from it}
; @subid_14{door opens when 2 torches are lit (up)}
; @subid_15{door opens when 2 torches are lit (left)}
; @subid_16{door opens when 1 torch is lit (down)}
; @subid_17{door opens when 1 torch is lit (left)}
; @postype{short}
.define INTERAC_DOOR_CONTROLLER $1e

;;
; Runs a dungeon-specific script. Subid is the script index.
.define INTERAC_DUNGEON_SCRIPT $20

;;
; Valid subids: $00-$0a
.define INTERAC_BIPIN $28

;;
; Valid subids: $00-$09
.define INTERAC_BLOSSOM $2b

;;
; The child that you name.
;
; subid: determines graphic.
;        0: hyperactive
;        1: shy
;        2: curious
;        3: slacker
;        4: warrior
;        5: arborist
;        6: singer
;
; var03: script index.
;        01-03: stage 4 (hyperactive/shy/curious)
;        04-06: stage 5
;        07-09: stage 6
;        0a-0d: stage 7 (slacker/warrior/arborist/singer)
;        0e-11: stage 8
;        12-15: stage 9
;        16-1c: unused?
.define INTERAC_CHILD $35

;;
; @subid_00: Normal shopkeeper}
; @subid_01: Secret shop / chest game guy}
; @subid_02: Advance shop}
.define INTERAC_SHOPKEEPER $46

;;
; Subid is the item being sold.
;
; @subid_00{Ring box upgrade (L2) (changes self to subid $14 if appropriate)}
; @subid_01{3 hearts}
; @subid_02{Hidden shop gasha seed 1}
; @subid_03{L1 shield}
; @subid_04{10 bombs}
; @subid_05{Hidden shop ring}
; @subid_06{Hidden shop gasha seed 2}
; @subid_07{Potion from syrup's shop}
; @subid_08{Gasha seed from syrup's shop}
; @subid_09{Potion from syrup's shop (shifted left to make room for bombchus)}
; @subid_0a{Gasha seed from syrup's shop (shifted left to make room for bombchus)}
; @subid_0b{Bombchus}
; @subid_0c{Nothing?}
; @subid_0d{Strange flute}
; @subid_0e{Advance shop gasha seed}
; @subid_0f{Advance shop GBA ring}
; @subid_10{Advance shop random ring}
; @subid_11{L2 shield}
; @subid_12{L3 shield}
; @subid_13{Normal shop gasha seed (linked only)}
; @subid_14{Ring box upgrade (L3)}
; @subid_15{Hidden shop heart piece}
.define INTERAC_SHOP_ITEM $47

;;
; @subid_00-02{pieces of triforce}
; @subid_03{Sparkles?}
; @subid_04{The "glow" behind the pieces of the triforce (var03 is the index)}
; @subid_05{Object that responds to key inputs?}
; @subid_06{?}
; @subid_07{?}
; @subid_08{Extra tree branches when scrolling up tree before titlescreen}
; @subid_09{var03 is a value from 0-2? Spawns subid $0a?}
; @subid_0a{?}
.define INTERAC_INTRO_SPRITES_1 $4a

;;
; Explosion animation; no collisions.
;
; This object's animParameter is set to certain values during the animation:\n
;   $01: When the explosion's radius increases\n
;   $ff: When the explosion is over
;
; var03: if set, it has a higher draw priority? (set in patch's minigame, tingle's balloon explosion)
.define INTERAC_EXPLOSION $56

;;
; This is an object that Link can collect.
;
;   Subid: treasure index (see constants/treasure.s)
;
;   var03: index in "treasureObjectData.s" indicating graphic, text when obtained, etc.
;
;   var38: If nonzero, and not $ff, this overrides the parameter 'c' to pass to the
;         "giveTreasure" function? (normally this is determined from treasureObjectData.s)
.define INTERAC_TREASURE $60

;;
; This causes a tile at a given position to change between 2 values depending on
; whether a certain switch is activated or not.
;
; @subid{Bitmask to check on wSwitchState (if nonzero, "active" tile is placed)}
; @X{"index" of tile replacement (defines what tiles are placed for on/off)}
; @Y{Position of tile that should change when wSwitchState changes}
; @postype{short}
.define INTERAC_SWITCH_TILE_TOGGLER $78

;;
; Subid:
;   Bits 3-7: Script index (dungeon-dependent)\n
;   Bits 0-2:\n
;     0: 1x1 platform\n
;     1: 1x2 platform\n
;     2: 1x3 platform\n
;     3: 2x1 platform\n
;     4: 3x1 platform\n
;     5: 2x2 platform\n
.define INTERAC_MOVING_PLATFORM $79

;;
; Roller from seasons, but exists in both games.
;
; @subid{Value from 0-2 indicating height of roller}
.define INTERAC_ROLLER $7a

;;
; Spinny thing that forces you to move in a clockwise or counterclockwise direction.
; The direction of the spinner is actually determined by wSpinnerState. This is
; initialized when entering a dungeon; search for the "@initialSpinnerValues" label.
;
; @subid_00-01{Red or blue spinner}
; @subid_02{Arrow indicating spinner direction}
; @X{Bitmask for wSpinnerState; each spinner in a dungeon should use a unique bit.}
; @postype{short}
.define INTERAC_SPINNER $7d

;;
; @subid_00{Miniboss portal; always in center of room}
; @subid_01{Portal in hero's cave; position can be set in Y. Enabled if ROOMFLAG_ITEM
;           (bit 5) in that room is set.
;           @postype{short}}
; @X{For subid 1 only, bits 0-3 are the index for the warp data. If bit 7 is set,
;    ROOMFLAG_ITEM must be set in that room for it to be enabled; otherwise it's always
;    enabled.}
.define INTERAC_MINIBOSS_PORTAL $7e

;;
; Essence on a pedestal (or the pedestal itself).
;
; @subid_00{The essence itself (spawns subids $01 and $02}
; @subid_01{Pedestal}
; @subid_02{The glow behind the essence}
.define INTERAC_ESSENCE $7f

;;
; @subid_00{A tiny sparkle that disappears in an instant.}
; @subid_01{Used by INTERAC_TIMEWARP}
; @subid_02{Used by INTERAC_MAKUCONFETTI, INTERAC_GREAT_FAIRY}
; @subid_03{Used by INTERAC_MAKU_SEED_AND_ESSENCES}
; @subid_04{Big, red-and-blue orb; used by INTERAC_MAKU_SEED_AND_ESSENCES, INTERAC_GREAT_FAIRY}
; @subid_05{?}
; @subid_06{Glowing orb behind Link in the intro cutscene, on the triforce screen}
; @subid_07{Used by tuni nut while being placed}
; @subid_08{?}
; @subid_09{?}
; @subid_0a{Used by INTERAC_GREAT_FAIRY}
; @subid_0b{Used by INTERAC_MAKU_SEED (but in an unused function?)}
; @subid_0c{Used by harp of ages in nayru's house}
; @subid_0d{?}
; @subid_0e{Used by bomb upgrade fairy}
; @subid_0f{Used by INTERAC_MAKU_SEED}
.define INTERAC_SPARKLE $84

;;
; @subid_00{Vasu}
; @subid_01{Blue snake}
; @subid_06{Red snake}
.define INTERAC_VASU $89

;;
; Bubbles created at random when swimming in a sidescrolling area.
;
; @subid_00{A bubble.}
; @subid_01{Spawns bubbles every 90 frames until bit 7 of relatedObj1.collisionType is 0.}
.define INTERAC_BUBBLE $91

;;
; Wooden tunnel thing used in Seasons.
;
; @subid_00{Upper half}
; @subid_01{Lower half}
; @subid_02{Right half}
; @subid_03{Left half}
.define INTERAC_WOODEN_TUNNEL $98

;;
; counter1: Number of frames to stay up. If 0 or $ff, it stays up indefinitely.
.define INTERAC_EXCLAMATION_MARK $9f

;;
; An image which moves up and to the left or right for 70 frames, then disappears.
;
; @subid_00{"Z" letter for a snoring character}
; @subid_01{A musical note}
; @var03_00{Veer left}
; @var03_01{Veer right}
.define INTERAC_FLOATING_IMAGE $a0

;;
; See 'movingSidescrollPlatformScriptTable' for movement patterns of each subid.
.define INTERAC_MOVING_SIDESCROLL_PLATFORM $a1

;;
; Similar to above, but the platform has conveyor belts on it.
; See 'movingSidescrollConveyorScriptTable' for movement patterns of each subid.
.define INTERAC_MOVING_SIDESCROLL_CONVEYOR $a2

;;
; @subid_00{?}
; @subid_01{?}
; @subid_02{The child}
.define INTERAC_ENDGAME_CUTSCENE_BIPSOM_FAMILY $a7

;;
; Responsible for controlling various credits cutscenes? High nibble of subid seems to be an index
; corresponding to the animal.
;
; @subid_00{Ricky?}
; @subid_01{Dimitri?}
; @subid_02{Moosh?}
; @subid_03{Maple?}
; @subid_04{Responsible for credits cutscenes such as link showing ralph swordplay, among others?}
.define INTERAC_a8 $a8

;;
; Decides which objects need to be spawned in the bipin/blossom family.
;
; @subid_00{Left side of house}
; @subid_01{Right side of house}
.define INTERAC_BIPIN_BLOSSOM_FAMILY_SPAWNER $ac

;;
; Used for the credits text in between the mini-cutscenes.
;
; @subid_00{Enter from right}
; @subid_01{Enter from left)
; @var03{?}
.define INTERAC_CREDITS_TEXT_HORIZONTAL $ae

;;
; Used for the credits after the cutscenes.
;
; @subid_00{?}
; @subid_01{?}
.define INTERAC_CREDITS_TEXT_VERTICAL $af

;;
; Energy thing that appears when you enter the final dungeon for the first time
.define INTERAC_FINAL_DUNGEON_ENERGY $b5

;;
; @subid{A unique value from $0-$f used as an index for wGashaSpot variables. Each subid
;        has a predetermined "class" determining how good its loot is (see
;        "@gashaSpotRanks").\n
;        Internally, this is copied to var03 when the subid gets overwritten with the
;        index of the treasure received.}
.define INTERAC_GASHA_SPOT $b6

;;
; These are little hearts that float up when Zelda kisses Link in the ending cutscene.
.define INTERAC_KISS_HEART $b7

;;
; Dog in Horon Village credits cutscene (unused in Ages)
.define INTERAC_HORON_DOG_CREDITS $b9

;;
; Banana carried by Moosh in credits cutscene.
.define INTERAC_BANANA $c0

;;
; A sparkle which stays in place for a bit, then moves down-left off screen?
.define INTERAC_c1 $c1

;;
; Creates an object of the given type with the given ID at every position where there's
; a tile of the specified index, then deletes itself.
;
; @subid{Tile index; an object will be spawned at each tile with this index.}
; @Y{ID of object to spawn}
; @X{bits 0-3: Subid of object to spawn;\n
;    bits 4-7: object type (0=enemy, 1=part, 2=interaction)}
.define INTERAC_CREATE_OBJECT_AT_EACH_TILEINDEX $c7

;;
; Not to be confused with INTERAC_DEKU_SCRUB. This is divided into two parts, the scrub
; itself (subids $00-$7f) and the bush above it (subid $80).
;
; @subid_00{Sells shield (expensive); subids 1-2 reserved for different shield levels}
; @subid_03{Sells shield (moderate); subids 5-6 reserved for different shield levels}
; @subid_06{Sells shield (cheap); subids 7-8 reserved for different shield levels}
; @subid_09{Sells bombs (missing some data, doesn't work)}
; @subid_0a{Sells ember seeds (missing some data)}
; @subid_80{The "bush" the scrub hides under; spawned automatically}
.define INTERAC_BUSINESS_SCRUB $ce

;;
; Some weird, corrupted animation?
.define INTERAC_cf $cf

;;
; Shows text explaining how to use the companions' abilities on certain screens. Most of
; these set bits in wCompanionTutorialTextShown so the explanation only happens once.
;
; @subid_00{Ricky hopping over holes}
; @subid_01{Ricky jumping over cliffs}
; @subid_02{Unused (should be "carrying dimitri"?)}
; @subid_03{Dimitri swimming up waterfalls}
; @subid_04{Moosh fluttering}
; @subid_05{Moosh buttstomp (unused in ages)}
.define INTERAC_COMPANION_TUTORIAL $d0

;;
; Shows the dialog after completing the game prompting you to save (unlinked only).
.define INTERAC_GAME_COMPLETE_DIALOG $d1

;;
; Titlescreen "clouds" on left/right sides when scrolling to the game logo.
;
; @subid_00{3rd from left}
; @subid_01{2nd from left}
; @subid_02{4th from the left}
; @subid_03{1st from the left}
.define INTERAC_TITLESCREEN_CLOUDS $d2

;;
; Birds used while scrolling up the tree before the titlescreen
; @subid{Value from 0-7}
.define INTERAC_INTRO_BIRD $d3

;;
; Link's ship shown after credits in linked game. Lower nibble of subid determines the
; object (ship/seagull/text), while the upper nibble determines the value for counter1
; (which affects the "cycle" that the seagull is on, in terms of bobbing up and down)
;
; @subid_00{The ship}
; @subid_01{Seagull}
; @subid_02{"The End" text}
.define INTERAC_LINK_SHIP $d4

;;
; @subid{The index of the secret (value of "wShortSecretIndex"?). This either creates
;        a chest or just gives the item to Link (if it's an upgrade).}
.define INTERAC_FARORE_GIVEITEM $d9

;;
; In the room of rites with Zelda, this triggers the twinrova battle when Link gets too
; close to Zelda.
.define INTERAC_ZELDA_APPROACH_TRIGGER $da

;;
; Nayru grocery shopping with Ralph in the credits.
; @subid_00{Nayru}
; @subid_01{Ralph}
.define INTERAC_NAYRU_RALPH_CREDITS $df

;;
; Blurb that displays the season/era at the top of the screen when entering an area.
;
; @subid_00{Present (but this is set by its own code)}
; @subid_01{Past (but this is set by its own code)}
.define INTERAC_ERA_OR_SEASON_INFO $e0

;;
; Eyeball that looks at Link. (Note, spawners aren't designed to work in small rooms?)
;
; @subid_00{Like subid 2 but the eye extends a but further}
; @subid_01{Spawner for subid 2; spawns eyeballs at each corresponding statue position}
; @subid_02{Normal eyeball looking at Link}
; @subid_03{Spawner for subid 4 (final dungeon eyeball puzzle)}
; @subid_04{Final dungeon eyeballs (looking away from direction to go)}
.define INTERAC_STATUE_EYEBALL $e2

;;
; @subid_00{Blue snake help book}
; @subid_01{Red snake help book}
.define INTERAC_RING_HELP_BOOK $e5


; ==============================================================================
; Ages only
; ==============================================================================

.ifdef ROM_AGES

;;
; Controls the red/yellow/blue floor tiles that toggle when jumped over.
;
; @subid_00{"Parent" interaction; constantly checks Link's position and spawns subid1 when
;           appropriate.}
; @subid_01{Toggles tile at position [var03] when Link lands, then deletes itself.}
.define INTERAC_TOGGLE_FLOOR $15

;;
; For torch puzzles.
;
; Subid: initial orientation of cube (0-5)
;
; @palette{PALH_89}
.define INTERAC_COLORED_CUBE $19

;;
; A flame that appears when the colored cube is put in the right place.
.define INTERAC_COLORED_CUBE_FLAME $1a

;;
; Subid bits 0-2:\n
;   Index of bit in wSwitchState which controls the gate.
;
; Subid bits 4-7:\n
;   0: barrier extends left.\n
;   2: barrier extends right.
.define INTERAC_MINECART_GATE $1b

.define INTERAC_STUB_1d $1d

;;
; @subid_00{Trigger a warp when Link dives here. (X should be 0 or 1, indicating where
;       to warp to, while Y is the short-form position.)}
; @subid_01{Trigger a warp at the top of a waterfall (only if riding dimitri)}
; @subid_02{Trigger a warp in a cave in a waterfall (only if riding Dimitri)}
.define INTERAC_SPECIAL_WARP $1f

;;
; Runs assembly code for specific dungeon events. Similar in purpose to INTERAC_MISC_PUZZLES?
;
; @subid_00{Nothing}
; @subid_01{d2: verify a 2x2 floor pattern, drop a key.}
; @subid_02{d2: verify that a floor tile is red to open a door.}
; @subid_03{Light torches when a colored cube rolls into this position.}
; @subid_04{d2: Set torch color based on the color of the tile at this position.}
; @subid_05{d2: Drop a small key here when a colored block puzzle has been solved.}
; @subid_06{d2: Set trigger 0 when the colored flames are lit red.}
; @subid_07{Toggle a bit in wSwitchState based on whether a toggleable floor tile at
;        position Y is blue. The bitmask to use is X.}
; @subid_08{Toggle a bit in wSwitchState based on whether blue flames are lit. The bitmask
;        to use is X.}
; @subid_09{d3: Drop a small key when 3 blocks have been pushed.}
; @subid_0a{d3: When an orb is hit, spawn an armos, as well as interaction which will spawn
;            a chest when it's killed.}
; @subid_0b{Unused? A chest appears when 4 torches in a diamond formation are lit?}
; @subid_0c{d3: 4 armos spawn when trigger 0 is activated.}
; @subid_0d{d3: Crystal breakage handler}
; @subid_0e{d3: Small key falls when a block is pushed into place}
; @subid_0f{d4: A door opens when a certain floor pattern is achieved}
; @subid_10{d4: A small key falls when a certain froor pattern is achieved}
; @subid_11{Tile-filling puzzle: when all the blue turns red, a chest will spawn here.}
; @subid_12{d4: A chest spawns here when the torches light up with the color blue.}
; @subid_13{d5: A chest spawns here when all the spaces around the owl statue are filled.}
; @subid_14{d5: A chest spawns here when two blocks are pushed to the right places}
; @subid_15{d5: Cane of Somaria chest spawns here when blocks are pushed into a pattern}
; @subid_16{d5: Sets floor tiles to show a pattern when a switch is held down.}
; @subid_17{Create a chest at position Y which appears when [wActiveTriggers] == X, but which
;        also disappears when the trigger is released.}
; @subid_18{d3: Calculate the value for [wSwitchState] based on which crystals are broken.}
; @subid_19{d1: Set trigger 0 when the colored flames are lit blue.}
.define INTERAC_DUNGEON_EVENTS $21

;;
; When a tile at this position is jumped over, all colored floor tiles in the room change
; colors.
;
; @subid_00{The "controller"}
; @subid_01{Instance that's spawned by the controller to perform the replacement.}
.define INTERAC_FLOOR_COLOR_CHANGER $22

;;
; Extends or retracts a bridge when a bit in wSwitchState changes.
;
; Subid: bits 0-2: bit in wSwitchState to watch
;
; @Y{YX position}
; @X{Index of bridge data}
; @postype{short}
.define INTERAC_EXTENDABLE_BRIDGE $23

;;
; Controls a bit in wActiveTriggers based on various things.
;
; Subid bits 0-3:\n
;   0: Control a bit in wActiveTriggers based on wToggleBlocksState.\n
;   1: Control a bit in wActiveTriggers based on wSwitchState.\n
;   2: Control a bit in wActiveTriggers based on if [wNumLitTorches] == Y.
;
; Subit bits 0-4: Index of a bit to check in wToggleBlocksState or wSwitchState (subids 0 and
;                 1 only)
;
; @Y{Number of torches to be lit (subid 2 only)}
; @X{a bitmask for wActiveTriggers (subid 2 only)}
.define INTERAC_TRIGGER_TRANSLATOR $24

;;
; Keeps track of the yellow tile in the tile-filling puzzles and updates the floor color.
; Starting position is determined by Y and X.
;
; To complete the tile-filling puzzle, an interaction with id $2111 should also exist;
; that will spawn the chest.
.define INTERAC_TILE_FILLER $25

.define INTERAC_STUB_26 $26
.define INTERAC_STUB_27 $27

;;
; subid does nothing.
.define INTERAC_ADLAR $29

;;
; Librarian at eyeglasses library.
; subid does nothing.
.define INTERAC_LIBRARIAN $2a

;;
; The wallmaster used in black tower escape cutscene?
.define INTERAC_VERAN_CUTSCENE_WALLMASTER $2c

;;
; Veran's face used in cutscene just before final battle
; @palette{PALH_87}
.define INTERAC_VERAN_CUTSCENE_FACE $2d

;;
; Old man who gives or takes money. His position is hardcoded. Uses room flag $40.
;
; Subid: 0 gives 200 rupees, 1 takes 100 rupees.
.define INTERAC_OLD_MAN_WITH_RUPEES $2e

;;
; Plays MUS_NAYRU and lowers volume if GLOBALFLAG_INTRO_DONE is not set.
.define INTERAC_PLAY_NAYRU_MUSIC $2f

;;
; @subid_00{Human npc}
; @subid_01{Goron npc}
; @subid_02{Elder npc (biggoron's sword minigame)}
; @subid_03{Controls the game itself}
.define INTERAC_SHOOTING_GALLERY $30

;;
; @subid_00{First meet at the start of the game}
; @subid_01{Talking after nayru is kidnapped}
; @subid_02{Credits cutscene}
; @subid_03{Saved Zelda cutscene?}
; @subid_04{Cutscene at black tower entrance where Impa warns about Ralph's heritage}
; @subid_05{Like subid 4, but for linked game}
; @subid_06{?}
; @subid_07{Tells you that Zelda's been kidnapped by vire}
; @subid_08{During Zelda kidnapped event}
; @subid_09{Tells you that Zelda's been kidnapped by twinrova}
; @subid_0a{? (doesn't have a script)}
.define INTERAC_IMPA_IN_CUTSCENE $31

;;
; A fake octorok.
; @subid_00{Octorok attacking impa. (var03 is a value from 0-2 for the index.)}
; @subid_02{Great fairy turned into an octorok.}
.define INTERAC_FAKE_OCTOROK $32

;;
; Not really the boss itself, but this basically "runs" the fight?
;
; Subid: this should be $ff; it's incremented each time an enemy is spawned to keep track
;        of the enemy index to spawn next.
.define INTERAC_SMOG_BOSS $33

;;
; The stone that's pushed at the start of the game. After it's moved, this stone is
; handled by PART_TRIFOCE_STONE instead.
.define INTERAC_TRIFORCE_STONE $34

;;
; @subid_00{Cutscene at the beginning of game (talking to Link, then gets possessed)}
; @subid_01{Cutscene in Ambi's palace after getting bombs}
; @subid_02{Cutscene on maku tree screen after being saved}
; @subid_03{Cutscene with Nayru and Ralph when Link exits the black tower}
; @subid_04{Cutscene at end of game with Ambi and her guards}
; @subid_05{?}
; @subid_06{?}
; @subid_07{Cutscene with the vision of Nayru teaching you Tune of Echoes}
; @subid_08{Cutscene after saving Zelda?}
; @subid_09{Cutscene where Ralph's heritage is revealed (unlinked?)}
; @subid_0a{Cutscene where Ralph's heritage is revealed (linked?)}
; @subid_0b{NPC after being saved}
; @subid_0c{NPC between being told about Ralph's heritage and beating Veran (linked?)}
; @subid_0d{NPC after Veran is beaten (linked)}
; @subid_0e{?}
; @subid_0f{NPC after getting maku seed, but before being told about Ralph's heritage}
; @subid_10{Cutscene in black tower where Nayru/Ralph meet you to try to escape}
; @subid_11{Cutscene on white background with Din just before facing Twinrova}
; @subid_12{?}
; @subid_13{NPC after completing game (singing to animals)}
.define INTERAC_NAYRU $36

;;
; @subid_00{Cutscene where Nayru gets possessed}
; @subid_01{Cutscene outside Ambi's palace before getting mystery seeds}
; @subid_02{Cutscene after Nayru is possessed}
; @subid_03{Cutscene after talking to Rafton}
; @subid_04{Cutscene on maku tree screen after saving Nayru}
; @subid_05{Cutscene in black tower where Nayru/Ralph meet you to try to escape}
; @subid_06{Cutscene at end of game with Ambi and her guards "confronting" Link}
; @subid_07{Cutscene postgame where they warp to the maku tree, Ralph notices the statue}
; @subid_08{Cutscene in credits where Ralph is training with his sword}
; @subid_09{Cutscene where Ralph charges in to Ambi's palace}
; @subid_0a{Cutscene where Ralph's about to charge into the black tower}
; @subid_0b{Cutscene where Ralph tells you about getting Tune of Currents}
; @subid_0c{Cutscene where Ralph confronts Ambi in black tower}
; @subid_0d{Cutscene where Ralph goes back in time}
; @subid_0e{Cutscene with Nayru and Ralph when Link exits the black tower}
; @subid_0f{Does nothing but stand there, facing right}
; @subid_10{Cutscene after talking to Cheval}
; @subid_11{NPC after finishing the game}
; @subid_12{NPC after beating Veran, before beating Twinrova in a linked game}
.define INTERAC_RALPH $37

;;
; Subid: only $00 is valid
.define INTERAC_PAST_GIRL $38

;;
; @subid_00{Listening to Nayru sing at beginning of game}
; @subid_01{Monkey disappearance cutscene (spawns multiple monkeys; var03 is monkey index)}
; @subid_02{Monkey that only exists before intro}
; @subid_03{Monkey that only exists before intro}
; @subid_04{?}
; @subid_05{Spawns more monkeys}
; @subid_06{?}
; @subid_07{A monkey npc depending on var03: \n
;      0: Appears between saving Nayru and beating game \n
;      1: Listening to Nayru after beating game \n
;      2: Appears between saving Maku tree and beating game}
.define INTERAC_MONKEY $39

;;
; This guy's appearance changes based on his subid. Has "present" and "past" versions, and
; can also be a "construction worker" in the black tower?
;
; @subid_00{Cutscene where guy is struck by lightning in intro}
; @subid_01{Past villager?}
; @subid_02{Guard blocking entrance to black tower}
; @subid_03{Guy in front of present maku tree screen}
; @subid_04{"Sidekick" to the comedian guy}
; @subid_05{Guy in front of shop}
; @subid_06{Villager in front of past maku tree screen}
; @subid_07{Villager in past near Ambi's palace}
; @subid_08{Villager outside house hear black tower}
; @subid_09{Villager who turns to stone in a cutscene?}
; @subid_0a{Villager turned to stone?}
; @subid_0b{Villager being restored from stone, resumes playing catch}
; @subid_0c{Villager playing catch with son}
; @subid_0d{Cutscene when you first enter the past}
; @subid_0e{Stone villager - during Zelda kidnapped event}
.define INTERAC_MALE_VILLAGER $3a

;;
; Like male villager, this person's appearance changes based on subid, with present and
; past versions.
;
; @subid_00{Cutscene where guy is struck by lightning in intro}
; @subid_01{Present NPC near black tower}
; @subid_02{Present NPC outside shop}
; @subid_03{Past NPC south of shooting gallery screen}
; @subid_04{Past NPC just outside black tower}
; @subid_05{Past villager}
; @subid_06{Linked game NPC}
; @subid_07{NPC in eyeglasses library (present)}
; @subid_08{Present NPC in the house above the ocean}
.define INTERAC_FEMALE_VILLAGER $3b

;;
; @subid_00{Listening to Nayru sing in intro}
; @subid_01{Kid turning to stone cutscene}
; @subid_02{Kid outside shop}
; @subid_03{Cutscene where kids talk about how they're scared of a ghost (red kid)}
; @subid_04{Cutscene where kids talk about how they're scared of a ghost (green kid)}
; @subid_05{Cutscene where kid is restored from stone}
; @subid_06{Cutscene where kid sees his dad turn to stone}
; @subid_07{Depressed kid in trade sequence}
; @subid_08{Kid who runs around in a pattern? Used in a credits cutscene maybe?}
; @subid_09{Same as $08, but different pattern.}
; @subid_0a{Cutscene?}
; @subid_0b{NPC in eyeglasses library present}
; @subid_0c{Cutscene where kid's dad gets restored from stone}
; @subid_0d{Kid with grandma who's either stone or was restored from stone}
; @subid_0e{NPC playing catch with dad, or standing next to his stone dad}
; @subid_0f{Cutscene where kid runs away - during Zelda kidnapped event}
; @subid_10{Listening to Nayru sing in endgame}
.define INTERAC_BOY $3c

;;
; Old lady in the present.
;
; @subid_00{NPC with a grandson that is stone for part of the game}
; @subid_01{Cutscene where her grandson gets turned to stone}
; @subid_02{NPC in present, screen left from bipin&blossom's house}
; @subid_03{Cutscene where her grandson is restored from stone}
; @subid_04{Linked game NPC (clock shop secret)}
; @subid_05{Linked game NPC (ruul secret)}
.define INTERAC_OLD_LADY $3d

;;
; @subid_00{Cutscene at start of game (unpossessing Impa)}
; @subid_01{Cutscene just before fighting possessed Ambi}
; @subid_02{Cutscene just after fighting possessed Ambi}
.define INTERAC_GHOST_VERAN $3e

;;
; Boy with sort of hostile-looking eyes?
;
; @subid_00{Boy in deku forest; appears only before getting bombs}
; @subid_01{Boy at top-left of Lynna city; only appears between beating d7 and getting maku sed}
; @subid_02{Boy in cutscene near spirit's grave}
; @subid_03{Used in linked game credits maybe?}
.define INTERAC_BOY_2 $3f

;;
; @subid_00{?}
; @subid_01{?}
; @subid_02{Left palace guard}
; @subid_03{?}
; @subid_04{?}
; @subid_05{Guard escorting Link in intermediate screens (just moves straight up)}
; @subid_06{Guard in cutscene who takes mystery seeds from Link}
; @subid_07{Guard just after Link is escorted out of the palace}
; @subid_08{Used in a cutscene? (doesn't do anything)}
; @subid_09{Right palace guard}
; @subid_0a{Red soldier that brings you to Ambi (escorts you from deku forest)}
; @subid_0b{Red soldier that brings you to Ambi (just standing there after escorting you)}
; @subid_0c{?}
; @subid_0d{Friendly soldier after finishing game. var03 is soldier index.}
.define INTERAC_SOLDIER $40

;;
; @subid_00{Guy standing outside d2 (before you get bombs)}
; @subid_01-05{Old man who hangs out around lynna city. Each subid is for a different phase
;          in the game, all mutually exclusive)}
.define INTERAC_MISC_MAN $41

;;
; @subid_00{Guy telling you about there being seeds in the woods}
; @subid_01{Guy in past telling you about how his island drifts}
.define INTERAC_MUSTACHE_MAN $42

;;
; @subid_00{Guy who wants to find something Ambi desires}
; @subid_01-02{Some NPC (same guy, but different locations for different game stages)}
; @subid_03{Guy in a cutscene (turning to stone?)}
; @subid_04{Guy in a cutscene (stuck as stone?)}
; @subid_05{Guy in a cutscene (being restored from stone?)}
; @subid_06{Guy watching family play catch (or is stone)}
; @subid_07{Guy turned to stone - during Zelda kidnapped event}
.define INTERAC_PAST_GUY $43

;;
; @subid_00{NPC giving hint about what ambi wants}
; @subid_01{NPC in start-of-game cutscene who turns into an old man}
; @subid_02-03{Bearded NPC in Lynna City}
; @subid_04{Bearded hobo in the past, outside shooting gallery}
.define INTERAC_MISC_MAN_2 $44

;;
; @subid_00{Old lady whose husband was sent to work on black tower}
; @subid_01{Old lady hanging around lynna village}
.define INTERAC_PAST_OLD_LADY $45

;;
; @subid_00-04{Tokays in cutscene who steal your stuff}
; @subid_05{NPC who trades meat for stink bag}
; @subid_06{Past NPC holding sword}
; @subid_07{Past NPC holding shovel}
; @subid_08{Past NPC holding harp}
; @subid_09{Past NPC holding flippers}
; @subid_0a{Past NPC holding seed satchel}
; @subid_0b{Linked game cutscene where tokay runs away from Rosa}
; @subid_0c{Participant in Wild Tokay game}
; @subid_0d{Past NPC in charge of wild tokay game}
; @subid_0e{Shopkeeper (trades items)}
; @subid_0f-10{Tokays who try to eat Dimitri}
; @subid_11{Past NPC looking after scent seedling}
; @subid_12{Present NPC outside museum}
; @subid_13{Present NPC below time portal}
; @subid_14{Present NPC outside cook's hut}
; @subid_15{Past NPC outside trading hut}
; @subid_16{Past NPC outside wild tokay game}
; @subid_17{Past NPC standing next to time portal}
; @subid_18{Past NPC on southeast shore}
; @subid_19{Present NPC in charge of the wild tokay museum}
; @subid_1a-1c{Tokay "statues" in the wild tokay museum}
; @subid_1d{NPC holding shield upgrade}
; @subid_1e{Present NPC who talks to you after climbing down vine}
; @subid_1f{Past NPC standing on cliff at north shore}
.define INTERAC_TOKAY $48

;;
; @subid_00{Fairy just discovered in their hiding place?}
; @subid_01{Discovered fairy who's now hanging out in "main" forest screen, until you
;   finish the game.}
; @subid_02{Unused?}
; @subid_03{Fairy that leads you to the animal companion in the forest (used on at least
;   3-4 screens, with var03 determining their exact behaviour)}
; @subid_04{Fairies surrounding the companion after being rescued from the forest}
; @subid_05-07{Generic NPC (between completing the maze and entering jabu)}
; @subid_08-0a{Generic NPC (between jabu and finishing the game)}
; @subid_0b{NPC in unlinked game who takes a secret}
; @subid_0c-0d{Generic NPC (after beating game)}
; @subid_0e-10{Generic NPC (while looking for companion trapped in woods)}
.define INTERAC_FOREST_FAIRY $49

;;
; @subid_00{Listening to Nayru at the start of the game}
; @subid_01{Rabbit hopping through screen (cutscene where they turn to stone)
;           If counter1 is nonzero, it will turn to stone once it hits 0.}
; @subid_02{"Controller" for the cutscene where rabbits turn to stone? (spawns subid $01)}
; @subid_03{Rabbit being restored from stone cutscene (gets restored and jumps away)}
; @subid_04{Rabbit being restored from stone cutscene (the one that wasn't stone)}
; @subid_05{Rabbit being restored from stone cutscene (bonks into other bunney)}
; @subid_06{Stone bunny (between jabu and beating the game)}
; @subid_07{Generic NPC waiting around in the spot Nayru used to sing}
.define INTERAC_RABBIT $4b

;;
; Not to be confused with INTERAC_KNOW_IT_ALL_BIRD.
;
; @subid_00{Listening to Nayru at the start of the game}
; @subid_01-03{Different colored birds that do nothing but hop? Used in a cutscene?}
; @subid_04{Bird with Impa when Zelda gets kidnapped}
.define INTERAC_BIRD $4c

;;
; @subid_00{Cutscene where you give mystery seeds to Ambi}
; @subid_01{Cutscene after escaping black tower}
; @subid_02{Credits cutscene where Ambi observes construction of Link statue}
; @subid_03{Cutscene where Ambi does evil stuff atop black tower (after d7)}
; @subid_04{Same cutscene as subid $03 (black tower after d7), but second part}
; @subid_05{Cutscene where Ralph confronts Ambi}
; @subid_06{Cutscene just before fighting possessed Ambi}
; @subid_07{Cutscene where Ambi regains control of herself}
; @subid_08{Cutscene after d3 where you're told Ambi's tower will soon be complete}
; @subid_09{Does nothing?}
; @subid_0a{NPC after Zelda is kidnapped}
.define INTERAC_AMBI $4d

;;
; @subid_00{Subrosian in lynna village (linked only)}
; @subid_01{Subrosian in goron dancing game (while dancing game is active?)}
; @subid_02{Subrosian in goron dancing game (var03 is 0 or 1 for green or red npcs)}
; @subid_03{Linked game NPC telling you the subrosian secret (for bombchus)}
; @subid_04{Linked game NPC telling you the smith secret (for shield upgrade)}
.define INTERAC_SUBROSIAN $4e

;;
; Impa as an npc at various stages in the game. There's also INTERAC_IMPA_IN_CUTSCENE.
;
; @subid_00{Impa in Nayru's house}
; @subid_01{Impa in past (after telling you about Ralph's heritage)}
; @subid_02{Impa after Zelda's been kidnapped}
; @subid_03{Impa after getting the maku seed}
.define INTERAC_IMPA_NPC $4f

;;
.define INTERAC_STUB_50 $50

;;
; The guy who you trade a dumbbell to for a mustache
.define INTERAC_DUMBBELL_MAN $51

;;
; An old man NPC. Note: INTERAC_OLD_MAN_WITH_RUPEES uses the same sprites.
;
; @subid_00{Old man who takes a secret to give you the shield (same spot as subid $02)}
; @subid_01{Old man who gives you book of seals}
; @subid_02{Old man guarding fairy powder in past (same spot as subid $00)}
; @subid_03-06{Generic NPCs in the past library}
.define INTERAC_OLD_MAN $52

;;
; The dog lover.
;
; @subid_00{Only valid subid value}
.define INTERAC_MAMAMU_YAN $53

;;
; Mamamu Yan's dog.
;
; @subid_00{Dog in mamamu's house}
; @subid_01{Dog outside that Link needs to find for a "sidequest". var03 is the map index (0-3).}
.define INTERAC_MAMAMU_DOG $54

;;
; Postman who trades you the stationary for a poe clock.
.define INTERAC_POSTMAN $55

;;
; Worker with a pickaxe.
;
; @subid_00{Worker below Maku Tree screen in past}
; @subid_01{Credits cutscene guy making Link statue?}
; @subid_02{Credits cutscene guy making Link statue?}
; @subid_03{Worker in black tower. Var03 is an index which determines their animation.}
.define INTERAC_PICKAXE_WORKER $57

;;
; Worker with a hardhat.
;
; @subid_00{NPC who gives you the shovel. If var03 is nonzero, he's just a generic guy.}
; @subid_01{Generic NPC. Var03 is 0 or 1; these npcs appear in the early and middle phases
;           of the black tower's construction, respectively.}
; @subid_02{NPC who guards the entrance to the black tower.}
; @subid_03{A patrolling NPC. var03 is a value from 0-4 determining his patrol route and
;           text.}
.define INTERAC_HARDHAT_WORKER $58

;;
; Ghost who starts the trade sequence. Subid does nothing.
;
; Var03: 0 when first encountered; 1 in the tomb; 2 when talking after that.
.define INTERAC_POE $59

;;
; Zora who trades you the broken sword for a guitar.
.define INTERAC_OLD_ZORA $5a

;;
; Trades you the stink bag for the stationary.
.define INTERAC_TOILET_HAND $5b

;;
; Gives you a doggie mask for tasty meat.
.define INTERAC_MASK_SALESMAN $5c

;;
; Red bear who listens to Nayru.
;
; @subid_00{Bear listening to Nayru at start of game.}
; @subid_01{Doesn't do anything, just a decoration?}
; @subid_02{Bear NPC, depending value of var03.
;           var03=0: The bear on screen where Nayru is kidnapped (after that cutscene);
;           also spawns other animals.
;           var03=1: The bear listening to Nayru after the game is complete.}
.define INTERAC_BEAR $5d

;;
; A sword, as used by Ralph. Doesn't have collisions?
;
; The animation is set by [relatedObj1.animParameter]; let this be p. Then, the sword is
; made visible when bit 7 of p is set, and the animation number is (p&0x7f). Effectively,
; this allows an interaction's animation to control both itself and the sword.
;
; var3f: When ([this.var3f]+1)&[relatedObj1.enabled] == 0, this object deletes itself?
.define INTERAC_SWORD $5e

;;
; Not maple syrup, syrup the witch
.define INTERAC_SYRUP $5f

;;
; A lever that Link can pull with the power bracelet.
;
; Bit 0 of subid is 0 to pull downward, 1 to pull upward.
;
; Bits 4-5 of subid indicate the distance to pull the lever.
;   0: 8 pixels, 1: $10 pixels, 2: $20 pixels, 3: $40 pixels.
;
; Bit 6 of subid is the "lever index" (0 or 1). This determines whether it writes to
; wLever1PullDistance or wLever2PullDistance. (Scripts will read from here to give the
; lever its functionality.)
;
; Bit 7 of the subid is set if this is the "extending" part of the lever (you normally
; don't need to worry about this).
;
; var03: ?
.define INTERAC_LEVER $61

;;
; A flower or sprout thing that falls when the maku tree communicates with you.
;
; @subid_00{Present (flowers)}
; @subid_01{Past (sprout things)}
.define INTERAC_MAKU_CONFETTI $62

;;
; An accessory is a sprite attached to another interaction. Like INTERAC_SWORD, it reads
; variables from relatedObj1 to place it relative to its "parent". Subid determines the
; graphic.
;
; @subid_3d{Monkey bow}
; @subid_3f{Ball used by villagers (only in cutscene; when actually used it's
;           INTERAC_BALL)}
; @subid_73{Meat in tokay game}
;
; var03: If zero, accessory is placed 12 pixels above relatedObj1 with draw priority 0.
;        If nonzero, it reads from a hardcoded table with index
;        [relatedObj1.animParameter] to set Y/X offsets, draw priority, and animation.
.define INTERAC_ACCESSORY $63

;;
; Components of the raftwreck cutscene (used by INTERAC_RAFTWRECK_CUTSCENE).
;
; @subid_00{A leaf being blown}
; @subid_01{A rock being blown}
; @subid_02{A monkey being blown}
; @subid_03{Gentle wind with leaves and rocks}
; @subid_04{Harsher wind including a monkey}
; @subid_05{Final 3 lightning strikes}
.define INTERAC_RAFTWRECK_CUTSCENE_HELPER $64

;;
; Gives you the funny joke for the cheesy mustache
.define INTERAC_COMEDIAN $65

;;
; @subid_00{Graceful goron?}
; @subid_01{Goron support dancer; text differs if in the past between linked/unlinked.
;           Var03 ranges from 0-6.}
; @subid_02{A "fake" goron object that manages jumping in the dancing minigame?}
; @subid_03{Cutscene where goron appears after beating d5; the guy who digs a new tunnel.}
; @subid_04{Goron pacing back and forth, worried about elder}
; @subid_05{An NPC in the past cave near the elder? var03 ranges from 0-5.}
; @subid_06{NPC trying to break the elder out of the rock.
;           var03 is $00 for the goron on the left, $01 for the one on the right.}
; @subid_07{Goron trying to break wall down to get at treasure}
; @subid_08{Goron guarding the staircase until you get brother's emblem (both eras)}
; @subid_09{Target carts gorons; var03 = 0 or 1 for gorons on left and right.}
; @subid_0a{Goron who gives you letter of introduction}
; @subid_0b{Goron running the big bang game}
; @subid_0c{Generic npc; text changes based on game state.}
; @subid_0d{Generic npc like subid $0c, but moving left and right.}
; @subid_0e{Generic npc like subid $0c, but naps when Link isn't near.}
; @subid_0f{Linked NPC telling you the biggoron secret.}
; @subid_10{Clairvoyant goron who gives you tips.}
.define INTERAC_GORON $66

;;
; Spawns companions in various situations.
; For subids other than $80, this is accompanied by an instance of INTERAC_COMPANION_SCRIPTS?
;
; @subid_00{Moosh being attacked by ghosts}
; @subid_01{Moosh saying goodbye after getting cheval rope}
; @subid_02{Ricky looking for gloves}
; @subid_03{Dimitri being attacked by hungry tokays}
; @subid_04{Companion lost in forest}
; @subid_05{Cutscene outside forest where you get the flute}
; @subid_80{Flute call for companion}
.define INTERAC_COMPANION_SPAWNER $67

;;
; @subid_00{Gives you the shovel on tokay island, linked only}
; @subid_01{Rosa at goron dance, linked only}
.define INTERAC_ROSA $68


;;
; @subid_00{Rafton in left part of house}
; @subid_01{Rafton in right part of house}
.define INTERAC_RAFTON $69

;;
; @subid_00{Cheval; only valid subid}
.define INTERAC_CHEVAL $6a

;;
; Many miscellaneous things here, categorized by subid. See also INTERAC_MISCELLANEOUS_2.
;
; @subid_00{Handles showing Impa's "Help" text when Link's about to screen transition}
; @subid_01{Spawns nayru, ralph, animals before she's possessed}
; @subid_02{Script for cutscene with Ralph outside Ambi's palace, before getting mystery seeds}
; @subid_03{Seasons troupe member with guitar?}
; @subid_04{Script for cutscene where moblins attack maku sapling}
; @subid_05{Cutscene in intro where lightning strikes a guy}
; @subid_06{Manages cutscene after beating d3}
; @subid_07{A seed satchel that slowly falls toward Link. Unused?}
; @subid_08{Part of the cutscene where tokays steal your stuff?}
; @subid_09{Shovel that Rosa gives to you in linked game}
; @subid_0a{Bomb treasure (in tokay hut)}
; @subid_0b{Cheval rope treasure}
; @subid_0c{Flippers treasure (in cheval's grave)}
; @subid_0d{Blocks that move over when pulling lever to get flippers}
; @subid_0e{Stone statue of Link that appears unconditionally}
; @subid_0f{Switch that opens path to Nuun Highlands}
; @subid_10{Unfinished stone statue of Link in credits cutscene}
; @subid_11{Triggers cutscene after beating Jabu-Jabu}
; @subid_12{Seasons troupe member with tambourine?}
; @subid_13{Goron bomb statue (left)}
; @subid_14{Goron bomb statue (right)}
; @subid_15{Stone statue of Link that appears only after finishing game}
; @subid_16{A flame that appears for [counter1] frames.}
.define INTERAC_MISCELLANEOUS_1 $6b

;;
; Spots where fairies are hiding in the hide-and-seek minigame.
;
; @subid_00{Begins fairy-hiding minigame}
; @subid_01{Hiding spot for fairy}
; @subid_02{Checks for Link leaving hide-and-seek the area}
.define INTERAC_FAIRY_HIDING_MINIGAME $6c

;;
; Possessed version of Nayru/Ambi, or veran's ghost.
;
; @subid_00{Possessed Nayru in ambi's palace, starts boss fight}
; @subid_01{Possessed Ambi? (No code defined for this?)}
; @subid_02{Ghost Veran}
; @palette{PALH_85}
.define INTERAC_POSSESSED_NAYRU $6d

;;
; NPCs for the cutscene where Nayru is freed from her possession.
;
; @subid_00{Nayru waking up after being freed from possession}
; @subid_01{Queen Ambi}
; @subid_02{Ghost Veran}
; @subid_03{Ralph}
; @subid_04{Guards that run into the room (var03 is index of guard)}
; @palette{PALH_85}
.define INTERAC_NAYRU_SAVED_CUTSCENE $6e

;;
.define INTERAC_STUB_6f $6f

;;
; Meat used in "wild tokay" game.
.define INTERAC_WILD_TOKAY_CONTROLLER $70

;;
; Animal companion-related cutscenes
;
; @subid_00{Moosh script while being attacked by ghosts}
; @subid_01{Stop companion from moving above this X-position, unless you have their flute}
; @subid_02{Stop companion from moving below this Y-position, unless you have their flute}
; @subid_03{Ricky script when he loses his gloves}
; @subid_04{Stop companion from moving above this Y-position, unless you have their flute}
; @subid_05{Stop companion from moving below this X-position, unless you have their flute}
; @subid_06{Dimitri script where he leaves Link after bringing him to the mainland}
; @subid_07{Dimitri script where he's harrassed by tokays}
; @subid_08{A fairy appears to tell you about the animal companion in the forest}
; @subid_09{Companion script where they're found in the fairy forest}
; @subid_0a{Script just outside the forest, where you get the flute}
; @subid_0b{Script in first screen of forest, where fairy leads you to the companion}
; @subid_0c{Sets bit 6 of wDimitriState so he disappears from Tokay Island}
; @subid_0d{Companion barrier to Symmetry City, until the tuni nut is restored}
.define INTERAC_COMPANION_SCRIPTS $71

;;
; @subid_00{King moblin / "parent" object for the cutscene}
; @subid_01{Normal moblin}
; @subid_02{Gorons who approach after he leaves (var03 = index)}
.define INTERAC_KING_MOBLIN_DEFEATED $72

;;
; Ghinis harassing Moosh
; @subid_00-02{The 3 ghinis in the cutscene}
.define INTERAC_GHINI_HARASSING_MOOSH $73

;;
; Conditionally creates a treasure object if Ricky's gloves should be available.
.define INTERAC_RICKYS_GLOVE_SPAWNER $74

;;
; @subid_00{link riding horse}
; @subid_01{link on horse neighing}
; @subid_02{cliff that horse stands on in temple shot}
; @subid_03{link on horse (closeup)}
; @subid_04{"sparkle" on closeup of link's face}
; @subid_05{birds}
.define INTERAC_INTRO_SPRITE $75

;;
; When spawned, this opens the gate for the maku sprout.
;
; @subid_00{?}
; @subid_01{Opening the gates}
.define INTERAC_MAKU_GATE_OPENING $76

;;
; A small key attached to an enemy. Due to a bug, this only works if the enemy to be
; attached to is in the first enemy slot. (Fixed in hack-base branch.)
;
; @subid{The enemy ID to attach the small key to}
.define INTERAC_SMALL_KEY_ON_ENEMY $77

;;
; Stone panels on the top floor of the ancient tomb. Opens when bit 7 of wActiveTriggers
; is set. Bit 6 of the room flags indicates they've been opened upon entering the room.
;
; @subid_00{Left panel}
; @subid_01{Right panel}
; @palette{PALH_7e}
.define INTERAC_STONE_PANEL $7b

;;
; This interaction is created when "sent back by a strange force". It makes the entire
; screen turn into a giant sine wave.
.define INTERAC_SCREEN_DISTORTION $7c

;;
; This appears to be just a decoration, doesn't do anything. Subid determines what it
; looks like.
;
; @subid_00{Portal from ganon's lair back to maku tree.}
; @subid_01{King Moblin's flag}
; @subid_02{Gasha sprout}
; @subid_03{Red ball?}
; @subid_04{Scent seedling (planted)}
; @subid_05{Tokay eyeball (always visible)}
; @subid_06{Tokay eyeball (deletes self if room flag bit 7 not set)}
; @subid_07{Fairy powder in a bottle}
; @subid_08{Green book}
; @subid_09{Fountain.
;           @palette{PALH_7d}}
; @subid_0a{"Stream" coming from a fountain.
;           @palette{PALH_7d}}
.define INTERAC_DECORATION $80

;;
; @subid_00{Feather (automatically adjusted to shovel if needed)}
; @subid_01{Bracelet (automatically adjusted to shovel if needed)}
; @subid_02{Shovel (replacing feather)}
; @subid_03{Shovel (replacing bracelet))}
; @subid_04{(L1) Shield (level adjusted automatically)}
; @subid_05{L2 Shield}
; @subid_06{L3 Shield}
.define INTERAC_TOKAY_SHOP_ITEM $81

;;
; Heavy sarcophagus that can be lifted with power gloves.
;
; @subid{If bit 7 is set, it automatically breaks. Otherwise, if subid is nonzero, this
;        gets tied to bit 6 of the room flags (it sets that bit when lifted, and it no
;        longer appears when reentering the room.))}
.define INTERAC_SARCOPHAGUS $82

;;
; Fairy that upgrades your bomb capacity.
;
; @subid_00{"Parent" interaction and the fairy itself}
; @subid_01{Bombs that surround Link (depending on his answer)}
; @subid_02{Gold/silver bombs (depends on var03)}
.define INTERAC_BOMB_UPGRADE_FAIRY $83

;;
.define INTERAC_STUB_85 $85

;;
; Flower for the maku tree. RelatedObj1 should be an instance of INTERAC_MAKU_TREE.
;
; @subid_00{Present flower}
; @subid_01{Something unused?}
.define INTERAC_MAKU_FLOWER $86

;;
; Maku tree in the present.
;
; @subid_00{Main object, converts itself to one of the subids when necessary}
; @subid_01{Cutscene where maku tree disappears}
; @subid_02{Maku tree just after being saved (present)}
; @subid_03{Cutscene after saving Nayru where Twinrova reveals themselves}
; @subid_04{Some cutscene?}
; @subid_05{Credits cutscene?}
; @subid_06{Cutscene where Link gets the maku seed, then Twinrova appears}
.define INTERAC_MAKU_TREE $87

;;
; Maku tree as a sprout in the past.
;
; @subid_00{Main object, converts itself to one of the subids when necessary}
; @subid_01{Script where moblins are attacking Maku Sprout}
; @subid_02{Used in credits cutscene?}
.define INTERAC_MAKU_SPROUT $88

;;
; Triggers maku tree cutscenes; condition for trigger and text depends on var03.
;
; @subid_00{Present version of cutscene}
; @subid_01{Past version of cutscene}
; @var03_00{After D1}
; @var03_01{After present D2 collapses}
; @var03_02{After getting harp}
; @var03_03{After D2}
; @var03_04{After D3. Sets some flags (black tower growth and flute available).}
; @var03_05{After D4}
; @var03_06{After Moblin's Keep destroyed}
; @var03_07{After D5. Also spawns the goron at the end of the cutscene.}
; @var03_08{After D6}
; @var03_09{After D7}
; @var03_0a{After D8}
; @var03_0b{After D8, except there's no conditions for the trigger?}
.define INTERAC_REMOTE_MAKU_CUTSCENE $8a

;;
; @subid_00{Cutscene where goron elder is saved / NPC in that room after that}
; @subid_01{NPC hanging out in rolling ridge}
; @subid_02{NPC for biggoron's sword minigame; postgame only}
.define INTERAC_GORON_ELDER $8b

;;
; Tokay meat object used in the wild tokay game. When spawned, it sets its position to be
; above screen and starts falling.
.define INTERAC_TOKAY_MEAT $8c

;;
; Twinrova in their "mysterious cloaked figure" form
;
; @subid_00{Cutscene at maku tree screen after saving Nayru}
; @subid_01{Cutscene after d7; black tower is complete}
; @subid_02{Cutscene after getting maku seed}
.define INTERAC_CLOAKED_TWINROVA $8d

;;
; A splash animation (used by ENEMY_OCTOGON)
.define INTERAC_OCTOGON_SPLASH $8e

;;
; An ember seed that goes up for a bit, then disappears after falling a bit. Only used in
; the cutscene where you give ember seeds to Tokays.
.define INTERAC_TOKAY_CUTSCENE_EMBER_SEED $8f

;;
; Miscellaneous stuff, mostly puzzle solutions. Similar in purpose to INTERAC_DUNGEON_EVENTS?
;
; @subid_00{Boss key puzzle in D6}
; @subid_01{Underwater switch hook puzzle in past d6}
; @subid_02{Spot to put a rolling colored block on in present d6}
; @subid_03{Chest from solving colored cube puzzle in d6 (related to subid $02)}
; @subid_04{Floor changer in present D6, triggered by orb}
; @subid_05{Helper for floor changer (subid $04)}
; @subid_06{Helper for floor changer (subid $04)}
; @subid_07{Wall retraction event after lighting torches in past d6}
; @subid_08{Checks to set the "bombable wall open" bit in d6 (north)}
; @subid_09{Checks to set the "bombable wall open" bit in d6 (east)}
; @subid_0a{Jabu-jabu water level controller script, in the room with the 3 buttons}
; @subid_0b{Ladder spawner in d7 miniboss room}
; @subid_0c{Switch hook puzzle early in d7 for a small key}
; @subid_0d{Staircase spawner after moving first set of stone panels in d8}
; @subid_0e{Staircase spawner after putting in slates in d8}
; @subid_0f{Octogon boss initialization (in the room just before the boss)}
; @subid_10{Something at the top of Talus Peaks?}
; @subid_11{D5 keyhole opening}
; @subid_12{D6 present/past keyhole opening}
; @subid_13{Eyeglass library keyhole opening}
; @subid_14{Spot to put a rolling colored block on in Hero's Cave}
; @subid_15{Stairs from solving colored cube puzzle in Hero's Cave (related to subid $14)}
; @subid_16{Warps Link out of Hero's Cave upon opening the chest}
; @subid_17{Enables portal in Hero's Cave first room if its other end is active}
; @subid_18{Drops a key in hero's cave block-pushing puzzle}
; @subid_19{Bridge controller in d5 room after the miniboss}
; @subid_1a{Checks solution to pushblock puzzle in Hero's Cave}
; @subid_1b{Spawn gasha seed at top of maku tree after 4th essence (left screen)}
; @subid_1c{Spawn gasha seed at top of maku tree after 7th essence (center screen)}
; @subid_1d{Spawn gasha seed at top of maku tree after 6th essence (right screen)}
; @subid_1e{Play "puzzle solved" sound after navigating eyeball puzzle in final dungeon}
; @subid_1f{Checks if Link gets stuck in the d5 boss key puzzle, resets the room if so}
; @subid_20{Money in sidescrolling room in Hero's Cave}
; @subid_21{Creates explosions while screen is fading out; used after killing veran}
.define INTERAC_MISC_PUZZLES $90

;;
; A falling rock as seen in the cutscene where Ganon's lair collapses? (Doesn't damage
; Link.)
;
; @subid_00{Spawner of falling rocks; stops when $cfdf is nonzero. Used when freeing goron
;           elder. var03 is 0 or 1, changing the positions where the rocks fall?}
; @subid_01{Instance of falling rock spawned by subid $00}
; @subid_02{Small rock "debris". var03, angle, and counter1 affect its trajectory, etc?}
; @subid_03{Debris from ENEMY_TARGET_CART_CRYSTAL; angle is a value from 0-3, indicating
;           a diagonal to move in.}
; @subid_04{Blue rock debris, moving straight on a diagonal (angle from 0-3) - shooting gallery}
; @subid_05{Red rock debris, moving straight on a diagonal (angle from 0-3) - shooting gallery}
; @subid_06{Debris from pickaxe workers? var03 determines oamFlags, counter2 determines
;           draw priority? angle should be 0 or 1 for right or left movement.}
.define INTERAC_FALLING_ROCK $92

;;
; One half of twinrova riding their broomstick. Subids are "paired" by evens and odds; one
; half is the red one, the other is the blue one, for a particular cutscene.
;
; @subid_00-01{Linked cutscene after saving Nayru?}
; @subid_02-03{Twinrova introduction? Unlinked equivalent of subids $00-$01?}
; @subid_04-05{?}
; @subid_06-07{Something in endgame just before Ganon's being revived?}
.define INTERAC_TWINROVA $93

;;
; The restoration guru.
;
; @subid_00{Patch in the upstairs room}
; @subid_01{Patch in his minigame room}
; @subid_02{The minecart in Patch's minigame}
; @subid_03{Beetle "manager"; spawns them and check when they're killed.}
; @subid_04{Broken tuni nut sprite}
; @subid_05{Broken sword sprite}
; @subid_06{Fixed tuni nut sprite}
; @subid_07{Fixed sword sprite}
.define INTERAC_PATCH $94

;;
; Ball used by villagers. Subid is controlled by $cfd3.
;
; @subid_00-01{Standard ball; subid alternates from 0 to 1 based on who's holding it}
; @subid_02{Cutscene where villager turns to stone?}
.define INTERAC_BALL $95

;;
; A moblin NPC. (Used in cutscene where past make tree is being attacked?)
.define INTERAC_MOBLIN $96

;;
; @subid_00{Create "poofs" around this object randomly when Present D2 collapses}
; @subid_01{Spawns "bubbles" (PART_JABU_JABUS_BUBBLES) that blow to the north when Jabu Jabu's mouth opens}
.define INTERAC_97 $97

;;
; @subid_00{An explosion that throws out 4 pieces of rock debris}
; @subid_01{A piece of rock debris}
; @subid_02{Like subid 1, but value of "visible" is determined by var38?}
; @var03{Angle for debris (0-3 for each diagonal)}
.define INTERAC_EXPLOSION_WITH_DEBRIS $99

;;
; For the subid, the first nibble corresponds to a bit number at
; wTmpcfc0.carpenterSearch.carpentersFound; other than that, the first nibble is ignored.
;
; @subid_00{The boss carpenter; changes to subid 5 when needed}
; @subid_01{The "gate" that the boss stands next to}
; @subid_02-04{One of the carpenters to be sought out (either in the bridge room, or in
;              the other rooms before returning)}
; @subid_05{The boss carpenter in the cutscene where they build the bridge}
; @subid_06-08{Carpenters in the cutscene where they build the bridge}
; @subid_09{Carpenter in Eyeglasses Library}
; @subid_ff{Checks if you leave the area without finding all the carpenters}
.define INTERAC_CARPENTER $9a

;;
.define INTERAC_RAFTWRECK_CUTSCENE $9b

;;
; @subid_00{Present King Zora}
; @subid_01{Past King Zora}
; @subid_02{Potion sprite}
.define INTERAC_KING_ZORA $9c

;;
; Guy who teaches you the tune of currents.
.define INTERAC_TOKKEY $9d

;;
; Pushblock that influences the flow of water in talus peaks.
;
; @subid_00{On right side}
; @subid_01{On left side}
.define INTERAC_WATER_PUSHBLOCK $9e

;;
; Platform in sidescrolling areas which disappears.
;
; @subid_00{?}
; @subid_01{?}
; @subid_02{?}
.define INTERAC_DISAPPEARING_SIDESCROLL_PLATFORM $a3

;;
; Platform in sidescrolling areas which moves in a circular motion. The "center" of the
; circle it follows is always position $78x$56 at a fixed distance away, meaning X and
; Y variables don't do anything.
;
; @subid_00{Starts moving up}
; @subid_01{Starts moving right}
; @subid_02{Starts moving down}
.define INTERAC_CIRCULAR_SIDESCROLL_PLATFORM $a4

;;
; Given to Maple
.define INTERAC_TOUCHING_BOOK $a5

;;
; See also INTERAC_MAKU_SEED_AND_ESSENCES
.define INTERAC_MAKU_SEED $a6

;;
; A flame used for the twinrova cutscenes (changes color based on parameters?)
;
; @subid_00-02{?}
; @subid_03-05{?}
; @subid_06-09{?}
.define INTERAC_TWINROVA_FLAME $a9

;;
; @subid_00{?}
; @subid_01{?}
; @subid_02{?}
.define INTERAC_DIN $aa

;;
; @subid_00{?}
; @subid_01{?}
; @subid_02{?}
; @subid_03{?}
; @subid_04{?}
; @subid_05{Present zora palace, top-right}
; @subid_06{Present zora palace, middle-left}
; @subid_07{Present zora palace, bottom-right}
; @subid_08{?}
; @subid_09{?}
; @subid_0a{?}
; @subid_0b{?}
; @subid_0c{?}
; @subid_0d{?}
; @subid_0e{Zora studying in library}
; @subid_0f{?}
; @subid_10{Gives zora scale to Link after beating jabu}
; @subid_11{Guards sea of storms entrance (past/unlinked)}
; @subid_12{Guards sea of storms entrance (present/linked)}
; @subid_13{?}
; @subid_14{?}
; @subid_15{?}
; @subid_16{?}
; @subid_17{?}
; @subid_18{?}
; @subid_19{?}
; @subid_1a{?}
; @subid_1b{?}
.define INTERAC_ZORA $ab

;;
; @subid_00{Zelda in room of rites}
; @subid_01{?}
; @subid_02{?}
; @subid_03{Zelda in vire minigame}
; @subid_04{In village after getting maku seed, before entering tower}
; @subid_05{?}
; @subid_06{Zelda in cutscene after being rescued from vire}
; @subid_07{In Nayru's house after saving her from vire}
; @subid_08{Zelda standing outside black tower after reveal about ralph?}
; @subid_09{During Zelda kidnapped event}
; @subid_0a{?}
.define INTERAC_ZELDA $ad

;;
; Twinrova in a cutscene where they're watching the flames?
;
; @subid_00{Blue twinrova?}
; @subid_01{Red twinrova?}
; @subid_02{Blue twinrova?}
; @subid_03{Red twinrova?}
.define INTERAC_TWINROVA_IN_CUTSCENE $b0

;;
.define INTERAC_TUNI_NUT $b1

;;
; Shakes the screen and spawns rocks from a volcano.
.define INTERAC_VOLCANO_HANDLER $b2

;;
; Spawns the harp of ages in Nayru's house, and manages the cutscene that ensues?
.define INTERAC_HARP_OF_AGES_SPAWNER $b3

;;
; Book in eyeglasses library.
;
; @subid_00{The podium with the missing book (also spawns the other subids)}
; @subid_01-05{Other podiums}
.define INTERAC_BOOK_OF_SEALS_PODIUM $b4

;;
; Actual enemy vire is spawned later?
;
; @subid_00{Vire at black tower entrance}
; @subid_01{Vire in donkey kong minigame (lower level)}
; @subid_02{Vire in donkey kong minigame (upper level)}
.define INTERAC_VIRE $b8

;;
; Jabu as a child in the past.
.define INTERAC_CHILD_JABU $ba

;;
; Veran in the intro cutscene
.define INTERAC_HUMAN_VERAN $bb

;;
; Twinrova again? TODO: better name.
;
; @subid_00-01{?}
; @subid_02-03{?}
.define INTERAC_TWINROVA_3 $bc

;;
; While this object is on-screen, whenever a block is pushed, all other tiles with the same tile
; index will also get pushed in the same direction. Used for puzzles in Ages D5.
.define INTERAC_PUSHBLOCK_SYNCHRONIZER $bd

;;
; A button in Ambi's palace that unlocks the secret passage.
; Subid is 0-4, corresponding to which button it is.
.define INTERAC_AMBIS_PALACE_BUTTON $be

;;
; NPC in Symmetry City.
;
; @subid_00{NPC in present upper-right house}
; @subid_01{Unused?}
; @subid_02{Lady in present lower houses}
; @subid_03{Unused?}
; @subid_04{NPC in present upper-left house}
; @subid_05{Unused?}
; @subid_06-07{Brothers with the tuni nut}
; @subid_08-09{Sisters in the tuni nut building}
; @subid_0a-0b{Kids in the lower past houses}
; @subid_0c{NPC outside symmetry volcano, in the past (after tuni nut is placed)}
.define INTERAC_SYMMETRY_NPC $bf

;;
.define INTERAC_PIRATE_SHIP $c2

;;
; @subid_00{Pirate ship roaming the sea (loaded in slot $d140, "w1ReservedInteraction1")}
; @subid_01{Unlinked cutscene of ship leaving}
; @subid_02{Linked cutscene of ship leaving}
.define INTERAC_PIRATE_CAPTAIN $c3

;;
; Generic Piratian; also, tokay eyeball slot.
;
; @subid_00-03{Piratian in the ship}
; @subid_04{Tokay eyeball slot (invisible object)}
.define INTERAC_PIRATE $c4

;;
; Play a harp song, and make music notes at Link's position. Used when Link learns a song.
;
; @subid_00{Tune of Echoes}
; @subid_01{Tune of Currents}
; @subid_02{Tune of Ages}
.define INTERAC_PLAY_HARP_SONG $c5

;;
; Object placed in the 3-door room in the black tower; checks whether to start the cutscene.
.define INTERAC_BLACK_TOWER_DOOR_HANDLER $c6

;;
.define INTERAC_TINGLE $c8

;;
; Cucco in Syrup's hut that prevents you from stealing. (Not to be confused with ENEMY_CUCCO,
; which is a more normal cucco.)
.define INTERAC_SYRUP_CUCCO $c9

;;
; @subid_00{Troy at target carts (postgame)}
; @subid_01{Troy in his house (disappears in postgame)}
.define INTERAC_TROY $ca

;;
; Ghini that appears in Ages for linked game stuff.
; There's also INTERAC_GHINI.
.define INTERAC_LINKED_GAME_GHINI $cb

;;
; Mayor of Lynna City
.define INTERAC_PLEN $cc

;;
; Linked game NPC
.define INTERAC_MASTER_DIVER $cd

;;
; This is for the great fairy that cleans the sea. For great fairies that heal, see
; "ENEMY_GREAT_FAIRY".
;
; @subid_00{Linked game NPC in fairies' woods (gives a secret)}
; @subid_01{Cutscene after being healed from being an octorok}
.define INTERAC_GREAT_FAIRY $d5

;;
; Linked game NPC.
; Not to be confused with INTERAC_BUSINESS_SCRUB.
.define INTERAC_DEKU_SCRUB $d6

;;
; Handles the cutscene where the maku seed and the 3 essences despawn the barrier in the black
; tower.
;
; @subid_00{Maku seed (spawns the other subids)}
; @subid_01-08{Essences}
.define INTERAC_MAKU_SEED_AND_ESSENCES $d7

;;
; Handles events in rooms where pulling a lever fills lava with walkable terrain.
;
; @subid_00{D4, 1st lava-filler room}
; @subid_01{D4, 2 rooms before boss key}
; @subid_02{D4, 1 room before boss key}
; @subid_03{D8, lava room with keyblock}
; @subid_04{D8, other lava room}
; @subid_05{Hero's Cave lava room}
.define INTERAC_LEVER_LAVA_FILLER $d8

;;
; Slot to place a slate in for ages d8.
;
; @subid{Value from 0-3, corresponds to room flag bits 0-3}
.define INTERAC_SLATE_SLOT $db

;;
; Miscellaneous stuff. See also INTERAC_MISCELLANEOUS_1.
;
; @subid_00{Graveyard key spawner}
; @subid_01{Graveyard gate opening cutscene}
; @subid_02{Initiates cutscene where present d2 collapses}
; @subid_03{Reveals portal spot under bush in symmetry (left side)}
; @subid_04{Reveals portal spot under bush in symmetry (right side)}
; @subid_05{Makes screen shake before tuni nut is restored}
; @subid_06{Makes volcanoes erupt before tuni nut is restored (spawns INTERAC_VOLCANO_HANLDER)}
; @subid_07{Heart piece spawner}
; @subid_08{
;   Replaces a tile at a position with a given value when destroyed. The effect is permanently
;   disabled once that tile is destroyed, by writing to room flags.
;   X is bitmask for room flags, var03 is the tile index to put at "Y".
;   @postype{short}}
; @subid_09{Animates jabu-jabu}
; @subid_0a{Initiates jabu opening his mouth cutscene}
; @subid_0b{Handles floor falling in King Moblin's castle}
; @subid_0c{Bridge handler in Rolling Ridge past}
; @subid_0d{Bridge handler in Rolling Ridge present}
; @subid_0e{Puzzle at entrance to sea of no return (ancient tomb)}
; @subid_0f{Shows text upon entering a room (only used for sea of no return entrance and black tower
;           turret)}
; @subid_10{Black tower entrance handler: warps Link to different variants of black tower.}
; @subid_11{Gives D6 Past boss key when you get D6 Present boss key}
; @subid_12{Bridge handler for cave leading to Tingle}
; @subid_13{Makes lava-waterfall an d4 entrance behave like lava instead of just a wall, so that the
;           fireballs "sink" into it instead of exploding like on land.}
; @subid_14{Spawns portal to final dungeon from maku tree}
; @subid_15{Sets present sea of storms chest contents (changes if linked)}
; @subid_16{Sets past sea of storms chest contents (changes if linked)}
; @subid_17{Forces Link to be squished when he's in a wall (used in ages d5 BK room)}
.define INTERAC_MISCELLANEOUS_2 $dc

;;
; The warp animation that occurs when entering a time portal.
;
; @subid_00{Initiating a warp (entered a portal from the source screen)}
; @subid_01{Completing a warp (warping in to the destination screen)}
; @subid_02{TODO: func_03_7244@state2@cbb3_02}
; @subid_03{?}
; @subid_04{?}
.define INTERAC_TIMEWARP $dd

;;
; A time portal created with the Tune of Currents or Tune of Ages.
; (TODO: wrap in ifdef)
.define INTERAC_TIMEPORTAL $de

;;
; Creates a time portal when the Tune of Echoes is played.
;
; If Bit 7 of subid is set, the portal is always open.
;
; If Bit 6 of subid is set, bit 1 of the room flags is set upon entering the
; portal the first time. The portal will subsequently remain open.
;
; @subid_00{Ordinary portal}
; @subid_01{First portal to past, starts active until maku tree saved}
; @subid_02{First portal to present, activates upon getting satchel}
.define INTERAC_TIMEPORTAL_SPAWNER $e1

;;
; @subid{Value from 0-9}
.define INTERAC_KNOW_IT_ALL_BIRD $e3

;;
.define INTERAC_STUB_e4 $e4

;;
; @subid_00{Raft on Tokay island (only when Dimitri is gone)}
; @subid_01{Raft outside Rafton's house}
; @subid_02{Raft created when SPECIALOBJECT_RAFT is dismounted}
.define INTERAC_RAFT $e6


; ==============================================================================
; Seasons only
; ==============================================================================

.else ;ROM_SEASONS

;;
; Called by Rod of Seasons item code, and sets the next available season
.define INTERAC_USED_ROD_OF_SEASONS $15

.define INTERAC_STUB_19 $19
.define INTERAC_STUB_1a $1a
.define INTERAC_STUB_1b $1b

;;
; Handles interaction with rupee tiles, giving random rupees
; @subid_00{D2 rupee room}
; @subid_01{D6 rupee room}
.define INTERAC_RUPEE_ROOM_RUPEES $1d

;;
; @subid_00{Holly's chimney}
; @subid_01{???}
; @subid_02{Into Sunken City left waterfall}
; @subid_03{Into Sunken City right waterfall}
; @subid_04{Into Natzu River waterfall}
; @subid_05{From Sunken City left waterfall}
; @subid_06{From Sunken City right waterfall}
; @subid_07{From Natzu River waterfall}
; @subid_08{Mt. Cucco dive spot to Sunken City}
; @subid_09{Sunken City north dive spot}
; @subid_0a{Dive spot outside D4}
; @subid_0b{ROOM_SEASONS_4f4, desert?}
; @subid_0c{ROOM_SEASONS_4f5, desert?}
; @subid_0d{Sunken City south dive spot}
.define INTERAC_SPECIAL_WARP $1f

;;
.define INTERAC_GNARLED_KEYHOLE $21

;;
; TODO: subids
.define INTERAC_MAKU_CUTSCENES $22

;;
; @subid_01{In Spring season room}
; @subid_11{In Summer season room}
; @subid_21{In Autumn season room}
; @subid_31{In Winter season room}
; @subid_30{Winter temple orb puzzle}
; @subid_40{Cutscene entering Temple area}
.define INTERAC_SEASON_SPIRITS_SCRIPTS $23

;;
; @subid_00{Mayor}
; @subid_01{Linked woman}
.define INTERAC_MAYORS_HOUSE_NPC $24

;;
; @subid_00{Not saved Mittens}
; @subid_01{Saved Mittens}
.define INTERAC_MITTENS $25

;;
; @subid_00{Not saved Mittens}
; @subid_01{Saved Mittens}
.define INTERAC_MITTENS_OWNER $26

;;
; @subid_00{South of Maku tree}
; @subid_01{By Eastern Suburbs portal}
; @subid_02{Near Floodgate keyhole}
.define INTERAC_SOKRA $27

;;
.define INTERAC_MRS_RUUL $29

;;
; @subid_00-09{Know-it-all birds}
; @subid_0a{Bird with Impa when Zelda gets kidnapped}
; @subid_0b{Panicking bird in Horon village entrance screen}
.define INTERAC_BIRD $2a

;;
.define INTERAC_MR_WRITE $2c

;;
; Moves around horon village a lot based on game stage
;
; @subid_80-86{}
.define INTERAC_FICKLE_LADY $2d

;;
; Girl in Sunken City
;
; @subid_00-04{}
.define INTERAC_FICKLE_GIRL $2e

;;
.define INTERAC_MALON $2f

;;
; @subid_00{Standing by head smelter in front of Autumn temple}
; @subid_01{unused???}
; @subid_02{1st room of furnace - bottom right}
; @subid_03{1st room of furnace - top left}
; @subid_04{2nd room of furnace - bottom right}
; @subid_05{2nd room of furnace - leftmost}
; @subid_06{Bottom-center screen of subrosian beach}
; @subid_07{Top-left screen of subrosian beach}
; @subid_08{Top-center screen of subrosian beach}
; @subid_09{Bottom-left screen of subrosian beach}
; @subid_0a{Screen above beach - bottom right}
; @subid_0b{Screen above beach - top left}
; @subid_0c{Shopkeeper}
; @subid_0d{Has gasha seed in house across a tile-wide river of lava}
; @subid_0e{Screen above portal near strange brothers}
; @subid_0f{Screen right of portal near strange brothers}
; @subid_10{Strange brother when stealing your feather - top-left}
; @subid_11{Strange brother when stealing your feather - bottom-right}
; @subid_12{Strange brothers house 1st screen - left}
; @subid_13{Strange brothers house 1st screen - right}
; @subid_14{TODO: Says "I still haven't been that way, what's there?"}
; @subid_15{Screen with entrance to cave you can start the erupting cutscene - left}
; @subid_16{Screen with entrance to cave you can start the erupting cutscene - right}
; @subid_17{From suburbs portal - left}
; @subid_18{From suburbs portal - right}
; @subid_19{Screen south of suburbs portal entry}
; @subid_1a{Same screen as portal 2 screens south of D8}
; @subid_1b{Screen south of NW locked door}
; @subid_1c{Just above boomerang subrosian}
; @subid_1d{Screen right of boomerang subrosian}
; @subid_1e{Across a pit leading to area with W ore}
; @subid_1f{Same screen as chest right of W ore}
; @subid_20{Screen above strange brother's house}
; @subid_21{Same screen as strange brother's house}
; @subid_22{Screen south of shop}
; @subid_23{In house with lava pool to the top-left}
; @subid_24{Top-right screen of subrosian beach}
; @subid_25{Golden subrosian giving secret}
; @subid_26{Signs guy}
.define INTERAC_SUBROSIAN $30

;;
; @subid_00{Rosa}
; @subid_01{Rosa following you}
; @subid_02{Spawns star ore}
; @subid_03{same code as subid_00???}
.define INTERAC_ROSA $31

;;
; @subid_00{South of autumn temple}
; @subid_01{Outside cave SE of D8}
; @subid_02{Path west of Temple of seasons near small erupting volcanoes}
; @subid_03{Near boomerang subrosian}
; @subid_04{Path southwest of Temple of seasons - gap to village}
; @subid_05{In village, screen north of portal}
; @subid_06-07{Unused?}
.define INTERAC_SUBROSIAN_WITH_BUCKETS $32

;;
; Bathing subrosians
;
; @subid_80-82{By 50 ore chunk spot}
; @subid_83-85{Above dancing minigame entrance}
.define INTERAC_BATHING_SUBROSIANS $33

;;
.define INTERAC_SUBROSIAN_SMITHS $34

;;
; Moves around sunken city a lot based on game stage
;
; @subid_80-84{}
.define INTERAC_MASTER_DIVERS_SON $36

;;
; Moves around horon village a lot based on game stage
;
; @subid_80-86{}
.define INTERAC_FICKLE_MAN $37

;;
; D1, D4 and linked Hero's cave
.define INTERAC_DUNGEON_WISE_OLD_MAN $38

;;
; Moves around his house in sunken city a lot based on game stage
; @subid_80-84{}
.define INTERAC_TREASURE_HUNTER $39

;;
; Seems to be unused
.define INTERAC_3a $3a

;;
; upper nybble of subid goes into var03
;
; @var03_00{Initially looks forward}
; @var03_01{Initially resting until you're near}
; @var03_02{Pushes Link away while walking}
;
; @subid_20{Pacing goron}
; @subid_11{Regular goron - 1F}
; @subid_02{Regular goron - 1F}
; @subid_13{Regular goron - 1F}
; @subid_14{Regular goron - 2F}
; @subid_15{Regular goron - 2F}
; @subid_16{Red goron who upgrades ringbox}
; @subid_07{Red goron giving secret}
.define INTERAC_GORON $3b

;;
.define INTERAC_OLD_LADY_FARMER $3c

;;
.define INTERAC_FOUNTAIN_OLD_MAN $3d

;;
; upper nybble of subid goes into var03, and determines type of NPC.
;
; subids are replaced with the current game stage (different for Horon Village and Sunken
; City).
;
; @subid_00-04{Throws dog a ball}
; @subid_10-13{Simple Horon Village boy}
; @subid_20{Disappears in winter. In Spring, plays with Horon village flower}
; @subid_30,32-34{Sunken City boy}
; @subid_31{In Sunken City, ROOM_SEASONS_06e when Moblins keep destroyed, else ROOM_SEASONS_05e}
.define INTERAC_MISC_BOY_NPCS $3e

;;
.define INTERAC_TICK_TOCK $3f

;;
; subid_00 and subid_0b belongs to captain
; code just determines looks, subids determine the script
;
; @subid_01-06{In the house, 1F}
; @subid_07{In the house, 2F - NPC Unlucky Sailor awaiting secret}
; @subid_08{In the house, 2F}
; @subid_09{Roof of house by portal}
; @subid_0a{By samasa desert gates}
; @subid_0c{Spawned by captain subid_0b from ship when leaving Subrosia}
; @subid_0d-0e{By captain subid_0b, by ship in Subrosia}
.define INTERAC_PIRATIAN $40

;;
; @subid_00{In the house}
; @subid_0b{By the ship in Subrosia}
.define INTERAC_PIRATIAN_CAPTAIN $41

;;
; 1 subrosian that moves downstairs when pirates leave
;
; @subid_00{2F}
; @subid_01{1F}
.define INTERAC_PIRATE_HOUSE_SUBROSIAN $42

;;
.define INTERAC_SYRUP $43

;;
; @subid_00{In Room of Rites}
; @subid_01{By Maku tree after escaping Room of Rites}
; @subid_02{Being kidnapped}
; @subid_03{TODO: With animals/people in cutscenes}
; @subid_04{Same script as above - unused?}
; @subid_05{TODO: With a triforce interaction}
; @subid_06{Pacing around in North Horon about to be kidnapped}
; @subid_07{After Zelda Villagers cutscene, she's there with animals}
; @subid_08{By Maku tree, before fighting Onox}
; @subid_09{In Impa's house after saving her from vire}
.define INTERAC_ZELDA $44

;;
; @subid_00{In cave, sleeping}
; @subid_01{Returned to Malong}
.define INTERAC_TALON $45

;;
; TODO: subids
.define INTERAC_MAKU_LEAF $48

;;
; Cucco in Syrup's hut that prevents you from stealing. (Not to be confused with ENEMY_CUCCO,
; which is a more normal cucco.)
.define INTERAC_SYRUP_CUCCO $49

;;
; @subid_00{}
; @subid_01{}
; @subid_02{TODO: spawned by interactionCodebb}
.define INTERAC_D1_RISING_STONES $4b

;;
; @subid_00{Windmill blades}
; @subid_01{Gasha sprouts in mayor's house}
; @subid_02{Left half of cloud}
; @subid_03{Right half of cloud}
; @subid_04{Red ore thrown into furnace}
; @subid_05{Blue ore thrown into furnace}
; @subid_06{TODO: level 2 sword in podium?}
; @subid_07{Water ring around fountain}
; @subid_08{Water spurting up from fountain}
; @subid_09{Goron vase in Ingo's house after trading it}
; @subid_0a{Spring emblem in Temple of Seasons}
; @subid_0b{Summer emblem in Temple of Seasons}
; @subid_0c{Winter emblem in Temple of Seasons}
; @subid_0d{Autumn emblem in Temple of Seasons}
.define INTERAC_MISC_STATIC_OBJECTS $4c

;;
; @subid_00{Talkable skull in the desert}
; @subid_01{Drops from quicksand}
.define INTERAC_PIRATE_SKULL $4d

;;
; @subid_00{Troupe 1 - green beer guy}
; @subid_01{Troupe 2 - blue hair}
; @subid_02{Troupe 3 - guitar guy}
; @subid_03{Troupe 4 - red beer guy}
; @subid_04{Impa}
; @subid_05{Campfire}
; @subid_06{Din}
; @subid_07{Tornado}
; @subid_08-09{Din during ending cutscenes}
; @subid_0a{Troupe in Horon Village}
; @subid_0b{Spawns subids $00 to $06}
.define INTERAC_DIN_DANCING_EVENT $4e

;;
; @subid_00{Din}
; @subid_01{Onox?}
; @subid_02{Crystals?}
; @subid_03{Circling thing?}
; @subid_04{Crystals?}
; @subid_05{Onox?}
.define INTERAC_DIN_IMPRISONED_EVENT $4f

;;
.define INTERAC_SEASONS_FAIRY $50

;;
; TODO: subids determine how active the volcano is and subid of INTERAC_VOLCANO_ROCK
;
; @subid_00{}
; @subid_01{}
.define INTERAC_SMALL_VOLCANO $51

;;
.define INTERAC_BIGGORON $52

;;
; @subid_00{By temple of autumn}
; @subid_01{By furnace}
.define INTERAC_HEAD_SMELTER $53

;;
.define INTERAC_SUBROSIAN_AT_VOLCANO_ITEMS $54

;;
; The subrosian trying to blow up the volcano leading to d8
.define INTERAC_SUBROSIAN_AT_VOLCANO $55

;;
.define INTERAC_INGO $57

;;
.define INTERAC_GURU_GURU $58

;;
; Overrides subid depending on sword gotten
.define INTERAC_LOST_WOODS_SWORD $59

;;
.define INTERAC_BLAINO_SCRIPT $5a

;;
.define INTERAC_LOST_WOODS_DEKU_SCRUB $5b

;;
.define INTERAC_LAVA_SOUP_SUBROSIAN $5c

;;
; subids indexed same as trade item subid, the ones used are
;
; @subid_06{Fish}
; @subid_07{Megaphone}
; @subid_08{Mushroom}
.define INTERAC_TRADE_ITEM $5d

;;
; subid_00{Regular quicksand that deals damage}
; subid_01-04{The four that could lead to pirate's bell}
; subid_05{Leads to SE samasa treasure chest}
.define INTERAC_QUICKSAND $5e

.define INTERAC_COMPANION_SPAWNER $5f

.define INTERAC_STUB_61 $61

;;
; subid_00{Spawns subid01 4 times with var03 of 0-3}
; subid_01{Handles chests and contents, and opening order}
.define INTERAC_D5_4_CHEST_PUZZLE $62

;;
.define INTERAC_D5_REVERSE_MOVING_ARMOS $63

;;
.define INTERAC_D5_FALLING_MAGNET_BALL $64

;;
; @subid_00{Created when trap rupee touched, inits stuff and spawns subid $01 and $02}
; @subid_01{TODO}
; @subid_02{TODO}
.define INTERAC_D6_CRYSTAL_TRAP_ROOM $65

;;
; TODO:
; @subid_00{}
; @subid_01{created by subid_00}
.define INTERAC_D7_4_ARMOS_BUTTON_PUZZLE $66

;;
.define INTERAC_D8_ARMOS_PATTERN_PUZZLE $67

;;
.define INTERAC_D8_GRABBABLE_ICE $68

;;
; @subid_00{Located in the 4 rooms where lava is spewed}
; @subid_01{spawned from subid_00 (TODO: what is it)}
; @subid_02{spawned from subid_01}
; @subid_03{spawned from subid_01}
; @subid_04{spawned from subid_00}
.define INTERAC_D8_FREEZING_LAVA_EVENT $69

;;
; @subid_00{Spawns subid_01 and subid_02}
; @subid_01{Dance leader}
; @subid_02{Dancer}
; @subid_03{TODO: spawned during tutorial}
.define INTERAC_DANCE_HALL_MINIGAME $6a

;;
; @subid_00{Floodgate Keeper}
; @subid_01{Floodgate Keeper Switch}
; @subid_02{Floodgate keyhole}
; @subid_03{D4 keyhole}
; @subid_04{Floodgate key}
; @subid_05{Dragon key}
; @subid_06{Tarm Ruins Armos unlocking stairs when pushed}
; @subid_07{Tarm Ruins Armos' next to stump}
; @subid_08{Tarm event when exited Lost Woods to the north}
; @subid_09{50 ore chunk dig spots, also spawned by Strange Brothers}
; @subid_0a{Static heart pieces}
; @subid_0b{Permanently removable objects, eg boulders, ember trees}
; @subid_0c{Object handler when falling with skull into pirate's bell room}
; @subid_0d{Green joy ring puzzle in Mt Cucco}
; @subid_0e{Master Diver 4 statue puzzle}
; @subid_0f{Pirate's bell}
; @subid_10{Armos blocking way to D6 - handler}
; @subid_11{Switch to Natzu}
; @subid_12{Onox Castle Cutscene}
; @subid_13{Prevents no enemies south of 1st North Horon seed tree when saving Zelda}
; @subid_14{Unblocking D3 dam - spawned by subid_02}
; @subid_15{Replace pirate ship with quicksand}
; @subid_16{Handle stolen feather - spawned by strange brothers}
; @subid_17{Horon village portal bridge spawner}
; @subid_18{Dig spots with random rings}
; @subid_19{Static gasha seed}
; @subid_1a{Underwater gasha seed}
; @subid_1b{Tick Tock secret entrance}
; @subid_1c{West Coast grave secret entrance}
; @subid_1d{D4 miniboss room - torch/darkness/N door interactions}
; @subid_1e{Sent back by Onox Castle barrier}
; @subid_1f{Sidescrolling static gasha seed}
; @subid_20{Sidescrolling static seed satchel}
; @subid_21{Mt Cucco banana tree}
; @subid_22{Hard ore}
; @subid_23{TODO:}
; @subid_24{TODO:}
; @subid_25{TODO:}
; @subid_26{TODO:}
.define INTERAC_MISCELLANEOUS_1 $6b

;;
; @subid_00{Event starter}
; @subid_01{Rosa herself}
.define INTERAC_ROSA_HIDING $6c

;;
; @subid_00{Event starter}
; @subid_01{Brother 1}
; @subid_02{Brother 2}
.define INTERAC_STRANGE_BROTHERS_HIDING $6d

;;
; @subid_00{spawned by subid_01 (TODO: what is it)}
; @subid_01{located in screen where feather is lost}
; @subid_02{located at strange brothers house entrance}
.define INTERAC_STEALING_FEATHER $6e

;;
; @subid_00{grabbable treasure}
; @subid_01{unblocking the Temple of Autumn}
.define INTERAC_BOMB_FLOWER $6f

;;
; @subid_00{Holly}
; @subid_01{Room outside for detecting snow shovelled}
.define INTERAC_HOLLY $70

;;
; @subid_00{Ricky running off after jumping up cliff in North Horon}
; @subid_01{Moosh being bullied in Spool}
; @subid_02{Taking animal to Sunken City}
; @subid_03{Ricky in North Horon}
; @subid_04{Dimitri in Spool Swamp}
; @subid_05{Dimitri being bullied}
; @subid_06{Moosh in Mt Cucco}
; @subid_07{Moblin rest house - point where bullies will appear}
; @subid_08{Leaving Sunken City with Dimitri}
; @subid_09{1st screen of North Horon from eyeglass lake - determining animal companion}
.define INTERAC_COMPANION_SCRIPTS $71

;;
.define INTERAC_BLAINO $72

;;
; @subid_00-02{Moosh's/Dimitri's 3 bullies}
; @subid_03-05{Spawned moblin bullies for Moosh event}
.define INTERAC_ANIMAL_MOBLIN_BULLIES $73

;;
; @subid_00{}
; @subid_01{}
; @subid_02{}
; @subid_03{}
; @subid_04{}
; @subid_05{}
; @subid_06{}
; @subid_07{}
; @subid_08{}
; @subid_09{}
; @subid_0a{spawned by subid_02 and subid_04}
; @subid_0b{spawned by subid_02 and subid_04}
; @subid_0c{Moblin Keep flag?}
.define INTERAC_74 $74

;;
; @subid_00{}
; @subid_01{}
; @subid_02{}
.define INTERAC_INTRO_SPRITE $75

;;
; @subid_00-02{The 3 bullies}
.define INTERAC_SUNKEN_CITY_BULLIES $76

;;
; Used by temple sinking cutscene
.define INTERAC_77 $77

;;
.define INTERAC_MAGNET_SPINNER $7b

;;
; @subid_00{}
; @subid_01{}
.define INTERAC_TRAMPOLINE $7c

;;
; @subid_00-03{}
.define INTERAC_FICKLE_OLD_MAN $80

;;
; @subid_00{Ribbon}
; @subid_01{Bomb upgrade}
; @subid_02-03{Gasha seed}
; @subid_04{Piece of heart}
; @subid_05-08{Ring}
; @subid_09{4 ember seeds}
; @subid_0a{Shield}
; @subid_0b{10 pegasus seeds}
; @subid_0c{3 hearts}
; @subid_0d{Member's card}
; @subid_0e{10 ore chunks}
.define INTERAC_SUBROSIAN_SHOP $81

;;
.define INTERAC_HORON_DOG $82

;;
.define INTERAC_BALL_THROWN_TO_DOG $83

;;
; Plays carnival music in the screen before Din dancing
.define INTERAC_INTRO_SCENE_MUSIC $85

;;
; TODO: each subid is 1 of the 5 explosions in each screen?
;
; @subid_00{}
; @subid_01{}
; @subid_02{}
; @subid_03{}
; @subid_04{}
.define INTERAC_TEMPLE_SINKING_EXPLOSION $86

;;
; Maku tree. TODO: subids
.define INTERAC_MAKU_TREE $87

;;
; clouds above Onox castle?
.define INTERAC_88 $88

;;
; @subid_00-04{}
.define INTERAC_FLOODED_HOUSE_GIRL $8a

;;
; @subid_00-04{}
.define INTERAC_MASTER_DIVERS_WIFE $8b

;;
; @subid_00{Rooster on top of d4}
; @subid_01{Rooster that leads to spring banana}
.define INTERAC_FLYING_ROOSTER $8c

;;
; @subid_00-04{}
.define INTERAC_MASTER_DIVER $8d

;;
; Bubbles?
.define INTERAC_8e $8e

;;
.define INTERAC_OLD_MAN_WITH_JEWEL $8f

;;
; @subid_00{Tarm ruins entrance script (spawn jewels)}
; @subid_01{Underwater pyramid jewel}
; @subid_02{Handles bridge creation to X jewel island}
; @subid_03{Handles event with X jewel moldorm}
; @subid_04{Determines chest contents in Spool Swamp's jewel cave}
; @subid_05{Determines chest contents in Eyeglass Lake's jewel cave}
; @subid_06{???}
; @subid_07{Created by linked Vire interaction}
.define INTERAC_JEWEL_HELPER $90

;;
; Jewels in place in tarm ruins (visual only)
.define INTERAC_JEWEL $92

;;
; @subid_00{Hanging on Maku tree}
; @subid_01{Given by Maku tree}
.define INTERAC_MAKU_SEED $93

;;
; Given to Maple
.define INTERAC_LON_LON_EGG $94

;;
; In rest house
;
; TODO: interactions $95, $96, maybe $97, $9a, $9b all interact with each other
;   for moblin rest house-related events
;
; @subid_00{}
; @subid_01{}
; @subid_02{}
; @subid_03{Spawned from INTERAC_MOBLIN_KEEP_SCENES - when coming down from Natzu}
; @subid_04{Spawned from seasonsFunc_3e52 (after moblin keep destroyed?) Rushes south}
; @subid_05{Spawned from interactionCodec3 as part of the spawned minions, Moves up, down, up?}
.define INTERAC_KING_MOBLIN $95

;;
; @subid_00-03{}
; @subid04{Spawned by INTERAC_MOBLIN_KEEP_SCENES}
; @subid05-06{Spawned by interactionCodec3 as part of the spawned minions}
.define INTERAC_MOBLIN $96

;;
; moblin house-related?
.define INTERAC_97 $97

;;
; @subid_00-07{}
.define INTERAC_OLD_MAN_WITH_RUPEES $99

;;
; Same room as moblin rest house - event when moblin house explodes?
;
; @subid_00{spawned in func _func_5a82}
; @subid_01{spawned by subid_02 4 times}
; @subid_02{same room as moblin rest house}
; @subid_03{spawned by subid_02}
.define INTERAC_9a $9a

;;
.define INTERAC_9b $9b

;;
.define INTERAC_SPRINGBLOOM_FLOWER $9c

;;
; @subid_00-05{}
.define INTERAC_IMPA $9d

;;
.define INTERAC_SAMASA_DESERT_GATE $9e

;;
.define INTERAC_DISAPPEARING_SIDESCROLL_PLATFORM $a3

;;
.define INTERAC_SUBROSIAN_SMITHY $a4

;;
; @subid_00{TODO: 1st Din after Dragon Onox beat - the one descending?}
; @subid_01{TODO: Other Din after Dragon Onox beat - outside crystal}
; @subid_02-07{TODO: all part of objectData, so ending cutscenes?}
; @subid_06{TODO: part of intro cutscenes (after being captured by Onox?)
; @subid_08{Horon village field, after game beat}
; @subid_09{1st Din (sees you collapsed)}
.define INTERAC_DIN $a5

;;
; @subid_00-04{subid determines angle that each of the 4 fade towards}
.define INTERAC_DINS_CRYSTAL_FADING $a6

;;
.define INTERAC_a9 $a9

;;
; Post-linked game?
;
; @subid_00{Impa}
; @subid_01{Zelda}
; @subid_02{Nayru - this and Impa subid_03 in same objectData}
; @subid_03{Impa}
.define INTERAC_aa $aa

;;
; @subid_00{Right of moblin keep - handles when shooting the cannons at you}
; @subid_01{Inside King Moblin boss room - pre-spawning the enemy king moblin}
; @subid_02{Moblin keep itself - after it's destroyed}
.define INTERAC_MOBLIN_KEEP_SCENES $ab

;;
; NPCs in one credits cutscene with Din and Maple?
;
; @subid_00-04{}
.define INTERAC_ad $ad

;;
; A flame used for the twinrova cutscenes (changes color based on parameters?)
;
; @subid_00-02{?}
; @subid_03-05{?}
; @subid_06-09{?}
.define INTERAC_TWINROVA_FLAME $b0

;;
; Regular piratian in cutscene?
;
; @subid_00{Unused??}
; @subid_01{1st scene in pirate ship, text handler for pirate coming down stairs}
; @subid_02{The actual piratian spawned from subid_01}
; @subid_03{1st scene in pirate ship, standing around}
; @subid_04-06{Unused?? possibly due to 4 in ship all using subid_03}
; @subid_07{Text handler when leaving Samasa desert}
; @subid_08{Text for the 1st dizzy pirate from above (spawns the actual pirate - subid_0a)}
; @subid_09{Focused invisible object moving left and right, to sway ship}
; @subid_0a{1st piratian coming inside ship when it's swaying}
; @subid_0b{2nd piratian coming inside ship when it's swaying}
; @subid_0c{3rd piratian coming inside ship when it's swaying}
; @subid_0d{Sick piratian already inside ship}
; @subid_0e{Sick piratian already inside ship}
; @subid_0f{Unused??}
; @subid_10{Actual NPC at West Coast ship - top half}
; @subid_11{Actual NPC at West Coast ship - bottom half}
; @subid_12-16{Inside pirate ship once docked in West Coast}
; @subid_17{Unused??}
; @subid_18{Ghost piratian}
; @subid_19{Handles text when above and left of boxes above ghost piratian}
; @subid_1a{Handles text when above and right of boxes above ghost piratian}
.define INTERAC_SHIP_PIRATIAN $b1

;;
; Piratian captain in cutscene?
;
; @subid_00{1st scene in pirate ship, leaving Subrosia}
; @subid_01{2nd scene in pirate ship, dizzy and sick}
; @subid_02{Text handler at west coast ship}
; @subid_03{Actual NPC at West Coast ship - top half}
.define INTERAC_SHIP_PIRATIAN_CAPTAIN $b2

;;
.define INTERAC_LINKED_CUTSCENE $b3

;;
; Twinrova witches
;
; @subid_00-07{}
.define INTERAC_b4 $b4

;;
; Linked game only
;
; @subid_00{Mrs Ruul's house}
; @subid_01{Outside Syrup Hut}
; @subid_02{On the way to Samasa desert gate}
; @subid_03{When pirates are leaving for West Coast}
; @subid_04{Pirate house 1F}
.define INTERAC_AMBI $b8

; TODO: the following people are 5 that hang around Zelda

;;
; Impa hanging around Zelda
;
; @subid_00{}
; @subid_01{}
; @subid_02{}
; @subid_03{Spawned by INTERAC_ZELDA_KIDNAPPED_ROOM ($c3)?}
.define INTERAC_ba $ba

;;
; Boy 1 hanging around Zelda
;
; @subid_00-02{}
.define INTERAC_bb $bb

;;
; Boy 2 hanging around Zelda
;
; @subid_00-04{}
.define INTERAC_bc $bc

;;
; Old man 1 hanging around Zelda
;
; @subid_00-02{}
.define INTERAC_bd $bd

;;
; Old man 2 hanging around Zelda
; @subid_00-02{}
.define INTERAC_be $be

;;
; @subid_00{}
; @subid_01{}
.define INTERAC_bf $bf

;;
.define INTERAC_MAYORS_HOUSE_UNLINKED_GIRL $c2

;;
.define INTERAC_ZELDA_KIDNAPPED_ROOM $c3

;;
.define INTERAC_ZELDA_VILLAGERS_ROOM $c4

;;
.define INTERAC_D4_HOLES_FLOORTRAP_ROOM $c5

;;
.define INTERAC_HEROS_CAVE_SWORD_CHEST $c6

;;
.define INTERAC_BOOMERANG_SUBROSIAN $c8

;;
.define INTERAC_BOOMERANG $c9

;;
.define INTERAC_TROY $ca

;;
; @subid_00{Beneath grave, awaiting secret}
; @subid_01{Red/Blue(?) ghini during minigame}
; @subid_02{Red/Blue(?) ghini during minigame}
; @subid_03{In Western Coast house, giving secret}
.define INTERAC_LINKED_GAME_GHINI $cb

;;
.define INTERAC_GOLDEN_CAVE_SUBROSIAN $cc

;;
; @subid_00{Inside house, awaiting a secret}
; @subid_01{Shows text swimming challenge cave}
; @subid_02{Shows treasure inside swimming challenge cave}
.define INTERAC_LINKED_MASTER_DIVER $cd

;;
; @subid_00{In Temple of Seasons, awaiting a secret}
; @subid_01{Linked game NPC near d2 (gives a secret)}
.define INTERAC_GREAT_FAIRY $d5

;;
.define INTERAC_DEKU_SCRUB $d6

.define INTERAC_STUB_d7 $d7

;;
; Gives Fairy secret
.define INTERAC_LINKED_FOUNTAIN_LADY $d8

;;
; @subid_00{Friendly Moblin (Tokay secret)}
; @subid_01{Mamayu Yan's mother (Mamamu secret)}
; @subid_02{Holly's friend (Symmetry secret)}
.define INTERAC_LINKED_SECRET_GIVERS $db

;;
; Mostly Hero's cave stuff, also reuses code for a peg-button-bridge room, and has code
; for volcano erupting cutscene, etc
;
; @subid_00{In cave with button opening bridge, requiring peg seeds to cross - creates bridge}
; @subid_01{Sets Hero's cave main entrance to linked entrance}
; @subid_02{Sets Hero's cave side entrance to linked entrance}
; @subid_03{Linked hero's cave, some multi-buttons rooms - sets bit 7 of wActiveTriggers if all set}
; @subid_04{In some linked hero's cave rooms with portals - spawns the portals}
; @subid_05{In linked heros's cave room with 5 buttons, a chest, and a portal - spawns bridge}
; @subid_06{In hero's cave magic boomerang puzzle room - drops small key}
; @subid_07{Hero's cave puzzle with 8 buttons and spawned enemies}
; @subid_08{Hero's cave puzzle with old man and dungeon chests}
; @subid_09{Same room as above - spawns portal}
; @subid_0a{Linked hero cave entrance - sets bit 4 of normal hero cave's entrance}
; @subid_0b{In Horon village screen with stump/Subrosia pirate house screen}
; @subid_0c{2 stairs leading out from D2 - shows Snake Remains text on entry}
; @subid_0d{Linked hero's cave, room above entrance - initializes dungeon on side entrance entry}
; @subid_0e{In most screens of Temple Remains, replaces some lava tiles with animated lava?}
; @subid_0f{Creates a chest on a purple tile in a linked hero's cave room}
.define INTERAC_MISCELLANEOUS_2 $dc

;;
.define INTERAC_GOLDEN_BEAST_OLD_MAN $dd

;;
; Handles the cutscene where the maku seed and the 3 essences despawn the barrier in the black
; tower.
;
; @subid_00{Maku seed (spawns the other subids)}
; @subid_01-08{Essences}
.define INTERAC_MAKU_SEED_AND_ESSENCES $de

;;
; @subid_00{To and from Subrosia}
; @subid_01{Others, eg in Linked hero's cave and to Twinrova's dungeon}
.define INTERAC_PORTAL_SPAWNER $e1

;;
; In linked game, places pyramid jewel
.define INTERAC_VIRE $e3

;;
.define INTERAC_LINKED_HEROS_CAVE_OLD_MAN $e4

;;
; Interaction to start cutscene of getting Rod of Seasons
;
; @subid_00{Spawns other subid's, and runs script}
; @subid_01{Colored sparkles coming from the seasons}
; @subid_02{Rod of seasons}
; @subid_03{Aura around Rod of seasons}
.define INTERAC_GET_ROD_OF_SEASONS $e6

;;
.define INTERAC_LONE_ZORA $e7

.endif ; ROM_SEASONS
