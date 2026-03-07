; List of tile indices which behave as magnet-able tiles.
;
; Can only have one tile per group number.
magnetTilesTable:
	.db $00 ; Group 0 (overworld)
	.db $e3 ; Group 1 (subrosia)
	.db $00 ; Group 2 (maku tree)
	.db $3f ; Group 3 (indoors)
	.db $3f ; Group 4 (dungeons)
	.db $3f ; Group 5 (dungeons)
	.db $3f ; Group 6 (dungeons, sidescroll)
	.db $3f ; Group 7 (dungeons, sidescroll)
