; This is a list of part objects common to both games. For game-specific definitions, see
; constants/{game}/interactions.s.
;
; The name "part" is a holdover from the early days of oracles hacking. "Part" was originally short
; for "particle". In the absence of any better name candidates, it stuck.
;
; Part objects are similar to enemy objects in that they're part of the same collision system, so
; they can damage / interact with Link or his items in the same way. They are generally used by
; enemy projectiles, or by other objects that need to interact with Link and his items somehow.
;
; See interactions.s for documentation on comment format.


;;
; Subids correspond to "constants/common/itemDrops.s".
;
; @var03{Nonzero if came from the ground?}
;
; @subid_00{Fairy}
; @subid_01{Heart}
; @subid_02{1 Rupee}
; @subid_03{5 Rupees}
; @subid_04{Bombs}
; @subid_05{Ember}
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
.define PART_ITEM_DROP $01

;;
; "Poof" that appears when you kill an enemy
.define PART_ENEMY_DESTROYED $02

;;
; Orb that toggles raisable blocks.
;
; @subid{0-7; the bit to set/check in wToggleBlocksState.}
.define PART_ORB $03

;;
; Boss death explosion.
;
; @subid{ID of enemy being killed (if 0, no item is dropped)}
.define PART_BOSS_DEATH_EXPLOSION $04

;;
; A switch which flips a bit in wSwitchState. Mostly just for dungeons, but is also kinda-hardcoded
; to work in ages' present overworld for the switch to Nuun Highlands.
;
; @subid{Bitmask for wSwitchState; xors that value when the switch is triggered.}
.define PART_SWITCH $05

;;
; The object at this position becomes a lightable torch. Increments wNumTorchesLit when it's lit.
;
; @subid_00{Once lit, it stays lit.}
; @subid_01{Once lit, it remains lit for [counter2] frames.}
; @subid_02{?}
.define PART_LIGHTABLE_TORCH $06

;;
; This is a shadow for an object. The shadow copies its parent's position, and gets bigger
; the closer it is to the ground. This type of shadow is larger than the "default" shadow
; that appears under Link and other enemies by setting bit 6 of the object's "visible"
; byte.
;
; The "parent" must set the shadow's relatedObj1 to the parent when it is created.
;
; @var03{Y-offset relative to parent}
; @subid_00{Small-size shadow}
; @subid_01{Medium-size shadow}
; @subid_02{Large-size shadow}
.define PART_SHADOW $07

;;
; Makes a room dark, and allows it to be lit up by lighting torches in the room. This spawns the
; necessary PART_LIGHTABLE_TORCH objects to achieve this.
;
; The YX value is actually the length of time the torches should stay lit (the value of "counter2"
; for the "PART_LIGHTABLE_TORCH" objects it spawns).
;
; @subid{Subid value for "PART_LIGHTABLE_TORCH" objects this will spawn.}
; @postype{none}
.define PART_DARK_ROOM_HANDLER $08

;;
; A button that you can step on to activate.
;
; If bit 7 of the subid is set, the button deactivates after a period of time?
;
; @subid{Value from 0-7, corresponding to a bit to set in wActiveTriggers when pressed.}
.define PART_BUTTON $09

;;
; Orb that moves back and forth horizontally. Only used in Seasons?
;
; @var03{Bitmask for wToggleBlocksState}
.define PART_MOVING_ORB $0b

;;
; Spawns a bridge. The code that spawns this must set the following variables:
;
; counter2: Length of the bridge (measured in 8x8 tiles)
;
; angle: direction it should spawn in (value from 0-3)
;
; Y: starting position (short-form)
.define PART_BRIDGE_SPAWNER $0c

;;
; This is used by ENEMY_AMBI_GUARD and subrosia hiding minigames to detect Link. This is an
; "invisible projectile" which, when it hits Link, notifies the guard/subrosian that Link has been
; seen. This object should have its "relatedObj1" set to the guard it's working for.
;
; @subid_00{"Controller"; spawns other subids as needed.}
; @subid_01{An "invisible projectile".}
; @subid_02{An "invisible projectile" that only lasts 4 frames; angle is offset by var03.}
; @subid_03{Like subid 2, but var03's offset is counterclockwise.}
.define PART_DETECTION_HELPER $0e

;;
; Respawnable bush that drops something when cut. Used in Ages D3 and Ramrock boss.
;
; Subid corresponts to constants/common/itemDrops.s.
;
; @subid_00{Fairy}
; @subid_01{Heart}
; @subid_02{1 Rupee}
; @subid_03{5 Rupees}
; @subid_04{Bombs}
; @subid_05{Ember}
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
.define PART_RESPAWNABLE_BUSH $0f

;;
; Seed on a seed tree.
;
; relatedObj2 does something?
;
; @subid{Seed type (0-5)}
.define PART_SEED_ON_TREE $10

;;
; @subid_00{?}
; @subid_01{Rock from a volcano?}
; @subid_02{Like subid 1, but falls directly from the sky instead of shooting up first?}
.define PART_VOLCANO_ROCK $11

;;
; Created when an enemy is burned.
.define PART_BURNING_ENEMY $12

;;
.define PART_OWL_STATUE $13

;;
; Item drops from the maple scramble.
;
; Maple sets these to state 4 when being collected.
;
; @subid{Corresponds to the item. Bit 7 of subid might do something?}
; @var03{Determines how many frames Maple takes to collect the item.}
.define PART_ITEM_FROM_MAPLE $14

;;
; See PART_ITEM_FROM_MAPLE documentation.
.define PART_ITEM_FROM_MAPLE_2 $15

;;
.define PART_GASHA_TREE $17

;;
.define PART_OCTOROK_PROJECTILE $18

;;
; @subid_00{?}
; @subid_01{Used by river zoras}
.define PART_ZORA_FIRE $19

;;
; Used by moblins, darknuts
.define PART_ENEMY_ARROW $1a

;;
.define PART_LYNEL_BEAM $1b

;;
.define PART_STALFOS_BONE $1c

;;
; Invisible object which provides collisions for enemy swords
.define PART_ENEMY_SWORD $1d

;;
.define PART_DEKU_SCRUB_PROJECTILE $1e

;;
.define PART_WIZZROBE_PROJECTILE $1f

;;
; Created by fire keese
.define PART_FIRE $20

;;
.define PART_MOBLIN_BOOMERANG $21

;;
.define PART_CUCCO_ATTACKER $22

;;
; Fire that falls down from its initial position, and respawns back there after a set amount of
; time. They're always used with "pipes" that they appear to come from.
.define PART_FALLING_FIRE $23

;;
; @subid_00{Shoots up}
; @subid_01{Shoots right}
; @subid_02{Shoots down}
; @subid_03{Shoots left}
.define PART_WALL_ARROW_SHOOTER $25

;;
; Lightning strikes a specified position
.define PART_LIGHTNING $27

;;
.define PART_SMALL_FAIRY $28

;;
.define PART_BEAM $29

;;
; Used by ENEMY_BALL_AND_CHAIN_SOLDIER.
;
; @subid_00{The ball}
; @subid_01{Part of the chain; 3/4ths extended}
; @subid_02{Part of the chain; 1/2 extended}
; @subid_03{Part of the chain; 1/4th extended}
.define PART_SPIKED_BALL $2a

;;
; Decorative heart when Great Fairy is healing Link
.define PART_GREAT_FAIRY_HEART $30

;;
; Also used by ENEMY_PODOBOO_TOWER, ENEMY_FIREBALL_SHOOTER, ENEMY_MAGUNESU, ENEMY_MANHANDLA
.define PART_GOPONGA_PROJECTILE $31

;;
; relatedObj2 is ENEMY_VIRE
; @subid_00-02{?}
.define PART_VIRE_PROJECTILE $3a

;;
; @subid_00{Normal}
; @subid_01{Has no special case for reducing speed when thrown onto king moblin's platform}
.define PART_KING_MOBLIN_BOMB $3f

;;
.define PART_RED_TWINROVA_PROJECTILE $4b

;;
; Used by ENEMY_MERGED_TWINROVA
.define PART_TWINROVA_FLAME $4c

;;
.define PART_BLUE_TWINROVA_PROJECTILE $4d

;;
.define PART_TWINROVA_SNOWBALL $4e

;;
; Used by Ganon. (Seems to be invisible, only there to provide collisions?)
.define PART_GANON_TRIDENT $50

;;
; Used by Ganon
.define PART_51 $51

;;
; Used by Ganon
.define PART_52 $52

;;
; Used by "createEnergySwirl" functions
.define PART_BLUE_ENERGY_BEAD $53
