; For ages, the "alt world" is the past.
;
; Indoor rooms don't appear to rely on the area flags to tell if they're in the
; past; they have this room-based table to determine that.
;
; A bit in the corresponding table is set if that room should be marked as
; being in the past.
;
; Note: group 0 is actually never checked.

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
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000

roomsInAltWorldGroup2:
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000001
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000001
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000010
	dbrev %00000000 %00000010
	dbrev %00010000 %10000001
	dbrev %00000001 %10001001

roomsInAltWorldGroup3:
	dbrev %00000000 %00000001
	dbrev %00000000 %00000001
	dbrev %00000000 %00000001
	dbrev %00000000 %00000000 
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000 
	dbrev %00000000 %00000011
	dbrev %00000000 %00000011 
	dbrev %00000000 %00000001
	dbrev %00000000 %00000000 
	dbrev %00000000 %00000001
	dbrev %00000000 %00000011 
	dbrev %00000000 %00000001
	dbrev %00000000 %00000001 
	dbrev %00000111 %01000000
	dbrev %00000000 %00101011 

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
	dbrev %11111111 %11111111 
	dbrev %11111101 %11111111
	dbrev %11111111 %11111111 

roomsInAltWorldGroup5:
roomsInAltWorldGroup7:
	dbrev %00000111 %11100000
	dbrev %00000000 %00000000 
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000 
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000 
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000 
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000 
	dbrev %00000000 %00000110
	dbrev %11111100 %00000000 
	dbrev %00011110 %01111110
	dbrev %01111110 %00000011 
	dbrev %11001110 %11111000
	dbrev %00000011 %11110000 
