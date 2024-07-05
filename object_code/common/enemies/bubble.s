; ==================================================================================================
; ENEMY_BUBBLE
; ==================================================================================================
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
