; ==================================================================================================
; ENEMY_ARMOS_WARRIOR
;
; Variables (for parent only, subid 1):
;   var30: "Turn" direction (should be 8 or -8)
;   var31: Shield
;   var32: Sword
;
; Variables (for shield only, subid 2):
;   relatedObj1: parent
;   relatedObj2: shield
;   var30: Animation index (0 or 1)
;   var31: Animation base (multiple of 2, for broken shield animation)
;   var32: Hits until destruction
;
; Variables (for sword only, subid 3):
;   relatedObj1: parent
;   relatedObj2: shield
;   var30/var31: Target position
;   var32/var33: Base position (yh and xh are manipulated by the animation to fix their
;                collision box, so need to be reset to these values each frame)
;   var34: If nonzero, checks for collision with shield
; ==================================================================================================
enemyCode73:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus

	; ENEMYSTATUS_DEAD

	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp z,enemyBoss_dead

	dec a
	jr nz,@delete

	; Subid 2 (shield) just destroyed

	; Destroy sword
	call ecom_killRelatedObj2

	; Set some variables on parent
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld (hl),$0d

	ld l,Enemy.counter1
	ld (hl),90

	ld l,Enemy.invincibilityCounter
	ld (hl),$60

@delete:
	jp enemyDelete

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw armosWarrior_state_uninitialized
	.dw armosWarrior_state_spawner
	.dw armosWarrior_state_stub
	.dw armosWarrior_state_stub
	.dw armosWarrior_state_stub
	.dw armosWarrior_state_stub
	.dw armosWarrior_state_stub
	.dw armosWarrior_state_stub

@normalState:
	dec b
	ld a,b
	rst_jumpTable
	.dw armosWarrior_parent
	.dw armosWarrior_shield
	.dw armosWarrior_sword


armosWarrior_state_uninitialized:
	ld a,b
	or a
	jp nz,ecom_setSpeedAndState8

	; Spawner only

	inc a
	ld (de),a ; [state] = 1
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,ENEMY_ARMOS_WARRIOR
	jp enemyBoss_initializeRoom


armosWarrior_state_spawner:
	ld b,$03
	call checkBEnemySlotsAvailable
	ret nz

	ld c,$0c
	call ecom_setZAboveScreen

	; Spawn parent
	ld b,ENEMY_ARMOS_WARRIOR
	call ecom_spawnUncountedEnemyWithSubid01
	ld c,h

	; Spawn shield
	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl) ; [shield.subid] = 2

	; [shield.relatedObj1] = parent
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c

	call objectCopyPosition
	push hl

	; Spawn sword
	call ecom_spawnUncountedEnemyWithSubid01
	ld (hl),$03 ; [sword.subid] = 3

	; [sword.relatedObj1] = parent
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c

	call objectCopyPosition

	; [parent.var31] = shield
	; [parent.var32] = sword
	ld b,h
	pop hl
	ld a,h
	ld h,c
	ld l,Enemy.var31
	ldi (hl),a
	ld (hl),b

	call objectCopyPosition

	; Transfer enabled byte to parent
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	jp enemyDelete


armosWarrior_state_stub:
	ret


armosWarrior_parent:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw armosWarrior_parent_state8
	.dw armosWarrior_parent_state9
	.dw armosWarrior_parent_stateA
	.dw armosWarrior_parent_stateB
	.dw armosWarrior_parent_stateC
	.dw armosWarrior_parent_stateD
	.dw armosWarrior_parent_stateE
	.dw armosWarrior_parent_stateF
	.dw armosWarrior_parent_state10


; Waiting for door to close
armosWarrior_parent_state8:
	ld a,($cc93)
	or a
	ret nz

	ldbc $01,$08
	call enemyBoss_spawnShadow
	ret nz

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_ARMOS_WARRIOR_PROTECTED
	jp objectSetVisible82


; Cutscene before fight starts (falling from sky)
armosWarrior_parent_state9:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	; Hit the ground

	ld l,Enemy.substate
	inc (hl)

	inc l
	ld a,$1a
	ld (hl),a ; [counter1]
	ld (wScreenShakeCounterY),a
	ld (wScreenShakeCounterX),a

	; [sword.zh] = [parent.zh]
	ld l,Enemy.var32
	ld h,(hl)
	ld l,Enemy.zh
	ld e,l
	ld a,(de)
	ld (hl),a

	ld a,SND_STRONG_POUND
	jp playSound

@substate1:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [substate]
	ld bc,TX_2f01
	jp showText

@substate2:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.counter1
	ld (hl),30

	call enemyBoss_beginMiniboss
	ld a,$02
	jp enemySetAnimation

@substate3:
	call ecom_decCounter1
	ret nz

	ld (hl),70 ; [counter1]
	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN

	ld l,e
	inc (hl) ; [substate]

	; [sword.yh] -= 2
	ld l,Enemy.var32
	ld h,(hl)
	ld l,Enemy.yh
	ld a,(hl)
	sub $02
	ldi (hl),a

	; [sword.xh] -= 1
	inc l
	dec (hl)

	xor a
	jp enemySetAnimation

; Sword moving up, parent moving down
@substate4:
	call ecom_decCounter1
	jr nz,++

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.angle
	ld (hl),ANGLE_LEFT

	ld l,Enemy.var30
	ld (hl),$08
++
	call objectApplySpeed
	jp enemyAnimate


; Deciding which direction to move in next
armosWarrior_parent_stateA:
	; If the armos is moving directly toward his sword, reverse direction
	ld e,Enemy.var32
	ld a,(de)
	ld h,a
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	call objectGetRelativeAngle
	add $04
	and $18
	ld b,a
	ld e,Enemy.angle
	ld a,(de)
	cp b
	jr nz,++

	; Reverse direction
	xor $10
	ld (de),a
	ld e,Enemy.var30
	ld a,(de)
	cpl
	inc a
	ld (de),a
++
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),75
	jr armosWarrior_parent_animate


; Moving in "box" pattern for [counter1] frames
armosWarrior_parent_stateB:
	call ecom_decCounter1
	jr nz,armosWarrior_parent_updateBoxMovement
	ld l,e
	dec (hl) ; [state]

armosWarrior_parent_updateBoxMovement:
	call armosWarrior_parent_checkReachedTurningPoint
	jr nz,armosWarrior_parent_animate

	; Hit one of the turning points in his movement pattern; turn 90 degrees
	ld h,d
	ld l,Enemy.var30
	ld e,Enemy.angle
	ld a,(de)
	add (hl)
	and $18
	ld (de),a

armosWarrior_parent_animate:
	jp enemyAnimate


; Shield just hit
armosWarrior_parent_stateC:
	call enemyAnimate
	call ecom_decCounter1
	jr nz,armosWarrior_parent_updateBoxMovement

	ld l,Enemy.state
	ld (hl),$0a

	; Set speed based on number of shield hits
	ld l,Enemy.var31
	ld h,(hl)
	ld l,Enemy.var32
	ld a,(hl)
	ld hl,armosWarrior_parent_speedVals
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	ret


; Shield just destroyed
armosWarrior_parent_stateD:
	call ecom_decCounter1
	jr z,@gotoNextState

	; Create debris at random offset every 8 frames
	ld a,(hl)
	and $07
	ret nz

	call getRandomNumber_noPreserveVars
	ld c,a
	and $70
	swap a
	sub $04
	ld b,a
	ld a,c
	and $0f
	ld c,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_ROCKDEBRIS
	jp objectCopyPositionWithOffset

@gotoNextState:
	ld (hl),30 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_STANDARD_MINIBOSS

	ld l,Enemy.speed
	ld (hl),SPEED_200

	ld bc,TX_2f02
	call showText

	ld a,$01
	jp enemySetAnimation


; Standing still before charging Link
armosWarrior_parent_stateE:
	call enemyAnimate
	call ecom_decCounter1
	jr nz,armosWarrior_parent_animate
	ld l,Enemy.state
	inc (hl)
	jp ecom_updateAngleTowardTarget


; Charging
armosWarrior_parent_stateF:
	call enemyAnimate
	ld a,$01
	call ecom_getSideviewAdjacentWallsBitset
	jp z,objectApplySpeed

	; Hit wall

	call ecom_incState
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a

	ld l,Enemy.speedZ
	ld a,<(-$180)
	ldi (hl),a
	ld (hl),>(-$180)

	ld l,Enemy.speed
	ld (hl),SPEED_100

	ld a,30
	call setScreenShakeCounter

	ld a,SND_STRONG_POUND
	jp playSound


; Recoiling from hitting wall
armosWarrior_parent_state10:
	call enemyAnimate
	ld c,$16
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed

	; Hit ground

	ld h,d
	ld l,Enemy.state
	ld (hl),$0e

	ld l,Enemy.speed
	ld (hl),SPEED_200

	ld l,Enemy.counter1
	ld (hl),60
	ret


armosWarrior_shield:
	ld a,(de)
	cp $08
	jr z,@state8

@state9:
	; Delete self if no hits remaining
	ld h,d
	ld l,Enemy.var32
	ld a,(hl)
	or a
	jp z,ecom_killObjectH

	ld a,Object.animParameter
	call objectGetRelatedObject1Var
	ld e,Enemy.var30
	ld a,(de)
	cp (hl)
	jr z,++

	ld a,(hl)
	ld (de),a
	ld e,Enemy.var31
	ld a,(de)
	add (hl)
	call enemySetAnimation
++
	jp armosWarrior_shield_updatePosition

; Uninitialized
@state8:
	ld a,($cc93)
	or a
	ret nz

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_ARMOS_WARRIOR_SHIELD

	ld l,Enemy.var32
	ld (hl),$03

	; [shield.relatedObj2] = sword (parent.var32)
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.var32
	ld e,Enemy.relatedObj2
	ld a,Enemy.start
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	ld e,Enemy.var31
	ld a,$03
	ld (de),a

	call enemySetAnimation
	call armosWarrior_shield_updatePosition
	jp objectSetVisible81


armosWarrior_sword:
	ld e,Enemy.state
	ld a,(de)
	cp $0b
	call nc,armosWarrior_sword_playSlashSound

	ld e,Enemy.state
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw armosWarrior_sword_state8
	.dw armosWarrior_sword_state9
	.dw armosWarrior_sword_stateA
	.dw armosWarrior_sword_stateB
	.dw armosWarrior_sword_stateC


; Waiting for door to close
armosWarrior_sword_state8:
	ld a,($cc93)
	or a
	ret nz

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_ARMOS_WARRIOR_SWORD

	ld l,Enemy.speed
	ld (hl),SPEED_20

	call armosWarrior_sword_setPositionAsHeld

	; [sword.relatedObj2] = shield (parent.var31)
	ld l,Enemy.var31
	ld e,Enemy.relatedObj2
	ld a,Enemy.start
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	ld a,$09
	call enemySetAnimation
	jp objectSetVisible80


; Waiting for initial cutscene to end, then moving upward before fight starts
armosWarrior_sword_state9:
	ld a,Object.substate
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,armosWarrior_sword_setPositionAsHeld

	sub $03
	ret c
	jr z,@parentSubstate3

	dec l
	ld a,(hl) ; [parent.state]
	cp $0a
	jr nc,@gotoStateA
	call armosWarrior_sword_playSlashSound
	jp enemyAnimate

@gotoStateA:
	ld h,d
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$01

	; Save position
	ld e,Enemy.yh
	ld l,Enemy.var32
	ld a,(de)
	ldi (hl),a
	ld e,Enemy.xh
	ld a,(de)
	ld (hl),a
	ret

@parentSubstate3:
	ld h,d
	ld l,Enemy.counter1
	ld a,(hl)
	inc (hl)

	or a
	ld a,$0a
	jp z,enemySetAnimation

	ld l,Enemy.yh
	dec (hl)
	ret


; Staying still before charging toward Link
armosWarrior_sword_stateA:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_180

	ld l,Enemy.counter1
	ld (hl),150

	; Write target position to var30/var31
	ld l,Enemy.var30
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a

	call ecom_updateAngleTowardTarget
	call enemyAnimate
	jp armosWarrior_sword_updateCollisionBox


; Charging toward target position
armosWarrior_sword_stateB:
	call armosWarrior_sword_checkCollisionWithShield
	ld a,(wFrameCounter)
	and $03
	jr nz,++

	; Update angle toward target position every 4 frames
	ld h,d
	ld l,Enemy.var30
	call ecom_readPositionVars
	call objectGetRelativeAngleWithTempVars
	ld e,Enemy.angle
	ld (de),a
++
	call armosWarrior_sword_checkWentTooFar
	jr c,@beginSlowingDown

	; If within 28 pixels of target position, start slowing down
	ld l,Enemy.var30
	ld a,(hl)
	sub b
	add 28
	cp 57
	jr nc,@notSlowingDown
	inc l
	ld a,(hl)
	sub c
	add 28
	cp 57
	jr nc,@notSlowingDown

@beginSlowingDown:
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),$70

@notSlowingDown:
	call enemyAnimate

armosWarrior_sword_updatePosition:
	call ecom_applyVelocityForTopDownEnemy

	; Save position
	ld h,d
	ld l,Enemy.yh
	ld e,Enemy.var32
	ldi a,(hl)
	ld (de),a
	inc e
	inc l
	ld a,(hl)
	ld (de),a

	jp armosWarrior_sword_updateCollisionBox


; Slowing down
armosWarrior_sword_stateC:
	call armosWarrior_sword_checkCollisionWithShield
	call ecom_decCounter1
	jr z,@stoppedMoving

	ld a,(hl) ; [counter1]
	swap a
	rrca
	and $03
	ld hl,armosWarrior_sword_speedVals
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a

	; Restore position (which was manipulated for shield collision detection)
	ld h,d
	ld l,Enemy.yh
	ld e,Enemy.var32
	ld a,(de)
	ldi (hl),a
	inc e
	inc l
	ld a,(de)
	ld (hl),a

	ld e,Enemy.counter1
	ld a,(de)
	cp 30
	jr nc,+
	rrca
+
	call nc,enemyAnimate
	jr armosWarrior_sword_updatePosition

@stoppedMoving:
	ld e,Enemy.animParameter
	ld a,(de)
	cp $07
	jr z,@atRest
	ld (hl),$02 ; [counter1]
	jp enemyAnimate

@atRest:
	ld l,Enemy.state
	ld (hl),$0a
	ld l,Enemy.var34
	ld (hl),$00

	; Set counter1 (frames to rest) based on number of hits until shield destroyed
	ld a,Object.var32
	call objectGetRelatedObject2Var
	ld a,(hl)
	swap a
	rlca
	add 30
	ld e,Enemy.counter1
	ld (de),a

	ld a,$0a
	jp enemySetAnimation


;;
; Shield copies parent's position plus an offset
armosWarrior_shield_updatePosition:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ldi a,(hl) ; [parent.yh]
	ld b,a
	inc l
	ldi a,(hl) ; [parent.xh]
	ld c,a

	inc l
	ld e,l
	ld a,(hl)
	ld (de),a ; [shield.zh] = [parent.zh]

	ld e,Enemy.var30
	ld a,(de)
	ld hl,armosWarrior_shield_YXOffsets
	rst_addDoubleIndex
	ld e,Enemy.yh
	ldi a,(hl)
	add b
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	add c
	ld (de),a
	ret


;;
; Updates collisionRadiusY/X based on animParameter, also adds an offset to Y/X position.
armosWarrior_sword_updateCollisionBox:
	ld e,Enemy.animParameter
	ld a,(de)
	add a
	ld hl,armosWarrior_sword_collisionBoxes
	rst_addDoubleIndex

	ld e,Enemy.var32
	ld a,(de)
	add (hl)
	ld e,Enemy.yh
	ld (de),a

	inc hl
	ld e,Enemy.var33
	ld a,(de)
	add (hl)
	ld e,Enemy.xh
	ld (de),a
	inc hl

	ld e,Enemy.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret


;;
; Sets the sword's position assuming it's being held by the parent.
armosWarrior_sword_setPositionAsHeld:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld bc,$f4fa
	jp objectTakePositionWithOffset

;;
armosWarrior_sword_checkCollisionWithShield:
	ld e,Enemy.var34
	ld a,(de)
	dec a
	ret z

	; Check if sword and shield collide
	ld a,Object.collisionRadiusY
	call objectGetRelatedObject2Var
	ld c,Enemy.yh
	call @checkIntersection
	ret nc

	ld c,Enemy.xh
	ld l,Enemy.collisionRadiusX
	call @checkIntersection
	ret nc

	; They've collided

	ld e,Enemy.var34
	ld a,$01
	ld (de),a

	; Set various variables on the shield
	ld l,Enemy.invincibilityCounter
	ld (hl),$18

	; [Hits until destruction]--
	ld l,Enemy.var32
	dec (hl)

	ld l,Enemy.var31
	ld a,(hl)
	add $02
	ld (hl),a

	; h = [shield.relatedObj1] = parent
	ld l,Enemy.relatedObj1+1
	ld h,(hl)

	ld l,Enemy.counter1
	ld (hl),60

	ld l,Enemy.state
	ld (hl),$0c

	ld l,Enemy.speed
	ld (hl),SPEED_300

	ld l,Enemy.invincibilityCounter
	ld (hl),$18

	ld a,SND_BOSS_DAMAGE
	jp playSound

;;
; Checks for intersection on a position component given two objects.
@checkIntersection:
	; b = [sword.collisionRadius] + [shield.collisionRadius]
	ld e,l
	ld a,(de)
	add (hl)
	ld b,a

	; a = [sword.pos] - [shield.pos]
	ld l,c
	ld e,l
	ld a,(de)
	sub (hl)

	add b
	sla b
	inc b
	cp b
	ret


;;
; The armos always moves in a "box" pattern in his first phase, this checks if he's
; reached one of the "corners" of the box where he must turn.
;
; @param[out]	zflag	z if hit a turning point
armosWarrior_parent_checkReachedTurningPoint:
	ld b,$31
	ld e,Enemy.yh
	ld a,(de)
	cp $30
	jr c,@hitCorner

	ld b,$7f
	cp $80
	jr nc,@hitCorner

	ld b,$bf
	ld e,Enemy.xh
	ld a,(de)
	cp $c0
	jr nc,@hitCorner

	ld b,$31
	cp $30
	jr c,@hitCorner

	call objectApplySpeed
	or d
	ret

@hitCorner:
	ld a,b
	ld (de),a
	xor a
	ret


;;
; @param[out]	bc	Position of sword
; @param[out]	cflag	c if the sword has gone to far and should stop now
armosWarrior_sword_checkWentTooFar:
	; Fix position, store it in bc
	ld h,d
	ld l,Enemy.yh
	ld e,Enemy.var32
	ld a,(de)
	ldi (hl),a
	ld b,a
	inc e
	inc l
	ld a,(de)
	ld (hl),a
	ld c,a

	; Read in boundary data based on the angle, determine if the sword has gone past
	ld e,Enemy.angle
	ld a,(de)
	add $02
	and $1c
	rrca
	ld hl,armosWarrior_sword_angleBoundaries
	rst_addAToHl

	ldi a,(hl)
	ld e,b
	call @checkPositionComponent
	jr c,++
	ld e,c
	ld a,(hl)
	call @checkPositionComponent
++
	ld h,d
	ret

;;
@checkPositionComponent:
	; If bit 0 of the data structure is set, it's an upper / left boundary
	bit 0,a
	jr nz,++
	cp e
	ret
++
	cp e
	ccf
	ret


armosWarrior_shield_YXOffsets:
	.db $fb $03 ; Frame 0
	.db $fb $07 ; Frame 1


; This is a table of data values for various parts of the sword's animation, which adjusts
; its collision box.
;   b0: Y-offset
;   b1: X-offset
;   b2: collisionRadiusY
;   b3: collisionRadiusX
armosWarrior_sword_collisionBoxes:
	.db $fc $00 $08 $03
	.db $fe $fe $06 $06
	.db $00 $fc $03 $08
	.db $02 $fe $06 $06
	.db $04 $ff $08 $03
	.db $02 $02 $06 $06
	.db $01 $04 $03 $08
	.db $fe $02 $06 $06


; Sword decelerates based on these values
armosWarrior_sword_speedVals:
	.db SPEED_40, SPEED_80, SPEED_100, SPEED_140


; Parent chooses a speed from here based on how many hits the shield has taken
armosWarrior_parent_speedVals:
	.db SPEED_180, SPEED_140, SPEED_100


; For each possible angle the sword can move in, this has Y and X boundaries where it
; should stop.
;   b0: Y-boundary. (If bit 0 is set, it's an upper boundary.)
;   b1: X-boundary. (If bit 0 is set, it's a left boundary.)
armosWarrior_sword_angleBoundaries:
	.db $51 $fe ; Up
	.db $51 $98 ; Up-right
	.db $fe $98 ; Right
	.db $60 $98 ; Down-right
	.db $60 $fe ; Down
	.db $60 $51 ; Down-left
	.db $fe $51 ; Left
	.db $51 $51 ; Up-left

;;
armosWarrior_sword_playSlashSound:
	ld a,(wFrameCounter)
	and $0f
	ret nz
	ld a,SND_SWORDSLASH
	jp playSound
