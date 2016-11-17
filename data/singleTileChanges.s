; @addr{$1232e}
singleTileChangeGroupTable:
	.dw singleTileChangeGroup0Data
	.dw singleTileChangeGroup1Data
	.dw singleTileChangeGroup2Data
	.dw singleTileChangeGroup3Data
	.dw singleTileChangeGroup4Data
	.dw singleTileChangeGroup5Data
	.dw singleTileChangeGroup6Data
	.dw singleTileChangeGroup7Data

; Data format:
; b0: Room index
; b1: Bitmask to check on room flags
; b2: Position of tile to change
; b3: New tile to put at that position

; @addr{$1233e}
singleTileChangeGroup0Data:
	.db $39 $40 $22 $d7
	.db $83 $80 $43 $1c
	.db $13 $02 $42 $d7
	.db $13 $04 $47 $d7
	.db $0a $80 $17 $ee
	.db $48 $f0 $28 $64
	.db $47 $f2 $36 $f2
	.db $88 $02 $66 $3a
	.db $6a $02 $48 $3a
	.db $48 $02 $68 $3a
	.db $64 $02 $67 $3a
	.db $00 $00

; @addr{$1236c}
singleTileChangeGroup1Data:
	.db $0e $80 $16 $af
	.db $48 $02 $48 $3a
	.db $15 $80 $34 $9e
	.db $17 $80 $18 $9e
	.db $35 $80 $58 $9e
	.db $37 $80 $57 $9e
	.db $ba $80 $54 $a2
	.db $ba $80 $55 $ef
	.db $ba $80 $56 $a4
	.db $a5 $80 $22 $ee
	.db $a5 $80 $23 $ef
	.db $65 $08 $51 $3a
	.db $65 $02 $61 $3a
	.db $00 $00

; @addr{$123a2}
singleTileChangeGroup2Data:
	.db $d7 $f0 $42 $e9
	.db $00 $00

; @addr{$123a8}
singleTileChangeGroup3Data:
	.db $d6 $f1 $55 $e9
	.db $0f $80 $16 $af
	.db $9e $80 $31 $1c
	.db $9e $80 $32 $a0
	.db $00 $00

; @addr{$123ba}
singleTileChangeGroup4Data:
	.db $56 $20 $44 $a0
	.db $59 $80 $a3 $a0
	.db $4b $80 $54 $a0
	.db $4b $80 $55 $1d
	.db $c5 $20 $57 $52
	.db $00 $00

; @addr{$123d0}
singleTileChangeGroup5Data:
	.db $19 $01 $08 $34
	.db $26 $02 $5e $35
	.db $87 $40 $7c $50
	.db $9c $40 $42 $52
	.db $a9 $40 $77 $52
	.db $8a $01 $77 $d4
	.db $8a $01 $86 $09
	.db $8a $01 $88 $09
	.db $8a $02 $5a $d5
	.db $8a $02 $4b $09
	.db $8a $02 $6b $09
	.db $8a $04 $37 $d6
	.db $8a $04 $26 $09
	.db $8a $04 $28 $09
	.db $8a $08 $54 $d7
	.db $8a $08 $43 $09
	.db $8a $08 $63 $09
	.db $8a $40 $77 $52
	.db $f0 $80 $9d $44
	.db $f1 $80 $66 $45
	.db $f5 $80 $9d $44
	.db $00 $00

; @addr{$12426}
singleTileChangeGroup6Data:
	.db $2b $80 $aa $19
singleTileChangeGroup7Data:
	.db $00 $00
