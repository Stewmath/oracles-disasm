; List of tiles which add values to wGashaMaturity (increases value of gasha nuts up to a point)
tileIncreaseGashaMaturityOnBreakTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

; Data format:
; b0: tile index
; b1: amount to add to wGashaMaturity

@collisions0:
@collisions4:
	.db $c7 50
	.db $c2 50
	.db $cb 50
	.db $d1 50
	.db $cf 30
	.db $c6 30
	.db $c4 30
	.db $c9 30
	.db $00
@collisions1:
	.db $30 100
	.db $31 100
	.db $32 100
	.db $33 100
	.db $00
@collisions2:
@collisions5:
	.db $30 50
	.db $31 50
	.db $32 50
	.db $33 50
	.db $38 100
	.db $39 100
	.db $3a 100
	.db $3b 100
	.db $68 50
	.db $69 50
@collisions3:
	.db $00
