enemyConveyorTilesTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling


@dungeons:
	.db $54, ANGLE_UP
	.db $55, ANGLE_RIGHT
	.db $56, ANGLE_DOWN
	.db $57, ANGLE_LEFT
@overworld:
@subrosia:
@makutree:
@indoors:
@sidescrolling:
	.db $00
