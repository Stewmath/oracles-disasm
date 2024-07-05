; ==================================================================================================
; ENEMY_VERAN_CHILD_BEE
; ==================================================================================================
enemyCode1f:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ret

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


@state_uninitialized:
	ld a,SPEED_200
	call ecom_setSpeedAndState8
	ld l,Enemy.counter1
	ld (hl),$10

	ld e,Enemy.subid
	ld a,(de)
	ld hl,@angleVals
	rst_addAToHl
	ld e,Enemy.angle
	ld a,(hl)
	ld (de),a
	jp objectSetVisible83

@angleVals:
	.db $10 $16 $0a


@state_stub:
	ret


@state8:
	call ecom_decCounter1
	jr z,++
	call objectApplySpeed
	jr @animate
++
	ld (hl),$0c ; [counter1]
	ld l,e
	inc (hl) ; [state]
@animate:
	jp enemyAnimate


@state9:
	call ecom_decCounter1
	jr nz,@animate
	ld l,e
	inc (hl) ; [state]
	call ecom_updateAngleTowardTarget


@stateA:
	call objectApplySpeed
	call objectCheckWithinRoomBoundary
	jr c,@animate
	call decNumEnemies
	jp enemyDelete
