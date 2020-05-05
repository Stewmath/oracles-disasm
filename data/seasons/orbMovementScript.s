orbMovementScript:
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03
	.dw @subid04
	.dw @subid05
	.dw @subid06
	.dw @subid07
	.dw @subid08
	.dw @subid09
	.dw @subid0A

@subid00:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_right $38
	ms_wait  $14
	ms_left  $18
	ms_wait  $14
	ms_loop  @@loop

@subid01:
	.db SPEED_180
	.db DIR_UP
@@loop:
	ms_right $48
	ms_wait  $14
	ms_left  $18
	ms_wait  $14
	ms_loop  @@loop

@subid02:
	.db SPEED_100
	.db DIR_UP
@@loop:
	ms_right $48
	ms_wait  $14
	ms_left  $18
	ms_wait  $14
	ms_loop  @@loop

@subid03:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_right $48
	ms_wait  $14
	ms_left  $18
	ms_wait  $14
	ms_loop  @@loop

@subid04:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_right $d8
	ms_wait  $14
	ms_left  $b8
	ms_wait  $14
	ms_loop  @@loop

@subid05:
	.db SPEED_300
	.db DIR_UP
@@loop:
	ms_right $78
	ms_left  $38
	ms_loop  @@loop

@subid06:
	.db SPEED_2e0
	.db DIR_UP
@@loop:
	ms_right $78
	ms_left  $38
	ms_loop  @@loop

@subid07:
	.db SPEED_2c0
	.db DIR_UP
@@loop:
	ms_right $78
	ms_left  $38
	ms_loop  @@loop

@subid08:
	.db SPEED_2a0
	.db DIR_UP
@@loop:
	ms_right $78
	ms_left  $38
	ms_loop  @@loop

@subid09:
	.db SPEED_280
	.db DIR_UP
@@loop:
	ms_right $78
	ms_left  $38
	ms_loop  @@loop

@subid0A:
	.db SPEED_260
	.db DIR_UP
@@loop:
	ms_right $78
	ms_left  $38
	ms_loop  @@loop
