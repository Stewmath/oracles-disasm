; ==================================================================================================
; INTERAC_FLYING_ROOSTER
;
; Variables:
;   var30/var31: Initial position
;   var32: Y-position necessary to clear the cliff
;   var33: Counter used along with var34
;   var34: Direction chicken is hopping in (up or down; when moving back to "base"
;          position)
;   var35: X-position at which the "destination" is (Link loses control)
; ==================================================================================================
interactionCode8c:
	ld e,Interaction.subid
	ld a,(de)
	bit 7,a
	jp nz,flyingRooster_subidBit7Set

	ld a,(wLinkDeathTrigger)
	or a
	jp nz,interactionAnimate

	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@state0:
	ld a,$01
	ld (de),a ; [state]

	ld a,$02
	call objectSetCollideRadius

	call flyingRooster_getSubidAndInitSpeed

	; Save initial position into var30/var31
	ld e,Interaction.yh
	ld l,Interaction.var30
	ld a,(de)
	ldi (hl),a
	ld e,Interaction.xh
	ld a,(de)
	ld (hl),a

	ld a,c
	ld hl,@subidData
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Interaction.var32
	ld (de),a
	ld e,Interaction.var35
	ld a,(hl)
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisiblec2

; b0: var32 (?)
; b1: var35 (Target x-position)
@subidData:
	.db $18 $68 ; Subid 0
	.db $08 $48 ; Subid 1


; Waiting for Link to grab
@state1:
	call interactionAnimate
	call objectAddToGrabbableObjectBuffer
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	ld bc,-$100
	jp objectSetSpeedZ


; "Grabbed" state
@state2:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @state2Substate1
	.dw @state2Substate2
	.dw @releaseFromLink
	.dw @state2Substate4

@justGrabbed:
	ld a,$01
	ld (de),a ; [substate]
	ld (wDisableScreenTransitions),a
	ld (wMenuDisabled),a
	ld a,$08
	ld (wLinkGrabState2),a
	ret

@state2Substate1:
	ld a,(wLinkInAir)
	or a
	ret nz

	ld a,(wLinkGrabState)
	and $07
	cp $03
	ret nz

	ld hl,w1Link.direction
	ld (hl),$01
	ld a,DISABLE_LINK
	ld (wDisabledObjects),a

	ld l,<w1Link.zh
	ld a,(hl)
	dec a
	ld (hl),a
	cp $f8
	ret nz
	ld a,$02
	ld (de),a
	ret


; Moving toward "base" position before continuing
@state2Substate2:
	; Calculate angle toward original position
	ld e,Interaction.var30
	ld a,(de)
	ld b,a
	inc e
	ld a,(de)
	ld c,a
	push de
	ld de,w1Link.yh
	call getRelativeAngle
	pop de
	ld e,Interaction.angle
	ld (de),a

	call flyingRooster_applySpeedAndUpdatePositions

	ld h,d
	ld l,Interaction.var30
	ldi a,(hl)
	cp b
	ret nz
	ldi a,(hl)
	cp c
	ret nz

	; Reached base position
	ld l,Interaction.enabled
	res 1,(hl)

	ld l,Interaction.substate
	ld (hl),$04

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@angles
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.angle
	ld (de),a
	xor a
	ld (wDisableScreenTransitions),a
	ret

@angles:
	.db $08 $01


@state2Substate4:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@incState

	; Subid 0 (on top of d4) only: stay in this state until reaching cliff edge.
	call flyingRooster_applySpeedAndUpdatePositions
	ld l,<w1Link.xh
	ldi a,(hl)
	cp $30
	ret c

	; Reached edge. Re-jig Link's y and z positions to make him "in the air".
	ld l,<w1Link.yh
	ld a,(hl)
	sub $68
	ld l,<w1Link.zh
	add (hl)
	ld (hl),a
	ld a,$68
	ld l,<w1Link.yh
	ld (hl),a

	ld l,<w1Link.visible
	res 6,(hl)

	ld e,Interaction.visible
	ld a,(de)
	res 6,a
	ld (de),a

@incState:
	call interactionIncState
	ret


; The state where Link can adjust the rooster's height.
@state3:
	call interactionAnimate
	call flyingRooster_applySpeedAndUpdatePositions

	; Cap y-position?
	ld l,<w1Link.yh
	ld a,(hl)
	cp $58
	jr nc,+
	inc (hl)
+
	ld l,<w1Link.xh
	ld e,Interaction.var35
	ld a,(de)
	cp (hl)
	jr c,@reachedTargetXPosition

	call flyingRooster_updateGravityAndCheckCaps
	ld a,(wGameKeysJustPressed)
	and (BTN_A|BTN_B)
	ret z

	; Set z speed based on subid
	ld bc,-$b0
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr z,+
	ld bc,-$d0
+
	call objectSetSpeedZ
	ld a,SND_CHICKEN
	call playSound
	jp interactionAnimate

@reachedTargetXPosition:
	call flyingRooster_getVisualLinkYPosition
	ld e,Interaction.var32
	ld a,(de)
	add $08
	cp b
	jr c,@notHighEnough

	; High enough
	ld a,$08
	ld e,Interaction.angle
	ld (de),a
	ld a,$04
	ld e,Interaction.state
	ld (de),a
	ret

@notHighEnough:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@gotoState6

	; Subid 0 only
	ld a,(wScreenTransitionBoundaryY)
	ld b,a
	ld l,<w1Link.yh
	ld a,(hl)
	sub b

	ld l,<w1Link.zh
	add (hl)
	ld (hl),a
	ld l,<w1Link.yh
	ld (hl),b

	; Create helper object to handle screen transition when Link falls
	call getFreeInteractionSlot
	ld a,INTERAC_FLYING_ROOSTER
	ldi (hl),a
	ld (hl),$80
	ld l,Interaction.enabled
	ld a,$03
	ldi (hl),a

@gotoState6:
	ld e,Interaction.state
	ld a,$06
	ld (de),a
	ld e,Interaction.counter1
	ld a,60
	ld (de),a
	ret


; Cucco stopped in place as it failed to get high enough
@state6:
	call interactionAnimate
	call interactionAnimate
	ld e,Interaction.counter1
	ld a,(de)
	dec a
	ld (de),a
	ret nz
	jp @releaseFromLink


; Lost control; moving onto cliff
@state4:
	call interactionAnimate
	call flyingRooster_applySpeedAndUpdatePositions
	ld e,Interaction.var35
	ld a,(de)
	add $20
	ld l,<w1Link.xh
	cp (hl)
	jr z,@releaseFromLink

	; Still moving toward target position
	ld a,(hl)
	and $0f
	ret nz

	; Update Link's Y/Z positions
	call flyingRooster_getVisualLinkYPosition
	add $08
	ld l,<w1Link.yh
	ld (hl),a
	ld l,<w1Link.zh
	ld a,$f8
	ld (hl),a

	ld l,<w1Link.visible
	set 6,(hl)
	ld e,Interaction.visible
	ld a,(de)
	and $bf
	ld (de),a
	ret

@releaseFromLink:
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld hl,w1Link.angle
	ld a,$ff
	ld (hl),a

	ld a,$05
	ld e,Interaction.state
	ld (de),a

	ld a,$08
	ld e,Interaction.var33
	ld (de),a

	xor a
	inc e
	ld (de),a ; [var34]

	ld a,$00
	call interactionSetAnimation
	jp dropLinkHeldItem


@state5:
	call interactionAnimate
	ld e,Interaction.var33
	ld a,(de)
	dec a
	ld (de),a
	jr nz,@updateHopping

	ld a,$08
	ld (de),a ; [var33]

	inc e
	ld a,(de) ; [var34]
	xor $01
	ld (de),a
	jr @moveTowardBasePosition

@updateHopping:
	and $01
	jr nz,@moveTowardBasePosition

	ld e,Interaction.var34
	ld a,(de)
	or a
	ld e,Interaction.zh
	ld a,(de)
	jr z,@decZ

@incZ:
	inc a
	jr @setZ
@decZ:
	dec a
@setZ:
	ld (de),a

@moveTowardBasePosition:
	ld e,Interaction.var30
	ld a,(de)
	ld b,a
	inc e
	ld a,(de)
	ld c,a

	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	call objectApplySpeed

	ld h,d
	ld l,Interaction.var30
	ld e,Interaction.yh
	ld a,(de)
	cp (hl)
	ret nz

	inc l
	ld e,Interaction.xh
	ld a,(de)
	cp (hl)
	ret nz

	; Reached base position
	ld l,Interaction.state
	ld (hl),$01

	ld l,Interaction.visible
	set 6,(hl)
	call flyingRooster_getSubidAndInitSpeed
	ld a,$01
	jp interactionSetAnimation

;;
; @param[out]	bc	Y/X positions for Link
flyingRooster_applySpeedAndUpdatePositions:
	ld hl,w1Link.yh
	ld e,Interaction.yh
	ldi a,(hl)
	ld (de),a
	inc l
	ld e,Interaction.xh
	ld a,(hl)
	ld (de),a
	call objectApplySpeed

	ld hl,w1Link.yh
	ld e,Interaction.yh
	ld a,(de)
	ld b,a
	ldi (hl),a
	inc l
	ld e,Interaction.xh
	ld a,(de)
	ld c,a
	ld (hl),a
	ret

;;
flyingRooster_updateGravityAndCheckCaps:
	; [this.z] = [w1Link.z]
	ld l,<w1Link.z
	ld e,Interaction.z
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	ld c,$20
	call objectUpdateSpeedZ_paramC

	; [w1Link.z] = [this.z]
	ld hl,w1Link.z
	ld e,Interaction.z
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a

	call flyingRooster_getVisualLinkYPosition
	ld e,Interaction.var32
	ld a,(de)
	cp b
	jr c,@checkBottomCap

	; Cap z-position at the top
	sub b
	ld l,<w1Link.zh
	add (hl)
	ld (hl),a
	ret

@checkBottomCap:
	ld l,<w1Link.zh
	ld a,(hl)
	cp $f8
	ret c

	; Cap z-position at bottom
	ld a,$f8
	ld (hl),a
	xor a
	ld e,Interaction.speedZ
	ld (de),a
	ld e,Interaction.speedZ+1
	ld (de),a
	ret

;;
; @param[out]	a,b	Link's Y-position + Z-position
flyingRooster_getVisualLinkYPosition:
	ld l,<w1Link.yh
	ld a,(hl)
	ld l,<w1Link.zh
	add (hl)
	ld b,a
	ret


; Helper object which handles the screen transition when Link falls down
flyingRooster_subidBit7Set:
	ld hl,w1Link.zh
	ld a,(wActiveRoom)
	and $f0
	jr nz,@nextScreen

	ld a,(hl)
	or a
	ret nz

	ld l,<w1Link.yh
	inc (hl)
	ld a,$80
	ld (wLinkInAir),a
	ld a,$82
	ld (wScreenTransitionDirection),a
	ret

@nextScreen:
	ld a,(wScrollMode)
	and $0e
	ret nz

	ld (hl),$e8 ; [w1Link.zh]
	ld l,<w1Link.yh
	ld (hl),$28
	jp interactionDelete

;;
flyingRooster_getSubidAndInitSpeed:
	ld l,Interaction.subid
	ld c,(hl)
	ld l,Interaction.speed
	ld (hl),SPEED_60
	ret
