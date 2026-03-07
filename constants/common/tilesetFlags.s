; Bits for the wTilesetFlags variable.

.ifdef ROM_AGES

.define TILESETFLAG_PAST $80 ; Past or Subrosia (depending on game)
.DEFINE TILESETFLAG_BIT_PAST 7

.define TILESETFLAG_UNDERWATER $40
.DEFINE TILESETFLAG_BIT_UNDERWATER 6

.else; ROM_SEASONS

.define TILESETFLAG_SUBROSIA $80
.DEFINE TILESETFLAG_BIT_SUBROSIA 7

.define TILESETFLAG_40 $40 ; Unused
.DEFINE TILESETFLAG_BIT_40 6

.endif

.define TILESETFLAG_SIDESCROLL $20
.DEFINE TILESETFLAG_BIT_SIDESCROLL 5

; Set in large, indoor rooms (which aren't real dungeons, ie. ambi's palace). Seems to disable
; certain properties of dungeons? (Ages only?)
.define TILESETFLAG_LARGE_INDOORS $10
.DEFINE TILESETFLAG_BIT_LARGE_INDOORS 4

; This flag is set on dungeons, but also on any room which has a layout in the "Dungeons" tab, even
; if it's not a real dungeon (ie. ambi's palace). In that case "TILESETFLAG_LARGE_INDOORS" is also
; set.
.define TILESETFLAG_DUNGEON $08
.DEFINE TILESETFLAG_BIT_DUNGEON 3

.define TILESETFLAG_INDOORS $04
.DEFINE TILESETFLAG_BIT_INDOORS 2

; Hardcodes location on the minimap for maku tree screens. Ages only?
.define TILESETFLAG_MAKU $02
.DEFINE TILESETFLAG_BIT_MAKU 1

; Does various things, including enabling the companion to be called (though it must also have the
; correct entry in the "companionCallableRooms" table). In Ages this must be set for the minimap to
; update Link's position. In Seasons it just checks the group number instead (this is the case for
; several other things too).
.define TILESETFLAG_OUTDOORS $01
.DEFINE TILESETFLAG_BIT_OUTDOORS 0
