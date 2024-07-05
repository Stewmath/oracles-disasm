; ==================================================================================================
; ENEMY_SHADOW_HAG_BUG
;
; Variables:
;   counter2: Lifetime counter
; ==================================================================================================
enemyCode42:
	jr z,++
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead

	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ret

@dead:
	; Decrement parent object's "bug count"
	ld a,Object.var30
	call objectGetRelatedObject1Var
	dec (hl)
	jp enemyDie_uncounted
++
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw shadowHagBug_state_uninitialized
	.dw shadowHagBug_state_stub
	.dw shadowHagBug_state_stub
	.dw shadowHagBug_state_stub
	.dw shadowHagBug_state_stub
	.dw shadowHagBug_state_galeSeed
	.dw shadowHagBug_state_stub
	.dw shadowHagBug_state_stub
	.dw shadowHagBug_state8
	.dw shadowHagBug_state9


shadowHagBug_state_uninitialized:
	ld a,SPEED_60
	call ecom_setSpeedAndState8

	ld l,Enemy.speedZ
	ld a,<(-$e0)
	ldi (hl),a
	ld (hl),>(-$e0)

	call getRandomNumber_noPreserveVars
	and $1f
	ld e,Enemy.angle
	ld (de),a
	jp objectSetVisible82


shadowHagBug_state_galeSeed:
	call ecom_galeSeedEffect
	ret c
	jp enemyDelete


shadowHagBug_state_stub:
	ret


shadowHagBug_state8:
	ld c,$12
	call objectUpdateSpeedZ_paramC
	jr nz,shadowHagBug_applySpeedAndAnimate

	ld l,Enemy.state
	inc (hl)

	call getRandomNumber
	ld l,Enemy.counter1
	ldi (hl),a
	ld (hl),180 ; [counter2]


shadowHagBug_state9:
	call ecom_decCounter2
	jr z,shadowHagBug_delete

	ld a,(hl)
	cp 30
	call c,ecom_flickerVisibility

	dec l
	dec (hl) ; [counter1]
	ld a,(hl)
	and $07
	jr nz,shadowHagBug_applySpeedAndAnimate

	; Choose a random position within link's 16x16 square
	ld bc,$0f0f
	call ecom_randomBitwiseAndBCE
	ldh a,(<hEnemyTargetY)
	add b
	sub $08
	ld b,a
	ldh a,(<hEnemyTargetX)
	add c
	sub $08
	ld c,a

	; Nudge angle toward chosen position
	ld e,Enemy.yh
	ld a,(de)
	ldh (<hFF8F),a
	ld e,Enemy.xh
	ld a,(de)
	ldh (<hFF8E),a
	call objectGetRelativeAngleWithTempVars
	call objectNudgeAngleTowards

shadowHagBug_applySpeedAndAnimate:
	call objectApplySpeed
	jp enemyAnimate

shadowHagBug_delete:
	; Decrement parent's "bug count"
	ld a,Object.var30
	call objectGetRelatedObject1Var
	dec (hl)
	jp enemyDelete
