; List of tiles which add values to wGashaMaturity (increases value of gasha nuts up to a point)
tileIncreaseGashaMaturityOnBreakTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

; Data format:
; b0: tile index
; b1: amount to add to wGashaMaturity

@overworld:
	.db $c6 $32
	.db $c2 $32
	.db $e3 $32
@subrosia:
	.db $e2 $32
	.db $cb $1e
	.db $c5 $1e
@makutree:
	.db $00

@indoors:
	.db $30 $64
	.db $31 $64
	.db $32 $64
	.db $33 $64
	.db $00

@dungeons:
	.db $30 $32
	.db $31 $32
	.db $32 $32
	.db $33 $32
	.db $38 $64
	.db $39 $64
	.db $3a $64
	.db $3b $64
@sidescrolling:
	.db $00
