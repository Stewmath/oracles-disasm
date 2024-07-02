; This is a list of tiles that can be landed on when jumping down a cliff, despite being
; solid.
landableTileFromCliffExceptions:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions1:
@collisions2:
@collisions5:
	.db TILEINDEX_RAISABLE_FLOOR_1 TILEINDEX_RAISABLE_FLOOR_2
@collisions0:
@collisions3:
@collisions4:
	.db $00
