; Garbage data follows

.IFDEF BUILD_VANILLA

; Partial copy of @shipDirectionsPresent. The first few entries are missing.
@shipDirectionsPresentCopy:
	.db $d6 $28 DIR_UP
	.db $b6 $68 DIR_RIGHT
	.db $b8 $63 DIR_DOWN
	.db $d8 $23 DIR_RIGHT
	.db $d8 $25 DIR_UP
	.db $c8 $15 DIR_RIGHT
	.db $c8 $18 DIR_UP
	.db $a8 $68 DIR_LEFT
	.db $a8 $63 DIR_DOWN
	.db $b8 $43 DIR_LEFT
	.db $00

@shipDirectionsPastCopy:
	.db $b6 $34 DIR_DOWN
	.db $d6 $14 DIR_RIGHT
	.db $d7 $18 DIR_UP
	.db $c7 $58 DIR_LEFT
	.db $c7 $53 DIR_UP
	.db $b7 $33 DIR_LEFT
	.db $00

;;
; Garbage function, calls invalid addresses, who knows what it was supposed to do.
func_7f55:
	ld a,(wPirateShipRoom)
	ld e,a
	ld hl,@data2
	call $1e43
	ret c

	ld hl,@data
	call $19c0
	jr z,+

	ld a,$04
	rst_addAToHl
+
	ld b,$04
	ld de,wPirateShipRoom
	jp $048b

@data:
	.db $b6 $48
	.db $48 $02
	.db $b6 $58
	.db $78 $02
@data2:
	.db $a8 $00
	.db $b6 $00
	.db $b7 $00
	.db $b8 $00
	.db $c6 $00
	.db $c7 $00
	.db $c8 $00
	.db $d6 $00
	.db $d7 $00
	.db $d8 $00
	.db $00

;;
; Another garbage function calling invalid addresses
func_7f90:
	callab $03 $7d20
	call $1aca
	jp $34ad

@data:
	.db $78 $02 $a8 $00 $b6 $00 $b7 $00
	.db $b8 $00 $c6 $00 $c7 $00 $c8 $00
	.db $d6 $00 $d7 $00 $d8 $00 $00

;;
; Another garbage function calling invalid addresses
func_7fb5:
	callab $03 $7d20
	call $1ae4
	jp $34c7

.endif ; BUILD_VANILLA
