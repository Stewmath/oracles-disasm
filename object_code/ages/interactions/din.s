; ==================================================================================================
; INTERAC_DIN
; ==================================================================================================
interactionCodeaa:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]
	call interactionInitGraphics
	call objectSetVisible82
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid0
	.dw @initSubid1
	.dw @initSubid2

@initSubid0:
@initSubid1:
	ret

@initSubid2:
	call interactionSetAlwaysUpdateBit
	ld bc,$4830
	jp interactionSetPosition


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid0
	.dw interactionAnimate
	.dw interactionAnimate

@runSubid0:
	call @runSubid0Substates
	ld e,Interaction.zh
	ld a,(de)
	or a
	jp nz,objectSetVisiblec2
	jp objectSetVisible82

@runSubid0Substates:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw interactionAnimate

@substate0:
	call interactionAnimate
	ld a,(wTmpcfc0.genericCutscene.state)
	cp $04
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),120
	ld a,$05
	call interactionSetAnimation
	jp @beginJump

@substate1:
	call interactionDecCounter1
	jp nz,@updateSpeedZ
	call interactionIncSubstate
	xor a
	ld l,Interaction.zh
	ld (hl),a
	ld l,Interaction.counter1
	ld (hl),30
	jp interactionAnimate

@substate2:
	call interactionDecCounter1
	jr nz,++
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),60
	ld bc,TX_3d09
	call showText
++
	jp interactionAnimate

@substate3:
	call interactionDecCounter1IfTextNotActive
	jr nz,++
	call interactionIncSubstate
	ld hl,wTmpcfc0.genericCutscene.state
	ld (hl),$05
++
	jp interactionAnimate


; Scripts unused?
@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.dinScript


@updateSpeedZ:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d

@beginJump:
	ld bc,-$100
	jp objectSetSpeedZ
