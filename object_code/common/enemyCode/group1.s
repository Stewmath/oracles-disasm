; ==============================================================================
; ENEMYID_RIVER_ZORA
; ==============================================================================
enemyCode08:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_08
	.dw @state_09
	.dw @state_0a
	.dw @state_0b

@state_uninitialized:
	ld a,$09
	ld (de),a
	ret

@state_stub:
	ret


; Waiting under the water until time to resurface
@state_08:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	ret


; Resurfacing in a random position
@state_09:
	call getRandomNumber_noPreserveVars
	cp (SCREEN_WIDTH<<4)-8
	ret nc

	ld c,a
	ldh a,(<hCameraX)
	add c
	ld c,a

	ldh a,(<hCameraY)
	ld b,a
	ldh a,(<hRng2)
	res 7,a
	add b
	ld b,a

	call checkTileAtPositionIsWater
	ret nc

	; Tile is water; spawn here.
	ld c,l
	call objectSetShortPosition
	ld l,Enemy.counter1
	ld (hl),48

	ld l,Enemy.state
	inc (hl) ; [state] = $0a

	xor a
	call enemySetAnimation
	jp objectSetVisible83


; In the process of surfacing.
@state_0a:
	call ecom_decCounter1
	jr nz,@animate

	; Surfaced; enable collisions & set animation.
	ld l,e
	inc (hl)
	ld l,Enemy.collisionType
	set 7,(hl)
	ld a,$01
	jp enemySetAnimation


; Above water, waiting until time to fire projectile.
@state_0b:
	ld h,d
	ld l,Enemy.animParameter
	ld a,(hl)
	inc a
	jr z,@disappear

	dec a
	jr z,@animate

	; Make projectile
	ld (hl),$00
	ld b,PARTID_ZORA_FIRE
	call ecom_spawnProjectile
	jr nz,@animate
	ld l,Part.subid
	inc (hl)

@animate:
	jp enemyAnimate

@disappear:
	ld a,$08
	ld (de),a ; [state] = 8

	ld l,Enemy.collisionType
	res 7,(hl)

	call getRandomNumber_noPreserveVars
	and $1f
	add $18
	ld e,Enemy.counter1
	ld (de),a

	ld b,INTERACID_SPLASH
	call objectCreateInteractionWithSubid00
	jp objectSetInvisible


; ==============================================================================
; ENEMYID_OCTOROK
;
; Variables:
;   counter1: How many frames to wait after various actions.
;   var30: How many frames to walk for.
;   var32: Should be 1, 3, or 7. Lower values make the octorok move and shoot more often.
; ==============================================================================
enemyCode09:
	call ecom_checkHazards
	jr z,@normalStatus

	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead

	; Check ENEMYSTATUS_KNOCKBACK
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@dead:
	ld e,Enemy.subid
	ld a,(de)
	cp $04
	jr nz,++
	ld hl,wKilledGoldenEnemies
	set 0,(hl)
++
	jp enemyDie

@normalStatus:
	call ecom_checkScentSeedActive
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw octorok_state_uninitialized
	.dw octorok_state_stub
	.dw octorok_state_stub
	.dw octorok_state_latchedBySwitchHook
	.dw octorok_state_followingScentSeed
	.dw ecom_blownByGaleSeedState
	.dw octorok_state_stub
	.dw octorok_state_stub
	.dw octorok_state_08
	.dw octorok_state_09
	.dw octorok_state_0a
	.dw octorok_state_0b


octorok_state_uninitialized:
	; Delete self if it's a golden enemy that's been defeated
	ld e,Enemy.subid
	ld a,(de)
	cp $04
	jr nz,++
	ld hl,wKilledGoldenEnemies
	bit 0,(hl)
	jp nz,enemyDelete
++
	; If bit 1 of subid is set, octorok is faster
	rrca
	ld a,SPEED_80
	jr nc,+
	ld a,SPEED_c0
+
	call ecom_setSpeedAndState8AndVisible
	ld (hl),$0a ; [state] = $0a

	; Enable moving toward scent seeds
	ld l,Enemy.var3f
	set 4,(hl)

	; Determine range of possible counter1 values, read into 'e' and 'var32'.
	ld e,Enemy.subid
	ld a,(de)
	ld hl,@counter1Ranges
	rst_addAToHl
	ld e,Enemy.var32
	ld a,(hl)
	ld (de),a

	; Decide random counter1, angle, and var30.
	ld e,a
	ldbc $18,$03
	call ecom_randomBitwiseAndBCE
	ld a,e
	ld hl,octorok_counter1Values
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a

	; Random initial angle
	ld e,Enemy.angle
	ld a,b
	ld (de),a

	ld a,c
	ld hl,octorok_walkCounterValues
	rst_addAToHl
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a
	jp ecom_updateAnimationFromAngle


; For each subid, each byte determines the maximum index of the value that can be read
; from "octorok_counter1Values" below. Effectively, lower values attack more often.
@counter1Ranges:
	.db $07 $07 $03 $03 $01


octorok_state_followingScentSeed:
	ld a,(wScentSeedActive)
	or a
	jr nz,++
	ld a,$08
	ld (de),a ; [state] = 8
	ret
++
	; Set angle toward scent seed (must be cardinal direction)
	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a

	call ecom_updateAnimationFromAngle
	call ecom_applyVelocityForTopDownEnemy
	jp enemyAnimate


octorok_state_latchedBySwitchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw ecom_fallToGroundAndSetState8

@substate1:
@substate2:
	ret

octorok_state_stub:
	ret


; State 8: Octorok decides what to do next after previous action
octorok_state_08:
	; Decide whether to move or shoot based on [var32] & [random number]. If var32 is
	; low, this means it will shoot more often.
	call getRandomNumber_noPreserveVars
	ld h,d
	ld l,Enemy.var32
	and (hl)
	ld l,Enemy.state
	jr nz,@standStill

	; Shoot a projectile after [counter1] frames
	ld (hl),$0b ; [state] = $0b
	ld l,Enemy.counter1
	ld (hl),$10

	; Blue and golden octoroks change direction to face Link before shooting
	ld l,Enemy.subid
	ld a,(hl)
	cp $02
	ret c
	call ecom_updateCardinalAngleTowardTarget
	jp ecom_updateAnimationFromAngle

@standStill:
	inc (hl) ; [state] = $09
	ld bc,octorok_counter1Values
	call addAToBc
	ld l,Enemy.counter1
	ld a,(bc)
	ld (hl),a
	ret


; A random value for counter1 is chosen from here when the octorok changes direction?
; Red octoroks read the whole range, blue octoroks only the first 4, golden ones only the
; first 2.
; Effectively, blue & golden octoroks move more often.
octorok_counter1Values:
	.db 30 45 60 75 45 60 75 90


; State 9: Standing still for [counter1] frames.
octorok_state_09:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state] = $0a (Walking)

	ld e,$03
	ld bc,$0318
	call ecom_randomBitwiseAndBCE

	; Randomly set how many frames to walk
	ld a,e
	ld hl,octorok_walkCounterValues
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.var30
	ld (de),a

	; Set random angle
	ld e,Enemy.angle
	ld a,c
	ld (de),a

	; 1 in 4 chance of changing direction toward Link (overriding previous angle)
	ld a,b
	or a
	call z,ecom_updateCardinalAngleTowardTarget
	jp ecom_updateAnimationFromAngle


; Values for var30 (how many frames to walk).
octorok_walkCounterValues:
	.db $19 $21 $29 $31


; State $0a: Octorok is walking for [var30] frames.
octorok_state_0a:
	ld h,d
	ld l,Enemy.var30
	dec (hl)
	jr nz,++

	ld l,e
	ld (hl),$08 ; [state] = $08
	ret
++
	call ecom_applyVelocityForTopDownEnemyNoHoles
	jr nz,++

	; Stopped moving, set new angle
	call ecom_setRandomCardinalAngle
	call ecom_updateAnimationFromAngle
++
	jp enemyAnimate


; State $0b: Waiting [counter1] frames, then shooting a projectile
octorok_state_0b:
	call ecom_decCounter1
	ret nz

	ld (hl),$20 ; [counter1] = $20 (wait this many frames after shooting)
	ld l,e
	ld (hl),$09 ; [state] = $09

	ld b,PARTID_OCTOROK_PROJECTILE
	call ecom_spawnProjectile
	ret nz
	ld a,SND_THROW
	jp playSound


; ==============================================================================
; ENEMYID_BOOMERANG_MOBLIN
; ==============================================================================
enemyCode0a:
	call ecom_checkHazards
	jr z,@normalStatus

	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@dead:
	ld e,Enemy.relatedObj2+1
	ld a,(de)
	or a
	jr z,++
	ld h,a
	ld l,Part.relatedObj1+1
	ld (hl),$ff
++
	jp enemyDie

@normalStatus:
	call ecom_checkScentSeedActive
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_scentSeed
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state_8
	.dw @state_9
	.dw @state_a


@state_uninitialized:
	ld a,SPEED_80
	call ecom_setSpeedAndState8AndVisible
	ld l,Enemy.var3f
	set 4,(hl)
	jp @gotoState8WithRandomAngleAndCounter


@state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jp z,@gotoState8WithRandomAngleAndCounter

	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a

	call ecom_updateAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemy
	jp enemyAnimate


@state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate1:
@@substate2:
	ret

@@substate3:
	ld b,$0a
	jp ecom_fallToGroundAndSetState

@state_stub:
	ret


; Moving until counter1 reaches 0
@state_8:
	call ecom_decCounter1
	jr z,++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,@animate
++
	ld e,Enemy.state
	ld a,$09
	ld (de),a
@animate:
	jp enemyAnimate


; Shoot a boomerang if Link is in that general direction; otherwise go back to state 8.
@state_9:
	call @gotoState8WithRandomAngleAndCounter
	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	swap a
	rlca
	ld h,d
	ld l,Enemy.direction
	cp (hl)
	ret nz

	; Spawn projectile
	ld b,PARTID_MOBLIN_BOOMERANG
	call ecom_spawnProjectile
	ret nz
	ld h,d
	ld l,Enemy.state
	ld (hl),$0a
	ret


; Waiting for boomerang to return
@state_a:
	ld e,Enemy.relatedObj2+1
	ld a,(de)
	or a
	jr nz,@animate

@gotoState8WithRandomAngleAndCounter:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counterVals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ld e,Enemy.state
	ld a,$08
	ld (de),a
	call ecom_setRandomCardinalAngle
	jp ecom_updateAnimationFromAngle

@counterVals:
	.db $30 $40 $50 $60


; ==============================================================================
; ENEMYID_LEEVER
; ==============================================================================
enemyCode0b:
	call ecom_checkHazards
	jr z,@normalStatus
	sub $03
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@dead:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr nz,@die

	; This is a respawning leever (subid 2), so spawn a new one
	ld b,ENEMYID_LEEVER
	call ecom_spawnEnemyWithSubid01
	ret nz

	inc (hl) ; [child.subid] = 2

	; Set Y/X
	ld e,Enemy.var30
	ld l,Enemy.yh
	ld a,(de)
	ldi (hl),a
	inc e
	inc l
	ld a,(de)
	ld (hl),a
@die:
	jp enemyDie

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_stub
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub


@normalState:
	ld a,b
	rst_jumpTable
	.dw @normalState_subid00
	.dw @normalState_subid01
	.dw @normalState_subid02


@state_uninitialized:
	call @setRandomCounter1
	jp ecom_setSpeedAndState8


@state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate1:
@@substate2:
	ret

@@substate3:
	ld e,Enemy.subid
	ld a,(de)
	ld hl,@@destStates
	rst_addAToHl
	ld b,(hl)
	jp ecom_fallToGroundAndSetState

@@destStates:
	.db $0a $0a $0a


@state_stub:
	ret


@normalState_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @subid00_stateA
	.dw @stateB


; Underground until counter1 reaches 0.
@state8:
	call ecom_decCounter1
	ret nz
	inc (hl)

	call @chooseSpawnPosition
	ret nz
	call objectSetShortPosition
	ld l,Enemy.state
	inc (hl) ; [state] = 9
	xor a
	call enemySetAnimation
	jp objectSetVisiblec2


; Emerging from the ground.
@state9:
	ld h,d
	ld l,Enemy.animParameter
	ld a,(hl)
	dec a
	jr nz,@animate

	; [animParameter] == 1; fully emerged.
	ld l,e
	inc (hl)
	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.speed
	ld (hl),SPEED_80
	call ecom_updateCardinalAngleTowardTarget
	call @setRandomHighCounter1
@animate:
	jp enemyAnimate


; Chasing Link.
@subid00_stateA:
	call ecom_decCounter1
	jp nz,@updatePosition

@backIntoGround:
	call ecom_incState
	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.speed
	ld (hl),SPEED_20
	ld a,$02
	jp enemySetAnimation


; Sinking back into the ground.
@stateB:
	ld h,d
	ld l,Enemy.animParameter
	ld a,(hl)
	dec a
	jr nz,@animate

	; [animParameter] == 1: Fully disappeared.
	ld l,e
	ld (hl),$08
	call @setRandomCounter1
	jp objectSetInvisible


@normalState_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @subid01_stateA
	.dw @stateB


; Chasing Link.
; (Same as subid 0's state A, except this sometimes "snaps" its angle back to Link
; immediately, making it more responsive?)
@subid01_stateA:
	call ecom_decCounter1
	jp z,@backIntoGround
	call getRandomNumber_noPreserveVars
	cp $14
	jp nc,@updatePosition
	call ecom_updateCardinalAngleTowardTarget
	jp @updatePosition


; Respawning leever
@normalState_subid02:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @subid02_state8
	.dw @subid02_state9
	.dw @subid02_stateA
	.dw @subid02_stateB
	.dw @subid02_stateC

@subid02_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.counter1
	ld a,(hl)
	and $30
	add $60
	ld (hl),a

	; Save initial position to var30/var31 so it can be restored when respawning.
	ld e,Enemy.yh
	ld l,Enemy.var30
	ld a,(de)
	ldi (hl),a
	ld e,Enemy.xh
	ld a,(de)
	ld (hl),a
	ret

; In ground, waiting until time to spawn.
@subid02_state9:
	call ecom_decCounter1
	ret nz
	inc l
	ld (hl),$06 ; [counter2] = 6
	ld l,e
	inc (hl) ; [state] = $0a
	xor a
	call enemySetAnimation
	jp objectSetVisiblec2


; Emerging from ground.
@subid02_stateA:
	ld e,Enemy.animParameter
	ld a,(de)
	dec a
	jr nz,@animate2

	; [animParameter] == 1; fully emerged.

	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = $0b

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.speed
	ld (hl),SPEED_a0
	call ecom_updateCardinalAngleTowardTarget
	call @setRandomHighCounter1
	jr @animate2


; Chasing Link. Unlike other leever types, if this hits a wall, it doesn't sink back into
; the ground until its timer is up.
@subid02_stateB:
	call ecom_decCounter1
	jp z,@backIntoGround
	call @nudgeTowardsLink
	call ecom_applyVelocityForSideviewEnemyNoHoles
@animate2:
	jp enemyAnimate


; Sinking back into ground.
@subid02_stateC:
	ld e,Enemy.animParameter
	ld a,(de)
	dec a
	jr nz,@animate2

	; [animParameter] == 1; fully disappeared.

	ld e,Enemy.state
	ld a,$09
	ld (de),a
	call @setRandomCounter1
	jp objectSetInvisible


;;
; Updates position, checks for collision with wall (or hole).
@updatePosition:
	ld a,$01 ; Set to $01 to treat holes as walls
	call ecom_getTopDownAdjacentWallsBitset
	jp nz,@backIntoGround
	call objectApplySpeed
	jp enemyAnimate

;;
; @param	b	Subid. if 0, it spawns relative to Link's position & direction;
;			otherwise it spawns in a completely random position.
; @param[out]	c	Position
; @param[out]	zflag	z if a valid position was returned
@chooseSpawnPosition:
	ld a,b
	or a
	jr nz,@@chooseRandomSpot

	; Spawn in relative to Link's position.

	ld de,w1Link.yh
	call getShortPositionFromDE
	ld c,a
	ld e,<w1Link.direction
	ld a,(de)
	rlca
	rlca
	ld hl,@@linkRelativeOffsets
	rst_addAToHl
	ld a,(wFrameCounter)
	and $03
	rst_addAToHl
	ldh a,(<hActiveObject)
	ld d,a
	ld a,c
	add (hl)
	ld c,a

	; We have a candidate position; check for validity. NOTE: Assumes small room.
	and $f0
	cp SMALL_ROOM_HEIGHT<<4
	jr nc,@@invalid
	ld a,c
	and $0f
	cp SMALL_ROOM_WIDTH
	jr nc,@@invalid

	ld b,>wRoomCollisions
	ld a,(bc)
	or a
	ret

@@invalid:
	or d
	ret

; Each of Link's directions has 4 candidates, one is chosen randomly.
@@linkRelativeOffsets:
	.db $d0 $c0 $b0 $b0 ; DIR_UP
	.db $03 $04 $05 $05 ; DIR_RIGHT
	.db $30 $40 $50 $50 ; DIR_DOWN
	.db $fd $fc $fb $fb ; DIR_LEFT

@@chooseRandomSpot:
	call getRandomNumber_noPreserveVars
	and $77
	ld c,a
	ld b,>wRoomCollisions
	ld a,(bc)
	or a
	ret


@setRandomCounter1:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret

@counter1Vals:
	.db $10 $30 $50 $70

@setRandomHighCounter1:
	call getRandomNumber_noPreserveVars
	ld e,Enemy.counter1
	and $38
	add $70
	ld (de),a
	ret

@nudgeTowardsLink:
	call ecom_decCounter2
	ret nz
	ld (hl),$06
	call objectGetAngleTowardEnemyTarget
	jp objectNudgeAngleTowards


; ==============================================================================
; ENEMYID_ARROW_MOBLIN
; ENEMYID_MASKED_MOBLIN
; ENEMYID_ARROW_SHROUDED_STALFOS
;
; These enemies and ENEMYID_ARROW_DARKNUT share some code.
; ==============================================================================
enemyCode0c:
enemyCode20:
enemyCode22:
	call ecom_checkHazards
	jr z,@normalStatus

	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret
@dead:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr nz,++
	ld hl,wKilledGoldenEnemies
	set 1,(hl)
++
	jp enemyDie

@normalStatus:
	call ecom_checkScentSeedActive
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw moblin_state_uninitialized
	.dw moblin_state_stub
	.dw moblin_state_stub
	.dw moblin_state_switchHook
	.dw moblin_state_scentSeed
	.dw ecom_blownByGaleSeedState
	.dw moblin_state_stub
	.dw moblin_state_stub
	.dw moblin_state_8
	.dw moblin_state_9


moblin_state_uninitialized:
	; Enable chasing scent seeds
	ld h,d
	ld l,Enemy.var3f
	set 4,(hl)

	ld l,Enemy.subid
	bit 1,(hl)
	jr z,++
	ld a,(wKilledGoldenEnemies)
	bit 1,a
	jp nz,enemyDelete
++
	jp arrowDarknut_state_uninitialized


moblin_state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jp z,arrowDarknut_setState8WithRandomAngleAndCounter

	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a
	call ecom_updateAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemy
	jp enemyAnimate


; Also used by darknuts
moblin_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw ecom_fallToGroundAndSetState8

@substate1:
@substate2:
	ret


moblin_state_stub:
	ret


; Also darknut state 8 (moving in some direction)
moblin_state_8:
	call ecom_decCounter1
	jr z,+
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,++
+
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$08
++
	jp enemyAnimate


; Standing until counter1 reaches 0 and a new direction is decided on.
moblin_state_9:
	call ecom_decCounter1
	ret nz
	call ecom_setRandomCardinalAngle
	call arrowDarknut_setState8WithRandomAngleAndCounter
	jr arrowDarknut_fireArrowEveryOtherTime


; ==============================================================================
; ENEMYID_ARROW_DARKNUT
; ==============================================================================
enemyCode21:
.ifdef ROM_AGES
	call ecom_checkHazards
.else
	call ecom_seasonsFunc_4446
.endif
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw arrowDarknut_state_uninitialized
	.dw moblin_state_stub
	.dw moblin_state_stub
	.dw moblin_state_switchHook
	.dw moblin_state_stub
	.dw moblin_state_stub
	.dw moblin_state_stub
	.dw moblin_state_stub
	.dw moblin_state_8
	.dw arrowDarknut_state_9


; Also used by moblins
arrowDarknut_state_uninitialized:
	ld e,Enemy.speed
	ld a,SPEED_80
	ld (de),a
	call ecom_setRandomCardinalAngle
	call arrowDarknut_setState8WithRandomAngleAndCounter
	jp objectSetVisiblec2


arrowDarknut_state_9:
	call ecom_decCounter1
	ret nz
	call arrowDarknut_chooseAngle
	call arrowDarknut_setState8WithRandomAngleAndCounter

; This is also used by moblin's state 9.
; Every other time they move, if they're facing Link, fire an arrow.
arrowDarknut_fireArrowEveryOtherTime:
	ld h,d
	ld l,Enemy.var30
	inc (hl)
	bit 0,(hl)
	ret z
	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	ld h,d
	ld l,Enemy.angle
	cp (hl)
	ret nz
	ld b,PARTID_ENEMY_ARROW
	jp ecom_spawnProjectile


;;
; Sets random angle and counter, and goes to state 8.
arrowDarknut_setState8WithRandomAngleAndCounter:
	call getRandomNumber_noPreserveVars
	and $3f
	add $30
	ld h,d
	ld l,Enemy.counter1
	ld (hl),a
	ld l,Enemy.state
	ld (hl),$08
	jp ecom_updateAnimationFromAngle

;;
; 1-in-4 chance of turning to face Link directly, otherwise turns in a random direction.
arrowDarknut_chooseAngle:
	call getRandomNumber_noPreserveVars
	and $03
	jp z,ecom_updateCardinalAngleTowardTarget
	jp ecom_setRandomCardinalAngle


; ==============================================================================
; ENEMYID_LYNEL
;
; Variables:
;   var30: Determines probability that the Lynel turns toward Link whenever it turns (less
;          bits set = more likely).
; ==============================================================================
enemyCode0d:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@dead:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr nz,++
	ld hl,wKilledGoldenEnemies
	set 3,(hl)
++
	jp enemyDie

@normalStatus:
	call ecom_checkScentSeedActive
	jr z,++
	ld e,Enemy.speed
	ld a,SPEED_100
	ld (de),a
++
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_scentSeed
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_08
	.dw @state_09
	.dw @state_0a


@state_uninitialized:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr nz,++
	ld hl,wKilledGoldenEnemies
	bit 3,(hl)
	jp nz,enemyDelete
++
	ld e,Enemy.subid
	ld a,(de)
	ld hl,@var30Vals
	rst_addAToHl
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a

	call objectSetVisiblec2
	call getRandomNumber_noPreserveVars
	and $30
	ld c,a
	ld h,d

	; Enable scent seed effect
	ld l,Enemy.var3f
	set 4,(hl)

	ld l,Enemy.state
	jp @changeDirection

@var30Vals:
	.db $07 $03 $01


@state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jp z,@gotoState8
	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a
	ld b,$04
	call @updateAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemy
	jp enemyAnimate

@state_stub:
	ret


; Choose whether to walk around some more, or fire a projectile.
@state_08:
	ld e,Enemy.var30
	ld a,(de)
	ld b,a
	ld c,$30
	call ecom_randomBitwiseAndBCE
	or b
	ld h,d
	ld l,Enemy.state
	jr z,@prepareProjectile

@changeDirection:
	ld (hl),$09 ; [state] = $09
	ld l,Enemy.counter1
	ld a,$30
	add c
	ld (hl),a
	jr @updateAngleAndSpeed

@prepareProjectile:
	ld (hl),$0a ; [state] = $0a
	ld l,Enemy.counter1
	ld (hl),$08
	call ecom_updateCardinalAngleTowardTarget
	jp ecom_updateAnimationFromAngle


; Moving until counter1 reaches 0, then return to state 8
@state_09:
	call ecom_decCounter1
	jr z,@gotoState8
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr z,@updateAngleAndSpeed
@animate:
	jp enemyAnimate


; Standing for a moment before firing projectile
@state_0a:
	call ecom_decCounter1
	jr nz,@animate
	ld b,PARTID_LYNEL_BEAM
	call ecom_spawnProjectile
	jr nz,@gotoState8

	call getRandomNumber_noPreserveVars
	and $30
	add $30
	ld e,Enemy.counter1
	ld (de),a

	ld h,d
	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.state
	ld (hl),$09
	jr @animate

@gotoState8:
	ld e,Enemy.state
	ld a,$08
	ld (de),a
	jr @animate

;;
; The lynel turns, and if Link is in its sights, it charges.
@updateAngleAndSpeed:
	call @chooseNewAngle
	ld b,$0e
	call objectCheckCenteredWithLink
	jr nc,++

	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	ld h,d
	ld l,Enemy.angle
	cp (hl)
	ld a,SPEED_100
	ld b,$04
	jr z,+++
++
	ld a,SPEED_80
	ld b,$00
+++
	ld l,Enemy.speed
	ld (hl),a

;;
; @param	b	0 if walking, 4 if running (value to add to animation)
@updateAnimationFromAngle:
	ld h,d
	ld l,Enemy.angle
	ldd a,(hl)
	swap a
	rlca
	add b
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
; Chooses a new angle; var30 sets the probability that it will turn to face Link instead
; of just a random direction.
@chooseNewAngle:
	call getRandomNumber_noPreserveVars
	ld h,d
	ld l,Enemy.var30
	and (hl)
	jp nz,ecom_setRandomCardinalAngle
	jp ecom_updateCardinalAngleTowardTarget


; ==============================================================================
; ENEMYID_BLADE_TRAP
; ENEMYID_FLAME_TRAP
;
; Variables for normal traps:
;   var30: Speed
;
; Variables for circular traps:
;   var30: Center Y for circular traps
;   var31: Center X for circular traps
;   var32: Radius of circle for circular traps
; ==============================================================================
enemyCode0e:
.ifdef ROM_SEASONS
enemyCode2b:
.endif
	dec a
	ret z
	dec a
	ret z
	call enemyAnimate
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw bladeTrap_subid00
	.dw bladeTrap_subid01
	.dw bladeTrap_subid02
	.dw bladeTrap_subid03
	.dw bladeTrap_subid04
	.dw bladeTrap_subid05


@state_uninitialized:
	ld a,b
	sub $03
	cp $02
	call c,bladeTrap_initCircular

	; Set different animation and var3e value for the spinning trap
	ld e,Enemy.subid
	ld a,(de)
	or a
	ld a,$08
	jr nz,++

	ld a,$01
	call enemySetAnimation
	ld a,$01
++
	ld e,Enemy.var3e
	ld (de),a
	jp ecom_setSpeedAndState8AndVisible

@state_stub:
	ret


; Red, spinning trap
bladeTrap_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ld a,$01
	jp enemySetAnimation


; Waiting for Link to walk into range
@state9:
	ld b,$0e
	call bladeTrap_checkLinkAligned
	ret nc
	call bladeTrap_checkObstructionsToTarget
	ret nz

	ld h,d
	ld l,Enemy.state
	ld (hl),$0a

	ld l,Enemy.counter1
	ld (hl),$18

	ld a,SND_MOVEBLOCK
	call playSound

	ld a,$02
	jp enemySetAnimation


; Moving toward Link (half-speed, just starting up)
@stateA:
	ld e,Enemy.counter1
	ld a,(de)
	rrca
	call c,ecom_applyVelocityForTopDownEnemyNoHoles
	call ecom_decCounter1
	jr nz,@animate

	ld l,Enemy.state
	ld (hl),$0b
@animate:
	jp enemyAnimate


; Moving toward Link
@stateB:
	call ecom_applyVelocityForTopDownEnemyNoHoles
	jr nz,@animate

	; Hit wall
	ld e,Enemy.state
	ld a,$09
	ld (de),a
	ld a,$01
	jp enemySetAnimation


; Blue, gold blade traps (reach exactly to the center of a large room, no further)
bladeTrap_subid01:
bladeTrap_subid02:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.subid
	ld a,(hl)
	dec a
	ld a,SPEED_180
	jr z,+
	ld a,SPEED_300
+
	ld l,Enemy.var30
	ld (hl),a


; Waiting for Link to walk into range
@state9:
	ld b,$0d
	call bladeTrap_checkLinkAligned
	ret nc
	call bladeTrap_checkObstructionsToTarget
	ret nz

	ld a,$01
	call ecom_getTopDownAdjacentWallsBitset
	ret nz

	call ecom_incState

	ld e,Enemy.var30
	ld l,Enemy.speed
	ld a,(de)
	ld (hl),a
	ld a,SND_UNKNOWN5
	jp playSound


; Moving
@stateA:
	call ecom_applyVelocityForTopDownEnemyNoHoles
	ld h,d
	jr z,@beginRetracting

	; Blade trap spans about half the size of a large room (which is different in
	ld l,Enemy.angle
	bit 3,(hl)
	ld b,((LARGE_ROOM_HEIGHT/2)<<4) + 8
	ld l,Enemy.yh
	jr z,++

	ld b,((LARGE_ROOM_WIDTH/2)<<4) + 8
	ld l,Enemy.xh
++
	ld a,(hl)
	sub b
	add $07
	cp $0f
	ret nc

@beginRetracting:
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	ld l,Enemy.state
	inc (hl)
	ld a,SND_CLINK
	jp playSound


; Retracting
@stateB:
	call ecom_applyVelocityForTopDownEnemyNoHoles
	ret nz
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$10
	ret


; Cooldown of 16 frames
@stateC:
	call ecom_decCounter1
	ret nz
	ld l,Enemy.state
	ld (hl),$09
	ret


; Circular blade traps (clockwise & counterclockwise, respectively)
bladeTrap_subid03:
bladeTrap_subid04:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8

@state8:
	ld a,(wFrameCounter)
	and $01
	call z,bladeTrap_updateAngle

	; Update position
	ld h,d
	ld l,Enemy.var30
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ld a,(hl)
	ld e,Enemy.angle
	jp objectSetPositionInCircleArc


; Unlimited range green blade
bladeTrap_subid05:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.var30
	ld (hl),SPEED_200


; Waiting for Link to walk into range
@state9:
	ld b,$0e
	call bladeTrap_checkLinkAligned
	ret nc
	call bladeTrap_checkObstructionsToTarget
	ret nz

	ld a,$01
	call ecom_getTopDownAdjacentWallsBitset
	ret nz

	ld h,d
	ld e,Enemy.var30
	ld l,Enemy.speed
	ld a,(de)
	ld (hl),a

	ld l,Enemy.state
	inc (hl)
	ld a,SND_UNKNOWN5
	jp playSound


; Moving toward Link
@stateA:
	call ecom_applyVelocityForTopDownEnemyNoHoles
	ret nz

	call ecom_incState
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ld a,SND_CLINK
	jp playSound


; Retracting
@stateB:
	call ecom_applyVelocityForTopDownEnemyNoHoles
	ret nz
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$10
	ret


; Cooldown of 16 frames
@stateC:
	call ecom_decCounter1
	ret nz
	ld l,Enemy.state
	ld (hl),$09
	ret

;;
; Only for subids 3-4 (circular traps)
bladeTrap_updateAngle:
	ld e,Enemy.subid
	ld a,(de)
	cp $03
	ld e,Enemy.angle
	jp nz,bladeTrap_decAngle
	jp bladeTrap_incAngle

;;
bladeTrap_initCircular:
	call getRandomNumber_noPreserveVars
	and $1f
	ld e,Enemy.angle
	ld (de),a

	ld e,Enemy.yh
	ld a,(de)
	ld c,a
	and $f0
	add $08
	ld e,Enemy.var30
	ld (de),a
	ld b,a

	ld a,c
	and $0f
	swap a
	add $08
	ld e,Enemy.var31
	ld (de),a
	ld c,a

	ld e,Enemy.xh
	ld a,(de)
	ld e,Enemy.var32
	ld (de),a

	ld e,Enemy.angle
	jp objectSetPositionInCircleArc


; Position offset to add when checking each successive tile between the trap and the
; target for solidity
bladeTrap_directionOffsets:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

;;
; @param[out]	zflag	z if there are no obstructions (solid tiles) between trap and
;			target
bladeTrap_checkObstructionsToTarget:
	ld h,d
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	ldh a,(<hEnemyTargetX)
	sub c
	add $04
	cp $09
	jr nc,++

	ldh a,(<hEnemyTargetY)
	sub b
	add $04
	cp $09
	ret c
++
	ld l,Enemy.angle
	call @getNumTilesToTarget

	; Get direction offset in hl
	ld a,(hl)
	rrca
	rrca
	ld hl,bladeTrap_directionOffsets
	rst_addAToHl
	ldi a,(hl)
	ld l,(hl)
	ld h,a

	; Check each tile between the trap and the target for solidity
	push de
	ld d,>wRoomCollisions
--
	call @checkNextTileSolid
	jr nz,++
	ldh a,(<hFF8B)
	dec a
	ldh (<hFF8B),a
	jr nz,--
++
	pop de
	ret

;;
; @param	bc	Tile we're at right now
; @param	d	>wRoomCollisions
; @param	hl	Value to add to bc each time (direction offset)
; @param[out]	zflag	nz if tile is solid
@checkNextTileSolid:
	ld a,b
	add h
	ld b,a
	and $f0
	ld e,a
	ld a,c
	add l
	ld c,a
	and $f0
	swap a
	or e
	ld e,a
	ld a,(de)
	or a
	ret

;;
; @param	bc	Enemy position
; @param	hl	Enemy angle
; @param[out]	hFF8B	Number of tiles between enemy and target
@getNumTilesToTarget:
	ld e,b
	ldh a,(<hEnemyTargetY)
	bit 3,(hl)
	jr z,+
	ld e,c
	ldh a,(<hEnemyTargetX)
+
	sub e
	jr nc,+
	cpl
	inc a
+
	swap a
	and $0f
	jr nz,+
	inc a
+
	ldh (<hFF8B),a
	ret

;;
; Determines if Link is aligned close enough on the X or Y axis to be attacked; if so,
; this sets the blade's angle accordingly.
;
; @param	b	How close Link must be (on the orthogonal axis relative to the
;			attack) before the trap can attack
; @param[out]	cflag	c if Link is in range
bladeTrap_checkLinkAligned:
	ld c,b
	sla c
	inc c
	ld e,$00
	ld h,d
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add b
	cp c
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	jr c,@inRange

	ld e,$18
	sub (hl)
	add b
	cp c
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	ret nc

@inRange:
	cp (hl)
	ld a,e
	jr c,+
	xor $10
+
	ld l,Enemy.angle
	ld (hl),a
	scf
	ret

;;
bladeTrap_incAngle:
	ld a,(de)
	inc a
	jr ++

;;
bladeTrap_decAngle:
	ld a,(de)
	dec a
++
	and $1f
	ld (de),a
	ret


; ==============================================================================
; ENEMYID_ROPE
;
; Variables:
;   counter2: Cooldown until rope can charge at Link again
;   var30: Hazards are checked iff bit 7 is set.
; ==============================================================================
enemyCode10:
	call rope_checkHazardsIfApplicable
	or a
	jr z,@normalStatus

	sub $03
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@normalStatus:
	call ecom_checkScentSeedActive
	jr z,++
	ld e,Enemy.speed
	ld a,SPEED_140
	ld (de),a
++
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_scentSeed
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub


@normalState:
	ld a,b
	rst_jumpTable
	.dw rope_subid00
	.dw rope_subid01
	.dw rope_subid02
	.dw rope_subid03


@state_uninitialized:
	ld e,Enemy.direction
	ld a,$ff
	ld (de),a

	; Subid 1: make speed lower?
	dec b
	ld a,SPEED_60
	jp z,ecom_setSpeedAndState8

	; Enable scent seed effect
	ld h,d
	ld l,Enemy.var3f
	set 4,(hl)

	jp ecom_setSpeedAndState8AndVisible


@state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate1:
@@substate2:
	ret


@@substate3:
	ld e,Enemy.subid
	ld a,(de)
	ld hl,@defaultStates
	rst_addAToHl
	ld b,(hl)
	jp ecom_fallToGroundAndSetState


@state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jr nz,++

	ld e,Enemy.subid
	ld a,(de)
	ld hl,@defaultStates
	rst_addAToHl
	ld e,Enemy.state
	ld a,(hl)
	ld (de),a
	ld e,Enemy.speed
	ld a,SPEED_60
	ld (de),a
	ret
++
	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a
	call rope_updateAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemy
	jp rope_animate


@defaultStates: ; Default states for each subid
	.db $09 $0b $0a $0a


@state_stub:
	ret


; Normal rope.
rope_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw rope_state_moveAround
	.dw rope_state_chargeLink


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.var30
	set 7,(hl)


; Moving around, checking whether to charge Link
rope_state_moveAround:
	ld b,$0a
	call objectCheckCenteredWithLink
	jr nc,++

	ld e,Enemy.counter2
	ld a,(de)
	or a
	jr nz,++

	; Charge at Link
	call ecom_updateCardinalAngleTowardTarget
	call ecom_incState
	ld l,Enemy.speed
	ld (hl),SPEED_140
	jp rope_updateAnimationFromAngle

++
	call ecom_decCounter2
	dec l
	dec (hl) ; [counter1]--
	call nz,ecom_applyVelocityForSideviewEnemyNoHoles
	jp z,rope_changeDirection

rope_callEnemyAnimate:
	jp enemyAnimate


; Charging Link
rope_state_chargeLink:
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp nz,rope_animate

	ld h,d
	ld l,Enemy.state
	dec (hl)

	ld l,Enemy.speed
	ld (hl),SPEED_60
	ld l,Enemy.counter2
	ld (hl),$40
	jp rope_changeDirection


; Rope that falls from the sky.
rope_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw rope_state_moveAround
	.dw rope_state_chargeLink


; Initialization
@state8:
	ld a,$09
	ld (de),a
	call getRandomNumber_noPreserveVars
	ld e,Enemy.counter1
	and $38
	inc a
	ld (de),a
	ret


; Wait a random amount of time before dropping from the sky
@state9:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]++

	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.var30
	set 7,(hl)

	ld l,Enemy.speedZ+1
	inc (hl)

	ld a,SND_FALLINHOLE
	call playSound
	call objectSetVisiblec1

	ld c,$08
	jp ecom_setZAboveScreen


; Currently falling from the sky
@stateA:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	ret nz

	ld l,Enemy.speedZ
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.state
	inc (hl)

	; Enable scent seeds
	ld l,Enemy.var3f
	set 4,(hl)

	call objectSetVisiblec2
	ld a,SND_BOMB_LAND
	call playSound

	call rope_changeDirection
	jr rope_callEnemyAnimate


; Immediately charges Link upon spawning
rope_subid02:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw rope_state_moveAround
	.dw rope_state_chargeLink


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.speed
	ld (hl),SPEED_140
	ld l,Enemy.counter1
	ld (hl),$08
	call ecom_updateCardinalAngleTowardTarget
	jp rope_updateAnimationFromAngle


; Waiting just before charging Link
@state9:
	call ecom_decCounter1
	jr nz,++

	ld l,e
	ld (hl),$0b ; [state] = "charge at Link" state

	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.var30
	set 7,(hl)
++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp enemyAnimate


; Falls and bounces toward Link when it spawns
rope_subid03:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw rope_state_moveAround
	.dw rope_state_chargeLink


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.speedZ
	ld a,$fe
	ldi (hl),a
	ld (hl),$fe

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	ld l,Enemy.angle
	ld a,(w1Link.direction)
	swap a
	rrca
	ld (hl),a

	jp rope_updateAnimationFromAngle


; "Bouncing" toward Link
@state9:
	ld c,$0e
	call objectUpdateSpeedZAndBounce
	jr c,@doneBouncing

	ld a,SND_BOMB_LAND
	call z,playSound

	; Enable collisions if speedZ is positive?
	ld e,Enemy.speedZ+1
	ld a,(de)
	or a
	jr nz,++
	ld h,d
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.var30
	set 7,(hl)
++
	jp ecom_applyVelocityForSideviewEnemyNoHoles

@doneBouncing:
	call ecom_incState
	ld l,Enemy.speed
	ld (hl),SPEED_60

;;
; Chooses random new angle, random value for counter1.
rope_changeDirection:
	ldbc $18,$70
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,b
	ld (de),a
	ld e,Enemy.counter1
	ld a,c
	add $70
	ld (de),a

;;
rope_updateAnimationFromAngle:
	ld h,d
	ld l,Enemy.angle
	ld a,(hl)
	and $0f
	ret z

	ldd a,(hl)
	and $10
	swap a
	xor $01
	cp (hl)
	ret z

	ld (hl),a
	jp enemySetAnimation

;;
rope_animate:
	ld h,d
	ld l,Enemy.animCounter
	ld a,(hl)
	sub $03
	jr nc,+
	xor a
+
	inc a
	ld (hl),a
	jp enemyAnimate

;;
rope_checkHazardsIfApplicable:
	ld h,d
	ld l,Enemy.var30
	bit 7,(hl)
	ret z
	jp ecom_checkHazards


; ==============================================================================
; ENEMYID_GIBDO
; ==============================================================================
enemyCode12:
	; a = ENEMY_STATUS
	call ecom_checkHazards

	; a = ENEMY_STATUS
	jr z,@normalStatus

	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

	; If just hit by ember seed, go to state $0a (turn into stalfos)
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_EMBER_SEED
	ret nz

	ld h,d
	ld l,Enemy.state
	ld a,$0a
	cp (hl)
	ret z

	ld (hl),a
	ld l,Enemy.counter1
	ld (hl),30
	ld l,Enemy.stunCounter
	ld (hl),$00
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_stub
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA


@uninitialized:
	ld a,SPEED_80
	jp ecom_setSpeedAndState8AndVisible


@state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @@substate1
	.dw @@substate2
	.dw ecom_fallToGroundAndSetState8

@@substate1:
@@substate2:
	ret

@state_stub:
	ret


; Choosing a direction & duration to walk
@state8:
	ld a,$09
	ld (de),a

	; Choose random angle & counter1
	ldbc $18,$7f
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,b
	ld (de),a
	ld e,Enemy.counter1
	ld a,$40
	add c
	ld (de),a
	jr @animate


; Walking in some direction for [counter1] frames
@state9:
	call ecom_decCounter1
	jr z,@gotoState8
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr z,@gotoState8
@animate:
	jp enemyAnimate


; Burning; turns into stalfos
@stateA:
	call ecom_decCounter1
	ret nz
	ldbc ENEMYID_STALFOS,$02
	jp enemyReplaceWithID


@gotoState8:
	ld e,Enemy.state
	ld a,$08
	ld (de),a
	jr @animate


; ==============================================================================
; ENEMYID_SPARK
; ==============================================================================
enemyCode13:
	call ecom_checkHazards
	jr z,@normalStatus

	sub ENEMYSTATUS_NO_HEALTH
	ret c
	ld e,Enemy.var2a
	ld a,(de)
	res 7,a
	sub ITEMCOLLISION_L1_BOOMERANG
	cp MAX_BOOMERANG_LEVEL
	jr nc,@normalStatus

	; Collision with boomerang occurred. Go to state 9.
	ld e,Enemy.state
	ld a,(de)
	cp $09
	jr nc,@normalStatus
	ld a,$09
	ld (de),a

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw spark_state_uninitialized
	.dw spark_state_stub
	.dw spark_state_stub
	.dw spark_state_stub
	.dw spark_state_stub
	.dw spark_state_stub
	.dw spark_state_stub
	.dw spark_state_stub
	.dw spark_state8
	.dw spark_state9
	.dw spark_stateA


spark_state_uninitialized:
	call spark_getWallAngle
	ld e,Enemy.angle
	ld (de),a
	ld a,SPEED_100
	call ecom_setSpeedAndState8
	jp objectSetVisible82


spark_state_stub:
	ret


; Standard movement state.
spark_state8:
	call spark_updateAngle
	call objectApplySpeed
	jp enemyAnimate


; Just hit by a boomerang. (Also whisp's state 9.)
spark_state9:
	ldbc INTERACID_PUFF,$02
	call objectCreateInteraction
	ret nz

	ld e,Enemy.relatedObj2
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	call ecom_incState
	jp objectSetInvisible


; Will delete self and create fairy when the "puff" is gone. (Also whisp's state A.)
spark_stateA:
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	ld a,(hl)
	inc a
	ret nz

	ld e,Enemy.id
	ld a,(de)
	cp ENEMYID_SPARK
	ld b,PARTID_ITEM_DROP
	call z,ecom_spawnProjectile
	jp enemyDelete


; ==============================================================================
; ENEMYID_WHISP
; ==============================================================================
enemyCode19:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

	ld e,Enemy.var2a
	ld a,(de)
	res 7,a
	sub ITEMCOLLISION_L1_BOOMERANG
	cp MAX_BOOMERANG_LEVEL
	jr nc,@normalStatus

	; Hit with boomerang
	ld e,Enemy.state
	ld a,(de)
	cp $09
	jr nc,@normalStatus
	ld a,$09
	ld (de),a

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw whisp_state_uninitialized
	.dw spark_state_stub
	.dw spark_state_stub
	.dw spark_state_stub
	.dw spark_state_stub
	.dw ecom_blownByGaleSeedState
	.dw spark_state_stub
	.dw spark_state_stub
	.dw whisp_state8
	.dw spark_state9
	.dw spark_stateA


whisp_state_uninitialized:
	call getRandomNumber_noPreserveVars
	and $18
	add $04
	ld e,Enemy.angle
	ld (de),a

	ld a,SPEED_c0
	call ecom_setSpeedAndState8

	jp objectSetVisible82


whisp_state8:
	call ecom_bounceOffWalls
	call objectApplySpeed
	jp enemyAnimate


;;
; Updates the spark's moving angle by checking for walls, updating angle appropriately.
; Sparks move by hugging walls.
spark_updateAngle:
	ld a,$01
	ldh (<hFF8A),a

	; Confirm that we're still up against a wall
	ld e,Enemy.angle
	ld a,(de)
	sub $08
	and $18
	call spark_checkWallInDirection
	jr c,++

	; The wall has gone missing, but don't update angle until we're centered by
	; 8 pixels.
	call spark_getTileOffset
	ret nz

	ld e,Enemy.angle
	ld a,(de)
	sub $08
	and $18
	ld (de),a
	ret
++
	; We're still hugging a wall, but check if we're running into one now.
	ld e,Enemy.angle
	ld a,(de)
	call spark_checkWallInDirection
	ret nc

	ld e,Enemy.angle
	ld a,(de)
	add $08
	and $18
	ld (de),a
	ret


;;
; @param[out]	a	Angle relative to enemy where wall is (only valid if cflag is set)
; @param[out]	cflag	c if there is a wall in any direction, nc otherwise
spark_getWallAngle:
	xor a
	call spark_checkWallInDirection
	ld a,$08
	ret c
	call spark_checkWallInDirection
	ld a,$10
	ret c
	call spark_checkWallInDirection
	ld a,$18
	ret c
	xor a
	ret

;;
; @param[out]	a	A value from 0-7, indicating the offset within a quarter-tile the
;			whisp is at. When this is 0, it needs to check for a direction
;			change?
spark_getTileOffset:
	ld e,Enemy.angle
	ld a,(de)
	bit 3,a
	jr nz,++
	ld e,Enemy.yh
	ld a,(de)
	and $07
	ret
++
	ld e,Enemy.xh
	ld a,(de)
	and $07
	ret

;;
; @param	a	Angle to check
; @param[out]	cflag	c if there's a solid wall in that direction
spark_checkWallInDirection:
	and $18
	rrca
	ld hl,@offsetTable
	rst_addAToHl
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld b,a

	inc hl
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	ld c,a

	push hl
	push bc
	call checkTileCollisionAt_disallowHoles
	pop bc
	pop hl
	ret c

	inc hl
	ldi a,(hl)
	add b
	ld b,a
	ld a,(hl)
	add c
	ld c,a
	jp checkTileCollisionAt_disallowHoles


; Each direction lists two position offsets to check for collisions at.
@offsetTable:
	.db $f7 $fc $00 $07 ; DIR_UP
	.db $fc $08 $07 $00 ; DIR_RIGHT
	.db $08 $fc $00 $07 ; DIR_DOWN
	.db $fc $f7 $07 $00 ; DIR_LEFT


; ==============================================================================
; ENEMYID_SPIKED_BEETLE
;
; Variables:
;   var30: $00 normally, $01 when flipped over.
; ==============================================================================
enemyCode14:
	call ecom_checkHazards
	jr z,@normalStatus

	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

	dec a
	jr nz,@knockback

	; Just hit by something

	; If bit 0 of var30 is set, ...?
	ld h,d
	ld l,Enemy.var30
	bit 0,(hl)
	jr z,++
	ld e,Enemy.zh
	ld a,(de)
	rlca
	jr c,++
	ld (hl),$00
++
	; Check if the collision was a shovel or shield (enemy will flip over)
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_SHOVEL
	jr z,++
	res 7,a
	sub ITEMCOLLISION_L1_SHIELD
	cp (ITEMCOLLISION_L3_SHIELD-ITEMCOLLISION_L1_SHIELD)+1
	jr nc,@normalStatus
++
	; If already flipped, return.
	ld e,Enemy.state
	ld a,(de)
	cp $0b
	ret z

	; Flip over.

	ld (hl),$01 ; [var30] = $01
	ld bc,-$180
	call objectSetSpeedZ

	ld l,Enemy.state
	ld (hl),$0b

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_SPIKED_BEETLE_FLIPPED

	ld l,Enemy.counter1
	ld (hl),180

	ld l,Enemy.knockbackAngle
	ld a,(hl)
	xor $10
	ld l,Enemy.angle
	ld (hl),a

	ld a,SND_BOMB_LAND
	call playSound
	ld a,$01
	jp enemySetAnimation


@knockback:
	ld e,Enemy.var30
	ld a,(de)
	or a
	jp z,ecom_updateKnockbackAndCheckHazards

	; If flipped over, knockback is considered to last until it stops bouncing.
	ld c,$18
	call objectUpdateSpeedZAndBounce
	ld a,$01
	jr nc,+
	xor a
+
	ld e,Enemy.knockbackCounter
	ld (de),a
	ld e,Enemy.knockbackAngle
	ld a,(de)
	ld c,a
	ld b,SPEED_e0
	jp ecom_applyGivenVelocity


@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


@state_uninitialized:
	call @setRandomAngleAndCounter1
	ld a,SPEED_40
	jp ecom_setSpeedAndState8AndVisible


@state_stub:
	ret


; Wandering around until Link comes into range
@state8:
	ld b,$08
	call objectCheckCenteredWithLink
	jp c,@chargeLink

	call ecom_decCounter1
	jp z,@setRandomAngleAndCounter1
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp z,@setRandomAngleAndCounter1
@animate:
	jp enemyAnimate


; Charging at Link
@state9:
	call ecom_decCounter2
	call @incSpeed
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,@animate

	; Hit wall
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),30
	ret


; Standing still for 30 frames (unless it can charge Link again)
@stateA:
	ld b,$08
	call objectCheckCenteredWithLink
	jp c,@chargeLink

	call ecom_decCounter1
	jr nz,@animate

	ld l,Enemy.state
	ld (hl),$08
	ld l,Enemy.speed
	ld (hl),SPEED_40
	jp @setRandomAngleAndCounter1


; Flipped over.
@stateB:
	call ecom_decCounter1
	jr nz,++

	; Flip back to normal.

	ld l,e
	inc (hl) ; [state] = $0c
	ld l,Enemy.speed
	ld (hl),SPEED_c0

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_SPIKED_BEETLE
	ld l,Enemy.xh
	inc (hl)
	ld bc,-$180
	call objectSetSpeedZ
	xor a
	jp enemySetAnimation
++
	; Waiting to flip back.
	ld a,(hl)
	cp 60
	jr nc,@animate

	; In last second, start shaking.
	and $06
	rrca
	ld hl,@xOscillationOffsets
	rst_addAToHl
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	ld (de),a
	jr @animate


; In the process of flipping back to normal.
@stateC:
	call ecom_applyVelocityForSideviewEnemyNoHoles
	call enemyAnimate

	ld c,$18
	call objectUpdateSpeedZ_paramC
	ret nz

	ld e,Enemy.state
	ld a,$08
	ld (de),a

	ld b,$10
	call objectCheckCenteredWithLink
	jr c,@chargeLink

	ld e,Enemy.speed
	ld a,SPEED_40
	ld (de),a
	ret

;;
; Angle and counter1 are set randomly (counter1 is between $30-$60, in increments of $10).
@setRandomAngleAndCounter1:
	ldbc $18,$30
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,b
	ld (de),a
	ld e,Enemy.counter1
	ld a,$30
	add c
	ld (de),a
	ret

;;
@chargeLink:
	call ecom_updateCardinalAngleTowardTarget
	ld h,d
	ld l,Enemy.state
	ld (hl),$09
	ld l,Enemy.counter2
	ld (hl),150
	ld l,Enemy.speed
	ld (hl),SPEED_40
	ret

;;
@incSpeed:
	ld e,Enemy.counter2
	ld a,(de)
	and $03
	ret nz

	ld e,Enemy.speed
	ld a,(de)
	cp SPEED_180
	ret nc
	add SPEED_20
	ld (de),a
	ret

@xOscillationOffsets:
	.db $01 $ff $ff $01


; ==============================================================================
; ENEMYID_BUBBLE
; ==============================================================================
enemyCode15:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

	; Check if collided with Link; disable sword if so.
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	jr nz,@normalStatus

	ld a,WHISP_RING
	call cpActiveRing
	jr z,@normalStatus

	ld a,180
	ld (wSwordDisabledCounter),a

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8

@state_uninitialized:
	call getRandomNumber_noPreserveVars
	and $18
	ld e,Enemy.angle
	ld (de),a
	ld a,SPEED_c0
	call ecom_setSpeedAndState8
	jp objectSetVisible82


@state_stub:
	ret


@state8:
	call @checkCenteredOnTile
	call z,@chooseNewDirection
	call ecom_applyVelocityForSideviewEnemyNoHoles
	call z,@chooseNewDirection
	jp enemyAnimate

;;
@chooseNewDirection:
	ldbc $07,$18
	call ecom_randomBitwiseAndBCE
	or b
	ret nz
	ld e,Enemy.angle
	ld a,c
	ld (de),a
	ret

;;
; @param[out]	zflag	z if centered
@checkCenteredOnTile:
	ld h,d
	ld l,Enemy.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)
	or c
	and $07
	ret


; ==============================================================================
; ENEMYID_BEAMOS
; ==============================================================================
enemyCode16:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9


@state_uninitialized:
	call ecom_setSpeedAndState8AndVisible
	ld l,Enemy.counter1
	ld (hl),$05
	jp objectMakeTileSolid


@state_stub:
	ret


@state8:
	call @updateAngle
	call ecom_decCounter2
	ret nz
	jr @checkFireBeam


@state9:
	call ecom_decCounter1
	jr nz,++
	ld (hl),$05 ; [counter1] = 5
	inc l
	ld (hl),40  ; [counter2] = 40
	ld l,e
	dec (hl) ; [state] = 8
	ret
++
	; Play sound on 11th-to-last frame
	ld a,(hl)
	cp $0b
	ld a,SND_BEAM
	jp z,playSound
	ret nc

	; Spawn projectile every frame for 10 frames
	ld b,PARTID_BEAM
	call ecom_spawnProjectile
	ret nz

	ld e,Enemy.counter1
	ld a,(de)
	and $01
	ld l,Part.subid
	ld (hl),a
	ret

;;
; Increments angle every 5 frames.
@updateAngle:
	call ecom_decCounter1
	ret nz

	ld (hl),$05
	ld l,Enemy.angle
	ld a,(hl)
	inc a
	and $1f
	ld (hl),a

	ld hl,@angleToAnimation
	rst_addAToHl
	ld a,(hl)
	jp enemySetAnimation

@angleToAnimation:
	.db $00 $00 $01 $01 $01 $01 $01 $02
	.db $02 $02 $03 $03 $03 $03 $03 $04
	.db $04 $04 $05 $05 $05 $05 $05 $06
	.db $06 $06 $07 $07 $07 $07 $07 $00

;;
@checkFireBeam:
	call objectGetAngleTowardEnemyTarget
	ld h,d
	ld l,Enemy.angle
	sub (hl)
	inc a
	cp $02
	ret nc

	ld l,Enemy.counter1
	ld (hl),20

	; "Invincibility" is just for the glowing effect?
	ld l,Enemy.invincibilityCounter
	ld (hl),$14

	ld l,Enemy.state
	inc (hl) ; [state] = 9
	ret


; ==============================================================================
; ENEMYID_GHINI
;
; Variables:
;   var30/31: Target Y/X position for subid 2 only
; ==============================================================================
enemyCode17:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	jr c,@stunned
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ret

@stunned:
	ld e,Enemy.stunCounter
	ld a,(de)
	or a
	ret nz

	; Restore normal Z position when stun is over?
	ld e,Enemy.zh
	ld a,$fe
	ld (de),a
	ret

@dead:
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp z,enemyDie

	; For subid 1 only, kill all other ghinis with subid 1.
	ldhl FIRST_ENEMY_INDEX, Enemy.id
@nextGhini:
	ld a,(hl)
	cp ENEMYID_GHINI
	jr nz,++
	inc l
	ldd a,(hl)
	dec a
	jr nz,++
	call ecom_killObjectH
	ld l,Enemy.id
++
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@nextGhini
	jp enemyDie


@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw ghini_subid00
	.dw ghini_subid01
	.dw ghini_subid02


@state_uninitialized:
	ld a,SPEED_80
	call ecom_setSpeedAndState8
	ld l,Enemy.zh
	ld (hl),$fe

	; Check for subid 1 only
	ld a,b
	dec a
	jr nz,++

	ld l,Enemy.counter1
	ld (hl),60
	ld l,Enemy.angle
	ld (hl),$10
	ld l,Enemy.collisionType
	res 7,(hl)
++
	jp objectSetVisiblec1


@state_stub:
	ret


; Normal ghini.
ghini_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9

@state8:
	; Set random angle, counter1
	ldbc $18,$7f
	call ecom_randomBitwiseAndBCE
	ld h,d
	ld l,Enemy.counter1
	ld a,$30
	add c
	ld (hl),a
	ld l,Enemy.angle
	ld (hl),b

	ld l,Enemy.state
	inc (hl)
	jp ghini_updateAnimationFromAngle

@state9:
	call ghini_updateMovement
	call ecom_decCounter1
	jr nz,++

	; Go back to state 8 to decide a new direction.
	ld l,Enemy.state
	dec (hl)
++
	jp enemyAnimate


; This type takes a second to spawn in, and killing one ghini of subid 1 makes all other
; die too?
ghini_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


; Fading in.
@state8:
	call ecom_decCounter1
	jr z,++

	; Flicker visibility
	ld a,(hl)
	and $01
	ret nz
	jp ecom_flickerVisibility
++
	; Make visible, enable collisions
	ld l,Enemy.visible
	set 7,(hl)
	ld l,Enemy.collisionType
	set 7,(hl)
	call @gotoStateC
	jr @animate


; Just wandering around until counter1 reaches 0.
@state9:
	call ghini_updateMovement
	ld a,(wFrameCounter)
	rrca
	jr nc,@animate
	call ecom_decCounter1
	jr z,@incState

	call getRandomNumber_noPreserveVars
	cp $08
	jr nc,@animate

	; Rare chance (1/8192 per frame) of moving directly toward Link
	; Otherwise just takes a new random angle
	ldbc $1f,$1f
	call ecom_randomBitwiseAndBCE
	or b
	ld a,c
	call z,objectGetAngleTowardEnemyTarget
	ld e,Enemy.angle
	ld (de),a
	call ghini_updateAnimationFromAngle
	jr @animate

@incState:
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$00
	jr @animate


; Gradually decrease speed for 128 frames
@stateA:
	ld h,d
	ld l,Enemy.counter1
	inc (hl)
	ld a,(hl)
	cp $80
	jp c,ghini_updateMovementAndSetSpeedFromCounter1

	ld (hl),$80
	ld l,e
	inc (hl) ; [state] = $0b
@animate:
	jp enemyAnimate


; Stop moving for 128 frames
@stateB:
	call ecom_decCounter1
	jr nz,@animate


@gotoStateC:
	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.counter1
	ld (hl),$7f
	ld l,Enemy.speed
	ld (hl),SPEED_20
	jr @animate


; Gradually increase speed for 128 frames
@stateC:
	call ecom_decCounter1
	jp nz,ghini_updateMovementAndSetSpeedFromCounter1

	ld l,e
	ld (hl),$09
	call getRandomNumber_noPreserveVars
	ld e,Enemy.counter1
	and $7f
	add $7f
	ld (de),a
	jr @animate


ghini_subid02:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB


; Choose a random target position to move toward
@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_40
	ld l,Enemy.counter1
	ld (hl),$24
	call ghini_chooseTargetPosition


; Grudually increasing speed while moving toward target
@state9:
	call ecom_decCounter1
	jr nz,++

	ld l,e
	inc (hl) ; [state] = $0a
	jr @stateA
++
	ld a,(hl)
	and $07
	jr nz,@stateA
	ld l,Enemy.speed
	ld a,(hl)
	add SPEED_20
	ld (hl),a


; Moving toward target
@stateA:
	ld h,d
	ld l,Enemy.var30
	call ecom_readPositionVars

	; Check that the target is at least 2 pixels away in either direction.
	sub c
	inc a
	cp $03
	jr nc,@moveTowardTarget
	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	jr nc,@moveTowardTarget

	; We've reached the target; go to state $0b.
	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.counter1
	ld (hl),$1c
	jr @stateB

@moveTowardTarget:
	call ecom_moveTowardPosition
	call ghini_updateAnimationFromAngle
@animate:
	jp enemyAnimate


; Gradually decreasing speed
@stateB:
	call ecom_decCounter1
	jr z,@gotoState8

	ld a,(hl)
	and $07
	jr nz,++
	ld l,Enemy.speed
	ld a,(hl)
	sub SPEED_20
	ld (hl),a
++
	call objectApplySpeed
	jr @animate

@gotoState8:
	ld l,e
	ld (hl),$08
	jr @state8


;;
; Sets speed, where it's higher if counter1 is lower.
ghini_updateMovementAndSetSpeedFromCounter1:
	call ghini_updateMovement
	ld e,Enemy.counter1
	ld a,(de)
	ld b,$00
	cp $2a
	jr c,++
	inc b
	cp $54
	jr c,++
	inc b
++
	ld a,b
	ld hl,@speeds
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	jr ghini_subid02@animate

@speeds:
	.db SPEED_80, SPEED_40, SPEED_20

;;
ghini_updateMovement:
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary
	ret z

;;
ghini_updateAnimationFromAngle:
	ld h,d
	ld l,Enemy.angle
	ldd a,(hl)
	cp $10
	ld a,$01
	jr c,+
	dec a
+
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
; Sets var30/var31 to target position for subid 2.
;
; Target position seems to always be somewhere around the center of the room, even moreso
; for large rooms.
;
ghini_chooseTargetPosition:
	ldbc $70,$70
	call ecom_randomBitwiseAndBCE
	ld a,b
	sub $20
	jr nc,+
	xor a
+
	ld b,a

	; b = [wRoomEdgeY]/2 + b - $28
	ld hl,wRoomEdgeY
	ldi a,(hl)
	srl a
	add b
	sub $28
	ld b,a

	; c = [wRoomEdgeX]/2 + c - $38
	ld a,(hl)
	srl a
	add c
	sub $38
	ld c,a
	ld h,d

	ld l,Enemy.var30
	ld (hl),b
	inc l
	ld (hl),c
	ret


; ==============================================================================
; ENEMYID_BUZZBLOB
;
; Variables:
;   var30: Animation index ($02 if in cukeman form)
;   var31: "pressedAButton" variable (set to $01 when pressed A, only in cukeman form)
; ==============================================================================
enemyCode18:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	jp c,buzzblob_checkShowText
	jp z,enemyDie

	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards

	; Just hit by something

	ld h,d
	ld l,Enemy.var2a
	ld a,(hl)
	cp $80|ITEMCOLLISION_MYSTERY_SEED
	jr z,@becomeCukeman

	cp $80|ITEMCOLLISION_ELECTRIC_SHOCK
	ret nz

	; Link hit the buzzblob, go to state $0a
	ld l,Enemy.state
	ld (hl),$0a

	; Disable scent seeds
	ld l,Enemy.var3f
	res 4,(hl)

	ld l,Enemy.stunCounter
	ld (hl),$00
	ld l,Enemy.counter1
	ld (hl),60
	ld a,$01
	jp enemySetAnimation


; Buzzblob becomes cukeman when using mystery seed on it.
@becomeCukeman:
	ld l,Enemy.var30
	ld a,$02
	cp (hl)
	ret z
	ld (hl),a
	call enemySetAnimation
	ld e,Enemy.pressedAButton
	jp objectAddToAButtonSensitiveObjectList

@normalStatus:
	call buzzblob_checkShowText
	call ecom_checkScentSeedActive
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw buzzblob_state_uninitialized
	.dw buzzblob_state_stub
	.dw buzzblob_state_stub
	.dw buzzblob_state_stub
	.dw buzzblob_state_scentSeed
	.dw ecom_blownByGaleSeedState
	.dw buzzblob_state_stub
	.dw buzzblob_state_stub
	.dw buzzblob_state8
	.dw buzzblob_state9
	.dw buzzblob_stateA


buzzblob_state_uninitialized:
	ld a,SPEED_40
	call ecom_setSpeedAndState8AndVisible

	; Enable moving toward scent seeds, and...?
	ld l,Enemy.var3f
	ld a,(hl)
	or $30
	ld (hl),a

	ret


buzzblob_state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jr nz,++
	ld a,$08
	ld (de),a ; [state] = 8
	jr buzzblob_animate
++
	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a
	call ecom_applyVelocityForSideviewEnemy
	jp enemyAnimate


buzzblob_state_stub:
	ret


; Choosing a direction and duration to move
buzzblob_state8:
	ld a,$09
	ld (de),a ; [state] = 9

	; Set random angle and counter1
	ldbc $1c,$30
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.counter1
	ld a,$30
	add c
	ld (de),a
	ld e,Enemy.angle
	ld a,b
	ld (de),a
	jr buzzblob_animate


; Moving in some direction for a certain amount of time
buzzblob_state9:
	call ecom_decCounter1
	jr z,buzzblob_chooseNewDirection
	call ecom_bounceOffWallsAndHoles
	call objectApplySpeed
buzzblob_animate:
	jp enemyAnimate


; "Shocking Link" state
buzzblob_stateA:
	call ecom_decCounter1
	jr nz,buzzblob_animate
	ld e,Enemy.var30
	ld a,(de)
	call enemySetAnimation

buzzblob_chooseNewDirection:
	ld h,d
	ld l,Enemy.state
	ld (hl),$08 ; Will choose new direction in state 8

	; Enable scent seeds
	ld l,Enemy.var3f
	set 4,(hl)

	ld l,Enemy.collisionType
	set 7,(hl)
	jr buzzblob_animate

;;
buzzblob_checkShowText:
	ld e,Enemy.var31
	ld a,(de)
	or a
	ret z

	xor a
	ld (de),a
	call getRandomNumber_noPreserveVars
	and $07
	add <TX_2f1e
	ld c,a
	ld b,>TX_2f00
	jp showText


; ==============================================================================
; ENEMYID_SAND_CRAB
; ==============================================================================
enemyCode1a:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockback
	ret
@normalStatus:
	call ecom_checkScentSeedActive
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_scentSeed
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9


@state_uninitialized:
	ld h,d
	ld l,Enemy.var3f
	set 4,(hl)
	jp ecom_setSpeedAndState8AndVisible


@state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jr nz,++
	ld a,$08
	ld (de),a ; [state] = 8
	jr @animate
++
	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a

	; Faster when moving left/right instead of up/down
	bit 3,a
	ld a,SPEED_40
	jr z,+
	ld a,SPEED_100
+
	ld e,Enemy.speed
	ld (de),a

	call ecom_applyVelocityForSideviewEnemy
	jr @animate


@state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @@substate1
	.dw @@substate2
	.dw ecom_fallToGroundAndSetState8


@@substate1:
@@substate2:
	ret


@state_stub:
	ret



; Choose random angle to move in
@state8:
	ld a,$09
	ld (de),a ; [state] = 9

	; Get random angle & duration for walk
	ldbc $18,$30
	call ecom_randomBitwiseAndBCE
	ld e,$86
	ld a,$30
	add c
	ld (de),a

	; Faster when moving left/right
	bit 3,b
	ld a,SPEED_40
	jr z,+
	ld a,SPEED_100
+
	ld e,$90
	ld (de),a

	ld e,Enemy.angle
	ld a,b
	ld (de),a
	jr @animate


; Moving in direction for [counter1] frames
@state9:
	call ecom_decCounter1
	jr z,++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,@animate
++
	ld e,Enemy.state
	ld a,$08
	ld (de),a
@animate:
	jp enemyAnimate


; ==============================================================================
; ENEMYID_SPINY_BEETLE
;
; Variables:
;   var03: $80 when stationary, $81 when charging Link. Child object (bush or rock) reads
;          this to determine relative Z position. Bit 7 is set to indicate it's grabbable.
;   var3b: Probably unused?
; ==============================================================================
enemyCode1b:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards

	; ENEMYSTATUS_JUST_HIT
	; If Link just hit the enemy, start moving
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret nz

	ld e,Enemy.state
	ld a,(de)
	cp $08
	jr nz,@normalStatus
	call ecom_updateCardinalAngleTowardTarget
	jp @chargeAtLink

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_stub
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB


@state_uninitialized:
	; Spawn the bush or rock to hide under
	ld b,ENEMYID_BUSH_OR_ROCK
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz

	ld e,l
	ld a,(de)
	ld (hl),a ; [child.subid] = [this.subid]

	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld e,Enemy.relatedObj2
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	call objectCopyPosition

	ld a,SPEED_e0
	call ecom_setSpeedAndState8

	ld l,Enemy.collisionRadiusY
	ld a,$03
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.var03
	ld (hl),$80

	; Change collisionType only for those hiding under rocks?
	dec l
	ld a,(hl)
	cp $02
	ret c

	; Borrow beamos collisions (nothing can kill it until rock is removed)
	ld l,Enemy.collisionType
	ld (hl),$80|ENEMYID_BEAMOS
	ret


@state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @@substate1
	.dw @@substate2
	.dw ecom_fallToGroundAndSetState8

@@substate1:
@@substate2:
	ret


@state_stub:
	ret


; Waiting for Link to move close enough.
@state8:
	call @checkBushOrRockGone
	ret z
	call ecom_decCounter2
	ret nz

	ld b,$0c
	call objectCheckCenteredWithLink
	ret nc

	call ecom_updateCardinalAngleTowardTarget
	or a
	ret z ; For some reason he never moves up?

	ld a,$01
	call ecom_getTopDownAdjacentWallsBitset
	ret nz


@chargeAtLink:
	call ecom_incState ; [state] = 9
	ld l,Enemy.counter1
	ld (hl),$38
	ld l,Enemy.var03
	ld (hl),$81
	jp objectSetVisiblec3


; Moving toward Link
@state9:
	call @checkBushOrRockGone
	ret z
	call ecom_decCounter1
	jr z,++
	call ecom_applyVelocityForTopDownEnemyNoHoles
	jr nz,@animate
++
	ld h,d
	ld l,Enemy.counter2
	ld (hl),30

	ld l,Enemy.state
	dec (hl)

	ld l,Enemy.var03
	ld (hl),$80
	ld l,Enemy.var3b
	ld (hl),$00

	jp objectSetInvisible


; Just lost protection (bush or rock).
@stateA:
	call ecom_decCounter1
	jr nz,@animate
	inc (hl)
	ld l,e
	inc (hl)
	jr @animate


; Moving around randomly after losing protection.
@stateB:
	call ecom_decCounter1
	jr nz,++

	ld (hl),40
	call getRandomNumber_noPreserveVars
	and $1c
	ld e,Enemy.angle
	ld (de),a
	jr @animate
++
	call ecom_applyVelocityForSideviewEnemyNoHoles
@animate:
	jp enemyAnimate


;;
; Checks if the object we're hiding under is gone; if so, updates collisionType,
; collisiosRadius, visibility, and sets state to $0a
;
; @param[out]	zflag	z if the object it's hiding under is gone
@checkBushOrRockGone:
	ld e,Enemy.relatedObj2+1
	ld a,(de)
	or a
	ret nz

	ld h,d
	ld l,Enemy.state
	ld (hl),$0a
	ld l,Enemy.counter1
	ld (hl),60

	; Restore normal collisions
	ld l,Enemy.collisionType
	ld (hl),$80|ENEMYID_SPINY_BEETLE

	ld l,Enemy.collisionRadiusY
	ld a,$06
	ldi (hl),a
	ld (hl),a
	call objectSetVisiblec3
	xor a
	ret

; ==============================================================================
; ENEMYID_ARMOS
;
; Variables:
;   subid: If bit 7 is set, it's a real armos; otherwise it's an armos spawner.
;   var31: The initial position of the armos (subid 1 only)
; ==============================================================================
enemyCode1d:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,armos_dead

	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards

	; ENEMYSTATUS_JUST_HIT

	; For subid $80, if Link touches this position, activate the armos.
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret nz

	ld e,Enemy.subid
	ld a,(de)
	cp $80
	jr nz,@normalStatus

	ld h,d
	ld l,Enemy.state
	ld a,(hl)
	cp $09
	jr nc,@normalStatus
	ld (hl),$09
	ret

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw armos_uninitialized
	.dw armos_state1
	.dw armos_state_stub
	.dw armos_state_switchHook
	.dw armos_state_stub
	.dw armos_state_stub
	.dw armos_state_stub
	.dw armos_state_stub

@normalState:
	res 7,b
	ld a,b
	rst_jumpTable
	.dw armos_subid00
	.dw armos_subid01


armos_uninitialized:
	ld a,b
	bit 7,a
	jr z,@gotoState1

	add a
	ld hl,@oamFlagsAndSpeeds
	rst_addAToHl
	ld e,Enemy.oamFlags
	ldi a,(hl)
	ld (de),a
	dec e
	ld (de),a
	ld a,(hl)
	call ecom_setSpeedAndState8

	; Subid 1 gets more health
	ld l,Enemy.subid
	bit 0,(hl)
	jr z,+
	ld l,Enemy.health
	inc (hl)
+
	; Effectively disable collisions
	ld l,Enemy.collisionType
	ld (hl),$80|ENEMYID_PODOBOO
	ret

@gotoState1:
	ld a,$01
	ld (de),a
	ret

@oamFlagsAndSpeeds:
	.db $05, SPEED_80 ; subid 0
	.db $04, SPEED_c0 ; subid 1


; For subid where bit 7 isn't set; spawn armos at all positions where their tiles are.
; (Enemy.yh currently contains the tile to replace, Enemy.xh is the new tile it becomes.)
armos_state1:
	ld e,Enemy.yh
	ld a,(de)
	ld b,a
	ld hl,wRoomLayout
	ld c,LARGE_ROOM_HEIGHT<<4
--
	ld a,(hl)
	cp b
	call z,armos_spawnArmosAtPosition
	inc l
	dec c
	jr nz,--

	call armos_clearKilledArmosBuffer
	call decNumEnemies
	jp enemyDelete


armos_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw @substate3


@substate1:
@substate2:
	ret

@substate3:
	ld b,$0b
	jp ecom_fallToGroundAndSetState


armos_state_stub:
	ret


armos_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw armos_subid00_state8
	.dw armos_state9
	.dw armos_subid00_stateA
	.dw armos_subid00_stateB
	.dw armos_subid00_stateC

; Waiting for Link to touch the statue (or for "$cca2" trigger?)
armos_subid00_state8:
	ld a,(wcca2)
	or a
	ret z
	ld a,$09
	ld (de),a
	ret


; The statue was just activated
armos_state9:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0a
	ld l,Enemy.counter1
	ld (hl),60
	ld l,Enemy.yh
	inc (hl)
	inc (hl)
	jp objectSetVisible82


; Flickering until it starts moving
armos_subid00_stateA:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld a,ENEMYCOLLISION_ACTIVE_RED_ARMOS

;;
; @param	a	EnemyCollisionMode
armos_beginMoving:
	ld l,e
	inc (hl) ; [state] = $0b

	; Enable normal collisions
	ld l,Enemy.collisionType
	ld (hl),$80|ENEMYID_ARMOS

	inc l
	ldi (hl),a ; Set enemyCollisionMode

	; Set collisionRadiusY/X
	ld a,$06
	ldi (hl),a
	ld (hl),a

	call armos_replaceTileUnderSelf
	jp objectSetVisiblec2


; Choose a direction to move
armos_subid00_stateB:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0c

	ld l,Enemy.counter1
	ld (hl),61
	call ecom_setRandomCardinalAngle


; Moving in some direction for [counter1] frames
armos_subid00_stateC:
	call ecom_decCounter1
	call nz,ecom_applyVelocityForTopDownEnemyNoHoles
	jr nz,++
	ld e,Enemy.state
	ld a,$0b
	ld (de),a
++
	jp enemyAnimate


armos_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw armos_subid01_state8
	.dw armos_state9
	.dw armos_subid01_stateA
	.dw armos_subid02_stateB
	.dw armos_subid03_stateC


; Waiting for Link to approach the statue
armos_subid01_state8:
	call armos_subid00_state8
	ret nz

	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	add $18
	cp $31
	ret nc

	ld b,(hl)
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $18
	cp $31
	ret nc

	; Link has gotten close enough; activate the armos.
	ld a,(hl)
	and $f0
	swap a
	ld c,a
	ld a,b
	and $f0
	or c
	ld l,Enemy.var31
	ld (hl),a

	ld l,e
	inc (hl) ; [state] = 9
	ret


; Flickering until it starts moving
armos_subid01_stateA:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld a,ENEMYCOLLISION_ACTIVE_BLUE_ARMOS
	jp armos_beginMoving


; Choose random new direction & amount of time to move in that direction
armos_subid02_stateB:
	ld a,$0c
	ld (de),a ; [state] = $0c

	; Get counter1
	ldbc $03,$03
	call ecom_randomBitwiseAndBCE
	ld a,b
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a

	; 1 in 4 chance of moving directly toward Link
	ld a,c
	or a
	jp z,ecom_updateCardinalAngleTowardTarget
	jp ecom_setRandomCardinalAngle

@counter1Vals:
	.db 30, 45, 60, 75


; Moving in some direction for [counter1] frames
armos_subid03_stateC:
	call ecom_decCounter1
	jr z,++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr z,++
	jp enemyAnimate
++
	ld e,Enemy.state
	ld a,$0b
	ld (de),a
	ret

;;
; @param	l	Position to spawn at
armos_spawnArmosAtPosition:
	push bc
	push hl
	ld c,l

	ld b,ENEMYID_ARMOS
	call ecom_spawnEnemyWithSubid01
	jr nz,@ret

	ld e,l
	ld a,(de)
	set 7,a
	ld (hl),a ; [child.subid] = [this.subid]|$80

	; [child.var30] = [this.xh] = tile to replace underneath new armos
	ld e,Enemy.xh
	ld l,Enemy.var30
	ld a,(de)
	ld (hl),a

	; Take short-form position in 'c', write to child's position
	ld l,e
	ld a,c
	and $0f
	swap a
	add $08
	ldd (hl),a
	dec l
	ld a,c
	and $f0
	add $06
	ld (hl),a
@ret:
	pop hl
	pop bc
	ret

;;
armos_dead:
	ld e,Enemy.subid
	ld a,(de)
	rrca
	jp nc,enemyDie

	; Subid 1 only: record the initial position of the armos that was killed.
	ld e,Enemy.var31
	ld a,(de)
	ld b,a
	ld hl,wTmpcfc0.armosStatue.killedArmosPositions-1
--
	inc l
	ld a,(hl)
	or a
	jr nz,--
	ld (hl),b
	jp enemyDie

;;
armos_clearKilledArmosBuffer:
	ld hl,wTmpcfc0.armosStatue.killedArmosPositions
	xor a
	ld b,$04
--
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	dec b
	jr nz,--
	ret

;;
; Replace the tile underneath the armos with [var30].
armos_replaceTileUnderSelf:
	call objectGetTileAtPosition
	ld c,l
	ld e,Enemy.var30
	ld a,(de)
	jp setTile


; ==============================================================================
; ENEMYID_PIRANHA
;
; Variables:
;   zh: Equals 2 when underwater
;   var30: Current animation index
; ==============================================================================
enemyCode1e:
	jr z,@normalStatus
	sub $03
	jr c,@stunned
	jp z,enemyDie
	dec a
	ret z

	; ENEMYSTATUS_KNOCKBACK

	ld e,Enemy.speed
	ld a,SPEED_200
	ld (de),a
	call fish_getAdjacentWallsBitsetForKnockback

	ld e,Enemy.knockbackAngle
	call ecom_applyVelocityGivenAdjacentWalls

	ld e,Enemy.speed
	ld a,SPEED_c0
	ld (de),a
	ret

@stunned:
	ld e,Enemy.zh
	ld a,(de)
	cp $02
	ret z
	or a
	ret nz
	jp fish_enterWater

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw fish_state_uninitialized
	.dw fish_state_stub
	.dw fish_state_stub
	.dw fish_state_stub
	.dw fish_state_stub
	.dw ecom_blownByGaleSeedState
	.dw fish_state_stub
	.dw fish_state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw fish_subid00
	.dw fish_subid01


fish_state_uninitialized:
	ld a,SPEED_80
	call ecom_setSpeedAndState8
	call objectSetVisible83

	ld l,Enemy.zh
	ld (hl),$02
	ld l,Enemy.angle
	ld (hl),ANGLE_RIGHT

	call fish_setRandomCounter1
	jp fish_updateAnimationFromAngle


fish_state_stub:
	ret


fish_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9


; Moving below water.
@state8:
	ld a,(wScentSeedActive)
	or a
	jr nz,++
	call ecom_decCounter1
	jr z,@leapOutOfWater
++
	call fish_updatePosition
	jp fish_checkReverseAngle

@leapOutOfWater:
	ld l,e
	inc (hl)
	ld l,Enemy.enemyCollisionMode
.ifdef ROM_AGES
	ld (hl),ENEMYCOLLISION_SWITCHHOOK_DAMAGE_ENEMY
.else
	ld (hl),ENEMYCOLLISION_STANDARD_ENEMY
.endif
	ld l,Enemy.zh
	ld (hl),$00

	ld l,Enemy.speedZ
	ld a,<(-$180)
	ldi (hl),a
	ld (hl),>(-$180)

	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ld b,INTERACID_SPLASH
	call objectCreateInteractionWithSubid00
	call objectSetVisiblec1
	ld b,$00
	jp fish_setAnimation


; Leaping outside the water.
@state9:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	jr z,fish_enterWater

	ld l,Enemy.speedZ
	ld a,(hl)
	or a
	jr nz,++
	inc l
	ld a,(hl)
	or a
	jr nz,++
	ld b,$01
	call fish_setAnimation
++
	jp fish_updatePosition


;;
fish_enterWater:
	ld h,d
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO
	ld l,Enemy.zh
	ld (hl),$02

	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.speed
	ld (hl),SPEED_80

	call fish_setRandomCounter1
	ld b,INTERACID_SPLASH
	call objectCreateInteractionWithSubid00
	call objectSetVisible83
	jp fish_updateAnimationFromAngle



fish_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8

@state8:
	ret

;;
; @param	cflag	c if we were able to move
fish_checkReverseAngle:
	ret c
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	ld (de),a

;;
fish_updateAnimationFromAngle:
	ld e,Enemy.angle
	ld a,(de)
	swap a
	rlca
	ld hl,@animations
	rst_addAToHl
	ld a,(hl)
	ld h,d
	ld l,Enemy.var30
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

@animations:
	.db $02 $01 $02 $00

;;
; Sets animation (3 or 5 is added to value passed if we're moving right or left)
;
; @param	b	Value to add to animation index
fish_setAnimation:
	ld e,Enemy.angle
	ld a,(de)
	swap a
	and $01
	ld a,$03
	jr nz,+
	ld a,$05
+
	add b
	ld h,d
	ld l,Enemy.var30
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation


;;
; @param[out]	cflag	c if we were able to move (tile in front of us is traversable)
fish_updatePosition:
	ld e,Enemy.angle
	ld a,(de)
	rrca
	rrca
	ld hl,@directionOffsets
	rst_addAToHl

	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	and $f0
	ld c,a

	inc hl
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	and $f0
	swap a

	or c
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	sub TILEINDEX_PUDDLE
	cp TILEINDEX_FD-TILEINDEX_PUDDLE+1
	ret nc
	call objectApplySpeed
	scf
	ret

@directionOffsets:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

;;
fish_setRandomCounter1:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret

@counter1Vals:
	.db $40 $50 $60 $70

;;
; Gets the "adjacent walls bitset" for the fish; since this swims, water is traversable,
; everything else is not.
;
; This is identical to "waterTektite_getAdjacentWallsBitsetGivenAngle".
;
; @param[out]	hFF8B	Bitset of adjacent walls
fish_getAdjacentWallsBitsetForKnockback:
	ld e,Enemy.knockbackAngle
	ld a,(de)
	call ecom_getAdjacentWallTableOffset

	ld h,d
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	ld hl,ecom_sideviewAdjacentWallOffsetTable
	rst_addAToHl

	ld a,$10
	ldh (<hFF8B),a
	ld d,>wRoomLayout
---
	ldi a,(hl)
	add b
	ld b,a
	and $f0
	ld e,a
	ldi a,(hl)
	add c
	ld c,a
	and $f0
	swap a
	or e
	ld e,a
	ld a,(de)
	sub TILEINDEX_PUDDLE
	cp TILEINDEX_FD-TILEINDEX_PUDDLE+1
	ldh a,(<hFF8B)
	rla
	ldh (<hFF8B),a
	jr nc,---

	xor $0f
	ldh (<hFF8B),a
	ldh a,(<hActiveObject)
	ld d,a
	ret


; ==============================================================================
; ENEMYID_POLS_VOICE
;
; Variables:
;   var30: gravity
; ==============================================================================
enemyCode23:
	call ecom_checkHazardsNoAnimationForHoles
	call polsVoice_checkLinkPlayingInstrument
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw polsVoice_state_uninitialized
	.dw polsVoice_state_stub
	.dw polsVoice_state_stub
	.dw polsVoice_state_stub
	.dw polsVoice_state_stub
	.dw ecom_blownByGaleSeedState
	.dw polsVoice_state_stub
	.dw polsVoice_state_stub
	.dw polsVoice_state8
	.dw polsVoice_state9

polsVoice_state_uninitialized:
	; Note: a is uninitialized; arbitrary speed
	call ecom_setSpeedAndState8

	call getRandomNumber_noPreserveVars
	ld e,Enemy.counter1
	and $3f
	inc a
	ld (de),a
	jr polsVoice_setLandedAnimation


polsVoice_state_stub:
	ret


polsVoice_state8:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state] = 9

	; Randomly read in 3 speed values: speedZ, gravity (var30), and speed.
	ld bc,$0f1c
	call ecom_randomBitwiseAndBCE
	or b
	ld hl,@jumpSpeeds1
	jr nz,+
	ld hl,@jumpSpeeds2
+
	ld e,Enemy.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	; [var30] = gravity
	ld e,Enemy.var30
	ldi a,(hl)
	ld (de),a

	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	cp SPEED_80
	jr z,++

	; For high speed jump, target Link directly instead of using a random angle
	call objectGetAngleTowardEnemyTarget
	add $02
	and $1c
	ld c,a
++
	ld e,Enemy.angle
	ld a,c
	ld (de),a
	xor a
	call enemySetAnimation
	jp objectSetVisiblec1


; Word: Initial speedZ
; Byte: gravity
; Byte: speed
@jumpSpeeds1:
	dwbb -$128, $0c, SPEED_80
@jumpSpeeds2:
	dwbb -$180, $0c, SPEED_c0


polsVoice_state9:
	call ecom_applyVelocityForSideviewEnemyNoHoles
	ld e,Enemy.var30
	ld a,(de)
	ld c,a
	call objectUpdateSpeedZ_paramC
	ret nz

	; Landed
	ld h,d
	ld l,Enemy.state
	dec (hl) ; [state] = 8
	ld l,Enemy.counter1
	ld (hl),$20

polsVoice_setLandedAnimation:
	ld a,$01
	call enemySetAnimation
	jp objectSetVisiblec2

;;
; @param	a	Enemy status
; @param[out]	a	Updated enemy status
polsVoice_checkLinkPlayingInstrument:
	ld b,a
	ld a,(wLinkPlayingInstrument)
	or a
	jr z,+
	ld b,ENEMYSTATUS_NO_HEALTH
+
	ld a,b
	or a
	ret


; ==============================================================================
; ENEMYID_LIKE_LIKE
;
; Variables:
;   relatedObj1: Pointer to the like-like spawner (subid 1), if one exists.
;   var30: Number of like-likes on-screen (for subid 1)
; ==============================================================================
enemyCode24:
	call likelike_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead

	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret nz

	; Just collided with Link. omnomnom
	ld h,d
	ld l,Enemy.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)

	; Don't eat him if Link would (somehow) get stuck in a wall
	callab bank5.checkPositionSurroundedByWalls

	rl b
	jp c,likelike_releaseLink

	ld e,Enemy.subid
	ld a,(de)
	or a
	ld a,$0b
	jr z,+
	inc a
+
	ld h,d
	ld l,Enemy.state
	ldi (hl),a
	inc l
	ld (hl),$00 ; [counter1] = 0
	inc l
	ld (hl),90  ; [counter2] = 90

	ld l,Enemy.collisionType
	res 7,(hl)

	; Link copies Likelike's position
	ld hl,w1Link
	call objectCopyPosition

	ld l,<w1Link.collisionType
	res 7,(hl)

	ld a,$01
	call enemySetAnimation
	jp objectSetVisiblec1


@dead:
	; Decrement spawner's counter
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	or a
	jp z,enemyDie

	ld h,a
	ld l,Enemy.var30
	dec (hl)
	jp enemyDie


@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw likelike_state_uninitialized
	.dw likelike_state_stub
	.dw likelike_state_stub
	.dw likelike_state_switchHook
	.dw likelike_state_stub
	.dw likelike_state_galeSeed
	.dw likelike_state_stub
	.dw likelike_state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw likelike_subid00
	.dw likelike_subid01
	.dw likelike_subid02
	.dw likelike_subid03


likelike_state_uninitialized:
	bit 0,b
	call z,objectSetVisiblec2
	ld a,SPEED_40
	jp ecom_setSpeedAndState8


likelike_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret

@substate3:
	ld e,Enemy.subid
	ld a,(de)
	ld hl,@defaultStates
	rst_addAToHl
	ld b,(hl)
	jp ecom_fallToGroundAndSetState

@defaultStates:
	.db $09 $08 $0a $0a


likelike_state_galeSeed:
	call ecom_galeSeedEffect
	ret c

	; Decrement spawner's counter
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	or a
	jr z,++
	ld h,a
	ld l,Enemy.var30
	dec (hl)
++
	call decNumEnemies
	jp enemyDelete


likelike_state_stub:
	ret


likelike_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw likelike_subid00_state8
	.dw likelike_state9
	.dw likelike_stateA
	.dw likelike_stateB
	.dw likelike_stateC


; Initialization
likelike_subid00_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]++
	ld l,Enemy.collisionType
	set 7,(hl)


; Choosing a new direction & duration
likelike_state9:
	ld h,d
	ld l,e
	inc (hl) ; [state]++

	ldbc $18,$30
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,b
	ld (de),a
	ld e,Enemy.counter1
	ld a,$38
	add c
	ld (de),a
	jr likelike_animate


; Moving in some direction for [counter1] frames
likelike_stateA:
	call ecom_decCounter1
	jr nz,@move

@newDirection:
	ld h,d
	ld l,Enemy.state
	dec (hl)
	jr likelike_animate

@move:
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr z,@newDirection

likelike_animate:
	jp enemyAnimate


; Eating Link
likelike_stateB:
	call ecom_decCounter2
	jr z,@releaseLink

	; Mashing 19 buttons before being released prevents like-like from eating shield
	ld a,(wGameKeysJustPressed)
	or a
	jr z,likelike_animate
	dec l
	inc (hl) ; [counter1]++
	jr likelike_animate

@releaseLink:
	ld (hl),60

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld a,(hl)
	cp 19
	jr nc,++
	ld a,TREASURE_SHIELD
	call checkTreasureObtained
	jr nc,++

	ld a,TREASURE_SHIELD
	call loseTreasure
	ld bc,TX_510b
	call showText
++
	call getRandomNumber_noPreserveVars
	and $18
	ld e,Enemy.angle
	ld (de),a
	call objectSetVisiblec2

;;
likelike_releaseLink:
	; Release link from LINK_STATE_GRABBED
	ld hl,w1Link.substate
	ld (hl),$04

	ld l,<w1Link.collisionType
	set 7,(hl)
	xor a
	jp enemySetAnimation


; Cooldown after eating Link; won't eat him again for another 60 frames
likelike_stateC:
	call ecom_decCounter2
	jr nz,++

	ld l,e
	ld a,(hl)
	sub $03
	ld (hl),a ; [state] -= 3

	ld l,Enemy.collisionType
	set 7,(hl)
	jr likelike_animate
++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,likelike_animate

	; Ran into wall
	call getRandomNumber_noPreserveVars
	and $18
	ld e,Enemy.angle
	ld (de),a
	jr likelike_animate


; Like-like spawner.
likelike_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA

@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.counter1
	inc (hl)
	jp likelike_findAllLikelikesWithSubid0


; Wait for Link to move past the screen edge
@state9:
	; Y from $10-$6f
	ld a,(w1Link.yh)
	sub $10
	cp (SMALL_ROOM_HEIGHT<<4)-$20
	ret nc

	; X from $10-$8f
	ld a,(w1Link.xh)
	sub $10
	cp (SMALL_ROOM_WIDTH<<4)-$20
	ret nc

	ld a,$0a
	ld (de),a ; [state] = $0a

; Check to spawn more like-likes.
@stateA:
	call ecom_decCounter1
	ret nz

	inc (hl) ; [counter1] = 1

	; No more than 6 like-likes at once
	ld l,Enemy.var30
	ld a,(hl)
	cp $06
	ret nc

	call getRandomNumber_noPreserveVars
	and $02
	ld c,a
	ld a,(wActiveRoom)
	cp $50
	jr z,@fromTop
	cp $40
	jr z,@fromBottom

	set 2,c
	cp $51
	ret nz

@fromBottom:
	ld e,$02
	call likelike_spawn
	ret nz
	call likelike_setChildSpawnPosition
	jr ++
@fromTop:
	ld e,$03
	call likelike_spawn
	ret nz
++
	; Successfully spawned a like-like.
	ld h,d
	ld l,Enemy.var30
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),120
	ret


likelike_subid02:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw likelike_state9 ; States actually offset by 1 compared to subid 0...
	.dw likelike_stateA
	.dw likelike_stateB
	.dw likelike_stateC

; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	; Set angle to ANGLE_UP (default) if spawning from bottom, or ANGLE_RIGHT if
	; spawning from left of screen
	ld l,Enemy.yh
	ld a,(hl)
	cp (SMALL_ROOM_HEIGHT<<4)+8
	jr z,+
	ld l,Enemy.angle
	ld (hl),ANGLE_RIGHT
+
	ld l,Enemy.counter1
	ld (hl),45
	ret

; Move forward until we're well into the screen boundary
@state9:
	call ecom_decCounter1
	jr z,++
	call objectApplySpeed
	jr likelike_animate2
++
	ld l,e
	inc (hl)
	ld l,Enemy.collisionType
	set 7,(hl)

likelike_animate2:
	jp enemyAnimate


likelike_subid03:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw likelike_state9 ; States actually offset by 1 compared to subid 0...
	.dw likelike_stateA
	.dw @stateB
	.dw likelike_stateC


; Initialization (spawning above the screen).
@state8:
	call likelike_chooseRandomPosition
	ret nz
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.speedZ+1
	ld (hl),$02
	jp objectSetVisiblec1


; Falling to the ground.
@state9:
	ld c,$08
	call objectUpdateSpeedZ_paramC
	jr nz,likelike_animate2

	; Hit the ground.
	ld l,Enemy.state
	inc (hl)
	call objectSetVisiblec2
	jr likelike_animate2


; Eating Link. Since this falls from the sky, this has extra height-related code.
@stateB:
	ld c,$08
	call objectUpdateSpeedZ_paramC
	ld l,Enemy.zh
	ld a,(hl)
	ld (w1Link.zh),a
	jp likelike_stateB

;;
; Spawner (subid 1) calls this to make new like-likes where their relatedObj1 references
; the spawner.
;
; @param	e	Subid of like-like to spwan
likelike_spawn:
	ld b,ENEMYID_LIKE_LIKE
	call ecom_spawnEnemyWithSubid01
	ret nz
	ld (hl),e
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d
	xor a
	ret

;;
; @param	c	Index of spawn position to use
likelike_setChildSpawnPosition:
	push hl
	ld a,c
	ld hl,@spawnPositions
	rst_addAToHl
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	pop hl
	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c
	ret

@spawnPositions:
	.db $88 $48
	.db $88 $58
	.db $38 $f8
	.db $48 $f8

;;
; Searches for all existing like-likes with subid 0, sets their relatedObj1 to point to
; this object (the spawner), and stores the current like-like count in var30.
likelike_findAllLikelikesWithSubid0:
	ldhl FIRST_ENEMY_INDEX, Enemy.id
	ld c,$00
@nextEnemy:
	; Find like-like with subid 0
	ld a,(hl)
	cp ENEMYID_LIKE_LIKE
	jr nz,++
	inc l
	ldd a,(hl)
	or a
	jr nz,++

	; Set its relatedObj1 to this
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d
	ld l,Enemy.id
	inc c
++
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	ld e,Enemy.var30
	ld a,c
	ld (de),a
	ret

;;
; Choose a random position to fall from the sky. If a good position is chosen, the
; Z position is also set to be above the screen.
;
; @param[out]	zflag	z if chose valid position
likelike_chooseRandomPosition:
	call getRandomNumber_noPreserveVars
	and $77
	inc a
	ld c,a
	ld b,>wRoomCollisions
	ld a,(bc)
	or a
	ret nz
	call objectSetShortPosition
	ld c,$08
	call ecom_setZAboveScreen
	xor a
	ret


;;
likelike_checkHazards:
	push af
	ld a,(w1Link.state)
	cp LINK_STATE_GRABBED
	jr nz,++

	ld e,Enemy.zh
	ld a,(de)
	rlca
	jr c,++
	ld bc,$0500
	call objectGetRelativeTile
	ld hl,hazardCollisionTable
	call lookupCollisionTable
	call c,likelike_releaseLink
++
	pop af
	jp ecom_checkHazards


; ==============================================================================
; ENEMYID_GOPONGA_FLOWER
; ==============================================================================
enemyCode25:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

	ld e,Enemy.health
	ld a,(de)
	or a
	jp z,ecom_updateKnockback

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9


@state_uninitialized:
	ld h,d
	ld l,Enemy.counter1
	ld (hl),90
	ld l,Enemy.subid
	ld a,(hl)
	or a
	jr z,++

	ld l,Enemy.oamTileIndexBase
	ld a,(hl)
	add $04
	ld (hl),a
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BIG_GOPONGA_FLOWER
++
	call ecom_setSpeedAndState8
	jp objectSetVisible83


@state_stub:
	ret


; Closed
@state8:
	call ecom_decCounter1
	ret nz
	ld (hl),60
	ld l,e
	inc (hl)
	ld a,$01
	jp enemySetAnimation


; Open, about to shoot a projectile
@state9:
	call ecom_decCounter1
	jr z,@closeFlower

	ld a,(hl)
	cp 40
	ret nz

	ld e,Enemy.subid
	ld a,(de)
	dec a
	call nz,getRandomNumber_noPreserveVars
	and $03
	ret nz
	ld b,PARTID_GOPONGA_PROJECTILE
	jp ecom_spawnProjectile

@closeFlower:
	ld e,Enemy.subid
	ld a,(de)
	ld bc,@counter1Vals
	call addAToBc
	ld a,(bc)
	ld (hl),a

	ld l,Enemy.state
	dec (hl)

	xor a
	jp enemySetAnimation


@counter1Vals: ; counter1 values per subid
	.db $78 $b4


; ==============================================================================
; ENEMYID_DEKU_SCRUB
;
; Variables:
;   var03: Read by ENEMYID_BUSH_OR_ROCK to control Z-offset
;   var30: Starts at 2, gets decremented each time one of the scrub's bullets hits itself.
;   var31: Index of ENEMYID_BUSH_OR_ROCK
;   var32: "pressedAButton" variable (nonzero when player presses A)
;   var33: Former var03 value (low byte of text index, TX_45XX)
; ==============================================================================
enemyCode27:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jr nz,@normalStatus

	; ENEMYSTATUS_JUST_HIT

	; Check var30, which is decremented by PARTID_DEKU_SCRUB_PROJECTILE each time it
	; hits the deku scrub.
	ld e,Enemy.var30
	ld a,(de)
	or a
	ret nz

	; We've been hit twice, go to state $0c and delete the bush.
	ld h,d
	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.var31
	ld h,(hl)
	jp ecom_killObjectH

@dead:
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp nz,enemyDie

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw dekuScrub_state_uninitialized
	.dw dekuScrub_state_stub
	.dw dekuScrub_state_stub
	.dw dekuScrub_state_stub
	.dw dekuScrub_state_stub
	.dw dekuScrub_state_stub
	.dw dekuScrub_state_stub
	.dw dekuScrub_state_stub
	.dw dekuScrub_state8
	.dw dekuScrub_state9
	.dw dekuScrub_stateA
	.dw dekuScrub_stateB
	.dw dekuScrub_stateC
	.dw dekuScrub_stateD


dekuScrub_state_uninitialized:
	call dekuScrub_spawnBush
	ret nz

	call objectMakeTileSolid
	ld h,>wRoomLayout
	ld (hl),$00

	; The value of 'a' here depends on "objectMakeTileSolid".
	; It should be 0 if the enemy spawned on an empty space.
	; In any case it shouldn't matter since this enemy doesn't move.
	call ecom_setSpeedAndState8

	ld l,Enemy.counter1
	inc (hl)

	ld l,Enemy.var30
	ld (hl),$02

	ld l,Enemy.var03
	ld a,(hl)
	ld (hl),$00
	ld l,Enemy.var33
	ld (hl),a
	ret


dekuScrub_state_stub:
	ret


; Waiting for Link to be a certain distance away
dekuScrub_state8:
	ld c,$2c
	call objectCheckLinkWithinDistance
	ret c
	call ecom_decCounter1
	ret nz

	ld (hl),90

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.var03
	ld (hl),$02

	xor a
	call enemySetAnimation
	jp objectSetVisiblec3


; Link is at a good distance, wait a bit longer before emerging from bush
dekuScrub_state9:
	ld c,$2c
	call objectCheckLinkWithinDistance
	jp c,dekuScrub_hideInBush

	call ecom_decCounter1
	jr nz,dekuScrub_animate

	; Emerge from under the bush
	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.var03
	inc (hl)

	; Calculate angle to shoot
	call objectGetAngleTowardEnemyTarget
	ld hl,dekuScrub_targetAngles
	rst_addAToHl
	ld a,(hl)
	or a
	jr z,dekuScrub_hideInBush

	ld e,Enemy.angle
	ld (de),a
	rrca
	rrca
	sub $02
	ld hl,dekuScrub_fireAnimations
	rst_addAToHl
	ld a,(hl)
	jp enemySetAnimation


; Firing sequence
dekuScrub_stateA:
	ld c,$2c
	call objectCheckLinkWithinDistance
	jr c,dekuScrub_hideInBush

	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr z,dekuScrub_hideInBush

	ld a,(de)
	dec a
	jr nz,dekuScrub_animate
	ld (de),a

	ld b,PARTID_DEKU_SCRUB_PROJECTILE
	call ecom_spawnProjectile

dekuScrub_animate:
	jp enemyAnimate


; Go hide in the bush again
dekuScrub_stateB:
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr nz,dekuScrub_animate

	ld h,d
	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.var03
	ld (hl),$00
	jp objectSetInvisible


; He's just been defeated
dekuScrub_stateC:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0d

	ld l,Enemy.collisionType
	res 7,(hl)

	ld e,Enemy.var32
	call objectAddToAButtonSensitiveObjectList
	ld a,$07
	call enemySetAnimation


; Waiting for Link to talk to him
dekuScrub_stateD:
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld e,Enemy.var32
	ld a,(de)
	or a
	jr z,dekuScrub_animate

	; Pressed A in front of deku scrub
	ld e,Enemy.var32
	xor a
	ld (de),a

	; Show text
	ld e,Enemy.var33
	ld a,(de)
	ld c,a
	ld b,>TX_4500
	jp showText


;;
dekuScrub_hideInBush:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0b

	ld l,Enemy.counter1
	ld (hl),120

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.var03
	ld (hl),$02
	ld a,$06
	jp enemySetAnimation


; Takes the relative angle between the deku scrub and Link as an index, and the
; corresponding value is the angle at which to shoot a projectile. "0" means can't shoot
; from this angle.
dekuScrub_targetAngles:
	.db $00 $00 $00 $00 $00 $00 $00 $08
	.db $08 $08 $0c $0c $0c $0c $0c $10
	.db $10 $10 $14 $14 $14 $14 $14 $18
	.db $18 $18 $00 $00 $00 $00 $00 $00

dekuScrub_fireAnimations:
	.db $05 $04 $03 $02 $01

;;
; @param[out]	zflag	z if spawned bus successfully
dekuScrub_spawnBush:
	ld b,ENEMYID_BUSH_OR_ROCK
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz

	call objectCopyPosition

	; [child.relatedObj1] = this
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	; Save projectile's index to var31
	ld e,Enemy.var31
	ld a,h
	ld (de),a

	ld l,Enemy.subid
	ld e,l
	ld a,(de)
	ld (hl),a
	xor a
	ret


; ==============================================================================
; ENEMYID_WALLMASTER
;
; Variables:
;   relatedObj1: For actual wallmaster (subid 1): reference to spawner.
;   relatedObj2: For spawner (subid 0): reference to actual wallmaster.
;   var30: Nonzero if collided with Link (currently warping him out)
; ==============================================================================
enemyCode28:
	jr z,@normalStatus
	sub $03
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockback

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret nz

	; Link just touched the hand. If not experiencing knockback, begin warping Link
	; out.
	ld e,Enemy.knockbackCounter
	ld a,(de)
	or a
	ret nz

	ld h,d
	ld l,Enemy.var30
	ld (hl),$01

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.yh
	ldi a,(hl)
	ld (w1Link.yh),a
	inc l
	ld a,(hl)
	ld (w1Link.xh),a
	ret

@dead:
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	or a
	jr z,++
	ld h,a
	ld l,Enemy.relatedObj2+1
	ld (hl),$00
	ld l,Enemy.yh
	dec (hl)
++
	jp enemyDie_uncounted


@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw wallmaster_state_uninitialized
	.dw wallmaster_state1
	.dw wallmaster_state_stub
	.dw wallmaster_state_stub
	.dw wallmaster_state_stub
	.dw wallmaster_state_galeSeed
	.dw wallmaster_state_stub
	.dw wallmaster_state_stub
	.dw wallmaster_state8
	.dw wallmaster_state9
	.dw wallmaster_stateA
	.dw wallmaster_stateB
	.dw wallmaster_stateC
	.dw wallmaster_stateD


wallmaster_state_uninitialized:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jp nz,ecom_setSpeedAndState8

	ld h,d
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),180

	ld l,Enemy.relatedObj2
	ld (hl),Enemy.start
	ret


; Subid 0 (wallmaster spawner) stays in this state indefinitely; spawns a wallmaster every
; 2 seconds.
wallmaster_state1:
	; "yh" acts as the number of wallmasters remaining to spawn, for the spawner.
	ld e,Enemy.yh
	ld a,(de)
	or a
	jr z,@delete

	ld e,Enemy.relatedObj2+1
	ld a,(de)
	or a
	ret nz

	call ecom_decCounter1
	ret nz

	ld (hl),120

	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	call getTileCollisionsAtPosition
	ret nz

	push bc
	ld b,ENEMYID_WALLMASTER
	call ecom_spawnUncountedEnemyWithSubid01
	pop bc
	ret nz
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld e,Enemy.relatedObj2+1
	ld a,h
	ld (de),a
	ret

@delete:
	call decNumEnemies
	call markEnemyAsKilledInRoom
	jp enemyDelete


wallmaster_state_galeSeed:
	call ecom_galeSeedEffect
	ret c

	; Tell spawner that this wallmaster is dead
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	or a
	jr z,++
	ld h,a
	ld l,Enemy.relatedObj2+1
	ld (hl),$00
++
	jp enemyDelete


wallmaster_state_stub:
	ret


; Spawning at Link's position, above the screen
wallmaster_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]++

	ld l,Enemy.collisionType
	ld (hl),$80|ENEMYID_FLOORMASTER

	; Copy Link's position, set high Z position
	ld l,Enemy.zh
	ld (hl),$a0
	ld l,Enemy.yh
	ld a,(w1Link.yh)
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	ld (hl),a

	ld a,SND_FALLINHOLE
	call playSound
	jp objectSetVisiblec1


; Falling to ground
wallmaster_state9:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	jr z,@hitGround

	call wallmaster_flickerVisibilityIfHighUp

	; Chechk for collision with Link
	ld e,Enemy.var30
	ld a,(de)
	or a
	ret z
	ld e,Enemy.zh
	ld a,(de)
	ld (w1Link.zh),a
	ret

@hitGround:
	ld l,Enemy.counter1
	ld (hl),30
	ld l,Enemy.state
	inc (hl)
	ret


; Waiting on ground for [counter1] frames before moving back up
wallmaster_stateA:
	call ecom_decCounter1
	jr nz,++
	ld l,e
	inc (hl) ; [state]++
	ret
++
	ld a,(hl)
	cp 20 ; [counter1] == 20?
	jr c,++
	ret nz

	; Close hand when [counter1] == 20
	ld a,$01
	jp enemySetAnimation
++
	dec a
	jr nz,++

	; Set collisionType when [counter1] == 1?
	ld l,Enemy.collisionType
	ld a,(hl)
	and $80
	or ENEMYID_WALLMASTER
	ld (hl),a
++
	ld l,Enemy.var30
	bit 0,(hl)
	ret z
	xor a
	ld (w1Link.visible),a
	ret


; Moving back up
wallmaster_stateB:
	call wallmaster_flickerVisibilityIfHighUp
	ld h,d
	ld l,Enemy.zh
	dec (hl)
	dec (hl)
	ld a,(hl)
	cp $a0
	ret nc

	; Moved high enough
	call objectSetInvisible
	ld l,Enemy.var30
	bit 0,(hl)
	jr z,++

	; We just pulled Link out, go to state $0d
	ld l,Enemy.state
	ld (hl),$0d
	ret
++
	ld l,Enemy.state
	inc (hl) ; [state] = $0c
	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.counter1
	ld (hl),120
	ret


; Waiting off-screen until time to attack again
wallmaster_stateC:
	call ecom_decCounter1
	ret nz

	ld l,e
	ld (hl),$08 ; [state] = 8
	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a
	jp enemySetAnimation


; Just dragged Link off-screen
wallmaster_stateD:
	; Go to substate 2 in LINK_STATE_GRABBED_BY_WALLMASTER.
	ld a,$02
	ld (w1Link.substate),a
	ret


;;
; Flickers visibility if very high up (zh < $b8)
wallmaster_flickerVisibilityIfHighUp:
	ld e,Enemy.zh
	ld a,(de)
	or a
	ret z
	cp $b8
	jp c,ecom_flickerVisibility
	cp $bc
	ret nc
	jp objectSetVisiblec1


; ==============================================================================
; ENEMYID_PODOBOO
;
; Variables:
;   relatedObj1: "Parent" (for subid 1, the lava particle)
;   var30: Animation index
;   var31: Initial Y position; the point at which the podoboo returns back to the lava
; ==============================================================================
enemyCode29:
	; Return for ENEMYSTATUS_01 or ENEMYSTATUS_STUNNED
	dec a
	ret z
	dec a
	ret z

	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw podoboo_state_uninitialized
	.dw podoboo_state_stub
	.dw podoboo_state_stub
	.dw podoboo_state_stub
	.dw podoboo_state_stub
	.dw podoboo_state_stub
	.dw podoboo_state_stub
	.dw podoboo_state_stub
	.dw podoboo_state8
	.dw podoboo_state9
	.dw podoboo_stateA
	.dw podoboo_stateB
	.dw podoboo_stateC

podoboo_state_uninitialized:
	; Note: a is uninitialized; arbitrary speed
	call ecom_setSpeedAndState8
	ld e,Enemy.subid
	ld a,(de)
	or a
	ret z

	; Subid 1 only

	ld (hl),$0c ; [state] = $0c

	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.var30
	ld a,(hl)
	inc a
	call enemySetAnimation
	jp objectSetVisible83


podoboo_state_stub:
	ret


; Subid 0: Waiting for Link to approach horizontally
podoboo_state8:
	ld h,d
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $30
	cp $61
	ret nc

	; Save initial Y-position so we know when the leap is done
	ld l,Enemy.yh
	ld a,(hl)
	ld l,Enemy.var31
	ld (hl),a
	jr podoboo_beginMovingUp


; Leaping out of lava
podoboo_state9:
	call enemyAnimate
	call podoboo_updatePosition
	jr z,@doneLeaping

	ld a,(hl) ; hl == Enemy.speedZ+1
	or a
	jr nz,podoboo_spawnLavaParticleEvery16Frames

	; Moving down
	ld l,Enemy.var30
	cp (hl)
	ret z
	ld (hl),a
	call enemySetAnimation
	jr podoboo_spawnLavaParticle

@doneLeaping:
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.collisionType
	res 7,(hl)


; Just re-entered the lava
podoboo_stateA:
	call podoboo_makeLavaSplash
	ret nz

	; Wait a random amount of time before resurfacing
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,podoboo_counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a

	call ecom_incState
	jp objectSetInvisible


; Waiting for [counter1] frames before jumping out again.
podoboo_stateB:
	call ecom_decCounter1
	ret nz
	inc (hl)
	jr podoboo_beginMovingUp


; State for "lava particle" (subid 1); just animate until time to delete self.
podoboo_stateC:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jp z,enemyDelete
	dec a
	jp nz,objectSetInvisible
	jp ecom_flickerVisibility


;;
podoboo_spawnLavaParticleEvery16Frames:
	call ecom_decCounter1
	ld a,(hl)
	and $0f
	ret nz

;;
podoboo_spawnLavaParticle:
	ld b,ENEMYID_PODOBOO
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz
	call objectCopyPosition
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d
	ret


;;
; Makes a splash, sets animation and speed, enables collisions for when the splash has
; just spawned, sets state to 9.
podoboo_beginMovingUp:
	call podoboo_makeLavaSplash
	ret nz

	call objectSetVisible82

	ld e,Enemy.var30
	ld a,$02
	ld (de),a
	call enemySetAnimation

	ld bc,-$440
	call objectSetSpeedZ

	ld l,Enemy.state
	ld (hl),$09
	ld l,Enemy.collisionType
	set 7,(hl)
	xor a
	ret


;;
; @param[out]	zflag	z if created successfully
podoboo_makeLavaSplash:
	ldbc INTERACID_LAVASPLASH,$01
	jp objectCreateInteraction


; Value randomly chosen from here
podoboo_counter1Vals:
	.db $10 $50 $50 $50


;;
; @param[out]	zflag	z if returned to original position.
podoboo_updatePosition:
	ld h,d
	ld l,Enemy.speedZ
	ld e,Enemy.y
	call add16BitRefs
	ld b,a

	; Check if Enemy.y has returned to its original position
	ld e,Enemy.var31
	ld a,(de)
	cp b
	jr c,++

	; If so, [Enemy.speedZ] += $001c
	dec l
	ld a,$1c
	add (hl)
	ldi (hl),a
	ld a,$00
	adc (hl)
	ld (hl),a
	or d
	ret
++
	; Reached original position.
	ld l,Enemy.yh
	ldd (hl),a
	ld (hl),$00
	xor a
	ret


; ==============================================================================
; ENEMYID_GIANT_BLADE_TRAP
; ==============================================================================
enemyCode2a:
	; Return for ENEMYSTATUS_01 or ENEMYSTATUS_STUNNED
	dec a
	ret z
	dec a
	ret z

	call ecom_getSubidAndCpStateTo08
	jr c,@commonState
	ld a,b
	rst_jumpTable
	.dw giantBladeTrap_subid00
	.dw giantBladeTrap_subid01
	.dw giantBladeTrap_subid02
	.dw giantBladeTrap_subid03

@commonState:
	rst_jumpTable
	.dw giantBladeTrap_state_uninitialized
	.dw giantBladeTrap_state_stub
	.dw giantBladeTrap_state_stub
	.dw giantBladeTrap_state_stub
	.dw giantBladeTrap_state_stub
	.dw giantBladeTrap_state_stub
	.dw giantBladeTrap_state_stub
	.dw giantBladeTrap_state_stub


giantBladeTrap_state_uninitialized:
	call ecom_setSpeedAndState8
	jp objectSetVisible82


giantBladeTrap_state_stub:
	ret


giantBladeTrap_subid00:
	ret


giantBladeTrap_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw giantBladeTrap_subid01_state8
	.dw giantBladeTrap_subid01_state9
	.dw giantBladeTrap_subid01_stateA


; Choosing initial direction to move.
giantBladeTrap_subid01_state8:
	ld a,$09
	ld (de),a ; [state] = 9
	call giantBladeTrap_chooseInitialAngle
	ld e,Enemy.speed
	ld a,SPEED_80
	ld (de),a
	ret


; Move until hitting a wall.
giantBladeTrap_subid01_state9:
	call giantBladeTrap_checkCanMoveInDirection
	jp z,objectApplySpeed
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$10
	ret


; Wait 16 frames, then change directions and start moving again.
giantBladeTrap_subid01_stateA:
	call ecom_decCounter1
	ret nz

	ld l,e
	dec (hl) ; [state]--

	; Rotate angle clockwise
	ld l,Enemy.angle
	ld a,(hl)
	add $08
	and $18
	ld (hl),a
	ret


giantBladeTrap_subid02:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw giantBladeTrap_subid02_state8
	.dw giantBladeTrap_commonState9
	.dw giantBladeTrap_subid02_stateA


; Initialization
giantBladeTrap_subid02_state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),60
	ret


; Accelerate until hitting a wall.
giantBladeTrap_commonState9:
	call giantBladeTrap_updateSpeed
	call giantBladeTrap_checkCanMoveInDirection
	jp z,objectApplySpeed

	call ecom_incState

	; Round Y, X to center of tile
	ld l,Enemy.yh
	ld a,(hl)
	add $02
	and $f8
	ldi (hl),a
	inc l
	ld a,(hl)
	add $02
	and $f8
	ld (hl),a

	ld l,Enemy.counter1
	ld (hl),$10
	ret


; Hit a wall, waiting for a bit then changing direction.
giantBladeTrap_subid02_stateA:
	call ecom_decCounter1
	ret nz

	; Rotate angle clockwise
	ld e,Enemy.angle
	ld a,(de)
	add $08
	and $1f
	ld (de),a

	call giantBladeTrap_checkCanMoveInDirection
	jr z,@canMove

	; Can't move this way; try reversing direction.
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	ld (de),a
	call giantBladeTrap_checkCanMoveInDirection
	jr z,@canMove

	; Can't move backward either; try another direction.
	ld e,Enemy.angle
	ld a,(de)
	sub $08
	and $1f
	ld (de),a

@canMove:
	 ; Return to state 9
	ld h,d
	ld l,Enemy.state
	dec (hl)
	ld l,Enemy.counter1
	ld (hl),90
	ret


giantBladeTrap_subid03:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw giantBladeTrap_subid03_state8
	.dw giantBladeTrap_commonState9
	.dw giantBladeTrap_subid03_stateA


; Initialization
giantBladeTrap_subid03_state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.angle
	ld (hl),$10
	ld l,Enemy.counter1
	ld (hl),90
	ret


; Hit a wall, waiting for a bit then changing direction.
giantBladeTrap_subid03_stateA:
	call ecom_decCounter1
	ret nz

	; Rotate angle counterclockwise
	ld e,Enemy.angle
	ld a,(de)
	sub $08
	and $1f
	ld (de),a

	call giantBladeTrap_checkCanMoveInDirection
	jr z,@canMove

	; Can't move this way; try reversing direction.
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	ld (de),a
	call giantBladeTrap_checkCanMoveInDirection
	jr z,@canMove

	; Can't move backward either; try another direction.
	ld e,Enemy.angle
	ld a,(de)
	add $08
	and $1f
	ld (de),a

@canMove:
	; Return to state 9
	ld h,d
	ld l,Enemy.state
	dec (hl)
	ld l,Enemy.counter1
	ld (hl),90
	ret


;;
; Subid 1 only; check all directions, choose which way to go.
giantBladeTrap_chooseInitialAngle:
	call giantBladeTrap_checkCanMoveInDirection
	ld a,ANGLE_RIGHT
	jr nz,@setAngle

	ld e,Enemy.angle
	ld (de),a
	call giantBladeTrap_checkCanMoveInDirection
	ld a,ANGLE_DOWN
	jr nz,@setAngle

	ld e,Enemy.angle
	ld (de),a
	call giantBladeTrap_checkCanMoveInDirection
	ld a,ANGLE_LEFT
	jr nz,@setAngle

	xor a
@setAngle:
	ld e,Enemy.angle
	ld (de),a
	ret

;;
; Based on current angle value, this checks if it can move in that direction (it is not
; blocked by solid tiles directly ahead).
;
; @param[out]	zflag	z if it can move in this direction.
giantBladeTrap_checkCanMoveInDirection:
	ld e,Enemy.yh
	ld a,(de)
	ld b,a
	ld e,Enemy.xh
	ld a,(de)
	ld c,a

	ld e,Enemy.angle
	ld a,(de)
	rrca
	ld hl,@positionOffsets
	rst_addAToHl
	push de
	ld d,>wRoomCollisions
	call @checkTileAtOffsetSolid
	jr nz,+
	call @checkTileAtOffsetSolid
+
	pop de
	ret

;;
; @param	bc	Position
; @param	hl	Pointer to position offsets
; @param[out]	zflag	z if tile is solid
@checkTileAtOffsetSolid:
	ldi a,(hl)
	add b
	and $f0
	ld e,a
	ldi a,(hl)
	add c
	swap a
	and $0f
	or e
	ld e,a
	ld a,(de)
	or a
	ret

@positionOffsets:
	.db $ef $f8  $ef $07 ; DIR_UP
	.db $f8 $10  $07 $10 ; DIR_RIGHT
	.db $10 $f8  $10 $07 ; DIR_DOWN
	.db $f8 $ef  $07 $ef ; DIR_LEFT

;;
; Decrements counter1 and uses its value to determine speed. Lower values = higher speed.
giantBladeTrap_updateSpeed:
	ld e,Enemy.counter1
	ld a,(de)
	or a
	ret z
	ld a,(de)
	dec a
	ld (de),a

	and $f0
	swap a
	ld hl,@speeds
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	ret

@speeds:
	.db SPEED_280, SPEED_200, SPEED_180, SPEED_100, SPEED_80, SPEED_20


; ==============================================================================
; ENEMYID_CHEEP_CHEEP
;
; Variables:
;   var03: How far to travel (copied to counter1)
; ==============================================================================
enemyCode2c:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockback

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw cheepCheep_state_uninitialized
	.dw cheepCheep_state_stub
	.dw cheepCheep_state_stub
	.dw cheepCheep_state_stub
	.dw cheepCheep_state_stub
	.dw ecom_blownByGaleSeedState
	.dw cheepCheep_state_stub
	.dw cheepCheep_state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw cheepCheep_subid00
	.dw cheepCheep_subid01


cheepCheep_state_uninitialized:
	ld a,SPEED_80
	call ecom_setSpeedAndState8
	jp objectSetVisible82


cheepCheep_state_stub:
	ret


cheepCheep_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw cheepCheep_subid00_state8
	.dw cheepCheep_state9
	.dw cheepCheep_stateA


; Initialize angle (left), counter1.
cheepCheep_subid00_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]++

	ld l,Enemy.angle
	ld (hl),ANGLE_LEFT

	ld l,Enemy.var03
	ld a,(hl)
	add a
	ld (hl),a
	ld l,Enemy.counter1
	ld (hl),a
	ret


; Moving until counter1 expires
cheepCheep_state9:
	call ecom_decCounter1
	jr nz,++
	ld (hl),60
	ld l,e
	inc (hl) ; [state]++
++
	call objectApplySpeed

cheepCheep_animate:
	jp enemyAnimate


; Waiting for 60 frames, then reverse direction
cheepCheep_stateA:
	call ecom_decCounter1
	jr nz,cheepCheep_animate

	ld e,Enemy.var03
	ld a,(de)
	ld (hl),a ; [counter1] = [var03]

	ld l,Enemy.state
	dec (hl)

	; Reverse angle
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ldd (hl),a

	; Reverse animation (in Enemy.direction variable)
	ld a,(hl)
	xor $01
	ld (hl),a
	jp enemySetAnimation


cheepCheep_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw cheepCheep_subid01_state8
	.dw cheepCheep_state9
	.dw cheepCheep_stateA


; Initialize angle (down), counter1.
cheepCheep_subid01_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]++
	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN

	ld l,Enemy.var03
	ld a,(hl)
	add a
	ld (hl),a
	ld l,Enemy.counter1
	ld (hl),a
	ret


; ==============================================================================
; ENEMYID_PODOBOO_TOWER
;
; Variables:
;   var30: Base y-position. (Actual y-position changes as it emerges from the ground.)
; ==============================================================================
enemyCode2d:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie_withoutItemDrop

	; ENEMYSTATUS_JUST_HIT or ENEMYSTATUS_KNOCKBACK
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_MYSTERY_SEED
	jp z,enemyDie_uncounted_withoutItemDrop

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD


@state_uninitialized:
	call ecom_setSpeedAndState8
	ld l,Enemy.var3f
	set 5,(hl)

	ld l,Enemy.counter1
	ld (hl),60

	ld l,Enemy.yh
	ld a,(hl)
	ld l,Enemy.var30
	ld (hl),a
	ret


@state_stub:
	ret


; Head is in the ground, flickering, for 60 frames
@state8:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld l,e
	inc (hl) ; [state]++
	ld l,Enemy.collisionType
	set 7,(hl)
	jp objectSetVisible82


; Rising up out of the ground
@state9:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z

	ld b,a
	call @updateCollisionRadiiAndYPosition
	ld a,b
	cp $0f
	ret nz

	; Fully emerged
	ld h,d
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),150
	inc l
	ld (hl),180 ; [counter2]


; Fully emerged from ground, firing at Link until counter2 reaches 0
@stateA:
	call @decCounter2Every4Frames
	jr nz,++
	ld l,e
	inc (hl) ; [state]++
	ld a,$01
	jp enemySetAnimation
++
	; Randomly fire projectile when [counter1] reaches 0
	call ecom_decCounter1
	jr nz,@animate

	ld (hl),150

	call getRandomNumber_noPreserveVars
	cp $b4
	jr nc,@animate

	ld b,PARTID_GOPONGA_PROJECTILE
	call ecom_spawnProjectile
@animate:
	jp enemyAnimate


; Moving back into the ground
@stateB:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z

	bit 7,a
	jr z,@updateCollisionRadiiAndYPosition

	; Head reached the ground
	call ecom_incState
	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.counter1
	ld (hl),60
	ret


; Head is in the ground, flickering, for 60 frames.
@stateC:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),180
	jp objectSetInvisible


; Waiting underground for [counter1] frames.
@stateD:
	call ecom_decCounter1
	ret nz
	ld (hl),60

	ld l,e
	ld (hl),$08 ; [state]

	xor a
	jp enemySetAnimation

;;
; Updates the podoboo tower's collision radius and y-position while it's emerging from the
; ground.
;
; @param	a	Index of data to read (multiple of 3)
@updateCollisionRadiiAndYPosition:
	sub $03
	ld hl,@data
	rst_addAToHl
	ld e,Enemy.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	ld e,Enemy.var30
	ld a,(de)
	add (hl)
	ld e,Enemy.yh
	ld (de),a

	ld e,Enemy.animParameter
	xor a
	ld (de),a
	ret

; b0: collisionRadiusY
; b1: collisionRadiusX
; b2: Offset for y-position
@data:
	.db $06 $04 $00
	.db $08 $04 $f9
	.db $0b $04 $f7
	.db $0f $04 $f4
	.db $12 $04 $f2

;;
@decCounter2Every4Frames:
	ld a,(wFrameCounter)
	and $03
	ret nz
	jp ecom_decCounter2


; ==============================================================================
; ENEMYID_THWIMP
;
; Variables:
;   var30: Original y-position (where it returns to after stomping)
; ==============================================================================
enemyCode2e:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


@state_uninitialized:
	ld e,Enemy.yh
	ld a,(de)
	ld e,Enemy.var30
	ld (de),a

	ld h,d
	ld l,Enemy.counter1
	inc (hl)

	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN
	jp ecom_setSpeedAndState8AndVisible


@state_stub:
	ret


; Cooldown of [counter1] frames
@state8:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [state]
	xor a
	ret


; Waiting for Link to approach
@state9:
	ld h,d
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $0a
	cp $15
	ret nc

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a

	inc a
	jp enemySetAnimation


; Falling down
@stateA:
	ld a,$40
	call objectUpdateSpeedZ_sidescroll
	jr c,@landed

	; Cap speedZ to $0200 (ish... doesn't fix the low byte)
	ld a,(hl)
	cp $03
	ret c
	ld (hl),$02
	ret

@landed:
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),45
	ld a,SND_CLINK
	jp playSound


; Just landed. Wait for [counter1] frames
@stateB:
	call @state8
	ret nz
	jp enemySetAnimation


; Moving back up at constant speed
@stateC:
	ld h,d
	ld l,Enemy.y
	ld a,(hl)
	sub $80
	ldi (hl),a
	ld a,(hl)
	sbc $00
	ld (hl),a

	ld e,Enemy.var30
	ld a,(de)
	cp (hl)
	ret nz

	ld l,Enemy.counter1
	ld (hl),24
	ld l,Enemy.state
	ld (hl),$08
	ret


; ==============================================================================
; ENEMYID_THWOMP
;
; Variables:
;   var30: Original y-position (where it returns to after stomping)
; ==============================================================================
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
