; This is a list of enemy objects common to both games. For game-specific definitions, see
; constants/{game}/interactions.s.
;
; Enemy objects are fairly straghtforward. They're enemies. Their most notable quality is that they
; can do damage to Link and take damage from items. (Part objects can also do this.)
;
; Enemies $00-$07, and $68-$7f, count as bosses. (These ID ranges are checked in
; enemyBossCommon.s.)
;
; See interactions.s for documentation on comment format.
;
; TODO: determine which enemies are supposed to count toward wNumEnemies, and which don't.


;;
.define ENEMY_STUB_00 $00

;;
.define ENEMY_MERGED_TWINROVA $01

;;
; @subid_00{Red twinrova}
; @subid_01{Blue twinrova}
.define ENEMY_TWINROVA $03

;;
; King of Evil
.define ENEMY_GANON $04

;;
.define ENEMY_RIVER_ZORA $08

;;
; @subid_00{Red octorok}
; @subid_01{Red octorok, faster}
; @subid_02{Blue octorok}
; @subid_03{Blue octorok, faster}
; @subid_04{Golden octorok (once dead, it's gone forever)}
.define ENEMY_OCTOROK $09

;;
; Moblin with boomerang.
;
; @subid_00{Red moblin}
; @subid_01{Blue moblin}
.define ENEMY_BOOMERANG_MOBLIN $0a

;;
; If used in a large room, they will only spawn in the top-left part of it (the normal
; boundaries of a small room).
;
; @subid_00{Red leever; tries to spawn right in front of Link.}
; @subid_01{Blue leever; spawns anywhere on-screen, chases Link more effectively.}
; @subid_02{Gold (respawning) leever; much faster; spawns in fixed position.}
.define ENEMY_LEEVER $0b

;;
; Moblin with arrows.
;
; @subid_00{Red moblin}
; @subid_01{Blue moblin}
; @subid_02{Golden moblin (once dead, it's gone forever)}
.define ENEMY_ARROW_MOBLIN $0c

;;
; @subid_00{Red lynel}
; @subid_01{Blue lynel}
; @subid_02{Golden lynel (once dead, it's gone forever)}
.define ENEMY_LYNEL $0d

;;
; For circular blade traps (subids 3-4), Y is the shortened YX position, while X is the
; radius of the circle. For other types of blade traps, Y and X are normal.
;
; @subid_00{Red spinning trap (unlimited range, does not return to start position)}
; @subid_01{Blue blade trap (reaches exactly to the center of a large room)}
; @subid_02{Gold blade trap (fast, same range as blue trap)}
; @subid_03{Green blade trap, moving in a circle, clockwise
;           @postype{short}}
; @subid_04{Green blade trap, moving in a circle, counterclockwise
;           @postype{short}}
; @subid_05{Green blade trap (unlimited range)}
.define ENEMY_BLADE_TRAP $0e

;;
; Rope = snake
;
; @subid_00{Normal}
; @subid_01{Falls from ceiling}
; @subid_02{Immediately charges Link upon spawning}
; @subid_03{Falls and bounces toward Link when it spawns}
.define ENEMY_ROPE $10

;;
.define ENEMY_GIBDO $12

;;
.define ENEMY_SPARK $13

;;
; Enemies you need to flip over with your shield or shovel.
.define ENEMY_SPIKED_BEETLE $14

;;
; Disables your sword
.define ENEMY_BUBBLE $15

;;
; Simliar to ENEMY_PODOBOO, this enemy's collisions are sometimes borrowed by other
; objects (ie. ENEMY_MERGED_TWINROVA).
.define ENEMY_BEAMOS $16

;;
; @subid_00{A tame ghini which only moves along cardinal directions.}
; @subid_01{Takes a second to fade in while spawning. Moves around at various speeds and
;           along diagonals. Killing it makes all other ghinis with subid $01 die at the
;           same time?}
; @subid_02{Chooses random target positions across the screen, and charges toward them.}
.define ENEMY_GHINI $17

;;
.define ENEMY_BUZZBLOB $18

;;
.define ENEMY_WHISP $19

;;
.define ENEMY_SAND_CRAB $1a

;;
; Beetle that hides under a bush or rock (ENEMY_BUSH_OR_ROCK).
;
; @subid_00{Hiding in bush (overworld only)}
; @subid_01{Hiding in bush (dungeons only)}
; @subid_02{Hiding in pot (dungeons only)}
; @subid_03{Hiding in rock (overworld only)}
.define ENEMY_SPINY_BEETLE $1b

;;
; @subid_00{Has mask on}
; @subid_01{Doesn't have mask on}
.define ENEMY_IRON_MASK $1c

;;
; Spawns armos from all tiles of a given type. All tiles of index "Y" turn into armos;
; the tile in question gets replaced with index "X" when they spawn.
;
; If bit 7 of subid is set, the armos spawns at the position given (Y and X behave
; normally); and the tile the armos was at is replaced with "var30". Since var30 can't be
; set in the editor, this feature should only be used internally by the game's code.
;
; @postype{none}
; @Y{Tile index to spawn armos on (ie. $26))
; @X{Tile index to replace those tiles with once the armos spawn (ie. $a0)}
; @subid_00{Red: activates when touched, or when nonzero is written to $cca2.}
; @subid_01{Blue: activates when Link is close to it. Faster, extra health, moves toward
;           Link more actively. Records positions of killed armos in $cfd0-$cfdf. (Might
;           be used in a seasons puzzle?)}
.define ENEMY_ARMOS $1d

;;
; Flopping fish in a top-down area.
;
; @subid_00{Standard fish}
; @subid_01{Unused?}
.define ENEMY_PIRANHA $1e

;;
; The type of moblin you'd see in the Goron area, with white horns, shoots arrows
;
; @subid_00{Red}
; @subid_01{Blue}
.define ENEMY_MASKED_MOBLIN $20

;;
; Darknut that shoots arrows.
;
; @subid_00{Red}
; @subid_01{Blue}
; @subid_02{Gold}
.define ENEMY_ARROW_DARKNUT $21

;;
; Shrouded stalfos that shoots arrows
.define ENEMY_ARROW_SHROUDED_STALFOS $22

;;
.define ENEMY_POLS_VOICE $23

;;
; @subid_00{Normal like-like}
; @subid_01{Like-like spawner. Hardcoded to only work in Season's lost woods.}
; @subid_02{Spawning in from left or bottom of screen (used with like-like spawner)}
; @subid_03{Falls from sky (used with like-like spawner)}
.define ENEMY_LIKE_LIKE $24

;;
; @subid_00{Goponga flower, like from link's awakening}
; @subid_01{Unused, upgraded version of goponga flower. Shoots more often. Looks pretty
;           cool.}
.define ENEMY_GOPONGA_FLOWER $25

;;
; Deku scrub that shoots seeds at you. His "bush" graphic (ENEMY_BUSH_OR_ROCK) only
; works outdoors.
;
; @var03{Low byte of text index to show when talking to the scrub (TX_45XX)}
.define ENEMY_DEKU_SCRUB $27

;;
; Falls from the ceiling to take you to the beginning of a dungeon.
;
; @Y{Number of wallmasters spawner should make before stopping}
; @postype{none}
; @subid_00{Wallmaster spawner; spawns subid 1 every 2 seconds.}
; @subid_01{Y/X behave normally. A single wallmaster which, when it dies, does not come
;           back.
;           @postype{normal}}
.define ENEMY_WALLMASTER $28

;;
; Lava enemy in sidescrolling areas.
;
; Note that this object's "collisionType" value is used by certain other objects when they
; enter invincible states (armos and shadow hag).
;
; @subid_00{The podoboo itself}
; @subid_01{Small flames that only act as decoration?}
.define ENEMY_PODOBOO $29

;;
; @subid_00{Green, doesn't move}
; @subid_01{Blue, moves up, then clockwise when it hits a wall, slow constant speed}
; @subid_02{Red, like blue but faster, and it accelerates}
; @subid_03{Plain, same as Red but starts facing down, moves counterclockwise}
.define ENEMY_GIANT_BLADE_TRAP $2a

;;
; Fish in sidescrolling areas that moves back and forth.
;
; @var03{How far to travel per cycle (in pixels)}
; @subid_00{Moves left, right}
; @subid_01{Moves down, up}
.define ENEMY_CHEEP_CHEEP $2c

;;
; Flame tower enemy
.define ENEMY_PODOBOO_TOWER $2d

;;
.define ENEMY_THWIMP $2e

;;
.define ENEMY_THWOMP $2f

;;
; @subid_00{Plain}
; @subid_01{Blue, more health, jumps more often}
.define ENEMY_TEKTITE $30

;;
; @subid_00{Plain}
; @subid_01{Red (jumps away from you, more health)}
; @subid_02{Orange (like red, also shoots bones at you)}
; @subid_03{Green (like red, but doesn't shoot bones, and tries to stomp on Link)}
.define ENEMY_STALFOS $31

;;
; Goddamned annoying bat enemy
;
; @subid_00{Moves all the time}
; @subid_01{Only moves when Link approaches, moves in circular patterns}
.define ENEMY_KEESE $32

;;
; Baby chicken that follows you around. Only coded properly for small rooms.
.define ENEMY_BABY_CUCCO $33

;;
; @subid_00{Green (one hit, disappears into ground)}
; @subid_01{Red (splits into ENEMY_GEL, doesn't disappear)}
.define ENEMY_ZOL $34

;;
; Blue hand that appears from the ground and warps you to dungeon entrance. Only subid 0,
; the spawner, should be used; it takes care of spawning the actual floormasters. Bugs may
; occur if the other subids are used by themselves.
;
; This might not work properly in small rooms (could spawn outside the screen).
;
; @postype{none}
; @Y{High digit is number of floormasters to spawn}
; @X{High digit is the subid of floormasters to spawn (minus one). Ie. "$20" spawns
;    wallmasters with subid 3.}
; @subid_00{Floormaster spawner.
;           @postype{none}}
; @subid_01{Only moves in cardinal directions toward Link}
; @subid_02{Moves in any direction toward Link}
; @subid_03{Moves in any direction toward Link, fast}
.define ENEMY_FLOORMASTER $35

;;
; Adult chicken. Doesn't work 100% in large rooms. See also INTERAC_CUCCO.
;
; Transforms into ENEMY_BABY_CUCCO or ENEMY_GIANT_CUCCO when mystery seeds are used on
; it (depends if the cucco revenge squad has been called in or not).
.define ENEMY_CUCCO $36

;;
; The most fearsome of enemies, the butterfly
.define ENEMY_BUTTERFLY $37

;;
; Heals you up. (See also INTERAC_GREAT_FAIRY for cutscenes & other stuff.)
.define ENEMY_GREAT_FAIRY $38

;;
; Goddamned annoying bat enemy (on fire)
;
; Doesn't work quite right in outdoor areas since it looks for torches to light itself back on fire
; (tile index $09, which is different outdoors). Also, it assumes that it's in a large room for
; various things (ie. room boundary checking).
;
; @subid_00{Has "height", and moves in a circle (clockwise/counterclockwise chosen randomly) until
;           Link approaches; it will attempt to divebomb him.}
; @subid_01{No height; very similar to a normal keese, except on fire.}
.define ENEMY_FIRE_KEESE $39

;;
.define ENEMY_WATER_TEKTITE $3a

;;
; Transforms from normal Cucco to attack Link.
;
; This is somewhat bugged in Ages? After attacking it once, it just runs away from Link
; forever, and its collisions become disabled. Behaves different in Seasons; after
; attacking it 8 times, it charges at Link, and will not stop... until he is dead.
;
; This bug seems to result from its health value being 0 (it doesn't die). Perhaps an
; engine feature relating to this was added in Ages, which caused the bug?
.define ENEMY_GIANT_CUCCO $3b


;;
; Moblin with a sword.
;
; @subid_00{Red}
; @subid_01{Blue}
; @subid_02{Blue, less cooldown between charges}
.define ENEMY_SWORD_MOBLIN $3d

;;
.define ENEMY_PEAHAT $3e

;;
; @subid_00{Green, stationary}
; @subid_01{Red, warps around}
; @subid_02{Blue, moves around}
.define ENEMY_WIZZROBE $40

;;
; Black crow. Behaviour is (almost) identical to ENEMY_BLUE_CROW.
;
; Only works properly in small rooms (they disappear at the boundaries of a small room).
;
; @subid_00{Perched, waiting for Link to approach.}
; @subid_01{Spawns crows from outside the screen; maximum of two at a time.}
.define ENEMY_CROW $41

;;
; ENEMY_ZOL splits into ENEMY_GEL's after being attacked.
.define ENEMY_GEL $43

.define ENEMY_STUB_44 $44

;;
; Hides in ground or in a hole to attack Link when he approaches.
; @subid_00{Spawner; spawns all 4 components of the pincer, then deletes self. Use this.}
; @subid_01{Head of pincer}
; @subid_02{Body part (3/4ths extended)}
; @subid_03{Body part (1/2 extended)}
; @subid_04{Body part (1/4th extended)}
.define ENEMY_PINCER $45

;;
; Darknut with a sword.
; @subid_00{Red}
; @subid_01{Blue}
; @subid_02{Gold}
.define ENEMY_SWORD_DARKNUT $48

;;
; Shrouded stalfos with a sword.
; @subid_00{Normal}
; @subid_01{Less cooldown between charges}
; @subid_02{Even less cooldown between charges}
.define ENEMY_SWORD_SHROUDED_STALFOS $49

;;
; The type of moblin you'd see in the Goron area, with white horns, with sword
; @subid_00{Red}
; @subid_01{Blue}
; @subid_02{Blue, less cooldown between charges}
.define ENEMY_SWORD_MASKED_MOBLIN $4a

;;
.define ENEMY_BALL_AND_CHAIN_SOLDIER $4b

;;
; Blue crow. Behaviour is (almost) identical to ENEMY_CROW.
;
; Only works properly in small rooms (they disappear at the boundaries of a small room).
;
; @subid_00{Perched, waiting for Link to approach}
; @subid_01{Spawns crows from outside the screen. No maximum of two at a time as with
;           ENEMY_CROW, but this is probably an oversight. If more than two are used,
;           multiple crows will spawn in the same spot.}
.define ENEMY_BLUE_CROW $4c

;;
; Enemies you need to push into holes to kill
.define ENEMY_HARDHAT_BEETLE $4d

;;
; Moves in the opposite direction Link is moving.
.define ENEMY_ARM_MIMIC $4e

;;
; @subid_00{Spawner; spawns all 3 components of the moldorm, then deletes self. Use this.}
; @subid_01{The head}
; @subid_02{Tail 1}
; @subid_03{Tail 2}
.define ENEMY_MOLDORM $4f

;;
; @var03{For subids $80+ only, this is a value from 0-3, which acts as an initial "timing
;        offset" so they don't all fire at the same time.}
; @subid_00{Shoots fireballs from all tiles with index equal to given "Y" parameter.
;           Does not stop when all enemies are killed.
;           @postype{none}}
; @subid_01{Shoots fireballs from all tiles with index equal to given "Y" parameter.
;           Stops when all enemies are killed.
;           @postype{none}}
; @subid_80{Shoots fireballs at Link from the actual position object is placed at.
;           Does not stop when all enemies are killed.
;           @postype{normal}}
; @subid_81{Shoots fireballs at Link from the actual position object is placed at.
;           Stops when all enemies are killed.
;           @postype{normal}}
.define ENEMY_FIREBALL_SHOOTER $50

;;
; @subid_00{Spawns beetles at this position when Link is close. (No limit... this could
;           easily fill all enemy slots.)}
; @subid_01{Beetle falls in from sky}
; @subid_02{Beetle appears instantly}
; @subid_03{Beetle "bounces" as he spawns, in the direction Link is facing. (Dug up from
;           ground)}
.define ENEMY_BEETLE $51

;;
; Creates a bunch of tiles from the ground that attack Link.
;
; @postype{none}
; @subid_00-02{"Spawners" for flying tiles. Each subid in this range has a hardcoded
;              pattern that it follows.}
; @subid_80-84{Actual tiles that spawn at the given position. The range of subids have
;              different values for the tile that gets replaced underneath them.
;              @postype{normal}}
.define ENEMY_FLYING_TILE $52

;;
; Decorative bug, non-interactable. Only designed to work in small rooms (moves roughly
; around the center of a small room)
;
; @subid{Gets written directly to oamFlags?}
.define ENEMY_DRAGONFLY $53

;;
.define ENEMY_STUB_57 $57

;;
; This is a bush, rock, or pot which rests on top of another enemy. Used by
; ENEMY_SPINY_BEETLE, ENEMY_DEKU_SCRUB.
;
; relatedObj1 should point to an enemy object, its "parent". If parent.var03 bit 7 is set,
; this is grabbable. Bits 0-1 of var03 determines Z position (how high above parent to
; place this at).
;
; @subid_00{Overworld bush}
; @subid_01{Dungeon bush}
; @subid_02{Dungeon pot}
; @subid_03{Overworld rock}
.define ENEMY_BUSH_OR_ROCK $58

;;
; Invisible object. This is made whenever an "item drop" object is in a room, and it
; spawns PART_ITEM_DROP when the tile at its position is destroyed.
;
; The reason this is an enemy is probably so it can use the "markEnemyAsKilledInRoom"
; function to prevent item drops from respawning for a while.
;
; Subid corresponds to constants/common/itemDrops.s.
;
; @subid_00{Fairy}
; @subid_01{Heart}
; @subid_02{1 rupee}
; @subid_03{5 rupees}
; @subid_04{Bombs}
; @subid_05{Ember seeds}
; @subid_06{Scent seeds}
; @subid_07{Pegasus seeds}
; @subid_08{Gale seeds}
; @subid_09{Mystery seeds}
; @subid_0a{Unused}
; @subid_0b{Unused}
; @subid_0c{Blue ore chunk (1)}
; @subid_0d{Red ore chunk (10)}
; @subid_0e{Gold ore chunk (50)}
; @subid_0f{100 rupees (1/8 chance) or an enemy (rope or beetle, 7/8 chance)}
.define ENEMY_ITEM_DROP_PRODUCER $59

;;
; Spawns seeds on a tree (corresponding "PART_SEED_ON_TREE" object).
; @subid{Bits 0-3: Index for "wSeedTreeRefilledBitset". Must be unique.\n
;        Bits 4-7: Seed type (0-4).}
; @postype{none}
.define ENEMY_SEEDS_ON_TREE $5a

;;
; Ice projectiles used in Twinrova battle
.define ENEMY_TWINROVA_ICE $5d

;;
; Bat enemy that merged Twinrova spawns during the fight
.define ENEMY_TWINROVA_BAT $5e

;;
; Part of cutscene for Ganon revival; darkens screen, makes shadows come toward Twinrova.
;
; @subid_00{Cutscene controller}
; @subid_01{An individual shadow}
.define ENEMY_GANON_REVIVAL_CUTSCENE $60

.define ENEMY_STUB_65 $65
.define ENEMY_STUB_66 $66
.define ENEMY_STUB_67 $67
.define ENEMY_STUB_68 $68
.define ENEMY_STUB_69 $69
.define ENEMY_STUB_6a $6a
.define ENEMY_STUB_6b $6b
.define ENEMY_STUB_6c $6c
.define ENEMY_STUB_6d $6d
.define ENEMY_STUB_6e $6e
.define ENEMY_STUB_6f $6f

;;
; @subid_00{Main form}
; @subid_01{Bat form}
.define ENEMY_VIRE $75
