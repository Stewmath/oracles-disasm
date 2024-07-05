dungeonDataTable:
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
; 2: Address of dungeon layout (this gets converted to an index relative to the
;    "dungeonLayoutDataStart" label)
; 3: wDungeonNumFloors
; 4: Base floor number plus 3 (if zero, the first floor is "B3")
;    This only affects how the map names the floor.
; 5: Bitset of floors that are unlocked on the map when you get the compass.
;    Again, this only affects the map.
; 6-7: Unused?

dungeonData00:
	m_DungeonData >wGroup4RoomFlags, $04, dungeon00Layout, $01, $03, $00, $00, $00
dungeonData01:
	m_DungeonData >wGroup4RoomFlags, $1c, dungeon01Layout, $01, $03, $03, $00, $00
dungeonData02:
	m_DungeonData >wGroup4RoomFlags, $39, dungeon02Layout, $01, $03, $01, $00, $00
dungeonData03:
	m_DungeonData >wGroup4RoomFlags, $4b, dungeon03Layout, $02, $02, $00, $00, $00
dungeonData04:
	m_DungeonData >wGroup4RoomFlags, $81, dungeon04Layout, $03, $02, $07, $00, $00
dungeonData05:
	m_DungeonData >wGroup4RoomFlags, $a7, dungeon05Layout, $01, $03, $01, $00, $00
dungeonData06:
	m_DungeonData >wGroup4RoomFlags, $ba, dungeon06Layout, $05, $03, $07, $00, $00
dungeonData07:
	m_DungeonData >wGroup5RoomFlags, $5b, dungeon07Layout, $03, $01, $00, $00, $00
dungeonData08:
	m_DungeonData >wGroup5RoomFlags, $87, dungeon08Layout, $02, $02, $00, $00, $00
dungeonData09:
	m_DungeonData >wGroup5RoomFlags, $97, dungeon09Layout, $01, $03, $00, $00, $00
dungeonData0a:
	m_DungeonData >wGroup5RoomFlags, $9d, dungeon0aLayout, $01, $03, $00, $00, $00
dungeonData0b:
	m_DungeonData >wGroup5RoomFlags, $30, dungeon0bLayout, $01, $03, $00, $00, $00
