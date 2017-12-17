; Each number corresponds to TX_03XX (see text.txt).
; If bit 7 is set, that indicates special behaviour; see the "_mapGetRoomText" function.
presentMapTextIndices: ; Actually "overworld"
	.db $b1 $2b $2b $c9 $03 $03 $03 $03 $18 $04 $04 $05 $05 $05 $05 $05
	.db $2b $2b $2b $02 $03 $03 $03 $03 $04 $04 $04 $05 $05 $a1 $05 $05
	.db $2b $2b $2b $02 $03 $03 $03 $03 $04 $04 $04 $05 $05 $05 $05 $05
	.db $2b $2b $2b $03 $03 $03 $03 $03 $04 $04 $04 $05 $05 $05 $0d $0d
	.db $06 $06 $2b $2b $03 $03 $83 $83 $83 $83 $83 $05 $05 $19 $0d $0d
	.db $06 $06 $2b $2b $07 $83 $83 $83 $83 $83 $83 $82 $82 $1a $1b $0d
	.db $99 $0e $1c $2b $07 $07 $0f $0f $0f $83 $83 $82 $82 $0d $0d $0d
	.db $0e $0e $0e $07 $07 $07 $0f $0f $1d $83 $83 $82 $11 $11 $11 $1e
	.db $0e $0e $0e $07 $07 $07 $0f $0f $29 $10 $a9 $11 $11 $91 $11 $11
	.db $0e $0e $0e $07 $07 $07 $89 $0f $0f $10 $10 $11 $11 $11 $11 $11
	.db $0e $0e $0e $1f $07 $07 $0f $0f $0f $10 $10 $11 $11 $11 $11 $11
	.db $0e $0e $0e $07 $07 $07 $20 $0f $10 $10 $10 $11 $11 $16 $16 $16
	.db $0e $0e $0e $13 $13 $84 $2a $2a $22 $80 $14 $14 $14 $16 $16 $16
	.db $b9 $12 $13 $13 $81 $13 $2a $23 $2a $2a $24 $14 $16 $16 $16 $16
	.db $12 $12 $13 $13 $13 $13 $25 $2a $26 $2a $14 $14 $16 $16 $16 $16
	.db $13 $13 $13 $13 $13 $2a $27 $2a $2a $28 $15 $15 $15 $16 $16 $16


pastMapTextIndices: ; Actually "subrosia"
	.db $c1 $30 $30 $30 $30 $30 $30 $31 $39 $31 $3a
	.db $30 $30 $30 $30 $30 $30 $30 $31 $31 $31 $31
	.db $30 $30 $3d $30 $3e $32 $32 $31 $38 $31 $3b
	.db $37 $37 $32 $3f $32 $32 $32 $31 $31 $31 $31
	.db $37 $37 $32 $32 $32 $3c $32 $32 $32 $40 $32
	.db $33 $33 $41 $32 $32 $32 $32 $32 $32 $32 $43
	.db $33 $33 $34 $34 $35 $35 $35 $35 $36 $36 $36
	.db $33 $33 $42 $34 $35 $35 $35 $35 $36 $36 $36



; This is the list of popups that appear when hovering the cursor over a tile.
;
; b0: room index
; b1: popup behaviour. Each digit represents a different popup; screens with only one
;     popup use the same digit twice. (see the "_mapMenu_LoadPopupData" function)
presentMinimapPopups:
	.db $d4 $88
	.db $96 $88
	.db $8d $88
	.db $60 $88
	.db $1d $38
	.db $8a $88
	.db $00 $88
	.db $d0 $88
	.db $03 $88
	.db $10 $ff
	.db $5f $ff
	.db $67 $ff
	.db $72 $ff
	.db $9e $ff
	.db $f8 $ff
	.db $04 $aa
	.db $08 $77
	.db $11 $33
	.db $1e $aa
	.db $1f $99
	.db $22 $99
	.db $24 $33
	.db $25 $aa
	.db $26 $33
	.db $2e $33
	.db $32 $33
	.db $38 $99
	.db $3b $99
	.db $3f $99
	.db $42 $33
	.db $44 $99
	.db $4d $11
	.db $4e $33
	.db $53 $33
	.db $5b $dd
	.db $5e $cc
	.db $62 $11
	.db $70 $33
	.db $75 $99
	.db $78 $11
	.db $7c $33
	.db $7e $33
	.db $7f $11
	.db $80 $99
	.db $88 $11
	.db $89 $99
	.db $8e $33
	.db $93 $33
	.db $95 $99
	.db $98 $33
	.db $99 $33
	.db $9a $aa
	.db $9b $33
	.db $a3 $11
	.db $a6 $99
	.db $aa $aa
	.db $ac $99
	.db $ae $33
	.db $b0 $aa
	.db $b6 $11
	.db $b9 $aa
	.db $c5 $21
	.db $c8 $91
	.db $c9 $44
	.db $c0 $99
	.db $d2 $33
	.db $d7 $11
	.db $da $11
	.db $e2 $bb
	.db $e6 $cc
	.db $e8 $cc
	.db $eb $33
	.db $ee $bb
	.db $ef $99
	.db $f0 $99
	.db $f2 $bb
	.db $f6 $11
	.db $f7 $a3
	.db $f9 $11
	.db $ff

pastMinimapPopups:
	.db $00 $88
	.db $05 $aa
	.db $08 $ee
	.db $0a $ee
	.db $13 $aa
	.db $20 $aa
	.db $22 $55
	.db $24 $55
	.db $28 $ee
	.db $2a $ee
	.db $33 $55
	.db $45 $66
	.db $49 $55
	.db $4a $aa
	.db $52 $11
	.db $53 $aa
	.db $57 $aa
	.db $5a $11
	.db $64 $bb
	.db $72 $a5
	.db $74 $bb
	.db $ff
