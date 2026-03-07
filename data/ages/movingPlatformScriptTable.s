.macro plat_wait
	.db $00, \1
.endm
.macro plat_move
	.db $01, \1
.endm
.macro plat_setangle
	.db $02, \1
.endm
.macro plat_setspeed
	.db $03, \1
.endm
.macro plat_jump
	.db $04, (\1-CADDR)&$ff
.endm
.macro plat_waitforlink
	.db $05
.endm
.macro plat_up
	.db $08, \1
.endm
.macro plat_right
	.db $09, \1
.endm
.macro plat_down
	.db $0a, \1
.endm
.macro plat_left
	.db $0b, \1
.endm

movingPlatform_scriptTable:
	.dw @dungeon00
	.dw @dungeon01
	.dw @dungeon02
	.dw @dungeon03
	.dw @dungeon04
	.dw @dungeon05
	.dw @dungeon06
	.dw @dungeon07
	.dw @dungeon08


@dungeon00:
@dungeon01:
	.dw @@platform0
	.dw @@platform1

@@platform0:
	plat_wait  $08
	plat_up    $80
	plat_wait  $08
	plat_down  $80
	plat_jump @@platform0

@@platform1:
	plat_wait  $08
	plat_left  $40
--
	plat_wait  $08
	plat_right $80
	plat_wait  $08
	plat_left  $80
	plat_jump --


@dungeon02:
@dungeon03:
@dungeon04:
	.dw @@platform0
	.dw @@platform1
	.dw @@platform2
	.dw @@platform3
	.dw @@platform4
	.dw @@platform5

@@platform0:
	plat_wait  $08
	plat_up    $60
--
	plat_wait  $08
	plat_down  $a0
	plat_wait  $08
	plat_up    $a0
	plat_jump --

@@platform1:
	plat_wait  $08
	plat_up    $20
--
	plat_wait  $08
	plat_down  $c0
	plat_wait  $08
	plat_up    $c0
	plat_jump --

@@platform2:
	plat_wait  $08
	plat_up    $40
--
	plat_wait  $08
	plat_down  $a0
	plat_wait  $08
	plat_up    $a0
	plat_jump --

@@platform3:
	plat_wait  $08
	plat_right $20
--
	plat_wait  $08
	plat_left  $c0
	plat_wait  $08
	plat_right $c0
	plat_jump --

@@platform4:
	plat_wait  $08
	plat_down  $60
	plat_wait  $08
	plat_up    $60
	plat_jump @@platform4

@@platform5:
	plat_wait  $08
	plat_left  $20
--
	plat_wait  $08
	plat_right $a0
	plat_wait  $08
	plat_left  $a0
	plat_jump --

@dungeon05:
@dungeon06:
@dungeon07:
@dungeon08:
