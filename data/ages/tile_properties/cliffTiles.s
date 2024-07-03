; Determines which tiles function as cliffs which Link can jump down.
;
; Data format:
;   b0: Tile index ($00 for end of list)
;   b1: Angle value from which the tile can be jumped off of.
;
; See also "itemPassableTiles.s" which allows projectiles to pass through cliffs.

cliffTilesTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five

@overworld:
@underwater:
	.db $05, ANGLE_DOWN
	.db $06, ANGLE_DOWN
	.db $07, ANGLE_DOWN
	.db $0a, ANGLE_LEFT
	.db $0b, ANGLE_RIGHT
	.db $64, ANGLE_DOWN
	.db $ff, ANGLE_DOWN
	.db $00

@indoors:
@dungeons:
@five:
	.db $b0, ANGLE_DOWN
	.db $b1, ANGLE_LEFT
	.db $b2, ANGLE_UP
	.db $b3, ANGLE_RIGHT
	.db $c1, ANGLE_DOWN
	.db $c2, ANGLE_LEFT
	.db $c3, ANGLE_UP
	.db $c4, ANGLE_RIGHT
@sidescrolling:
	.db $00
