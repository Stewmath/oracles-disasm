; ==================================================================================================
; ENEMY_SPARK
; ==================================================================================================
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
	ldbc INTERAC_PUFF,$02
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
	cp ENEMY_SPARK
	ld b,PART_ITEM_DROP
	call z,ecom_spawnProjectile
	jp enemyDelete
