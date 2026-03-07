; List of tiles which add values to wGashaMaturity (increases value of gasha nuts up to a point)
;
; Data format:
; b0: tile index
; b1: amount to add to wGashaMaturity

tileIncreaseGashaMaturityOnBreakTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

@overworld:
	.db $c6 50
	.db $c2 50
	.db $e3 50
@subrosia:
	.db $e2 50
	.db $cb 30
	.db $c5 30
@makutree:
	.db $00

@indoors:
	.db $30 100
	.db $31 100
	.db $32 100
	.db $33 100
	.db $00

@dungeons:
	.db $30 50
	.db $31 50
	.db $32 50
	.db $33 50
	.db $38 100
	.db $39 100
	.db $3a 100
	.db $3b 100
@sidescrolling:
	.db $00
