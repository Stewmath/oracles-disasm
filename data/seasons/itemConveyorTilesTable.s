_itemConveyorTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

; b0: tile index
; b1: angle to move in

@collisions4:
	.db TILEINDEX_CONVEYOR_UP	$00
	.db TILEINDEX_CONVEYOR_RIGHT	$08
	.db TILEINDEX_CONVEYOR_DOWN	$10
	.db TILEINDEX_CONVEYOR_LEFT	$18
@collisions0:
@collisions1:
@collisions2:
@collisions3:
@collisions5:
	.db $00			; $4c37