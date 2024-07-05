; ==================================================================================================
; Data for INTERAC_MOVING_SIDESCROLL_PLATFORM and INTERAC_MOVING_SIDESCROLL_CONVEYOR
; ==================================================================================================
movingSidescrollPlatformScriptTable:
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
	.dw @subid0a
	.dw @subid0b
	.dw @subid0c
	.dw @subid0d
	.dw @subid0e
	.dw @subid0f
	.dw @subid10
	.dw @subid11
	.dw @subid12
	.dw @subid13
	.dw @subid14


@subid00:
	.db SPEED_80
	.db $00
--
	ms_right $6a
	ms_left  $4a
	ms_loop  --


@subid01:
	.db SPEED_80
	.db $00
--
	ms_left  $96
	ms_right $b6
	ms_loop  --


@subid02:
	.db SPEED_80
	.db $00
--
	ms_up    $28
	ms_down  $58
	ms_loop  --


@subid03:
	.db SPEED_80
	.db $00
--
	ms_left  $50
	ms_right $a0
	ms_loop  --


@subid04:
	.db SPEED_80
	.db $00
--
	ms_left  $50
	ms_right $80
	ms_loop  --


@subid05:
	.db SPEED_80
	.db $00
--
	ms_right $70
	ms_left  $40
	ms_loop  --


@subid06:
	.db SPEED_80
	.db $00
--
	ms_left  $40
	ms_right $b0
	ms_loop  --


@subid07:
	.db SPEED_80
	.db $00
--
	ms_up    $68
	ms_down  $98
	ms_loop  --


@subid08:
	.db SPEED_80
	.db $02
--
	ms_up    $38
	ms_down  $88
	ms_loop  --


@subid09:
	.db SPEED_80
	.db $02
--
	ms_down  $88
	ms_up    $38
	ms_loop  --


@subid0a:
	.db SPEED_80
	.db $03
--
	ms_left  $40
	ms_right $90
	ms_loop  --


@subid0b:
	.db SPEED_80
	.db $00
--
	ms_right $88
	ms_down  $68
	ms_left  $78
	ms_up    $28
	ms_loop  --


@subid0c:
	.db SPEED_80
	.db $00
--
	ms_left  $a8
	ms_down  $88
	ms_right $c0
	ms_up    $38
	ms_loop  --


@subid0d:
	.db SPEED_80
	.db $00
--
	ms_right $60
	ms_left  $30
	ms_loop  --


@subid0e:
	.db SPEED_80
	.db $00
--
	ms_right $a0
	ms_left  $70
	ms_loop  --


@subid0f:
	.db SPEED_80
	.db $01
--
	ms_down  $88
	ms_wait  $1e
	ms_up    $68
	ms_wait  $1e
	ms_loop  --


@subid10:
	.db SPEED_80
	.db $02
--
	ms_down  $88
	ms_up    $68
	ms_loop  --


@subid11:
	.db SPEED_80
	.db $02
--
	ms_down  $88
	ms_up    $48
	ms_loop  --


@subid12:
	.db SPEED_80
	.db $02
--
	ms_up    $48
	ms_down  $88
	ms_loop  --


@subid13:
	.db SPEED_80
	.db $00
--
	ms_up    $28
	ms_down  $88
	ms_loop  --


@subid14:
	.db SPEED_80
	.db $00
--
	ms_down  $88
	ms_up    $28
	ms_loop  --


movingSidescrollConveyorScriptTable: ; INTERAC_MOVING_SIDESCROLL_CONVEYOR
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03
	.dw @subid04

@subid00:
	.db SPEED_80
	.db $01
--
	ms_right $50
	ms_down  $88
	ms_left  $38
	ms_up    $38
	ms_loop  --


@subid01:
	.db SPEED_80
	.db $00
--
	ms_down  $88
	ms_up    $28
	ms_loop  --


@subid02:
	.db SPEED_80
	.db $01
--
	ms_up    $28
	ms_down  $88
	ms_loop  --


@subid03:
	.db SPEED_80
	.db $01
--
	ms_up    $28
	ms_right $80
	ms_down  $88
	ms_left  $40
	ms_loop  --


@subid04:
	.db SPEED_80
	.db $00
--
	ms_up    $38
	ms_left  $40
	ms_down  $78
	ms_right $a0
	ms_loop  --
