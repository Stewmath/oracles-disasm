; ==================================================================================================
; ENEMY_POLS_VOICE
;
; Variables:
;   var30: gravity
; ==================================================================================================
enemyCode23:
	call ecom_checkHazardsNoAnimationForHoles
	call polsVoice_checkLinkPlayingInstrument
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
	.dw polsVoice_state_uninitialized
	.dw polsVoice_state_stub
	.dw polsVoice_state_stub
	.dw polsVoice_state_stub
	.dw polsVoice_state_stub
	.dw ecom_blownByGaleSeedState
	.dw polsVoice_state_stub
	.dw polsVoice_state_stub
	.dw polsVoice_state8
	.dw polsVoice_state9

polsVoice_state_uninitialized:
	; Note: a is uninitialized; arbitrary speed
	call ecom_setSpeedAndState8

	call getRandomNumber_noPreserveVars
	ld e,Enemy.counter1
	and $3f
	inc a
	ld (de),a
	jr polsVoice_setLandedAnimation


polsVoice_state_stub:
	ret


polsVoice_state8:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state] = 9

	; Randomly read in 3 speed values: speedZ, gravity (var30), and speed.
	ld bc,$0f1c
	call ecom_randomBitwiseAndBCE
	or b
	ld hl,@jumpSpeeds1
	jr nz,+
	ld hl,@jumpSpeeds2
+
	ld e,Enemy.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	; [var30] = gravity
	ld e,Enemy.var30
	ldi a,(hl)
	ld (de),a

	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	cp SPEED_80
	jr z,++

	; For high speed jump, target Link directly instead of using a random angle
	call objectGetAngleTowardEnemyTarget
	add $02
	and $1c
	ld c,a
++
	ld e,Enemy.angle
	ld a,c
	ld (de),a
	xor a
	call enemySetAnimation
	jp objectSetVisiblec1


; Word: Initial speedZ
; Byte: gravity
; Byte: speed
@jumpSpeeds1:
	dwbb -$128, $0c, SPEED_80
@jumpSpeeds2:
	dwbb -$180, $0c, SPEED_c0


polsVoice_state9:
	call ecom_applyVelocityForSideviewEnemyNoHoles
	ld e,Enemy.var30
	ld a,(de)
	ld c,a
	call objectUpdateSpeedZ_paramC
	ret nz

	; Landed
	ld h,d
	ld l,Enemy.state
	dec (hl) ; [state] = 8
	ld l,Enemy.counter1
	ld (hl),$20

polsVoice_setLandedAnimation:
	ld a,$01
	call enemySetAnimation
	jp objectSetVisiblec2

;;
; @param	a	Enemy status
; @param[out]	a	Updated enemy status
polsVoice_checkLinkPlayingInstrument:
	ld b,a
	ld a,(wLinkPlayingInstrument)
	or a
	jr z,+
	ld b,ENEMYSTATUS_NO_HEALTH
+
	ld a,b
	or a
	ret
