; ==================================================================================================
; ENEMY_SMASHER
;
; Variables (ball, subid 0):
;   relatedObj1: parent
;   var30: Counter until the ball respawns
;
; Variables (parent, subid 1):
;   relatedObj1: ball
;   var30/var31: Target position (directly in front of ball object)
;   var32: Nonzero if already initialized
; ==================================================================================================
enemyCode74:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jr z,@normalStatus
	jp ecom_updateKnockback

@dead:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr nz,@mainDead

	; Ball dead
	call smasher_ball_makeLinkDrop
	call objectCreatePuff
	jp enemyDelete

@mainDead:
	ld e,Enemy.collisionType
	ld a,(de)
	or a
	call nz,ecom_killRelatedObj1
	jp enemyBoss_dead

@normalStatus:
	call smasher_ball_updateRespawnTimer
	call ecom_getSubidAndCpStateTo08
	jr c,@commonState
	ld a,b
	or a
	jp z,smasher_ball
	jp smasher_parent

@commonState:
	rst_jumpTable
	.dw smasher_state_uninitialized
	.dw smasher_state_stub
	.dw smasher_state_grabbed
	.dw smasher_state_stub
	.dw smasher_state_stub
	.dw smasher_state_stub
	.dw smasher_state_stub
	.dw smasher_state_stub


smasher_state_uninitialized:
	ld a,b
	or a
	jr nz,@alreadySpawnedParent

@initializeBall:
	ld b,a
	ld a,$ff
	call enemyBoss_initializeRoom

	; Spawn parent
	ld b,ENEMY_SMASHER
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz

	; [parent.enabled] = [ball.enabled]
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	; [ball.relatedObj1] = parent
	; [parent.relatedObj1] = ball
	ld l,Enemy.relatedObj1
	ld e,l
	ld a,Enemy.start
	ldi (hl),a
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld (hl),d

	call objectCopyPosition

	; If parent object has a lower index than ball object, swap them
	ld a,h
	cp d
	jr nc,@initialize

	ld l,Enemy.subid
	ld (hl),$80 ; Change former "parent" to "ball"
	ld e,l
	ld a,$01
	ld (de),a   ; Change former "ball" (this) to "parent"

@alreadySpawnedParent:
	dec a
	jr z,@gotoState8

	; Effectively clears bit 7 of parent's subid (should be $80 when it reaches here)
	ld e,Enemy.subid
	xor a
	ld (de),a

@initialize:
	ld a,$01
	call smasher_setOamFlags

	ld l,Enemy.xh
	ld a,(hl)
	sub $20
	ld (hl),a

	ld a,$04
	call enemySetAnimation

@gotoState8:
	jp ecom_setSpeedAndState8AndVisible


smasher_state_grabbed:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @atRest

@justGrabbed:
	ld h,d
	ld l,e
	inc (hl)
	ld a,2<<4
	ld (wLinkGrabState2),a
	jp objectSetVisiblec1

@beingHeld:
	ret

@released:
	call ecom_bounceOffWallsAndHoles
	jr z,++

	; Hit a wall; copy new angle to the "throw item" that's controlling this
	ld e,Enemy.angle
	ld a,(de)
	ld hl,w1ReservedItemC.angle
	ld (hl),a
++
	; Return if parent was already hit
	ld a,Object.invincibilityCounter
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	ret nz

	; Check if we've collided with parent
	ld l,Enemy.zh
	ld e,l
	ld a,(de)
	sub (hl)
	add $08
	cp $11
	ret nc
	call checkObjectsCollided
	ret nc

	; We've collided

	ld l,Enemy.invincibilityCounter
	ld (hl),$20
	ld l,Enemy.knockbackCounter
	ld (hl),$10

	ld l,Enemy.health
	dec (hl)

	; Calculate knockback angle for boss
	call smasher_ball_loadPositions
	push hl
	call objectGetRelativeAngleWithTempVars
	pop hl
	ld l,Enemy.knockbackAngle
	ld (hl),a

	; Reverse knockback angle for ball
	xor $10
	ld hl,w1ReservedItemC.angle
	ld (hl),a

	ld a,SND_BOSS_DAMAGE
	jp playSound

@atRest:
	dec e
	ld a,$08
	ld (de),a ; [state] = 8
	jp objectSetVisiblec2


smasher_state_stub:
	ret


smasher_ball:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw smasher_ball_state8
	.dw smasher_ball_state9
	.dw smasher_ball_stateA
	.dw smasher_ball_stateB
	.dw smasher_ball_stateC
	.dw smasher_ball_stateD
	.dw smasher_ball_stateE
	.dw smasher_ball_stateF


; Initialization (or just reappeared after disappearing)
smasher_ball_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_SMASHER_BALL
	ld l,Enemy.speed
	ld (hl),SPEED_a0


; Lying on ground, waiting for parent or Link to pick it up
smasher_ball_state9:
	call objectAddToGrabbableObjectBuffer
	jp objectPushLinkAwayOnCollision


; Parent is picking up the ball
smasher_ball_stateA:
	ld h,d
	ld l,Enemy.zh
	ldd a,(hl)
	cp $f4
	jr z,++

	; [ball.z] -= $0080 (moving up)
	ld a,(hl)
	sub <($0080)
	ldi (hl),a
	ld a,(hl)
	sbc >($0080)
	ld (hl),a
++
	; Move toward parent on Y/X axis
	ld a,Object.yh
	call objectGetRelatedObject1Var
	call smasher_ball_loadPositions
	cp c
	jp nz,ecom_moveTowardPosition
	ldh a,(<hFF8F)
	cp b
	jp nz,ecom_moveTowardPosition

	; Reached parent's Y/X position; wait for Z as well
	ld e,Enemy.zh
	ld a,(de)
	cp $f4
	ret nz

	; Reached position; go to next state
	call ecom_incState

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.speed
	ld (hl),SPEED_300
	jp objectSetVisiblec1


; This state is a signal for the parent, which will update the ball's state when it gets
; released.
smasher_ball_stateB:
	ret


; Being thrown
smasher_ball_stateC:
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jr c,@doneBouncing
	jr nz,++

	; Hit ground
	ld e,Enemy.speed
	ld a,(de)
	srl a
	ld (de),a
	call smasher_ball_playLandSound
++
	call ecom_bounceOffWallsAndHoles
	jp objectApplySpeed

@doneBouncing:
	ld h,d
	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.collisionType
	res 7,(hl)
	call objectSetVisiblec2

smasher_ball_playLandSound:
	ld a,SND_BOMB_LAND
	jp playSound


; Disappearing (either after being thrown, or after a time limit)
smasher_ball_stateD:
	call objectCreatePuff
	ret nz

	; If parent is picking up or throwing the ball, cancel that
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0b
	jr c,++
	ld (hl),$0d ; [parent.state]
	ld l,Enemy.oamFlagsBackup
	ld a,$03
	ldi (hl),a
	ld (hl),a
++
	call ecom_incState

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.counter1
	ld (hl),60
	jp objectSetInvisible


; Ball is gone, will reappear after [counter1] frames
smasher_ball_stateE:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.zh
	ld (hl),-$20

	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a

	; Choose random position to spawn at
	call getRandomNumber_noPreserveVars
	and $0e
	ld hl,@spawnPositions
	rst_addAToHl
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a

	call objectCreatePuff
	jp objectSetVisiblec1

@spawnPositions:
	.db $38 $38
	.db $78 $38
	.db $38 $78
	.db $78 $78
	.db $38 $b8
	.db $78 $b8
	.db $58 $58
	.db $58 $98


; Ball is falling to ground after reappearing
smasher_ball_stateF:
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jr c,@doneBouncing
	ret nz
	jp smasher_ball_playLandSound

@doneBouncing:
	ld e,Enemy.state
	ld a,$08
	ld (de),a
	jp objectSetVisiblec2


smasher_parent:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw smasher_parent_state8
	.dw smasher_parent_state9
	.dw smasher_parent_stateA
	.dw smasher_parent_stateB
	.dw smasher_parent_stateC
	.dw smasher_parent_stateD


; Initialization
smasher_parent_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$01

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	; Don't do below function call if already initialized
	ld l,Enemy.var32
	bit 0,(hl)
	jr nz,smasher_parent_state9

	inc (hl) ; [var32]
	call enemyBoss_beginMiniboss


smasher_parent_state9:
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $09
	jr z,@moveTowardBall

	; Ball unavailable; moving aronund in random angles

	call ecom_decCounter1
	jr nz,@updateMovement

	; Time to choose a new angle
	ld (hl),60 ; [counter1]

	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@randomAngles
	rst_addAToHl
	ld e,Enemy.angle
	ld a,(hl)
	ld (de),a
	call smasher_updateDirectionFromAngle

@updateMovement:
	call ecom_applyVelocityForSideviewEnemyNoHoles
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr nz,@updateAnim

	call smasher_hop
	ld e,Enemy.direction
	ld a,(de)
	inc a
	jp enemySetAnimation

@updateAnim:
	; Change animation when he reaches the peak of his hop (speedZ is zero)
	ldd a,(hl)
	or (hl)
	ret nz
	ld e,Enemy.direction
	ld a,(de)
	jp enemySetAnimation

@moveTowardBall:
	; Copy ball's Y-position to var30 (Y-position to move to)
	ld l,Enemy.yh
	ld e,Enemy.var30
	ldi a,(hl)
	ld (de),a

	; Calculate X-position to move to ($0e pixels to one side of the ball), then store
	; the value in var31
	inc l
	ld e,l
	ld a,(de) ; [parent.xh]
	cp (hl)   ; [ball.xh]
	ld a,$0e
	jr nc,+
	ld a,-$0e
+
	ld c,a

	add (hl) ; [ball.xh]
	ld b,a
	sub $18
	cp $c0
	jr c,++
	ld a,c
	cpl
	inc a
	add a
	add b
	ld b,a
++
	ld h,d
	ld l,Enemy.var31
	ld (hl),b

	; Goto next state to move toward the ball
	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.speed
	ld (hl),SPEED_100

	ld l,Enemy.var30
	call ecom_readPositionVars
	call smasher_updateAngleTowardPosition
	jp enemySetAnimation


@randomAngles: ; When ball is unavailable, smasher move randomly in one of these angles
	.db $06 $0a $16 $1a


; Moving toward ball on the ground
smasher_parent_stateA:
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $09
	jr nz,smasher_parent_linkPickedUpBall

	; Check if we've reached the target position in front of the ball
	ld h,d
	ld l,Enemy.var30
	call ecom_readPositionVars
	sub c
	add $02
	cp $05
	jr nc,@movingTowardBall
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jr nc,@movingTowardBall

	; We've reached the position

	ld l,Enemy.state
	inc (hl) ; [parent.state]

	ld l,Enemy.zh
	ld (hl),$00

	ld a,$02
	call smasher_setOamFlags

	ld a,Object.state
	call objectGetRelatedObject1Var
	inc (hl) ; [ball.state] = $0a

	; Face toward the ball? ('b' is still set to the y-position from before?)
	ld l,Enemy.xh
	ld c,(hl)
	call smasher_updateAngleTowardPosition
	inc a
	jp enemySetAnimation

@movingTowardBall:
	call ecom_moveTowardPosition

	ld e,Enemy.angle
	ld a,(de)
	call smasher_updateDirectionFromAngle
	call enemySetAnimation

	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	jr smasher_hop


smasher_parent_linkPickedUpBall:
	; Stop chasing the ball
	ld h,d
	ld l,Enemy.state
	ld (hl),$09

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	ld l,Enemy.counter1
	ld (hl),60

	ld a,$03
	call smasher_setOamFlags

	; Run away from Link
	call ecom_updateCardinalAngleAwayFromTarget
	jp smasher_updateDirectionFromAngle


; About to pick up ball
smasher_parent_stateB:
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMYSTATE_GRABBED
	jr z,smasher_parent_linkPickedUpBall

	; Wait for ball's state to update
	cp $0b
	ret c

	ld a,$03
	call smasher_setOamFlags

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter2
	ld (hl),30

	ld l,Enemy.speed
	ld (hl),SPEED_40

;;
smasher_hop:
	ld l,Enemy.speedZ
	ld a,<(-$c0)
	ldi (hl),a
	ld (hl),>(-$c0)
	ret


; Just picked up ball; hopping while moving slowly toward Link
smasher_parent_stateC:
	call smasher_updateAngleTowardLink
	inc a
	call enemySetAnimation

	call ecom_decCounter2

	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr z,@hitGround

	call ecom_applyVelocityForSideviewEnemyNoHoles

	; Update ball's position
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	call objectCopyPosition
	dec l
	ld e,l
	ld a,(de) ; [parent.zh]
	add $f4
	ld (hl),a ; [ball.zh]
	ret

@hitGround:
	ld e,Enemy.counter2
	ld a,(de)
	or a
	jp nz,smasher_hop

	; Done hopping; go to next state to leap into the air

	ld a,>(-$1e0)
	ldd (hl),a
	ld (hl),<(-$1e0)

	ld l,Enemy.state
	inc (hl)

	ld a,$02
	jp smasher_setOamFlags


; In midair just before throwing ball
smasher_parent_stateD:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr nz,@inMidair

	; Hit the ground
	ld l,Enemy.state
	ld (hl),$08
	ret

@inMidair:
	ld a,Object.zh
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(de)
	add $f4
	ld (hl),a

	ld e,Enemy.speedZ+1
	ld a,(de)
	rlca
	jr nc,@movingDown

	; Moving up
	call smasher_updateAngleTowardLink
	inc a
	jp enemySetAnimation

@movingDown:
	; Return if speedZ is nonzero (not at peak of jump)
	ld b,a
	dec e
	ld a,(de)
	or b
	ret nz

	; Throw the ball if its state is valid for this
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0b
	ret nz

	inc (hl) ; [ball.state]
	ld l,Enemy.angle
	ld e,l
	ld a,(de)
	ld (hl),a

	ld a,$03
	call smasher_setOamFlags

	ld e,Enemy.direction
	ld a,(de)
	jp enemySetAnimation


;;
; @param[out]	a	direction value
smasher_updateAngleTowardPosition:
	call objectGetRelativeAngleWithTempVars
	ld e,Enemy.angle
	ld (de),a
	jr smasher_updateDirectionFromAngle

;;
smasher_updateAngleTowardLink:
	call objectGetAngleTowardEnemyTarget
	ld e,Enemy.angle
	ld (de),a

;;
; @param	a	angle
; @param[out]	a	direction value
smasher_updateDirectionFromAngle:
	ld b,a
	and $0f
	ret z
	ld a,b
	and $10
	xor $10
	swap a
	rlca
	ld e,Enemy.direction
	ld (de),a
	ret


;;
; @param	a	Value for oamFlags
smasher_setOamFlags:
	ld h,d
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	ret

;;
; Loads positions into bc and hFF8E/hFF8F for subsequent call to
; "objectGetRelativeAngleWithTempVars".
;
; @param	h	Parent object
smasher_ball_loadPositions:
	ld l,Enemy.yh
	ld e,l
	ld a,(de)
	ldh (<hFF8F),a
	ld b,(hl)
	ld l,Enemy.xh
	ld e,l
	ld a,(de)
	ldh (<hFF8E),a
	ld c,(hl)
	ret


;;
; Updates the ball's "respawn timer" and makes it disappear (goes to state $0d) when it
; hits zero.
smasher_ball_updateRespawnTimer:
	; Return if this isn't the ball
	ld e,Enemy.subid
	ld a,(de)
	or a
	ret nz

	ld e,Enemy.state
	ld a,(de)
	cp $0d
	ret nc
	ld a,(wFrameCounter)
	rrca
	ret c

	ld h,d
	ld l,Enemy.var30
	inc (hl)
	ld a,(hl)
	cp 180
	ret c

	ld (hl),$00
	call smasher_ball_makeLinkDrop
	ld e,Enemy.state
	ld a,$0d
	ld (de),a
	ret


;;
smasher_ball_makeLinkDrop:
	ld e,Enemy.state
	ld a,(de)
	cp $02
	ret nz
	inc e
	ld a,(de)
	cp $02
	ret nc
	jp dropLinkHeldItem
