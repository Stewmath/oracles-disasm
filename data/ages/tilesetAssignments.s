roomTilesetsGroupTable: ; 0x112d4
	.dw group0Tilesets
	.dw group1Tilesets
	.dw group2Tilesets
	.dw group3Tilesets
	.dw group4Tilesets
	.dw group5Tilesets
	.dw group6Tilesets
	.dw group7Tilesets

group0Tilesets: ; 0x112e4
	.incbin "rooms/ages/group0Tilesets.bin"
group1Tilesets: ; 0x113e4
	.incbin "rooms/ages/group1Tilesets.bin"
group2Tilesets: ; 0x114e4
	.incbin "rooms/ages/group2Tilesets.bin"
group3Tilesets: ; 0x115e4
	.incbin "rooms/ages/group3Tilesets.bin"
group4Tilesets: ; 0x116e4
group6Tilesets:
	.incbin "rooms/ages/group4Tilesets.bin"
group5Tilesets: ; 0x117e4
group7Tilesets:
	.incbin "rooms/ages/group5Tilesets.bin"
