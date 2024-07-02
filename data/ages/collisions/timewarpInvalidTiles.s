; The tiles listed here cannot be timewarped onto, unless the 2nd byte is $01, in which case it will
; be permitted to warp onto them if Link has the mermaid suit.
invalidTimewarpTileList:
	.db $f3 $00 ; Hole
	.db $fe $00 ; Waterfall
	.db $ff $00 ; Waterfall
	.db $e4 $00
	.db $e5 $00
	.db $e6 $00
	.db $e7 $00
	.db $e8 $00
	.db $e9 $00 ; Whirlpool
	.db $fc $01 ; Deep water
	.db $00
