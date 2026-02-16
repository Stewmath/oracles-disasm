.ifdef INCLUDE_GARBAGE

.ifdef REGION_US
; Garbage data? Looks like a partial repeat of the last warp.
unknownData7ede:
	.db $ef $44 $43 $ff ; $7ede
.endif ; REGION_US

.endif