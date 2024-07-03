; This is a list of tiles which cause PARTID_SEA_EFFECTS to spawn in the room if any of the tiles
; exist. See seaEffectTiles2.s for details.

seaEffectTileTable:
	.db @overworld-CADDR
	.db @indoors-CADDR
	.db @dungeons-CADDR
	.db @sidescrolling-CADDR
	.db @underwater-CADDR
	.db @five-CADDR

@overworld:
@underwater:
	.db TILEINDEX_POLLUTION
	.db TILEINDEX_WHIRLPOOL
	.db $00

@indoors:
@dungeons:
@five:
	.db $3c $3d $3e $3f ; Whirlpool tiles
@sidescrolling:
	.db $00
