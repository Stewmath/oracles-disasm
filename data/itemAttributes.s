; See constants/itemsTypes.s.

; b0: Item.collisionType (see constants/collisionTypes.s)
;     bit 7 set if collisions should be enabled?
; b1: Item.collisionRadiusY/X (1st digit is Y, 2nd is X)
; b2: Item.damage (how much it deals to enemies)
; b3: Item.health

; @addr{65b3}
itemAttributes:
	.db $80 $11 $ff $03 ; $00
	.db $01 $00 $00 $00 ; $01
	.db $8a $55 $ff $00 ; $02
	.db $18 $44 $fc $00 ; $03
	.db $92 $44 $fc $00 ; $04
	.db $84 $00 $fe $7e ; $05
	.db $97 $66 $fe $00 ; $06
	.db $90 $00 $ff $7e ; $07
	.db $12 $00 $00 $00 ; $08
	.db $12 $00 $00 $00 ; $09
	.db $8d $66 $fe $7e ; $0a
	.db $12 $00 $00 $7e ; $0b
	.db $87 $55 $fb $00 ; $0c
	.db $18 $00 $fc $00 ; $0d
	.db $12 $00 $00 $00 ; $0e
	.db $12 $00 $00 $00 ; $0f
	.db $12 $00 $00 $00 ; $10
	.db $12 $00 $00 $00 ; $11
	.db $12 $00 $00 $00 ; $12
	.db $12 $00 $00 $00 ; $13
	.db $12 $00 $00 $00 ; $14
	.db $8c $33 $ff $00 ; $15
	.db $16 $00 $fd $00 ; $16
	.db $12 $00 $00 $00 ; $17
	.db $15 $77 $fc $09 ; $18
	.db $12 $00 $00 $00 ; $19
	.db $12 $00 $00 $00 ; $1a
	.db $12 $00 $00 $00 ; $1b
	.db $12 $00 $00 $00 ; $1c
	.db $84 $66 $f8 $7e ; $1d
	.db $84 $99 $f4 $7e ; $1e
	.db $12 $00 $00 $00 ; $1f
	.db $9b $44 $fe $00 ; $20
	.db $9c $44 $fe $00 ; $21
	.db $9d $44 $ff $00 ; $22
	.db $9e $44 $ff $00 ; $23
	.db $9a $44 $fe $00 ; $24
	.db $92 $00 $00 $00 ; $25
	.db $92 $00 $00 $00 ; $26
	.db $99 $22 $fe $00 ; $27
	.db $99 $aa $fc $00 ; $28
	.db $90 $66 $fc $7e ; $29
	.db $99 $66 $fc $00 ; $2a
	.db $8f $88 $fc $00 ; $2b
