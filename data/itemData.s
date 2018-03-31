; See constants/itemTypes.s.
;
; Data format:
; b0: object gfx index (see data/objectGfxHeaders.s)
; b1: value for Item.oamTileIndexBase
; b2: value for Item.oamFlags

; @addr{63a5}
itemData:
	.db $00 $00 $00 ; $00
	.db $00 $00 $00 ; $01
	.db $00 $00 $00 ; $02
	.db $78 $10 $04 ; $03
	.db $00 $52 $0a ; $04
	.db $00 $52 $08 ; $05
	.db $00 $4e $0d ; $06
	.db $00 $52 $0a ; $07
	.db $00 $52 $09 ; $08
	.db $00 $00 $00 ; $09
	.db $00 $52 $09 ; $0a
	.db $00 $16 $09 ; $0b
	.db $00 $52 $0b ; $0c
	.db $00 $2c $0d ; $0d
	.db $00 $00 $00 ; $0e
	.db $00 $52 $08 ; $0f
	.db $00 $00 $00 ; $10
	.db $00 $00 $00 ; $11
	.db $00 $00 $00 ; $12
	.db $00 $52 $09 ; $13
	.db $00 $00 $00 ; $14
	.db $00 $00 $00 ; $15
	.db $00 $00 $00 ; $16
	.db $00 $00 $00 ; $17
	.db $00 $18 $0b ; $18
	.db $00 $00 $00 ; $19
	.db $00 $16 $0b ; $1a
	.db $00 $00 $00 ; $1b
	.db $00 $00 $00 ; $1c
	.db $00 $00 $00 ; $1d
	.db $00 $52 $08 ; $1e
	.db $00 $00 $00 ; $1f
	.db $78 $12 $02 ; $20
	.db $78 $14 $03 ; $21
	.db $78 $16 $01 ; $22
	.db $78 $18 $01 ; $23
	.db $78 $1a $00 ; $24
	.db $00 $1c $01 ; $25
	.db $00 $1e $00 ; $26
	.db $00 $38 $0c ; $27
	.db $00 $00 $00 ; $28
	.db $72 $0a $02 ; $29
	.db $00 $28 $09 ; $2a
	; Item $2b (dimitri mouth) missing? Not that important since it's invisible...
	; It'll end up reading from the first entry of "interactionData".
