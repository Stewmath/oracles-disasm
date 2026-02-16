.ifdef INCLUDE_GARBAGE

.ifdef REGION_JP
	; TODO : analyze this garbage data.
	.db $7f $6d $7f $62 $2e $77 $7e $fe
	.db $04 $c0 $2e $79 $36 $01 $3e $3d
	.db $c3 $74 $0c $c9 $1e $44 $1a $c7
	.db $76 $7f $8b $7f $cd $e9 $15 $cd
	.db $9a $23 $2e $49 $36 $04 $3e $0b
	.db $cd $f4 $24 $21 $4c $65 $cd $fd
	.db $24 $cd $0b $25 $1e $7f $1a $b7
	.db $ca $45 $26 $cd $b7 $25 $c3 $9a
	.db $22 $1e $44 $1a $c7 $a3 $7f $b1
	.db $7f $cd $e9 $15 $3e $06 $cd $8c
	.db $24 $2e $44 $34 $c3 $f0 $1d $1e
	.db $42 $1a $21 $de $cf $cd $05 $02
	.db $c2 $c5 $3a $c3 $1c $26
.endif ; REGION_JP

.endif