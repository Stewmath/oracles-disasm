; ==================================================================================================
; INTERAC_VERAN_CUTSCENE_WALLMASTER
; ==================================================================================================
interactionCode2c:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	ld bc,$0140
	call objectSetSpeedZ
	ld l,Interaction.counter1
	ld (hl),$14
	ld l,Interaction.zh
	ld (hl),$a0

	call objectSetVisiblec3

@state1:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call interactionDecCounter1
	ret nz
	jp interactionIncSubstate

@substate1:
	ld c,$00
	call objectUpdateSpeedZ_paramC
	ret nz
	ld a,$01
	call interactionSetAnimation
	jp interactionIncSubstate

@substate2:
	ld e,Interaction.animParameter
	ld a,(de)
	bit 7,a
	jp nz,interactionIncSubstate

	or a
	ret z

	xor a
	ld (w1Link.visible),a
	ld a,$1e
	ld e,Interaction.counter1
	ld (de),a
	ld a,SND_BOSS_DEAD
	jp playSound

@substate3:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr z,++
	dec a
	ld (de),a
	ret
++
	ld e,Interaction.zh
	ld a,(de)
	dec a
	ld (de),a
	cp $b0
	ret nz
	ld a,$08
	ld (wTmpcbb5),a
	jp interactionDelete
