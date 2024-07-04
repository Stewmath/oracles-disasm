; Data format:
;   b0: object gfx header to use (see data/objectGfxHeaders.s)
;   b1: Value for Enemy.enemyCollisionMode (bit 7 must be set for collisions to work)
;   b2: value for Enemy.damage (how much damage it deals)
;   b3: value for Enemy.health
;
;   Or, parameters 2/3 can be replaced with a pointer to subid data (see below).

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
	m_EnemySubidData $08 $20
	m_EnemySubidData $08 $20
	m_EnemySubidData $0c $10
	m_EnemySubidData $0c $10
	m_EnemySubidData $3f $30
	m_EnemySubidDataEnd

enemy0aSubidData:
	m_EnemySubidData $0c $20
	m_EnemySubidData $11 $10
	m_EnemySubidDataEnd

enemy0bSubidData:
	m_EnemySubidData $0c $27
	m_EnemySubidData $0e $17
	m_EnemySubidData $0c $37
	m_EnemySubidDataEnd

enemy0cSubidData:
	m_EnemySubidData $0c $20
	m_EnemySubidData $11 $10
	m_EnemySubidData $3f $30
	m_EnemySubidDataEnd

enemy0dSubidData:
	m_EnemySubidData $17 $20
	m_EnemySubidData $1b $10
	m_EnemySubidData $3f $30
	m_EnemySubidDataEnd

enemy0eSubidData:
	m_EnemySubidData $02 $20
	m_EnemySubidData $02 $10
	m_EnemySubidData $02 $30
	m_EnemySubidData $02 $00
	m_EnemySubidData $02 $00
	m_EnemySubidData $02 $00
	m_EnemySubidDataEnd

enemy17SubidData:
	m_EnemySubidData $1a $2b
	m_EnemySubidData $14 $2b
	m_EnemySubidDataEnd

enemy20SubidData:
enemy4aSubidData:
	m_EnemySubidData $0a $20
	m_EnemySubidData $0c $10
	m_EnemySubidDataEnd

enemy21SubidData:
enemy48SubidData:
	m_EnemySubidData $14 $20
	m_EnemySubidData $19 $10
	m_EnemySubidData $3f $30
	m_EnemySubidDataEnd

enemy2aSubidData:
	m_EnemySubidData $38 $08
	m_EnemySubidData $38 $18
	m_EnemySubidData $38 $28
	m_EnemySubidData $38 $38
	m_EnemySubidDataEnd

enemy30SubidData:
	m_EnemySubidData $0a $3b
	m_EnemySubidData $0c $1b
	m_EnemySubidDataEnd

enemy31SubidData:
	m_EnemySubidData $0a $12
	m_EnemySubidData $0c $22
	m_EnemySubidData $0e $32
	m_EnemySubidData $0e $02
	m_EnemySubidDataEnd

enemy34SubidData:
	m_EnemySubidData $0a $00
	m_EnemySubidData $0c $20
	m_EnemySubidDataEnd

; Unused data?
	m_EnemySubidData $00 $1b
	m_EnemySubidData $00 $1b
	m_EnemySubidDataEnd

enemy3dSubidData:
	m_EnemySubidData $0d $20
	m_EnemySubidData $12 $10
	m_EnemySubidDataEnd

enemy40SubidData:
	m_EnemySubidData $0e $00
	m_EnemySubidData $11 $20
	m_EnemySubidData $15 $10
	m_EnemySubidDataEnd

enemy46SubidData:
	m_EnemySubidData $43 $0e
	m_EnemySubidData $43 $1e
	m_EnemySubidData $43 $2e
	m_EnemySubidData $43 $3e
	m_EnemySubidDataEnd

enemy70SubidData:
	m_EnemySubidData $1c $10
	m_EnemySubidData $1c $20
	m_EnemySubidDataEnd

enemy7bSubidData:
	m_EnemySubidData $00 $00
	m_EnemySubidData $27 $10
	m_EnemySubidData $28 $10
	m_EnemySubidData $29 $10
	m_EnemySubidDataEnd

enemy7cSubidData:
	m_EnemySubidData $00 $60
	m_EnemySubidData $3b $10
	m_EnemySubidData $2b $60
	m_EnemySubidDataEnd

enemy7dSubidData:
	m_EnemySubidData $00 $00
	m_EnemySubidData $2c $60
	m_EnemySubidData $2d $60
	m_EnemySubidData $2e $60
	m_EnemySubidDataEnd


; Data format:
;   b0: value for Enemy.collisionRadiusY
;   b1: value for Enemy.collisionRadiusX
;   b2: value for Enemy.damage (how much damage it deals)
;   b3: value for Enemy.health

extraEnemyData:
	.db $00 $00 $00 $7f ; 0x00
	.db $06 $06 $00 $7f ; 0x01
	.db $04 $04 $fc $7f ; 0x02
	.db $06 $06 $fc $7f ; 0x03
	.db $04 $04 $f8 $7f ; 0x04
	.db $06 $06 $f8 $7f ; 0x05
	.db $02 $02 $fc $01 ; 0x06
	.db $04 $06 $fc $01 ; 0x07
	.db $06 $06 $fe $02 ; 0x08
	.db $04 $06 $fc $02 ; 0x09
	.db $06 $06 $fc $02 ; 0x0a
	.db $04 $06 $fc $03 ; 0x0b
	.db $06 $06 $fc $03 ; 0x0c
	.db $06 $06 $fa $03 ; 0x0d
	.db $06 $06 $fc $04 ; 0x0e
	.db $06 $06 $f8 $04 ; 0x0f
	.db $04 $04 $fc $05 ; 0x10
	.db $06 $06 $fc $05 ; 0x11
	.db $06 $06 $fa $05 ; 0x12
	.db $06 $06 $f8 $05 ; 0x13
	.db $06 $06 $fc $06 ; 0x14
	.db $06 $06 $fc $07 ; 0x15
	.db $06 $06 $fc $08 ; 0x16
	.db $06 $06 $f8 $08 ; 0x17
	.db $06 $06 $fa $09 ; 0x18
	.db $06 $06 $f8 $09 ; 0x19
	.db $06 $06 $fc $0a ; 0x1a
	.db $06 $06 $f8 $0c ; 0x1b
	.db $06 $06 $fc $10 ; 0x1c
	.db $06 $06 $00 $14 ; 0x1d
	.db $06 $06 $fc $08 ; 0x1e
	.db $09 $04 $fe $0e ; 0x1f
	.db $06 $06 $fc $10 ; 0x20
	.db $06 $06 $fe $12 ; 0x21
	.db $06 $06 $fe $0c ; 0x22
	.db $0a $0a $f8 $0f ; 0x23
	.db $04 $04 $fc $14 ; 0x24
	.db $0c $0c $fc $7f ; 0x25
	.db $09 $09 $fa $1a ; 0x26
	.db $06 $03 $fa $1e ; 0x27
	.db $06 $11 $fa $7f ; 0x28
	.db $06 $06 $fa $14 ; 0x29
	.db $03 $03 $fc $02 ; 0x2a
	.db $0a $0a $fc $04 ; 0x2b
	.db $0c $06 $f8 $7f ; 0x2c
	.db $04 $04 $fc $02 ; 0x2d
	.db $06 $06 $f8 $06 ; 0x2e
	.db $06 $03 $f8 $19 ; 0x2f
	.db $0a $0a $f8 $30 ; 0x30
	.db $0c $0c $f8 $50 ; 0x31
	.db $04 $03 $00 $30 ; 0x32
	.db $06 $06 $fc $03 ; 0x33
	.db $0e $07 $f8 $14 ; 0x34
	.db $12 $12 $f4 $64 ; 0x35
	.db $0c $0c $00 $05 ; 0x36
	.db $03 $02 $00 $01 ; 0x37
	.db $0d $0d $f8 $7f ; 0x38
	.db $06 $06 $fc $14 ; 0x39
	.db $04 $04 $00 $01 ; 0x3a
	.db $08 $08 $fc $7f ; 0x3b
	.db $0f $0c $f8 $7f ; 0x3c
	.db $06 $06 $fc $01 ; 0x3d
	.db $07 $0c $fc $40 ; 0x3e
	.db $06 $06 $f8 $34 ; 0x3f
	.db $07 $07 $f8 $04 ; 0x40
	.db $06 $06 $00 $20 ; 0x41
	.db $04 $06 $f8 $06 ; 0x42
	.db $02 $02 $fc $02 ; 0x43
