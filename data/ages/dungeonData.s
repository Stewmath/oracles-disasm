dungeonDataTable: ; $4d2a
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
	.dw dungeonData0c
	.dw dungeonData0d
	.dw dungeonData0e
	.dw dungeonData0f

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
dungeonData00: ; $4d4a
	.db >wGroup4Flags $04 $00 $01 $03 $00 $01 $00
dungeonData01: ; $4d52
	.db >wGroup4Flags $24 $02 $01 $03 $03 $00 $00
dungeonData02: ; $4d5a
	.db >wGroup4Flags $46 $03 $02 $02 $01 $00 $00
dungeonData03: ; $4d62
	.db >wGroup4Flags $66 $05 $02 $02 $00 $00 $00
dungeonData04: ; $4d6a
	.db >wGroup4Flags $91 $07 $02 $02 $07 $00 $00
dungeonData05: ; $4d72
	.db >wGroup4Flags $bb $09 $02 $02 $01 $00 $00
dungeonData06: ; $4d7a
	.db >wGroup5Flags $26 $0e $01 $03 $07 $00 $00
dungeonData07: ; $4d82
	.db >wGroup5Flags $56 $11 $03 $03 $00 $00 $00
dungeonData08: ; $4d8a
	.db >wGroup5Flags $aa $14 $04 $00 $00 $00 $00
dungeonData09: ; $4d92
	.db >wGroup4Flags $01 $00 $01 $03 $00 $00 $00
dungeonData0a: ; $4d9a
	.db >wGroup5Flags $f4 $19 $01 $03 $00 $00 $00
dungeonData0b: ; $4da2
	.db >wGroup4Flags $ce $0b $02 $02 $00 $00 $00
dungeonData0c: ; $4daa
	.db >wGroup5Flags $44 $0f $02 $02 $00 $00 $00
dungeonData0d: ; $4db2
	.db >wGroup4Flags $04 $01 $01 $03 $00 $00 $00
dungeonData0e: ; $4dba
	.db >wGroup5Flags $ce $18 $01 $03 $00 $00 $00
dungeonData0f: ; $4dc2
	.db >wGroup4Flags $ce $0d $01 $03 $00 $00 $00
