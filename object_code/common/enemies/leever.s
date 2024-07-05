; ==================================================================================================
; ENEMY_LEEVER
; ==================================================================================================
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
	ld b,ENEMY_LEEVER
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
