; ==================================================================================================
; Leftover template code maybe? Nothing here is referenced by anything.
; ==================================================================================================

	ret
	jr z,+
	sub $03
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ret
+

enemyCodeTemplate0:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state2

@state0:
	jp ecom_setSpeedAndState8AndVisible

@state_stub:
	ret

@state2:
	jp enemyAnimate
	call ecom_checkHazards
	jr z,+
	sub $03
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret
+

enemyCodeTemplate1:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub

@state0:
	jp enemyDelete

@state_stub:
	ret
