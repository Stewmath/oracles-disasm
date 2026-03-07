; This is a list of tiles that will cause certain room flag bits to be set when destroyed.
;
; In order for this to work, the corresponding bit in the "breakableTileModes" table
; must be set; see breakableTiles.s.
;
; Data format:
; b0: tile index
; b1: bit 7:    Set if it's a door/bomb wall linked between two rooms in a dungeon (will update the
;               room flags in both rooms)
;     bit 6:    Set if it's a door/bomb wall linked between two rooms indoors
;     bits 0-3: If bit 6 or 7 is set, this is the "direction" of the room link ($0, $4, $8, or $c).
;               If bits 6 and 7 aren't set, this is the bit to set in the room flags (ie.
;               value of 2 will set bit 2).

tileUpdateRoomFlagsOnBreakTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

@overworld:
	.db $c6 $07
	.db $c1 $07
	.db $c2 $07
	.db $e3 $07
@subrosia:
	.db $e2 $07
	.db $cb $07
	.db $c5 $07
@makutree:
	.db $00

@indoors:
	.db $30 $00
	.db $31 $44
	.db $32 $02
	.db $33 $4c
	.db $00

@dungeons:
	.db $30 $80
	.db $31 $84
	.db $32 $88
	.db $33 $8c
	.db $38 $80
	.db $39 $84
	.db $3a $88
	.db $3b $8c
@sidescrolling:
	.db $00
