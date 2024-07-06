; ==================================================================================================
; ENEMY_ARM_MIMIC
;
; Shares code with ENEMY_LINK_MIMIC.
;
; Variables:
;   var30: Animation index
; ==================================================================================================
enemyCode4e:
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
	.dw armMimic_uninitialized
	.dw armMimic_state_stub
	.dw armMimic_state_stub
	.dw armMimic_state_switchHook
	.dw armMimic_state_stub
	.dw ecom_blownByGaleSeedState
	.dw armMimic_state_stub
	.dw armMimic_state_stub
	.dw armMimic_state8


armMimic_uninitialized:
	ld e,Enemy.var30
	ld a,(w1Link.direction)
	add $02
	and $03
	ld (de),a
	call enemySetAnimation

	ld a,SPEED_100
	jp ecom_setSpeedAndState8AndVisible


armMimic_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw ecom_fallToGroundAndSetState8

@substate1:
@substate2:
	ret


armMimic_state_stub:
	ret


; Only "normal" state; simply moves in reverse of Link's direction.
armMimic_state8:
	; Check that Link is moving
	ld a,(wLinkAngle)
	inc a
	ret z

	add $0f
	and $1f
	ld e,Enemy.angle
	ld (de),a
	call ecom_applyVelocityForSideviewEnemyNoHoles

	ld h,d
	ld l,Enemy.var30
	ld a,(w1Link.direction)
	add $02
	and $03
	cp (hl)
	jr z,@animate

	ld (hl),a
	call enemySetAnimation
@animate:
	jp enemyAnimate
