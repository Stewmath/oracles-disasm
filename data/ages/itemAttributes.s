; See constants/common/items.s.

; b0: Item.collisionType (see constants/common/collisionTypes.s)
;     bit 7 set if collisions should be enabled?
; b1: Item.collisionRadiusY/X (1st digit is Y, 2nd is X)
; b2: Item.damage (how much it deals to enemies)
; b3: Item.health

itemAttributes:
	.db $80 $11 $ff $03 ; $00: ITEM_NONE
	.db $01 $00 $00 $00 ; $01: ITEM_SHIELD
	.db $8a $55 $ff $00 ; $02: ITEM_PUNCH
	.db $18 $44 $fc $00 ; $03: ITEM_BOMB
	.db $92 $44 $fc $00 ; $04: ITEM_CANE_OF_SOMARIA
	.db $84 $00 $fe $7e ; $05: ITEM_SWORD
	.db $97 $66 $fe $00 ; $06: ITEM_BOOMERANG
	.db $90 $00 $ff $7e ; $07: ITEM_ROD_OF_SEASONS
	.db $12 $00 $00 $00 ; $08: ITEM_MAGNET_GLOVES
	.db $12 $00 $00 $00 ; $09: ITEM_SWITCH_HOOK_HELPER
	.db $8d $66 $fe $7e ; $0a: ITEM_SWITCH_HOOK
	.db $12 $00 $00 $7e ; $0b: ITEM_SWITCH_HOOK_CHAIN
	.db $87 $55 $fb $00 ; $0c: ITEM_BIGGORON_SWORD
	.db $18 $00 $fc $00 ; $0d: ITEM_BOMBCHUS
	.db $12 $00 $00 $00 ; $0e: ITEM_FLUTE
	.db $12 $00 $00 $00 ; $0f: ITEM_SHOOTER
	.db $12 $00 $00 $00 ; $10: ITEM_10
	.db $12 $00 $00 $00 ; $11: ITEM_HARP
	.db $12 $00 $00 $00 ; $12: ITEM_12
	.db $12 $00 $00 $00 ; $13: ITEM_SLINGSHOT
	.db $12 $00 $00 $00 ; $14: ITEM_14
	.db $8c $33 $ff $00 ; $15: ITEM_SHOVEL
	.db $16 $00 $fd $00 ; $16: ITEM_BRACELET
	.db $12 $00 $00 $00 ; $17: ITEM_FEATHER
	.db $15 $77 $fc $09 ; $18: ITEM_18
	.db $12 $00 $00 $00 ; $19: ITEM_SEED_SATCHEL
	.db $12 $00 $00 $00 ; $1a: ITEM_DUST
	.db $12 $00 $00 $00 ; $1b: ITEM_1b
	.db $12 $00 $00 $00 ; $1c: ITEM_1c
	.db $84 $66 $f8 $7e ; $1d: ITEM_MINECART_COLLISION
	.db $84 $99 $f4 $7e ; $1e: ITEM_FOOLS_ORE
	.db $12 $00 $00 $00 ; $1f: ITEM_1f
	.db $9b $44 $fe $00 ; $20: ITEM_EMBER_SEED
	.db $9c $44 $fe $00 ; $21: ITEM_SCENT_SEED
	.db $9d $44 $ff $00 ; $22: ITEM_PEGASUS_SEED
	.db $9e $44 $ff $00 ; $23: ITEM_GALE_SEED
	.db $9a $44 $fe $00 ; $24: ITEM_MYSTERY_SEED
	.db $92 $00 $00 $00 ; $25: ITEM_25
	.db $92 $00 $00 $00 ; $26: ITEM_26
	.db $99 $22 $fe $00 ; $27: ITEM_SWORD_BEAM
	.db $99 $aa $fc $00 ; $28: ITEM_28
	.db $90 $66 $fc $7e ; $29: ITEM_29
	.db $99 $66 $fc $00 ; $2a: ITEM_RICKY_TORNADO
	.db $8f $88 $fc $00 ; $2b: ITEM_DIMITRI_MOUTH
