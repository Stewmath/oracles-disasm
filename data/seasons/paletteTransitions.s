; This file deals with "smooth palette transitions" between rooms, ie. at the entrance to
; the graveyard.
;
; Data format: (differs in ages)
; b0: direction (or $ff to end)
; b1: room index
; b2: source palette index for "paletteTransitionSeasonData"
; b3: destination palette index for "paletteTransitionSeasonData"
;
; Note: Byte 0 is the direction Link MOVES INTO the room, not where he ENTERS FROM.


paletteTransitionSeasonData:
	; $00
	.dw paletteData49b0 ; SEASON_SPRING
	.dw paletteData49e0 ; SEASON_SUMMER
	.dw paletteData4a10 ; SEASON_FALL
	.dw paletteData4a40 ; SEASON_WINTER

	; $01
	.dw paletteData4a70
	.dw paletteData4aa0
	.dw paletteData4ad0
	.dw paletteData4b00

	; $02
	.dw paletteData4da0
	.dw paletteData4dd0
	.dw paletteData4e00
	.dw paletteData4e30

	; $03
	.dw paletteData4f20
	.dw paletteData4f50
	.dw paletteData4f80
	.dw paletteData4fb0

	; $04
	.dw paletteData50a0
	.dw paletteData50d0
	.dw paletteData5100
	.dw paletteData5130

	; $05
	.dw paletteData5160
	.dw paletteData5190
	.dw paletteData51c0
	.dw paletteData51f0



paletteTransitionIndexData:
	.dw @group0
	.dw @group1

@group0: ; Overworld
	.db $e0 DIR_UP   $00 $03 ; Graveyard
	.db $f0 DIR_DOWN $03 $00
	.db $63 DIR_UP   $01 $02 ; Tarm ruins (unused due to fadeout transition)
	.db $73 DIR_DOWN $02 $01
	.db $83 DIR_UP   $00 $01 ; Holodrum plain <-> spool swamp (unused)
	.db $93 DIR_DOWN $01 $00
	.db $23 DIR_UP   $04 $05 ; Onox's castle entrance
	.db $33 DIR_DOWN $05 $04
	.db $00 $ff

@group1: ; Subrosia
	.db $00 $ff
