seaEffectTileTable:
	.db @data0-CADDR
	.db @data1-CADDR
	.db @data1-CADDR
	.db @data2-CADDR
	.db @data0-CADDR
	.db @data1-CADDR

; Outside, underwater collisions
@data0:
	.db $eb ; Pollution tile
	.db $e9 ; Whirlpool tile
	.db $00

; Dungeon & Indoor collisions
@data1:
	.db $3c $3d $3e $3f ; All whirlpool tiles?

; Sidescrolling collisions
@data2:
	.db $00
