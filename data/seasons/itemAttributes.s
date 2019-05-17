; See constants/itemsTypes.s.

; b0: Item.collisionType (see constants/collisionTypes.s)
;     bit 7 set if collisions should be enabled?
; b1: Item.collisionRadiusY/X (1st digit is Y, 2nd is X)
; b2: Item.damage (how much it deals to enemies)
; b3: Item.health

itemAttributes:
	.db $80 $11 $ff $03 ; $00: ITEMID_NONE
	.db $01 $00 $00 $00 ; $01: ITEMID_SHIELD
	.db $8a $55 $ff $00 ; $02: ITEMID_PUNCH
	.db $17 $44 $fc $00 ; $03: ITEMID_BOMB
	.db $92 $44 $fc $00 ; $04: ITEMID_CANE_OF_SOMARIA
	.db $84 $00 $fe $7e ; $05: ITEMID_SWORD
	.db $95 $66 $fe $00 ; $06: ITEMID_BOOMERANG
	.db $8c $00 $ff $7e ; $07: ITEMID_ROD_OF_SEASONS
	.db $12 $00 $00 $00 ; $08: ITEMID_MAGNET_GLOVES
	.db $12 $00 $00 $00 ; $09: ITEMID_SWITCH_HOOK_HELPER
	.db $92 $66 $fe $7e ; $0a: ITEMID_SWITCH_HOOK
	.db $12 $00 $00 $7e ; $0b: ITEMID_SWITCH_HOOK_CHAIN
	.db $87 $55 $fb $00 ; $0c: ITEMID_BIGGORON_SWORD
	.db $17 $00 $fc $00 ; $0d: ITEMID_BOMBCHUS
	.db $12 $00 $00 $00 ; $0e: ITEMID_FLUTE
	.db $12 $00 $00 $00 ; $0f: ITEMID_SHOOTER
	.db $12 $00 $00 $00 ; $10: ITEMID_10
	.db $12 $00 $00 $00 ; $11: ITEMID_HARP
	.db $12 $00 $00 $00 ; $12: ITEMID_12
	.db $12 $00 $00 $00 ; $13: ITEMID_SLINGSHOT
	.db $12 $00 $00 $00 ; $14: ITEMID_14
	.db $8d $33 $ff $00 ; $15: ITEMID_SHOVEL
	.db $14 $00 $fd $00 ; $16: ITEMID_BRACELET
	.db $12 $00 $00 $00 ; $17: ITEMID_FEATHER
	.db $13 $77 $fc $09 ; $18: ITEMID_18
	.db $12 $00 $00 $00 ; $19: ITEMID_SEED_SATCHEL
	.db $12 $00 $00 $00 ; $1a: ITEMID_DUST
	.db $12 $00 $00 $00 ; $1b: ITEMID_1b
	.db $12 $00 $00 $00 ; $1c: ITEMID_1c
	.db $84 $66 $f8 $7e ; $1d: ITEMID_MINECART_COLLISION
	.db $84 $99 $f4 $7e ; $1e: ITEMID_FOOLS_ORE
	.db $12 $00 $00 $00 ; $1f: ITEMID_1f
	.db $9b $44 $fe $00 ; $20: ITEMID_EMBER_SEED
	.db $9c $44 $fe $00 ; $21: ITEMID_SCENT_SEED
	.db $9d $44 $ff $00 ; $22: ITEMID_PEGASUS_SEED
	.db $9e $44 $ff $00 ; $23: ITEMID_GALE_SEED
	.db $9a $44 $fe $00 ; $24: ITEMID_MYSTERY_SEED
	.db $92 $00 $00 $00 ; $25: ITEMID_25
	.db $92 $00 $00 $00 ; $26: ITEMID_26
	.db $99 $22 $fe $00 ; $27: ITEMID_SWORD_BEAM
	.db $99 $aa $fc $00 ; $28: ITEMID_28
	.db $98 $66 $fc $7e ; $29: ITEMID_29
	.db $99 $66 $fc $00 ; $2a: ITEMID_RICKY_TORNADO
	.db $8f $88 $fc $00 ; $2b: ITEMID_DIMITRI_MOUTH
