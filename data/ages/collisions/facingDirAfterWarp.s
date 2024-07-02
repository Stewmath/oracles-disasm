; List of tiles which set Link's facing direction to a particular value when spawning onto them.
;
; Data format:
;
; b0: Tile index
; b1: Direction to face when spawning onto that tile

facingDirAfterWarpTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions1:
	.db $36 DIR_UP ; Cave opening?
@collisions2:
@collisions3:
	.db $44 DIR_LEFT  ; Up stairs
	.db $45 DIR_RIGHT ; Down stairs

@collisions0:
@collisions4:
@collisions5:
	.db $00
