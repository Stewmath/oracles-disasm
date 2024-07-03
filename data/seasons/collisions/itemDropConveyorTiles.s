itemDropConveyorTilesTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

@dungeons:
	.db TILEINDEX_CONVEYOR_UP    $00
	.db TILEINDEX_CONVEYOR_RIGHT $08
	.db TILEINDEX_CONVEYOR_DOWN  $10
	.db TILEINDEX_CONVEYOR_LEFT  $18
@overworld:
@subrosia:
@makutree:
@indoors:
@sidescrolling:
	.db $00
