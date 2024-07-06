; ==================================================================================================
; INTERAC_SPARKLE
; ==================================================================================================
interactionCode84:
	call checkInteractionState
	jr nz,@state1

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld l,$44
	inc (hl)
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @mediumDrawPriority
	.dw @initSubid02
	.dw @initSubid03
	.dw @lowDrawPriority
	.dw @mediumDrawPriority
	.dw @mediumDrawPriority
	.dw @highDrawPriority
	.dw @initSubid08
	.dw @mediumDrawPriority

@initSubid00:
	ld h,d
	ld l,$46
	ld (hl),$78
@highDrawPriority:
	jp objectSetVisible82

@initSubid02:
	ld h,d
	ld l,$50
	ld (hl),$80
	inc l
	ld (hl),$ff
@mediumDrawPriority:
	jp objectSetVisible81

@initSubid03:
	ld h,d
	ld l,$50
	ld (hl),$c0
	inc l
	ld (hl),$ff
	jp objectSetVisible81

@lowDrawPriority:
	jp objectSetVisible80

@initSubid08:
	ld h,d
	ld l,$46
	ld (hl),$c2
	jp objectSetVisible80

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw @runSubid01
	.dw @runSubid02
	.dw @runSubid03
	.dw @runSubid04
	.dw @runSubid05
	.dw @runSubid06
	.dw @runSubid07
	.dw @runSubid08
	.dw @runSubid09

@runSubid00:
@runSubid07:
@animateAndFlickerAndDeleteWhenCounter1Zero:
	call interactionDecCounter1
	jp z,interactionDelete
@animateAndFlicker:
	call interactionAnimate
	ld a,(wFrameCounter)
@flicker4:
	rrca
	jp c,objectSetInvisible
	jp objectSetVisible
	
@runSubid02:
@runSubid03:
	call objectApplyComponentSpeed

@runSubid01:
@runSubid05:
	ld e,$61
	ld a,(de)
	cp $ff
	jp z,interactionDelete
	jp interactionAnimate

@runSubid04:
	ld a,($cfc0)
	bit 0,a
	jp nz,interactionDelete
	jr @animateAndFlicker

@runSubid09:
	ld a,($cbb9)
	cp $06
	jp z,interactionDelete
	jr @animateFlickerAndTakeRelatedObj1Position

@runSubid06:
	ld a,($cbb9)
	cp $07
	jp z,interactionDelete

@animateFlickerAndTakeRelatedObj1Position:
	call interactionAnimate
	ld a,$0b
	call objectGetRelatedObject1Var
	call objectTakePosition
	ld a,($cbb7)
	jr @flicker4

@runSubid08:
	ld a,$0b
	call objectGetRelatedObject1Var
	call objectTakePosition
	jr @animateAndFlickerAndDeleteWhenCounter1Zero
