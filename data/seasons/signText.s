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
signTextGroup3Data:
	.db $43, $d9, <TX_2e00
	.db $52, $4d, <TX_2e01
	.db $17, $0b, <TX_2e03
	.db $53, $1f, <TX_2e04
	.db $27, $97, <TX_2e05
	.db $45, $73, <TX_2e0a
	.db $27, $fc, <TX_2e0b
	.db $28, $35, <TX_2e0c
	.db $45, $7f, <TX_2e0d
	.db $13, $b4, <TX_2e0e
	.db $55, $82, <TX_2e0f
	.db $17, $82, <TX_2e10
	.db $26, $9b, <TX_2e11
	.db $41, $63, <TX_2e12
	.db $22, $7b, <TX_2e13
	.db $34, $54, <TX_2e14
	.db $56, $d7, <TX_2e15
	.db $12, $c4, <TX_2e16
	.db $23, $2c, <TX_2e17
	.db $38, $bb, <TX_2e18
	.db $27, $55, <TX_2e19
	.db $25, $f4, <TX_2e1a
	.db $23, $b9, <TX_2e1b
	.db $33, $f6, <TX_2e1d
	.db $23, $68, <TX_2e1e
	.db $00

signTextGroup1Data:
	.db $27, $45, <TX_2e07
	.db $42, $59, <TX_2e08
	.db $46, $14, <TX_2e09
	.db $00

signTextGroup2Data:
signTextGroup4Data:
	.db $17, $04, <TX_2e02
	.db $00

signTextGroup5Data:
	.db $82, $12, <TX_2e1c
signTextGroup6Data:
signTextGroup7Data:
	.db $00
