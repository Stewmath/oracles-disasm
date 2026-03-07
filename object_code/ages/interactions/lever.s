; ==================================================================================================
; INTERAC_LEVER
;
; subid:    Bit 7 set if this is the "child" object (the part that links the lever base to
;           the part Link is pulling); otherwise, bit 0 set if the lever is pulled upward.
; var03:    Nonzero if the "child" lever (part that extends) has already been created?
; var30:    Y position at which lever is fully retracted.
; var31:    Number of units to pull the lever before it's fully pulled.
; var32/33: Address of something in wram (wLever1PullDistance or wLever2PullDistance)
; var34:    Y offset of Link relative to lever when he's pulling it
; var35:    Nonzero if lever was pulled last frame.
; ==================================================================================================
interactionCode61:
	ld e,Interaction.subid
	ld a,(de)
	rlca
	ld e,Interaction.state
	jp c,@updateLeverConnectionObject

	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call interactionInitGraphics
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr nz,@label_09_254

	; Create new INTERAC_LEVER, and set their relatedObj1's to each other.
	; This new "child" object will just be the graphic for the "extending" part.
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_LEVER
	ld l,Interaction.relatedObj1
	ld e,l
	ld a,Interaction.enabled
	ld (de),a
	ldi (hl),a
	inc e
	ld (hl),d
	ld a,h
	ld (de),a

	; Jump if new object's slot >= this object's slot
	cp d
	jr nc,@label_09_253

	; Swap the subids of the two objects to ensure that the "parent" has a lower slot
	; number?
	ld l,Interaction.subid
	ld e,l
	ld a,(de)
	ldi (hl),a ; [new.subid] = [this.subid]

	ld a,$80
	ld (de),a ; [this.subid] = $80
	inc (hl)  ; [new.var03] = $01

	jp objectCopyPosition

@label_09_253:
	ld l,Interaction.subid
	ld (hl),$80

@label_09_254:
	call interactionIncState

	; After above function call, h = d.
	ld l,Interaction.collisionRadiusY
	ld (hl),$05
	inc l
	ld (hl),$01

	; [var30] = [yh]
	ld l,Interaction.yh
	ld a,(hl)
	ld e,Interaction.var30
	ld (de),a

	; [var31] = y-offset of lever when fully extended.
	ld l,Interaction.subid
	ld a,(hl)
	and $30
	swap a
	ld bc,@leverLengths
	call addAToBc
	inc e
	ld a,(bc)
	ld (de),a

	; [var32/var33] = address of wLever1PullDistance or wLever2PullDistance
	ld bc,wLever1PullDistance
	bit 6,(hl) ; Check bit 6 of subid
	jr z,+
	inc bc
+
	inc e
	ld a,c
	ld (de),a
	inc e
	ld a,b
	ld (de),a

	; [subid] &= $01 (only indicates direction of lever now)
	ld a,(hl)
	and $01
	ld (hl),a

	; [var34] = Y offset of Link relative to lever when he's pulling it
	ld a,$0c
	jr z,+
	ld a,$f3
+
	inc e
	ld (de),a
	ld a,(hl)
	call interactionSetAnimation
	jp objectSetVisible83


; Which byte is read from here depends on bits 4-5 of subid.
@leverLengths:
	.db $08 $10 $20 $40


; Waiting for Link to grab
@state1:
	call objectPushLinkAwayOnCollision

	; Get the rough "direction value" toward link (rounded to a cardinal direction)
	call objectGetAngleTowardEnemyTarget
	add $14
	and $18
	swap a
	rlca
	ld c,a

	; Check that this direction matches the valid pulling direction and Link's facing
	; direction
	ld e,Interaction.subid
	ld a,(de)
	add a
	cp c
	ret nz
	ld a,(w1Link.direction)
	cp c
	ret nz

	; Allow to be grabbed
	jp objectAddToGrabbableObjectBuffer


; State 2: Link is grabbing this.
@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld a,$80
	ld (wLinkGrabState2),a

	; Calculate Link's y and x positions
	ld l,Interaction.xh
	ld a,(hl)
	ld (w1Link.xh),a
	ld l,Interaction.var34
	ld a,(hl)
	ld l,Interaction.yh
	add (hl)
	ld (w1Link.yh),a
	xor a
	dec l
	ld (hl),a
	ld (w1Link.y),a

	ld b,SPEED_40
	inc a
	jr @setSpeedAndAngle

@substate1:
	; Check animParameter of the "parent item" for the power bracelet?
	ld a,(w1ParentItem2.animParameter)
	or a
	jr nz,++
	ld e,Interaction.var35
	ld (de),a
	ret
++
	call @checkLeverFullyExtended
	ret nc

	; Not fully extended yet. Set Link's speed/angle to this lever's speed/angle
	ld l,Interaction.angle
	ld c,(hl)
	ld l,Interaction.speed
	ld b,(hl)
	call updateLinkPositionGivenVelocity

	; Update Lever's position based on Link's position.
	ld a,(w1Link.yh)
	ld h,d
	ld l,Interaction.var34
	sub (hl)
	ld l,Interaction.yh
	ld (hl),a

	; Take difference from lever's "base" position to get the number of pixels it's
	; been pulled.
	ld l,Interaction.var30
	sub (hl)
	call @updatePullOffset

	; Return if lever position hasn't changed.
	cp b
	ret z

	; Play moveblock sound if lever was not pulled last frame, and it is not fully
	; pulled.
	ld h,d
	ld l,Interaction.var35
	bit 0,(hl)
	ret nz
	inc (hl)
	bit 7,b
	ret nz

	ld a,SND_MOVEBLOCK
	jp playSound


; Lever just released?
@substate2:
@substate3:
	call interactionIncState
	ld l,Interaction.enabled
	res 1,(hl)
	ld b,SPEED_40
	xor a

@setSpeedAndAngle:
	ld l,Interaction.speed
	ld (hl),b

	; Calculate angle using subid (which has direction information)
	ld l,Interaction.subid
	xor (hl)
	swap a
	ld l,Interaction.angle
	ld (hl),a
	ret


; Lever retracting back to original position by itself.
@state3:
	call objectApplySpeed

	; Update lever pull offset
	ld e,Interaction.yh
	ld a,(de)
	ld b,a
	ld e,Interaction.var30
	ld a,(de)
	sub b
	call @updatePullOffset
	call @checkLeverFullyRetracted
	jr c,@makeGrabbable

	; Lever fully retracted.
	ld l,Interaction.state
	ld (hl),$01
	ld b,SPEED_40
	ld a,$01
	call @setSpeedAndAngle

@makeGrabbable:
	; State 1 doesn't do anything except make the lever grabbable, so just reuse it.
	jp @state1


; This part is almost entirely separate from the lever code above; this is a separate
; object that graphically connects the lever's base with the part Link is holding.
@updateLeverConnectionObject:
	ld a,(de)
	or a
	jr nz,@@state1

@@state0:
	call interactionInitGraphics
	call interactionIncState
	call objectSetVisible83

	; Copy parent's x position
	ld a,Object.xh
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(hl)
	ld (de),a

@@state1:
	; b = [relatedObj1.subid]*5 (either 0 or 5 as a base for the table below)
	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld a,(hl)
	add a
	add a
	add (hl)
	ld b,a

	; a = (number of pixels pulled)/16
	ld l,Interaction.yh
	ld a,(hl)
	ld l,Interaction.var30
	sub (hl)
	jr nc,+
	cpl
	inc a
+
	swap a
	and $07
	push af

	; Get Y offset for animation.
	add b
	ld bc,@animationYOffsets
	call addAToBc
	ld a,(bc)
	add (hl)
	ld e,Interaction.yh
	ld (de),a

	; Set animation. Animation $02 is just a 16-pixel high lever connection, and
	; animations $03-$06 each add another 16-pixel high connection to the chain.
	pop af
	add $02
	jp interactionSetAnimation

@animationYOffsets:
	.db $00 $08 $10 $18 $20 ; Lever facing down
	.db $00 $f8 $f0 $e8 $e0 ; Lever facing up

;;
; If the lever is fully extended, this also caps its position to the max value.
;
; @param[out]	cflag	nc if fully extended.
@checkLeverFullyExtended:
	ld e,Interaction.var31
	ld a,(de)
	ld h,d

	ld l,Interaction.subid
	bit 0,(hl)
	jr z,@posComparison

	cpl
	inc a

@negComparison:
	ld l,Interaction.var30
	add (hl)
	ld l,Interaction.yh
	cp (hl)
	ret c
	ld (hl),a
	ret

;;
; If the lever is fully retracted, this also caps its position to 0.
;
; @param[out]	cflag	nc if fully retracted.
@checkLeverFullyRetracted:
	xor a
	ld h,d
	ld l,Interaction.subid
	bit 0,(hl)
	jr z,@negComparison

@posComparison:
	ld l,Interaction.var30
	add (hl)
	ld b,a
	ld l,Interaction.yh
	ld a,(hl)
	cp b
	ret c
	ld (hl),b
	ret

;;
; @param	a	Offset of lever from its base (Value to write to
;			wLever1/2PullDistance before possible negation)
; @param	cflag	Set if lever is facing up
; @param[out]	a	Old value of pull distance
; @param[out]	b	New value of pull distance
@updatePullOffset:
	jr nc,++
	cpl
	inc a
++
	ld h,d
	ld l,Interaction.var31
	cp (hl)
	jr nz,++

	; Pulled lever all the way?
	ld h,a
	push hl
	ld a,SND_OPENCHEST
	call playSound

	; Set bit 7 of pull distance when fully pulled
	pop hl
	ld a,h
	or $80
	ld h,d
++
	; Read address in var32/var33; set new value to 'b' and return old value as 'a'.
	ld b,a
	inc l
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(hl)
	ld (hl),b
	ret
