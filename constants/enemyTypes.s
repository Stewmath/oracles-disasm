; See interactionTypes.s for documentation on comment format.

.define ENEMYID_MERGED_TWINROVA			$01

;;
; See also INTERACID_VERAN_CUTSCENE_FACE (triggers cutscene for this)
.define ENEMYID_VERAN_FINAL_FORM		$02
.define ENEMYID_TWINROVA			$03
.define ENEMYID_GANON				$04
.define ENEMYID_05				$05

.define ENEMYID_VERAN_HUMAN			$06

;;
; @palette{PALH_83}
.define ENEMYID_RAMROCK				$07

;;
.define ENEMYID_RIVER_ZORA			$08

;;
; @subid_00{Red octorok}
; @subid_01{Red octorok, faster}
; @subid_02{Blue octorok}
; @subid_03{Blue octorok, faster}
; @subid_04{Golden octorok (once dead, it's gone forever)}
.define ENEMYID_OCTOROK				$09

;;
; Moblin with boomerang.
; @subid_00{Red moblin}
; @subid_01{Blue moblin}
.define ENEMYID_BOOMERANG_MOBLIN		$0a

;;
; If used in a large room, they will only spawn in the top-left part of it (the normal
; boundaries of a small room).
;
; @subid_00{Red leever; tries to spawn right in front of Link.}
; @subid_01{Blue leever; spawns anywhere on-screen, chases Link more effectively.}
; @subid_02{Gold (respawning) leever; much faster; spawns in fixed position.}
.define ENEMYID_LEEVER				$0b

;;
; Moblin with arrows.
; @subid_00{Red moblin}
; @subid_01{Blue moblin}
; @subid_02{Golden moblin (once dead, it's gone forever)}
.define ENEMYID_ARROW_MOBLIN			$0c

;;
; @subid_00{Red lynel}
; @subid_01{Blue lynel}
; @subid_02{Golden lynel (once dead, it's gone forever)}
.define ENEMYID_LYNEL				$0d

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
.define ENEMYID_BLADE_TRAP			$0e

;;
; Spider that Veran spawns when fighting posessed Ambi
; @palette{PALH_8a}
.define ENEMYID_VERAN_SPIDER			$0f

;;
; Rope = snake
; @subid_00{Normal}
; @subid_01{Falls from ceiling}
; @subid_02{Immediately charges Link upon spawning}
; @subid_03{Falls and bounces toward Link when it spawns}
.define ENEMYID_ROPE				$10

;;
; Part of D4 boss (ENEMYID_EYESOAR)
.define ENEMYID_EYESOAR_CHILD			$11

;;
.define ENEMYID_GIBDO				$12

;;
.define ENEMYID_SPARK				$13

;;
; Enemies you need to flip over with your shield or shovel.
.define ENEMYID_SPIKED_BEETLE			$14

;;
; Disables your sword
.define ENEMYID_BUBBLE				$15

;;
.define ENEMYID_BEAMOS				$16

;;
; @subid_00{A tame ghini which only moves along cardinal directions.}
; @subid_01{Takes a second to fade in while spawning. Moves around at various speeds and
;           along diagonals. Killing it makes all other ghinis with subid $01 die at the
;           same time?}
; @subid_02{Chooses random target positions across the screen, and charges toward them.}
.define ENEMYID_GHINI				$17

;;
.define ENEMYID_BUZZBLOB			$18

;;
.define ENEMYID_WHISP				$19

;;
.define ENEMYID_SAND_CRAB			$1a

;;
; Beetle that hides under a bush or rock (ENEMYID_BUSH_OR_ROCK).
;
; @subid_00{Hiding in bush (overworld only)}
; @subid_01{Hiding in bush (dungeons only)}
; @subid_02{Hiding in pot (dungeons only)}
; @subid_03{Hiding in rock (overworld only)}
.define ENEMYID_SPINY_BEETLE			$1b

;;
; @subid_00{Has mask on}
; @subid_01{Doesn't have mask on}
.define ENEMYID_IRON_MASK			$1c

;;
; Spawn armos from all tiles of a given type.
; @postype{none}
; @Y{Tile index to spawn armos on (ie. $26))
; @X{Tile index to replace those tiles with once the armos spawn (ie. $a0)}
.define ENEMYID_ARMOS				$1d

;;
; Flopping fish in a top-down area
.define ENEMYID_FISH				$1e

;;
; Something that flies at you then despawns when off-screen. (Missing palette?)
.define ENEMYID_1f				$1f

;;
; The type of moblin you'd see in the Goron area, with white horns, shoots arrows
; @subid_00{Red}
; @subid_01{Blue}
.define ENEMYID_MASKED_MOBLIN			$20

;;
; Darknut that shoots arrows.
; @subid_00{Red}
; @subid_01{Blue}
; @subid_02{Gold}
.define ENEMYID_ARROW_DARKNUT			$21

;;
; Shrouded stalfos that shoots arrows
.define ENEMYID_ARROW_SHROUDED_STALFOS		$22

;;
.define ENEMYID_POLS_VOICE			$23

.define ENEMYID_LIKE_LIKE			$24

;;
.define ENEMYID_GOPONGA_FLOWER			$25

;;
; ?
.define ENEMYID_26				$26

;;
; Deku scrub that shoots seeds at you
.define ENEMYID_DEKU_SCRUB			$27

;;
; Falls from the ceiling to take you to the beginning of a dungeon.
.define ENEMYID_WALLMASTER			$28

;;
; Subid 0 spawns "podoboos", which look like pieces of lava that shoot straight up.
.define ENEMYID_PODOBOO				$29

;;
; @subid_00{Green, doesn't move}
; @subid_01{Blue, moves up, then clockwise when it hits a wall}
; @subid_02{Red, like blue but faster}
; @subid_03{Plain, moves down, thes clockwise when it hits a wall}
.define ENEMYID_GIANT_BLADE_TRAP		$2a

;;
; This object allows down-transitions to work in sidescrolling areas when it is present.
; In particular, it forces a transition to occur if Link falls onto the bottom boundary of
; the screen.
.define ENEMYID_ENABLE_SIDESCROLL_DOWN_TRANSITION	$2b

;;
; Moves from side-to-side.
.define ENEMYID_CHEEP_CHEEP			$2c

;;
; Flame tower enemy
.define ENEMYID_PODOBOO_TOWER			$2d

;;
.define ENEMYID_THWIMP				$2e

.define ENEMYID_THWOMP				$2f

;;
; @subid_00{Plain}
; @subid_01{Blue}
.define ENEMYID_TEKTITE				$30

;;
; @subid_00{Plain}
; @subid_01{Red (jumps away from you, more health)}
; @subid_02{Orange (jumps away from you, more health, shoots bones at you)}
; @subid_03{Green (like red?}}
.define ENEMYID_STALFOS				$31

;;
; Goddamned annoying bat enemy
.define ENEMYID_KEESE				$32

;;
; Baby chicken that follows you around
.define ENEMYID_BABY_CUCCO			$33

;;
; @subid_00{Green (one hit, disappears into ground)}
; @subid_01{Red (splits into ENEMYID_GEL, doesn't disappear)}
.define ENEMYID_ZOL				$34

;;
; Blue hand that appears from the ground and warps you to dungeon entrance
.define ENEMYID_FLOORMASTER			$35

;;
; Adult chicken
.define ENEMYID_CUCCO				$36

;;
; The most fearsome of enemies, the butterfly
.define ENEMYID_BUTTERFLY			$37

;;
; Heals you up
.define ENEMYID_GREAT_FAIRY			$38

;;
; Goddamned annoying bat enemy (on fire)
.define ENEMYID_FIRE_KEESE			$39

;;
.define ENEMYID_WATER_TEKTITE			$3a

;;
.define ENEMYID_GIANT_CUCCO			$3b

;;
; Jellyfish enemy that splits in two.
; @subid_00{Normal version}
; @subid_00{Split version}
.define ENEMYID_BARI				$3c

;;
; Moblin with a sword.
; @subid_00{Red}
; @subid_01{Blue}
.define ENEMYID_SWORD_MOBLIN			$3d

;;
.define ENEMYID_PEAHAT				$3e

;;
; Smaller enemies used in Giant Ghini fight
.define ENEMYID_GIANT_GHINI_CHILD		$3f

;;
; @subid_00{Green, stationary}
; @subid_01{Red, warps around}
; @subid_02{Blue, moves around}
.define ENEMYID_WIZZROBE			$40

;;
; Black crow. See also ENEMYID_BLUE_CROW.
.define ENEMYID_CROW				$41

;;
; Smaller enemies used in shadow hag fight
.define ENEMYID_SHADOW_HAG_CHILD		$42

;;
; ENEMYID_ZOL splits into ENEMYID_GEL's after being attacked.
.define ENEMYID_GEL				$43

;;
.define ENEMYID_STUB_44				$44

;;
; Hides in ground or in a hole to attack Link when he approaches.
.define ENEMYID_PINCER				$45

;;
.define ENEMYID_STUB_46				$46

;;
; Enemies in floor-tile-changing puzzles in Ages only.
.define ENEMYID_COLOR_CHANGING_GEL		$47

;;
; Darknut with a sword.
; @subid_00{Red}
; @subid_01{Blue}
; @subid_02{Gold}
.define ENEMYID_SWORD_DARKNUT			$48

;;
; Shrouded stalfos with a sword.
.define ENEMYID_SWORD_SHROUDED_STALFOS		$49

;;
; The type of moblin you'd see in the Goron area, with white horns, with sword
; @subid_00{Red}
; @subid_01{Blue}
.define ENEMYID_SWORD_MASKED_MOBLIN		$4a

;;
.define ENEMYID_BALL_AND_CHAIN_SOLDIER		$4b

;;
; Similar to ENEMYID_CROW.
; @subid_00{Perched, waiting for Link to approach}
; @subid_01{Spawns crows from outside the screen}
.define ENEMYID_BLUE_CROW			$4c

;;
; Enemies you need to push into holes to kill
.define ENEMYID_HARDHAT_BEETLE			$4d

;;
.define ENEMYID_MIMIC				$4e

;;
.define ENEMYID_MOLDORM				$4f

;;
; @postype{none}
; @subid_01{Shoots fireballs from all tiles with index equal to given "Y" parameter.
;           @postype{none}}
; @subid_80{Shoots fireballs at Link from the actual position object is placed at.
;           @postype{normal}}
.define ENEMYID_FIREBALL_SHOOTER		$50

;;
; @subid_00{Spawns beetles at this position}
; @subid_01{Beetle falls in from sky}
; @subid_02{Beetle appears instantly}
; @subid_03{Beetle "bounces" as he spawns?}
.define ENEMYID_BEETLE				$51

;;
; @subid{The "index" of the "flying tile data" to use (which tiles attack)? Hardcoded?}
.define ENEMYID_FLYING_TILE			$52

;;
.define ENEMYID_DRAGONFLY			$53

;;
; Guard in Ambi's palace (kicks you out if he sees you)
.define ENEMYID_AMBI_GUARD			$54

.define ENEMYID_CANDLE				$55

;;
; "Decorative" moblins that don't do anything? Subids 0-3 have various positions?
.define ENEMYID_56				$56

;;
.define ENEMYID_STUB_57				$57

;;
; This is a bush, rock, or pot which rests on top of another enemy. Used by
; ENEMYID_SPINY_BEETLE, ENEMYID_DEKU_SCRUB.
;
; relatedObj1 should point to an enemy object, its "parent". If parent.var03 bit 7 is set,
; this is grabbable. Bits 0-1 of var03 determines Z position (how high above parent to
; place this at).
;
; @subid_00{Overworld bush}
; @subid_01{Dungeon bush}
; @subid_02{Dungeon pot}
; @subid_03{Overworld rock}
.define ENEMYID_BUSH_OR_ROCK			$58

;;
; Invisible object
.define ENEMYID_ITEM_DROP_PRODUCER		$59

;;
; Spawns seeds on a tree (corresponding "PARTID_SEED_ON_TREE" object).
; @subid{Bits 0-3: Index for "seedTreeRefilledBitset".\n
;        Bits 4-7: Seed type (0-4).}
.define ENEMYID_SEEDS_ON_TREE			$5a

.define ENEMYID_STUB_5b				$5b
.define ENEMYID_STUB_5c				$5c

;;
; Ice projectiles used in Twinrova battle
.define ENEMYID_TWINROVA_ICE			$5d

;;
.define ENEMYID_5e				$5e

;;
; Hardhat beetle that just pushes Link away. Has a purple tint.
; @palette{PALH_8d}
.define ENEMYID_HARMLESS_HARDHAT_BEETLE		$5f

;;
; Part of cutscene for Ganon revival or something?
.define ENEMYID_60				$60

;;
; Fight either Nayru or Ambi posessed by Nayru.
;
; This doesn't load the needed palette; assumes it's loaded already?
;
; @subid_00{Nayru}
; @subid_01{Ambi}
; @palette{PALH_85}
.define ENEMYID_VERAN_POSESSION_BOSS		$61

;;
; This should never be used manually
.define ENEMYID_VINE_SPROUT			$62

; Crystals for target carts?
.define ENEMYID_TARGET_CART_CRYSTAL		$63

;;
; Used in final battle against Veran.
; @palette{PALH_82}
.define ENEMYID_LINK_MIMIC			$64

.define ENEMYID_STUB_65				$65
.define ENEMYID_STUB_66				$66
.define ENEMYID_STUB_67				$67
.define ENEMYID_STUB_68				$68
.define ENEMYID_STUB_69				$69
.define ENEMYID_STUB_6a				$6a
.define ENEMYID_STUB_6b				$6b
.define ENEMYID_STUB_6c				$6c
.define ENEMYID_STUB_6d				$6d
.define ENEMYID_STUB_6e				$6e
.define ENEMYID_STUB_6f				$6f


; ================================================================================
; Minibosses
; ================================================================================

.define ENEMYID_GIANT_GHINI			$70
.define ENEMYID_SWOOP				$71
.define ENEMYID_DIGDOGGER			$72
.define ENEMYID_ARMOS_WARRIOR			$73
.define ENEMYID_SMASHER				$74
.define ENEMYID_VIRE				$75
.define ENEMYID_ANGLER_FISH			$76
.define ENEMYID_BLUE_STALFOS			$77


; ================================================================================
; Bosses
; ================================================================================

.define ENEMYID_PUMPKIN_HEAD			$78
.define ENEMYID_HEAD_THWOMP			$79
.define ENEMYID_SHADOW_HAG			$7a
.define ENEMYID_EYESOAR				$7b
.define ENEMYID_SMOG				$7c
.define ENEMYID_OCTOGON				$7d
.define ENEMYID_PLASMARINE			$7e
.define ENEMYID_KING_MOBLIN			$7f

; Also ramrock with ID 7
