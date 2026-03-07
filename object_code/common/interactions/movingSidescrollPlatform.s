; ==================================================================================================
; INTERAC_MOVING_SIDESCROLL_PLATFORM
; ==================================================================================================
interactionCodea1:
	call sidescrollPlatform_checkLinkOnPlatform
	call @updateSubid
	jp sidescrollingPlatformCommon

@updateSubid:
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
	ld hl,bank0e.movingSidescrollPlatformScriptTable
.else
	ld hl,bank0d.movingSidescrollPlatformScriptTable
.endif
	call objectLoadMovementScript
	call interactionInitGraphics
	ld e,Interaction.direction
	ld a,(de)
	ld hl,@collisionRadii
	rst_addDoubleIndex
	ld e,Interaction.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld e,Interaction.direction
	ld a,(de)
	call interactionSetAnimation
	jp objectSetVisible82

@collisionRadii:
	.db $09 $0f
	.db $09 $17
	.db $19 $07
	.db $19 $0f
	.db $09 $07

@state8:
	ld e,Interaction.var32
	ld a,(de)
	ld h,d
	ld l,Interaction.yh
	cp (hl)
	jr nc,+
	jp objectApplySpeed
+
	ld a,(de)
	ld (hl),a
	jp sidescrollPlatformFunc_5bfc

@state9:
	ld e,Interaction.xh
	ld a,(de)
	ld h,d
	ld l,Interaction.var33
	cp (hl)
	jr nc,++
	ld l,Interaction.speed
	ld b,(hl)
	ld c,ANGLE_RIGHT
	ld a,(wLinkRidingObject)
	cp d
	call z,updateLinkPositionGivenVelocity
	jp objectApplySpeed
++
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
	jp objectApplySpeed
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
	jr nc,++
	ld l,Interaction.speed
	ld b,(hl)
	ld c,ANGLE_LEFT
	ld a,(wLinkRidingObject)
	cp d
	call z,updateLinkPositionGivenVelocity
	jp objectApplySpeed
++
	ld a,(de)
	ld (hl),a
	jp sidescrollPlatformFunc_5bfc


movingPlatform_stateC:
	call interactionDecCounter1
	ret nz
	jp sidescrollPlatformFunc_5bfc
