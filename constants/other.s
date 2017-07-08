; Room sizes (in 16x16 tiles)
.define LARGE_ROOM_WIDTH	$0f
.define LARGE_ROOM_HEIGHT	$0b
.define SMALL_ROOM_WIDTH	$0a
.define SMALL_ROOM_HEIGHT	$08

; Screen size (in 16x16 tiles, not accounting for status bar) (same as small rooms)
.define SCREEN_WIDTH		$0a
.define SCREEN_HEIGHT		$08

; Overworld size
.define OVERWORLD_WIDTH		14
.define OVERWORLD_HEIGHT	14

; First 4 map groups are small
.define NUM_SMALL_GROUPS	$04
.define NUM_UNIQUE_GROUPS	$06
.define FIRST_SIDESCROLL_GROUP	$06

; For wScrollMode
.define SCROLLMODE_01		$01
.define SCROLLMODE_02		$02

.define NUM_GASHA_SPOTS		$10

; Number of items the inventory can hold (not including A and B buttons)
.define INVENTORY_CAPACITY	$10

.define NUM_RINGS		$40
