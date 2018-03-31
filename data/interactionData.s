; See constants/interactions.s.
;
; Data format:
; b0: object gfx index (see data/objectGfxHeaders.s)
; b1: Value for INTERAC_OAM_TILEINDEX_BASE (bits 0-6)
; b2:
;   bits 0-3: initial animation index
;   bits 4-6: palette
;   bit 7: vram bank (should usually be 0? this just happens to get copied to the oamflags
;   along with the palette.)

; Or, if a pointer is supplied instead, it will point to a sequence of these
; values, each of which is for a unique subid. If bit 7 of b1 is set on one of
; these, it indicates that it is the last valid subid, and all subsequent
; subid's will use those values.

.macro m_InteractionData
	.if NARGS == 3
		.db \1 \2 \3
	.else
		.db \1&$ff $80 \1>>8
	.endif
.endm

; @addr{$fe426}
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
	/* $10 */ m_InteractionData $57 $00 $02
	/* $11 */ m_InteractionData $6b $0a $13
	/* $12 */ m_InteractionData $72 $0a $20
	/* $13 */ m_InteractionData $00 $00 $e0
	/* $14 */ m_InteractionData $00 $00 $e0
	/* $15 */ m_InteractionData $00 $00 $00
	/* $16 */ m_InteractionData $72 $00 $40
	/* $17 */ m_InteractionData interaction17SubidData
	/* $18 */ m_InteractionData interaction18SubidData
	/* $19 */ m_InteractionData $77 $00 $50
	/* $1a */ m_InteractionData $76 $0a $00
	/* $1b */ m_InteractionData interaction1bSubidData
	/* $1c */ m_InteractionData $6c $08 $00
	/* $1d */ m_InteractionData $00 $00 $00
	/* $1e */ m_InteractionData $00 $00 $00
	/* $1f */ m_InteractionData $00 $00 $00
	/* $20 */ m_InteractionData $00 $00 $00
	/* $21 */ m_InteractionData $00 $00 $00
	/* $22 */ m_InteractionData $00 $00 $00
	/* $23 */ m_InteractionData $00 $00 $00
	/* $24 */ m_InteractionData $00 $00 $00
	/* $25 */ m_InteractionData $00 $00 $00
	/* $26 */ m_InteractionData $00 $00 $00
	/* $27 */ m_InteractionData $00 $00 $00
	/* $28 */ m_InteractionData $46 $00 $00
	/* $29 */ m_InteractionData $62 $12 $00
	/* $2a */ m_InteractionData $55 $1a $00
	/* $2b */ m_InteractionData $47 $00 $00
	/* $2c */ m_InteractionData $a2 $00 $20
	/* $2d */ m_InteractionData $62 $00 $60
	/* $2e */ m_InteractionData $41 $10 $02
	/* $2f */ m_InteractionData $00 $00 $00
	/* $30 */ m_InteractionData interaction30SubidData
	/* $31 */ m_InteractionData interaction31SubidData
	/* $32 */ m_InteractionData interaction32SubidData
	/* $33 */ m_InteractionData $00 $00 $00
	/* $34 */ m_InteractionData $3d $00 $60
	/* $35 */ m_InteractionData interaction35SubidData
	/* $36 */ m_InteractionData $26 $00 $12
	/* $37 */ m_InteractionData $24 $00 $12
	/* $38 */ m_InteractionData interaction38SubidData
	/* $39 */ m_InteractionData $4e $10 $30
	/* $3a */ m_InteractionData interaction3aSubidData
	/* $3b */ m_InteractionData interaction3bSubidData
	/* $3c */ m_InteractionData interaction3cSubidData
	/* $3d */ m_InteractionData $42 $10 $32
	/* $3e */ m_InteractionData $38 $00 $10
	/* $3f */ m_InteractionData $3e $00 $02
	/* $40 */ m_InteractionData $4d $00 $12
	/* $41 */ m_InteractionData interaction41SubidData
	/* $42 */ m_InteractionData $46 $1c $14
	/* $43 */ m_InteractionData $42 $0c $24
	/* $44 */ m_InteractionData interaction44SubidData
	/* $45 */ m_InteractionData interaction45SubidData
	/* $46 */ m_InteractionData $62 $00 $11
	/* $47 */ m_InteractionData interaction47SubidData
	/* $48 */ m_InteractionData $28 $00 $02
	/* $49 */ m_InteractionData $4c $16 $20
	/* $4a */ m_InteractionData interaction4aSubidData
	/* $4b */ m_InteractionData $0d $00 $20
	/* $4c */ m_InteractionData $0d $14 $11
	/* $4d */ m_InteractionData $56 $00 $12
	/* $4e */ m_InteractionData $65 $00 $02
	/* $4f */ m_InteractionData $0f $00 $22
	/* $50 */ m_InteractionData interaction50SubidData
	/* $51 */ m_InteractionData $40 $00 $00
	/* $52 */ m_InteractionData $41 $10 $02
	/* $53 */ m_InteractionData $53 $00 $22
	/* $54 */ m_InteractionData $53 $14 $30
	/* $55 */ m_InteractionData $41 $00 $22
	/* $56 */ m_InteractionData $00 $0c $a0
	/* $57 */ m_InteractionData $4a $00 $00
	/* $58 */ m_InteractionData $5b $00 $32
	/* $59 */ m_InteractionData $5d $00 $02
	/* $5a */ m_InteractionData $59 $00 $00
	/* $5b */ m_InteractionData $4b $10 $10
	/* $5c */ m_InteractionData $5e $00 $00
	/* $5d */ m_InteractionData $4e $00 $50
	/* $5e */ m_InteractionData $64 $00 $10
	/* $5f */ m_InteractionData $4f $00 $00
	/* $60 */ m_InteractionData interaction60SubidData
	/* $61 */ m_InteractionData $72 $0a $30
	/* $62 */ m_InteractionData interaction62SubidData
	/* $63 */ m_InteractionData interaction63SubidData
	/* $64 */ m_InteractionData interaction64SubidData
	/* $65 */ m_InteractionData $43 $00 $21
	/* $66 */ m_InteractionData $2a $00 $32
	/* $67 */ m_InteractionData $00 $00 $00
	/* $68 */ m_InteractionData interaction68SubidData
	/* $69 */ m_InteractionData $5e $10 $12
	/* $6a */ m_InteractionData $59 $1a $00
	/* $6b */ m_InteractionData interaction6bSubidData
	/* $6c */ m_InteractionData $00 $00 $00
	/* $6d */ m_InteractionData interaction6dSubidData
	/* $6e */ m_InteractionData interaction6eSubidData
	/* $6f */ m_InteractionData $83 $0c $01
	/* $70 */ m_InteractionData $00 $00 $00
	/* $71 */ m_InteractionData $7c $16 $30
	/* $72 */ m_InteractionData interaction72SubidData
	/* $73 */ m_InteractionData $90 $16 $20
	/* $74 */ m_InteractionData $00 $00 $00
	/* $75 */ m_InteractionData interaction75SubidData
	/* $76 */ m_InteractionData $00 $00 $00
	/* $77 */ m_InteractionData $7a $0c $50
	/* $78 */ m_InteractionData $00 $00 $00
	/* $79 */ m_InteractionData interaction79SubidData
	/* $7a */ m_InteractionData interaction7aSubidData
	/* $7b */ m_InteractionData interaction7bSubidData
	/* $7c */ m_InteractionData $00 $00 $00
	/* $7d */ m_InteractionData interaction7dSubidData
	/* $7e */ m_InteractionData $00 $16 $a0
	/* $7f */ m_InteractionData interaction7fSubidData
	/* $80 */ m_InteractionData interaction80SubidData
	/* $81 */ m_InteractionData interaction81SubidData
	/* $82 */ m_InteractionData $72 $1c $41
	/* $83 */ m_InteractionData interaction83SubidData
	/* $84 */ m_InteractionData interaction84SubidData
	/* $85 */ m_InteractionData $00 $00 $00
	/* $86 */ m_InteractionData interaction86SubidData
	/* $87 */ m_InteractionData $04 $00 $00
	/* $88 */ m_InteractionData $67 $00 $00
	/* $89 */ m_InteractionData $51 $00 $00
	/* $8a */ m_InteractionData $00 $00 $00
	/* $8b */ m_InteractionData $5a $00 $30
	/* $8c */ m_InteractionData $80 $0a $33
	/* $8d */ m_InteractionData $39 $00 $02
	/* $8e */ m_InteractionData $ca $10 $00
	/* $8f */ m_InteractionData $78 $12 $20
	/* $90 */ m_InteractionData $00 $00 $00
	/* $91 */ m_InteractionData $00 $16 $90
	/* $92 */ m_InteractionData interaction92SubidData
	/* $93 */ m_InteractionData $2c $00 $02
	/* $94 */ m_InteractionData interaction94SubidData
	/* $95 */ m_InteractionData $45 $06 $20
	/* $96 */ m_InteractionData interaction96SubidData
	/* $97 */ m_InteractionData $00 $00 $00
	/* $98 */ m_InteractionData $71 $00 $30
	/* $99 */ m_InteractionData interaction99SubidData
	/* $9a */ m_InteractionData $60 $00 $10
	/* $9b */ m_InteractionData $00 $00 $00
	/* $9c */ m_InteractionData interaction9cSubidData
	/* $9d */ m_InteractionData $5f $14 $02
	/* $9e */ m_InteractionData $6c $1c $50
	/* $9f */ m_InteractionData interaction9fSubidData
	/* $a0 */ m_InteractionData interactiona0SubidData
	/* $a1 */ m_InteractionData $72 $0e $00
	/* $a2 */ m_InteractionData $75 $00 $50
	/* $a3 */ m_InteractionData $72 $0e $10
	/* $a4 */ m_InteractionData $72 $1a $00
	/* $a5 */ m_InteractionData interactiona5SubidData
	/* $a6 */ m_InteractionData $83 $12 $00
	/* $a7 */ m_InteractionData interactiona7SubidData
	/* $a8 */ m_InteractionData $00 $00 $00
	/* $a9 */ m_InteractionData interactiona9SubidData
	/* $aa */ m_InteractionData interactionaaSubidData
	/* $ab */ m_InteractionData $44 $00 $12
	/* $ac */ m_InteractionData $00 $00 $00
	/* $ad */ m_InteractionData $11 $00 $02
	/* $ae */ m_InteractionData $00 $00 $00
	/* $af */ m_InteractionData $00 $00 $00
	/* $b0 */ m_InteractionData $88 $00 $00
	/* $b1 */ m_InteractionData $83 $04 $52
	/* $b2 */ m_InteractionData $00 $00 $00
	/* $b3 */ m_InteractionData $00 $00 $00
	/* $b4 */ m_InteractionData $7a $16 $10
	/* $b5 */ m_InteractionData $00 $00 $00
	/* $b6 */ m_InteractionData interactionb6SubidData
	/* $b7 */ m_InteractionData interactionb7SubidData
	/* $b8 */ m_InteractionData $3c $00 $20
	/* $b9 */ m_InteractionData interactionb9SubidData
	/* $ba */ m_InteractionData $66 $00 $30
	/* $bb */ m_InteractionData $37 $00 $10
	/* $bc */ m_InteractionData $2f $00 $00
	/* $bd */ m_InteractionData $00 $00 $00
	/* $be */ m_InteractionData $00 $00 $00
	/* $bf */ m_InteractionData interactionbfSubidData
	/* $c0 */ m_InteractionData $82 $1c $32
	/* $c1 */ m_InteractionData $6b $0a $10
	/* $c2 */ m_InteractionData $61 $00 $30
	/* $c3 */ m_InteractionData $63 $00 $14
	/* $c4 */ m_InteractionData $63 $0a $12
	/* $c5 */ m_InteractionData $00 $00 $00
	/* $c6 */ m_InteractionData $00 $00 $00
	/* $c7 */ m_InteractionData $00 $00 $00
	/* $c8 */ m_InteractionData $55 $04 $00
	/* $c9 */ m_InteractionData $4c $00 $20
	/* $ca */ m_InteractionData $40 $0e $34
	/* $cb */ m_InteractionData $90 $16 $00
	/* $cc */ m_InteractionData $44 $16 $24
	/* $cd */ m_InteractionData $3f $16 $14
	/* $ce */ m_InteractionData $8d $00 $50
	/* $cf */ m_InteractionData interactioncfSubidData
	/* $d0 */ m_InteractionData $00 $00 $00
	/* $d1 */ m_InteractionData $00 $00 $80
	/* $d2 */ m_InteractionData interactiond2SubidData
	/* $d3 */ m_InteractionData $85 $1a $30
	/* $d4 */ m_InteractionData interactiond4SubidData
	/* $d5 */ m_InteractionData interactiond5SubidData
	/* $d6 */ m_InteractionData $40 $12 $00
	/* $d7 */ m_InteractionData interactiond7SubidData
	/* $d8 */ m_InteractionData $00 $00 $00
	/* $d9 */ m_InteractionData $00 $00 $00
	/* $da */ m_InteractionData $00 $00 $00
	/* $db */ m_InteractionData $00 $00 $00
	/* $dc */ m_InteractionData $00 $00 $80
	/* $dd */ m_InteractionData interactionddSubidData
	/* $de */ m_InteractionData $00 $4a $90
	/* $df */ m_InteractionData interactiondfSubidData
	/* $e0 */ m_InteractionData interactione0SubidData
	/* $e1 */ m_InteractionData $6c $10 $40
	/* $e2 */ m_InteractionData $8c $1e $04
	/* $e3 */ m_InteractionData $0d $14 $11
	/* $e4 */ m_InteractionData $00 $00 $00
	/* $e5 */ m_InteractionData $6c $08 $10
	/* $e6 */ m_InteractionData $00 $60 $b0

interaction60SubidData:
interaction63SubidData:
	m_InteractionData $78 $04 $00
	m_InteractionData $78 $06 $40
	m_InteractionData $78 $08 $53
	m_InteractionData $00 $00 $00
	m_InteractionData $00 $00 $00
	m_InteractionData $78 $10 $40
	m_InteractionData $78 $12 $20
	m_InteractionData $78 $14 $30
	m_InteractionData $78 $16 $10
	m_InteractionData $78 $18 $10
	m_InteractionData $78 $1a $00
	m_InteractionData $00 $00 $00
	m_InteractionData $00 $00 $00
	m_InteractionData $79 $0a $10
	m_InteractionData $79 $08 $00
	m_InteractionData $00 $00 $00
	m_InteractionData $7d $00 $00
	m_InteractionData $7d $02 $50
	m_InteractionData $7d $04 $40
	m_InteractionData $7d $06 $00
	m_InteractionData $7d $08 $50
	m_InteractionData $7d $0a $40
	m_InteractionData $7d $0c $40
	m_InteractionData $7d $0e $20
	m_InteractionData $00 $00 $00
	m_InteractionData $7d $12 $50
	m_InteractionData $7d $10 $50
	m_InteractionData $7d $16 $40
	m_InteractionData $7d $18 $50
	m_InteractionData $00 $00 $00
	m_InteractionData $00 $00 $00
	m_InteractionData $7d $1e $40
	m_InteractionData $7c $00 $50
	m_InteractionData $7c $02 $50
	m_InteractionData $00 $00 $00
	m_InteractionData $7c $16 $03
	m_InteractionData $7e $00 $50
	m_InteractionData $7e $02 $33
	m_InteractionData $81 $14 $43
	m_InteractionData $79 $16 $43
	m_InteractionData $78 $04 $00
	m_InteractionData $78 $04 $10
	m_InteractionData $78 $04 $20
	m_InteractionData $78 $06 $40
	m_InteractionData $78 $06 $50
	m_InteractionData $78 $08 $43
	m_InteractionData $78 $08 $53
	m_InteractionData $00 $00 $00
	m_InteractionData $79 $00 $00
	m_InteractionData $79 $04 $53
	m_InteractionData $79 $04 $00
	m_InteractionData $79 $14 $00
	m_InteractionData $79 $14 $10
	m_InteractionData $79 $14 $20
	m_InteractionData $82 $04 $00
	m_InteractionData $82 $06 $20
	m_InteractionData $82 $08 $10
	m_InteractionData $82 $0a $30
	m_InteractionData $79 $10 $22
	m_InteractionData $79 $12 $52
	m_InteractionData $81 $10 $33
	m_InteractionData $65 $10 $23
	m_InteractionData $83 $00 $03
	m_InteractionData $45 $06 $20
	m_InteractionData $7a $00 $33
	m_InteractionData $7a $04 $13
interaction17SubidData:
	m_InteractionData $7a $0c $50
	m_InteractionData $7a $08 $53
interaction18SubidData:
	m_InteractionData $7a $0e $50
	m_InteractionData $7a $10 $20
	m_InteractionData $7a $12 $50
	m_InteractionData $7a $12 $40
	m_InteractionData $7a $14 $00
	m_InteractionData $82 $14 $33
	m_InteractionData $82 $08 $53
	m_InteractionData $82 $00 $33
	m_InteractionData $82 $0c $52
	m_InteractionData $82 $0e $12
	m_InteractionData $82 $04 $53
	m_InteractionData $83 $12 $0d
	m_InteractionData $75 $1c $30
	m_InteractionData $81 $0c $13
	m_InteractionData $7a $16 $03
	m_InteractionData $82 $1a $50
	m_InteractionData $81 $14 $53
	m_InteractionData $81 $1c $53
	m_InteractionData $83 $0a $04
	m_InteractionData $83 $00 $33
	m_InteractionData $82 $12 $32
	m_InteractionData $00 $00 $00
	m_InteractionData $00 $00 $00
	m_InteractionData $83 $06 $53
	m_InteractionData $83 $04 $52
	m_InteractionData $81 $1c $43
	m_InteractionData $00 $00 $00
interactiond7SubidData:
	m_InteractionData $83 $12 $0d
	m_InteractionData $7f $00 $13
	m_InteractionData $7f $04 $02
	m_InteractionData $7f $06 $32
	m_InteractionData $7f $08 $22
	m_InteractionData $7f $0a $02
	m_InteractionData $7f $0c $02
	m_InteractionData $7f $0e $13
	m_InteractionData $7f $12 $53
	m_InteractionData $79 $1a $23
	m_InteractionData $7e $06 $03
	m_InteractionData $7e $0e $33
	m_InteractionData $7e $16 $13
	m_InteractionData $00 $00 $00
	m_InteractionData $00 $00 $00
	m_InteractionData $00 $00 $00
	m_InteractionData $00 $00 $00
	m_InteractionData $80 $00 $53
	m_InteractionData $80 $04 $22
	m_InteractionData $80 $06 $03
	m_InteractionData $80 $0a $33
	m_InteractionData $80 $0e $33
	m_InteractionData $80 $12 $13
	m_InteractionData $80 $16 $12
	m_InteractionData $80 $18 $32
	m_InteractionData $80 $1a $13
	m_InteractionData $81 $00 $33
	m_InteractionData $81 $04 $33
	m_InteractionData $81 $88 $13

interaction1bSubidData:
	m_InteractionData $74 $10 $00
	m_InteractionData $74 $90 $02

interaction7dSubidData:
	m_InteractionData $73 $00 $40
	m_InteractionData $73 $00 $51
	m_InteractionData $73 $80 $02

interaction7aSubidData:
	m_InteractionData $74 $00 $40
	m_InteractionData $74 $00 $42
	m_InteractionData $74 $00 $44
	m_InteractionData $74 $80 $46

interaction7bSubidData:
	m_InteractionData $75 $14 $60
	m_InteractionData $75 $94 $61

interaction7fSubidData:
	m_InteractionData $7f $00 $00
	m_InteractionData $76 $00 $40
	m_InteractionData $76 $06 $43
	m_InteractionData $3a $80 $00

interaction80SubidData:
	m_InteractionData $69 $10 $40
	m_InteractionData $69 $00 $51
	m_InteractionData $69 $0a $02
	m_InteractionData $69 $0c $23
	m_InteractionData $6c $0c $04
	m_InteractionData $82 $1a $53
	m_InteractionData $82 $1a $53
	m_InteractionData $82 $12 $32
	m_InteractionData $7a $16 $04
	m_InteractionData $6f $00 $66
	m_InteractionData $6f $90 $67

interaction81SubidData:
	m_InteractionData $7d $0c $40
	m_InteractionData $7d $12 $50
	m_InteractionData $7d $16 $40
	m_InteractionData $7d $16 $40
	m_InteractionData $7d $06 $00
	m_InteractionData $7d $08 $50
	m_InteractionData $7d $8a $40

interaction86SubidData:
	m_InteractionData $04 $00 $00
	m_InteractionData $05 $1e $12
interaction0bSubidData:
	m_InteractionData $87 $08 $40
	m_InteractionData $87 $88 $41

interaction30SubidData:
	m_InteractionData $5b $18 $02
	m_InteractionData $2a $00 $34
	m_InteractionData $00 $80 $00

interaction31SubidData:
	m_InteractionData $0f $00 $22
	m_InteractionData $0f $80 $26

interaction32SubidData:
	m_InteractionData $8f $00 $22
	m_InteractionData $8f $80 $22

interaction35SubidData:
	m_InteractionData $48 $00 $00
	m_InteractionData $48 $00 $10
	m_InteractionData $48 $00 $20
	m_InteractionData $48 $00 $00
	m_InteractionData $48 $00 $00
	m_InteractionData $49 $00 $00
	m_InteractionData $49 $00 $00
	m_InteractionData $47 $80 $00

interaction38SubidData:
	m_InteractionData $3f $1c $34
interaction3aSubidData:
	m_InteractionData $4f $10 $12
	m_InteractionData $5c $10 $12
	m_InteractionData $5b $00 $32
	m_InteractionData $4f $10 $12
	m_InteractionData $4f $10 $12
	m_InteractionData $4f $10 $12
	m_InteractionData $5c $10 $12
	m_InteractionData $5c $10 $12
	m_InteractionData $5c $10 $12
	m_InteractionData $5c $10 $12
	m_InteractionData $5c $10 $12
	m_InteractionData $5c $10 $12
	m_InteractionData $5c $10 $12
	m_InteractionData $5c $10 $12
	m_InteractionData $5c $10 $11
interaction3bSubidData:
	m_InteractionData $3f $00 $22
	m_InteractionData $3f $00 $22
	m_InteractionData $3f $00 $22
	m_InteractionData $5c $00 $22
	m_InteractionData $5c $00 $22
	m_InteractionData $5c $00 $22
	m_InteractionData $5c $00 $22
	m_InteractionData $3f $00 $22
	m_InteractionData $3f $00 $22
interaction3cSubidData:
	m_InteractionData $45 $10 $02
	m_InteractionData $45 $10 $02
	m_InteractionData $45 $10 $02
	m_InteractionData $45 $10 $02
	m_InteractionData $45 $10 $02
	m_InteractionData $45 $10 $02
	m_InteractionData $3e $10 $02
	m_InteractionData $3e $10 $02
	m_InteractionData $3e $10 $02
	m_InteractionData $3e $10 $02
	m_InteractionData $3e $10 $02
	m_InteractionData $45 $10 $02
	m_InteractionData $3e $10 $02
	m_InteractionData $45 $10 $02
	m_InteractionData $3e $10 $02
	m_InteractionData $3e $10 $03
	m_InteractionData $45 $10 $00
interaction41SubidData:
	m_InteractionData $42 $00 $00
	m_InteractionData $44 $1a $05
	m_InteractionData $44 $1a $05
	m_InteractionData $44 $1a $05
	m_InteractionData $44 $1a $05
	m_InteractionData $44 $1a $05
	m_InteractionData $44 $1a $05
interaction44SubidData:
	m_InteractionData $42 $08 $04
	m_InteractionData $43 $0c $14
	m_InteractionData $43 $0c $04
	m_InteractionData $43 $0c $04
	m_InteractionData $42 $08 $04
interaction45SubidData:
	m_InteractionData $49 $1c $34
	m_InteractionData $49 $1c $34
interactiond5SubidData:
	m_InteractionData $4b $00 $30
	m_InteractionData $4b $00 $20
interactione0SubidData:
	m_InteractionData $70 $00 $10
	m_InteractionData $70 $08 $30
interaction47SubidData:
	m_InteractionData $79 $14 $10
	m_InteractionData $78 $02 $59
	m_InteractionData $79 $0a $10
	m_InteractionData $7d $06 $00
	m_InteractionData $78 $10 $40
	m_InteractionData $79 $08 $00
	m_InteractionData $79 $0a $10
	m_InteractionData $79 $00 $23
	m_InteractionData $79 $0a $10
	m_InteractionData $79 $00 $23
	m_InteractionData $79 $0a $10
	m_InteractionData $7e $00 $50
	m_InteractionData $79 $10 $13
	m_InteractionData $7c $16 $03
	m_InteractionData $79 $0a $10
	m_InteractionData $79 $08 $00
	m_InteractionData $79 $08 $00
	m_InteractionData $7d $08 $50
	m_InteractionData $7d $0a $40
	m_InteractionData $79 $0a $10
	m_InteractionData $79 $14 $20
	m_InteractionData $79 $10 $22
interaction4aSubidData:
	m_InteractionData $6b $00 $60
	m_InteractionData $6b $00 $60
	m_InteractionData $6b $00 $60
	m_InteractionData $6b $0a $13
	m_InteractionData $76 $06 $45
	m_InteractionData $00 $00 $22
	m_InteractionData $00 $00 $22
	m_InteractionData $6b $12 $14
	m_InteractionData $85 $00 $46
	m_InteractionData $00 $60 $a0
	m_InteractionData $00 $ea $93

interaction50SubidData:
	m_InteractionData $56 $00 $00
	m_InteractionData $56 $00 $20
	m_InteractionData $56 $00 $30
	m_InteractionData $56 $80 $10

; Unused data?
	m_InteractionData $79 $10 $20
	m_InteractionData $79 $0a $11
	m_InteractionData $79 $08 $01
	m_InteractionData $79 $08 $01
	m_InteractionData $79 $00 $24

interaction62SubidData:
	m_InteractionData $6c $04 $20
	m_InteractionData $6c $80 $30

interaction64SubidData:
	m_InteractionData $00 $00 $90
	m_InteractionData $00 $02 $b0
	m_InteractionData $4e $90 $31

interaction68SubidData:
	m_InteractionData $65 $00 $02
	m_InteractionData $65 $80 $06

interaction6bSubidData:
	m_InteractionData $00 $00 $00
	m_InteractionData $00 $00 $00
	m_InteractionData $00 $00 $00
	m_InteractionData $58 $00 $00
	m_InteractionData $00 $00 $00
	m_InteractionData $00 $00 $00
	m_InteractionData $00 $00 $00
	m_InteractionData $7c $00 $51
	m_InteractionData $00 $00 $00
	m_InteractionData $7d $16 $41
	m_InteractionData $78 $10 $41
	m_InteractionData $81 $10 $32
	m_InteractionData $79 $04 $52
	m_InteractionData $00 $36 $e3
	m_InteractionData $6d $00 $64
	m_InteractionData $00 $00 $00
	m_InteractionData $6d $00 $66
	m_InteractionData $00 $00 $00
	m_InteractionData $58 $00 $07
	m_InteractionData $4c $1c $48
	m_InteractionData $4c $1c $49
	m_InteractionData $6d $00 $64
	m_InteractionData $00 $86 $aa

interaction6dSubidData:
interaction6eSubidData:
	m_InteractionData $26 $00 $60
	m_InteractionData $56 $00 $66
	m_InteractionData $38 $00 $19
	m_InteractionData $24 $00 $10
	m_InteractionData $4d $80 $2c

interaction72SubidData:
	m_InteractionData $a9 $00 $01
	m_InteractionData $90 $00 $33
	m_InteractionData $54 $80 $30

interaction75SubidData:
	m_InteractionData $00 $00 $80
	m_InteractionData $00 $00 $04
	m_InteractionData $00 $00 $05
	m_InteractionData $00 $00 $01
	m_InteractionData $00 $00 $82
	m_InteractionData $00 $00 $83
	m_InteractionData $00 $80 $86

interaction79SubidData:
	m_InteractionData $72 $08 $00
	m_InteractionData $72 $08 $01
	m_InteractionData $72 $08 $02
	m_InteractionData $72 $08 $03
	m_InteractionData $72 $08 $04
	m_InteractionData $72 $88 $05

interaction83SubidData:
	m_InteractionData $56 $00 $20
	m_InteractionData $78 $10 $41
	m_InteractionData $69 $8e $31

interaction84SubidData:
	m_InteractionData $6b $0a $01
	m_InteractionData $6b $0a $21
	m_InteractionData $6b $0a $01
	m_InteractionData $6b $0a $21
	m_InteractionData $3a $00 $00
	m_InteractionData $3a $00 $00
	m_InteractionData $3a $14 $42
	m_InteractionData $3a $00 $00
	m_InteractionData $3a $00 $00
	m_InteractionData $6b $0a $11
	m_InteractionData $6b $0a $01
	m_InteractionData $6b $0a $11
	m_InteractionData $3a $00 $00
	m_InteractionData $3a $00 $04
	m_InteractionData $3a $00 $00
	m_InteractionData $3a $80 $00

interaction92SubidData:
	m_InteractionData $96 $00 $50
	m_InteractionData $96 $00 $50
	m_InteractionData $00 $02 $b1
	m_InteractionData $6b $0a $12
	m_InteractionData $00 $02 $91
	m_InteractionData $00 $02 $a1
	m_InteractionData $00 $82 $81

interaction94SubidData:
	m_InteractionData $52 $00 $02
	m_InteractionData $52 $00 $02
	m_InteractionData $72 $00 $48
	m_InteractionData $00 $00 $00
	m_InteractionData $83 $06 $59
	m_InteractionData $81 $08 $19
	m_InteractionData $83 $04 $5a
	m_InteractionData $7d $82 $5b

interaction96SubidData:
	m_InteractionData $90 $80 $20

interaction99SubidData:
	m_InteractionData $00 $0c $a0
	m_InteractionData $00 $02 $a1
	m_InteractionData $00 $82 $f1

interaction9cSubidData:
	m_InteractionData $5f $00 $10
	m_InteractionData $5f $00 $00
	m_InteractionData $79 $80 $21

interaction9fSubidData:
	m_InteractionData $45 $08 $50
	m_InteractionData $3b $98 $41

interactiona0SubidData:
	m_InteractionData $45 $00 $30
	m_InteractionData $00 $c4 $90

interactiona5SubidData:
	m_InteractionData $80 $1a $10
	m_InteractionData $81 $9a $30

interactiona7SubidData:
	m_InteractionData $4b $10 $00
	m_InteractionData $46 $00 $01
	m_InteractionData $47 $00 $02
	m_InteractionData $3f $80 $03

interactiona9SubidData:
	m_InteractionData $89 $00 $40
	m_InteractionData $89 $00 $60
	m_InteractionData $89 $00 $70
	m_InteractionData $89 $00 $40
	m_InteractionData $89 $00 $60
	m_InteractionData $89 $00 $70
	m_InteractionData $8a $00 $70
	m_InteractionData $8a $00 $70
	m_InteractionData $8a $80 $70

interactionaaSubidData:
	m_InteractionData $14 $00 $05
	m_InteractionData $13 $00 $04
	m_InteractionData $13 $80 $02

interactionbfSubidData:
	m_InteractionData $4f $10 $12
	m_InteractionData $4f $10 $12
	m_InteractionData $3f $00 $22
	m_InteractionData $3f $00 $22
	m_InteractionData $45 $10 $02
	m_InteractionData $45 $10 $02
	m_InteractionData $5c $10 $12
	m_InteractionData $5c $10 $12
	m_InteractionData $5c $00 $22
	m_InteractionData $5c $00 $22
	m_InteractionData $3e $10 $02
	m_InteractionData $3e $90 $02

interactionb6SubidData:
	m_InteractionData $79 $10 $22
	m_InteractionData $79 $08 $00
	m_InteractionData $79 $08 $00
	m_InteractionData $79 $08 $00
	m_InteractionData $79 $08 $00
	m_InteractionData $79 $08 $00
	m_InteractionData $79 $00 $23
	m_InteractionData $78 $08 $53
	m_InteractionData $78 $00 $20
	m_InteractionData $78 $02 $50
	m_InteractionData $81 $98 $53

interactionb7SubidData:
	m_InteractionData $00 $00 $a0
	m_InteractionData $78 $82 $51

interactionb9SubidData:
	m_InteractionData $4c $08 $30
	m_InteractionData $3e $10 $12
	m_InteractionData $3e $00 $04
	m_InteractionData $43 $10 $26
	m_InteractionData $50 $14 $28
	m_InteractionData $50 $14 $0a
	m_InteractionData $50 $14 $3c
	m_InteractionData $54 $80 $2e

interactioncfSubidData:
	m_InteractionData $00 $26 $e0
	m_InteractionData $00 $26 $e1
	m_InteractionData $00 $a6 $e2

interactiond2SubidData:
	m_InteractionData $86 $00 $20
	m_InteractionData $86 $00 $21
	m_InteractionData $86 $00 $22
	m_InteractionData $86 $80 $23

interactiond4SubidData:
	m_InteractionData $8b $00 $00
	m_InteractionData $8b $0e $71
	m_InteractionData $8b $90 $42

interactionddSubidData:
	m_InteractionData $6a $00 $00
	m_InteractionData $6a $00 $00
	m_InteractionData $00 $10 $b5
	m_InteractionData $6a $00 $72
	m_InteractionData $6a $80 $72

interactiondfSubidData:
	m_InteractionData $26 $00 $04
	m_InteractionData $24 $80 $12

; End at $fec09

