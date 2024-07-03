; Lists tiles that behave as conveyors when item drops (PARTID_ITEM_DROP) are on them.

itemDropConveyorTilesTable:
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
