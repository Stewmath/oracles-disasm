; This is a barebones "scripting language" used for objects that move in a simple pattern.
; Non-interaction objects can use this, which is probably the only reason it exists.
;
; Used by ambi guards, sidescrolling platforms, some other things?
;
; An object can load such a script with "objectLoadMovementScript", and run it each frame
; with "objectRunMovementScript". It assumes that the object's states $08-$0b move
; up/right/down/left, respectively, and state $0c is for "waiting".
;
; Using this type of script reserves the object's var30/var31 to save the script's
; address. It also writes the Y-destination to var32, and the X-destination to var33.

; Used for looping patrols
.macro ms_loop
	.db $00
	.dw \1
.endm

; Parameter 1: Dest y-position
.macro ms_up ; Goes to state 8
	.db $01 \1
.endm

; Parameter 1: Dest x-position
.macro ms_right ; Goes to state 9
	.db $02 \1
.endm

; Parameter 1: Dest y-position
.macro ms_down ; Goes to state $0a
	.db $03 \1
.endm

; Parameter 1: Dest x-position
.macro ms_left ; Goes to state $0b
	.db $04 \1
.endm

; Parameter 1: counter1 (frames to wait)
.macro ms_wait ; Goes to state $0c
	.db $05, \1
.endm

; Parameter 1: counter1
; Parameter 2: state to change to
.macro ms_state
	.db $06, \1, \2
.endm
