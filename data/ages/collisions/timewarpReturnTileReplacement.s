; Tile replacements applied to the room when Link returns from a timewarp (entered a return portal,
; or got forcibly sent back due to a failed timewarp).
;
; This should "pull out all the stops" and replace every possible breakable tile that Link could
; have timewarped from with something non-solid. Otherwise, Link could get caught in an infinite
; timewarp loop.
;
; Contrast with timewarpEntryTileReplacement.s, which applies only when playing the tune of
; currents/ages.

timewarpReturnTileReplacementDict:
	.db $c0 $3a ; Rocks
	.db $c3 $3a
	.db $c5 $3a ; Bushes
	.db $c8 $3a
	.db $ce $3a ; Burnable bush
	.db $db $3a ; Switchhook diamond
	.db $f2 $3a ; Sign
	.db $cd $3a ; Dirt
	.db $04 $3a ; Flowers (in some areas)
	.db $00
