; Bitset of valid targets for bombchus. Each bit corresponds to one enemy ID.
bombchuTargets:
        ; Enemies $00 to $0f
        dbrev %00000000 %11111100
        ; Enemies $10 to $1f
        dbrev %11101001 %10111110
        ; Enemies $20 to $2f
        dbrev %11111100 %00001100
        ; Enemies $30 to $3f
        dbrev %11101100 %00111110
        ; Enemies $40 to $4f
        dbrev %10010111 %11110111
        ; Enemies $50 to $5f
        dbrev %01000000 %00000010
        ; Enemies $60 to $6f
        dbrev %00000000 %00000000
        ; Enemies $70 to $7f
        dbrev %11000000 %00000000
