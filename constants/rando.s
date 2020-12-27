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


; The defines below here modified by the randomizer.

.define RANDO_SEASONS_ITEM_D0_SWORD, TREASURE_OBJECT_SWORD_00
.define RANDO_SEASONS_ITEM_MAKU_TREE, TREASURE_OBJECT_GNARLED_KEY_00
