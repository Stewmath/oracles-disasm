; The first $20 treasures correspond to items (see constants/itemTypes.s). Beyond that,
; they differ.

; Item indices from $00-$1f can be used as inventory items; ones above that can't be.
.define NUM_INVENTORY_ITEMS	$20


.enum 0

	TREASURE_NONE			db ; $00
	TREASURE_SHIELD			db ; $01
	TREASURE_PUNCH			db ; $02 ; Set by default on the file
	TREASURE_BOMBS			db ; $03
	TREASURE_CANE_OF_SOMARIA	db ; $04
	TREASURE_SWORD			db ; $05
	TREASURE_BOOMERANG		db ; $06
	TREASURE_ROD_OF_SEASONS		db ; $07
	TREASURE_MAGNET_GLOVES		db ; $08
	TREASURE_SWITCH_HOOK_HELPER	db ; $09 ; Probably not an actual treasure
	TREASURE_SWITCH_HOOK		db ; $0a
	TREASURE_SWITCH_HOOK_CHAIN	db ; $0b ; Probably not an actual treasure
	TREASURE_BIGGORON_SWORD		db ; $0c
	TREASURE_BOMBCHUS		db ; $0d
	TREASURE_FLUTE			db ; $0e
	TREASURE_SHOOTER		db ; $0f
	TREASURE_10			db ; $10
	TREASURE_HARP			db ; $11
	TREASURE_12			db ; $12
	TREASURE_SLINGSHOT		db ; $13
	TREASURE_14			db ; $14
	TREASURE_SHOVEL			db ; $15
	TREASURE_BRACELET		db ; $16
	TREASURE_FEATHER		db ; $17
	TREASURE_18			db ; $18
	TREASURE_SEED_SATCHEL		db ; $19 ; When set, you're allowed to pick seeds from trees
	TREASURE_1a			db ; $1a
	TREASURE_1b			db ; $1b
	TREASURE_1c			db ; $1c
	TREASURE_MINECART_COLLISION	db ; $1d ; Probably not an actual treasure
	TREASURE_FOOLS_ORE		db ; $1e
	TREASURE_1f			db ; $1f

	TREASURE_EMBER_SEEDS		db ; $20
	TREASURE_SCENT_SEEDS		db ; $21
	TREASURE_PEGASUS_SEEDS		db ; $22
	TREASURE_GALE_SEEDS		db ; $23
	TREASURE_MYSTERY_SEEDS		db ; $24
	TREASURE_TUNE_OF_ECHOES		db ; $25
	TREASURE_TUNE_OF_CURRENTS	db ; $26
	TREASURE_TUNE_OF_AGES		db ; $27
	TREASURE_RUPEES			db ; $28
	TREASURE_HEART_REFILL		db ; $29
	TREASURE_HEART_CONTAINER	db ; $2a
	TREASURE_HEART_PIECE		db ; $2b
	TREASURE_RING_BOX		db ; $2c
	TREASURE_RING			db ; $2d ; Once the flag is set, you see the unappraised ring counter
	TREASURE_FLIPPERS		db ; $2e
	TREASURE_POTION			db ; $2f
	TREASURE_SMALL_KEY		db ; $30
	TREASURE_BOSS_KEY		db ; $31
	TREASURE_COMPASS		db ; $32
	TREASURE_MAP			db ; $33
	TREASURE_GASHA_SEED		db ; $34
	TREASURE_35			db ; $35
	TREASURE_MAKU_SEED		db ; $36
	TREASURE_37			db ; $37 ; Ore chunks?
	TREASURE_38			db ; $38
	TREASURE_39			db ; $39
	TREASURE_3a			db ; $3a
	TREASURE_3b			db ; $3b
	TREASURE_3c			db ; $3c
	TREASURE_3d			db ; $3d
	TREASURE_3e			db ; $3e
	TREASURE_3f			db ; $3f
	TREASURE_ESSENCE		db ; $40
	TREASURE_TRADEITEM		db ; $41

.ifdef ROM_AGES

	TREASURE_GRAVEYARD_KEY		db ; $42
	TREASURE_CROWN_KEY		db ; $43
	TREASURE_OLD_MERMAID_KEY	db ; $44
	TREASURE_MERMAID_KEY		db ; $45
	TREASURE_LIBRARY_KEY		db ; $46
	TREASURE_47			db ; $47
	TREASURE_RICKY_GLOVES		db ; $48
	TREASURE_BOMB_FLOWER		db ; $49
	TREASURE_MERMAID_SUIT		db ; $4a
	TREASURE_SLATE			db ; $4b
	TREASURE_TUNI_NUT		db ; $4c
	TREASURE_SCENT_SEEDLING		db ; $4d
	TREASURE_ZORA_SCALE		db ; $4e
	TREASURE_TOKAY_EYEBALL		db ; $4f
	TREASURE_EMPTY_BOTTLE		db ; $50: unused? (similar to fairy powder)
	TREASURE_FAIRY_POWDER		db ; $51
	TREASURE_CHEVAL_ROPE		db ; $52
	TREASURE_MEMBERS_CARD		db ; $53
	TREASURE_ISLAND_CHART		db ; $54
	TREASURE_BOOK_OF_SEALS		db ; $55
	TREASURE_56			db ; $56
	TREASURE_57			db ; $57
	TREASURE_58			db ; $58: relates to bomb flower?
	TREASURE_GORON_LETTER		db ; $59
	TREASURE_LAVA_JUICE		db ; $5a
	TREASURE_BROTHER_EMBLEM		db ; $5b
	TREASURE_GORON_VASE		db ; $5c
	TREASURE_GORONADE		db ; $5d
	TREASURE_ROCK_SIRLOIN		db ; $5e
	TREASURE_5f			db ; $5f

.else; ROM_SEASONS

	TREASURE_GNARLED_KEY		db ; $42
	TREASURE_FLOODGATE_KEY		db ; $43
	TREASURE_DRAGON_KEY		db ; $44
	TREASURE_STAR_ORE		db ; $45
	TREASURE_RIBBON			db ; $46
	TREASURE_SPRING_BANANA		db ; $47
	TREASURE_RICKY_GLOVES		db ; $48
	TREASURE_BOMB_FLOWER		db ; $49
	TREASURE_PIRATES_BELL		db ; $4a
	TREASURE_TREASURE_MAP		db ; $4b
	TREASURE_ROUND_JEWEL		db ; $4c
	TREASURE_PYRAMID_JEWEL		db ; $4d
	TREASURE_SQUARE_JEWEL		db ; $4e
	TREASURE_X_SHAPED_JEWEL		db ; $4f
	TREASURE_RED_ORE		db ; $50
	TREASURE_BLUE_ORE		db ; $51
	TREASURE_HARD_ORE		db ; $52
	TREASURE_MEMBERS_CARD		db ; $53
	TREASURE_MASTERS_PLAQUE		db ; $54
	TREASURE_55			db ; $55
	TREASURE_56			db ; $56
	TREASURE_57			db ; $57
	TREASURE_58			db ; $58: relates to bomb flower?

	; The remainder appear as seeds in seed satchel/slingshot, but that probably
	; doesn't mean anything. These may not be valid treasures.
	TREASURE_59			db ; $59
	TREASURE_5a			db ; $5a
	TREASURE_5b			db ; $5b
	TREASURE_5c			db ; $5c
	TREASURE_5d			db ; $5d
	TREASURE_5e			db ; $5e
	TREASURE_5f			db ; $5f

.endif ; ROM_SEASONS


	; Do these behave the same in seasons?
	TREASURE_60			db ; $60
	TREASURE_BOMB_UPGRADE		db ; $61
	TREASURE_SATCHEL_UPGRADE	db ; $62
	TREASURE_63			db ; $63
	TREASURE_64			db ; $64
	TREASURE_65			db ; $65
	TREASURE_66			db ; $66
	TREASURE_67			db ; $67
.ende
