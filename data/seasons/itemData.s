; See constants/itemTypes.s.
;
; Data format:
; b0: object gfx index (see data/objectGfxHeaders.s)
; b1: value for Item.oamTileIndexBase
; b2: value for Item.oamFlags

itemData:
	.db $00 $00 $00 ; $00: ITEMID_NONE
	.db $00 $00 $00 ; $01: ITEMID_SHIELD
	.db $00 $00 $00 ; $02: ITEMID_PUNCH
	.db $5c $10 $04 ; $03: ITEMID_BOMB
	.db $00 $52 $0a ; $04: ITEMID_CANE_OF_SOMARIA
	.db $00 $52 $08 ; $05: ITEMID_SWORD
	.db $00 $4e $0d ; $06: ITEMID_BOOMERANG
	.db $00 $52 $0a ; $07: ITEMID_ROD_OF_SEASONS
	.db $00 $52 $09 ; $08: ITEMID_MAGNET_GLOVES
	.db $00 $00 $00 ; $09: ITEMID_SWITCH_HOOK_HELPER
	.db $00 $52 $09 ; $0a: ITEMID_SWITCH_HOOK
	.db $00 $16 $09 ; $0b: ITEMID_SWITCH_HOOK_CHAIN
	.db $00 $52 $0b ; $0c: ITEMID_BIGGORON_SWORD
	.db $00 $2c $0d ; $0d: ITEMID_BOMBCHUS
	.db $00 $00 $00 ; $0e: ITEMID_FLUTE
	.db $00 $52 $08 ; $0f: ITEMID_SHOOTER
	.db $00 $00 $00 ; $10: ITEMID_10
	.db $00 $00 $00 ; $11: ITEMID_HARP
	.db $00 $00 $00 ; $12: ITEMID_12
	.db $00 $52 $09 ; $13: ITEMID_SLINGSHOT
	.db $00 $00 $00 ; $14: ITEMID_14
	.db $00 $00 $00 ; $15: ITEMID_SHOVEL
	.db $00 $00 $00 ; $16: ITEMID_BRACELET
	.db $00 $00 $00 ; $17: ITEMID_FEATHER
	.db $00 $18 $0b ; $18: ITEMID_18
	.db $00 $00 $00 ; $19: ITEMID_SEED_SATCHEL
	.db $00 $16 $0b ; $1a: ITEMID_DUST
	.db $00 $00 $00 ; $1b: ITEMID_1b
	.db $00 $00 $00 ; $1c: ITEMID_1c
	.db $00 $00 $00 ; $1d: ITEMID_MINECART_COLLISION
	.db $00 $52 $08 ; $1e: ITEMID_FOOLS_ORE
	.db $00 $00 $00 ; $1f: ITEMID_1f
	.db $5c $12 $02 ; $20: ITEMID_EMBER_SEED
	.db $5c $14 $03 ; $21: ITEMID_SCENT_SEED
	.db $5c $16 $01 ; $22: ITEMID_PEGASUS_SEED
	.db $5c $18 $01 ; $23: ITEMID_GALE_SEED
	.db $5c $1a $00 ; $24: ITEMID_MYSTERY_SEED
	.db $00 $1c $01 ; $25: ITEMID_25
	.db $00 $1e $00 ; $26: ITEMID_26
	.db $00 $38 $0c ; $27: ITEMID_SWORD_BEAM
	.db $00 $00 $00 ; $28: ITEMID_28
	.db $57 $0a $02 ; $29: ITEMID_29
	.db $00 $28 $09 ; $2a: ITEMID_RICKY_TORNADO
	; Item $2b (dimitri mouth) exists, but it's invisible, so this doesn't matter.
