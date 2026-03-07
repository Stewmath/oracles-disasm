; ==================================================================================================
; ENEMY_BEETLE
;
; Variables for spawner (subid 0):
;   var30: Number of beetles spawned in? It's never actually used, and it doesn't seem to
;          update correctly, so this was probably for some abandoned idea.
;
; Variables for actual beetles (subid 1+):
;   relatedObj1: Reference to spawner object (optional)
; ==================================================================================================
enemyCode51:
	call beetle_checkHazards
	or a
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.subid
	ld a,(de)
	cp $02
	ret nz

	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret z

	ld h,d
	ld l,Enemy.state
	ld (hl),$0a

	ld l,Enemy.counter1
	ld (hl),$01
	ret

@dead:
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jr nz,++

	; Subid 1 only (falling from sky): Update spawner's var30.
	; Since the spawner spawns subid 2, this is probably broken... (not that it
	; matters since the spawner doesn't check its var30 anyway)
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	or a
	jr z,++
	ld a,Object.var30
	call objectGetRelatedObject1Var
	dec (hl)
++
	jp enemyDie

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw beetle_state_uninitialized
	.dw beetle_state_spawner
	.dw beetle_state_stub
	.dw beetle_state_switchHook
	.dw beetle_state_stub
	.dw beetle_state_galeSeed
	.dw beetle_state_stub
	.dw beetle_state_stub

@normalState:
	dec b
	ld a,b
	rst_jumpTable
	.dw beetle_subid1
	.dw beetle_subid2
	.dw beetle_subid3


beetle_state_uninitialized:
	ld a,b
	or a
	ld a,SPEED_80
	jp nz,ecom_setSpeedAndState8

	; Subid 0
	ld a,$01
	ld (de),a ; [state]


beetle_state_spawner:
	call ecom_decCounter2
	ret nz

	; Only spawn beetles when Link is close
	ld c,$20
	call objectCheckLinkWithinDistance
	ret nc

	ld e,Enemy.counter2
	ld a,90
	ld (de),a

	ld b,ENEMY_BEETLE
	call ecom_spawnEnemyWithSubid01
	ret nz
	inc (hl) ; [subid] = 2
	jp objectCopyPosition


beetle_state_galeSeed:
	call ecom_galeSeedEffect
	ret c

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


beetle_state_switchHook:
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
	ld b,$0a
	jp ecom_fallToGroundAndSetState


beetle_state_stub:
	ret


; Falls from the sky
beetle_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw beetle_stateA


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)

	ld c,$08
	call ecom_setZAboveScreen

	call objectSetVisiblec1

	ld a,SND_FALLINHOLE
	jp playSound


; Falling in from above the screen
@state9:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	ret nz

	; [speedZ] = 0
	ld l,Enemy.speedZ
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.state
	inc (hl)

	call objectSetVisiblec2

	ld a,SND_BOMB_LAND
	call playSound

	call beetle_chooseRandomAngleAndCounter1
	jr beetle_animate


; Common beetle state
beetle_stateA:
	call ecom_decCounter1
	call z,beetle_chooseRandomAngleAndCounter1
	call ecom_applyVelocityForSideviewEnemyNoHoles

beetle_animate:
	jp enemyAnimate


; Spawns in instantly
beetle_subid2:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw beetle_stateA


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),30

	call ecom_updateCardinalAngleTowardTarget
	jp objectSetVisiblec2


; Moving toward Link for 30 frames, before starting random movement
@state9:
	call ecom_decCounter1
	jr nz,@keepMovingTowardLink

	inc (hl) ; [counter1] = 1
	ld l,e
	inc (hl) ; [state]
	jr beetle_stateA

@keepMovingTowardLink:
	ld a,(hl)
	cp 22
	jr nz,++
	ld l,Enemy.collisionType
	set 7,(hl)
++
	call ecom_applyVelocityForSideviewEnemy
	jr beetle_animate


; "Bounces in" when it spawns (dug up from the ground)
beetle_subid3:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw beetle_stateA


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speedZ
	ld a,<(-$102)
	ldi (hl),a
	ld (hl),>(-$102)

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	; Bounce in the direction Link is facing
	ld l,Enemy.angle
	ld a,(w1Link.direction)
	swap a
	rrca
	ld (hl),a

	jp objectSetVisiblec2


; Bouncing
@state9:
	ld c,$0e
	call objectUpdateSpeedZAndBounce
	jr c,@doneBouncing

	ld a,SND_BOMB_LAND
	call z,playSound

	; Enable collisions when it starts moving back down
	ld e,Enemy.speedZ+1
	ld a,(de)
	or a
	jr nz,++
	ld h,d
	ld l,Enemy.collisionType
	set 7,(hl)
++
	jp ecom_applyVelocityForSideviewEnemyNoHoles

@doneBouncing:
	call ecom_incState
	ld l,Enemy.speed
	ld (hl),SPEED_80


;;
beetle_chooseRandomAngleAndCounter1:
	ld bc,$071c
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,c
	ld (de),a

	ld a,b
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret

@counter1Vals:
	.db 15 30 30 60 60 60 90 90

;;
; Beetle has custom checkHazards function so it can decrease the spawner's var30 (number
; of spawned
beetle_checkHazards:
	ld b,a
	ld e,Enemy.state
	ld a,(de)
	cp $0a
	ld a,b
	ret c

	; Check if currently sinking in lava? (water doesn't count?)
	ld h,d
	ld l,Enemy.var3f
	bit 1,(hl)
	jr z,@checkHazards

	; When [counter1] == 59, decrement spawner's var30 if it exists?
	ld l,Enemy.counter1
	ld a,(hl)
	cp 59
	jr nz,@checkHazards

	ld l,Enemy.relatedObj1+1
	ld a,(hl)
	or a
	jr z,@checkHazards

	ld h,a
	ld l,Enemy.var30
	dec (hl)

@checkHazards:
	ld a,b
	jp ecom_checkHazards
