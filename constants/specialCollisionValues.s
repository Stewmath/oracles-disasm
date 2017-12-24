; When a tile has a collision value $10 or greater, special behaviour specific to certain
; objects kicks in. This prevents enemies from walking down holes, or just specifies more
; fine-grained control over which pixels are collisions.

; The ones between $10-$17 can specify vertical columns of pixels that are solid, whereas
; ones from $18-$1f can specify horizontal rows of pixels that are solid.

; See the functions "objectCheckTileCollision_allowHoles / disallowHoles" to see where
; these values are relevant.

.enum $10

	SPECIALCOLLISION_HOLE			db ; $10: also applies to water, lava
	SPECIALCOLLISION_VERTICAL_BRIDGE	db ; $11
	SPECIALCOLLISION_VERTICAL_BRIDGE_LEFT	db ; $12
	SPECIALCOLLISION_VERTICAL_BRIDGE_RIGHT	db ; $13
	SPECIALCOLLISION_14			db ; $14: Unused?
	SPECIALCOLLISION_15			db ; $15: Unused?
	SPECIALCOLLISION_16			db ; $16: Unused?
	SPECIALCOLLISION_MINECART_TRACK		db ; $17

	SPECIALCOLLISION_STAIRS			db ; $18: The kind of stairs that slow you down
	SPECIALCOLLISION_HORIZONTAL_BRIDGE	db ; $19
	SPECIALCOLLISION_HORIZONTAL_BRIDGE_LEFT	db ; $1a
	SPECIALCOLLISION_HORIZONTAL_BRIDGE_RIGHT db ; $1b
	SPECIALCOLLISION_1c			db ; $1c: Unused?
	SPECIALCOLLISION_1d			db ; $1d: Unused?
	SPECIALCOLLISION_RISING_FLOOR		db ; $1e
	SPECIALCOLLISION_1f			db ; $1f: Unused?

.ende


.define SPECIALCOLLISION_fe $fe
.define SPECIALCOLLISION_ff $ff
