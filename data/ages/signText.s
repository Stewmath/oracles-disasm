; Data format:
;
;   b0: Position ($YX)
;   b1: Room index
;   b2: Text to show (always TX_2eXX)

signTextGroupTable:
	.dw signTextGroup0Data
	.dw signTextGroup1Data
	.dw signTextGroup2Data
	.dw signTextGroup3Data
	.dw signTextGroup4Data
	.dw signTextGroup5Data
	.dw signTextGroup6Data
	.dw signTextGroup7Data

signTextGroup0Data:
	.db $35, $2a, <TX_2e01
	.db $51, $3d, <TX_2e05
	.db $46, $19, <TX_2e06
	.db $22, $1d, <TX_2e07
	.db $32, $48, <TX_2e0d
	.db $47, $57, <TX_2e0e
	.db $37, $6a, <TX_2e0f
	.db $42, $64, <TX_2e10
	.db $28, $24, <TX_2e11
	.db $57, $50, <TX_2e12
	.db $42, $68, <TX_2e14
	.db $51, $55, <TX_2e15
	.db $15, $59, <TX_2e16
	.db $32, $83, <TX_2e1c
	.db $36, $47, <TX_2e1d
	.db $00

signTextGroup1Data:
	.db $54, $39, <TX_2e03
	.db $53, $33, <TX_2e04
	.db $24, $1d, <TX_2e08
	.db $44, $3a, <TX_2e09
	.db $32, $48, <TX_2e0d
	.db $33, $53, <TX_2e13
	.db $31, $57, <TX_2e17
	.db $23, $89, <TX_2e18
	.db $31, $49, <TX_2e1e
	.db $00

signTextGroup2Data:
	.db $52, $e9, <TX_2e00
	.db $46, $fd, <TX_2e0a
	.db $46, $ff, <TX_2e0a
	.db $44, $c4, <TX_2e19
	.db $35, $b1, <TX_2e1a
	.db $58, $a1, <TX_2e1b
	.db $38, $d1, <TX_2e1f
	.db $00

signTextGroup3Data:
	.db $15, $1e, <TX_2e0b
	.db $34, $4e, <TX_2e0c
	.db $44, $c4, <TX_2e19
	.db $35, $b1, <TX_2e1a
	.db $58, $a1, <TX_2e1b
	.db $38, $d1, <TX_2e1f
	.db $00

signTextGroup4Data:
	.db $62, $01, <TX_2e02
	.db $3c, $02, <TX_2e02
	.db $32, $02, <TX_2e02
	.db $44, $03, <TX_2e02
	.db $00

signTextGroup5Data:
	.db $6c, $bf, <TX_2e20
signTextGroup6Data:
signTextGroup7Data:
	.db $00
