roomAreasGroupTable: ; 0x112d4
	.dw group0Areas
	.dw group1Areas
	.dw group2Areas
	.dw group3Areas
	.dw group4Areas
	.dw group5Areas
	.dw group6Areas
	.dw group7Areas

group0Areas: ; 0x112e4
	.incbin "rooms/ages/group0Areas.bin"
group1Areas: ; 0x113e4
	.incbin "rooms/ages/group1Areas.bin"
group2Areas: ; 0x114e4
	.incbin "rooms/ages/group2Areas.bin"
group3Areas: ; 0x115e4
	.incbin "rooms/ages/group3Areas.bin"
group4Areas: ; 0x116e4
group6Areas:
	.incbin "rooms/ages/group4Areas.bin"
group5Areas: ; 0x117e4
group7Areas:
	.incbin "rooms/ages/group5Areas.bin"
