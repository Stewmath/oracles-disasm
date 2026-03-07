; This table maps a tile index to a tileType (see constants/common/tileTypes.s), which is one of the main
; ways that special tile effects are implemented.
;
; This has no effect on anything other than Link himself. For holes, water, and lava to work with
; enemies and other object types, see "hazards.s".
;
; Data format:
;   b0: Tile index ($00 to end the list)
;   b1: Tile type
tileTypesTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five

@overworld:
@underwater:
	.db $f3 TILETYPE_HOLE
	.db $d4 TILETYPE_VINES
	.db $d5 TILETYPE_VINES
	.db $d6 TILETYPE_VINES
	.db $f8 TILETYPE_GRASS
	.db $d0 TILETYPE_STAIRS
	.db $e9 TILETYPE_WHIRLPOOL
	.db $ea TILETYPE_ICE
	.db $f9 TILETYPE_PUDDLE
	.db $fa TILETYPE_WATER
	.db $fc TILETYPE_SEAWATER
	.db $fe TILETYPE_WATER
	.db $ff TILETYPE_WATER
	.db $e0 TILETYPE_UPCURRENT
	.db $e3 TILETYPE_RIGHTCURRENT
	.db $e1 TILETYPE_DOWNCURRENT
	.db $e2 TILETYPE_LEFTCURRENT
	.db $e4 TILETYPE_LAVA
	.db $e5 TILETYPE_LAVA
	.db $e6 TILETYPE_LAVA
	.db $e7 TILETYPE_LAVA
	.db $e8 TILETYPE_LAVA
	.db $00

@dungeons:
	.db $0e TILETYPE_RAISABLE_FLOOR
	.db $0f TILETYPE_RAISABLE_FLOOR
@indoors:
@five:
	.db $f3 TILETYPE_HOLE
	.db $f4 TILETYPE_HOLE
	.db $f5 TILETYPE_HOLE
	.db $f6 TILETYPE_HOLE
	.db $f7 TILETYPE_HOLE
	.db $f9 TILETYPE_PUDDLE
	.db $fa TILETYPE_WATER
	.db $fc TILETYPE_SEAWATER
	.db $fe TILETYPE_WATER
	.db $ff TILETYPE_WATER
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
	.db $8a TILETYPE_ICE
	.db $00

@sidescrolling:
	.db $16 TILETYPE_SS_LADDER
	.db $18 TILETYPE_SS_LADDER
	.db $17 TILETYPE_SS_LADDER|TILETYPE_SS_LADDER_TOP
	.db $19 TILETYPE_SS_LADDER|TILETYPE_SS_LADDER_TOP
	.db $f4 TILETYPE_SS_HOLE
	.db $0f TILETYPE_SS_HOLE
	.db $0c TILETYPE_SS_HOLE
	.db $1a TILETYPE_SS_LADDER|TILETYPE_SS_WATER
	.db $1b TILETYPE_SS_WATER
	.db $1c TILETYPE_SS_WATER
	.db $1d TILETYPE_SS_WATER
	.db $1e TILETYPE_SS_WATER
	.db $1f TILETYPE_SS_WATER
	.db $20 TILETYPE_SS_ICE
	.db $22 TILETYPE_SS_ICE
	.db $02 $00
	.db $00
