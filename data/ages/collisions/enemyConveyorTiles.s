enemyConveyorTilesTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five


@dungeons:
@five:
	.db $54, ANGLE_UP
	.db $55, ANGLE_RIGHT
	.db $56, ANGLE_DOWN
	.db $57, ANGLE_LEFT
@overworld:
@indoors:
@sidescrolling:
@underwater:
	.db $00
