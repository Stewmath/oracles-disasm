.define PARTID_01	 			$01
.define PARTID_ENEMY_DESTROYED	 		$02
.define PARTID_ORB				$03 ; Orb that toggles raisable blocks

; Makes a torch lightable.
; Subid:
;   0: Once lit, it stays lit.
;   1: Once lit, it remains lit for [counter2] frames.
;   2: ?
.define PARTID_06				$06

; Spawns a bridge.
; counter2: Length of the bridge (measured in 8x8 tiles)
; angle: direction it should spawn in (value from 0-3)
; Y: starting position (short-form)
.define PARTID_BRIDGE_SPAWNER			$0c

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

.define PARTID_SPARKLE				$26

; Lightning strikes a specified position
.define PARTID_LIGHTNING			$27

.define PARTID_BEAM				$29

; When this object exists, it applies the effects of whirlpool and pollution tiles.
; It's a bit weird to put this functionality in an object...
.define PARTID_SEA_EFFECTS			$2e

; Ball for the shooting gallery
.define PARTID_BALL				$38

; $45: falling boulder spawner?

.define PARTID_BLUE_ENERGY_BEAD			$53 ; Used by "createEnergySwirl" functions

; The stone that's pushed at the start of the game. This only applies after it's moved;
; before it's moved, the stone is handled by INTERACID_TRIFOCE_STONE instead.
.define PARTID_TRIFORCE_STONE			$5a
