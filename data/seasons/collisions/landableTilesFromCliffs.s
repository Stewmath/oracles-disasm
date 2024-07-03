; This is a list of tiles that can be landed on when jumping down a cliff, despite being
; solid.
landableTileFromCliffExceptions:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

@overworld:
	.db $eb $20
@subrosia:
@makutree:
@indoors:
@dungeons:
@sidescrolling:
	.db $00
