; Item objects are a type of object which can collide with enemy and part objects. This includes
; weapons like swords, as well as some more unexpected things like ricky's tornado.
;
; The item objects described here are "physical" objects which can exist in-game. This is slightly
; different from "treasures" (see constants/common/treasures.s), which only represent things
; collectable by Link, and which may not have any physical representation.
;
; Item IDs from $00-$1f correspond to treasures, while IDs $20 and above are different.

.enum 0
	ITEM_NONE			db ; 0x00
	ITEM_SHIELD			db ; 0x01
	ITEM_PUNCH			db ; 0x02
	ITEM_BOMB			db ; 0x03
	ITEM_CANE_OF_SOMARIA		db ; 0x04
	ITEM_SWORD			db ; 0x05
	ITEM_BOOMERANG			db ; 0x06
	ITEM_ROD_OF_SEASONS		db ; 0x07
	ITEM_MAGNET_GLOVES		db ; 0x08

	; This is mainly used as a place to store positions, and as an object to focus the
	; camera on.
	ITEM_SWITCH_HOOK_HELPER		db ; 0x09

	ITEM_SWITCH_HOOK		db ; 0x0a
	ITEM_SWITCH_HOOK_CHAIN		db ; 0x0b: The blue circle that follows the switch hook
	ITEM_BIGGORON_SWORD		db ; 0x0c
	ITEM_BOMBCHUS			db ; 0x0d
	ITEM_FLUTE			db ; 0x0e
	ITEM_SHOOTER			db ; 0x0f
	ITEM_10				db ; 0x10
	ITEM_HARP			db ; 0x11
	ITEM_12				db ; 0x12
	ITEM_SLINGSHOT			db ; 0x13
	ITEM_14				db ; 0x14
	ITEM_SHOVEL			db ; 0x15
	ITEM_BRACELET			db ; 0x16
	ITEM_FEATHER			db ; 0x17

	; Somaria block creation? (Not the rod itself)
	ITEM_18				db ; 0x18

	ITEM_SEED_SATCHEL		db ; 0x19
	ITEM_DUST			db ; 0x1a: "Dust" when using pegasus seeds?
	ITEM_1b				db ; 0x1b
	ITEM_1c				db ; 0x1c

	; Used to give minecarts collisions with enemies
	ITEM_MINECART_COLLISION		db ; 0x1d

	ITEM_FOOLS_ORE			db ; 0x1e
	ITEM_1f				db ; 0x1f

	; Item IDs $20 and above can't be used directly as items in link's inventory.
	ITEM_EMBER_SEED			db ; 0x20
	ITEM_SCENT_SEED			db ; 0x21
	ITEM_PEGASUS_SEED		db ; 0x22
	ITEM_GALE_SEED			db ; 0x23
	ITEM_MYSTERY_SEED		db ; 0x24
	ITEM_25				db ; 0x25
	ITEM_26				db ; 0x26
	ITEM_SWORD_BEAM			db ; 0x27

	; animal companion attack? (includes moosh's attack, ricky's punch)
	ITEM_28				db ; 0x28

.ifdef ROM_AGES
	ITEM_29				db ; 0x29
.else
	ITEM_MAGNET_BALL		db ; 0x29
.endif
	ITEM_RICKY_TORNADO		db ; 0x2a
	ITEM_DIMITRI_MOUTH		db ; 0x2b: invisible item
.ende
