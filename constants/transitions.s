; Used for miniboss warps, maybe other things
.define TRANSITION_DEST_0		$0

; Use this most of the time. It's similar to DEST_0 but calls a few extra
; functions, stores link's respawn position?
.define TRANSITION_DEST_SET_RESPAWN	$1

; Use when link walks walks in from off the screen. Parameter can be $0 for
; up, $4 for down. Sets respawn.
.define TRANSITION_DEST_LEAVESCREEN		$3

; Same as TRANSITION_DEST_0.
.define TRANSITION_DEST_DONT_SET_RESPAWN	$4

; Fall onto the screen. Doesn't set respawn.
.define TRANSITION_DEST_FALL		$5

; Warp in and create a portal. Doesn't set respawn.
.define TRANSITION_DEST_TIMEWARP	$6

; Transition used in the beginning of the game. Sets respawn.
.define TRANSITION_DEST_SLOWFALL	$B

; Same as DEST_STANDARD but link is aligned 8 pixels to the left.
.define TRANSITION_DEST_X_SHIFTED	$E

; Same as DEST_0 but doesn't set link's facing direction for up/down stairs.
; Unused by the game's warp destinations, maybe hardcoded somewhere?
.define TRANSITION_DEST_UNKNOWN7	$7

; Duplicate of UNKNOWN_7.
.define TRANSITION_DEST_DUPLICATE7_1	$A

; Same as DEST_0 but link's direction gets set by the $cc50 variable.
.define TRANSITION_DEST_UNKNOWNC	$C

; Duplicate of UNKNOWN_7.
.define TRANSITION_DEST_DUPLICATE7_2	$D

; Link does not appear.
.define TRANSITION_DEST_INVISIBLE	$F



; Screen fades out, then back in.
.define TRANSITION_SRC_FADEOUT		$2

; Use when link walks walks off the screen. Parameter can be $0 for up, $4 for
; down.
.define TRANSITION_SRC_LEAVESCREEN	$3

; Screen instantly goes white, then uncovers the screen in columns.
.define TRANSITION_SRC_INSTANT		$4

; Does the subrosia transition from seasons.
.define TRANSITION_SRC_SUBROSIA		$8

; Fall out of the screen
.define TRANSITION_SRC_FALL		$9

.define TRANSITION_SRC_INVISIBLE	$F
