; ==================================================================================================
; INTERAC_SPARKLE
; ==================================================================================================
interactionCode84:
	call checkInteractionState
	jr nz,@state1

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.state
	inc (hl)
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @highDrawPriority
	.dw @highDrawPriority
	.dw @highDrawPriority
	.dw @initSubid07
	.dw @highDrawPriority
	.dw @initSubid09
	.dw @initSubid0a
	.dw @initSubid0b
	.dw @initSubid0c
	.dw @highDrawPriority
	.dw @highDrawPriority
	.dw @highDrawPriority

@initSubid0a:
	ld h,d
	ld l,Interaction.speed
	ld a,(hl)
	or a
	jr nz,@initSubid00
	ld (hl),$78

@initSubid00:
@initSubid01:
@initSubid09:
	inc e
	ld a,(de)
	or a
	jp nz,objectSetVisible81

@initSubid02:
@initSubid03:
@initSubid07:
@lowDrawPriority:
	jp objectSetVisible82

@highDrawPriority:
	jp objectSetVisible80

@initSubid0b:
	ld h,d
	ld l,Interaction.speedY
	ld (hl),<(-$40)
	inc l
	ld (hl),>(-$40)
	jp objectSetVisible81

@initSubid0c:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Interaction.var38
	ld a,(hl)
	ld (de),a
	jr @lowDrawPriority


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
	.dw @runSubid0a
	.dw @runSubid0b
	.dw @runSubid0c
	.dw @runSubid0d
	.dw @runSubid0e
	.dw @runSubid0f

@runSubid02:
@runSubid03:
@runSubid0b:
	call objectApplyComponentSpeed

@runSubid00:
@runSubid01:
@runSubid09:
	ld e,Interaction.animParameter
	ld a,(de)
	cp $ff
	jp z,interactionDelete
	jp interactionAnimate


@runSubid04:
@animateAndFlickerAndDeleteWhenCounter1Zero:
	call interactionDecCounter1
	jp z,interactionDelete

@runSubid08:
@animateAndFlicker:
	call interactionAnimate
	ld a,(wFrameCounter)
@flicker:
	rrca
	jp c,objectSetInvisible
	jp objectSetVisible


@runSubid05:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld bc,$0800
	call objectTakePositionWithOffset
	jr @animateAndFlickerAndDeleteWhenCounter1Zero


@runSubid07:
@runSubid0f:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	call objectTakePosition

@runSubid0e:
	ld a,(wTmpcfc0.bombUpgradeCutscene.state)
	bit 0,a
	jp nz,interactionDelete
	jr @animateAndFlicker


@runSubid06:
	ld a,(wTmpcbb9)
	cp $07
	jp z,interactionDelete

@animateFlickerAndTakeRelatedObj1Position:
	call interactionAnimate
	ld a,Object.yh
	call objectGetRelatedObject1Var
	call objectTakePosition
	ld a,(wIntro.frameCounter)
	jr @flicker


@runSubid0a:
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jp c,interactionAnimate
	jp interactionDelete


@runSubid0c:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Interaction.var38
	ld a,(de)
	cp (hl)
	jp nz,interactionDelete

	call objectTakePosition
	ld a,($cfc0)
	bit 0,a
	jp nz,interactionDelete
	jr @animateAndFlicker


@runSubid0d:
	ld a,(wTmpcbb9)
	cp $06
	jp z,interactionDelete
	jr @animateFlickerAndTakeRelatedObj1Position
