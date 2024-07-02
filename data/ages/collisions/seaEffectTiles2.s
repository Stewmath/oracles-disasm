harmfulWaterTilesCollisionTable:
	.dw @overworld
	.dw @stub
	.dw @dungeon
	.dw @stub
	.dw @underwater
	.dw @dungeon
@overworld:
	.db TILEINDEX_POLLUTION $00
	.db TILEINDEX_WHIRLPOOL $01
@stub:
	.db $00
@underwater:
	.db TILEINDEX_POLLUTION $00
	.db TILEINDEX_WHIRLPOOL $02
	.db $00
@dungeon:
	; 4 different variants of the currents pits in underwater dungeons
	.db $3c $02
	.db $3d $02
	.db $3e $02
	.db $3f $02
	.db $00

; Entries are the 4 directional currents tiles
currentsCollisionTable:
	.dw @overworld
	.dw @stub
	.dw @dungeon
	.dw @stub
	.dw @stub
	.dw @dungeon
@dungeon:
	.db $54 ANGLE_UP
	.db $55 ANGLE_RIGHT
	.db $56 ANGLE_DOWN
	.db $57 ANGLE_LEFT
	.db $00
@overworld:
	.db $e0 ANGLE_UP
	.db $e1 ANGLE_DOWN
	.db $e2 ANGLE_LEFT
	.db $e3 ANGLE_RIGHT
@stub:
	.db $00
