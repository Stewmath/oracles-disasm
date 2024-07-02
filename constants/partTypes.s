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
.define PARTID_ITEM_DROP 			$01

;;
; "Poof" that appears when you kill an enemy
.define PARTID_ENEMY_DESTROYED	 		$02

;;
; Orb that toggles raisable blocks.
;
; @subid{0-7; the bit to set/check in wToggleBlocksState.}
.define PARTID_ORB				$03

;;
; Boss death explosion.
;
; @subid{ID of enemy being killed (if 0, no item is dropped)}
.define PARTID_BOSS_DEATH_EXPLOSION		$04

;;
; A switch which flips a bit in wSwitchState. Mostly just for dungeons, but is also kinda-hardcoded
; to work in the present overworld too for the switch to Nuun Highlands.
;
; @subid{Bitmask for wSwitchState; xors that value when the switch is triggered.}
.define PARTID_SWITCH				$05

;;
; The object at this position becomes a lightable torch. Increments wNumTorchesLit when it's lit.
;
; @subid_00{Once lit, it stays lit.}
; @subid_01{Once lit, it remains lit for [counter2] frames.}
; @subid_02{?}
.define PARTID_LIGHTABLE_TORCH			$06

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
.define PARTID_SHADOW				$07

;;
; Makes a room dark, and allows it to be lit up by lighting torches in the room. This spawns the
; necessary PARTID_LIGHTABLE_TORCH objects to achieve this.
;
; The YX value is actually the length of time the torches should stay lit (the value of "counter2"
; for the "PARTID_LIGHTABLE_TORCH" objects it spawns).
;
; @subid{Subid value for "PARTID_LIGHTABLE_TORCH" objects this will spawn.}
; @postype{none}
.define PARTID_DARK_ROOM_HANDLER		$08

;;
; A button that you can step on to activate.
;
; If bit 7 of the subid is set, the button deactivates after a period of time?
;
; @subid{Value from 0-7, corresponding to a bit to set in wActiveTriggers when pressed.}
.define PARTID_BUTTON				$09

;;
; Orb that moves back and forth horizontally. Only used in Seasons?
;
; @var03{Bitmask for wToggleBlocksState}
.define PARTID_MOVING_ORB			$0b

;;
; Spawns a bridge. The code that spawns this must set the following variables:
;
; counter2: Length of the bridge (measured in 8x8 tiles)
;
; angle: direction it should spawn in (value from 0-3)
;
; Y: starting position (short-form)
.define PARTID_BRIDGE_SPAWNER			$0c

;;
; This is used by ENEMYID_AMBI_GUARD to detect Link. This is an "invisible projectile"
; which, when it hits Link, notifies the guard that Link has been seen. This object should
; have its "relatedObj1" set to the guard it's working for.
;
; @subid_00{"Controller"; spawns other subids as needed.}
; @subid_01{An "invisible projectile".}
; @subid_02{An "invisible projectile" that only lasts 4 frames; angle is offset by var03.}
; @subid_03{Like subid 2, but var03's offset is counterclockwise.}
.define PARTID_DETECTION_HELPER			$0e

;;
; Respawnable bush that drops something when cut. Used in Ages D3 and Ramrock boss.
;
; TODO: make subid a dropdown in LynnaLab.
;
; @subid{Item drop (see constants/itemDrops.s)}
.define PARTID_RESPAWNABLE_BUSH			$0f

;;
; Seed on a seed tree.
;
; relatedObj2 does something?
;
; @subid{Seed type (0-5)}
.define PARTID_SEED_ON_TREE			$10

;;
; @subid_00{?}
; @subid_01{Rock from a volcano?}
; @subid_02{Like subid 1, but falls directly from the sky instead of shooting up first?}
.define PARTID_VOLCANO_ROCK			$11

;;
; Created when an enemy is burned.
.define PARTID_FLAME	 			$12

;;
.define PARTID_OWL_STATUE			$13

;;
; Not sure if this applies to item drops outside of maple scramble?
;
; Maple sets these to state 4 when being collected.
;
; @subid{Corresponds to the item. Bit 7 of subid might do something?}
; @var03{Determines how many frames Maple takes to collect the item.}
.define PARTID_ITEM_FROM_MAPLE			$14

;;
; See PARTID_ITEM_FROM_MAPLE documentation.
.define PARTID_ITEM_FROM_MAPLE_2		$15

;;
; Looks like a bubble
.define PARTID_JABU_JABUS_BUBBLES		$16

;;
.define PARTID_GASHA_TREE			$17

;;
.define PARTID_OCTOROK_PROJECTILE		$18

;;
; @subid_00{?}
; @subid_01{Used by river zoras}
.define PARTID_ZORA_FIRE			$19

;;
; Used by moblins, darknuts
.define PARTID_ENEMY_ARROW			$1a

;;
.define PARTID_LYNEL_BEAM			$1b

;;
.define PARTID_STALFOS_BONE			$1c

;;
; Invisible object which provides collisions for enemy swords
.define PARTID_ENEMY_SWORD			$1d

;;
.define PARTID_DEKU_SCRUB_PROJECTILE		$1e

;;
.define PARTID_WIZZROBE_PROJECTILE		$1f

;;
; Created by fire keese
.define PARTID_FIRE				$20

;;
.define PARTID_MOBLIN_BOOMERANG			$21

;;
.define PARTID_CUCCO_ATTACKER			$22

;;
; Fire that falls down from its initial position, and respawns back there after a set amount of
; time. They're always used with "pipes" that they appear to come from.
.define PARTID_FALLING_FIRE			$23

;;
.define PARTID_GROTTO_CRYSTAL			$24

;;
; @subid_00{Shoots up}
; @subid_01{Shoots right}
; @subid_02{Shoots down}
; @subid_03{Shoots left}
.define PARTID_WALL_ARROW_SHOOTER		$25

;;
.define PARTID_SPARKLE				$26

; Lightning strikes a specified position
.define PARTID_LIGHTNING			$27

;;
.define PARTID_SMALL_FAIRY			$28

;;
.define PARTID_BEAM				$29

;;
; Used by ENEMYID_BALL_AND_CHAIN_SOLDIER.
;
; @subid_00{The ball}
; @subid_01{Part of the chain; 3/4ths extended}
; @subid_02{Part of the chain; 1/2 extended}
; @subid_03{Part of the chain; 1/4th extended}
.define PARTID_SPIKED_BALL			$2a

;;
; Used by INTERACID_TIMEWARP
.define PARTID_TIMEWARP_ANIMATION		$2b

;;
; Used by INTERACID_VIRE (flame used in "donkey kong" minigame?)
;
; subid determines movement pattern
; @subid_00{2nd screen with Zelda}
; @subid_01{1st screen}
.define PARTID_DONKEY_KONG_FLAME		$2c

;;
; Used by ENEMYID_VERAN_FAIRY - the blue projectile often used
.define PARTID_VERAN_FAIRY_PROJECTILE		$2d

;;
; When this object exists, it applies the effects of whirlpool and pollution tiles.
; It's a bit weird to put this functionality in an object...
.define PARTID_SEA_EFFECTS			$2e

;;
; Turns Link into a baby
.define PARTID_BABY_BALL			$2f

;;
; Decorative heart when Great Fairy is healing Link
.define PARTID_GREAT_FAIRY_HEART		$30

;;
; Also used by ENEMYID_PODOBOO_TOWER, ENEMYID_FIREBALL_SHOOTER, ENEMYID_MAGUNESU, ENEMYID_MANHANDLA
.define PARTID_GOPONGA_PROJECTILE		$31

;;
; @palette(PALH_be}
.define PARTID_SUBTERROR_DIRT			$32

;;
; Rotating things that you can shoot seeds off of (TODO: better name)
.define PARTID_ROTATABLE_SEED_THING		$33

;;
; Used by Ramrock (seed form)
.define PARTID_RAMROCK_SEED_FORM_LASER		$34

;;
; Used by Ramrock (glove form)
;
; @subid_00{Right hand/shoulder}
; @subid_01{Left hand/shoulder}
; @subid_80{Right hand/shoulder}
; @subid_81{Left hand/shoulder}
.define PARTID_RAMROCK_GLOVE_FORM_ARM		$35

;;
; Flame animation used exclusively by ENEMYID_CANDLE. Expects relatedObj1 to point to its
; parent.
.define PARTID_CANDLE_FLAME			$36

;;
; Used by ENEMYID_VERAN_POSSESSION_BOSS, ENEMYID_VERAN_FAIRY.
;
; @subid_00{The "core" which fires the actual projectiles}
; @subid_01{An actual projectile}
.define PARTID_VERAN_PROJECTILE			$37

;;
; Ball for the shooting gallery
.define PARTID_BALL				$38

;;
; Projectile used by head thwomp?
.define PARTID_HEAD_THWOMP_FIREBALL		$39

;;
; relatedObj2 is ENEMYID_VIRE
; @subid_00-02{?}
.define PARTID_VIRE_PROJECTILE			$3a

;;
; Used by head thwomp (purple face); a boulder.
.define PARTID_3b				$3b

;;
; Used by head thwomp
.define PARTID_HEAD_THWOMP_CIRCULAR_PROJECTILE				$3c

;;
; Subid: ?
.define PARTID_BLUE_STALFOS_PROJECTILE		$3d

;;
; Part that affects PARTID_DETECTION_HELPER created by Ambi Guards
.define PARTID_3e				$3e

;;
; @subid_00{Normal}
; @subid_01{Has no special case for reducing speed when thrown onto king moblin's platform}
.define PARTID_KING_MOBLIN_BOMB			$3f

;;
; Used with bomb drop with head thwomp.
;
; Does not create bomb drop, but configures its speed and angle.
;
; relatedObj1 is a reference to a PARTID_ITEM_DROP instance.
.define PARTID_HEAD_THWOMP_BOMB_DROPPER				$40

;;
.define PARTID_SHADOW_HAG_SHADOW		$41

;;
.define PARTID_PUMPKIN_HEAD_PROJECTILE		$42

;;
; @subid_00{Blue}
; @subid_01{Red}
.define PARTID_PLASMARINE_PROJECTILE		$43

;;
; relatedObj1 must be set to the tingle object (INTERACID_TINGLE).
.define PARTID_TINGLE_BALLOON			$44

;;
; Spawns boulders when climbing up to Patch.
;
; All subids used per screen, they determine initial time before spawning, so that they fall one
; after the other.
;
; @subid_00-03{}
.define PARTID_FALLING_BOULDER_SPAWNER		$45

;;
; subids determine bit set/unset of wActiveTriggers when hit
; @subid_00-03{}
.define PARTID_SEED_SHOOTER_EYE_STATUE		$46

;;
; Bomb used by PARTID_KING_MOBLIN_MINION.
.define PARTID_BOMB				$47

;;
; Projectile used by Octogon when Link is below water and Octogon is above.
;
; @subid_00{The large projectile (before splitting)}
; @subid_01{Smaller, split projectile}
.define PARTID_OCTOGON_DEPTH_CHARGE		$48

;;
; Used by big bang game.
;
; @subid_00{A single bomb?}
; @subid_ff{A spawner for bombs?}
.define PARTID_BIGBANG_BOMB_SPAWNER		$49

;;
;
; Projectile used by smog boss.
; @subid_00{Projectile from small smog}
; @subid_01{Projectile from large smog}
.define PARTID_SMOG_PROJECTILE			$4a

;;
.define PARTID_RED_TWINROVA_PROJECTILE		$4b

;;
; Used by ENEMYID_MERGED_TWINROVA
.define PARTID_TWINROVA_FLAME			$4c

;;
.define PARTID_BLUE_TWINROVA_PROJECTILE		$4d

;;
.define PARTID_TWINROVA_SNOWBALL		$4e

;;
; Used by Ramrock (seed form)
.define PARTID_RAMROCK_SEED_FORM_ORB				$4f

;;
; Used by Ganon. (Seems to be invisible, only there to provide collisions?)
.define PARTID_GANON_TRIDENT			$50

;;
; Used by Ganon
.define PARTID_51				$51

;;
; Used by Ganon
.define PARTID_52				$52

;;
; Used by "createEnergySwirl" functions
.define PARTID_BLUE_ENERGY_BEAD			$53

;;
.define PARTID_ROOM_OF_RITES_FALLING_BOULDER	$54

;;
.define PARTID_OCTOGON_BUBBLE			$55

;;
; Used by ENEMYID_VERAN_FINAL_FORM (spider)
.define PARTID_VERAN_SPIDERWEB			$56

;;
; Used by ENEMYID_VERAN_FINAL_FORM
.define PARTID_VERAN_ACID_POOL			$57

;;
; Used by ENEMYID_VERAN_FINAL_FORM (bee)
.define PARTID_VERAN_BEE_PROJECTILE		$58

;;
; @subid_00{Left flame}
; @subid_01{Top flame}
; @subid_02{Right flame}
; @subid_03{Bottom flame}
.define PARTID_BLACK_TOWER_MOVING_FLAMES	$59

;;
; The stone that's pushed at the start of the game. This only applies after it's moved;
; before it's moved, the stone is handled by INTERACID_TRIFORCE_STONE instead.
.define PARTID_TRIFORCE_STONE			$5a


; Can't have IDs higher than $80 (would need to modify code in objectLoading.s, possibly more)


; TODO: Separate ages/seasons stuff properly.


.ifdef ROM_SEASONS


;;
; @subid_00{D3 hallway to miniboss room}
; @subid_04{D6 room where button destroys floor tiles}
.define PARTID_HOLES_FLOORTRAP			$0a

;;
; @subid_00{1 of 3 requiring Hyper Slingshot}
; @subid_01{1 of 3 requiring Hyper Slingshot}
; @subid_02{1 of 3 requiring Hyper Slingshot}
; @subid_80{Hit by any slingshot}
.define PARTID_SLINGSHOT_EYE_STATUE		$0d

; Part of object data, spawned by interaction $95, in Moblin's rest house
.define PARTID_S_16				$16

.define PARTID_SHOOTING_DRAGON_HEAD		$24

;;
; A flame coming from the wall in Unicorn's Cave
.define PARTID_WALL_FLAME_SHOOTERS_FLAMES	$26

;;
.define PARTID_BURIED_MOLDORM			$2b

;;
; @subid_00{Shoots up}
; @subid_01{Shoots right}
; @subid_02{Shoots down}
; @subid_03{Shoots left}
.define PARTID_CANNON_ARROW_SHOOTER		$2c

;;
; @subid_00{Faces right}
; @subid_01{Faces left}
.define PARTID_KING_MOBLINS_CANNONS		$2d

;;
; created by facade - holes?
.define PARTID_2e				$2e

;;
; TODO: Is this the same as PARTID_GOPONGA_PROJECTILE?
;
; @subid_80{Normal}
; @subid_81{Low health}
.define PARTID_MOTHULA_PROJECTILE_1		$31

;;
; Bubble that can be popped, used primarily (only?) by the girl blowing bubbles in Sunken City
.define PARTID_POPPABLE_BUBBLE			$32

;;
; created by dragon onox
.define PARTID_33				$33

;;
; created by goriya brothers
.define PARTID_38				$38

;;
; created by agunima - the balls?
.define PARTID_39				$39

;;
.define PARTID_3a				$3a

;;
; created by Poe sister 2
.define PARTID_POE_SISTER_FLAME			$3c

;;
; created by frypolar
.define PARTID_3d				$3d

;;
.define PARTID_AQUAMENTUS_PROJECTILE		$40

;;
.define PARTID_DODONGO_FIREBALL			$41

;;
; @subid_80{Normal}
; @subid_81{Low health}
.define PARTID_MOTHULA_PROJECTILE_2		$42

;;
; created by Gleeok - projectiles?
.define PARTID_43				$43

;;
; created by medusa head
.define PARTID_44				$44

;;
.define PARTID_S_45				$45

;;
.define PARTID_S_46				$46

;;
; relating to General Onox boss fight?
.define PARTID_47				$47

;;
.define PARTID_48				$48

;;
.define PARTID_49				$49

;;
; created by dragon onox
.define PARTID_4a				$4a

; located in Onox's room
.define PARTID_DIN_CRYSTAL			$4f


.endif
