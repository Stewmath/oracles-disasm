.ifdef INCLUDE_GARBAGE

.ifdef REGION_JP
	; TODO : analyze this garbage data.
	.db $25 $7e $b7 $c0 $34 $3e $01 $c3
	.db $ca $25 $c3 $c5 $3a
.endif ; REGION_JP

.endif