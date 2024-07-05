; ==================================================================================================
; PART_SPIKED_BALL
;
; Variables:
;   speed: Nonstandard usage; it's a 16-bit variable which gets added to var30 (distance
;          away from origin).
;   relatedObj1: ENEMY_BALL_AND_CHAIN_SOLDIER (for the head / subid 0),
;                or PART_SPIKED_BALL (the head; for subids 1-3).
;   var30: Distance away from origin point
; ==================================================================================================
partCode2a:
	jr z,@normalStatus

	; Check for sword or shield collision
	ld e,Part.var2a
	ld a,(de)
	res 7,a
	sub ITEMCOLLISION_L1_SHIELD
	cp ITEMCOLLISION_SWORD_HELD-ITEMCOLLISION_L1_SHIELD + 1
	jr nc,@normalStatus

	; Make "parent" immune since the ball blocked the attack
	ld a,Object.invincibilityCounter
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr nz,+
	ld (hl),$f4
+
	; If speedZ is positive, make it 0?
	ld h,d
	ld l,Part.speedZ+1
	ld a,(hl)
	rlca
	jr c,@normalStatus
	xor a
	ldd (hl),a
	ld (hl),a

@normalStatus:
	ld e,Part.subid
	ld a,(de)
	ld b,a
	ld e,Part.state
	ld a,b
	rst_jumpTable
	.dw spikedBall_head
	.dw spikedBall_chain
	.dw spikedBall_chain
	.dw spikedBall_chain


; The main part of the spiked ball (actually has collisions, etc)
spikedBall_head:
	; Check if parent was deleted
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMY_BALL_AND_CHAIN_SOLDIER
	jp nz,partDelete

	ld b,h
	call spikedBall_updateStateFromParent
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw spikedBall_head_state0
	.dw spikedBall_head_state1
	.dw spikedBall_head_state2
	.dw spikedBall_head_state3
	.dw spikedBall_head_state4
	.dw spikedBall_head_state5


; Initialization
spikedBall_head_state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.collisionType
	set 7,(hl)
	call objectSetVisible81


; Rotating slowly
spikedBall_head_state1:
	ld e,Part.angle
	ld a,(de)
	inc a
	and $1f
	ld (de),a
	jr spikedBall_head_setDefaultDistanceAway


; Rotating faster
spikedBall_head_state2:
	ld e,Part.angle
	ld a,(de)
	add $02
	and $1f
	ld (de),a

spikedBall_head_setDefaultDistanceAway:
	ld e,Part.var30
	ld a,$0a
	ld (de),a

;;
; @param	b	Enemy object
spikedBall_updatePosition:
	call spikedBall_copyParentPosition
	ld e,Part.var30
	ld a,(de)
	ld e,Part.angle
	jp objectSetPositionInCircleArc


; About to throw the ball; waiting for it to rotate into a good position for throwing.
spikedBall_head_state3:
	call spikedBall_copyParentPosition

	; Compare the ball's angle with Link; must keep rotating it until it's aligned
	; perfectly.
	ldh a,(<hEnemyTargetY)
	ldh (<hFF8F),a
	ldh a,(<hEnemyTargetX)
	ldh (<hFF8E),a
	push hl
	call objectGetRelativeAngleWithTempVars
	pop bc
	xor $10
	ld e,a
	sub $06
	and $1f
	ld h,d
	ld l,Part.angle
	sub (hl)
	inc a
	and $1f
	cp $03
	jr nc,spikedBall_head_state2 ; keep rotating

	; It's aligned perfectly; begin throwing it.
	ld a,e
	sub $03
	and $1f
	ld (hl),a ; [angle]

	ld l,Part.state
	inc (hl)

	ld l,Part.var30
	ld (hl),$0d
	jp spikedBall_updatePosition


; Ball has just been released
spikedBall_head_state4:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),$00

	ld l,Part.angle
	ld a,(hl)
	add $03
	and $1f
	ld (hl),a

	; Distance from origin
	ld l,Part.var30
	ld (hl),$12

	; speed variable is used in a nonstandard way (added to var30, aka distance from
	; origin)
	ld l,Part.speed
	ld a,<($0340)
	ldi (hl),a
	ld (hl),>($0340)

	jp spikedBall_updatePosition


spikedBall_head_state5:
	call spikedBall_checkCollisionWithItem
	call spikedBall_head_updateDistanceFromOrigin
	jp spikedBall_updatePosition


; The chain part of the ball (just decorative)
spikedBall_chain:
	ld a,(de)
	or a
	jr nz,@state1

@state0:
	inc a
	ld (de),a ; [state]
	call partSetAnimation
	call objectSetVisible81

@state1:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp PART_SPIKED_BALL
	jp nz,partDelete

	; Copy parent's angle
	ld l,Part.angle
	ld e,l
	ld a,(hl)
	ld (de),a

	call spikedBall_chain_updateDistanceFromOrigin
	ld l,Part.relatedObj1+1
	ld b,(hl)
	jp spikedBall_updatePosition


;;
; @param	b	Enemy object
spikedBall_copyParentPosition:
	ld h,b
	ld l,Enemy.yh
	ldi a,(hl)
	sub $05
	ld b,a
	inc l
	ldi a,(hl)
	sub $05
	ld c,a
	inc l
	ld a,(hl)
	ld e,Part.zh
	ld (de),a
	ret


;;
; If the ball collides with any item other than Link, this sets its speed to 0 (begins
; retracting earlier).
spikedBall_checkCollisionWithItem:
	; Check for collision with any item other than Link himself
	ld h,d
	ld l,Part.var2a
	bit 7,(hl)
	ret z
	ld a,(hl)
	cp $80|ITEMCOLLISION_LINK
	ret z

	ld l,Part.speed+1
	bit 7,(hl)
	ret nz
	xor a
	ldd (hl),a
	ld (hl),a
	ret


;;
spikedBall_head_updateDistanceFromOrigin:
	ld h,d
	ld e,Part.var30
	ld l,Part.speed+1
	ld a,(de)
	add (hl)
	cp $0a
	jr c,@fullyRetracted

	ld (de),a

	; Deceleration
	dec l
	ld a,(hl)
	sub <($0020)
	ldi (hl),a
	ld a,(hl)
	sbc >($0020)
	ld (hl),a
	ret

@fullyRetracted:
	; Tell parent (ENEMY_BALL_AND_CHAIN_SOLDIER) we're fully retracted
	ld a,Object.counter1
	call objectGetRelatedObject1Var
	ld (hl),$00
	ret


;;
; Reads parent's var30 to decide whether to update state>
spikedBall_updateStateFromParent:
	ld l,Enemy.var30

	; Check state between 1-3
	ld e,Part.state
	ld a,(de)
	dec a
	cp $03
	jr c,++

	; If uninitialized (state 0), return
	inc a
	ret z

	; State is 4 or above (ball is being thrown).
	; Continue if [parent.var30] != 2 (signal to throw ball)
	ld a,(hl)
	cp $02
	ret z
++
	; Set state to:
	; * 1 if [parent.var30] == 0 (ball rotates slowly)
	; * 2 if [parent.var30] == 1 (ball rotates quickly)
	; * 3 if [parent.var30] >= 2 (ball should be thrown)
	ld a,(hl)
	or a
	ld c,$01
	jr z,++
	inc c
	dec a
	jr z,++
	inc c
++
	ld e,Part.state
	ld a,c
	ld (de),a
	ret

;;
; @param	h	Parent object (the actual ball)
spikedBall_chain_updateDistanceFromOrigin:
	ld l,Part.var30
	push hl
	ld e,Part.subid
	ld a,(de)
	dec a
	rst_jumpTable
	.dw @subid1
	.dw @subid2
	.dw @subid3

@subid1:
	; [var30] = [parent.var30] * 3/4
	pop hl
	ld e,l
	ld a,(hl)
	srl a
	srl a
	ld b,a
	add a
	add b
	inc a
	ld (de),a
	ret

@subid2:
	; [var30] = [parent.var30] * 2/4
	pop hl
	ld e,l
	ld a,(hl)
	srl a
	srl a
	add a
	ld (de),a
	ret

@subid3:
	; [var30] = [parent.var30] * 1/4
	pop hl
	ld e,l
	ld a,(hl)
	srl a
	srl a
	ld (de),a
	ret
