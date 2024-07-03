; Determines which tiles function as cliffs which Link can jump down.
;
; Data format:
;   b0: Tile index ($00 for end of list)
;   b1: Angle value from which the tile can be jumped off of.
;
; See also "itemPassibleTiles.s" which allows projectiles to pass through cliffs.

cliffTilesTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

@overworld:
	.db $54, ANGLE_DOWN
	.db $25, ANGLE_LEFT
	.db $26, ANGLE_RIGHT
	.db $28, ANGLE_RIGHT
	.db $27, ANGLE_LEFT
	.db $94, ANGLE_DOWN
	.db $95, ANGLE_DOWN
	.db $2a, ANGLE_UP
	.db $9a, ANGLE_DOWN
	.db $cc, ANGLE_DOWN
	.db $cd, ANGLE_DOWN
	.db $ce, ANGLE_DOWN
	.db $cf, ANGLE_DOWN
	.db $fe, ANGLE_DOWN
	.db $ff, ANGLE_DOWN
	.db $00

@subrosia:
	.db $ea, ANGLE_DOWN
	.db $eb, ANGLE_DOWN
	.db $54, ANGLE_DOWN
	.db $00

@makutree:
	.db $00

@indoors:
@dungeons:
	.db $b0, ANGLE_DOWN
	.db $b1, ANGLE_LEFT
	.db $b2, ANGLE_UP
	.db $b3, ANGLE_RIGHT
	.db $05, ANGLE_UP
	.db $06, ANGLE_DOWN
@sidescrolling:
	.db $00
