; This is a list of positions Link can warp to with gale seeds.
; This does not populate the screens themselves with trees or anything.
;
; Data format:
;   b0: room index (or $00 to terminate the list)
;   b1: position for Link to land in
;   b2: map popup index (should show the tree type)

treeWarps:
	.db $10 $34 $18
	.db $5f $43 $18
	.db $67 $23 $16
	.db $72 $44 $17
	.db $9e $45 $19
	.db $f8 $33 $15
	.db $00 $00 $00
	.db $00 $00 $00
