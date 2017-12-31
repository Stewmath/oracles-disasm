.define PARTID_01	 			$01
.define PARTID_ENEMY_DESTROYED	 		$02
.define PARTID_FLAME	 			$12

; Not sure if this applies to item drops outside of maple scramble?
; Subid corresponds to the item.
;   bit 7 of subid might do something?
; var03 determines how many frames Maple takes to collect the item.
; Maple sets these to state 4 when being collected.
.define PARTID_ITEM_FROM_MAPLE			$14
.define PARTID_ITEM_FROM_MAPLE_2		$15

.define PARTID_GASHA_TREE			$17
.define PARTID_OCTOROK_PROJECTILE		$18
.define PARTID_ZORA_FIRE			$19

; Lightning strikes a specified position
.define PARTID_LIGHTNING			$27

.define PARTID_BEAM				$29

; When this object exists, it applies the effects of whirlpool and pollution tiles.
; It's a bit weird to put this functionality in an object...
.define PARTID_SEA_EFFECTS			$2e

.define PARTID_BLUE_ENERGY_BEAD			$53 ; Used by "createEnergySwirl" functions
.define PARTID_TRIFORCE_STONE			$5a
