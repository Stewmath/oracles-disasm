;;
; Subids correspond to "constants/itemDrops.s".
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
; @subid_0a{Unused?}
; @subid_0b{Unused?}
; @subid_0c{Blue ore chunk (1)}
; @subid_0d{Red ore chunk (10)}
; @subid_0e{Gold ore chunk (50)}
; @subid_0f{100 rupees (1/8 chance) or an enemy (rope or beetle, 7/8 chance)}
.define PARTID_ITEM_DROP 			$01

.define PARTID_ENEMY_DESTROYED	 		$02
.define PARTID_ORB				$03 ; Orb that toggles raisable blocks

;;
; Boss death explosion?
; @subid{ID of enemy being killed}
.define PARTID_04				$04

; Makes a torch lightable.
; Subid:
;   0: Once lit, it stays lit.
;   1: Once lit, it remains lit for [counter2] frames.
;   2: ?
.define PARTID_06				$06

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
; @subid{Bitmask for wSwitchState?}
.define PARTID_SWITCH				$05

; Spawns a bridge.
; counter2: Length of the bridge (measured in 8x8 tiles)
; angle: direction it should spawn in (value from 0-3)
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
; Seed on a seed tree.
; @subid{Seed type (0-5)}
.define PARTID_SEED_ON_TREE			$10

.define PARTID_FLAME	 			$12

; Not sure if this applies to item drops outside of maple scramble?
; Subid corresponds to the item.
;   bit 7 of subid might do something?
; var03 determines how many frames Maple takes to collect the item.
; Maple sets these to state 4 when being collected.
.define PARTID_ITEM_FROM_MAPLE			$14
.define PARTID_ITEM_FROM_MAPLE_2		$15
.define PARTID_16				$16
.define PARTID_GASHA_TREE			$17
.define PARTID_OCTOROK_PROJECTILE		$18

;;
; @subid_00{?}
; @subid_01{Used by river zoras}
.define PARTID_ZORA_FIRE			$19

;;
; Used by moblins, darknuts
.define PARTID_ENEMY_ARROW			$1a

.define PARTID_LYNEL_BEAM			$1b

.define PARTID_STALFOS_BONE			$1c

;;
; Invisible object which provides collisions for enemy swords
.define PARTID_ENEMY_SWORD			$1d

.define PARTID_DEKU_SCRUB_PROJECTILE		$1e

.define PARTID_WIZZROBE_PROJECTILE		$1f

;;
; Created by fire keese
.define PARTID_FIRE				$20

.define PARTID_MOBLIN_BOOMERANG			$21

.define PARTID_CUCCO_ATTACKER			$22

.define PARTID_SPARKLE				$26

; Lightning strikes a specified position
.define PARTID_LIGHTNING			$27

;;
; Some kind of item?
.define PARTID_28				$28

.define PARTID_BEAM				$29

;;
; Used by ENEMYID_BALL_AND_CHAIN_SOLDIER.
; @subid_00{The ball}
; @subid_01{Part of the chain; 3/4ths extended}
; @subid_02{Part of the chain; 1/2 extended}
; @subid_03{Part of the chain; 1/4th extended}
.define PARTID_SPIKED_BALL			$2a

;;
; Used by ENEMYID_VERAN_FAIRY
.define PARTID_2d				$2d

;;
; When this object exists, it applies the effects of whirlpool and pollution tiles.
; It's a bit weird to put this functionality in an object...
.define PARTID_SEA_EFFECTS			$2e

;;
; Turns Link intoa baby
.define PARTID_BABY_BALL			$2f

;;
; Decorative heart when Great Fairy is healing Link
.define PARTID_GREAT_FAIRY_HEART		$30

;;
; Also used by ENEMYID_PODOBOO_TOWER, ENEMYID_FIREBALL_SHOOTER
.define PARTID_GOPONGA_PROJECTILE		$31

;;
; @palette(PALH_be}
.define PARTID_SUBTERROR_DIRT			$32

;;
; Used by Ramrock (seed form)
.define PARTID_34				$34

;;
; Used by Ramrock (bomb form)
.define PARTID_35				$35

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
.define PARTID_VIRE_PROJECTILE			$3a

;;
; Used by head thwomp (purple face)
.define PARTID_3b				$3b

;;
; Used by head thwomp
.define PARTID_3c				$3c

;;
; Subid: ?
.define PARTID_BLUE_STALFOS_PROJECTILE		$3d

;;
; @subid_00{Normal}
; @subid_01{Has no special case for reducing speed when thrown onto king moblin's platform}
.define PARTID_KING_MOBLIN_BOMB			$3f

;;
; Used with bomb drop with head thwomp?
; relatedObj1 is a reference to a PARTID_ITEM_DROP instance.
.define PARTID_40				$40

.define PARTID_SHADOW_HAG_SHADOW		$41

.define PARTID_PUMPKIN_HEAD_PROJECTILE		$42

;;
; @subid_00{Blue}
; @subid_01{Red}
.define PARTID_PLASMARINE_PROJECTILE		$43

; $45: falling boulder spawner?

;;
; Bomb used by PARTID_KING_MOBLIN_MINION.
.define PARTID_BOMB				$47

;;
; Projectile used by Octogon when Link is below water and Octogon is above
; @subid_00{The large projectile (before splitting)}
; @subid_01{Smaller, split projectile}
.define PARTID_OCTOGON_DEPTH_CHARGE		$48

;;
; Used by big bang game.
; @subid_00{A single bomb?}
; @subid_ff{A spawner for bombs?}
.define PARTID_BIGBANG_BOMB_SPAWNER		$49

;;
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
.define PARTID_4f				$4f

;;
; Used by Ganon
.define PARTID_50				$50

;;
; Used by Ganon
.define PARTID_51				$51

;;
; Used by Ganon
.define PARTID_52				$52

.define PARTID_BLUE_ENERGY_BEAD			$53 ; Used by "createEnergySwirl" functions

.define PARTID_OCTOGON_BUBBLE			$55

;;
; Used by ENEMYID_VERAN_FINAL_FORM (spider)
.define PARTID_56				$56

;;
; Used by ENEMYID_VERAN_FINAL_FORM
.define PARTID_57				$57

;;
; Used by ENEMYID_VERAN_FINAL_FORM (bee)
.define PARTID_58				$58

; The stone that's pushed at the start of the game. This only applies after it's moved;
; before it's moved, the stone is handled by INTERACID_TRIFORCE_STONE instead.
.define PARTID_TRIFORCE_STONE			$5a



; TODO: Separate ages/seasons stuff properly.

.ifdef ROM_SEASONS

;;
; TODO: Is this the same as PARTID_GOPONGA_PROJECTILE?
; @subid_80{Normal}
; @subid_81{Low health}
.define PARTID_MOTHULA_PROJECTILE_1		$31

;;
.define PARTID_AQUAMENTUS_PROJECTILE		$40

.define PARTID_DODONGO_FIREBALL			$41

;;
; @subid_80{Normal}
; @subid_81{Low health}
.define PARTID_MOTHULA_PROJECTILE_2		$42

.endif
