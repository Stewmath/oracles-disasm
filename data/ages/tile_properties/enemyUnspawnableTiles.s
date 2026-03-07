; This lists the tiles that an enemy can't spawn on (despite being non-solid).
;
; Data format:
;   b0: Tile index
;   b1: Unused? (always $01)

enemyUnspawnableTilesTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five

@overworld:
@underwater:
	.db $f3 $01
	.db $fd $01
	.db $e9 $01
	.db $00

@indoors:
@dungeons:
@five:
	.db $f3 $01
	.db $f4 $01
	.db $f5 $01
	.db $f6 $01
	.db $f7 $01
	.db $fd $01
	.db $59 $01
	.db $5a $01
	.db $5b $01
	.db $5c $01
	.db $5d $01
	.db $5e $01
	.db $5f $01
	.db $44 $01
	.db $45 $01
	.db $3c $01
	.db $3d $01
	.db $3e $01
	.db $3f $01
@sidescrolling:
	.db $00
