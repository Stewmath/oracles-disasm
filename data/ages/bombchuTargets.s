; Bitset of valid targets for bombchus. Each bit corresponds to one enemy ID.
bombchuTargets:
	; Enemies $00 to $0f
	dbrev %00000000 %11111101
	; Enemies $10 to $1f
	dbrev %11101001 %10111111
	; Enemies $20 to $2f
	dbrev %11111100 %00001100
	; Enemies $30 to $3f
	dbrev %11101100 %00111111
	; Enemies $40 to $4f
	dbrev %10110101 %11110111
	; Enemies $50 to $5f
	dbrev %01001100 %00000010
	; Enemies $60 to $6f
	dbrev %00001000 %00000000
	; Enemies $70 to $7f
	dbrev %00000000 %00000000
