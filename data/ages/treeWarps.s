; This is a list of positions Link can warp to with gale seeds.
; This does not populate the screens themselves with trees or anything.
;
; Data format:
;   b0: room index (or $00 to terminate the list)
;   b1: position for Link to land in
;   b2: map popup index (should show the tree type)

presentTreeWarps:
	.db $ac $54 $16 ; This entry is ignored unless the scent seedling is planted
	.db $13 $55 $18
	.db $78 $55 $15
	.db $c1 $34 $18
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00

pastTreeWarps:
	.db $08 $43 $17
	.db $25 $44 $16
	.db $2d $36 $19
	.db $78 $55 $15
	.db $80 $36 $19
	.db $c1 $34 $18
	.db $00 $00 $00
	.db $00 $00 $00
