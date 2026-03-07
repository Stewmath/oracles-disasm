; ==================================================================================================
; ENEMY_SPIKED_BEETLE
;
; Variables:
;   var30: $00 normally, $01 when flipped over.
; ==================================================================================================
enemyCode14:
	call ecom_checkHazards
	jr z,@normalStatus

	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

	dec a
	jr nz,@knockback

	; Just hit by something

	; If bit 0 of var30 is set, ...?
	ld h,d
	ld l,Enemy.var30
	bit 0,(hl)
	jr z,++
	ld e,Enemy.zh
	ld a,(de)
	rlca
	jr c,++
	ld (hl),$00
++
	; Check if the collision was a shovel or shield (enemy will flip over)
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_SHOVEL
	jr z,++
	res 7,a
	sub ITEMCOLLISION_L1_SHIELD
	cp (ITEMCOLLISION_L3_SHIELD-ITEMCOLLISION_L1_SHIELD)+1
	jr nc,@normalStatus
++
	; If already flipped, return.
	ld e,Enemy.state
	ld a,(de)
	cp $0b
	ret z

	; Flip over.

	ld (hl),$01 ; [var30] = $01
	ld bc,-$180
	call objectSetSpeedZ

	ld l,Enemy.state
	ld (hl),$0b

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_SPIKED_BEETLE_FLIPPED

	ld l,Enemy.counter1
	ld (hl),180

	ld l,Enemy.knockbackAngle
	ld a,(hl)
	xor $10
	ld l,Enemy.angle
	ld (hl),a

	ld a,SND_BOMB_LAND
	call playSound
	ld a,$01
	jp enemySetAnimation


@knockback:
	ld e,Enemy.var30
	ld a,(de)
	or a
	jp z,ecom_updateKnockbackAndCheckHazards

	; If flipped over, knockback is considered to last until it stops bouncing.
	ld c,$18
	call objectUpdateSpeedZAndBounce
	ld a,$01
	jr nc,+
	xor a
+
	ld e,Enemy.knockbackCounter
	ld (de),a
	ld e,Enemy.knockbackAngle
	ld a,(de)
	ld c,a
	ld b,SPEED_e0
	jp ecom_applyGivenVelocity


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
	.dw @stateB
	.dw @stateC


@state_uninitialized:
	call @setRandomAngleAndCounter1
	ld a,SPEED_40
	jp ecom_setSpeedAndState8AndVisible


@state_stub:
	ret


; Wandering around until Link comes into range
@state8:
	ld b,$08
	call objectCheckCenteredWithLink
	jp c,@chargeLink

	call ecom_decCounter1
	jp z,@setRandomAngleAndCounter1
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp z,@setRandomAngleAndCounter1
@animate:
	jp enemyAnimate


; Charging at Link
@state9:
	call ecom_decCounter2
	call @incSpeed
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,@animate

	; Hit wall
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),30
	ret


; Standing still for 30 frames (unless it can charge Link again)
@stateA:
	ld b,$08
	call objectCheckCenteredWithLink
	jp c,@chargeLink

	call ecom_decCounter1
	jr nz,@animate

	ld l,Enemy.state
	ld (hl),$08
	ld l,Enemy.speed
	ld (hl),SPEED_40
	jp @setRandomAngleAndCounter1


; Flipped over.
@stateB:
	call ecom_decCounter1
	jr nz,++

	; Flip back to normal.

	ld l,e
	inc (hl) ; [state] = $0c
	ld l,Enemy.speed
	ld (hl),SPEED_c0

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_SPIKED_BEETLE
	ld l,Enemy.xh
	inc (hl)
	ld bc,-$180
	call objectSetSpeedZ
	xor a
	jp enemySetAnimation
++
	; Waiting to flip back.
	ld a,(hl)
	cp 60
	jr nc,@animate

	; In last second, start shaking.
	and $06
	rrca
	ld hl,@xOscillationOffsets
	rst_addAToHl
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	ld (de),a
	jr @animate


; In the process of flipping back to normal.
@stateC:
	call ecom_applyVelocityForSideviewEnemyNoHoles
	call enemyAnimate

	ld c,$18
	call objectUpdateSpeedZ_paramC
	ret nz

	ld e,Enemy.state
	ld a,$08
	ld (de),a

	ld b,$10
	call objectCheckCenteredWithLink
	jr c,@chargeLink

	ld e,Enemy.speed
	ld a,SPEED_40
	ld (de),a
	ret

;;
; Angle and counter1 are set randomly (counter1 is between $30-$60, in increments of $10).
@setRandomAngleAndCounter1:
	ldbc $18,$30
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,b
	ld (de),a
	ld e,Enemy.counter1
	ld a,$30
	add c
	ld (de),a
	ret

;;
@chargeLink:
	call ecom_updateCardinalAngleTowardTarget
	ld h,d
	ld l,Enemy.state
	ld (hl),$09
	ld l,Enemy.counter2
	ld (hl),150
	ld l,Enemy.speed
	ld (hl),SPEED_40
	ret

;;
@incSpeed:
	ld e,Enemy.counter2
	ld a,(de)
	and $03
	ret nz

	ld e,Enemy.speed
	ld a,(de)
	cp SPEED_180
	ret nc
	add SPEED_20
	ld (de),a
	ret

@xOscillationOffsets:
	.db $01 $ff $ff $01
