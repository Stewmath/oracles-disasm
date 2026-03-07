; ==================================================================================================
; INTERAC_97
; ==================================================================================================
interactionCode97:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisible83
@state1:
	ld hl,$cfd0
	ld a,(hl)
	inc a
	jp z,interactionDelete
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
@substate0:
	ld hl,$cfd0
	ld a,(hl)
	cp $02
	ret z
	call interactionAnimate
	ld hl,$cfc0
	bit 1,(hl)
	ret z
	call interactionIncSubstate
	call objectSetVisible81
@func_581d:
	push de
	ld h,d
	ld l,$57
	ld a,(hl)
	ld d,a
	ld bc,$0301
	call objectCopyPositionWithOffset
	pop de
	ret
@substate1:
	ld hl,$cfc0
	bit 3,(hl)
	jr z,+
	call interactionIncSubstate
	ld l,$49
	ld (hl),$10
	ld l,$50
	ld (hl),$14
	ld bc,$fe80
	call objectSetSpeedZ
+
	jr @func_581d
@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	jp interactionDelete
