; ==================================================================================================
; ENEMY_SAND_CRAB
; ==================================================================================================
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
