; For seasons, the "alt world" is subrosia.
;
; A bit in the corresponding table is set if that room should be marked as
; being in subrosia.
;
; Note: group 0 is actually never checked. Subrosia itself is group 1.

roomsInAltWorldTable:
	.dw roomsInAltWorldGroup0
	.dw roomsInAltWorldGroup1
	.dw roomsInAltWorldGroup2
	.dw roomsInAltWorldGroup3
	.dw roomsInAltWorldGroup4
	.dw roomsInAltWorldGroup5
	.dw roomsInAltWorldGroup6
	.dw roomsInAltWorldGroup7

roomsInAltWorldGroup0:
roomsInAltWorldGroup1:
roomsInAltWorldGroup2:
roomsInAltWorldGroup3:
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00110011
	dbrev %00000111 %00000010
	dbrev %11000000 %01001100
	dbrev %01100000 %00001100
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000


roomsInAltWorldGroup4:
roomsInAltWorldGroup6:
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000001
	dbrev %11100000 %01000000

roomsInAltWorldGroup5:
roomsInAltWorldGroup7:
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000010 %00000001
	dbrev %00000000 %00000000
	dbrev %00110000 %00000000
	dbrev %11111111 %11110000
