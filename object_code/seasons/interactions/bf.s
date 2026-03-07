; ==================================================================================================
; cloaked twinrova?
; ==================================================================================================
interactionCodebf:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,$46
	ld (hl),$3c
	jp objectSetVisible80
@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
@substate0:
	call interactionDecCounter1
	jr z,+
	ld a,(wFrameCounter)
	rrca
	jp nc,objectSetInvisible
	jp objectSetVisible
+
	ld l,$45
	inc (hl)
	jp objectSetVisible
@substate1:
	ld h,d
	ld l,$42
	ld a,(hl)
	or a
	jr nz,@subid1
	ld a,($cfc0)
	bit 0,a
	ret z
	ld l,$45
	inc (hl)
	ld a,$02
	jp interactionSetAnimation
@subid1:
	ld a,($cfc0)
	bit 7,a
	jp nz,interactionDelete
	ret
@substate2:
	ld a,($cfc0)
	bit 1,a
	jp nz,interactionDelete
	ret
