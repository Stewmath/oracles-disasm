; Tiles in normal areas

.define TILEINDEX_UNLIT_TORCH		$08
.define TILEINDEX_LIT_TORCH		$09
.define TILEINDEX_GASHA_TREE_TL		$4e
.define TILEINDEX_CONVEYOR_UP		$54
.define TILEINDEX_CONVEYOR_RIGHT	$55
.define TILEINDEX_CONVEYOR_DOWN		$56
.define TILEINDEX_CONVEYOR_LEFT		$57
.define TILEINDEX_TRACK_TL		$59
.define TILEINDEX_TRACK_BR		$5a
.define TILEINDEX_TRACK_BL		$5b
.define TILEINDEX_TRACK_TR		$5c
.define TILEINDEX_TRACK_HORIZONTAL	$5d
.define TILEINDEX_TRACK_VERTICAL	$5e
.define TILEINDEX_MINECART_PLATFORM	$5f
.define TILEINDEX_MYSTICAL_TREE_TL	$6e
.define TILEINDEX_MINECART_DOOR_UP	$7c
.define TILEINDEX_MINECART_DOOR_RIGHT	$7d
.define TILEINDEX_MINECART_DOOR_DOWN	$7e
.define TILEINDEX_MINECART_DOOR_LEFT	$7f
.define TILEINDEX_STANDARD_FLOOR	$a0 ; Keyblocks and such will turn into this tile
.define TILEINDEX_SOFT_SOIL		$d2
.define TILEINDEX_GRAVE_HIDING_DOOR	$d9
.define TILEINDEX_SOMARIA_BLOCK		$da
.define TILEINDEX_SWITCH_DIAMOND	$db
.define TILEINDEX_STAIRCASE		$dc
.define TILEINDEX_CHEST_OPENED		$f0
.define TILEINDEX_CHEST			$f1
.define TILEINDEX_SIGN			$f2
.define TILEINDEX_HOLE			$f3
.define TILEINDEX_SOFT_SOIL_PLANTED	$f5
.define TILEINDEX_GRASS			$f8
.define TILEINDEX_PUDDLE		$f9
.define TILEINDEX_DEEP_WATER		$fc

; Tiles in sidescrolling areas
.define TILEINDEX_SS_SPIKE		$02

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
