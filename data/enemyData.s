.macro m_EnemyData
	.if NARGS == 4
		.db \1 \2 \3 \4
	.else
		.db \1 \2
		dwbe \3 | $8000
	.endif
.endm

; Data format:
; 0: npc gfx header to use
; 1: Value for ENEMY_COLLIDE_PROPERTIES
; 2/3: Either a pointer to subID-specific data, or 2 values which apply to all
; subIDs. See below for what those 2 bytes do.

; @addr{$fdd4b}
enemyData:
        m_EnemyData $00 $00 $00 $00
        m_EnemyData $db $08 $34 $00
        m_EnemyData $d7 $ea $30 $60
        m_EnemyData $33 $8a $33 $00
        m_EnemyData $16 $8b $35 $10
        m_EnemyData $cf $8c $02 $60
        m_EnemyData $d4 $8d $2f $10
        m_EnemyData $ce $8e $2b $60
        m_EnemyData $8f $0f $0c $2d
        m_EnemyData $8f $90 enemy09SubidData
        m_EnemyData $91 $91 enemy0aSubidData
        m_EnemyData $8f $10 enemy0bSubidData
        m_EnemyData $91 $91 enemy0cSubidData
        m_EnemyData $95 $92 enemy0dSubidData
        m_EnemyData $9e $93 enemy0eSubidData
        m_EnemyData $d3 $10 $0e $75
        m_EnemyData $9b $14 $0a $06
        m_EnemyData $c4 $95 $2d $39
        m_EnemyData $9b $96 $17 $20
        m_EnemyData $9b $97 $03 $0a
        m_EnemyData $8c $98 $0a $14
        m_EnemyData $9b $99 $01 $2b
        m_EnemyData $8c $00 $00 $18
        m_EnemyData $90 $9a enemy17SubidData
        m_EnemyData $93 $9b $0a $08
        m_EnemyData $9b $9c $03 $09
        m_EnemyData $94 $90 $0a $30
        m_EnemyData $94 $90 $0a $2c
        m_EnemyData $a0 $9d $0a $20
        m_EnemyData $92 $82 $40 $09
        m_EnemyData $94 $84 $0c $32
        m_EnemyData $da $9f $0e $68
        m_EnemyData $90 $91 enemy20SubidData
        m_EnemyData $98 $a0 enemy21SubidData
        m_EnemyData $9c $91 $0e $00
        m_EnemyData $8c $a1 $0c $30
        m_EnemyData $99 $22 $11 $36
        m_EnemyData $94 $a3 $0a $28
        m_EnemyData $a5 $a4 $02 $28
        m_EnemyData $8d $80 $3b $50
        m_EnemyData $a0 $25 $11 $2c
        m_EnemyData $a4 $04 $03 $20
        m_EnemyData $9e $a6 enemy2aSubidData
        m_EnemyData $00 $00 $00 $00
        m_EnemyData $a4 $94 $0a $33
        m_EnemyData $a4 $0f $11 $50
        m_EnemyData $a3 $a7 $03 $1d
        m_EnemyData $a3 $a8 $3c $40
        m_EnemyData $8f $91 enemy30SubidData
        m_EnemyData $9b $90 enemy31SubidData
        m_EnemyData $9d $9f $07 $00
        m_EnemyData $4c $00 $01 $37
        m_EnemyData $97 $29 enemy34SubidData
        m_EnemyData $a2 $25 $11 $10
        m_EnemyData $4c $aa $41 $20
        m_EnemyData $4a $00 $00 $14
        m_EnemyData $4b $00 $00 $20
        m_EnemyData $9d $ab $09 $50
        m_EnemyData $97 $94 $0c $05
        m_EnemyData $9a $ac $3e $20
        m_EnemyData $a1 $ad enemy3cSubidData
        m_EnemyData $91 $91 enemy3dSubidData
        m_EnemyData $97 $d8 $0c $23
        m_EnemyData $ad $af $44 $50
        m_EnemyData $9f $30 enemy40SubidData
        m_EnemyData $93 $31 $3d $30
        m_EnemyData $c3 $b2 $08 $2a
        m_EnemyData $97 $b3 $06 $20
        m_EnemyData $a5 $00 $00 $10
        m_EnemyData $92 $34 $11 $20
        m_EnemyData $00 $00 $00 $00
        m_EnemyData $97 $ee $06 $2e
        m_EnemyData $98 $a0 enemy48SubidData
        m_EnemyData $9c $91 $0e $00
        m_EnemyData $90 $b6 enemy4aSubidData
        m_EnemyData $99 $b7 $16 $20
        m_EnemyData $93 $31 $11 $14
        m_EnemyData $8c $b8 $0e $32
        m_EnemyData $a1 $b9 $13 $30
        m_EnemyData $97 $ba $16 $07
        m_EnemyData $00 $00 $00 $00
        m_EnemyData $9b $3b $07 $0d
        m_EnemyData $9c $3c $0a $5b
        m_EnemyData $4a $00 $00 $26
        m_EnemyData $4d $da $1a $00
        m_EnemyData $9c $be $17 $1d
        m_EnemyData $90 $00 $00 $30
        m_EnemyData $00 $3f $00 $00
        m_EnemyData $00 $c0 $0a $00
        m_EnemyData $00 $00 $00 $88
        m_EnemyData $00 $00 $01 $00
        m_EnemyData $00 $00 $00 $00
        m_EnemyData $00 $00 $00 $00
        m_EnemyData $de $8e $0a $16
        m_EnemyData $9d $c1 $42 $20
        m_EnemyData $8c $c2 $0e $62
        m_EnemyData $a7 $00 $00 $02
        m_EnemyData $d0 $43 $2e $60
        m_EnemyData $6b $90 $2c $09
        m_EnemyData $78 $82 $01 $46
        m_EnemyData $d5 $b9 $1b $66
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
        m_EnemyData $ad $c4 $1c $50
        m_EnemyData $af $c4 $1d $20
        m_EnemyData $b1 $c4 $1e $10
        m_EnemyData $b4 $c4 enemy73SubidData
        m_EnemyData $b7 $c5 $20 $30
        m_EnemyData $3c $46 $21 $20
        m_EnemyData $b8 $e4 $22 $10
        m_EnemyData $b9 $c8 $23 $10
        m_EnemyData $bc $c9 $24 $30
        m_EnemyData $bf $ca $25 $00
        m_EnemyData $c2 $4b $26 $30
        m_EnemyData $c4 $ed $27 $10
        m_EnemyData $c5 $cd $28 $30
        m_EnemyData $c8 $ce $29 $20
        m_EnemyData $cb $4f $2a $10
        m_EnemyData $a9 $d0 $36 $00

; Each 2 bytes are for a particular subID.
; 0: Bits 0-6 are an index for the extraEnemyData table below.
;    If bit 7 is set, the next subID is valid.
; 1: Determines palette, among other things?

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
; 0: value for ENEMY_COLLIDERADIUSY
; 1: value for ENEMY_COLLIDERADIUSX
; 2: value for ENEMY_DAMAGE (how much damage it deals)
; 3: value for ENEMY_HEALTH

; @addr{$fdfb9}
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
        .db $0a $0a $fe $0c
        .db $0a $0a $fc $14
        .db $06 $06 $fc $14
        .db $08 $0a $fc $0c
        .db $06 $06 $fc $05
        .db $06 $06 $fe $12
        .db $0c $0c $fc $1e
        .db $08 $08 $fa $12
        .db $06 $0c $fc $08
        .db $12 $0f $fc $04
        .db $09 $09 $fa $0c
        .db $06 $06 $f8 $14
        .db $0a $0a $fc $06
        .db $06 $06 $fa $14
        .db $0a $08 $fc $07
        .db $04 $0a $fc $04
        .db $06 $06 $00 $80
        .db $04 $04 $fe $04
        .db $08 $06 $f8 $80
        .db $0c $06 $f8 $27
        .db $08 $0a $f8 $18
        .db $0c $06 $fc $03
        .db $00 $00 $fc $7f
        .db $06 $06 $fc $03
        .db $0e $07 $f8 $14
        .db $12 $12 $f4 $64
        .db $0a $0c $00 $06
        .db $03 $02 $00 $01
        .db $0d $0d $f8 $7f
        .db $06 $06 $fc $14
        .db $04 $04 $00 $01
        .db $08 $08 $fc $7f
        .db $0f $0c $f8 $7f
        .db $06 $06 $fc $01
        .db $07 $0c $fc $02
        .db $06 $06 $f8 $34
        .db $07 $07 $f8 $04
        .db $06 $06 $00 $20
        .db $04 $06 $f8 $06
        .db $04 $02 $fc $01
        .db $02 $02 $00 $02
