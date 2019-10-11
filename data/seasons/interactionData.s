; See notes in data/ages/interactionData.s.

.macro m_InteractionData
	.if NARGS == 3
		.db \1 \2 \3
	.else
		.db \1&$ff $80 \1>>8
	.endif
.endm


interactionData:
	/* $00 */ m_InteractionData $00 $00 $80
	/* $01 */ m_InteractionData $00 $00 $80
	/* $02 */ m_InteractionData $00 $10 $80
	/* $03 */ m_InteractionData $00 $04 $90
	/* $04 */ m_InteractionData $00 $26 $a0
	/* $05 */ m_InteractionData $00 $16 $b0
	/* $06 */ m_InteractionData $00 $02 $b0
	/* $07 */ m_InteractionData $00 $10 $90
	/* $08 */ m_InteractionData $00 $10 $b0
	/* $09 */ m_InteractionData $00 $1e $90
	/* $0a */ m_InteractionData $00 $42 $b0
	/* $0b */ m_InteractionData interaction0bSubidData
	/* $0c */ m_InteractionData $00 $40 $d0
	/* $0d */ m_InteractionData $00 $16 $b0
	/* $0e */ m_InteractionData $00 $16 $b0
	/* $0f */ m_InteractionData $00 $16 $b0
	/* $10 */ m_InteractionData $4b $00 $02
	/* $11 */ m_InteractionData $50 $0a $13
	/* $12 */ m_InteractionData $57 $0a $20
	/* $13 */ m_InteractionData $00 $00 $e0
	/* $14 */ m_InteractionData $00 $00 $e0
	/* $15 */ m_InteractionData $00 $00 $00
	/* $16 */ m_InteractionData $57 $00 $40
	/* $17 */ m_InteractionData interaction17SubidData
	/* $18 */ m_InteractionData interaction18SubidData
	/* $19 */ m_InteractionData $00 $00 $00
	/* $1a */ m_InteractionData $00 $00 $00
	/* $1b */ m_InteractionData $00 $00 $80
	/* $1c */ m_InteractionData $51 $1a $00
	/* $1d */ m_InteractionData $00 $00 $00
	/* $1e */ m_InteractionData $00 $00 $00
	/* $1f */ m_InteractionData $00 $00 $00
	/* $20 */ m_InteractionData $00 $00 $00
	/* $21 */ m_InteractionData $00 $00 $00
	/* $22 */ m_InteractionData $00 $00 $00
	/* $23 */ m_InteractionData $00 $00 $00
	/* $24 */ m_InteractionData $34 $00 $14
	/* $25 */ m_InteractionData $36 $10 $20
	/* $26 */ m_InteractionData $36 $00 $10
	/* $27 */ m_InteractionData $32 $00 $00
	/* $28 */ m_InteractionData $39 $00 $00
	/* $29 */ m_InteractionData $37 $00 $24
	/* $2a */ m_InteractionData interaction2aSubidData
	/* $2b */ m_InteractionData $3a $00 $00
	/* $2c */ m_InteractionData $40 $00 $04
	/* $2d */ m_InteractionData $37 $16 $24
	/* $2e */ m_InteractionData $45 $1c $20
	/* $2f */ m_InteractionData $36 $1c $24
	/* $30 */ m_InteractionData $07 $00 $02
	/* $31 */ m_InteractionData $07 $00 $02
	/* $32 */ m_InteractionData $07 $00 $02
	/* $33 */ m_InteractionData $08 $00 $04
	/* $34 */ m_InteractionData interaction34SubidData
	/* $35 */ m_InteractionData interaction35SubidData
	/* $36 */ m_InteractionData $3f $16 $24
	/* $37 */ m_InteractionData $35 $1c $04
	/* $38 */ m_InteractionData $34 $10 $04
	/* $39 */ m_InteractionData $35 $00 $24
	/* $3a */ m_InteractionData $00 $00 $00
	/* $3b */ m_InteractionData interaction3bSubidData
	/* $3c */ m_InteractionData $35 $10 $04
	/* $3d */ m_InteractionData $3e $10 $04
	/* $3e */ m_InteractionData interaction3eSubidData
	/* $3f */ m_InteractionData $40 $0a $34
	/* $40 */ m_InteractionData $47 $0a $10
	/* $41 */ m_InteractionData $47 $00 $10
	/* $42 */ m_InteractionData $07 $00 $00
	/* $43 */ m_InteractionData $41 $00 $00
	/* $44 */ m_InteractionData interaction44SubidData
	/* $45 */ m_InteractionData $45 $00 $20
	/* $46 */ m_InteractionData $33 $00 $11
	/* $47 */ m_InteractionData interaction47SubidData
	/* $48 */ m_InteractionData $51 $16 $00
	/* $49 */ m_InteractionData $3f $00 $20
	/* $4a */ m_InteractionData interaction4aSubidData
	/* $4b */ m_InteractionData interaction4bSubidData
	/* $4c */ m_InteractionData interaction4cSubidData
	/* $4d */ m_InteractionData $47 $1c $21
	/* $4e */ m_InteractionData interaction4eSubidData
	/* $4f */ m_InteractionData interaction4fSubidData
	/* $50 */ m_InteractionData interaction50SubidData
	/* $51 */ m_InteractionData $00 $00 $00
	/* $52 */ m_InteractionData $4f $00 $60
	/* $53 */ m_InteractionData $07 $00 $12
	/* $54 */ m_InteractionData interaction54SubidData
	/* $55 */ m_InteractionData $07 $00 $11
	/* $56 */ m_InteractionData $00 $0c $a0
	/* $57 */ m_InteractionData $44 $00 $00
	/* $58 */ m_InteractionData $42 $00 $00
	/* $59 */ m_InteractionData interaction59SubidData
	/* $5a */ m_InteractionData $00 $00 $00
	/* $5b */ m_InteractionData $33 $12 $00
	/* $5c */ m_InteractionData $07 $00 $00
	/* $5d */ m_InteractionData interaction5dSubidData
	/* $5e */ m_InteractionData $00 $00 $80
	/* $5f */ m_InteractionData $00 $00 $00
	/* $60 */ m_InteractionData interaction60SubidData
	/* $61 */ m_InteractionData $00 $00 $00
	/* $62 */ m_InteractionData $00 $00 $00
	/* $63 */ m_InteractionData $00 $00 $00
	/* $64 */ m_InteractionData $57 $0a $20
	/* $65 */ m_InteractionData $00 $00 $00
	/* $66 */ m_InteractionData $00 $00 $e0
	/* $67 */ m_InteractionData $77 $12 $10
	/* $68 */ m_InteractionData $5b $0a $40
	/* $69 */ m_InteractionData interaction69SubidData
	/* $6a */ m_InteractionData interaction6aSubidData
	/* $6b */ m_InteractionData interaction6bSubidData
	/* $6c */ m_InteractionData $07 $00 $00
	/* $6d */ m_InteractionData $07 $00 $00
	/* $6e */ m_InteractionData $60 $0c $40
	/* $6f */ m_InteractionData $66 $0a $01
	/* $70 */ m_InteractionData $11 $00 $00
	/* $71 */ m_InteractionData interaction71SubidData
	/* $72 */ m_InteractionData $80 $00 $12
	/* $73 */ m_InteractionData interaction73SubidData
	/* $74 */ m_InteractionData interaction74SubidData
	/* $75 */ m_InteractionData interaction75SubidData
	/* $76 */ m_InteractionData interaction76SubidData
	/* $77 */ m_InteractionData $00 $00 $00
	/* $78 */ m_InteractionData $00 $00 $00
	/* $79 */ m_InteractionData interaction79SubidData
	/* $7a */ m_InteractionData interaction7aSubidData
	/* $7b */ m_InteractionData $59 $10 $40
	/* $7c */ m_InteractionData interaction7cSubidData
	/* $7d */ m_InteractionData interaction7dSubidData
	/* $7e */ m_InteractionData $00 $16 $a0
	/* $7f */ m_InteractionData interaction7fSubidData
	/* $80 */ m_InteractionData $37 $1a $00
	/* $81 */ m_InteractionData interaction81SubidData
	/* $82 */ m_InteractionData $3f $08 $30
	/* $83 */ m_InteractionData $38 $06 $20
	/* $84 */ m_InteractionData interaction84SubidData
	/* $85 */ m_InteractionData $00 $00 $00
	/* $86 */ m_InteractionData $00 $16 $b0
	/* $87 */ m_InteractionData $04 $00 $00
	/* $88 */ m_InteractionData $52 $00 $00
	/* $89 */ m_InteractionData $43 $00 $00
	/* $8a */ m_InteractionData $37 $16 $14
	/* $8b */ m_InteractionData $3d $04 $34
	/* $8c */ m_InteractionData $4d $00 $11
	/* $8d */ m_InteractionData $32 $16 $10
	/* $8e */ m_InteractionData interaction8eSubidData
	/* $8f */ m_InteractionData $34 $10 $00
	/* $90 */ m_InteractionData $00 $00 $00
	/* $91 */ m_InteractionData $00 $16 $90
	/* $92 */ m_InteractionData interaction92SubidData
	/* $93 */ m_InteractionData $66 $12 $00
	/* $94 */ m_InteractionData $63 $04 $32
	/* $95 */ m_InteractionData interaction95SubidData
	/* $96 */ m_InteractionData $75 $00 $10
	/* $97 */ m_InteractionData $0c $04 $10
	/* $98 */ m_InteractionData $56 $00 $30
	/* $99 */ m_InteractionData $34 $10 $02
	/* $9a */ m_InteractionData interaction9aSubidData
	/* $9b */ m_InteractionData $00 $00 $00
	/* $9c */ m_InteractionData $51 $00 $01
	/* $9d */ m_InteractionData $0f $00 $22
	/* $9e */ m_InteractionData $00 $00 $00
	/* $9f */ m_InteractionData interaction9fSubidData
	/* $a0 */ m_InteractionData interactiona0SubidData
	/* $a1 */ m_InteractionData interactiona1SubidData
	/* $a2 */ m_InteractionData interactiona2SubidData
	/* $a3 */ m_InteractionData $57 $0e $10
	/* $a4 */ m_InteractionData $07 $00 $00
	/* $a5 */ m_InteractionData interactiona5SubidData
	/* $a6 */ m_InteractionData $15 $18 $40
	/* $a7 */ m_InteractionData interactiona7SubidData
	/* $a8 */ m_InteractionData $00 $00 $00
	/* $a9 */ m_InteractionData interactiona9SubidData
	/* $aa */ m_InteractionData interactionaaSubidData
	/* $ab */ m_InteractionData $00 $00 $00
	/* $ac */ m_InteractionData $00 $00 $00
	/* $ad */ m_InteractionData interactionadSubidData
	/* $ae */ m_InteractionData $00 $00 $00
	/* $af */ m_InteractionData $00 $00 $00
	/* $b0 */ m_InteractionData interactionb0SubidData
	/* $b1 */ m_InteractionData $47 $0a $12
	/* $b2 */ m_InteractionData $47 $00 $10
	/* $b3 */ m_InteractionData $00 $00 $00
	/* $b4 */ m_InteractionData $28 $00 $00
	/* $b5 */ m_InteractionData $00 $00 $80
	/* $b6 */ m_InteractionData interactionb6SubidData
	/* $b7 */ m_InteractionData interactionb7SubidData
	/* $b8 */ m_InteractionData $49 $00 $10
	/* $b9 */ m_InteractionData interactionb9SubidData
	/* $ba */ m_InteractionData $0f $00 $20
	/* $bb */ m_InteractionData $31 $10 $00
	/* $bc */ m_InteractionData $31 $00 $00
	/* $bd */ m_InteractionData $34 $00 $10
	/* $be */ m_InteractionData $34 $10 $00
	/* $bf */ m_InteractionData $2d $00 $00
	/* $c0 */ m_InteractionData $65 $10 $32
	/* $c1 */ m_InteractionData $50 $0a $10
	/* $c2 */ m_InteractionData $37 $16 $34
	/* $c3 */ m_InteractionData $00 $00 $80
	/* $c4 */ m_InteractionData $00 $00 $80
	/* $c5 */ m_InteractionData $00 $00 $80
	/* $c6 */ m_InteractionData $60 $00 $00
	/* $c7 */ m_InteractionData $00 $00 $80
	/* $c8 */ m_InteractionData $07 $00 $13
	/* $c9 */ m_InteractionData $67 $00 $50
	/* $ca */ m_InteractionData $34 $10 $00
	/* $cb */ m_InteractionData $75 $16 $00
	/* $cc */ m_InteractionData $07 $00 $32
	/* $cd */ m_InteractionData $32 $16 $10
	/* $ce */ m_InteractionData $71 $00 $50
	/* $cf */ m_InteractionData interactioncfSubidData
	/* $d0 */ m_InteractionData $00 $00 $80
	/* $d1 */ m_InteractionData $00 $00 $80
	/* $d2 */ m_InteractionData interactiond2SubidData
	/* $d3 */ m_InteractionData $68 $1a $30
	/* $d4 */ m_InteractionData interactiond4SubidData
	/* $d5 */ m_InteractionData $3e $00 $30
	/* $d6 */ m_InteractionData $33 $12 $00
	/* $d7 */ m_InteractionData $00 $00 $80
	/* $d8 */ m_InteractionData $3d $00 $24
	/* $d9 */ m_InteractionData $00 $00 $80
	/* $da */ m_InteractionData $00 $00 $80
	/* $db */ m_InteractionData interactiondbSubidData
	/* $dc */ m_InteractionData $00 $00 $80
	/* $dd */ m_InteractionData $34 $10 $32
	/* $de */ m_InteractionData interactiondeSubidData
	/* $df */ m_InteractionData interactiondfSubidData
	/* $e0 */ m_InteractionData interactione0SubidData
	/* $e1 */ m_InteractionData interactione1SubidData
	/* $e2 */ m_InteractionData $72 $1e $04
	/* $e3 */ m_InteractionData $30 $00 $20
	/* $e4 */ m_InteractionData $34 $10 $12
	/* $e5 */ m_InteractionData $51 $1a $11
	/* $e6 */ m_InteractionData interactione6SubidData
	/* $e7 */ m_InteractionData $4c $00 $10

interaction54SubidData:
interaction60SubidData:
	.db $5c $04 $00
	.db $5c $06 $40
	.db $5c $08 $53
	.db $5c $0c $10
	.db $5c $0e $50
	.db $5c $10 $40
	.db $5c $12 $20
	.db $5c $14 $30
	.db $5c $16 $10
	.db $5c $18 $10
	.db $5c $1a $00
	.db $5c $1c $10
	.db $5c $1e $20
	.db $5d $0a $10
	.db $5d $08 $00
	.db $00 $00 $00
	.db $60 $00 $00
	.db $60 $02 $50
	.db $60 $04 $40
	.db $60 $06 $00
	.db $60 $08 $50
	.db $60 $0a $40
	.db $60 $0c $40
	.db $60 $0e $50
	.db $5f $10 $10
	.db $60 $12 $50
	.db $60 $14 $10
	.db $60 $16 $40
	.db $60 $18 $50
	.db $60 $1a $40
	.db $60 $10 $20
	.db $60 $1e $40
	.db $5f $00 $50
	.db $5f $02 $40
	.db $5f $04 $50
	.db $5f $16 $03
	.db $61 $00 $50
	.db $61 $02 $33
	.db $5d $0c $33
	.db $00 $00 $00
	.db $5c $04 $00
	.db $5c $04 $10
	.db $5c $04 $20
	.db $5c $06 $40
	.db $5c $06 $50
	.db $5c $08 $43
	.db $5c $08 $53
	.db $5c $0c $30
	.db $5d $00 $00
	.db $5d $04 $53
	.db $5d $04 $00
	.db $5d $14 $00
	.db $5d $14 $10
	.db $5d $14 $20
interaction92SubidData:
	.db $65 $04 $00
	.db $65 $06 $20
	.db $65 $08 $10
	.db $65 $0a $30
	.db $5d $10 $22
	.db $5d $12 $52
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $5e $00 $33
	.db $5e $04 $13
interaction17SubidData:
	.db $5e $0c $50
	.db $5e $08 $53
interaction18SubidData:
	.db $5e $0e $50
	.db $5e $10 $40
	.db $5e $12 $10
	.db $66 $12 $0a
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $65 $10 $33
	.db $64 $1c $53
	.db $66 $0a $04
	.db $66 $00 $33
	.db $66 $04 $10
	.db $66 $04 $20
	.db $66 $06 $03
	.db $65 $18 $23
	.db $65 $1c $13
	.db $64 $1c $43
	.db $00 $00 $00
interactiondeSubidData:
	.db $66 $12 $0a
	.db $62 $14 $02
	.db $62 $10 $12
	.db $62 $06 $53
	.db $62 $0a $42
	.db $62 $16 $52
	.db $62 $0c $43
	.db $62 $02 $23
	.db $62 $00 $32
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $00 $00 $00
	.db $63 $00 $03
	.db $63 $04 $32
	.db $63 $06 $03
	.db $63 $0a $43
	.db $64 $14 $53
	.db $63 $0e $53
	.db $63 $12 $13
	.db $64 $00 $13
	.db $64 $04 $53
	.db $64 $08 $33
	.db $64 $0c $13
	.db $64 $90 $03

interaction7dSubidData:
	.db $58 $00 $40
	.db $58 $00 $51
	.db $58 $80 $02

interaction7aSubidData:
	.db $59 $00 $40
	.db $59 $00 $42
	.db $59 $00 $44
	.db $59 $80 $46

interaction7fSubidData:
	.db $62 $00 $00
	.db $5b $00 $40
	.db $5b $06 $43
	.db $2e $80 $00

interaction0bSubidData:
	.db $6b $08 $40
	.db $6b $88 $41

interactione0SubidData:
	.db $55 $00 $00
	.db $55 $08 $20
	.db $55 $10 $30
	.db $55 $98 $10

interactione1SubidData:
	.db $4f $18 $40
	.db $4f $98 $50

interaction6aSubidData:
	.db $07 $00 $12
	.db $07 $00 $22
	.db $07 $00 $12
	.db $41 $80 $07

interaction7cSubidData:
	.db $58 $1a $10
	.db $58 $9a $20

interaction2aSubidData:
	.db $46 $14 $00
	.db $46 $14 $10
	.db $46 $14 $20
	.db $46 $14 $30
	.db $46 $14 $20
	.db $46 $14 $30
	.db $46 $14 $10
	.db $46 $14 $00
	.db $46 $14 $00
	.db $46 $94 $10

interaction34SubidData:
	.db $07 $00 $00
	.db $07 $80 $01

interaction35SubidData:
	.db $3b $00 $00
	.db $3b $00 $10
	.db $3b $00 $20
	.db $3b $00 $00
	.db $3b $00 $00
	.db $3c $00 $00
	.db $3c $00 $00
	.db $3a $80 $00

interaction3eSubidData:
	.db $31 $10 $03
	.db $31 $10 $12
	.db $31 $10 $22
	.db $31 $90 $32

interaction3bSubidData:
	.db $46 $00 $33
	.db $46 $00 $34
	.db $46 $00 $32
	.db $46 $00 $35
	.db $46 $00 $34
	.db $46 $00 $35
	.db $46 $00 $24
	.db $46 $80 $22

interaction44SubidData:
	.db $11 $00 $05
	.db $11 $00 $02
	.db $11 $00 $02
	.db $11 $00 $02
	.db $11 $00 $02
	.db $11 $00 $02
	.db $11 $00 $00
	.db $11 $00 $02
	.db $11 $00 $02
	.db $11 $80 $02

interaction47SubidData:
	.db $5f $00 $50
	.db $5c $02 $59
	.db $5d $0a $10
	.db $60 $06 $00
	.db $5c $10 $40
	.db $65 $14 $33
	.db $5d $0a $10
	.db $5d $00 $23
	.db $5d $0a $10
	.db $5d $00 $23
	.db $5d $0a $10
	.db $61 $00 $50
	.db $5d $10 $13
	.db $5f $16 $03
	.db $5d $0a $10
	.db $5d $08 $00
	.db $5d $08 $00
	.db $60 $08 $50
	.db $60 $0a $40
	.db $5d $0a $10
interaction4aSubidData:
	.db $50 $00 $60
	.db $50 $00 $60
	.db $50 $00 $60
	.db $50 $0a $13
	.db $5b $06 $45
	.db $00 $00 $22
	.db $00 $00 $22
	.db $50 $12 $14
	.db $68 $00 $46
	.db $00 $60 $a0
	.db $00 $ea $93

interaction4bSubidData:
	.db $00 $18 $b0
	.db $00 $02 $b1
	.db $00 $86 $a2

interaction4cSubidData:
	.db $4e $00 $00
	.db $4e $18 $09
	.db $52 $18 $62
	.db $52 $18 $63
	.db $66 $04 $25
	.db $66 $04 $15
	.db $4e $1e $25
	.db $53 $0a $66
	.db $53 $1a $67
	.db $63 $0e $51
	.db $56 $0e $01
	.db $56 $12 $21
	.db $56 $16 $15
	.db $56 $98 $39

interaction4eSubidData:
	.db $48 $00 $04
	.db $48 $00 $00
	.db $48 $00 $02
	.db $48 $00 $03
	.db $0f $00 $2b
	.db $00 $06 $a5
	.db $13 $00 $06
	.db $80 $12 $17
	.db $48 $00 $00
	.db $48 $00 $02
	.db $48 $80 $01

interaction4fSubidData:
	.db $14 $00 $00
	.db $6a $00 $01
	.db $15 $18 $43
	.db $6b $00 $46
	.db $15 $18 $44
	.db $6d $80 $0f

interaction50SubidData:
	.db $49 $00 $00
	.db $49 $00 $20
	.db $49 $00 $30
	.db $49 $80 $10

; Unused data?
	.db $5d $10 $20
	.db $5d $0a $11
	.db $5d $08 $01
	.db $5d $08 $01
	.db $5d $00 $24

interaction59SubidData:
	.db $4e $1a $50
	.db $4e $1a $40
interaction5dSubidData:
	.db $63 $00 $00
	.db $63 $04 $30
	.db $63 $06 $00
	.db $63 $0a $40
	.db $64 $14 $50
	.db $63 $0e $50
	.db $63 $12 $10
	.db $64 $00 $10
	.db $64 $04 $50
	.db $64 $08 $30
	.db $64 $0c $10
	.db $64 $90 $00

interaction69SubidData:
	.db $5b $0a $40
	.db $5b $0a $40
	.db $5b $06 $41
	.db $5b $8e $12

interaction6bSubidData:
	.db $43 $1c $10
	.db $74 $9a $02

interaction71SubidData:
	.db $65 $10 $30
	.db $5f $16 $30
interaction73SubidData:
	.db $75 $00 $00
	.db $75 $00 $23
	.db $75 $00 $20
	.db $75 $00 $20
	.db $75 $00 $20
	.db $75 $00 $23
interaction74SubidData:
	.db $54 $00 $60
	.db $54 $00 $60
	.db $54 $00 $63
	.db $54 $00 $63
	.db $54 $00 $63
	.db $54 $00 $61
	.db $54 $1c $62
	.db $54 $00 $60
	.db $54 $00 $64
	.db $54 $00 $65
	.db $54 $00 $64
	.db $54 $00 $65
	.db $53 $80 $56

interaction75SubidData:
	.db $00 $00 $00
	.db $00 $00 $04
	.db $00 $80 $05

interaction76SubidData:
	.db $31 $00 $00
	.db $31 $10 $00
	.db $31 $10 $21
interaction79SubidData:
	.db $57 $08 $00
	.db $57 $08 $01
	.db $57 $08 $02
	.db $57 $08 $03
	.db $57 $08 $04
	.db $57 $88 $05

interaction81SubidData:
	.db $65 $0c $23
	.db $5c $10 $50
	.db $5d $0a $10
	.db $5d $0a $10
	.db $5d $10 $26
	.db $5d $08 $00
	.db $5d $08 $00
	.db $5d $08 $00
	.db $5d $08 $00
	.db $5c $12 $20
	.db $60 $06 $00
	.db $5c $16 $10
	.db $5c $02 $57
	.db $5d $0c $13
	.db $5c $0c $10
interaction84SubidData:
	.db $2e $00 $00
	.db $50 $0a $21
	.db $50 $0a $01
	.db $50 $0a $01
	.db $2e $00 $00
	.db $50 $0a $01
	.db $2e $14 $52
	.db $2e $00 $00
	.db $2e $00 $00
	.db $2e $00 $04
	.db $2e $80 $00

interaction8eSubidData:
	.db $38 $02 $10
	.db $38 $02 $11
	.db $38 $82 $12

interaction95SubidData:
	.db $00 $00 $00
	.db $00 $00 $03
	.db $00 $00 $01
	.db $0b $00 $04
	.db $0a $00 $06
	.db $0a $80 $07

interaction9aSubidData:
	.db $00 $0c $a0
	.db $00 $82 $a1

interaction9fSubidData:
	.db $38 $08 $50
	.db $2f $98 $41

interactiona0SubidData:
	.db $38 $00 $30
	.db $00 $c4 $90

interactiona1SubidData:
	.db $57 $0e $00
	.db $57 $0e $00
	.db $57 $0e $01
	.db $57 $0e $01
	.db $57 $0e $02
	.db $57 $0e $02
	.db $57 $0e $03
	.db $57 $8e $03

interactiona2SubidData:
	.db $5a $00 $50
	.db $5a $00 $50
	.db $5a $00 $51
	.db $5a $80 $51

interactiona5SubidData:
	.db $13 $00 $04
	.db $13 $00 $01
	.db $13 $00 $02
	.db $13 $00 $06
	.db $13 $00 $00
	.db $13 $00 $01
	.db $13 $00 $04
	.db $14 $00 $08
	.db $13 $80 $06

interactiona7SubidData:
	.db $3e $10 $00
	.db $39 $00 $01
	.db $3a $00 $02
	.db $32 $80 $03

interactiona9SubidData:
	.db $37 $16 $20
	.db $31 $10 $02
	.db $36 $10 $24
	.db $36 $00 $16
	.db $34 $00 $18
	.db $37 $80 $2a

interactionaaSubidData:
	.db $0f $00 $20
	.db $11 $00 $02
	.db $4a $00 $17
	.db $0f $80 $2b

interactionadSubidData:
	.db $46 $00 $30
	.db $3f $00 $22
	.db $07 $00 $04
	.db $3f $08 $36
	.db $45 $80 $28

interactionb0SubidData:
	.db $11 $00 $03
	.db $6c $00 $10
	.db $6c $00 $21
	.db $6e $00 $42
	.db $6e $00 $62
	.db $6e $00 $72
	.db $4a $00 $14
	.db $13 $00 $05
	.db $6e $00 $42
	.db $6e $00 $62
	.db $6e $00 $72
	.db $6f $00 $72
	.db $6f $00 $72
	.db $6f $00 $72
interactionb6SubidData:
	.db $5d $10 $22
	.db $5d $08 $00
	.db $5d $08 $00
	.db $5d $08 $00
	.db $5d $08 $00
	.db $5d $08 $00
	.db $5d $00 $23
	.db $5c $08 $53
	.db $5c $00 $20
	.db $5c $02 $50
	.db $64 $98 $53

interactionb7SubidData:
	.db $00 $00 $a0
	.db $5c $82 $51

interactionb9SubidData:
	.db $3f $08 $30
	.db $31 $10 $12
	.db $31 $00 $04
	.db $36 $10 $26
	.db $46 $14 $28
	.db $46 $14 $0a
	.db $46 $14 $3c
	.db $46 $80 $2e

interactioncfSubidData:
	.db $00 $26 $e0
	.db $00 $26 $e1
	.db $00 $a6 $e2

interactiond2SubidData:
	.db $69 $00 $20
	.db $69 $00 $21
	.db $69 $00 $22
	.db $69 $80 $23

interactiond4SubidData:
	.db $70 $00 $00
	.db $70 $0e $71
	.db $70 $90 $42

interactiondbSubidData:
	.db $75 $00 $12
	.db $3d $04 $24
	.db $37 $96 $14

interactiondfSubidData:
	.db $4a $00 $04
	.db $4b $90 $12

interactione6SubidData:
	.db $00 $00 $00
	.db $73 $18 $00
	.db $60 $10 $21
	.db $5b $06 $42
