; ==================================================================================================
; ENEMY_HARDHAT_BEETLE
; ENEMY_HARMLESS_HARDHAT_BEETLE (ages only)
; ==================================================================================================
enemyCode4d:
.ifdef ROM_AGES
enemyCode5f:
.endif
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
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

@state_uninitialized:
.ifdef ROM_AGES
	ld e,Enemy.id
	ld a,(de)
	cp ENEMY_HARMLESS_HARDHAT_BEETLE
	ld a,PALH_8d
	call z,loadPaletteHeader
.endif
	ld a,SPEED_60
	jp ecom_setSpeedAndState8AndVisible

@state_stub:
	ret

@state8:
	call ecom_updateAngleTowardTarget
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp enemyAnimate
