; This lists the tiles that an enemy can't spawn on (despite being non-solid).
;   b0: tile index
;   b1: unused?

enemyUnspawnableTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
@collisions1:
	.db $f3 $01
	.db $fd $01
	.db $00
@collisions2:
@collisions3:
@collisions4:
	.db $f3 $01
	.db $f4 $01
	.db $f5 $01
	.db $f6 $01
	.db $f7 $01
	.db $fd $01
	.db $d0 $01
	.db $59 $01
	.db $5a $01
	.db $5b $01
	.db $5c $01
	.db $5d $01
	.db $5e $01
	.db $5f $01
	.db $44 $01
	.db $45 $01

@collisions5:
	.db $00
