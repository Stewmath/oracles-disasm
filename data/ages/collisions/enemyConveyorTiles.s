enemyConveyorTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5


@collisions2:
@collisions5:
	.db $54, ANGLE_UP
	.db $55, ANGLE_RIGHT
	.db $56, ANGLE_DOWN
	.db $57, ANGLE_LEFT
@collisions0:
@collisions1:
@collisions3:
@collisions4:
	.db $00
