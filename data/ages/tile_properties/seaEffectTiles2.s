; This is a list of tiles which have some special effect when PART_SEA_EFFECTS has been spawned in
; the current room.
;
; This is a bit of a weird system. First, in seaEffectTiles1.s, the PART_SEA_EFFECTS object is
; automatically spawned in if any of the tiles in that file exist.
;
; Then, so long as that object exists, it checks the data in this file to apply pollution,
; whirlpool, and water current effects.
;
; Not sure why an object needs to be spawned at all, but hey, it works.


; Data format for this table:
;   b0: Tile index ($00 to end the list)
;   b1: $00 for pollution tile, $01 for whirlpool tile, $02 for underwater whirlpool tile
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

; Data format for this table:
;   b0: Tile index ($00 to end the list)
;   b1: Angle towards which Link should be moved while on this tile
currentsCollisionTable:
	.dw @overworld
	.dw @stub
	.dw @dungeon
	.dw @stub
	.dw @stub
	.dw @dungeon

@dungeon:
	.db $54, ANGLE_UP
	.db $55, ANGLE_RIGHT
	.db $56, ANGLE_DOWN
	.db $57, ANGLE_LEFT
	.db $00

@overworld:
	.db $e0, ANGLE_UP
	.db $e1, ANGLE_DOWN
	.db $e2, ANGLE_LEFT
	.db $e3, ANGLE_RIGHT
@stub:
	.db $00
