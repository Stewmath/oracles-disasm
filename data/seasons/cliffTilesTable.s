; @addr{7c9a}
cliffTilesTable:
	.dw @collisions0Data
	.dw @collisions1Data
	.dw @collisions2Data
	.dw @collisions3Data
	.dw @collisions4Data
	.dw @collisions5Data

; Data format:
; b0: Tile index
; b1: Angle value from which the tile can be jumped off of.

@collisions0Data:
	.db $54 $10
	.db $25 $18
	.db $26 $08
	.db $28 $08
	.db $27 $18
	.db $94 $10
	.db $95 $10
	.db $2a $00
	.db $9a $10
	.db $cc $10
	.db $cd $10
	.db $ce $10
	.db $cf $10
	.db $fe $10
	.db $ff $10
	.db $00

@collisions1Data:
	.db $ea $10
	.db $eb $10
	.db $54 $10
	.db $00

@collisions2Data:
	.db $00
@collisions3Data:
@collisions4Data:
	.db $b0 $10
	.db $b1 $18
	.db $b2 $00
	.db $b3 $08
	.db $05 $00
	.db $06 $10

@collisions5Data:
	.db $00
