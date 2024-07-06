; ==================================================================================================
; INTERAC_INTRO_SPRITE
; ==================================================================================================
interactionCode75:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState
	call interactionInitGraphics
	call objectSetVisible82
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init
	.dw @subid3Init
	.dw @subid4Init
	.dw @subid5Init
	.dw @subid6Init

@subid0Init:
@subid5Init:
	ret

@subid1Init:
	ld h,d
	ld l,Interaction.counter1
	ld (hl),$05

@initSpeedToScrollLeft:
	ld l,Interaction.angle
	ld (hl),ANGLE_LEFT
	ld l,Interaction.speed
	ld (hl),SPEED_20
	ld bc,$7080
	jp interactionSetPosition

@subid2Init:
	call objectSetVisible83
	ld h,d
	jr @initSpeedToScrollLeft

@subid3Init:
	ld bc,$4c6c
	call interactionSetPosition
	ld l,Interaction.angle
	ld (hl),$19
	ld l,Interaction.speed
	ld (hl),SPEED_40
	ret

@subid4Init:
	ld bc,$1838
	jp interactionSetPosition

@subid6Init:
	ld h,d
	ld l,Interaction.angle
	ld (hl),$1a
	ld l,Interaction.speed
	ld (hl),SPEED_60
	ret

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid0
	.dw @runSubid1
	.dw @runSubid2
	.dw @runSubid3
	.dw interactionAnimate
	.dw @runSubid5
	.dw @runSubid6

@runSubid0:
@runSubid5:
	ld a,(wIntro.cbba)
	or a
	jp z,interactionAnimate
	jp interactionDelete

@runSubid1:
	call checkInteractionSubstate
	jr nz,@updateSpeed

	call interactionAnimate
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	jr z,@updateSpeed

	ld (hl),$00
	ld l,Interaction.counter1
	dec (hl)
	jr nz,@updateSpeed

	ld l,Interaction.substate
	inc (hl)
	ld a,$04
	call interactionSetAnimation

@updateSpeed:
@runSubid2:
	ld hl,wIntro.cbb6
	ld a,(hl)
	or a
	ret z
	jp objectApplySpeed

@runSubid3:
	call interactionAnimate
	ld a,(wIntro.frameCounter)
	and $03
	ret nz
	jp objectApplySpeed

@runSubid6:
	ld a,(wTmpcbba)
	or a
	jp nz,interactionDelete
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call interactionAnimate
	jp objectApplySpeed
