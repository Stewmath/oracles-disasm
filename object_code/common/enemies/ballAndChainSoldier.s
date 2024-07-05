; ==================================================================================================
; ENEMY_BALL_AND_CHAIN_SOLDIER
;
; Variables:
;   relatedObj2: reference to PART_SPIKED_BALL
;   counter1: Written to by PART_SPIKED_BALL?
;   var30: Signal for PART_SPIKED_BALL.
;          0: Ball should rotate at normal speed.
;          1: Ball should rotate at double speed.
;          2: Ball should be thrown at Link.
;   var31: State to return to after switch hook is used on enemy
; ==================================================================================================
enemyCode4b:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus
	jp enemyDie

@normalStatus:
.ifdef ROM_AGES
	call ecom_checkHazards
.else
	call ecom_seasonsFunc_4446
.endif
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw ballAndChain_state_uninitialized
	.dw ballAndChain_state_stub
	.dw ballAndChain_state_stub
	.dw ballAndChain_state_switchHook
	.dw ballAndChain_state_stub
	.dw ballAndChain_state_stub
	.dw ballAndChain_state_stub
	.dw ballAndChain_state_stub
	.dw ballAndChain_state8
	.dw ballAndChain_state9
	.dw ballAndChain_stateA


ballAndChain_state_uninitialized:
	call ballAndChain_spawnSpikedBall
	ret nz

	ld a,SPEED_60
	call ecom_setSpeedAndState8AndVisible

	ld l,Enemy.var31
	ld (hl),$08
	ret


ballAndChain_state_switchHook:
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
	ld e,Enemy.var31
	ld a,(de)
	ld b,a
	jp ecom_fallToGroundAndSetState


ballAndChain_state_stub:
	ret


; Waiting for Link to be close enough to attack
ballAndChain_state8:
	ld c,$38
	call objectCheckLinkWithinDistance
	jr nc,@moveTowardLink

	; Link is close enough
	call ecom_incState
	call ballAndChain_setDefaultState

	ld l,Enemy.counter1
	ld (hl),90

	; Signal PART_SPIKED_BALL to rotate faster
	ld l,Enemy.var30
	inc (hl)

	ld a,$01
	jp enemySetAnimation

@moveTowardLink:
	call ecom_updateAngleTowardTarget
	call ecom_applyVelocityForSideviewEnemyNoHoles

ballAndChain_animate:
	jp enemyAnimate


; Spinning up ball for [counter1] frames before attacking
ballAndChain_state9:
	call ecom_decCounter1
	jr nz,ballAndChain_animate

	inc (hl) ; [counter1]
	ld l,e
	inc (hl) ; [state]

	call ballAndChain_setDefaultState

	; Signal PART_SPIKED_BALL to begin throw toward Link
	ld l,Enemy.var30
	inc (hl)
	ret


; Waiting for PART_SPIKED_BALL to set this object's counter1 to 0 (signalling the throw
; is done)
ballAndChain_stateA:
	ld e,Enemy.counter1
	ld a,(de)
	or a
	ret nz

	; Throw done

	ld c,$38
	call objectCheckLinkWithinDistance
	ld h,d
	ld l,Enemy.state
	jr nc,@gotoState8

	; Link is close; attack again immediately
	dec (hl) ; [state] = 9
	call ballAndChain_setDefaultState
	ld l,Enemy.counter1
	ld (hl),90

	ld l,Enemy.var30
	dec (hl)
	ret

@gotoState8:
	; Link isn't close; go to state 8, waiting for him to be close enough
	ld (hl),$08 ; [state]
	call ballAndChain_setDefaultState

	ld l,Enemy.var30
	xor a
	ld (hl),a
	jp enemySetAnimation


;;
; @param[out]	zflag	z if spawned successfully
ballAndChain_spawnSpikedBall:
	; BUG: This checks for 4 enemy slots, but we actually need 4 part slots...
	ld b,$04
	call checkBEnemySlotsAvailable
	ret nz

	; Spawn the ball
	ld b,PART_SPIKED_BALL
	call ecom_spawnProjectile

	; Spawn the 3 parts of the chain. Their "relatedObj1" will be set to the ball (not
	; this enemy).
	ld c,h
	ld e,$01
@nextChain:
	call getFreePartSlot
	ld (hl),b
	inc l
	ld (hl),e
	ld l,Part.relatedObj1
	ld a,Part.start
	ldi (hl),a
	ld (hl),c
	inc e
	ld a,e
	cp $04
	jr nz,@nextChain
	ret


;;
; Sets state the enemy will return to after switch hook is used on it
;
; @param	hl	Pointer to state
ballAndChain_setDefaultState:
	ld a,(hl)
	ld l,Enemy.var31
	ld (hl),a
	ret
