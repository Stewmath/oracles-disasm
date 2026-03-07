; ==================================================================================================
; ENEMY_GIBDO
; ==================================================================================================
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
	ldbc ENEMY_STALFOS,$02
	jp enemyReplaceWithID


@gotoState8:
	ld e,Enemy.state
	ld a,$08
	ld (de),a
	jr @animate
