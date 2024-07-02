; This is a list of tiles that initiate warps when touched.
warpTileTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
@collisions4:
	.db $dc $00
	.db $dd $00
	.db $de $00
	.db $df $00
	.db $ed $00
	.db $ee $00
	.db $ef $00
	.db $00
@collisions1:
	.db $34 $00
	.db $36 $00
	.db $44 $00
	.db $45 $00
	.db $46 $00
	.db $47 $00
	.db $af $00
	.db $00
@collisions2:
@collisions5:
	.db $44 $00
	.db $45 $00
	.db $46 $00
	.db $47 $00
	.db $4f $00
	.db $00
@collisions3:
	.db $00
