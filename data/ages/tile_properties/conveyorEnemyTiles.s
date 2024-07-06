; Defines tiles which behave as conveyors when enemies are on them.
;
; Data format:
;   b0: Tile index
;   b1: Angle to move the enemy

enemyConveyorTilesTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five


@dungeons:
@five:
	.db TILEINDEX_CONVEYOR_UP,    ANGLE_UP
	.db TILEINDEX_CONVEYOR_RIGHT, ANGLE_RIGHT
	.db TILEINDEX_CONVEYOR_DOWN,  ANGLE_DOWN
	.db TILEINDEX_CONVEYOR_LEFT,  ANGLE_LEFT
@overworld:
@indoors:
@sidescrolling:
@underwater:
	.db $00
