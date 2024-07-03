; Lists the water, hole, and lava tiles for each collision mode.
;
; These tiles must have corresponding entries in tileTypeMappings.s to work properly.
;
; Data format:
;   b0: Tile index
;   b1: $01 = water, $02 = hole, $04 = lava
hazardCollisionTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

@overworld:
	.db $f3 $02
	.db $fd $01
	.db $fe $01
	.db $ff $01
	.db $d1 $01
	.db $d2 $01
	.db $d3 $01
	.db $d4 $01
	.db $7b $04
	.db $7c $04
	.db $7d $04
	.db $7e $04
	.db $7f $04
	.db $00

@subrosia:
	.db $f3 $02
	.db $f4 $02
	.db $7b $04
	.db $7c $04
	.db $7d $04
	.db $7e $04
	.db $7f $04
	.db $c0 $04
	.db $c1 $04
	.db $c2 $04
	.db $c3 $04
	.db $c4 $04
	.db $c5 $04
	.db $c6 $04
	.db $c7 $04
	.db $c8 $04
	.db $c9 $04
	.db $ca $04
	.db $cb $04
	.db $cc $04
	.db $cd $04
	.db $ce $04
	.db $cf $04
@makutree:
	.db $00

@indoors:
@dungeons:
	.db $f3 $02
	.db $f4 $02
	.db $f5 $02
	.db $f6 $02
	.db $f7 $02
	.db $48 $02
	.db $49 $02
	.db $4a $02
	.db $4b $02
	.db $d0 $42
	.db $61 $04
	.db $62 $04
	.db $63 $04
	.db $64 $04
	.db $65 $04
	.db $fd $01
	.db $00

@sidescrolling:
	.db $0c $04
	.db $0d $04
	.db $0e $04
	.db $1a $01
	.db $1b $01
	.db $1c $01
	.db $1d $01
	.db $1e $01
	.db $1f $01
	.db $00
