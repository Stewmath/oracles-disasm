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
	.db $c6 $32
	.db $c2 $32
	.db $e3 $32
@collisions1:
	.db $e2 $32
	.db $cb $1e
	.db $c5 $1e
@collisions2:
	.db $00

@collisions3:
	.db $30 $64
	.db $31 $64
	.db $32 $64
	.db $33 $64
	.db $00

@collisions4:
	.db $30 $32
	.db $31 $32
	.db $32 $32
	.db $33 $32
	.db $38 $64
	.db $39 $64
	.db $3a $64
	.db $3b $64
@collisions5:
	.db $00
