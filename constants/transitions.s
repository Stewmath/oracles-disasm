; Used for miniboss warps, maybe other things
.define TRANSITION_DEST_0		$0

; Use this most of the time. It's similar to DEST_0 but calls a few extra
; functions, stores link's respawn position?
.define TRANSITION_DEST_STANDARD	$1

; Screen fades out, then back in.
.define TRANSITION_SRC_FADEOUT		$2

; Works for SRC and DEST. Use when link walks off the screen, or walks in from
; off the screen. Parameter can be $0 for up, $4 for down.
.define TRANSITION_LEAVESCREEN		$3

; Screen instantly goes white, then uncovers the screen in columns.
; Can also be used by destinations for some reason, in this case it's the same
; as DEST_0.
.define TRANSITION_SRC_INSTANT		$4

; Fall onto the screen
.define TRANSITION_DEST_FALL		$5

; Warp in and create a portal
.define TRANSITION_DEST_TIMEWARP	$6

; Same as DEST_0 but doesn't set link's facing direction for up/down stairs.
; Unused by the game's warp destinations, maybe hardcoded somewhere?
.define TRANSITION_DEST_UNKNOWN7	$7

; Does the subrosia transition from seasons.
.define TRANSITION_SRC_SUBROSIA		$8

; Fall out of the screen
.define TRANSITION_SRC_FALL		$9

; Duplicate of UNKNOWN_7.
.define TRANSITION_DEST_DUPLICATE7_1	$A

; Transition used in the beginning of the game
.define TRANSITION_DEST_SLOWFALL	$B

; Same as DEST_0 but link's direction gets set by the $cc50 variable.
.define TRANSITION_DEST_FADEIN_3	$C

; Duplicate of UNKNOWN_7.
.define TRANSITION_DEST_DUPLICATE7_2	$D

; Same as DEST_STANDARD but link is aligned 8 pixels to the left.
.define TRANSITION_DEST_X_SHIFTED	$E

; Link does not appear.
.define TRANSITION_INVISIBLE		$F
