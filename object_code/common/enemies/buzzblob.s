; ==================================================================================================
; ENEMY_BUZZBLOB
;
; Variables:
;   var30: Animation index ($02 if in cukeman form)
;   var31: "pressedAButton" variable (set to $01 when pressed A, only in cukeman form)
; ==================================================================================================
enemyCode18:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	jp c,buzzblob_checkShowText
	jp z,enemyDie

	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards

	; Just hit by something

	ld h,d
	ld l,Enemy.var2a
	ld a,(hl)
	cp $80|ITEMCOLLISION_MYSTERY_SEED
	jr z,@becomeCukeman

	cp $80|ITEMCOLLISION_ELECTRIC_SHOCK
	ret nz

	; Link hit the buzzblob, go to state $0a
	ld l,Enemy.state
	ld (hl),$0a

	; Disable scent seeds
	ld l,Enemy.var3f
	res 4,(hl)

	ld l,Enemy.stunCounter
	ld (hl),$00
	ld l,Enemy.counter1
	ld (hl),60
	ld a,$01
	jp enemySetAnimation


; Buzzblob becomes cukeman when using mystery seed on it.
@becomeCukeman:
	ld l,Enemy.var30
	ld a,$02
	cp (hl)
	ret z
	ld (hl),a
	call enemySetAnimation
	ld e,Enemy.pressedAButton
	jp objectAddToAButtonSensitiveObjectList

@normalStatus:
	call buzzblob_checkShowText
	call ecom_checkScentSeedActive
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw buzzblob_state_uninitialized
	.dw buzzblob_state_stub
	.dw buzzblob_state_stub
	.dw buzzblob_state_stub
	.dw buzzblob_state_scentSeed
	.dw ecom_blownByGaleSeedState
	.dw buzzblob_state_stub
	.dw buzzblob_state_stub
	.dw buzzblob_state8
	.dw buzzblob_state9
	.dw buzzblob_stateA


buzzblob_state_uninitialized:
	ld a,SPEED_40
	call ecom_setSpeedAndState8AndVisible

	; Enable moving toward scent seeds, and...?
	ld l,Enemy.var3f
	ld a,(hl)
	or $30
	ld (hl),a

	ret


buzzblob_state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jr nz,++
	ld a,$08
	ld (de),a ; [state] = 8
	jr buzzblob_animate
++
	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a
	call ecom_applyVelocityForSideviewEnemy
	jp enemyAnimate


buzzblob_state_stub:
	ret


; Choosing a direction and duration to move
buzzblob_state8:
	ld a,$09
	ld (de),a ; [state] = 9

	; Set random angle and counter1
	ldbc $1c,$30
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.counter1
	ld a,$30
	add c
	ld (de),a
	ld e,Enemy.angle
	ld a,b
	ld (de),a
	jr buzzblob_animate


; Moving in some direction for a certain amount of time
buzzblob_state9:
	call ecom_decCounter1
	jr z,buzzblob_chooseNewDirection
	call ecom_bounceOffWallsAndHoles
	call objectApplySpeed
buzzblob_animate:
	jp enemyAnimate


; "Shocking Link" state
buzzblob_stateA:
	call ecom_decCounter1
	jr nz,buzzblob_animate
	ld e,Enemy.var30
	ld a,(de)
	call enemySetAnimation

buzzblob_chooseNewDirection:
	ld h,d
	ld l,Enemy.state
	ld (hl),$08 ; Will choose new direction in state 8

	; Enable scent seeds
	ld l,Enemy.var3f
	set 4,(hl)

	ld l,Enemy.collisionType
	set 7,(hl)
	jr buzzblob_animate

;;
buzzblob_checkShowText:
	ld e,Enemy.var31
	ld a,(de)
	or a
	ret z

	xor a
	ld (de),a
	call getRandomNumber_noPreserveVars
	and $07
	add <TX_2f1e
	ld c,a
	ld b,>TX_2f00
	jp showText
