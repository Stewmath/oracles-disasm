.enum 0
	ITEMID_NONE			db ; 0x00
	ITEMID_SHIELD			db ; 0x01
	ITEMID_PUNCH			db ; 0x02
	ITEMID_BOMB			db ; 0x03
	ITEMID_CANE_OF_SOMARIA		db ; 0x04
	ITEMID_SWORD			db ; 0x05
	ITEMID_BOOMERANG		db ; 0x06
	ITEMID_07			db ; 0x07
	ITEMID_08			db ; 0x08

	; This is mainly used as a place to store positions, and as an object to focus the
	; camera on.
	ITEMID_SWITCH_HOOK_HELPER	db ; 0x09

	ITEMID_SWITCH_HOOK		db ; 0x0a
	ITEMID_SWITCH_HOOK_CHAIN	db ; 0x0b: The blue circle that follows the switch hook
	ITEMID_BIGGORON_SWORD		db ; 0x0c
	ITEMID_BOMBCHU			db ; 0x0d
	ITEMID_FLUTE			db ; 0x0e
	ITEMID_SHOOTER			db ; 0x0f
	ITEMID_10			db ; 0x10
	ITEMID_HARP			db ; 0x11
	ITEMID_12			db ; 0x12

	; Slingshot leftovers maybe?
	ITEMID_13			db ; 0x13

	ITEMID_14			db ; 0x14
	ITEMID_SHOVEL			db ; 0x15
	ITEMID_BRACELET			db ; 0x16
	ITEMID_FEATHER			db ; 0x17

	; Somaria block creation? (Not the rod itself)
	ITEMID_18			db ; 0x18

	ITEMID_SATCHEL			db ; 0x19
	ITEMID_1a			db ; 0x1a
	ITEMID_1b			db ; 0x1b
	ITEMID_1c			db ; 0x1c

	; Used to give minecarts collisions with enemies
	ITEMID_MINECART_COLLISION	db ; 0x1d

	; Similar to biggoron sword?
	ITEMID_1e			db ; 0x1e

	ITEMID_1f			db ; 0x1f
	ITEMID_20			db ; 0x20
	ITEMID_21			db ; 0x21
	ITEMID_22			db ; 0x22
	ITEMID_23			db ; 0x23
	ITEMID_24			db ; 0x24
	ITEMID_25			db ; 0x25
	ITEMID_26			db ; 0x26
	ITEMID_SWORD_BEAM		db ; 0x27
	ITEMID_28			db ; 0x28
	ITEMID_29			db ; 0x29
	ITEMID_2a			db ; 0x2a
.ende
