; Note: Part IDs can't be $80 or higher (would need to modify code in objectLoading.s, possibly
; elsewhere to accomodate that)

; ==============================================================================
; Common parts (exist in ages and seasons)
; ==============================================================================

;;
; Subids correspond to "constants/itemDrops.s".
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
; Subid corresponts to constants/itemDrops.s.
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


; ==============================================================================
; Ages only
; ==============================================================================

.ifdef ROM_AGES

.define PART_STUB_0a $0a
.define PART_STUB_0d $0d

;;
.define PART_JABU_JABUS_BUBBLES $16

;;
.define PART_GROTTO_CRYSTAL $24

;;
.define PART_SPARKLE $26

;;
; Used by INTERAC_TIMEWARP
.define PART_TIMEWARP_ANIMATION $2b

;;
; Used by INTERAC_VIRE (flame used in "donkey kong" minigame)
;
; subid determines movement pattern
; @subid_00{2nd screen with Zelda}
; @subid_01{1st screen}
.define PART_DONKEY_KONG_FLAME $2c

;;
; Used by ENEMY_VERAN_FAIRY - the blue projectile often used
.define PART_VERAN_FAIRY_PROJECTILE $2d

;;
; When this object exists, it applies the effects of whirlpool and pollution tiles.
; It's a bit weird to put this functionality in an object...
.define PART_SEA_EFFECTS $2e

;;
; Turns Link into a baby
.define PART_BABY_BALL $2f

;;
; @palette(PALH_be}
.define PART_SUBTERROR_DIRT $32

;;
; Rotating things that you can shoot seeds off of
.define PART_ROTATABLE_SEED_THING $33

;;
; Used by Ramrock (seed form)
.define PART_RAMROCK_SEED_FORM_LASER $34

;;
; Used by Ramrock (glove form)
;
; @subid_00{Right hand/shoulder}
; @subid_01{Left hand/shoulder}
; @subid_80{Right hand/shoulder}
; @subid_81{Left hand/shoulder}
.define PART_RAMROCK_GLOVE_FORM_ARM $35

;;
; Flame animation used exclusively by ENEMY_CANDLE. Expects relatedObj1 to point to its
; parent.
.define PART_CANDLE_FLAME $36

;;
; Used by ENEMY_VERAN_POSSESSION_BOSS, ENEMY_VERAN_FAIRY.
;
; @subid_00{The "core" which fires the actual projectiles}
; @subid_01{An actual projectile}
.define PART_VERAN_PROJECTILE $37

;;
; Ball for the shooting gallery
.define PART_BALL $38

;;
; Projectile used by head thwomp?
.define PART_HEAD_THWOMP_FIREBALL $39


;;
; Used by head thwomp (purple face); a boulder.
.define PART_3b $3b

;;
; Used by head thwomp
.define PART_HEAD_THWOMP_CIRCULAR_PROJECTILE $3c

;;
; Subid: ?
.define PART_BLUE_STALFOS_PROJECTILE $3d

;;
; Part that affects PART_DETECTION_HELPER created by Ambi Guards
.define PART_3e $3e

;;
; Used with bomb drop with head thwomp.
;
; Does not create bomb drop, but configures its speed and angle.
;
; relatedObj1 is a reference to a PART_ITEM_DROP instance.
.define PART_HEAD_THWOMP_BOMB_DROPPER $40

;;
.define PART_SHADOW_HAG_SHADOW $41

;;
.define PART_PUMPKIN_HEAD_PROJECTILE $42

;;
; @subid_00{Blue}
; @subid_01{Red}
.define PART_PLASMARINE_PROJECTILE $43

;;
; relatedObj1 must be set to the tingle object (INTERAC_TINGLE).
.define PART_TINGLE_BALLOON $44

;;
; Spawns boulders when climbing up to Patch.
;
; All subids used per screen, they determine initial time before spawning, so that they fall one
; after the other.
;
; @subid_00-03{}
.define PART_FALLING_BOULDER_SPAWNER $45

;;
; subids determine bit set/unset of wActiveTriggers when hit
; @subid_00-03{}
.define PART_SEED_SHOOTER_EYE_STATUE $46

;;
; Bomb used by PART_KING_MOBLIN_MINION.
.define PART_BOMB $47

;;
; Projectile used by Octogon when Link is below water and Octogon is above.
;
; @subid_00{The large projectile (before splitting)}
; @subid_01{Smaller, split projectile}
.define PART_OCTOGON_DEPTH_CHARGE $48

;;
; Used by big bang game.
;
; @subid_00{A single bomb?}
; @subid_ff{A spawner for bombs?}
.define PART_BIGBANG_BOMB_SPAWNER $49

;;
;
; Projectile used by smog boss.
; @subid_00{Projectile from small smog}
; @subid_01{Projectile from large smog}
.define PART_SMOG_PROJECTILE $4a

;;
; Used by Ramrock (seed form)
.define PART_RAMROCK_SEED_FORM_ORB $4f

;;
.define PART_ROOM_OF_RITES_FALLING_BOULDER $54

;;
.define PART_OCTOGON_BUBBLE $55

;;
; Used by ENEMY_VERAN_FINAL_FORM (spider)
.define PART_VERAN_SPIDERWEB $56

;;
; Used by ENEMY_VERAN_FINAL_FORM
.define PART_VERAN_ACID_POOL $57

;;
; Used by ENEMY_VERAN_FINAL_FORM (bee)
.define PART_VERAN_BEE_PROJECTILE $58

;;
; @subid_00{Left flame}
; @subid_01{Top flame}
; @subid_02{Right flame}
; @subid_03{Bottom flame}
.define PART_BLACK_TOWER_MOVING_FLAMES $59

;;
; The stone that's pushed at the start of the game. This only applies after it's moved;
; before it's moved, the stone is handled by INTERAC_TRIFORCE_STONE instead.
.define PART_TRIFORCE_STONE $5a


; ==============================================================================
; Seasons only
; ==============================================================================

.else ;ROM_SEASONS

;;
; @subid_00{D3 hallway to miniboss room}
; @subid_04{D6 room where button destroys floor tiles}
.define PART_HOLES_FLOORTRAP $0a

;;
; @subid_00{1 of 3 requiring Hyper Slingshot}
; @subid_01{1 of 3 requiring Hyper Slingshot}
; @subid_02{1 of 3 requiring Hyper Slingshot}
; @subid_80{Hit by any slingshot}
.define PART_SLINGSHOT_EYE_STATUE $0d

;;
; Part of object data, spawned by interaction $95, in Moblin's rest house
.define PART_16 $16

.define PART_SHOOTING_DRAGON_HEAD $24

;;
; A flame coming from the wall in Unicorn's Cave
.define PART_WALL_FLAME_SHOOTERS_FLAMES $26

;;
.define PART_BURIED_MOLDORM $2b

;;
; @subid_00{Shoots up}
; @subid_01{Shoots right}
; @subid_02{Shoots down}
; @subid_03{Shoots left}
.define PART_CANNON_ARROW_SHOOTER $2c

;;
; @subid_00{Faces right}
; @subid_01{Faces left}
.define PART_KING_MOBLINS_CANNONS $2d

;;
; created by facade - holes?
.define PART_2e $2e

;;
.define PART_2f $2f

;;
; Bubble that can be popped, used primarily (only?) by the girl blowing bubbles in Sunken City
.define PART_POPPABLE_BUBBLE $32

;;
; created by dragon onox
.define PART_33 $33

.define PART_STUB_34 $34
.define PART_STUB_35 $35
.define PART_STUB_36 $36
.define PART_STUB_37 $37

;;
; created by goriya brothers
.define PART_38 $38

;;
; created by agunima - the balls?
.define PART_39 $39

;;
.define PART_3b $3b

;;
; created by Poe sister 2
.define PART_POE_SISTER_FLAME $3c

;;
; created by frypolar
.define PART_3d $3d

;;
.define PART_3e $3e

;;
.define PART_AQUAMENTUS_PROJECTILE $40

;;
.define PART_DODONGO_FIREBALL $41

;;
; @subid_80{Normal}
; @subid_81{Low health}
.define PART_MOTHULA_PROJECTILE_2 $42

;;
; created by Gleeok - projectiles?
.define PART_43 $43

;;
; created by medusa head
.define PART_44 $44

;;
.define PART_45 $45

;;
.define PART_46 $46

;;
; relating to General Onox boss fight?
.define PART_47 $47

;;
.define PART_48 $48

;;
.define PART_49 $49

;;
; created by dragon onox
.define PART_4a $4a

;;
; located in Onox's room
.define PART_DIN_CRYSTAL $4f

.endif ; ROM_SEASONS
