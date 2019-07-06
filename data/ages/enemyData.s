.macro m_EnemyData
	.if NARGS == 4
		.db \1 \2 \3 \4
	.else
		.db \1 \2
		dwbe \3 | $8000
	.endif
.endm

; Data format:
; 0: object gfx header to use (see data/objectGfxHeaders.s)
; 1: Value for Enemy.enemyCollisionMode (bit 7 must be set for collisions to work)
; 2/3: Either a pointer to subID-specific data, or 2 values which apply to all
; subIDs. See below for what those 2 bytes do.

enemyData:
	/* 0x00 */ m_EnemyData $00 $00 $00 $00
	/* 0x01 */ m_EnemyData $db $08 $34 $00
	/* 0x02 */ m_EnemyData $d7 $ea $30 $60
	/* 0x03 */ m_EnemyData $33 $8a $33 $00
	/* 0x04 */ m_EnemyData $16 $8b $35 $10
	/* 0x05 */ m_EnemyData $cf $8c $02 $60
	/* 0x06 */ m_EnemyData $d4 $8d $2f $10
	/* 0x07 */ m_EnemyData $ce $8e $2b $60
	/* 0x08 */ m_EnemyData $8f $0f $0c $2d
	/* 0x09 */ m_EnemyData $8f $90 enemy09SubidData
	/* 0x0a */ m_EnemyData $91 $91 enemy0aSubidData
	/* 0x0b */ m_EnemyData $8f $10 enemy0bSubidData
	/* 0x0c */ m_EnemyData $91 $91 enemy0cSubidData
	/* 0x0d */ m_EnemyData $95 $92 enemy0dSubidData
	/* 0x0e */ m_EnemyData $9e $93 enemy0eSubidData
	/* 0x0f */ m_EnemyData $d3 $10 $0e $75
	/* 0x10 */ m_EnemyData $9b $14 $0a $06
	/* 0x11 */ m_EnemyData $c4 $95 $2d $39
	/* 0x12 */ m_EnemyData $9b $96 $17 $20
	/* 0x13 */ m_EnemyData $9b $97 $03 $0a
	/* 0x14 */ m_EnemyData $8c $98 $0a $14
	/* 0x15 */ m_EnemyData $9b $99 $01 $2b
	/* 0x16 */ m_EnemyData $8c $00 $00 $18
	/* 0x17 */ m_EnemyData $90 $9a enemy17SubidData
	/* 0x18 */ m_EnemyData $93 $9b $0a $08
	/* 0x19 */ m_EnemyData $9b $9c $03 $09
	/* 0x1a */ m_EnemyData $94 $90 $0a $30
	/* 0x1b */ m_EnemyData $94 $90 $0a $2c
	/* 0x1c */ m_EnemyData $a0 $9d $0a $20
	/* 0x1d */ m_EnemyData $92 $82 $40 $09
	/* 0x1e */ m_EnemyData $94 $84 $0c $32
	/* 0x1f */ m_EnemyData $da $9f $0e $68
	/* 0x20 */ m_EnemyData $90 $91 enemy20SubidData
	/* 0x21 */ m_EnemyData $98 $a0 enemy21SubidData
	/* 0x22 */ m_EnemyData $9c $91 $0e $00
	/* 0x23 */ m_EnemyData $8c $a1 $0c $30
	/* 0x24 */ m_EnemyData $99 $22 $11 $36
	/* 0x25 */ m_EnemyData $94 $a3 $0a $28
	/* 0x26 */ m_EnemyData $a5 $a4 $02 $28
	/* 0x27 */ m_EnemyData $8d $80 $3b $50
	/* 0x28 */ m_EnemyData $a0 $25 $11 $2c
	/* 0x29 */ m_EnemyData $a4 $04 $03 $20
	/* 0x2a */ m_EnemyData $9e $a6 enemy2aSubidData
	/* 0x2b */ m_EnemyData $00 $00 $00 $00
	/* 0x2c */ m_EnemyData $a4 $94 $0a $33
	/* 0x2d */ m_EnemyData $a4 $0f $11 $50
	/* 0x2e */ m_EnemyData $a3 $a7 $03 $1d
	/* 0x2f */ m_EnemyData $a3 $a8 $3c $40
	/* 0x30 */ m_EnemyData $8f $91 enemy30SubidData
	/* 0x31 */ m_EnemyData $9b $90 enemy31SubidData
	/* 0x32 */ m_EnemyData $9d $9f $07 $00
	/* 0x33 */ m_EnemyData $4c $00 $01 $37
	/* 0x34 */ m_EnemyData $97 $29 enemy34SubidData
	/* 0x35 */ m_EnemyData $a2 $25 $11 $10
	/* 0x36 */ m_EnemyData $4c $aa $41 $20
	/* 0x37 */ m_EnemyData $4a $00 $00 $14
	/* 0x38 */ m_EnemyData $4b $00 $00 $20
	/* 0x39 */ m_EnemyData $9d $ab $09 $50
	/* 0x3a */ m_EnemyData $97 $94 $0c $05
	/* 0x3b */ m_EnemyData $9a $ac $3e $20
	/* 0x3c */ m_EnemyData $a1 $ad enemy3cSubidData
	/* 0x3d */ m_EnemyData $91 $91 enemy3dSubidData
	/* 0x3e */ m_EnemyData $97 $d8 $0c $23
	/* 0x3f */ m_EnemyData $ad $af $44 $50
	/* 0x40 */ m_EnemyData $9f $30 enemy40SubidData
	/* 0x41 */ m_EnemyData $93 $31 $3d $30
	/* 0x42 */ m_EnemyData $c3 $b2 $08 $2a
	/* 0x43 */ m_EnemyData $97 $b3 $06 $20
	/* 0x44 */ m_EnemyData $a5 $00 $00 $10
	/* 0x45 */ m_EnemyData $92 $34 $11 $20
	/* 0x46 */ m_EnemyData $00 $00 $00 $00
	/* 0x47 */ m_EnemyData $97 $ee $06 $2e
	/* 0x48 */ m_EnemyData $98 $a0 enemy48SubidData
	/* 0x49 */ m_EnemyData $9c $91 $0e $00
	/* 0x4a */ m_EnemyData $90 $b6 enemy4aSubidData
	/* 0x4b */ m_EnemyData $99 $b7 $16 $20
	/* 0x4c */ m_EnemyData $93 $31 $11 $14
	/* 0x4d */ m_EnemyData $8c $b8 $0e $32
	/* 0x4e */ m_EnemyData $a1 $b9 $13 $30
	/* 0x4f */ m_EnemyData $97 $ba $16 $07
	/* 0x50 */ m_EnemyData $00 $00 $00 $00
	/* 0x51 */ m_EnemyData $9b $3b $07 $0d
	/* 0x52 */ m_EnemyData $9c $3c $0a $5b
	/* 0x53 */ m_EnemyData $4a $00 $00 $26
	/* 0x54 */ m_EnemyData $4d $da $1a $00
	/* 0x55 */ m_EnemyData $9c $be $17 $1d
	/* 0x56 */ m_EnemyData $90 $00 $00 $30
	/* 0x57 */ m_EnemyData $00 $3f $00 $00
	/* 0x58 */ m_EnemyData $00 $c0 $0a $00
	/* 0x59 */ m_EnemyData $00 $00 $00 $88
	/* 0x5a */ m_EnemyData $00 $00 $01 $00
	/* 0x5b */ m_EnemyData $00 $00 $00 $00
	/* 0x5c */ m_EnemyData $00 $00 $00 $00
	/* 0x5d */ m_EnemyData $de $8e $0a $16
	/* 0x5e */ m_EnemyData $9d $c1 $42 $20
	/* 0x5f */ m_EnemyData $8c $c2 $0e $62
	/* 0x60 */ m_EnemyData $a7 $00 $00 $02
	/* 0x61 */ m_EnemyData $d0 $43 $2e $60
	/* 0x62 */ m_EnemyData $6b $90 $2c $09
	/* 0x63 */ m_EnemyData $78 $82 $01 $46
	/* 0x64 */ m_EnemyData $d5 $b9 $1b $66
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
	/* 0x70 */ m_EnemyData $ad $c4 $1c $50
	/* 0x71 */ m_EnemyData $af $c4 $1d $20
	/* 0x72 */ m_EnemyData $b1 $c4 $1e $10
	/* 0x73 */ m_EnemyData $b4 $c4 enemy73SubidData
	/* 0x74 */ m_EnemyData $b7 $c5 $20 $30
	/* 0x75 */ m_EnemyData $3c $46 $21 $20
	/* 0x76 */ m_EnemyData $b8 $e4 $22 $10
	/* 0x77 */ m_EnemyData $b9 $c8 $23 $10
	/* 0x78 */ m_EnemyData $bc $c9 $24 $30
	/* 0x79 */ m_EnemyData $bf $ca $25 $00
	/* 0x7a */ m_EnemyData $c2 $4b $26 $30
	/* 0x7b */ m_EnemyData $c4 $ed $27 $10
	/* 0x7c */ m_EnemyData $c5 $cd $28 $30
	/* 0x7d */ m_EnemyData $c8 $ce $29 $20
	/* 0x7e */ m_EnemyData $cb $4f $2a $10
	/* 0x7f */ m_EnemyData $a9 $d0 $36 $00

; Each 2 bytes are for a particular subID.
; 0: Bits 0-6 are an index for the extraEnemyData table below.
;    If bit 7 is set, the next subID is valid.
; 1: bits 4-7: palette + bank bit
;    bits 0-3: oamTileIndexBase/2

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
	.db $94 $2b
	.db $16 $2b
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
enemy3cSubidData:
	.db $8e $1c
	.db $43 $1c
enemy3dSubidData:
	.db $8d $20
	.db $12 $10
enemy40SubidData:
	.db $8e $00
	.db $91 $20
	.db $15 $10
enemy73SubidData:
	.db $9a $10
	.db $9a $10
	.db $b1 $20
	.db $32 $30

; Data format:
; 0: value for Enemy.collisionRadiusY
; 1: value for Enemy.collisionRadiusX
; 2: value for Enemy.damage (how much damage it deals)
; 3: value for Enemy.health

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
	.db $0a $0a $fe $0c ; 0x1c
	.db $0a $0a $fc $14 ; 0x1d
	.db $06 $06 $fc $14 ; 0x1e
	.db $08 $0a $fc $0c ; 0x1f
	.db $06 $06 $fc $05 ; 0x20
	.db $06 $06 $fe $12 ; 0x21
	.db $0c $0c $fc $1e ; 0x22
	.db $08 $08 $fa $12 ; 0x23
	.db $06 $0c $fc $08 ; 0x24
	.db $12 $0f $fc $04 ; 0x25
	.db $09 $09 $fa $0c ; 0x26
	.db $06 $06 $f8 $14 ; 0x27
	.db $0a $0a $fc $06 ; 0x28
	.db $06 $06 $fa $14 ; 0x29
	.db $0a $08 $fc $07 ; 0x2a
	.db $04 $0a $fc $04 ; 0x2b
	.db $06 $06 $00 $80 ; 0x2c
	.db $04 $04 $fe $04 ; 0x2d
	.db $08 $06 $f8 $80 ; 0x2e
	.db $0c $06 $f8 $27 ; 0x2f
	.db $08 $0a $f8 $18 ; 0x30
	.db $0c $06 $fc $03 ; 0x31
	.db $00 $00 $fc $7f ; 0x32
	.db $06 $06 $fc $03 ; 0x33
	.db $0e $07 $f8 $14 ; 0x34
	.db $12 $12 $f4 $64 ; 0x35
	.db $0a $0c $00 $06 ; 0x36
	.db $03 $02 $00 $01 ; 0x37
	.db $0d $0d $f8 $7f ; 0x38
	.db $06 $06 $fc $14 ; 0x39
	.db $04 $04 $00 $01 ; 0x3a
	.db $08 $08 $fc $7f ; 0x3b
	.db $0f $0c $f8 $7f ; 0x3c
	.db $06 $06 $fc $01 ; 0x3d
	.db $07 $0c $fc $02 ; 0x3e
	.db $06 $06 $f8 $34 ; 0x3f
	.db $07 $07 $f8 $04 ; 0x40
	.db $06 $06 $00 $20 ; 0x41
	.db $04 $06 $f8 $06 ; 0x42
	.db $04 $02 $fc $01 ; 0x43
	.db $02 $02 $00 $02 ; 0x44
