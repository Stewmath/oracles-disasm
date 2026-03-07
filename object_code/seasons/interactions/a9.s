; ==================================================================================================
; INTERAC_a9
; ==================================================================================================
interactionCodea9:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld e,$50
	ld a,$1e
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisiblec0

@state1:
	call interactionAnimate
	ld e,$42
	ld a,(de)
	cp $02
	ret z
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	ld a,($cfc0)
	or a
	ret z
	call interactionIncSubstate
	ld l,$42
	ld a,(hl)
	add a
	inc a
	jp interactionSetAnimation

@substate1:
	ld a,($cfc0)
	cp $02
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$0a
	ret

@substate2:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld bc,$ff00
	jp objectSetSpeedZ

@substate3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$50
	ret

@substate4:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld l,$42
	ld a,(hl)
	cp $01
	ld a,$04
	jr z,+
	xor a
+
	ld l,$49
	ld (hl),a
	ret

@substate5:
	ld e,$42
	ld a,(de)
	cp $01
	jr z,@applySpeed
	cp $04
	jr z,@applySpeed
	cp $05
	ret nz

@applySpeed:
	jp objectApplySpeed
