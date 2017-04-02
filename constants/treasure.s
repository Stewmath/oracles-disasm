; Item indices from $00-$1f can be used as inventory items; ones above that can't be.
.define NUM_INVENTORY_ITEMS $20

; The first $20 treasures correspond to items (see constants/itemTypes.s). Beyond that,
; they differ.

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
	TREASURE_36			db ; $36
	TREASURE_37			db ; $37
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
	TREASURE_GRAVEYARD_KEY		db ; $42
	TREASURE_CROWN_KEY		db ; $43
	TREASURE_OLD_MERMAID_KEY	db ; $44
	TREASURE_MERMAID_KEY		db ; $45
	TREASURE_LIBRARY_KEY		db ; $46
	TREASURE_47			db ; $47
	TREASURE_RICKYGLOVES		db ; $48
	TREASURE_BOMB_FLOWER		db ; $49
	TREASURE_MERMAIDSUIT		db ; $4a
	TREASURE_SLATE			db ; $4b
	TREASURE_TUNI_NUT		db ; $4c
	TREASURE_4d			db ; $4d
	TREASURE_4e			db ; $4e
	TREASURE_4f			db ; $4f
	TREASURE_50			db ; $50
	TREASURE_51			db ; $51

	; Relates to animal companion; maybe remembering its position?
	TREASURE_52			db ; $52

	TREASURE_53			db ; $53
	TREASURE_54			db ; $54
	TREASURE_55			db ; $55
	TREASURE_56			db ; $56
	TREASURE_57			db ; $57
	TREASURE_58			db ; $58
	TREASURE_59			db ; $59
	TREASURE_5a			db ; $5a
	TREASURE_5b			db ; $5b
	TREASURE_5c			db ; $5c
	TREASURE_5d			db ; $5d
	TREASURE_5e			db ; $5e
	TREASURE_5f			db ; $5f

	; Values $60+ have special behaviour; $60-$67 correspond to bits in address $cca8?
	TREASURE_60			db ; $60
	TREASURE_61			db ; $61
	TREASURE_62			db ; $62
	TREASURE_63			db ; $63
	TREASURE_64			db ; $64
	TREASURE_65			db ; $65
	TREASURE_66			db ; $66
	TREASURE_67			db ; $67

.ende
