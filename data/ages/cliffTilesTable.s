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
@collisions4Data:
	.db $05 $10
	.db $06 $10
	.db $07 $10
	.db $0a $18
	.db $0b $08
	.db $64 $10
	.db $ff $10
	.db $00

@collisions1Data:
@collisions2Data:
@collisions5Data:
	.db $b0 $10
	.db $b1 $18
	.db $b2 $00
	.db $b3 $08
	.db $c1 $10
	.db $c2 $18
	.db $c3 $00
	.db $c4 $08
@collisions3Data:
	.db $00
