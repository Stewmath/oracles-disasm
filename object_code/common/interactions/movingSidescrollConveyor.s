; ==================================================================================================
; INTERAC_MOVING_SIDESCROLL_CONVEYOR
; ==================================================================================================
interactionCodea2:
	call interactionAnimate
	call sidescrollPlatform_checkLinkOnPlatform
	call nz,sidescrollPlatform_updateLinkKnockbackForConveyor
	call @updateState
	jp sidescrollingPlatformCommon

@updateState:
	ld e,Interaction.state
	ld a,(de)
	sub $08
	jr c,@state0To7
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw movingPlatform_stateC

@state0To7:
.ifdef ROM_AGES
	ld hl,bank0e.movingSidescrollConveyorScriptTable
.else
	ld hl,bank0d.movingSidescrollConveyorScriptTable
.endif
	call objectLoadMovementScript
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.collisionRadiusY
	ld (hl),$08
	inc l
	ld (hl),$0c
	ld e,Interaction.direction
	ld a,(de)
	call interactionSetAnimation
	jp objectSetVisible82

@state8:
	ld e,Interaction.var32
	ld a,(de)
	ld h,d
	ld l,Interaction.yh
	cp (hl)
	jr c,@applySpeed
	ld a,(de)
	ld (hl),a
	jp sidescrollPlatformFunc_5bfc

@state9:
	ld e,Interaction.xh
	ld a,(de)
	ld h,d
	ld l,Interaction.var33
	cp (hl)
	jr c,@applySpeed
	ld a,(hl)
	ld (de),a
	jp sidescrollPlatformFunc_5bfc

@stateA:
	ld e,Interaction.yh
	ld a,(de)
	ld h,d
	ld l,Interaction.var32
	cp (hl)
	jr nc,++
	ld l,Interaction.speed
	ld b,(hl)
	ld c,ANGLE_DOWN
	ld a,(wLinkRidingObject)
	cp d
	call z,updateLinkPositionGivenVelocity
	jr @applySpeed
++
	ld a,(hl)
	ld (de),a
	jp sidescrollPlatformFunc_5bfc

@stateB:
	ld e,Interaction.var33
	ld a,(de)
	ld h,d
	ld l,Interaction.xh
	cp (hl)
	jr c,@applySpeed
	ld a,(de)
	ld (hl),a
	jp sidescrollPlatformFunc_5bfc

@applySpeed:
	call objectApplySpeed
	ld a,(wLinkRidingObject)
	cp d
	ret nz

	ld e,Interaction.angle
	ld a,(de)
	rrca
	rrca
	ld b,a
	ld e,Interaction.direction
	ld a,(de)
	add b
	ld hl,@directions
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,a
	ld b,(hl)
	jp updateLinkPositionGivenVelocity

@directions:
	.db ANGLE_RIGHT, SPEED_080
	.db ANGLE_LEFT,  SPEED_080
	.db ANGLE_RIGHT, SPEED_100
	.db ANGLE_LEFT,  SPEED_060
	.db ANGLE_RIGHT, SPEED_080
	.db ANGLE_LEFT,  SPEED_080
	.db ANGLE_RIGHT, SPEED_060
	.db ANGLE_LEFT,  SPEED_100
