; Each bit is set if a companion is callable in the corresponding room.
; In ages, this is for the present only (companions never callable in the past).

companionCallableRooms:
	dbrev %11000111 %00000000
	dbrev %00000111 %00000000
	dbrev %11010111 %11110000
	dbrev %11111111 %00111100
	dbrev %01011011 %11111100
	dbrev %11111111 %11111100
	dbrev %11111111 %11111100
	dbrev %11111111 %11111100
	dbrev %11111111 %11111100
	dbrev %11111111 %11011100
	dbrev %00000000 %10000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
