; Dev ring is a fake ring that enables debug features. This is $80 instead of $40 like in the
; original randomizer, because bit 6 is used to temporarily disable rings while remembering what
; ring you should have equipped (while fighting blaino).
.define DEV_RING $80

; Values for "collect mode" (override for the 1st byte in the treasure object data)
.define COLLECT_MODE_PICKUP_ALT,           $02
.define COLLECT_MODE_PICKUP,               $0a
.define COLLECT_MODE_POOF,                 $1a
.define COLLECT_MODE_FALL_KEY,             $28
.define COLLECT_MODE_FALL,                 $29
.define COLLECT_MODE_CHEST_NOFLAG,         $30
.define COLLECT_MODE_CHEST,                $38
.define COLLECT_MODE_DIVE,                 $49
.define COLLECT_MODE_CHEST_MAP_OR_COMPASS, $68


; Certain randomized slots (ie. maku tree screen) borrow unused treasure flags for remembering if
; they have been obtained.
.define RANDO_MAKU_TREE_FLAG, TREASURE_SWITCH_HOOK_HELPER
