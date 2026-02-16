.ifdef INCLUDE_GARBAGE

.ifdef REGION_JP
	; TODO : analyze this garbage data.
	.db $60 $ba $b2 $00 $50 $bb $00 $21
	.db $b8 $b0 $00 $0c $b9 $00 $b3 $af
	.db $00 $0c $49 $b1 $0f $81 $ba $b2
	.db $00 $0c $bb $00 $00 $ff $ff $00
	.db $ff $07 $07 $f0 $17 $00 $f0 $2f
	.db $d0 $4f $a8 $c7 $8f $e0 $81 $6f
	.db $fc $fc $07 $fa $03 $fd $21 $08
	.db $07 $f9 $ff $01 $2f $60 $df $c0
	.db $40 $bf $21 $e0 $9f $ff $80 $bf
	.db $80 $c0 $2a $2f $0c $eb $0c $f4
	.db $0b $f2 $00 $15 $e3 $f1 $07 $e7
	.db $01 $ef $21 $00 $e7 $80 $f7 $84
	.db $bb $83 $fc $40 $00 $ff $60 $d7
	.db $50 $de $6e $db $68 $00 $fd $01
	.db $fa $02 $fe $fc $07 $01 $02 $ff
	.db $01 $fe $02 $f6 $06 $23 $df $08
	.db $9f $e0 $80 $ff $21 $c0 $f7 $70
	.db $20 $3f $20 $21 $1f $1f $dd $c1
	.db $3f $00 $02 $ff $06 $eb $0a $7b
	.db $76 $d3 $40 $16 $21 $e3 $e6 $db
	.db $68 $ef $77 $00 $d4 $58 $c8 $4f
	.db $e7 $27 $f8 $18 $00 $ff $0f $ff
	.db $00 $fe $02 $fc $fc $0d $01 $00
	.db $00 $ff $20 $a4 $80 $25 $c0 $41
	.db $0f $0a $1b $06 $f7 $0e $eb $1a
	.db $00 $13 $f2 $f7 $f4 $2f $28 $ff
	.db $f0 $84 $5b $7f $c0 $ff $bf $21
	.db $f1 $b3 $48 $ec $21 $bf $e0 $27
	.db $ff $fe $01 $20 $ff $fd $41 $9d
	.db $ff $cd $ff $e5 $08 $ff $f5 $ff
	.db $af $41 $a7 $ff $b3 $00 $ff $98
	.db $ff $c7 $ff $70 $7f $3f $78 $3f
	.db $31 $21 $37 $3b $19 $ff $e3 $04
	.db $ff $0e $fe $fc $fc $00 $0e $2f
	.db $07 $07 $0f $09 $17 $18 $1b $10
	.db $2a $20 $36 $26 $3f $98 $00 $3f
	.db $2f $2f $2f $17 $1f $1f $17 $17
	.db $1f $0f $0b $0e $0c $30 $20 $f0
	.db $80 $80 $ef $9f $fd $43 $a6 $60
	.db $20 $90 $30 $70 $10 $55 $00 $90
	.db $f0 $97 $f7 $9f $fc $93 $b8 $97
	.db $e8 $b7 $ff $ef $f0 $00 $00 $03
	.db $03 $fd $ff $be $80 $5e $40 $60
	.db $20 $20 $20 $d5 $00 $20 $2e $af
	.db $ff $f9 $46 $60 $df $c1 $bf $ff
	.db $7f $c0 $00 $00 $78 $78 $ac $c4
	.db $76 $02 $ba $82 $4b $41 $61 $41
	.db $61 $21 $d4 $00 $21 $31 $3b $7a
	.db $22 $56 $62 $64 $dc $8c $fc $78
	.db $f8 $00 $3b $1f $eb $ef $fe $9f
	.db $ff $e7 $79 $79 $3f $3e $1b $15
	.db $57 $00 $0f $0f $08 $04 $06 $76
	.db $3a $18 $85 $c2 $ff $3e $e7 $fd
	.db $bd $a5 $f3 $70 $e6 $af $eb $00
	.db $ff $00 $2f $3f $26 $3f $30 $3f
	.db $1f $1f $85 $c0 $ff $fe $07 $fd
	.db $fd $05 $8c $fc $f9 $7b $7f $fa
	.db $00 $ff $00 $5b $df $59 $df $8c
	.db $8f $07 $07 $01 $60 $ff $f0 $f0
	.db $38 $f8 $fe $e6 $3f $e1 $3f $b5
	.db $d7 $d7 $f5 $00 $ff $00 $d7 $f5
	.db $95 $f7 $22 $e2 $c0 $c0 $ff $ff
	.db $00 $30 $08 $1c $00 $00 $2f $37
	.db $37 $39 $5f $6e $7f $7b $14 $18
	.db $18 $fc $00 $00 $3c $3c $5a $66
	.db $e7 $a5 $bf $bd $ab $81 $82 $00
	.db $eb $c3 $ff $ff $bf $bd $81 $6a
	.db $42 $7e $7e $3c $3c $00 $00 $00
	.db $0e $7e $1e $1e $2d $33 $53 $72
	.db $7d $5f $6b $57 $6b $76 $5e $00
	.db $f0 $01 $6f $57 $2f $37 $3e $3e
	.db $1f $1e $00 $00 $00 $00 $f0 $00
	.db $00 $80 $80 $f0 $f0 $68 $98 $9c
	.db $94 $fc $f4 $ac $04 $38 $00 $fc
	.db $ac $0c $f4 $ac $04 $a8 $08 $f8
	.db $f8 $f0 $f0 $00 $00
.endif ; REGION_JP

.endif