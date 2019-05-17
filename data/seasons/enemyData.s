; See notes in data/ages/enemyData.s.

.macro m_EnemyData
	.if NARGS == 4
		.db \1 \2 \3 \4
	.else
		.db \1 \2
		dwbe \3 | $8000
	.endif
.endm


enemyData:
	/* 0x00 */ m_EnemyData $00 $00 $00 $00
	/* 0x01 */ m_EnemyData $c2 $08 $34 $00
	/* 0x02 */ m_EnemyData $bd $89 $31 $60
	/* 0x03 */ m_EnemyData $24 $8a $33 $00
	/* 0x04 */ m_EnemyData $16 $8b $35 $10
	/* 0x05 */ m_EnemyData $c0 $0c $32 $60
	/* 0x06 */ m_EnemyData $b8 $8d $2f $60
	/* 0x07 */ m_EnemyData $91 $8e $36 $00
	/* 0x08 */ m_EnemyData $74 $0f $0c $2d
	/* 0x09 */ m_EnemyData $74 $90 enemy09SubidData
	/* 0x0a */ m_EnemyData $76 $91 enemy0aSubidData
	/* 0x0b */ m_EnemyData $74 $10 enemy0bSubidData
	/* 0x0c */ m_EnemyData $76 $91 enemy0cSubidData
	/* 0x0d */ m_EnemyData $7a $92 enemy0dSubidData
	/* 0x0e */ m_EnemyData $85 $93 enemy0eSubidData
	/* 0x0f */ m_EnemyData $88 $93 $03 $18
	/* 0x10 */ m_EnemyData $82 $10 $0a $06
	/* 0x11 */ m_EnemyData $77 $94 $11 $07
	/* 0x12 */ m_EnemyData $82 $95 $17 $20
	/* 0x13 */ m_EnemyData $82 $96 $03 $0a
	/* 0x14 */ m_EnemyData $72 $97 $0a $14
	/* 0x15 */ m_EnemyData $82 $98 $01 $2b
	/* 0x16 */ m_EnemyData $72 $00 $00 $18
	/* 0x17 */ m_EnemyData $75 $99 enemy17SubidData
	/* 0x18 */ m_EnemyData $78 $9a $0a $08
	/* 0x19 */ m_EnemyData $82 $9b $03 $09
	/* 0x1a */ m_EnemyData $79 $90 $0a $30
	/* 0x1b */ m_EnemyData $79 $90 $0a $2c
	/* 0x1c */ m_EnemyData $87 $9c $0a $20
	/* 0x1d */ m_EnemyData $77 $82 $40 $09
	/* 0x1e */ m_EnemyData $79 $84 $0c $32
	/* 0x1f */ m_EnemyData $00 $00 $00 $00
	/* 0x20 */ m_EnemyData $75 $91 enemy20SubidData
	/* 0x21 */ m_EnemyData $7e $9f enemy21SubidData
	/* 0x22 */ m_EnemyData $83 $a0 $0e $00
	/* 0x23 */ m_EnemyData $72 $a1 $0c $30
	/* 0x24 */ m_EnemyData $7f $22 $11 $36
	/* 0x25 */ m_EnemyData $79 $a3 $0a $28
	/* 0x26 */ m_EnemyData $00 $00 $00 $00
	/* 0x27 */ m_EnemyData $71 $80 $3b $50
	/* 0x28 */ m_EnemyData $87 $24 $11 $2c
	/* 0x29 */ m_EnemyData $8d $04 $03 $20
	/* 0x2a */ m_EnemyData $85 $a5 enemy2aSubidData
	/* 0x2b */ m_EnemyData $00 $84 $03 $a5
	/* 0x2c */ m_EnemyData $8d $8f $0a $33
	/* 0x2d */ m_EnemyData $8d $0f $11 $50
	/* 0x2e */ m_EnemyData $8c $a6 $03 $1d
	/* 0x2f */ m_EnemyData $8c $a7 $3c $40
	/* 0x30 */ m_EnemyData $74 $91 enemy30SubidData
	/* 0x31 */ m_EnemyData $82 $a8 enemy31SubidData
	/* 0x32 */ m_EnemyData $84 $a9 $07 $00
	/* 0x33 */ m_EnemyData $3f $00 $01 $37
	/* 0x34 */ m_EnemyData $7d $2a enemy34SubidData
	/* 0x35 */ m_EnemyData $89 $24 $11 $10
	/* 0x36 */ m_EnemyData $3f $ab $41 $20
	/* 0x37 */ m_EnemyData $3d $00 $00 $14
	/* 0x38 */ m_EnemyData $3e $00 $00 $20
	/* 0x39 */ m_EnemyData $84 $ac $09 $50
	/* 0x3a */ m_EnemyData $7d $90 $0c $05
	/* 0x3b */ m_EnemyData $81 $ad $3e $20
	/* 0x3c */ m_EnemyData $8b $9e $0e $00
	/* 0x3d */ m_EnemyData $76 $91 enemy3dSubidData
	/* 0x3e */ m_EnemyData $7d $d5 $0c $23
	/* 0x3f */ m_EnemyData $7b $00 $00 $50
	/* 0x40 */ m_EnemyData $86 $2f enemy40SubidData
	/* 0x41 */ m_EnemyData $78 $30 $3d $30
	/* 0x42 */ m_EnemyData $79 $00 $00 $2c
	/* 0x43 */ m_EnemyData $7d $b1 $06 $20
	/* 0x44 */ m_EnemyData $00 $00 $00 $00
	/* 0x45 */ m_EnemyData $77 $32 $11 $20
	/* 0x46 */ m_EnemyData $b1 $b3 enemy46SubidData
	/* 0x47 */ m_EnemyData $af $29 $0a $30
	/* 0x48 */ m_EnemyData $7e $9f enemy48SubidData
	/* 0x49 */ m_EnemyData $83 $a0 $0e $00
	/* 0x4a */ m_EnemyData $75 $b4 enemy4aSubidData
	/* 0x4b */ m_EnemyData $7f $b5 $16 $20
	/* 0x4c */ m_EnemyData $78 $30 $0c $14
	/* 0x4d */ m_EnemyData $72 $b6 $0e $32
	/* 0x4e */ m_EnemyData $88 $b7 $13 $30
	/* 0x4f */ m_EnemyData $7d $b8 $16 $07
	/* 0x50 */ m_EnemyData $00 $00 $00 $00
	/* 0x51 */ m_EnemyData $82 $39 $07 $0d
	/* 0x52 */ m_EnemyData $83 $3a $0a $5b
	/* 0x53 */ m_EnemyData $3d $02 $00 $26
	/* 0x54 */ m_EnemyData $80 $bb $01 $10
	/* 0x55 */ m_EnemyData $b5 $bc $16 $67
	/* 0x56 */ m_EnemyData $05 $82 $3a $35
	/* 0x57 */ m_EnemyData $7c $3d $39 $10
	/* 0x58 */ m_EnemyData $00 $be $0a $00
	/* 0x59 */ m_EnemyData $00 $00 $00 $88
	/* 0x5a */ m_EnemyData $00 $01 $01 $00
	/* 0x5b */ m_EnemyData $4f $00 $00 $68
	/* 0x5c */ m_EnemyData $00 $00 $00 $00
	/* 0x5d */ m_EnemyData $c5 $c9 $0a $16
	/* 0x5e */ m_EnemyData $84 $bf $42 $20
	/* 0x5f */ m_EnemyData $80 $c0 $41 $58
	/* 0x60 */ m_EnemyData $8f $00 $00 $02
	/* 0x61 */ m_EnemyData $00 $00 $00 $00
	/* 0x62 */ m_EnemyData $00 $00 $00 $00
	/* 0x63 */ m_EnemyData $00 $00 $00 $00
	/* 0x64 */ m_EnemyData $00 $00 $00 $00
	/* 0x65 */ m_EnemyData $00 $00 $00 $00
	/* 0x66 */ m_EnemyData $00 $00 $00 $00
	/* 0x67 */ m_EnemyData $00 $00 $00 $00
	/* 0x68 */ m_EnemyData $00 $00 $00 $00
	/* 0x69 */ m_EnemyData $00 $00 $00 $00
	/* 0x6a */ m_EnemyData $00 $00 $00 $00
	/* 0x6b */ m_EnemyData $00 $00 $00 $00
	/* 0x6c */ m_EnemyData $00 $00 $00 $00
	/* 0x6d */ m_EnemyData $00 $00 $00 $00
	/* 0x6e */ m_EnemyData $00 $00 $00 $00
	/* 0x6f */ m_EnemyData $00 $00 $00 $00
	/* 0x70 */ m_EnemyData $95 $41 enemy70SubidData
	/* 0x71 */ m_EnemyData $8a $0f $1d $10
	/* 0x72 */ m_EnemyData $96 $42 $1e $10
	/* 0x73 */ m_EnemyData $98 $43 $1f $20
	/* 0x74 */ m_EnemyData $9b $c4 $20 $30
	/* 0x75 */ m_EnemyData $30 $45 $21 $20
	/* 0x76 */ m_EnemyData $9e $46 $22 $20
	/* 0x77 */ m_EnemyData $a0 $47 $23 $20
	/* 0x78 */ m_EnemyData $a3 $c8 $24 $00
	/* 0x79 */ m_EnemyData $a8 $c9 $25 $60
	/* 0x7a */ m_EnemyData $ad $ca $26 $60
	/* 0x7b */ m_EnemyData $b0 $cb enemy7bSubidData
	/* 0x7c */ m_EnemyData $b3 $8a enemy7cSubidData
	/* 0x7d */ m_EnemyData $b6 $e1 enemy7dSubidData
	/* 0x7e */ m_EnemyData $9e $46 $22 $30
	/* 0x7f */ m_EnemyData $ba $4d $30 $00

enemy09SubidData:
	.db $88 $20
	.db $88 $20
	.db $8c $10
	.db $8c $10
	.db $3f $30
enemy0aSubidData:
	.db $8c $20
	.db $11 $10
enemy0bSubidData:
	.db $8c $27
	.db $8e $17
	.db $0c $37
enemy0cSubidData:
	.db $8c $20
	.db $91 $10
	.db $3f $30
enemy0dSubidData:
	.db $97 $20
	.db $9b $10
	.db $3f $30
enemy0eSubidData:
	.db $82 $20
	.db $82 $10
	.db $82 $30
	.db $82 $00
	.db $82 $00
	.db $02 $00
enemy17SubidData:
	.db $9a $2b
	.db $14 $2b
enemy20SubidData:
enemy4aSubidData:
	.db $8a $20
	.db $0c $10
enemy21SubidData:
enemy48SubidData:
	.db $94 $20
	.db $99 $10
	.db $3f $30
enemy2aSubidData:
	.db $b8 $08
	.db $b8 $18
	.db $b8 $28
	.db $38 $38
enemy30SubidData:
	.db $8a $3b
	.db $0c $1b
enemy31SubidData:
	.db $8a $12
	.db $8c $22
	.db $8e $32
	.db $0e $02
enemy34SubidData:
	.db $8a $00
	.db $0c $20
; Unused data?
	.db $80 $1b
	.db $00 $1b
enemy3dSubidData:
	.db $8d $20
	.db $12 $10
enemy40SubidData:
	.db $8e $00
	.db $91 $20
	.db $15 $10
enemy46SubidData:
	.db $c3 $0e
	.db $c3 $1e
	.db $c3 $2e
	.db $43 $3e
enemy70SubidData:
	.db $9c $10
	.db $1c $20
enemy7bSubidData:
	.db $80 $00
	.db $a7 $10
	.db $a8 $10
	.db $29 $10
enemy7cSubidData:
	.db $80 $60
	.db $bb $10
	.db $2b $60
enemy7dSubidData:
	.db $80 $00
	.db $ac $60
	.db $ad $60
	.db $2e $60


extraEnemyData:
	.db $00 $00 $00 $7f
	.db $06 $06 $00 $7f
	.db $04 $04 $fc $7f
	.db $06 $06 $fc $7f
	.db $04 $04 $f8 $7f
	.db $06 $06 $f8 $7f
	.db $02 $02 $fc $01
	.db $04 $06 $fc $01
	.db $06 $06 $fe $02
	.db $04 $06 $fc $02
	.db $06 $06 $fc $02
	.db $04 $06 $fc $03
	.db $06 $06 $fc $03
	.db $06 $06 $fa $03
	.db $06 $06 $fc $04
	.db $06 $06 $f8 $04
	.db $04 $04 $fc $05
	.db $06 $06 $fc $05
	.db $06 $06 $fa $05
	.db $06 $06 $f8 $05
	.db $06 $06 $fc $06
	.db $06 $06 $fc $07
	.db $06 $06 $fc $08
	.db $06 $06 $f8 $08
	.db $06 $06 $fa $09
	.db $06 $06 $f8 $09
	.db $06 $06 $fc $0a
	.db $06 $06 $f8 $0c
	.db $06 $06 $fc $10
	.db $06 $06 $00 $14
	.db $06 $06 $fc $08
	.db $09 $04 $fe $0e
	.db $06 $06 $fc $10
	.db $06 $06 $fe $12
	.db $06 $06 $fe $0c
	.db $0a $0a $f8 $0f
	.db $04 $04 $fc $14
	.db $0c $0c $fc $7f
	.db $09 $09 $fa $1a
	.db $06 $03 $fa $1e
	.db $06 $11 $fa $7f
	.db $06 $06 $fa $14
	.db $03 $03 $fc $02
	.db $0a $0a $fc $04
	.db $0c $06 $f8 $7f
	.db $04 $04 $fc $02
	.db $06 $06 $f8 $06
	.db $06 $03 $f8 $19
	.db $0a $0a $f8 $30
	.db $0c $0c $f8 $50
	.db $04 $03 $00 $30
	.db $06 $06 $fc $03
	.db $0e $07 $f8 $14
	.db $12 $12 $f4 $64
	.db $0c $0c $00 $05
	.db $03 $02 $00 $01
	.db $0d $0d $f8 $7f
	.db $06 $06 $fc $14
	.db $04 $04 $00 $01
	.db $08 $08 $fc $7f
	.db $0f $0c $f8 $7f
	.db $06 $06 $fc $01
	.db $07 $0c $fc $40
	.db $06 $06 $f8 $34
	.db $07 $07 $f8 $04
	.db $06 $06 $00 $20
	.db $04 $06 $f8 $06
	.db $02 $02 $fc $02
