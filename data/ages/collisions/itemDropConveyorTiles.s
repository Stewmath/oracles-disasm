itemDropConveyorTilesTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five

@dungeons:
@five:
	.db TILEINDEX_CONVEYOR_UP    $00
	.db TILEINDEX_CONVEYOR_RIGHT $08
	.db TILEINDEX_CONVEYOR_DOWN  $10
	.db TILEINDEX_CONVEYOR_LEFT  $18
@overworld:
@indoors:
@sidescrolling:
@underwater:
	.db $00
