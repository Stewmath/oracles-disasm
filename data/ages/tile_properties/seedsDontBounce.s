; List of tiles which seed shooter seeds don't bounce off of. (Burnable stuff.)
seedsDontBounceTilesTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five

@overworld:
	.db $ce $cf $c5 $c5 $c6 $c7 $c8 $c9 $ca
@indoors:
@sidescrolling:
@underwater:
	.db $00

@dungeons:
@five:
	.db TILEINDEX_UNLIT_TORCH
	.db TILEINDEX_LIT_TORCH
	.db $00
