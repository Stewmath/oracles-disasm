; If you're looking to write scripts, this is the wrong file. This is for "simple scripts"
; that are hardly capable of doing anything.
;
; See the "interactionRunSimpleScript" function. Why does this even exist? The only extra
; opcode it has is "ss_setinterleavedtile", which seems to be used for opening- and
; closing-door animations.

.macro ss_end
	.db $00
.endm

.macro ss_wait
	.db $01 \1
.endm

.macro ss_playsound
	.db $02 \1
.endm

; param 1: position
; param 2: value
.macro ss_settile
	.db $03 \1 \2
.endm

; param 1: position
; param 2: tile 1
; param 3: tile 2
; param 4: how to mix the tiles (value from 0-3)
.macro ss_setinterleavedtile
	.db $04 \1 \2 \3 \4
.endm

.ifdef ROM_SEASONS
; param1: number of tiles
; param2: first tile position
; param3: tile
.macro ss_setrowoftiles
	.db $05 \1 \2 \3
.endm

.macro ss_ret1
	.db $06
.endm

; param1: number of tiles
; param2: first tile position
; param3: tile 2 (tile 1 is at param2)
; param4: how to mix the tiles (value from 0-3)
.macro ss_setrowofinterleavedtiles
	.db $07 \1 \2 \3 \4
.endm

.macro ss_ret2
	.db $08
.endm
.endif
