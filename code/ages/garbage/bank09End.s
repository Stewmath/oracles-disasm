.ifdef INCLUDE_GARBAGE

.ifdef REGION_JP
	; TODO : analyze this garbage data.
	.db $0e $ea $39 $cc $c9 $cd $55 $19
	.db $e6 $40 $c0 $3e $42 $cd $17 $17
	.db $d0 $cb $f6 $c9 $cd $55 $19 $cb
	.db $77 $c0 $cb $7f $c8 $cd $b2 $3a
	.db $c0 $36 $60 $2c $36 $42 $2c $36
	.db $01 $2e $4b $3e $58 $22 $fa $e0
	.db $c6 $2e $4d $77 $c9 $cd $b8 $23
	.db $20 $44 $fa $ab $c4 $b7 $c0 $3e
	.db $01 $12 $1e $40 $1a $f6 $80 $12
	.db $cd $e9 $15 $cd $26 $1e $cd $38
	.db $1e $1e $42 $1a $b7 $28 $05 $fa
	.db $86 $c4 $2f $3c $c6 $28 $2e $4b
	.db $77 $1e $42 $1a $b7 $20 $09 $cd
	.db $9f $23 $21 $1c $7f $c3 $ea $7e
	.db $3e $30 $cd $b3 $30 $c2 $c5 $3a
	.db $1e $46 $3e $3c $12 $c9 $3e $0a
	.db $cd $b3 $30 $20 $07 $fa $ab $c4
	.db $b7 $c2 $c5 $3a $cd $bd $23 $20
	.db $20 $cd $86 $23 $c0 $2e $46 $36
	.db $3c $cd $2f $04 $e6 $01 $c8 $cd
	.db $9f $23 $cd $2f $04 $e6 $03 $21
	.db $14 $7f $df $2a $66 $6f $c3 $ea
	.db $7e $1e $70 $1a $b7 $20 $3a $3e
	.db $01 $12 $1e $47 $1a $21 $11 $7f
	.db $d7 $7e $cd $e7 $04 $3e $ff $ea
	.db $29 $cd $1a $b7 $3e $d2 $c4 $74
	.db $0c $1a $fe $02 $28 $05 $cd $38
	.db $1e $18 $16 $cd $1a $04 $e6 $01
	.db $47 $3e $13 $28 $02 $3e $8d $1e
	.db $4d $12 $78 $cd $ca $25 $cd $41
	.db $1e $1e $47 $1a $fe $02 $20 $0c
	.db $cd $b7 $25 $1e $61 $1a $3c $20
	.db $03 $cd $38 $1e $cd $86 $23 $c0
	.db $62 $2e $58 $2a $6e $67 $23 $23
	.db $1e $58 $7c $12 $1c $7d $12 $2a
	.db $3c $28 $0b $1e $46 $12 $1c $7e
	.db $12 $1e $70 $af $12 $c9 $62 $2e
	.db $42 $7e $b7 $ca $c5 $3a $2e $45
	.db $36 $00 $2e $46 $36 $3c $c9 $3b
	.db $99 $9a $1c $7f $1c $7f $1c $7f
	.db $1c $7f $3c $00 $02 $01 $04 $00
	.db $02 $02 $78 $00 $02 $01 $02 $00
	.db $02 $01 $02 $00 $03 $01 $01 $00
	.db $0c $02 $3c $00 $ff 
.endif ; REGION_JP

.endif