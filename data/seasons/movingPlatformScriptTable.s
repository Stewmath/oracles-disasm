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

movingPlatform_nonDungeonScriptTable:
	.dw movingPlatform_nonDungeon00
	.dw movingPlatform_nonDungeon01
	.dw movingPlatform_nonDungeon02

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
@dungeon02:
@dungeon05:
	.dw @@platform0
	.dw @@platform1
	.dw @@platform2
	.dw @@platform3
	.dw @@platform4
	.dw @@platform5
	.dw @@platform6

@@platform0:
	plat_wait  $10
	plat_left  $40
--
	plat_wait  $10
	plat_right $a0
	plat_wait  $10
	plat_left  $a0
	plat_jump --

@@platform1:
	plat_wait  $10
	plat_up    $40
--
	plat_wait  $10
	plat_down  $a0
	plat_wait  $10
	plat_up    $a0
	plat_jump --

@@platform2:
	plat_wait  $10
	plat_right $40
--
	plat_wait  $10
	plat_left  $a0
	plat_wait  $10
	plat_right $a0
	plat_jump --

@@platform3:
	plat_setspeed $28
	plat_wait  $20
	plat_left  $40
--
	plat_wait  $20
	plat_right $50
	plat_wait  $20
	plat_left  $50
	plat_jump --

@@platform4:
	plat_right $c0
--
	plat_wait  $10
	plat_left  $e0
	plat_wait  $10
	plat_right $e0
	plat_jump --

@@platform5:
	plat_left  $50
--
	plat_wait  $10
	plat_right $e0
	plat_wait  $10
	plat_left  $e0
	plat_jump --

@@platform6:
	plat_right $50
--
	plat_wait  $10
	plat_left  $e0
	plat_wait  $10
	plat_right $e0
	plat_jump --

@dungeon03:
	.dw @@platform00
	.dw @@platform01
	.dw @@platform02

@@platform00:
	plat_right $40
--
	plat_wait  $20
	plat_left  $80
	plat_wait  $20
	plat_right $80
	plat_jump --

@@platform01:
	plat_down  $60
--
	plat_wait  $08
	plat_up    $c0
	plat_wait  $08
	plat_down  $c0
	plat_jump --

@@platform02:
	plat_left  $60
	plat_wait  $20
	plat_right $60
	plat_wait  $20
	plat_jump @@platform02

@dungeon04:
	.dw @@platform00

@@platform00:
	plat_setspeed $50
--
	plat_wait  $3c
	plat_left  $30
	plat_up    $38
	plat_left  $28
	plat_down  $38
	plat_right $28
	plat_up    $38
	plat_right $28
	plat_wait  $3c
	plat_down  $18
	plat_right $08
	plat_down  $20
	plat_jump --

@dungeon06:
	.dw @@platform00
	.dw @@platform01
	.dw @@platform02
	.dw @@platform03
	.dw @@platform04
	.dw @@platform05
	.dw @@platform06
	.dw @@platform07
	.dw @@platform08
	.dw @@platform09

@@platform00:
	plat_right $60
	plat_wait  $10
	plat_left  $60
	plat_wait  $10
	plat_jump @@platform00

@@platform01:
	plat_down  $80
	plat_wait  $10
	plat_up    $80
	plat_wait  $10
	plat_jump @@platform01

@@platform02:
@@platform03:
	plat_up    $20
	plat_wait  $10
	plat_down  $20
	plat_wait  $10
	plat_jump @@platform02

@@platform04:
	plat_up    $a0
	plat_wait  $10
	plat_down  $a0
	plat_wait  $10
	plat_jump @@platform04

@@platform05:
	plat_up    $c0
	plat_wait  $10
	plat_down  $c0
	plat_wait  $10
	plat_jump @@platform05

@@platform06:
@@platform07:
	plat_left  $60
	plat_wait  $10
	plat_right $60
	plat_wait  $10
	plat_jump @@platform06

@@platform08:
	plat_down  $e0
	plat_wait  $10

@@platform09:
	plat_up    $e0
	plat_wait  $10
	plat_jump @@platform08

@dungeon07:
	.dw @@platform00
	.dw @@platform01
	.dw @@platform02
	.dw @@platform03
	.dw @@platform04
	.dw @@platform05

@@platform00:
	plat_setspeed $50
--
	plat_wait  $3c
	plat_down  $20
	plat_left  $48
	plat_up    $20
	plat_right $18
	plat_down  $08
	plat_right $18
	plat_up    $18
	plat_wait  $28
	plat_down  $18
	plat_left  $18
	plat_up    $08
	plat_left  $18
	plat_down  $20
	plat_right $48
	plat_up    $20
	plat_jump --

@@platform01:
	plat_wait  $08
	plat_right $80
	plat_wait  $08
	plat_left  $80
	plat_jump @@platform01

@@platform02:
	plat_setspeed $50
--
	plat_wait  $08
	plat_left  $38
	plat_wait  $08
	plat_up    $30
	plat_wait  $08
	plat_right $38
	plat_wait  $08
	plat_down  $30
	plat_jump --

@@platform03:
	plat_down  $60
--
	plat_wait  $08
	plat_up    $80
	plat_wait  $08
	plat_down  $80
	plat_jump --

@@platform04:
	plat_wait  $08
	plat_left  $a0
	plat_wait  $08
	plat_up    $a0
	plat_wait  $08
	plat_right $a0
	plat_wait  $08
	plat_down  $a0
	plat_jump @@platform04

@@platform05:
	plat_wait  $08
	plat_up    $80
	plat_wait  $08
	plat_down  $80
	plat_jump @@platform05

@dungeon08:
	.dw @@platform00
	.dw @@platform01
	.dw @@platform02
	.dw @@platform03

@@platform00:
@@platform02:
	plat_right $e0
	plat_wait  $10
	plat_left  $e0
	plat_wait  $10
	plat_jump @@platform00

@@platform01:
@@platform03:
	plat_left  $e0
	plat_wait  $10
	plat_right $e0
	plat_wait  $10
	plat_jump @@platform01

movingPlatform_nonDungeon00:
	plat_setspeed $50
--
	plat_wait  $3c
	plat_left  $1c
	plat_wait  $0f
	plat_up    $30
	plat_wait  $0f
	plat_right $38
	plat_wait  $0f
	plat_down  $30
	plat_wait  $0f
	plat_left  $1c
	plat_wait  $3c
	plat_jump --

movingPlatform_nonDungeon01:
	plat_wait  $08
	plat_right $40
	plat_wait  $08
	plat_left  $40
	plat_jump movingPlatform_nonDungeon01

movingPlatform_nonDungeon02:
	plat_wait  $08
	plat_left  $40
	plat_wait  $08
	plat_right $40
	plat_jump movingPlatform_nonDungeon02
