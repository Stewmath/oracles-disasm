; This is a list of room IDs (the low bytes only) where gasha spots are located.
;
; If this is not set correctly, the gasha tree may not appear after planting the seed
; (although it's possible that the nut will still be there, floating in midair?)
;
; In order to prevent the above scenario, it will also be necessary to adjust the
; "applyRoomSpecificTileChangesAfterGfxLoad" function such that these rooms load the gasha
; tree graphics.
;
; Note: since this file doesn't track the group numbers, it won't work properly if there
; are gasha spots on the same map in the past/present.
; ie. You can't have a gasha spot on both maps $050 and $150.

gashaSpotRooms:
	.db $05 ; subid: $00
	.db $2c ; subid: $01
	.db $30 ; subid: $02
	.db $7b ; subid: $03
	.db $90 ; subid: $04
	.db $ad ; subid: $05
	.db $cb ; subid: $06
	.db $d7 ; subid: $07
	.db $01 ; subid: $08
	.db $0a ; subid: $09
	.db $28 ; subid: $0a
	.db $34 ; subid: $0b
	.db $55 ; subid: $0c
	.db $95 ; subid: $0d
	.db $d0 ; subid: $0e
	.db $ca ; subid: $0f
