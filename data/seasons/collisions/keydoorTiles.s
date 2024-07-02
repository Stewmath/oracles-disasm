; This data is used by INTERACID_DUNGEON_KEY_SPRITE to determine what key sprite to use when opening
; locked doors.
;
; This does not make doors unlockable. See data/{game}/collisions/interactableTiles.s for that.
;
; Data format:
;   b0: tile index
;   b1: key type (0=small key, 1=boss key)

keyDoorGraphicTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
	.db $00
@collisions1:
	.db $ec $00 ; Subrosia key door
@collisions2:
@collisions3:
@collisions5:
	.db $00
@collisions4:
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
