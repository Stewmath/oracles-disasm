; ==================================================================================================
; ENEMY_GOHMA
;
; Variables for subid 1 (main body):
;   relatedObj2: Reference to subid 3 (claw)
;   var30: ?
;   var31: Affects animation?
;   var32: Number of "children" spawned (ENEMY_GOHMA_GEL)
;
; Variables for subid 2 (body hitbox):
;   relatedObj1: Reference to subid 1
;
; Variables for subid 3 (claw):
;   relatedObj1: Reference to subid 1
;   var30: Nonzero if Link was caught?
; ==================================================================================================
enemyCode7b:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@collisionOccurred

	; Health is 0 (might just be moving to next phase)
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp z,gohma_subid1_dead

	ld e,Enemy.animParameter
	ld a,(de)
	cp $80
	jp nz,gohma_subid3_dead

	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr z,++
	ld (hl),10
	ld l,Enemy.state
	inc (hl)
	inc l
	ld (hl),$00
++
	jp enemyDie_uncounted

@collisionOccurred:
	ld e,Enemy.subid
	ld a,(de)
	cp $01
	jr nz,++

	ld a,Object.id
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp ENEMY_GOHMA
	jr nz,@normalStatus

	ld l,Enemy.invincibilityCounter
	ld e,l
	ld a,(de)
	ld (hl),a
	jr @normalStatus
++
	cp $03
	jr nz,@normalStatus

	ld e,Enemy.var2a
	ld a,(de)
	res 7,a
	cp ITEMCOLLISION_L1_SWORD
	jr nc,@normalStatus

	; Link or shield collision
	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_GOHMA_CLAW_LUNGING
	jr nz,@normalStatus

	ld e,Enemy.var30
	ld a,$01
	ld (de),a

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@state8OrHigher
	rst_jumpTable
	.dw gohma_state_uninitialized
	.dw gohma_state_spawner
	.dw gohma_state_stub
	.dw gohma_state_stub
	.dw gohma_state_stub
	.dw gohma_state_stub
	.dw gohma_state_stub
	.dw gohma_state_stub

@state8OrHigher:
	dec b
	ld a,b
	rst_jumpTable
	.dw gohma_subid1
	.dw gohma_subid2
	.dw gohma_subid3


gohma_state_uninitialized:
	ld a,b
	or a
	jp nz,ecom_setSpeedAndState8

	; Subid 0
	inc a
	ld (de),a ; [state] = 1
	ld a,ENEMY_GOHMA
	call enemyBoss_initializeRoom


gohma_state_spawner:
	ld b,$03
	call checkBEnemySlotsAvailable
	ret nz

	ld b,ENEMY_GOHMA
	call ecom_spawnUncountedEnemyWithSubid01
	call objectCopyPosition

	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	ld c,h
	ld e,$02
	call @spawnChild

	ld e,$03
	call @spawnChild

	ld a,h
	ld h,c
	ld l,Enemy.relatedObj2+1
	ldd (hl),a
	ld (hl),$80
	jp enemyDelete

@spawnChild:
	call ecom_spawnUncountedEnemyWithSubid01
	ld (hl),e ; [subid] = e
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c
	ret


gohma_state_stub:
	ret


; Main body
gohma_subid1:
	ld a,(de) ; [state]
	sub $08
	rst_jumpTable
	.dw gohma_subid1_state8
	.dw gohma_subid1_state9
	.dw gohma_subid1_stateA
	.dw gohma_subid1_stateB
	.dw gohma_subid1_stateC
	.dw gohma_subid1_stateD


; Initialization
gohma_subid1_state8:
	ld bc,$0208
	call enemyBoss_spawnShadow
	ret nz

	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = 9

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_GOHMA_BODY

	ld l,Enemy.counter1
	ld (hl),30
	ld l,Enemy.var31
	ld (hl),$02

	ld c,$08
	jp ecom_setZAboveScreen


; Following Link from the ceiling
gohma_subid1_state9:
	call ecom_decCounter1
	jr nz,@updatePosition

	ld (hl),30 ; [counter1]
	ld c,$28
	call objectCheckLinkWithinDistance
	jr nc,@updatePosition

	; Time to fall down
	ld l,Enemy.state
	inc (hl) ; [state] = $0a

	ld a,Object.visible
	call objectGetRelatedObject2Var
	set 7,(hl)

	call objectSetVisible81
	ld c,$08
	call ecom_setZAboveScreen

@updatePosition:
	call ecom_updateCardinalAngleTowardTarget
	call gohma_updateSpeedWhileFalling
	call objectApplySpeed

	; Check that x-position is contained in the room
	ld e,Enemy.xh
	ld a,(de)
	cp $20
	jr nc,++
	ld a,$20
	ld (de),a
	ret
++
	cp $d0
	ret c
	ld a,$d0
	ld (de),a
	ret


; Falling down
gohma_subid1_stateA:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	jr z,@hitGround

	ld a,(de)
	cp $f9
	ret c
	ld a,$02
	jp gohma_setAnimation

@hitGround:
	ld l,Enemy.state
	inc (hl) ; [state] = $0b
	ld l,Enemy.counter1
	ld (hl),60

	ld a,MUS_BOSS
	ld (wActiveMusic),a
	call playSound
	ld a,SND_STRONG_POUND
	call playSound

	ld a,$28
	call setScreenShakeCounter
	jp objectSetVisible83


; Standing in place
gohma_subid1_stateB:
	call ecom_decCounter1
	ret nz

	inc (hl) ; [counter1] = 1
	ld l,e
	inc (hl) ; [state] = $0c

	ld l,Enemy.var30
	ld (hl),45
	ret


; Phase 1 of fight: claw still intact
gohma_subid1_stateC:
	call gohma_subid1_updateAnimationsAndCollisions
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw gohma_stateC_substate2
	.dw gohma_stateC_substate3
	.dw gohma_stateC_substate4

; Standing in place before deciding which way to move
@substate0:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [substate] = 1
	call gohma_phase1_decideAngle
	call gohma_decideMovementDuration
	call gohma_decideAnimation
	jp gohma_updateSpeedWhileFalling

; Walking in some direction
@substate1:
	call enemyAnimate
	call ecom_decCounter2

	; Jump if Link is in front of gohma within $28 pixels?
	ld h,d
	ld l,Enemy.yh
	ld a,(w1Link.yh)
	sub (hl)
	cp $28
	jr nc,gohma_movingNormally

	; Jump if Link isn't close to gohma horizontally
	ld l,Enemy.xh
	ld a,(w1Link.xh)
	sub (hl)
	add $18
	cp $25
	jr nc,gohma_movingNormally

	; Charge at Link if counter2 is zero?
	ld l,Enemy.counter2
	ld a,(hl)
	or a
	jr z,gohma_beginLungeTowardLink

gohma_movingNormally:
	call gohma_checkWallsAndPlayWalkingSound
	call ecom_decCounter1
	ret nz

	; [substate] = 0 (stop moving for a moment)
	ld l,Enemy.substate
	dec (hl)
	call getRandomNumber_noPreserveVars
	and $07
	ld hl,gohma_counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret

gohma_beginLungeTowardLink:
	ld l,Enemy.substate
	inc (hl) ; [substate] = 2
	inc l
	ld (hl),31 ; [counter1]

	ld l,Enemy.speed
	ld (hl),SPEED_300

	; Check if claw was destroyed?
	ld a,Object.health
	call objectGetRelatedObject2Var
	ld a,(hl)
	or a
	jr z,++

	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.collisionType
	set 7,(hl)
++
	ld a,$09

gohma_setAnimation:
	ld e,Enemy.direction
	ld (de),a
	jp enemySetAnimation


; Lunging toward Link (or moving back) with claw
gohma_stateC_substate2:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr z,@doneLunge

	res 7,a
	dec a
	ret z
	jp gohma_updateLunge

@doneLunge:
	; Check if grabbed Link
	ld a,(w1Link.state)
	cp LINK_STATE_GRABBED
	jr z,gohma_stateC_setSubstate4

	ld h,d
	ld l,Enemy.substate
	inc (hl) ; [substate] = 3
	inc l
	ld (hl),20 ; [counter1]
	ret

; Grabbed Link
gohma_stateC_setSubstate4:
	ld e,Enemy.substate
	ld a,$04
	ld (de),a
	ld a,$0a
	jr gohma_setAnimation


; Standing in place after lunge
gohma_stateC_substate3:
	ld a,(w1Link.state)
	cp LINK_STATE_GRABBED
	jr z,gohma_stateC_setSubstate4

	call ecom_decCounter1
	ret nz

	inc (hl) ; [counter1] = 1
	inc l
	ld (hl),40 ; [counter2]

	ld l,e
	ld (hl),$00 ; [substate]

	ld l,Enemy.var31
	ld (hl),$02
	ret


; Holding Link
gohma_stateC_substate4:
	call enemyAnimate
	ld h,d
	ld l,Enemy.animParameter
	bit 7,(hl)
	ret z

	ld l,Enemy.substate
	ld (hl),$00
	inc l
	ld (hl),60 ; [counter1]

	ld l,Enemy.var31
	ld (hl),$02
	ret


; Phase 2 of fight: claw destroyed
gohma_subid1_stateD:
	call gohma_subid1_updateAnimationsAndCollisions
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call getRandomNumber_noPreserveVars
	and $03
	jr nz,@chooseNextMovement

	ld h,d
	ld l,Enemy.var32
	ld a,(hl)
	cp $05
	jr nc,@chooseNextMovement

	ld l,Enemy.substate
	ld (hl),$02
	inc l
	ld (hl),$01 ; [counter1]

	ld a,$0b
	jp gohma_setAnimation

@chooseNextMovement:
	call ecom_setRandomCardinalAngle
	ld e,Enemy.substate
	ld a,$01
	ld (de),a
	call gohma_decideMovementDuration
	call gohma_decideAnimation
	jp gohma_updateSpeedWhileFalling


@substate1:
	call enemyAnimate
	jp gohma_movingNormally

@substate2:
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr z,@chooseNextMovement

	res 7,a
	dec a
	jr z,@animate
	call ecom_decCounter1
	call z,gohma_phase2_spawnGelChild
@animate:
	jp enemyAnimate


; Collision box for legs
gohma_subid2:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9

@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)

	; Save id in var30 (never actually used though?)
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a

@state9:
	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,enemyDelete

	; Copy position of parent
	ld bc,$ff00
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	jp objectTakePositionWithOffset


; Claw
gohma_subid3:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE
	.dw @stateF

; Uninitialized
@state8:
	ld a,$09
	ld (de),a ; [state]

	call objectSetVisible81
	call objectSetInvisible
	ld a,$0c
	jp enemySetAnimation


; Falling from ceiling along with main body
@state9:
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0a
	jr z,@falling
	ret c

	; Landed
	ld h,d
	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_GOHMA_CLAW
	ld l,Enemy.zh
	ld (hl),$00
	jp objectSetVisible82

@falling:
	ld l,Enemy.zh
	ld a,(hl)
	cp $f9
	jr nc,@closeToGround

	ld bc,$f806
	jp objectTakePositionWithOffset

@closeToGround:
	ld a,$0d
	call enemySetAnimation
	jr @updateNormalPosition


; Standing in place
@stateA:
	call gohma_checkShouldBlock
	call gohma_updateCollisionsEnabled
	call @updateNormalPosition
	jp enemyAnimate


; Blocking eye with claw
@stateB:
	call ecom_decCounter1
	jp nz,gohma_claw_updateBlockingPosition

@gotoStateA:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0a
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_GOHMA_CLAW
	ld a,$0d
	call enemySetAnimation

@updateNormalPosition:
	ld bc,$08fa
	ld a,Object.start
	call objectGetRelatedObject1Var
	jp objectTakePositionWithOffset


; Beginning attack with claw (being held behind gohma)
@stateC:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0c

	ld l,Enemy.var30
	ld (hl),$00

	ld a,$0f
	call enemySetAnimation

	ld a,SND_SWORDSLASH
	call playSound

	jp gohma_claw_updatePositionInLunge


; Claw in the process of attacking
@stateD:
	call enemyAnimate

	ld h,d
	ld l,Enemy.animParameter
	bit 7,(hl)
	jr nz,@label_0e_308

	bit 0,(hl)
	jr z,++

	res 0,(hl)
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_GOHMA_CLAW_LUNGING
++
	call gohma_claw_updatePositionInLunge
	ld e,Enemy.var30
	ld a,(de)
	or a
	ret z
	jr @linkCaught

@label_0e_308:
	ld e,Enemy.var30
	ld a,(de)
	or a
	jp z,@gotoStateA

	xor a
	call gohma_claw_setPositionInLunge

@linkCaught:
	ld a,$10
	call enemySetAnimation

	; Mess with Link's animation?
	ld hl,w1Link.var31
	ld (hl),$0d
	ld l,<w1Link.animMode
	ld (hl),$00

	ld l,SpecialObject.collisionType
	res 7,(hl)

	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = $0e

	ld l,Enemy.animParameter
	ld (hl),$08
	jr @updateLinkPosition


; Claw grabbed Link and is pulling him back
@stateE:
	; Wait for main body to move back into position
	ld a,Object.substate
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $04
	jr z,@donePullingBack

	call gohma_claw_updatePositionInLunge
	jr @updateLinkPosition

@donePullingBack:
	ld h,d
	dec l
	inc (hl) ; [state] = $0f
	ld l,Enemy.animParameter
	ld (hl),$00
	ret


; Claw is slamming Link into the ground
@stateF:
	call enemyAnimate

	; Check slam is done
	ld h,d
	ld l,Enemy.animParameter
	bit 7,(hl)
	jp nz,@gotoStateA

	bit 2,(hl)
	jr z,@label_0e_311

	bit 4,(hl)
	jp z,gohma_updateClawPositionDuringSlamAttack

	res 4,(hl)
	ld hl,w1Link.substate
	ld (hl),$02
	ld l,<w1Link.collisionType
	set 7,(hl)
	jp gohma_updateClawPositionDuringSlamAttack

@label_0e_311:
	bit 4,(hl)
	jr z,++

	; A slam occurs now; play sound, apply damage, etc.
	res 4,(hl)
	ld a,SND_EXPLOSION
	call playSound
	ld a,$14
	call setScreenShakeCounter
	ld a,$0a
	ld (w1Link.invincibilityCounter),a
	ld a,-6
	ld (w1Link.damageToApply),a
	ld h,d
	ld l,Enemy.animParameter
++
	call gohma_updateLinkAnimAndClawPositionDuringSlamAttack

@updateLinkPosition:
	ld bc,$0002
	ld hl,w1Link
	jp objectCopyPositionWithOffset


;;
; Updates speed while falling to be fast vertically, slow horizontally.
gohma_updateSpeedWhileFalling:
	ld h,d
	ld l,Enemy.angle
	bit 3,(hl)
	ld l,Enemy.speed
	ld (hl),SPEED_80
	ret z
	ld (hl),SPEED_180
	ret

;;
; Reverses direction if gohma hits a wall, and plays walking sound.
gohma_checkWallsAndPlayWalkingSound:
	ld h,d
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)

	; Add offset to position based on direction we're moving in
	ld e,Enemy.angle
	ld a,(de)
	rrca
	rrca
	ld hl,gohma_positionOffsets
	rst_addAToHl
	ldi a,(hl)
	add b
	ld b,a
	ld a,(hl)
	add c
	ld c,a

	; Check for wall in front of gohma
	call getTileCollisionsAtPosition
	jr z,gohma_updateMovement

	; Reverse direction
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	ld (de),a

;;
gohma_updateMovement:
	; If moving down, don't allow gohma to pass a certain point?
	ld e,Enemy.angle
	ld a,(de)
	sub $09
	cp $0f
	jr nc,++
	ld e,Enemy.yh
	ld a,(de)
	cp $98
	jr nc,@updateWalkingSound
++
	call objectApplySpeed

@updateWalkingSound:
	ld e,Enemy.angle
	ld a,(de)
	bit 3,a
	ld b,$07
	jr nz,+
	ld b,$0f
+
	ld a,(wFrameCounter)
	and b
	ret nz

	ld a,SND_LAND
	jp playSound

gohma_positionOffsets:
	.db $f7 $00
	.db $00 $18
	.db $08 $00
	.db $00 $e7


;;
; Used by subid 1 (body) and 3 (claw)?
gohma_updateCollisionsEnabled:
	ld e,Enemy.health
	ld a,(de)
	or a
	ret z

	call objectGetAngleTowardEnemyTarget
	add $06
	and $1f
	cp $0d
	ld h,d
	ld l,Enemy.collisionType
	jr c,++
	set 7,(hl)
	ret
++
	res 7,(hl)
	ret

;;
; Main body has died (health is 0).
gohma_subid1_dead:
	ld e,Enemy.collisionType
	ld a,(de)
	or a
	jr z,@dead

	; Kill all gels that gohma may have spawned
	ld h,FIRST_ENEMY_INDEX
@nextEnemy:
	ld l,Enemy.id
	ld a,(hl)
	cp ENEMY_GOHMA_GEL
	call z,ecom_killObjectH
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	; Kill claw
	ld a,Object.id
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp ENEMY_GOHMA
	jr nz,@dead

	call ecom_killObjectH
	ld l,Enemy.animParameter
	ld (hl),$80
@dead:
	jp enemyBoss_dead


;;
; Claw is dead
gohma_subid3_dead:
	ld h,d
	ld l,Enemy.collisionType
	ld a,(hl)
	or a
	jr z,+++

	ld (hl),$00
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ld l,Enemy.angle
	ld (hl),$18
	ld bc,-$e0
	call objectSetSpeedZ
	ld a,$11
	call enemySetAnimation
+++
	ld c,$0a
	call objectUpdateSpeedZ_paramC
	call objectApplySpeed
	jp enemyAnimate


;;
gohma_subid1_updateAnimationsAndCollisions:
	ld e,Enemy.substate
	ld a,(de)
	dec a
	jr nz,@updateCollision

	; [substate] == 1

	ld h,d
	ld l,Enemy.var30
	dec (hl)
	jr nz,@updateCollision

	call getRandomNumber_noPreserveVars
	and $30
	add $a0
	ld b,a
	ld e,Enemy.var31
	ld a,(de)
	sub $02
	swap a
	cpl
	inc a
	rrca
	add b
	ld e,Enemy.var30
	ld (de),a

	ld h,d
	ld l,Enemy.counter1
	ld a,(hl)
	add $18
	ld (hl),a

	ld l,Enemy.var31
	ld a,(hl)
	xor $04
	ld (hl),a

	ld e,Enemy.angle
	ld a,(de)
	swap a
	rlca
	and $02
	add (hl) ; [var31]
	dec e
	ld (de),a ; [direction]
	dec a
	call enemySetAnimation

@updateCollision:
	ld e,Enemy.animParameter
	ld a,(de)
	rlca
	jp c,gohma_updateCollisionsEnabled

	ld e,Enemy.collisionType
	ld a,(de)
	res 7,a
	ld (de),a
	ret


;;
gohma_phase1_decideAngle:
	ld b,$00
	ld h,d
	ld l,Enemy.yh
	ld a,(hl)
	cp $60
	jr nc,@setAngle

	call getRandomNumber
	and $07
	jp z,ecom_setRandomCardinalAngle

	ld a,(w1Link.yh)
	sub (hl)
	cp $20
	jr c,@checkHorizontal

	ld b,$10
	cp $80
	jr c,@setAngle

	ld b,$00
	cp $e0
	jr c,@setAngle

@checkHorizontal:
	ld l,Enemy.xh
	ld a,(w1Link.xh)
	cp (hl)
	ld b,$18
	jr c,@setAngle

	ld b,$08
@setAngle:
	ld l,Enemy.angle
	ld (hl),b
	ret

;;
; Sets counter1 to something.
gohma_decideMovementDuration:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter1Vals
	rst_addAToHl

	; Horizontal movement has less duration
	ld e,Enemy.angle
	ld a,(de)
	and $08
	add a
	add a
	cpl
	inc a
	add (hl)
	ld e,Enemy.counter1
	ld (de),a
	ret

@counter1Vals:
	.db $60 $70 $80 $50

;;
gohma_decideAnimation:
	ld h,d
	ld l,Enemy.var31
	ld e,Enemy.angle
	ld a,(de)
	swap a
	rlca
	and $02
	add (hl)
	ld l,Enemy.direction
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
; Updates movement for "lunge" at Link with claw
gohma_updateLunge:
	call ecom_decCounter1
	ret z

	ld a,(hl)
	cp 30
	push af
	call z,gohma_initAngleForLungeAtLink

	pop af
	cp 15
	jp nz,gohma_updateMovement

	; Begin moving back
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	ld (de),a
	jp gohma_updateMovement

;;
; Decides angle to use while charging toward Link, and plays sound effect.
gohma_initAngleForLungeAtLink:
	ld b,$00
	ld a,Object.xh
	call objectGetRelatedObject2Var
	ld a,(w1Link.xh)
	sub (hl)
	add $06
	cp $0d
	jr c,@setAngle

	ld b,$fe
	cp $86
	jr c,@setAngle

	ld b,$02

@setAngle:
	ld e,Enemy.angle
	ld a,$10
	add b
	ld (de),a

	ld a,SND_BEAM2
	jp playSound

;;
; @param	hl	Pointer to counter1
gohma_phase2_spawnGelChild:
	ld (hl),$07
	ld l,Enemy.var32
	ld a,(hl)
	cp $05
	ret nc

	call getRandomNumber_noPreserveVars
	and $03
	ld c,a
	ld b,ENEMY_GOHMA_GEL
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz

	ld (hl),c ; [subid] = c (random number from 0 to 3)
	call objectCopyPosition
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld h,d
	ld l,Enemy.var32
	inc (hl)
	ld a,SND_GOHMA_SPAWN_GEL
	jp playSound

gohma_counter1Vals:
	.db $05 $0f $0f $19 $19 $19 $23 $23

;;
; If Link is using something and a certain item type is active, block eye with claw
gohma_checkShouldBlock:
	ld a,(wLinkUsingItem1)
	and $f0
	ret z

	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld a,(w1Link.yh)
	sub (hl)
	cp $2c
	ret c

	; Check if any item with ID above ITEM_DUST is active?
	ld h,FIRST_ITEM_INDEX
@nextItem:
	ld l,Item.id
	ld a,(hl)
	cp ITEM_DUST
	jr nc,@beginBlock
	inc h
	ld a,h
	cp $e0
	jr c,@nextItem
	ret

@beginBlock:
	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = $0b

	ld l,Enemy.counter1
	ld (hl),60

	ld a,$0e
	call enemySetAnimation

gohma_claw_updateBlockingPosition:
	ld bc,$07ff
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	jp objectTakePositionWithOffset

;;
gohma_claw_updatePositionInLunge:
	ld e,Enemy.animParameter
	ld a,(de)

;;
; @param	a	Position index
gohma_claw_setPositionInLunge:
	ld hl,@positions
	rst_addAToHl
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	ld a,$00
	call objectGetRelatedObject1Var
	jp objectTakePositionWithOffset

@positions:
	.db $08 $fa
	.db $05 $f3
	.db $fd $f3
	.db $ef $f8
	.db $09 $fb

;;
; @param	hl	Pointer to w1Link.animParameter?
gohma_updateLinkAnimAndClawPositionDuringSlamAttack:
	; Update Link's animation?
	ld a,(hl)
	ld hl,gohma_linkVar31Stuff
	rst_addAToHl
	ld a,(hl)
	ld (w1Link.var31),a

gohma_updateClawPositionDuringSlamAttack:
	ld e,Enemy.animParameter
	ld a,(de)
	and $03
	ld hl,gohma_clawSlamPositionOffsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	ld a,$00
	call objectGetRelatedObject1Var
	jp objectTakePositionWithOffset


gohma_linkVar31Stuff:
	.db $0d $0e $0f $0e

gohma_clawSlamPositionOffsets:
	.db $08 $fa
	.db $fd $f3
	.db $ef $f8
	.db $05 $f3
