; This is a list of tiles that initiate warps when touched.
;
; Data format:
;   b0: Tile index which triggers a warp
;   b1: Always $00 except for a special case for holly's chimney?

warpTileTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

@overworld:
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

@subrosia:
	.db $e6 $00
	.db $e7 $00
	.db $e8 $00
	.db $ed $00
	.db $ee $00
	.db $ef $00
	.db $00

@makutree:
	.db $ea $00
	.db $eb $00
	.db $ec $00
	.db $ed $00
	.db $e8 $00
	.db $00

@indoors:
	.db $34 $00
	.db $36 $00
	.db $4f $00
	.db $44 $00
	.db $45 $00
	.db $46 $00
	.db $47 $00
	.db $00

@dungeons:
	.db $44 $00
	.db $45 $00
	.db $46 $00
	.db $47 $00
	.db $4f $00
	.db $00

@sidescrolling:
	.db $00
