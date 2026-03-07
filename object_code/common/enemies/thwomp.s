; ==================================================================================================
; ENEMY_THWOMP
;
; Variables:
;   var30: Original y-position (where it returns to after stomping)
; ==================================================================================================
enemyCode2f:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

@normalStatus:
	call @runState
	jp thwomp_updateLinkRidingSelf

@runState:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw thwomp_uninitialized
	.dw thwomp_state_stub
	.dw thwomp_state_stub
	.dw thwomp_state_stub
	.dw thwomp_state_stub
	.dw thwomp_state_stub
	.dw thwomp_state_stub
	.dw thwomp_state_stub
	.dw thwomp_state8
	.dw thwomp_state9
	.dw thwomp_stateA
	.dw thwomp_stateB


thwomp_uninitialized:
	; Note: a is uninitialized; arbitrary speed
	call ecom_setSpeedAndState8

	ld l,Enemy.var30
	ld e,Enemy.yh
	ld a,(de)
	ld (hl),a

	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN
	ld a,$04
	call enemySetAnimation
	jp objectSetVisible82


thwomp_state_stub:
	ret


; Waiting for Link to approach
thwomp_state8:
	ld h,d
	ld l,Enemy.xh
	ld a,(w1Link.xh)
	sub (hl)
	add $14
	cp $29
	jr c,@linkApproached

	; Update eye looking at Link
	call objectGetAngleTowardLink
	add $02
	and $1c
	ld h,d
	ld l,Enemy.angle
	cp (hl)
	ret z
	ld (hl),a
	rrca
	rrca
	jp enemySetAnimation

@linkApproached:
	call ecom_incState
	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a
	ld a,$08
	jp enemySetAnimation


; Falling to ground
thwomp_state9:
	ld b,$10
	ld a,$30
	call objectUpdateSpeedZ_sidescroll_givenYOffset
	jr c,@hitGround

	; Cap speedZ to $0200 (ish... doesn't fix the low byte)
	ld a,(hl)
	cp $03
	ret c
	ld (hl),$02
	ret

@hitGround:
	call ecom_incState

	ld l,Enemy.counter2
	ld (hl),60
	ld a,45
	ld (wScreenShakeCounterY),a

	ld a,SND_DOORCLOSE
	jp playSound


; Resting on ground for 50 frames after hitting it, then moving back to starting position
thwomp_stateA:
	call ecom_decCounter2
	ret nz

	ld e,Enemy.yh
	ld l,Enemy.var30
	ld a,(de)
	cp (hl)
	jr z,@doneMovingUp

	ld l,Enemy.y
	ld a,(hl)
	sub $80
	ldi (hl),a
	ld a,(hl)
	sbc $00
	ld (hl),a
	ret

@doneMovingUp:
	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),$20
	ret


; Cooldown before stomping again
thwomp_stateB:
	call ecom_decCounter1
	ret nz

	ld l,e
	ld (hl),$08 ; [state] = 8
	jp thwomp_updateLinkRidingSelf


;;
; Unused function
;
; @param	bc	Position offset
; @param[out]	a	Tile collisions at thwomp's position + offset bc
thwomp_func67ba:
	ld e,Enemy.yh
	ld a,(de)
	add b
	ld b,a
	ld e,Enemy.xh
	ld a,(de)
	ld c,a
	jp getTileCollisionsAtPosition


;;
; Checks if Link is riding the thwomp, updates appropriate variables if so.
thwomp_updateLinkRidingSelf:
	ld h,d
	ld l,Enemy.xh
	ld a,(w1Link.xh)
	sub (hl)
	add $13
	cp $27
	jr nc,@notRiding

	ld a,(w1Link.collisionRadiusY)
	ld b,a
	ld l,Enemy.collisionRadiusY
	ld e,Enemy.yh
	ld a,(de)
	sub (hl)
	sub b
	ld c,a

	ld a,(w1Link.yh)
	sub c
	add $03
	cp $07
	jr nc,@notRiding

	ld a,c
	sub $03
	ld (w1Link.yh),a
	ld a,d
	ld (wLinkRidingObject),a
	ret

@notRiding:
	; Only clear wLinkRidingObject if it's already equal to this object's index.
	ld a,(wLinkRidingObject)
	sub d
	ret nz
	ld (wLinkRidingObject),a
	ret
