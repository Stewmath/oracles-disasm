; Tile replacements applied to the room when Link enters through a timewarp with the tune of
; currents or tune of echoes.
;
; Unlike with timewarpReturnTileReplacement.s, this is only for convenience, allowing the player to
; initiate a timewarp when it otherwise wouldn't work.

timewarpEntryTileReplacementDict:
	.db $c5 $3a ; Bush
	.db $c8 $3a ; Bush
	.db $04 $3a ; Flower (nuun highlands)
	.db $00
