; ==================================================================================================
; INTERAC_BOOMERANG
; ==================================================================================================
interactionCodec9:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ldbc $41 $28
	ld l,$50
	ld (hl),b
	ld l,$46
	ld (hl),c
	ld l,$49
	ld (hl),$18
	jp objectSetVisible82
@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
@substate0:
	call interactionDecCounter1
	jr nz,+
	ld l,$49
	ld (hl),$08
	call interactionIncSubstate
+
	call objectApplySpeed
--
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	ld (hl),$00
	ld a,$78
	call nz,playSound
	jp interactionAnimate
@substate1:
	call objectApplySpeed
	call objectGetRelatedObject1Var
	ld l,$4d
	ld e,l
	ld a,(de)
	add $08
	cp (hl)
	jr c,--
	ld l,$77
	ld (hl),$00
	jp interactionDelete
