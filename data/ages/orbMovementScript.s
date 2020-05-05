orbMovementScript:
	.dw @subid00

@subid00:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_right $98
	ms_left  $68
	ms_loop  @@loop
