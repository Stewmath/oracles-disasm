dungeonDataTable: ; $4cc5
	.dw dungeonData00
	.dw dungeonData01
	.dw dungeonData02
	.dw dungeonData03
	.dw dungeonData04
	.dw dungeonData05
	.dw dungeonData06
	.dw dungeonData07
	.dw dungeonData08
	.dw dungeonData09
	.dw dungeonData0a
	.dw dungeonData0b

; Bytes:
; 0: High byte of flag address.
; 1: Which room wallmasters send you to
; 2: wDungeonFirstLayout
; 3: wDungeonNumFloors
; 4: Base floor number plus 3 (if zero, the first floor is "B3")
;    This only affects how the map names the floor.
; 5: Bitset of floors that are unlocked on the map when you get the compass.
;    Again, this only affects the map.
; 6-7: Unused?
dungeonData00:
	.db >wGroup4Flags $04 $00 $01 $03 $00 $00 $00
dungeonData01:
	.db >wGroup4Flags $1c $01 $01 $03 $03 $00 $00
dungeonData02:
	.db >wGroup4Flags $39 $02 $01 $03 $01 $00 $00
dungeonData03:
	.db >wGroup4Flags $4b $03 $02 $02 $00 $00 $00
dungeonData04:
	.db >wGroup4Flags $81 $05 $03 $02 $07 $00 $00
dungeonData05:
	.db >wGroup4Flags $a7 $08 $01 $03 $01 $00 $00
dungeonData06:
	.db >wGroup4Flags $ba $09 $05 $03 $07 $00 $00
dungeonData07:
	.db >wGroup5Flags $5b $0f $03 $01 $00 $00 $00
dungeonData08:
	.db >wGroup5Flags $87 $12 $02 $02 $00 $00 $00
dungeonData09:
	.db >wGroup5Flags $97 $14 $01 $03 $00 $00 $00
dungeonData0a:
	.db >wGroup5Flags $9d $15 $01 $03 $00 $00 $00
dungeonData0b:
	.db >wGroup5Flags $30 $0e $01 $03 $00 $00 $00
