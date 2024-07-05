; List of tiles which seed shooter seeds don't bounce off of. (Burnable stuff.)
;
; CROSSITEMS: Added this for seasons.
;
; Not including most types of flowers in this table because some of them can be "fall leaves" in
; autumn (and then the seeds would stop when touching fall leaves which is obviously wrong)
seedsDontBounceTilesTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

@overworld:
	.db $c4 $c5 $c6 $c7 $ca $cb $d8 $e5
@subrosia:
@makutree:
@sidescrolling:
	.db $00

@indoors:
@dungeons:
	.db TILEINDEX_UNLIT_TORCH
	.db TILEINDEX_LIT_TORCH
	.db $00
