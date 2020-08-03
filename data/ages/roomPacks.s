; Each byte is for a room in the present or past.
;
; Bits 0-6 represent the id of the room "pack". Rooms in the same pack have
; compatible graphics. Rooms in a different pack may need a full graphics
; reload in screen transitions, in the form of a "fadeout" transition. This
; might be used more in Seasons, in Ages almost everything is in pack $01.
;
; Value $7f has some special behaviour. Dunno what it does but it's used in the
; animal companion region.
;
; When bit 7 is set, the graphics must be reloaded when you leave the room
; pack. So the maku tree has bit 7 set and is in room pack $00. So when you go
; to any adjacent room, which are in a different pack ($01), the graphics will
; be fully reloaded.

roomPackData:
	.incbin "rooms/ages/roomPacksPresent.bin"
	.incbin "rooms/ages/roomPacksPast.bin"
