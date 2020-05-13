; Each bit is set if a companion is callable in the corresponding room.
; In ages, this is for the present only (companions never callable in the past).

companionCallableRooms:
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000111 %11111000
	dbrev %00001101 %11100000
	dbrev %11101101 %11100000
	dbrev %11111111 %11101111
	dbrev %10111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111000
	dbrev %11111111 %10111000
	dbrev %00011111 %11110000
	dbrev %00011111 %11110000
	dbrev %00011111 %11000000
