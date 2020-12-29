; This is in the "rando" namespace.
;
; The data in this file will be modified by the randomizer. (It should not modify the collect mode,
; only the treasure object.)


.ifdef ROM_SEASONS

seasonsSlot_d0SwordChest:
	dwbe TREASURE_OBJECT_SWORD_00
	.db  $00

seasonsSlot_makuTree:
	dwbe TREASURE_OBJECT_GNARLED_KEY_00
	.db  COLLECT_MODE_FALL

seasonsSlot_shop150Rupees:
	dwbe TREASURE_OBJECT_FLUTE_00
	.db  $00

seasonsSlot_membersShop1:
	dwbe TREASURE_OBJECT_SEED_SATCHEL_00
	.db  $00

seasonsSlot_membersShop2:
	dwbe TREASURE_OBJECT_GASHA_SEED_00
	.db  $00

seasonsSlot_membersShop3:
	dwbe TREASURE_OBJECT_TREASURE_MAP_00
	.db  $00

.endif
