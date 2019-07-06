; These are values given to Link or an item's "collisionType" variable. It affects how
; enemies will react to the item on collision.
;
; Items have these values assigned in "data/{game}/itemAttributes.s".
;
; Upon collision with enemies, the corresponding value from the item is written to the
; Enemy or Part object's var2a. Bit 7 is set to indicate that the collision just occurred.
;
; Be careful about rearranging these; certain enemies check ranges of values, not just
; specific ones (ie. everything from L1_SWORD to EXPERT_PUNCH).
;
; See data/ages/objectCollisionTable.s for more detailed documentation.

.enum 0
	ITEMCOLLISION_LINK			db ; $00: Collision with link, companion
	ITEMCOLLISION_L1_SHIELD			db ; $01: Level 1 shield collision
	ITEMCOLLISION_L2_SHIELD			db ; $02: Level 2 shield
	ITEMCOLLISION_L3_SHIELD			db ; $03: Level 3 shield
	ITEMCOLLISION_L1_SWORD			db ; $04: Level 1 sword, minecart
	ITEMCOLLISION_L2_SWORD			db ; $05: Level 2 sword
	ITEMCOLLISION_L3_SWORD			db ; $06: Level 3 sword
	ITEMCOLLISION_BIGGORON_SWORD		db ; $07: Biggoron's sword
	ITEMCOLLISION_SWORDSPIN			db ; $08: Sword spin (any level?)
	ITEMCOLLISION_SWORD_HELD		db ; $09: Sword being held out (any level?)
	ITEMCOLLISION_FIST_PUNCH		db ; $0a: Punch (fist ring, unused item)
	ITEMCOLLISION_EXPERT_PUNCH		db ; $0b: Punch (expert's ring)
	ITEMCOLLISION_SHOVEL			db ; $0c: Shovel (bumps enemies)
	ITEMCOLLISION_SWITCH_HOOK		db ; $0d: Switch hook
	ITEMCOLLISION_0e			db ; $0e:
	ITEMCOLLISION_0f			db ; $0f: Instant death - maybe dimitri?
	ITEMCOLLISION_10			db ; $10:
	ITEMCOLLISION_11			db ; $11:

	; Collisions $00-$11 are considered "direct attacks" from Link, for the purpose of
	; ambi's guards (they notice him right away), while $11-$1f are indirect attacks?

	ITEMCOLLISION_CANE_OF_SOMARIA		db ; $12: Cane of Somaria, other harmless things?
	ITEMCOLLISION_13			db ; $13:
	ITEMCOLLISION_14			db ; $14:
	ITEMCOLLISION_SOMARIA_BLOCK		db ; $15: Cane of Somaria block
	ITEMCOLLISION_16			db ; $16: Object being thrown (ie. sign)
	ITEMCOLLISION_BOOMERANG			db ; $17: Boomerang (both levels?)
	ITEMCOLLISION_BOMB			db ; $18: Bomb, bombchu
	ITEMCOLLISION_SWORD_BEAM		db ; $19: Sword beam
	ITEMCOLLISION_MYSTERY_SEED		db ; $1a: Mystery seed
	ITEMCOLLISION_EMBER_SEED		db ; $1b: Ember seed
	ITEMCOLLISION_SCENT_SEED		db ; $1c: Scent seed
	ITEMCOLLISION_PEGASUS_SEED		db ; $1d: Pegasus seed
	ITEMCOLLISION_GALE_SEED			db ; $1e: Gale seed
	ITEMCOLLISION_1f			db ; $1f: Probably unused

	; Values above $20 don't fit into "objectCollisionTable", and so can only be used
	; if hard-coded somewhere. These values should never be written to an item's
	; "collisionType", but may be written to an enemy's "var2a".

	; COLLISIONEFFECT_ELECTRIC_SHOCK overrides the actual collisionType with this.
	ITEMCOLLISION_ELECTRIC_SHOCK		db ; $20

.ende
