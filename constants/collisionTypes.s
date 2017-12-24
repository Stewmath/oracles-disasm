; These are values given to Link or an item's "collisionType" variable. It affects how
; enemies will react to the item on collision.
;
; See also:
;  constants/collisionEffects.s (list of effects that may occur on collision)
;  data/collisionReactionSets.s (defines which collision effects occur when)

.enum 0
	COLLISIONTYPE_LINK			db ; $00: Collision with link, companion
	COLLISIONTYPE_L1_SHIELD			db ; $01: Level 1 shield collision
	COLLISIONTYPE_L2_SHIELD			db ; $02: Level 2 shield
	COLLISIONTYPE_L3_SHIELD			db ; $03: Level 3 shield
	COLLISIONTYPE_L1_SWORD			db ; $04: Level 1 sword, minecart
	COLLISIONTYPE_L2_SWORD			db ; $05: Level 2 sword
	COLLISIONTYPE_L3_SWORD			db ; $06: Level 3 sword
	COLLISIONTYPE_BIGGORON_SWORD		db ; $07: Biggoron's sword
	COLLISIONTYPE_SWORDSPIN			db ; $08: Sword spin (any level?)
	COLLISIONTYPE_SWORD_HELD		db ; $09: Sword being held out (any level?)
	COLLISIONTYPE_FIST_PUNCH		db ; $0a: Punch (fist ring, unused item)
	COLLISIONTYPE_EXPERT_PUNCH		db ; $0b: Punch (expert's ring)
	COLLISIONTYPE_SHOVEL			db ; $0c: Shovel (bumps enemies)
	COLLISIONTYPE_SWITCH_HOOK		db ; $0d: Switch hook
	COLLISIONTYPE_0e			db ; $0e:
	COLLISIONTYPE_0f			db ; $0f: Instant death - maybe dimitri?
	COLLISIONTYPE_10			db ; $10:
	COLLISIONTYPE_11			db ; $11:
	COLLISIONTYPE_CANE_OF_SOMARIA		db ; $12: Cane of Somaria, other harmless things?
	COLLISIONTYPE_13			db ; $13:
	COLLISIONTYPE_14			db ; $14:
	COLLISIONTYPE_SOMARIA_BLOCK		db ; $15: Cane of Somaria block
	COLLISIONTYPE_16			db ; $16: Object being thrown (ie. sign)
	COLLISIONTYPE_BOOMERANG			db ; $17: Boomerang (both levels?)
	COLLISIONTYPE_BOMB			db ; $18: Bomb, bombchu
	COLLISIONTYPE_SWORD_BEAM		db ; $19: Sword beam
	COLLISIONTYPE_1a			db ; $1a:
	COLLISIONTYPE_EMBER_SEED		db ; $1b: Ember seed
	COLLISIONTYPE_SCENT_SEED		db ; $1c: Scent seed
	COLLISIONTYPE_PEGASUS_SEED		db ; $1d: Pegasus seed
	COLLISIONTYPE_GALE_SEED			db ; $1e: Gale seed
	COLLISIONTYPE_1f			db ; $1f: Probably unused

.ende
