; ==================================================================================================
; ENEMY_SHADOW_HAG
;
; Variables:
;   counter2: Number of times to spawn bugs before shadows separate
;   var30: Number of bugs on-screen
;   var31: Set if the hag couldn't spawn because Link was in a bad position
; ==================================================================================================
enemyCode7a:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus

	; Dead. Delete all "children" objects.
	ld e,Enemy.collisionType
	ld a,(de)
	or a
	jr z,@dead
	ldhl FIRST_ENEMY_INDEX, Enemy.start
@killNext:
	ld l,Enemy.id
	ld a,(hl)
	cp ENEMY_SHADOW_HAG_BUG
	call z,ecom_killObjectH
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@killNext
@dead:
	jp enemyBoss_dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw shadowHag_state_uninitialized
	.dw shadowHag_state_stub
	.dw shadowHag_state_stub
	.dw shadowHag_state_stub
	.dw shadowHag_state_stub
	.dw shadowHag_state_stub
	.dw shadowHag_state_stub
	.dw shadowHag_state_stub
	.dw shadowHag_state8
	.dw shadowHag_state9
	.dw shadowHag_stateA
	.dw shadowHag_stateB
	.dw shadowHag_stateC
	.dw shadowHag_stateD
	.dw shadowHag_stateE
	.dw shadowHag_stateF
	.dw shadowHag_state10
	.dw shadowHag_state11
	.dw shadowHag_state12
	.dw shadowHag_state13

shadowHag_state_uninitialized:
	ld a,ENEMY_SHADOW_HAG
	ld b,$00
	call enemyBoss_initializeRoom
	ld a,SPEED_80
	jp ecom_setSpeedAndState8


shadowHag_state_stub:
	ret


shadowHag_state8:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

; Wait for door to close, then begin cutscene
@substate0:
	ld a,($cc93)
	or a
	ret nz

	inc a
	ld (wDisabledObjects),a

	ld bc,$0104
	call enemyBoss_spawnShadow
	ret nz

	ld h,d
	ld l,Enemy.substate
	inc (hl)
	ld l,Enemy.angle
	ld (hl),$18
	ld l,Enemy.zh
	ld (hl),$ff

	; Set position to Link's position
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	add $04
	ldi (hl),a
	inc l
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ret

; Moving left to center of room
@substate1:
	ld e,Enemy.xh
	ld a,(de)
	cp ((LARGE_ROOM_WIDTH/2)<<4)+8
	jp nc,objectApplySpeed

	call shadowHag_beginEmergingFromShadow
	ld h,d
	ld l,Enemy.substate
	inc (hl)

	inc l
	ld (hl),$10 ; [counter1]

	ld l,Enemy.zh
	ld (hl),$00
	jp ecom_killRelatedObj2

; Emerging from shadow
@substate2:
	call shadowHag_updateEmergingFromShadow
	ret nz

	ld e,Enemy.substate
	ld a,$03
	ld (de),a
	dec a
	jp enemySetAnimation

; Delay before showing textbox
@substate3:
	call ecom_decCounter1
	jr nz,@animate

	ld (hl),$08
	ld l,e
	inc (hl)
	ld bc,TX_2f2b
	jp showText

@substate4:
	call ecom_decCounter1
	jr nz,@animate
	call shadowHag_beginReturningToGround
	call enemyBoss_beginBoss
@animate:
	jp enemyAnimate


; Currently in the ground, showing eyes
shadowHag_state9:
	call ecom_decCounter2
	jp nz,shadowHag_updateReturningToGround

	dec l
	ld a,(hl)
	or a
	jr z,@spawnShadows

	dec (hl)
	jp ecom_flickerVisibility

@spawnShadows:
	ld b,$04
	call checkBPartSlotsAvailable
	ret nz

	ldbc PART_SHADOW_HAG_SHADOW,$04
--
	call ecom_spawnProjectile
	dec c
	ld l,Part.angle
	ld (hl),c
	jr nz,--

	; Go to state A
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),150
	inc l
	ld (hl),$04 ; [counter2]

	ld l,Enemy.collisionType
	res 7,(hl)
	jp objectSetInvisible


; Shadows chasing Link
shadowHag_stateA:
	ld a,(wFrameCounter)
	rrca
	ret c
	call ecom_decCounter1
	ret nz

	; Time for shadows to reconverge.

	dec (hl) ; [counter1] = $ff
	ld l,e
	inc (hl) ; [state] = $0b

	call getRandomNumber_noPreserveVars
	and $06
	ld hl,@targetPositions
	rst_addAToHl
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a
	ret

; When the shadows reconverge, one of these positions is chosen randomly.
@targetPositions:
	.db $38 $48
	.db $38 $b8
	.db $78 $48
	.db $78 $b8


; Shadows reconverging to target position
shadowHag_stateB:
	ld e,Enemy.counter2
	ld a,(de)
	or a
	ret nz

	; All shadows have now returned.

	; Decide how many times to spawn bugs before shadows separate again
	call getRandomNumber_noPreserveVars
	and $01
	add $02
	ld e,Enemy.counter2
	ld (de),a

shadowHag_initStateC:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_PODOBOO

	ld l,Enemy.collisionRadiusY
	ld (hl),$03
	inc l
	ld (hl),$05

	call objectSetVisible83
	ld a,$04
	jp enemySetAnimation


; Delay before spawning bugs
shadowHag_stateC:
	call ecom_decCounter1
	jr nz,++
	ld (hl),$41
	ld l,e
	inc (hl)
++
	jp enemyAnimate


; Spawning bugs
shadowHag_stateD:
	call enemyAnimate
	call ecom_decCounter1
	jr z,@doneSpawningBugs

	; Spawn bug every 16 frames
	ld a,(hl)
	and $0f
	ret nz

	; Maximum of 7 at a time
	ld e,Enemy.var30
	ld a,(de)
	cp $07
	ret nc

	; Spawn bug
	ld b,ENEMY_SHADOW_HAG_BUG
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz

	; [child.relatedObj1] = this
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	; [child.position] = [this.position]
	call objectCopyPosition

	ld h,d
	ld l,Enemy.var30
	inc (hl)
	ret

@doneSpawningBugs:
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),30
	ret


; Done spawning bugs; delay before the hag herself spawns in
shadowHag_stateE:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld e,Enemy.var31
	ld a,(de)
	or a
	ld a,90
	jr z,++
	xor a
	ld (de),a
	ld a,150
++
	ld (hl),a ; [counter1] = a

	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.collisionType
	res 7,(hl)
	jp objectSetInvisible


; Waiting for Link to be in a position where the hag can spawn behind him
shadowHag_stateF:
	call ecom_decCounter1
	jr z,@couldntSpawn

	call shadowHag_chooseSpawnPosition
	ret nz
	ld e,Enemy.yh
	ld a,b
	ld (de),a
	ld e,Enemy.xh
	ld a,c
	ld (de),a
	call shadowHag_beginEmergingFromShadow
	jp ecom_incState

@couldntSpawn:
	ld e,Enemy.var31
	ld a,$01
	ld (de),a

	inc l
	dec (hl) ; [counter2]--
	jp nz,shadowHag_initStateC

	call shadowHag_beginReturningToGround
	ld a,$04
	jp enemySetAnimation


; Spawning out of ground to attack Link
shadowHag_state10:
	call shadowHag_updateEmergingFromShadow
	ret nz

	call ecom_incState

	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_SHADOW_HAG

	ld l,Enemy.speed
	ld (hl),SPEED_180
	ld l,Enemy.counter1
	ld (hl),30
	ld l,Enemy.direction
	ld (hl),$ff

	ld l,Enemy.collisionRadiusY
	ld (hl),$0c
	inc l
	ld (hl),$08

	call ecom_updateCardinalAngleTowardTarget
	jp ecom_updateAnimationFromAngle


; Delay before charging at Link
shadowHag_state11:
	call shadowHag_checkLinkLookedAtHag
	jr z,shadowHag_doneCharging

	call ecom_decCounter1
	ret nz
	ld (hl),60

	ld l,Enemy.state
	inc (hl)

shadowHag_animate:
	jp enemyAnimate


; Charging at Link
shadowHag_state12:
	call shadowHag_checkLinkLookedAtHag
	jr z,shadowHag_doneCharging

	call ecom_decCounter1
	jr z,shadowHag_doneCharging

	ld e,Enemy.yh
	ld a,(de)
	sub $12
	cp (LARGE_ROOM_HEIGHT<<4)-$32
	jr nc,shadowHag_doneCharging

	ld e,Enemy.xh
	ld a,(de)
	sub $18
	cp (LARGE_ROOM_WIDTH<<4)-$30
	jr nc,shadowHag_doneCharging
	call objectApplySpeed
	jr shadowHag_animate


shadowHag_doneCharging:
	call ecom_decCounter2
	jp z,shadowHag_beginReturningToGround

	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_PODOBOO
	ld a,$06
	jp enemySetAnimation


; Delay before spawning bugs again
shadowHag_state13:
	call ecom_decCounter1
	jr nz,shadowHag_updateReturningToGround
	jp shadowHag_initStateC


;;
shadowHag_beginEmergingFromShadow:
	ld a,$05
	call enemySetAnimation
	call objectSetVisible82
	ld e,Enemy.yh
	ld a,(de)
	sub $04
	ld (de),a
	ret

;;
; @param[out]	zflag	z if done emerging? (animParameter was $ff)
shadowHag_updateEmergingFromShadow:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	ret z

	; If [animParameter] == 1, y -= 8? (To center the hitbox maybe?)
	sub $02
	ret nz
	ld (de),a

	ld e,Enemy.yh
	ld a,(de)
	sub $08
	ld (de),a
	or d
	ret

;;
shadowHag_updateReturningToGround:
	call enemyAnimate

	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z
	bit 7,a
	ret nz

	dec a
	ld hl,@yOffsets
	rst_addAToHl

	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld (de),a

	ld e,Enemy.animParameter
	xor a
	ld (de),a
	ret

@yOffsets:
	.db $08 $04

;;
; Sets state to 9 & initializes stuff
shadowHag_beginReturningToGround:
	ld h,d
	ld l,Enemy.state
	ld (hl),$09

	ld l,Enemy.counter1
	ld (hl),90
	inc l
	ld (hl),30 ; [counter2]

	; Make hag invincible
	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_PODOBOO

	ld l,Enemy.collisionRadiusY
	ld (hl),$03
	inc l
	ld (hl),$05

	ld a,$06
	jp enemySetAnimation

;;
; Chooses position to spawn at for charge attack based on Link's facing direction.
;
; @param[out]	bc	Spawn position
; @param[out]	zflag	nz if Link is too close to the wall to spawn in
shadowHag_chooseSpawnPosition:
	ld a,(w1Link.direction)
	ld hl,@spawnOffsets
	rst_addDoubleIndex

	ld a,(w1Link.yh)
	add (hl)
	ld b,a
	sub $1c
	cp $80
	jr nc,@invalid

	inc hl
	ld a,(w1Link.xh)
	ld e,a
	add (hl)
	ld c,a
	cp $f0
	jr nc,@invalid

	sub e
	jr nc,++
	cpl
	inc a
++
	rlca
	jp nc,getTileCollisionsAtPosition

@invalid:
	or d
	ret

@spawnOffsets:
	.db $40 $00
	.db $08 $c0
	.db $c0 $00
	.db $08 $40

;;
; @param[out]	zflag	z if Link looked at the hag
shadowHag_checkLinkLookedAtHag:
	call objectGetAngleTowardEnemyTarget
	add $14
	and $18
	swap a
	rlca
	ld b,a
	ld a,(w1Link.direction)
	cp b
	ret
