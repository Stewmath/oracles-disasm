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
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $c2 $08 $34 $00
	m_EnemyData $bd $89 $31 $60
	m_EnemyData $24 $8a $33 $00
	m_EnemyData $16 $8b $35 $10
	m_EnemyData $c0 $0c $32 $60
	m_EnemyData $b8 $8d $2f $60
	m_EnemyData $91 $8e $36 $00
	m_EnemyData $74 $0f $0c $2d
	m_EnemyData $74 $90 enemy09SubidData
	m_EnemyData $76 $91 enemy0aSubidData
	m_EnemyData $74 $10 enemy0bSubidData
	m_EnemyData $76 $91 enemy0cSubidData
	m_EnemyData $7a $92 enemy0dSubidData
	m_EnemyData $85 $93 enemy0eSubidData
	m_EnemyData $88 $93 $03 $18
	m_EnemyData $82 $10 $0a $06
	m_EnemyData $77 $94 $11 $07
	m_EnemyData $82 $95 $17 $20
	m_EnemyData $82 $96 $03 $0a
	m_EnemyData $72 $97 $0a $14
	m_EnemyData $82 $98 $01 $2b
	m_EnemyData $72 $00 $00 $18
	m_EnemyData $75 $99 enemy17SubidData
	m_EnemyData $78 $9a $0a $08
	m_EnemyData $82 $9b $03 $09
	m_EnemyData $79 $90 $0a $30
	m_EnemyData $79 $90 $0a $2c
	m_EnemyData $87 $9c $0a $20
	m_EnemyData $77 $82 $40 $09
	m_EnemyData $79 $84 $0c $32
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $75 $91 enemy20SubidData
	m_EnemyData $7e $9f enemy21SubidData
	m_EnemyData $83 $a0 $0e $00
	m_EnemyData $72 $a1 $0c $30
	m_EnemyData $7f $22 $11 $36
	m_EnemyData $79 $a3 $0a $28
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $71 $80 $3b $50
	m_EnemyData $87 $24 $11 $2c
	m_EnemyData $8d $04 $03 $20
	m_EnemyData $85 $a5 enemy2aSubidData
	m_EnemyData $00 $84 $03 $a5
	m_EnemyData $8d $8f $0a $33
	m_EnemyData $8d $0f $11 $50
	m_EnemyData $8c $a6 $03 $1d
	m_EnemyData $8c $a7 $3c $40
	m_EnemyData $74 $91 enemy30SubidData
	m_EnemyData $82 $a8 enemy31SubidData
	m_EnemyData $84 $a9 $07 $00
	m_EnemyData $3f $00 $01 $37
	m_EnemyData $7d $2a enemy34SubidData
	m_EnemyData $89 $24 $11 $10
	m_EnemyData $3f $ab $41 $20
	m_EnemyData $3d $00 $00 $14
	m_EnemyData $3e $00 $00 $20
	m_EnemyData $84 $ac $09 $50
	m_EnemyData $7d $90 $0c $05
	m_EnemyData $81 $ad $3e $20
	m_EnemyData $8b $9e $0e $00
	m_EnemyData $76 $91 enemy3dSubidData
	m_EnemyData $7d $d5 $0c $23
	m_EnemyData $7b $00 $00 $50
	m_EnemyData $86 $2f enemy40SubidData
	m_EnemyData $78 $30 $3d $30
	m_EnemyData $79 $00 $00 $2c
	m_EnemyData $7d $b1 $06 $20
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $77 $32 $11 $20
	m_EnemyData $b1 $b3 enemy46SubidData
	m_EnemyData $af $29 $0a $30
	m_EnemyData $7e $9f enemy48SubidData
	m_EnemyData $83 $a0 $0e $00
	m_EnemyData $75 $b4 enemy4aSubidData
	m_EnemyData $7f $b5 $16 $20
	m_EnemyData $78 $30 $0c $14
	m_EnemyData $72 $b6 $0e $32
	m_EnemyData $88 $b7 $13 $30
	m_EnemyData $7d $b8 $16 $07
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $82 $39 $07 $0d
	m_EnemyData $83 $3a $0a $5b
	m_EnemyData $3d $02 $00 $26
	m_EnemyData $80 $bb $01 $10
	m_EnemyData $b5 $bc $16 $67
	m_EnemyData $05 $82 $3a $35
	m_EnemyData $7c $3d $39 $10
	m_EnemyData $00 $be $0a $00
	m_EnemyData $00 $00 $00 $88
	m_EnemyData $00 $01 $01 $00
	m_EnemyData $4f $00 $00 $68
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $c5 $c9 $0a $16
	m_EnemyData $84 $bf $42 $20
	m_EnemyData $80 $c0 $41 $58
	m_EnemyData $8f $00 $00 $02
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $00 $00 $00 $00
	m_EnemyData $95 $41 enemy70SubidData
	m_EnemyData $8a $0f $1d $10
	m_EnemyData $96 $42 $1e $10
	m_EnemyData $98 $43 $1f $20
	m_EnemyData $9b $c4 $20 $30
	m_EnemyData $30 $45 $21 $20
	m_EnemyData $9e $46 $22 $20
	m_EnemyData $a0 $47 $23 $20
	m_EnemyData $a3 $c8 $24 $00
	m_EnemyData $a8 $c9 $25 $60
	m_EnemyData $ad $ca $26 $60
	m_EnemyData $b0 $cb enemy7bSubidData
	m_EnemyData $b3 $8a enemy7cSubidData
	m_EnemyData $b6 $e1 enemy7dSubidData
	m_EnemyData $9e $46 $22 $30
	m_EnemyData $ba $4d $30 $00

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
