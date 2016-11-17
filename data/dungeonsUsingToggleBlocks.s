; Each bit sets whether a particular dungeon uses those red/blue toggle blocks.
; The default values are dungeons 5, 8, and hero's cave.

; @addr{3657}
dungeonsUsingToggleBlocks:
	dbrev %00000100 %10010000
