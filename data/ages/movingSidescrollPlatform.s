; ==================================================================================================
; Data for INTERAC_MOVING_SIDESCROLL_PLATFORM and INTERAC_MOVING_SIDESCROLL_CONVEYOR
; ==================================================================================================

movingSidescrollPlatformScriptTable:
	.dw movingSidescrollPlatformScript_subid00
	.dw movingSidescrollPlatformScript_subid01
	.dw movingSidescrollPlatformScript_subid02
	.dw movingSidescrollPlatformScript_subid03
	.dw movingSidescrollPlatformScript_subid04
	.dw movingSidescrollPlatformScript_subid05
	.dw movingSidescrollPlatformScript_subid06
	.dw movingSidescrollPlatformScript_subid07
	.dw movingSidescrollPlatformScript_subid08
	.dw movingSidescrollPlatformScript_subid09
	.dw movingSidescrollPlatformScript_subid0a
	.dw movingSidescrollPlatformScript_subid0b
	.dw movingSidescrollPlatformScript_subid0c
	.dw movingSidescrollPlatformScript_subid0d
	.dw movingSidescrollPlatformScript_subid0e


movingSidescrollPlatformScript_subid00:
	.db SPEED_80
	.db $04
@@loop:
	ms_right $78
	ms_left  $58
	ms_loop  @@loop


movingSidescrollPlatformScript_subid01:
	.db SPEED_80
	.db $04
@@loop:
	ms_up    $28
	ms_down  $68
	ms_loop  @@loop


movingSidescrollPlatformScript_subid02:
	.db SPEED_80
	.db $00
@@loop:
	ms_up    $28
	ms_right $50
	ms_down  $68
	ms_left  $30
	ms_loop  @@loop

movingSidescrollPlatformScript_subid03:

	.db SPEED_80
	.db $00
@@loop:
	ms_left  $70
	ms_up    $28
	ms_right $90
	ms_down  $88
	ms_loop  @@loop


movingSidescrollPlatformScript_subid04:
	.db SPEED_80
	.db $02
@@loop:
	ms_up    $48
	ms_down  $88
	ms_loop  @@loop


movingSidescrollPlatformScript_subid05:
	.db SPEED_80
	.db $02
@@loop:
	ms_down  $78
	ms_up    $38
	ms_loop  @@loop



movingSidescrollConveyorScriptTable: ; INTERAC_MOVING_SIDESCROLL_CONVEYOR
	.dw @subid00

@subid00:
	.db SPEED_80
	.db $01
@@loop:
	ms_right $50
	ms_down  $88
	ms_left  $38
	ms_up    $38
	ms_loop  @@loop



movingSidescrollPlatformScript_subid06:
	.db SPEED_80
	.db $04
@@loop:
	ms_up    $38
	ms_down  $68
	ms_loop  @@loop


movingSidescrollPlatformScript_subid07:
	.db SPEED_80
	.db $04
@@loop:
	ms_left  $88
	ms_right $a8
	ms_loop  @@loop


movingSidescrollPlatformScript_subid08:
	.db SPEED_80
	.db $04
@@loop:
	ms_up    $58
	ms_down  $98
	ms_loop  @@loop


movingSidescrollPlatformScript_subid09:
	.db SPEED_80
	.db $04
@@loop:
	ms_up    $48
	ms_down  $98
	ms_loop  @@loop


movingSidescrollPlatformScript_subid0a:
	.db SPEED_80
	.db $01
@@loop:
	ms_up    $38
	ms_down  $88
	ms_loop  @@loop


movingSidescrollPlatformScript_subid0b:
	.db SPEED_80
	.db $03
@@loop:
	ms_left  $40
	ms_wait  30
	ms_right $80
	ms_wait  30
	ms_loop  @@loop


movingSidescrollPlatformScript_subid0c:
	.db SPEED_80
	.db $00
@@loop:
	ms_down  $68
	ms_wait  30
	ms_up    $38
	ms_loop  @@loop


movingSidescrollPlatformScript_subid0d:
	.db SPEED_80
	.db $00
@@loop:
	ms_down  $98
	ms_wait  30
	ms_up    $68
	ms_loop  @@loop


movingSidescrollPlatformScript_subid0e:
	.db SPEED_80
	.db $00
@@loop:
	ms_left  $30
	ms_wait  30
	ms_right $a0
	ms_wait  30
	ms_loop  @@loop
