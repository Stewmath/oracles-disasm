; This is a list of tiles that initiate warps when touched.
warpTileTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
	.db $e6 $00
	.db $e7 $00
	.db $e8 $00
	.db $e9 $00
	.db $ea $00
	.db $eb $01 ; Chimney gets special treatment?
	.db $ed $00
	.db $ee $00
	.db $ef $00
	.db $00
@collisions1:
	.db $e6 $00
	.db $e7 $00
	.db $e8 $00
	.db $ed $00
	.db $ee $00
	.db $ef $00
	.db $00
@collisions2:
	.db $ea $00
	.db $eb $00
	.db $ec $00
	.db $ed $00
	.db $e8 $00
	.db $00
@collisions3:
	.db $34 $00
	.db $36 $00
	.db $4f $00
	.db $44 $00
	.db $45 $00
	.db $46 $00
	.db $47 $00
	.db $00
@collisions4:
	.db $44 $00
	.db $45 $00
	.db $46 $00
	.db $47 $00
	.db $4f $00
	.db $00
@collisions5:
	.db $00
