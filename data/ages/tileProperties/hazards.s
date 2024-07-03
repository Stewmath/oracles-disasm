; Lists the water, hole, and lava tiles for each collision mode.
;
; These tiles must have corresponding entries in tileTypeMappings.s to work properly.
;
; Data format:
;   b0: Tile index
;   b1: $01 = water, $02 = hole, $04 = lava
hazardCollisionTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five

@overworld:
@underwater:
	.db $fa $01
	.db $fc $01
	.db $fe $01
	.db $ff $01
	.db $e0 $01
	.db $e1 $01
	.db $e2 $01
	.db $e3 $01
	.db $f3 $02
	.db $e4 $04
	.db $e5 $04
	.db $e6 $04
	.db $e7 $04
	.db $e8 $04
	.db $e9 $01
	.db $00

@indoors:
@dungeons:
@five:
	.db $fa $01
	.db $fc $01
	.db $f3 $02
	.db $f4 $02
	.db $f5 $02
	.db $f6 $02
	.db $f7 $02
	.db $61 $04
	.db $62 $04
	.db $63 $04
	.db $64 $04
	.db $65 $04
	.db $48 $02
	.db $49 $02
	.db $4a $02
	.db $4b $02
	.db $00

@sidescrolling:
	.db $1a $01
	.db $1b $01
	.db $1c $01
	.db $1d $01
	.db $1e $01
	.db $1f $01
	.db $00
