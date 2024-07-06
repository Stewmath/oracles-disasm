; ==================================================================================================
; ENEMY_LIKE_LIKE
;
; Variables:
;   relatedObj1: Pointer to the like-like spawner (subid 1), if one exists.
;   var30: Number of like-likes on-screen (for subid 1)
; ==================================================================================================
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
	ld b,ENEMY_LIKE_LIKE
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
	cp ENEMY_LIKE_LIKE
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
