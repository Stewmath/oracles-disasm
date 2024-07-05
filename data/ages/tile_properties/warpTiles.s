; This is a list of tiles that initiate warps when touched.
;
; Data format:
;   b0: Tile index which triggers a warp
;   b1: Always $00 except for a special case for holly's chimney?

warpTileTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five

@overworld:
@underwater:
	.db $dc $00
	.db $dd $00
	.db $de $00
	.db $df $00
	.db $ed $00
	.db $ee $00
	.db $ef $00
	.db $00

@indoors:
	.db $34 $00
	.db $36 $00
	.db $44 $00
	.db $45 $00
	.db $46 $00
	.db $47 $00
	.db $af $00
	.db $00

@dungeons:
@five:
	.db $44 $00
	.db $45 $00
	.db $46 $00
	.db $47 $00
	.db $4f $00
	.db $00

@sidescrolling:
	.db $00
