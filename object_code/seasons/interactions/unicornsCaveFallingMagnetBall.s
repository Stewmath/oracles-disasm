; ==================================================================================================
; INTERAC_D5_FALLING_MAGNET_BALL
; ==================================================================================================
interactionCode64:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw interactionDelete
@state0:
	call interactionInitGraphics
	call getThisRoomFlags
	bit 7,(hl)
	jr nz,@createBall
	call objectGetZAboveScreen
	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	ld l,Interaction.zh
	ld (hl),a
	ret
@createBall:
	ld e,Interaction.state
	ld a,$04
	ld (de),a
	jp objectSetVisiblec2
@state1:
	call getThisRoomFlags
	bit 7,(hl)
	ret z
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ld e,Interaction.counter1
	ld a,$1e
	ld (de),a
	ld a,SND_SOLVEPUZZLE
	call playSound
	jp objectSetVisiblec1
@state2:
	call interactionDecCounter1
	ret nz
	ld l,Interaction.state
	inc (hl)
@state3:
	ld c,$10
	call objectUpdateSpeedZAndBounce
	ret nc
	ld e,Interaction.state
	ld a,$04
	ld (de),a
@state4:
	ld hl,w1MagnetBall
	ld a,(hl)
	or a
	ret nz
	ld (hl),$01
	inc l
	ld (hl),ITEM_MAGNET_BALL
	call objectCopyPosition
	ld e,Interaction.relatedObj1
	ld l,Object.relatedObj1
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a
	ld e,Interaction.state
	ld a,$05
	ld (de),a
	ret
