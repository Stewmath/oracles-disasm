; See constants/common/items.s.
;
; Data format:
; b0: object gfx index (see data/objectGfxHeaders.s)
; b1: value for Item.oamTileIndexBase
; b2: value for Item.oamFlags

itemData:
	.db $00 $00 $00 ; $00: ITEM_NONE
	.db $00 $00 $00 ; $01: ITEM_SHIELD
	.db $00 $00 $00 ; $02: ITEM_PUNCH
	.db $5c $10 $04 ; $03: ITEM_BOMB
	.db $00 $52 $0a ; $04: ITEM_CANE_OF_SOMARIA
	.db $00 $52 $08 ; $05: ITEM_SWORD
	.db $00 $4e $0d ; $06: ITEM_BOOMERANG
	.db $00 $52 $0a ; $07: ITEM_ROD_OF_SEASONS
	.db $00 $52 $09 ; $08: ITEM_MAGNET_GLOVES
	.db $00 $00 $00 ; $09: ITEM_SWITCH_HOOK_HELPER
	.db $00 $52 $09 ; $0a: ITEM_SWITCH_HOOK
	.db $00 $16 $09 ; $0b: ITEM_SWITCH_HOOK_CHAIN
	.db $00 $52 $0b ; $0c: ITEM_BIGGORON_SWORD
	.db $00 $2c $0d ; $0d: ITEM_BOMBCHUS
	.db $00 $00 $00 ; $0e: ITEM_FLUTE
	.db $00 $52 $08 ; $0f: ITEM_SHOOTER
	.db $00 $00 $00 ; $10: ITEM_10
	.db $00 $00 $00 ; $11: ITEM_HARP
	.db $00 $00 $00 ; $12: ITEM_12
	.db $00 $52 $09 ; $13: ITEM_SLINGSHOT
	.db $00 $00 $00 ; $14: ITEM_14
	.db $00 $00 $00 ; $15: ITEM_SHOVEL
	.db $00 $00 $00 ; $16: ITEM_BRACELET
	.db $00 $00 $00 ; $17: ITEM_FEATHER
	.db $00 $18 $0b ; $18: ITEM_18
	.db $00 $00 $00 ; $19: ITEM_SEED_SATCHEL
	.db $00 $16 $0b ; $1a: ITEM_DUST
	.db $00 $00 $00 ; $1b: ITEM_1b
	.db $00 $00 $00 ; $1c: ITEM_1c
	.db $00 $00 $00 ; $1d: ITEM_MINECART_COLLISION
	.db $00 $52 $08 ; $1e: ITEM_FOOLS_ORE
	.db $00 $00 $00 ; $1f: ITEM_1f
	.db $5c $12 $02 ; $20: ITEM_EMBER_SEED
	.db $5c $14 $03 ; $21: ITEM_SCENT_SEED
	.db $5c $16 $01 ; $22: ITEM_PEGASUS_SEED
	.db $5c $18 $01 ; $23: ITEM_GALE_SEED
	.db $5c $1a $00 ; $24: ITEM_MYSTERY_SEED
	.db $00 $1c $01 ; $25: ITEM_25
	.db $00 $1e $00 ; $26: ITEM_26
	.db $00 $38 $0c ; $27: ITEM_SWORD_BEAM
	.db $00 $00 $00 ; $28: ITEM_28
	.db $57 $0a $02 ; $29: ITEM_MAGNET_BALL
	.db $00 $28 $09 ; $2a: ITEM_RICKY_TORNADO
	; Item $2b (dimitri mouth) exists, but it's invisible, so this doesn't matter.
