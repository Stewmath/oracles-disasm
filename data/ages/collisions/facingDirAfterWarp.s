; List of tiles which set Link's facing direction to a particular value when spawning onto them.
;
; Data format:
;   b0: Tile index
;   b1: Direction to face when spawning onto that tile

facingDirAfterWarpTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five

@indoors:
	.db $36 DIR_UP ; Cave opening?
@dungeons:
@sidescrolling:
	.db $44 DIR_LEFT  ; Up stairs
	.db $45 DIR_RIGHT ; Down stairs
@overworld:
@underwater:
@five:
	.db $00
