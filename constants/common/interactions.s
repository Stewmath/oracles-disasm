; This is a list of interaction objects common to both games. For game-specific definitions, see
; constants/{game}/interactions.s.
;
; An "interaction" is simply a type of object. The most notable quality of this type of object is
; that they can be assigned scripts (see the "scripts/" folder). This makes them well-suited to be
; used for implementing NPCs, puzzles, and a lot of other miscellaneous stuff.
;
; The comments here describe the "interface" of the objects; that is, what variables are important
; to initialize when creating them. Additional comments about internal variables used by the objects
; may be found next to their code (search for a label of the form "interactionCodeXX", where XX is
; their ID).
;
; COMMENT FORMAT:
;   LynnaLab parses the comments to glean information about interactions. When a line starts with
;   ";;", every subsequent line that starts with ";" is considered documentation until the next
;   uncommented line. Within here, the description can be typed, or fields can be entered with
;   "@field{value}".
;
;   Field list (case-insensitive):
;   * postype: Affects how to determine the object's position.
;       "normal" = Y and X positions are treated normally (default).
;       "short" = both Y and X positions are stored in Y variable.
;       "none" = this object doesn't have anything resembling a position.
;   * palette: Palette header to load. Most sprites use palettes 0-5, which are always the
;              same, but some object use slots 6-7 for custom palettes. These objects
;              should use this field.
;   * subid_XX: Description for subid XX.
;
;  You might also see some manual newline ("\n") entries sometimes since making the comments pretty
;  in both the GUI and in plaintext format is hard...


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
;   Subid: treasure index (see constants/common/treasure.s)
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
