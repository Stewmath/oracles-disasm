itemConveyorTilesTable:
	.dw itemConveyorTiles_collisions0
	.dw itemConveyorTiles_collisions1
	.dw itemConveyorTiles_collisions2
	.dw itemConveyorTiles_collisions3
	.dw itemConveyorTiles_collisions4
	.dw itemConveyorTiles_collisions5

; b0: tile index
; b1: angle to move in

itemConveyorTiles_collisions2:
itemConveyorTiles_collisions5:
	.db TILEINDEX_CONVEYOR_UP	$00
	.db TILEINDEX_CONVEYOR_RIGHT	$08
	.db TILEINDEX_CONVEYOR_DOWN	$10
	.db TILEINDEX_CONVEYOR_LEFT	$18
itemConveyorTiles_collisions0:
itemConveyorTiles_collisions1:
itemConveyorTiles_collisions3:
itemConveyorTiles_collisions4:
	.db $00
