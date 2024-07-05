; Lists tiles which behave as conveyors when bombs and bombchus owned by the player are resting on
; them.
;
; Data format:
;
; b0: tile index
; b1: angle to move in

itemConveyorTilesTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

@dungeons:
	.db TILEINDEX_CONVEYOR_UP,    ANGLE_UP
	.db TILEINDEX_CONVEYOR_RIGHT, ANGLE_RIGHT
	.db TILEINDEX_CONVEYOR_DOWN,  ANGLE_DOWN
	.db TILEINDEX_CONVEYOR_LEFT,  ANGLE_LEFT
@overworld:
@subrosia:
@makutree:
@indoors:
@sidescrolling:
	.db $00
