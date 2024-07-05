; ==================================================================================================
; ENEMY_PUMPKIN_HEAD
;
; Variables (body, subid 1):
;   relatedObj1: Reference to ghost
;   relatedObj2: Reference to head
;   var30: Stomp counter (stops stomping when it reaches 0)
;
; Variables (ghost, subid 2):
;   relatedObj1: Reference to body
;   var33/var34: Head's position (where ghost is moving toward)
;
; Variables (head, subid 3):
;   relatedObj1: Reference to body
;   var31: Link's direction last frame
;   var32: Head's orientation when it was picked up
; ==================================================================================================
enemyCode78:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	jr @normalStatus

@dead:
	call pumpkinHead_noHealth
	ret z

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr c,@commonState
	dec b
	ld a,b
	rst_jumpTable
	.dw pumpkinHead_body
	.dw pumpkinHead_ghost
	.dw pumpkinHead_head

@commonState:
	rst_jumpTable
	.dw pumpkinHead_state_uninitialized
	.dw pumpkinHead_state_spawner
	.dw pumpkinHead_state_grabbed
	.dw pumpkinHead_state_stub
	.dw pumpkinHead_state_stub
	.dw pumpkinHead_state_stub
	.dw pumpkinHead_state_stub
	.dw pumpkinHead_state_stub


pumpkinHead_state_uninitialized:
	ld a,b
	or a
	jp nz,ecom_setSpeedAndState8

	; Subid 0 (spawner)
	inc a
	ld (de),a ; [state] = 1
	ld a,ENEMY_PUMPKIN_HEAD
	ld b,$00
	jp enemyBoss_initializeRoom


pumpkinHead_state_spawner:
	; Wait for doors to close
	ld a,($cc93)
	or a
	ret nz

	ld b,$03
	call checkBEnemySlotsAvailable
	ret nz

	; Spawn body
	ld b,ENEMY_PUMPKIN_HEAD
	call ecom_spawnUncountedEnemyWithSubid01
	call objectCopyPosition
	ld c,h

	; Spawn ghost
	call ecom_spawnUncountedEnemyWithSubid01
	call @commonInit

	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	; [body.relatedObj1] = ghost
	ld a,h
	ld h,c
	ld l,Enemy.relatedObj1+1
	ldd (hl),a
	ld (hl),Enemy.start

	; Spawn head
	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl)
	call @commonInit

	; [body.relatedObj2] = head
	ld a,h
	ld h,c
	ld l,Enemy.relatedObj2+1
	ldd (hl),a
	ld (hl),Enemy.start

	; Delete spawner
	jp enemyDelete

@commonInit:
	inc (hl) ; [subid]++

	; [relatedObj1] = body
	ld l,Enemy.relatedObj1
	ld (hl),Enemy.start
	inc l
	ld (hl),c

	jp objectCopyPosition


pumpkinHead_state_grabbed:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @atRest

@justGrabbed:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	xor a
	ld (wLinkGrabState2),a

	ld l,Enemy.var31
	ld a,(w1Link.direction)
	ld (hl),a

	ld l,Enemy.direction
	ld e,Enemy.var32
	ld a,(hl)
	ld (de),a

	; [ghost.state] = $13
	ld a,Object.relatedObj1+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.state
	ld a,(hl)
	ld (hl),$13

	cp $13
	jr nc,++
	ld l,Enemy.zh
	ld (hl),$f8
	ld l,Enemy.invincibilityCounter
	ld (hl),$f4
++
	jp objectSetVisiblec1

@beingHeld:
	; Update animation based on Link's facing direction
	ld a,(w1Link.direction)
	ld h,d
	ld l,Enemy.var31
	cp (hl)
	ret z

	ld (hl),a

	ld l,Enemy.var32
	add (hl)
	and $03
	add a
	ld l,Enemy.direction
	ld (hl),a
	jp enemySetAnimation

@released:
	ret

@atRest:
	; [ghost.state] = $15
	ld a,Object.relatedObj1+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.state
	ld (hl),$15

	; [head.state] = $16
	ld h,d
	ld (hl),$16

	jp objectSetVisiblec2


pumpkinHead_state_stub:
	ret


pumpkinHead_body:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw pumpkinHead_body_state08
	.dw pumpkinHead_body_state09
	.dw pumpkinHead_body_state0a
	.dw pumpkinHead_body_state0b
	.dw pumpkinHead_body_state0c
	.dw pumpkinHead_body_state0d
	.dw pumpkinHead_body_state0e
	.dw pumpkinHead_body_state0f
	.dw pumpkinHead_body_state10
	.dw pumpkinHead_body_state11
	.dw pumpkinHead_body_state12
	.dw pumpkinHead_body_state13


; Initialization
pumpkinHead_body_state08:
	ld bc,$0106
	call enemyBoss_spawnShadow
	ret nz

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.oamFlags
	ld a,$01
	ldd (hl),a
	ld (hl),a

	call objectSetVisible83

	ld c,$08
	call ecom_setZAboveScreen

	ld a,$0d
	jp enemySetAnimation


; Falling from ceiling
pumpkinHead_body_state09:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN

	ld a,30

pumpkinHead_body_shakeScreen:
	call setScreenShakeCounter
	ld a,SND_DOORCLOSE
	jp playSound


; Waiting for head to catch up with body
pumpkinHead_body_state0a:
	ld a,Object.zh
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $f0
	ret c

	call ecom_decCounter1
	ret nz

	call pumpkinHead_body_chooseRandomStompTimerAndCount
	jr pumpkinHead_body_beginMoving


; Walking around
pumpkinHead_body_state0b:
	call pumpkinHead_body_countdownUntilStomp
	ret z

	call ecom_decCounter1
	jr z,pumpkinHead_body_chooseNextAction

	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr z,pumpkinHead_body_chooseNextAction

	jp enemyAnimate


pumpkinHead_body_chooseNextAction:
	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	ld b,a

	ld e,Enemy.angle
	ld a,(de)
	cp b
	jr nz,pumpkinHead_body_beginMoving

	; Currently facing toward Link. 1 in 4 chance of head firing projectiles.
	call getRandomNumber_noPreserveVars
	cp $40
	jr c,pumpkinHead_body_beginMoving

	; Head will fire projectiles.
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$38

	; [head.state] = $0b
	ld a,Object.state
	call objectGetRelatedObject2Var
	inc (hl)

	jr pumpkinHead_body_updateAnimationFromAngle


; Head is firing projectiles; waiting for it to finish.
pumpkinHead_body_state0c:
	call ecom_decCounter1
	ret nz

pumpkinHead_body_beginMoving:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0b

	ld l,Enemy.speed
	ld (hl),SPEED_80

	; Random duration of time to walk
	call getRandomNumber_noPreserveVars
	and $0f
	ld hl,pumpkinHead_body_walkDurations
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a

	call ecom_setRandomCardinalAngle

pumpkinHead_body_updateAnimationFromAngle:
	ld e,Enemy.angle
	ld a,(de)
	swap a
	rlca
	ld b,a

	ld hl,pumpkinHead_body_collisionRadiusXVals
	rst_addAToHl
	ld e,Enemy.collisionRadiusX
	ld a,(hl)
	ld (de),a

	ld a,b
	add $0b
	jp enemySetAnimation


pumpkinHead_body_walkDurations:
	.db 30, 30, 60, 60, 60, 60,  60,  90
	.db 90, 90, 90, 90, 90, 120, 120, 120

pumpkinHead_body_collisionRadiusXVals:
	.db $0c $08 $0c $08


; Preparing to stomp
pumpkinHead_body_state0d:
	call ecom_decCounter1
	jr z,pumpkinHead_body_beginStomp

	ld a,(hl)
	rrca
	ret nc
	call ecom_updateCardinalAngleTowardTarget
	jr pumpkinHead_body_updateAnimationFromAngle

pumpkinHead_body_beginStomp:
	ld l,Enemy.state
	ld (hl),$0e

	ld l,Enemy.speedZ
	ld a,<(-$3a0)
	ldi (hl),a
	ld (hl),>(-$3a0)

	ld l,Enemy.speed
	ld (hl),SPEED_100

	; [ghost.state] = $0c
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld (hl),$0c

	; [head.state] = $0e
	ld a,Object.state
	call objectGetRelatedObject2Var
	ld (hl),$0e

	; Update angle based on direction toward Link
	call ecom_updateAngleTowardTarget
	add $04
	and $18
	swap a
	rlca
	ld b,a
	ld hl,pumpkinHead_body_collisionRadiusXVals
	rst_addAToHl
	ld e,Enemy.collisionRadiusX
	ld a,(hl)
	ld (de),a

	ld a,b
	add $0b
	call enemySetAnimation
	jp objectSetVisible81


; In midair during stomp
pumpkinHead_body_state0e:
	ld c,$30
	call objectUpdateSpeedZ_paramC
	jp nz,ecom_applyVelocityForSideviewEnemyNoHoles

	; Hit ground

	ld l,Enemy.state
	inc (hl)

	ld e,Enemy.var30
	ld a,(de)
	dec a
	ld a,15
	jr nz,+
	ld a,30
+
	ld l,Enemy.counter1
	ld (hl),a

	ld a,20
	call pumpkinHead_body_shakeScreen
	jp objectSetVisible83


; Landed after a stomp
pumpkinHead_body_state0f:
	call ecom_decCounter1
	ret nz

	ld l,Enemy.var30
	dec (hl)
	jr nz,pumpkinHead_body_beginStomp
	jp pumpkinHead_body_beginMoving


; Body has been destroyed
pumpkinHead_body_state10:
	ret


; Head has moved up, body will now regenerate
pumpkinHead_body_state11:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$08
	ld l,Enemy.angle
	ld (hl),$10
	jp objectCreatePuff


; Delay before making body visible
pumpkinHead_body_state12:
	call ecom_decCounter1
	ret nz

	ld (hl),30 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	call objectSetVisible83

	ld a,$0d
	jp enemySetAnimation


; Body has regenerated, waiting a moment before resuming
pumpkinHead_body_state13:
	call ecom_decCounter1
	ret nz

	ld l,Enemy.collisionType
	set 7,(hl)

	call pumpkinHead_body_chooseRandomStompTimerAndCount
	jp pumpkinHead_body_beginMoving


pumpkinHead_ghost:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw pumpkinHead_ghost_state08
	.dw pumpkinHead_ghost_state09
	.dw pumpkinHead_ghost_state0a
	.dw pumpkinHead_ghost_state0b
	.dw pumpkinHead_ghost_state0c
	.dw pumpkinHead_ghost_state0d
	.dw pumpkinHead_ghost_state0e
	.dw pumpkinHead_ghost_state0f
	.dw pumpkinHead_ghost_state10
	.dw pumpkinHead_ghost_state11
	.dw pumpkinHead_ghost_state12
	.dw pumpkinHead_ghost_state13
	.dw pumpkinHead_ghost_state14
	.dw pumpkinHead_ghost_state15
	.dw pumpkinHead_ghost_state16
	.dw pumpkinHead_ghost_state17


; Initialization
pumpkinHead_ghost_state08:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PUMPKIN_HEAD_GHOST

	ld l,Enemy.oamFlags
	ld a,$05
	ldd (hl),a
	ld (hl),a

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.collisionRadiusY
	ld a,$06
	ldi (hl),a
	ld (hl),a

	call objectSetVisible83
	ld c,$20
	call ecom_setZAboveScreen

	ld a,$0a
	jp enemySetAnimation


; Falling from ceiling. (Also called by "head" state 9.)
pumpkinHead_ghost_state09:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ld l,Enemy.zh
	ld a,(hl)
	cp $f0
	ret c

	ld (hl),$f0
	ld l,Enemy.state
	inc (hl)
	ret


; Waiting for head to fall into place
pumpkinHead_ghost_state0a:
	; Check [head.zh]
	ld a,Object.relatedObj2+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.zh
	ld a,(hl)
	cp $f0
	ret nz

	ld e,Enemy.state
	ld a,$0b
	ld (de),a
	call objectSetInvisible


; Copy body's position
pumpkinHead_ghost_state0b:
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	jp objectTakePosition


; Body just began stomping; is moving upward
pumpkinHead_ghost_state0c:
	call pumpkinHead_ghostOrHead_updatePositionWhileStompingUp
	ret nz

	call ecom_incState
	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a
	call objectSetVisible81


; Body is stomping; moving downward
pumpkinHead_ghost_state0d:
	ld c,$28
	call pumpkinHead_ghostOrHead_updatePositionWhileStompingDown
	ret c

	ld (hl),$f0 ; [zh]
	ld l,Enemy.state
	inc (hl)
	jp objectSetVisible83


; Reached target z-position after stomping; waiting for head to catch up
pumpkinHead_ghost_state0e:
	ld a,Object.relatedObj2+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.zh
	ld a,(hl)
	cp $ee
	ret c

	ld e,Enemy.state
	ld a,$0b
	ld (de),a
	jp objectSetInvisible


; Body just destroyed
pumpkinHead_ghost_state0f:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speedZ
	ld a,<(-$120)
	ldi (hl),a
	ld (hl),>(-$120)

	jp objectSetInvisible


; Falling to ground after body disappeared
pumpkinHead_ghost_state10:
	ld c,$28
	call objectUpdateSpeedZ_paramC
	ret nz

	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),$08
	ret


; Delay before going to next state?
pumpkinHead_ghost_state11:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [state]
	ret


; Waiting for head to be picked up
pumpkinHead_ghost_state12:
	ret


; Link just grabbed the head; ghost runs away
pumpkinHead_ghost_state13:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),60

	ld l,Enemy.speed
	ld (hl),SPEED_140
	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.collisionType
	set 7,(hl)
	call objectSetVisiblec2

	call ecom_updateCardinalAngleAwayFromTarget

	ld a,$0a
	jp enemySetAnimation


; Falling to ground, then running away with angle computed earlier
pumpkinHead_ghost_state14:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call ecom_decCounter1
	jr nz,++

	ld l,Enemy.state
	inc (hl)
	call objectSetVisible82
++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp enemyAnimate


; Stopped running away, or head just landed on ground
pumpkinHead_ghost_state15:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),120
	ld a,$09
	jp enemySetAnimation


; After [counter1] frames, will choose which direction to move in next
pumpkinHead_ghost_state16:
	call ecom_decCounter1
	jr nz,@checkHeadOnGround

	ld (hl),60 ; [counter1]
	ld l,e
	dec (hl)
	dec (hl) ; [state] = $14

	call getRandomNumber_noPreserveVars
	and $1c
	ld e,Enemy.angle
	ld (de),a
	jr @setAnim

@checkHeadOnGround:
	; Check [head.state] to see if head is at rest on the ground
	ld a,Object.relatedObj2+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.state
	ld a,(hl)
	cp $02
	jp z,enemyAnimate

	ld h,d
	inc (hl) ; [this.state]

	; Copy head's position, use that as target position to move toward.
	; [this.var33] = [head.yh]
	ld a,Object.relatedObj2+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.yh
	ld e,Enemy.var33
	ldi a,(hl)
	ld (de),a

	; [this.var34] = [head.xh]
	inc l
	inc e
	ld a,(hl)
	ld (de),a

@setAnim:
	ld a,$0a
	jp enemySetAnimation


; Moving toward head (or where head used to be)
pumpkinHead_ghost_state17:
	ld h,d
	ld l,Enemy.var33
	call ecom_readPositionVars
	sub c
	add $08
	cp $11
	jr nc,@moveTowardHead
	ldh a,(<hFF8F)
	sub b
	add $08
	cp $11
	jr nc,@moveTowardHead

	; Reached head.

	; Check [head.state] to see if it's being held
	ld a,Object.relatedObj2+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.state
	ld a,(hl)
	cp $02
	ret z

	ld (hl),$13 ; [head.state] = $13

	ld h,d
	ld (hl),$0b ; [this.state] = $0b

	ld l,Enemy.collisionType
	res 7,(hl)
	jp objectSetInvisible

@moveTowardHead:
	call ecom_moveTowardPosition
	jp enemyAnimate


pumpkinHead_head:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw pumpkinHead_head_state08
	.dw pumpkinHead_head_state09
	.dw pumpkinHead_head_state0a
	.dw pumpkinHead_head_state0b
	.dw pumpkinHead_head_state0c
	.dw pumpkinHead_head_state0d
	.dw pumpkinHead_head_state0e
	.dw pumpkinHead_head_state0f
	.dw pumpkinHead_head_state10
	.dw pumpkinHead_head_state11
	.dw pumpkinHead_head_state12
	.dw pumpkinHead_head_state13
	.dw pumpkinHead_head_state14
	.dw pumpkinHead_head_state15
	.dw pumpkinHead_head_state16


; Initialization
pumpkinHead_head_state08:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.angle
	ld (hl),$ff

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PUMPKIN_HEAD_HEAD

	ld l,Enemy.collisionRadiusY
	ld (hl),$06

	call objectSetVisible82
	ld c,$30
	call ecom_setZAboveScreen

	ld a,$04
	ld b,$00

;;
pumpkinHead_head_setAnimation:
	ld e,Enemy.direction
	ld (de),a
	add b
	ld b,a
	srl a
	ld hl,@collisionRadiusXVals
	rst_addAToHl
	ld e,Enemy.collisionRadiusX
	ld a,(hl)
	ld (de),a
	ld a,b
	jp enemySetAnimation

@collisionRadiusXVals:
	.db $08 $06 $08 $06


pumpkinHead_head_state09:
	call pumpkinHead_ghost_state09
	ret c

	ld a,MUS_BOSS
	ld (wActiveMusic),a
	jp playSound


; Head follows body. Called by other states.
pumpkinHead_head_state0a:
	call objectSetPriorityRelativeToLink

	ld a,Object.animParameter
	call objectGetRelatedObject1Var
	ld a,(hl)
	push hl
	ld hl,@headZOffsets
	rst_addAToHl
	ldi a,(hl)
	ld c,a
	ld b,$00
	ld a,(hl)
	pop hl
	push af
	call objectTakePositionWithOffset

	pop af
	ld e,Enemy.zh
	ld (de),a

	; Check whether body's angle is different from head's angle
	ld l,Enemy.angle
	ld e,l
	ld a,(de)
	cp (hl)
	jp z,enemyAnimate

	ld a,(hl)
	ld (de),a
	rrca
	rrca
	ld b,$00
	jr pumpkinHead_head_setAnimation

; Offsets for head relative to body. Indexed by body's animParameter.
;   b0: Y offset
;   b1: Z position
@headZOffsets:
	.db $00 $f0
	.db $01 $f0
	.db $00 $ef


; Preparing to fire projectiles
pumpkinHead_head_state0b:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),20

	call pumpkinHead_head_state0a

	ld e,Enemy.angle
	ld a,(de)
	rrca
	rrca
	ld b,$01
	jp pumpkinHead_head_setAnimation


; Delay before firing projectile
pumpkinHead_head_state0c:
	call ecom_decCounter1
	jp nz,objectSetPriorityRelativeToLink

	; Fire projectile
	ld (hl),36 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.angle
	ld a,(hl)
	rrca
	rrca
	ld b,$00
	call pumpkinHead_head_setAnimation
	call getFreePartSlot
	ret nz

	ld (hl),PART_PUMPKIN_HEAD_PROJECTILE
	ld l,Part.angle
	ld e,Enemy.angle
	ld a,(de)
	ld (hl),a
	call objectCopyPosition

	ld a,SND_VERAN_FAIRY_ATTACK
	jp playSound


; Delay after firing projectile
pumpkinHead_head_state0d:
	call ecom_decCounter1
	jp nz,objectSetPriorityRelativeToLink

	ld l,e
	ld (hl),$0a ; [state]
	jr pumpkinHead_head_state0a


; Began a stomp; moving up
pumpkinHead_head_state0e:
	call pumpkinHead_ghostOrHead_updatePositionWhileStompingUp
	jr z,@movingDown

	; Update angle
	ld l,Enemy.angle
	ld e,l
	ld a,(de)
	cp (hl)
	ret z
	ld a,(hl)
	ld (de),a
	add $04
	and $18
	rrca
	rrca
	ld b,$00
	jp pumpkinHead_head_setAnimation

@movingDown:
	call ecom_incState
	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a
	call objectSetVisible80


; Body is stomping; moving down
pumpkinHead_head_state0f:
	ld c,$20
	call pumpkinHead_ghostOrHead_updatePositionWhileStompingDown
	ret c

	; Reached target position
	ld (hl),$f0 ; [zh]
	ld l,Enemy.state
	ld (hl),$0a
	jp objectSetVisible82


; Body just destroyed
pumpkinHead_head_state10:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speedZ
	ld a,<(-$120)
	ldi (hl),a
	ld (hl),>(-$120)
	jp objectSetVisiblec2


; Head falling down after body destroyed
pumpkinHead_head_state11:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),120
	ret


; Head is grabbable for 120 frames
pumpkinHead_head_state12:
	call ecom_decCounter1
	jp nz,pumpkinHead_head_state16

	ld l,e
	inc (hl) ; [state]

	; [ghost.state] = $0b
	ld a,Object.relatedObj1+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.state
	ld (hl),$0b
	ret


; Ghost just re-entered head, or head timed out before Link grabbed it
pumpkinHead_head_state13:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$10

	ld l,Enemy.collisionRadiusX
	ld (hl),$0a

	ld a,$08
	jp enemySetAnimation


; Delay before moving back up, respawning body
pumpkinHead_head_state14:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speedZ
	ld a,<(-$200)
	ldi (hl),a
	ld (hl),>(-$200)

	ld l,Enemy.collisionRadiusX
	ld (hl),$06
	ld a,$04
	jp enemySetAnimation


; Head moving up
pumpkinHead_head_state15:
	ld c,$20
	call objectUpdateSpeedZ_paramC

	ld l,Enemy.zh
	ld a,(hl)
	cp $f1
	ret nc

	; Head has gone up high enough; respawn body now.

	ld (hl),$f0 ; [zh]

	ld l,Enemy.state
	ld (hl),$0a

	ld l,Enemy.collisionRadiusX
	ld (hl),$0c

	call objectSetVisible82

	; [body.state] = $11
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld (hl),$11

	; Copy head's position to ghost
	call objectCopyPosition

	; [ghost.zh]
	ld l,Enemy.zh
	ld (hl),$00

	ld a,$04
	ld b,$00
	jp pumpkinHead_head_setAnimation


; Head has just come to rest after being thrown.
; Called by other states (to make it grabbable).
pumpkinHead_head_state16:
	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	ret z
	call objectAddToGrabbableObjectBuffer
	jp objectPushLinkAwayOnCollision


;;
; @param[out]	zflag	z if time to stomp
pumpkinHead_body_countdownUntilStomp:
	ld a,(wFrameCounter)
	rrca
	ret c
	call ecom_decCounter2
	ret nz

	ld l,Enemy.state
	ld (hl),$0d
	ld l,Enemy.counter1
	ld (hl),60

;;
; Randomly sets the duration until a stomp occurs, and the number of stomps to perform.
pumpkinHead_body_chooseRandomStompTimerAndCount:
	ld bc,$0701
	call ecom_randomBitwiseAndBCE
	ld a,b
	ld hl,@counter2Vals
	rst_addAToHl

	ld e,Enemy.counter2
	ld a,(hl)
	ld (de),a

	ld e,Enemy.var30
	ld a,c
	add $02
	ld (de),a
	xor a
	ret

@counter2Vals:
	.db 90, 120, 120, 120, 150, 150, 150, 180

;;
; @param[out]	zflag	z if body is moving down
pumpkinHead_ghostOrHead_updatePositionWhileStompingUp:
	ld a,Object.speedZ+1
	call objectGetRelatedObject1Var
	bit 7,(hl)
	ret z

	call objectTakePosition
	ld e,Enemy.zh
	ld a,(de)
	sub $10
	ld (de),a
	ret

;;
; @param	c	Gravity
; @param[out]	hl	Enemy.zh
; @param[out]	cflag	nc if reached target z-position
pumpkinHead_ghostOrHead_updatePositionWhileStompingDown:
	call objectUpdateSpeedZ_paramC
	ld l,Enemy.zh
	ld a,(hl)
	cp $f0
	ret nc

	push af
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	call objectTakePosition
	pop af
	ld e,Enemy.zh
	ld (de),a
	ret


;;
pumpkinHead_noHealth:
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jr z,@bodyHealthZero
	dec a
	jr z,@ghostHealthZero

@headHealthZero:
	call objectCreatePuff
	ld h,d
	ld l,Enemy.state
	ldi a,(hl)
	cp $02
	jr nz,@delete

	ld a,(hl) ; [substate]
	cp $02
	call c,dropLinkHeldItem
@delete:
	jp enemyDelete

@ghostHealthZero:
	ld e,Enemy.collisionType
	ld a,(de)
	or a
	jr nz,++
	call ecom_killRelatedObj1
	ld l,Enemy.relatedObj2+1
	ld h,(hl)
	call ecom_killObjectH
++
	call enemyBoss_dead
	xor a
	ret

@bodyHealthZero:
	; Delete self if ghost's health is 0
	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,enemyDelete

	; Otherwise, the body just disappears temporarily
	ld h,d
	ld l,Enemy.health
	ld (hl),$08

	ld l,Enemy.state
	ld (hl),$10

	ld l,Enemy.zh
	ld (hl),$00

	; [ghost.state] = $0f
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld (hl),$0f

	; [head.state] = $10
	ld a,Object.state
	call objectGetRelatedObject2Var
	ld (hl),$10

	call objectCreatePuff
	jp objectSetInvisible
