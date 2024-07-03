; If you want to change which tiles are cliff tiles, see also "itemPassibleCliffTilesTable.s".

cliffTilesTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five

; Data format:
; b0: Tile index
; b1: Angle value from which the tile can be jumped off of.

@overworld:
@underwater:
	.db $05 $10
	.db $06 $10
	.db $07 $10
	.db $0a $18
	.db $0b $08
	.db $64 $10
	.db $ff $10
	.db $00

@indoors:
@dungeons:
@five:
	.db $b0 $10
	.db $b1 $18
	.db $b2 $00
	.db $b3 $08
	.db $c1 $10
	.db $c2 $18
	.db $c3 $00
	.db $c4 $08
@sidescrolling:
	.db $00
