; Spawn mode and collect mode constants for "data/{game}/treasureObjectData.s".
; This is mainly just for LynnaLab's benefit.


;;
; Appears instantly. Do not use in chests.
.define TREASURE_SPAWN_MODE_INSTANT 0

;;
; Appears with a poof. Do not use in chests.
.define TREASURE_SPAWN_MODE_PUFF 1

;;
; Item falls from the top of the screen and the "puzzle solved" sound plays. Do not use in chests.
.define TREASURE_SPAWN_MODE_FROM_SCREEN_TOP 2

;;
; Item rises up before being obtained; meant for chests.
.define TREASURE_SPAWN_MODE_FROM_CHEST_A 3

;;
; Used for that one small key that falls into water in Seasons D4? Do not use in chests.
.define TREASURE_SPAWN_MODE_FROM_UNDERWATER 4

;;
; A buried item. When the tile at this object's position is broken (ie. digging up the tile), the
; treasure spawns. Do not use in chests.
.define TREASURE_SPAWN_MODE_BURIED 5

;;
; Link grabs it after a short delay. Meant for map and compass chests.
.define TREASURE_SPAWN_MODE_FROM_CHEST_B 6

; 7: undefined



;;
; Link's animation does not change when he gets the item.
.define TREASURE_GRAB_MODE_NO_CHANGE 0

;;
; Link holds the item over his head with 1 hand.
.define TREASURE_GRAB_MODE_1_HAND 1

;;
; Link holds the item over his head with 2 hands.
.define TREASURE_GRAB_MODE_2_HAND 2

;;
; Link performs a spin slash. (Getting the sword in Seasons.)
.define TREASURE_GRAB_MODE_SPIN_SLASH 3

; 4/5: same as 1/2?
; 6/7: undefined
