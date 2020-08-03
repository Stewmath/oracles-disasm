; Each byte is for a room in the overworld.
;
; This behaves slightly differently in Seasons than Ages. Bit 7 has no special
; significance? Whenever transitioning between rooms of different "packs", a fadeout
; transition is triggered so that the season can change.

roomPackData:
	.incbin "rooms/seasons/roomPacks.bin"
