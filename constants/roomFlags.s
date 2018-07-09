; These are bits which can be set for a room in wPresentRoomFlags,
; wPastRoomFlags, etc.

; Many of these flags can be used for basically any purpose, but there are
; a few standardized purposes.

; Generic names
.define ROOMFLAG_01	$01
.define ROOMFLAG_02	$02
.define ROOMFLAG_04	$04
.define ROOMFLAG_08	$08
.define ROOMFLAG_10	$10
.define ROOMFLAG_20	$20
.define ROOMFLAG_40	$40
.define ROOMFLAG_80	$80

; For all collision modes
.define ROOMFLAG_VISITED		$10
.define ROOMFLAG_ITEM			$20 ; Item obtained / chest opened

; Overworlds only
.define ROOMFLAG_LAYOUTSWAP		$01
.define ROOMFLAG_PORTALSPOT_DISCOVERED	$08

; Dungeons and indoors only (collision modes 1 and 2)
; These following 4 are set when corresponding key doors are opened.
; They also apply to bombable walls in those directions.
; Setting any of these bits in a dungeon will indicate on the map that one can move in the
; corresponding direction.
.define ROOMFLAG_KEYDOOR_UP	$01
.define ROOMFLAG_KEYDOOR_RIGHT	$02
.define ROOMFLAG_KEYDOOR_DOWN	$04
.define ROOMFLAG_KEYDOOR_LEFT	$08

; Dungeons only (collision mode 2)
; Bit 7 has purposes including:
;  - Whether a keyblock has been unlocked in the room
;  - Whether a set of stairs has appeared
;  - Whether a boss in the room has been defeated
; (See also the "applyStandardTileSubstitutions" function.)
.define ROOMFLAG_KEYBLOCK	$80


.define ROOMFLAG_BIT_VISITED	4
.define ROOMFLAG_BIT_ITEM	5
.define ROOMFLAG_BIT_40		6
.define ROOMFLAG_BIT_80		7

.define ROOMFLAG_BIT_LAYOUTSWAP			0
.define ROOMFLAG_BIT_PORTALSPOT_DISCOVERED	3

.define ROOMFLAG_BIT_KEYDOOR_UP			0
.define ROOMFLAG_BIT_KEYDOOR_RIGHT		1
.define ROOMFLAG_BIT_KEYDOOR_DOWN		2
.define ROOMFLAG_BIT_KEYDOOR_LEFT		3

.define ROOMFLAG_BIT_KEYBLOCK			7
