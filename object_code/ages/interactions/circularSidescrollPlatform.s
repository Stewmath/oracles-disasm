; ==================================================================================================
; INTERAC_CIRCULAR_SIDESCROLL_PLATFORM
; ==================================================================================================
interactionCodea4:
	call sidescrollPlatform_checkLinkOnPlatform
	call @updateState
	jp sidescrollingPlatformCommon

@updateState:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.state
	inc (hl)

	ld l,Interaction.collisionRadiusY
	ld a,$08
	ldi (hl),a
	ld (hl),a

	ld l,Interaction.speed
	ld (hl),SPEED_c0
	ld l,Interaction.counter1
	ld (hl),$07

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@angles
	rst_addAToHl
	ld e,Interaction.angle
	ld a,(hl)
	ld (de),a

	ld bc,$5678
	ld a,$35
	call objectSetPositionInCircleArc

	ld e,Interaction.angle
	ld a,(de)
	add $08
	and $1f
	ld (de),a
	call @func_5a67
	jp objectSetVisible82

@angles:
	.db ANGLE_UP, ANGLE_RIGHT, ANGLE_DOWN

@state1:
	call interactionDecCounter1
	jr nz,++
	ld (hl),$0e
	ld l,Interaction.angle
	ld a,(hl)
	inc a
	and $1f
	ld (hl),a
++
	call objectApplySpeed

	ld e,Interaction.var34
	ld a,(de)
	or a
	jr z,@func_5a67

	ld h,d
	ld l,Interaction.var36
	ld e,Interaction.yh
	ld a,(de)
	sub (hl)
	ld b,a

	inc l
	ld e,Interaction.xh
	ld a,(de)
	sub (hl)
	ld c,a
	ld hl,w1Link.yh
	ld a,(hl)
	add b
	ldi (hl),a
	inc l
	ld a,(hl)
	add c
	ld (hl),a

@func_5a67:
	ld h,d
	ld l,Interaction.var36
	ld e,Interaction.yh
	ld a,(de)
	ldi (hl),a
	ld e,Interaction.xh
	ld a,(de)
	ld (hl),a
	ret

;;
; Used by:
; * INTERAC_MOVING_SIDESCROLL_PLATFORM
; * INTERAC_MOVING_SIDESCROLL_CONVEYOR
; * INTERAC_DISAPPEARING_SIDESCROLL_PLATFORM
; * INTERAC_CIRCULAR_SIDESCROLL_PLATFORM
sidescrollingPlatformCommon:
	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	ret nz
	call objectCheckCollidedWithLink
	ret nc

	; Platform has collided with Link.

	call sidescrollPlatform_checkLinkIsClose
	jr c,@label_0b_183
	call sidescrollPlatform_getTileCollisionBehindLink
	jp z,sidescrollPlatform_pushLinkAwayHorizontal

	call sidescrollPlatform_checkLinkSquished
	ret c

	ld e,Interaction.yh
	ld a,(de)
	ld b,a
	ld a,(w1Link.yh)
	cp b
	ld c,ANGLE_UP
	jr nc,@moveLinkAtAngle
	ld c,ANGLE_DOWN
	jr @moveLinkAtAngle

@label_0b_183:
	call sidescrollPlatformFunc_5b51
	ld a,(hl)
	or a
	jp z,sidescrollPlatform_pushLinkAwayVertical

	call sidescrollPlatform_checkLinkSquished
	ret c
	ld a,(wLinkRidingObject)
	cp d
	jr nz,@label_0b_184
	ldh a,(<hFF8B)
	cp $03
	jr z,@label_0b_184

	push af
	call sidescrollPlatform_pushLinkAwayVertical
	pop af
	rrca
	jr ++

@label_0b_184:
	ld e,Interaction.xh
	ld a,(de)
	ld b,a
	ld a,(w1Link.xh)
	cp b
++
	ld c,ANGLE_RIGHT
	jr nc,@moveLinkAtAngle
	ld c,ANGLE_LEFT

;;
; @param	c	Angle
@moveLinkAtAngle:
	ld b,SPEED_80
	jp updateLinkPositionGivenVelocity

;;
; @param[out]	cflag	c if Link got squished
sidescrollPlatform_checkLinkSquished:
	ld h,d
	ld l,Interaction.collisionRadiusY
	ld a,(hl)
	ld b,a
	add a
	inc a
	ld c,a
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	sub (hl)
	add b
	cp c
	ret nc

	ld l,Interaction.collisionRadiusX
	ld a,(hl)
	add $02
	ld b,a
	add a
	inc a
	ld c,a
	ld l,Interaction.xh
	ld a,(w1Link.xh)
	sub (hl)
	add b
	cp c
	ret nc

	xor a
	ld l,Interaction.angle
	bit 3,(hl)
	jr nz,+
	inc a
+
	ld (wcc50),a
	ld a,LINK_STATE_SQUISHED
	ld (wLinkForceState),a
	scf
	ret

;;
; @param[out]	cflag	c if Link's close enough to the platform?
sidescrollPlatform_checkLinkIsClose:
	ld a,(wLinkInAir)
	or a
	ld b,$05
	jr z,+
	dec b
+
	ld h,d
	ld l,Interaction.collisionRadiusX
	ld a,(hl)
	add b

	ld b,a
	add a
	inc a
	ld c,a
	ld l,Interaction.xh
	ld a,(w1Link.xh)
	sub (hl)
	add b
	cp c
	ret nc

	ld l,Interaction.collisionRadiusY
	ld a,(hl)
	sub $02
	ld b,a
	add a
	inc a
	ld c,a
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	sub (hl)
	add b
	cp c
	ccf
	ret

;;
; @param[out]	a	Collision value
; @param[out]	zflag	nz if a valid collision value is returned
sidescrollPlatform_getTileCollisionBehindLink:
	ld l,Interaction.xh
	ld a,(w1Link.xh)
	cp (hl)
	ld b,-$05
	jr c,+
	ld b,$04
+
	add b
	ld c,a
	ld a,(w1Link.yh)
	sub $04
	ld b,a
	call getTileCollisionsAtPosition
	ret nz
	ld a,b
	add $08
	ld b,a
	jp getTileCollisionsAtPosition

;;
; @param[out]	hl
sidescrollPlatformFunc_5b51:
	ld h,d
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	cp (hl)
	ld b,-$06
	jr c,+
	ld b,$09
+
	add b
	ld b,a
	ld a,(w1Link.xh)
	sub $03
	ld c,a
	call getTileCollisionsAtPosition
	ld hl,hFF8B
	ld (hl),$00
	jr z,+
	set 1,(hl)
+
	ld a,c
	add $05
	ld c,a
	call getTileCollisionsAtPosition
	ld hl,hFF8B
	ret z
	inc (hl)
	ret

;;
; Checks if Link's on the platform, updates wLinkRidingObject if so.
;
; @param[out]	zflag	nz if Link is standing on the platform
sidescrollPlatform_checkLinkOnPlatform:
	call objectCheckCollidedWithLink
	jr nc,@notOnPlatform

	ld h,d
	ld l,Interaction.yh
	ld a,(hl)
	ld l,Interaction.collisionRadiusY
	sub (hl)
	sub $02
	ld b,a
	ld a,(w1Link.yh)
	cp b
	jr nc,@notOnPlatform

	call sidescrollPlatform_checkLinkIsClose
	jr nc,@notOnPlatform

	ld e,Interaction.var34
	ld a,(de)
	or a
	jr nz,@onPlatform
	ld a,$01
	ld (de),a
	call sidescrollPlatform_updateLinkSubpixels

@onPlatform:
	ld a,d
	ld (wLinkRidingObject),a
	xor a
	ret

@notOnPlatform:
	ld e,Interaction.var34
	ld a,(de)
	or a
	ret z
	ld a,$00
	ld (de),a
	ret

;;
sidescrollPlatform_updateLinkKnockbackForConveyor:
	ld e,Interaction.angle
	ld a,(de)
	bit 3,a
	ret z

	ld hl,w1Link.knockbackAngle
	ld e,Interaction.direction
	ld a,(de)
	swap a
	add $08
	ld (hl),a
	ld l,<w1Link.invincibilityCounter
	ld (hl),$fc
	ld l,<w1Link.knockbackCounter
	ld (hl),$0c
	ret

;;
; @param[out]	hl	counter1
sidescrollPlatform_decCounter1:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret

;;
sidescrollPlatform_pushLinkAwayVertical:
	ld hl,w1Link.collisionRadiusY
	ld e,Interaction.collisionRadiusY
	ld a,(de)
	add (hl)
	ld b,a
	ld l,<w1Link.yh
	ld e,Interaction.yh
	jr +++

;;
sidescrollPlatform_pushLinkAwayHorizontal:
	ld hl,w1Link.collisionRadiusX
	ld e,Interaction.collisionRadiusX
	ld a,(de)
	add (hl)
	ld b,a
	ld l,<w1Link.xh
	ld e,Interaction.xh
+++
	ld a,(de)
	cp (hl)
	jr c,++
	ld a,b
	cpl
	inc a
	ld b,a
++
	ld a,(de)
	add b
	ld (hl),a
	ret

;;
sidescrollPlatformFunc_5bfc:
	call objectRunMovementScript
	ld a,(wLinkRidingObject)
	cp d
	ret nz

;;
sidescrollPlatform_updateLinkSubpixels:
	ld e,Interaction.y
	ld a,(de)
	ld (w1Link.y),a
	ld e,Interaction.x
	ld a,(de)
	ld (w1Link.x),a
	ret
