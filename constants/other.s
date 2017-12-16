; Room sizes (in 16x16 tiles)
.define LARGE_ROOM_WIDTH	$0f
.define LARGE_ROOM_HEIGHT	$0b
.define SMALL_ROOM_WIDTH	$0a
.define SMALL_ROOM_HEIGHT	$08

; Screen size (in 16x16 tiles, not accounting for status bar) (same as small rooms)
.define SCREEN_WIDTH		$0a
.define SCREEN_HEIGHT		$08

; Overworld size
.ifdef ROM_AGES
	.define OVERWORLD_WIDTH		14
	.define OVERWORLD_HEIGHT	14

	; The starting X/Y positions of the tile grid on the map screen
	.define OVERWORLD_MAP_START_X	3
	.define OVERWORLD_MAP_START_Y	2

.else; ROM_SEASONS
	.define OVERWORLD_WIDTH		16
	.define OVERWORLD_HEIGHT	16

	; Subrosia size (seasons only)
	.define SUBROSIA_WIDTH	7
	.define SUBROSIA_HEIGHT	11

	; The starting X/Y positions of the tile grid on the map screen.
	; TODO: need separate definitions for subrosia?
	.define OVERWORLD_MAP_START_X	2
	.define OVERWORLD_MAP_START_Y	1
.endif

; First 4 map groups are small
.define NUM_SMALL_GROUPS	$04
.define NUM_UNIQUE_GROUPS	$06
.define FIRST_SIDESCROLL_GROUP	$06

.define NUM_DUNGEONS		$10 ; Should be multiple of 8

; For wScrollMode
.define SCROLLMODE_01		$01
.define SCROLLMODE_02		$02

.define NUM_GASHA_SPOTS		$10

; Number of items the inventory can hold (not including A and B buttons)
.define INVENTORY_CAPACITY	$10


.ifdef ROM_AGES
	; Should be multiple of 8. Used for seed tree refill stuff
	.define NUM_SEED_TREES $10
.else; ROM_SEASONS
	.define NUM_SEED_TREES $08
.endif
