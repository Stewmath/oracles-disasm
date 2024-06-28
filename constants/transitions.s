; This handles "transitions" for both the source of the warp (where it was initiated) and the
; destination (where it's led to). They control how Link exists and enters the screen. The
; destination transition type may also set Link's respawn point.

; Both the TRANSITION_DEST and TRANSITION_SRC variables are written to the "wWarpTransition"
; variable at their respective times. Some values are only valid for the "source" transition, some
; are only valid for the "destination" transition, some are valid for both.

;;
; Basic warp. Used for miniboss warps, but other than that, it seems DEST_DONT_SET_RESPAWN is used
; instead.
.define TRANSITION_DEST_BASIC		$0

;;
; Use this most of the time. It's similar to DEST_BASIC, but updates Link's respawn point.
.define TRANSITION_DEST_SET_RESPAWN	$1

;;
; Link walks in from off the screen.
;
; Set both the "X" and "Y" values to "$f" to trigger special behaviour. If both are "$f" then Link
; will spawn at the top or bottom of the screen in the horizontal center. If only Y is "$f", then
; the X value will act normally.
;
; Set the "Parameter" value to "$9" to make him walk upward into the next screen (from the bottom),
; or to "$f" to make him walk downward into the next screen (from the top).
.define TRANSITION_DEST_ENTERSCREEN		$3

;;
; Same as DEST_BASIC (but this one is actually used).
.define TRANSITION_DEST_DONT_SET_RESPAWN	$4

;;
; Fall onto the screen. Doesn't update respawn.
.define TRANSITION_DEST_FALL		$5


.ifdef ROM_AGES
;;
; Warp in and create a portal. Doesn't update respawn. Ages only.
.define TRANSITION_DEST_TIMEWARP	$6

.else; ROM_SEASONS

;;
; Jumped in from a trampoline. Seasons only.
.define TRANSITION_DEST_FROM_TRAMPOLINE	$6

.endif

;;
; In Seasons only, this is used when falling into Holly's house.
; In Ages it's a duplicate of UNKNOWN_A (unused).
.define TRANSITION_DEST_FALL_INTO_HOLLYS_HOUSE	$7

;;
; The same as DEST_BASIC but doesn't set link's facing direction for up/down stairs. Seems unused.
.define TRANSITION_DEST_UNKNOWN_A	$a

;;
; Transition used in the beginning of the game. Updates respawn point.
.define TRANSITION_DEST_SLOWFALL	$b

;;
; Same as DEST_BASIC but link's direction gets set by the "wcc50" variable.
.define TRANSITION_DEST_UNKNOWN_C	$c

;;
; Duplicate of UNKNOWN_A.
;.define TRANSITION_DEST_DUPLICATE7_2	$d

;;
; Same as DEST_SET_RESPAWN but link is aligned 8 pixels to the left.
.define TRANSITION_DEST_X_SHIFTED	$e

;;
; Link does not appear.
.define TRANSITION_DEST_INVISIBLE	$f



;;
; Screen fades out before warping.
.define TRANSITION_SRC_FADEOUT		$2

;;
; Link walks off the screen.
.define TRANSITION_SRC_LEAVESCREEN	$3

;;
; Screen instantly turns white.
.define TRANSITION_SRC_INSTANT		$4

;;
; Subrosian portal-style warp. (The destination can be something generic like SET_RESPAWN. It seems
; to be affected by this.)
.define TRANSITION_SRC_SUBROSIA		$8

;;
; Fall out of the screen (like into a hole).
.define TRANSITION_SRC_FALL		$9
