; This data is used by INTERAC_DUNGEON_KEY_SPRITE to determine what key sprite to use when opening
; locked doors.
;
; This does not make doors unlockable. See data/{game}/tile_properties/interactableTiles.s for that.
;
; Data format:
;   b0: tile index
;   b1: key type (0=small key, 1=boss key)

keyDoorGraphicTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

@overworld:
	.db $00

@subrosia:
	.db $ec $00 ; Subrosia key door

@makutree:
@indoors:
@sidescrolling:
	.db $00

@dungeons:
	.db $1e $00 ; Keyblock
	.db $70 $00 ; Small key doors
	.db $71 $00
	.db $72 $00
	.db $73 $00
	.db $74 $01 ; Boss key doors
	.db $75 $01
	.db $76 $01
	.db $77 $01
	.db $00
