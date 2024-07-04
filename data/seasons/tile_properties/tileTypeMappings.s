; This table maps a tile index to a tileType (see constants/common/tileTypes.s), which is one of the
; main ways that special tile effects are implemented.
;
; This has no effect on anything other than Link himself. For holes, water, and lava to work with
; enemies and other object types, see "hazards.s".
;
; Data format:
;   b0: Tile index ($00 to end the list)
;   b1: Tile type
tileTypesTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

@overworld:
	.db $20 TILETYPE_STUMP
	.db $f3 TILETYPE_HOLE
	.db $f4 TILETYPE_HOLE
	.db $dd TILETYPE_VINES
	.db $de TILETYPE_VINES
	.db $df TILETYPE_VINES
	.db $f8 TILETYPE_GRASS
	.db $f9 TILETYPE_GRASS
	.db $d0 TILETYPE_STAIRS
	.db $db TILETYPE_CRACKED_ICE
	.db $dc TILETYPE_ICE
	.db $fd TILETYPE_WATER
	.db $fa TILETYPE_PUDDLE
	.db $fb TILETYPE_PUDDLE
	.db $fc TILETYPE_PUDDLE
	.db $d1 TILETYPE_UPCURRENT
	.db $d4 TILETYPE_RIGHTCURRENT
	.db $d2 TILETYPE_DOWNCURRENT
	.db $d3 TILETYPE_LEFTCURRENT
	.db $c9 TILETYPE_CRACKEDFLOOR
	.db $7b TILETYPE_LAVA
	.db $7c TILETYPE_LAVA
	.db $7d TILETYPE_LAVA
	.db $7e TILETYPE_LAVA
	.db $7f TILETYPE_LAVA
	.db $00

@subrosia:
	.db $f3 TILETYPE_HOLE
	.db $f4 TILETYPE_HOLE
	.db $f8 TILETYPE_GRASS
	.db $f9 TILETYPE_GRASS
	.db $d0 TILETYPE_STAIRS
	.db $d1 TILETYPE_STAIRS
	.db $fa TILETYPE_PUDDLE
	.db $fb TILETYPE_PUDDLE
	.db $fc TILETYPE_PUDDLE
	.db $7b TILETYPE_LAVA
	.db $7c TILETYPE_LAVA
	.db $7d TILETYPE_LAVA
	.db $7e TILETYPE_LAVA
	.db $7f TILETYPE_LAVA
	.db $c0 TILETYPE_LAVA
	.db $c1 TILETYPE_LAVA
	.db $c2 TILETYPE_LAVA
	.db $c3 TILETYPE_LAVA
	.db $c4 TILETYPE_LAVA
	.db $c5 TILETYPE_LAVA
	.db $c6 TILETYPE_LAVA
	.db $c7 TILETYPE_LAVA
	.db $c8 TILETYPE_LAVA
	.db $c9 TILETYPE_LAVA
	.db $ca TILETYPE_LAVA
	.db $cb TILETYPE_LAVA
	.db $cc TILETYPE_LAVA
	.db $cd TILETYPE_LAVA
	.db $ce TILETYPE_LAVA
	.db $cf TILETYPE_LAVA
	.db $00

@makutree:
	.db $d0 TILETYPE_VINES
	.db $dd TILETYPE_VINES
	.db $de TILETYPE_VINES
	.db $df TILETYPE_VINES
	.db $00

@indoors:
@dungeons:
	.db $f3 TILETYPE_HOLE
	.db $f4 TILETYPE_HOLE
	.db $f5 TILETYPE_HOLE
	.db $f6 TILETYPE_HOLE
	.db $f7 TILETYPE_HOLE
	.db $fd TILETYPE_WATER
	.db $fa TILETYPE_PUDDLE
	.db $fb TILETYPE_PUDDLE
	.db $fc TILETYPE_PUDDLE
	.db $d0 TILETYPE_HOLE
	.db $61 TILETYPE_LAVA
	.db $62 TILETYPE_LAVA
	.db $63 TILETYPE_LAVA
	.db $64 TILETYPE_LAVA
	.db $65 TILETYPE_LAVA
	.db $50 TILETYPE_STAIRS
	.db $51 TILETYPE_STAIRS
	.db $52 TILETYPE_STAIRS
	.db $53 TILETYPE_STAIRS
	.db $48 TILETYPE_WARPHOLE
	.db $49 TILETYPE_WARPHOLE
	.db $4a TILETYPE_WARPHOLE
	.db $4b TILETYPE_WARPHOLE
	.db $4d TILETYPE_CRACKEDFLOOR
	.db $54 TILETYPE_UPCONVEYOR
	.db $55 TILETYPE_RIGHTCONVEYOR
	.db $56 TILETYPE_DOWNCONVEYOR
	.db $57 TILETYPE_LEFTCONVEYOR
	.db $60 TILETYPE_SPIKE
	.db $8c TILETYPE_ICE
	.db $8d TILETYPE_ICE
	.db $3f TILETYPE_HOLE
	.db $00

@sidescrolling:
	.db $16 TILETYPE_SS_LADDER
	.db $18 TILETYPE_SS_LADDER
	.db $17 TILETYPE_SS_LADDER_TOP|TILETYPE_SS_LADDER
	.db $19 TILETYPE_SS_LADDER_TOP|TILETYPE_SS_LADDER
	.db $f4 TILETYPE_SS_HOLE
	.db $0f TILETYPE_SS_HOLE
	.db $0c TILETYPE_SS_HOLE
	.db $1a TILETYPE_SS_WATER|TILETYPE_SS_LADDER
	.db $1b TILETYPE_SS_WATER
	.db $1c TILETYPE_SS_WATER
	.db $1d TILETYPE_SS_WATER
	.db $1e TILETYPE_SS_WATER
	.db $1f TILETYPE_SS_WATER
	.db $20 TILETYPE_SS_ICE
	.db $22 TILETYPE_SS_ICE
	.db $0c TILETYPE_SS_LAVA
	.db $0d TILETYPE_SS_LAVA
	.db $0e TILETYPE_SS_LAVA
	.db $02 $00
	.db $00
