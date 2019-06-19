; Room sizes (in 16x16 tiles)
; LARGE_ROOM_WIDTH/LARGE_ROOM_HEIGHT shouldn't be increased because it could overflow into
; buffers used immediately after the room layout in RAM.
.define LARGE_ROOM_WIDTH	$0f
.define LARGE_ROOM_HEIGHT	$0b
.define SMALL_ROOM_WIDTH	$0a
.define SMALL_ROOM_HEIGHT	$08

; Screen size (in 16x16 tiles, not accounting for status bar) (same as small rooms)
.define SCREEN_WIDTH		$0a
.define SCREEN_HEIGHT		$08

; Amount used for heart reflils (great fairy)
.define MAX_LINK_HEALTH		$40

; Overworld size
.ifdef ROM_AGES
	.define OVERWORLD_WIDTH		14
	.define OVERWORLD_HEIGHT	14

	; The starting X/Y positions of the tile grid on the map screen
	.define OVERWORLD_MAP_START_X	3
	.define OVERWORLD_MAP_START_Y	2

	; The first index at which to move popups on the map screen to the opposite side
	; of the screen. Ie. when cursor X is from 0-7 it's on the right; from 8-15 it's
	; on the left.
	.define OVERWORD_MAP_POPUP_SHIFT_INDEX_X	8
	.define OVERWORD_MAP_POPUP_SHIFT_INDEX_Y	8

	.define NUM_DUNGEONS		$10
	.define NUM_DUNGEONS_DIV_8	2 ; Above value divided by 8, rounded up

.else; ROM_SEASONS
	.define OVERWORLD_WIDTH		16
	.define OVERWORLD_HEIGHT	16

	; The starting X/Y positions of the tile grid on the map screen.
	.define OVERWORLD_MAP_START_X	2
	.define OVERWORLD_MAP_START_Y	1

	.define OVERWORD_MAP_POPUP_SHIFT_INDEX_X	8
	.define OVERWORD_MAP_POPUP_SHIFT_INDEX_Y	8

	; Subrosia size (seasons only)
	.define SUBROSIA_WIDTH	11
	.define SUBROSIA_HEIGHT	8

	.define SUBROSIA_MAP_START_X	4
	.define SUBROSIA_MAP_START_Y	5

	.define SUBROSIA_MAP_POPUP_SHIFT_INDEX_X	5
	.define SUBROSIA_MAP_POPUP_SHIFT_INDEX_Y	4

	.define NUM_DUNGEONS		$0c
	.define NUM_DUNGEONS_DIV_8	2 ; Above value divided by 8, rounded up
.endif

; First 4 map groups are small
.define NUM_SMALL_GROUPS	$04
.define NUM_UNIQUE_GROUPS	$06
.define FIRST_SIDESCROLL_GROUP	$06

; For wScrollMode
.define SCROLLMODE_01		$01
.define SCROLLMODE_02		$02
.define SCROLLMODE_04		$04
.define SCROLLMODE_08		$08

.define NUM_GASHA_SPOTS		$10

; Number of items the inventory can hold (not including A and B buttons)
.define INVENTORY_CAPACITY	$10


.ifdef ROM_AGES
	; Should be multiple of 8. Used for seed tree refill stuff
	.define NUM_SEED_TREES $10
.else; ROM_SEASONS
	.define NUM_SEED_TREES $08
.endif


; Bits for wDisabledObjects
.define DISABLE_LINK			$01
.define DISABLE_INTERACTIONS		$02
.define DISABLE_ENEMIES			$04
.define DISABLE_8			$08
.define DISABLE_ITEMS			$10
.define DISABLE_COMPANION		$20
.define DISABLE_40			$40
.define DISABLE_ALL_BUT_INTERACTIONS	$80


; Room indices

.ifdef ROM_AGES
	.define GANON_ROOM $5f5
	; TODO: twinrova room
.else; ROM_SEASONS
	.define GANON_ROOM $59e
.endif
