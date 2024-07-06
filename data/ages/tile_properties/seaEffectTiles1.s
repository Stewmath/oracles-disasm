; This is a list of tiles which cause PART_SEA_EFFECTS to spawn in the room if any of the tiles
; exist. See seaEffectTiles2.s for details.

seaEffectTileTable:
	dbrel @overworld
	dbrel @indoors
	dbrel @dungeons
	dbrel @sidescrolling
	dbrel @underwater
	dbrel @five

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
