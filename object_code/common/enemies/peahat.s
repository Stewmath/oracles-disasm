; ==================================================================================================
; ENEMY_PEAHAT
; ==================================================================================================
enemyCode3e:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

	; ENEMYSTATUS_KNOCKBACK
	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_PEAHAT
	ret nz

@normalStatus:
	call peahat_updateEnemyCollisionMode
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw peahat_state_uninitialized
	.dw peahet_state_stub
	.dw peahet_state_stub
	.dw peahet_state_stub
	.dw peahet_state_stub
	.dw ecom_blownByGaleSeedState
	.dw peahet_state_stub
	.dw peahet_state_stub
	.dw peahat_state8
	.dw peahat_state9
	.dw peahat_stateA
	.dw peahat_stateB


peahat_state_uninitialized:
	call ecom_setSpeedAndState8AndVisible
	ld l,Enemy.counter1
	inc (hl)
	ret


peahet_state_stub:
	ret


; Stationary for [counter1] frames
peahat_state8:
	call ecom_decCounter1
	ret nz

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),$7f

	ld l,Enemy.speed
	ld (hl),SPEED_20

	ld l,Enemy.var30
	ld (hl),$0f
	call objectSetVisiblec1
	jr peahat_animate


; Accelerating
peahat_state9:
	call ecom_decCounter1
	jp nz,peahat_updatePosition

	ld l,Enemy.state
	inc (hl)

	call getRandomNumber_noPreserveVars
	and $07
	ld hl,peahat_counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	call ecom_setRandomAngle
	jr peahat_animate


; Flying around at top speed
peahat_stateA:
	call ecom_decCounter1
	jr z,@beginSlowingDown

	; Change angle every 32 frames
	ld a,(hl)
	and $1f
	call z,ecom_setRandomAngle

	call objectApplySpeed
	call ecom_bounceOffScreenBoundary
	jr peahat_animate

@beginSlowingDown:
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.counter1
	ld (hl),$00

peahat_animate:
	jp enemyAnimate


; Slowing down
peahat_stateB:
	ld h,d
	ld l,Enemy.counter1
	inc (hl)

	ld a,$80
	cp (hl)
	jp nz,peahat_updatePosition

	; Go to state 8 for $80 frames (if tile is non-solid) or 1 frame (if tile is
	; solid).
	ld (hl),$80 ; [counter1]
	push hl
	call objectGetTileCollisions
	pop hl
	jr z,+
	ld (hl),$01 ; [counter1]
+
	ld l,Enemy.state
	ld (hl),$08
	call objectSetVisiblec2
	jr peahat_animate


;;
peahat_updateEnemyCollisionMode:
	ld e,Enemy.zh
	ld a,(de)
	or a
	ld a,ENEMYCOLLISION_PEAHAT_VULNERABLE
	jr z,+
	ld a,ENEMYCOLLISION_PEAHAT
+
	ld e,Enemy.enemyCollisionMode
	ld (de),a
	ret

;;
; Adjusts speed based on counter1, updates position, animates.
peahat_updatePosition:
	ld e,Enemy.counter1
	ld a,(de)
	dec a
	cp $41
	jr nc,@animate

	and $78
	swap a
	rlca
	ld b,a
	sub $06
	jr c,+
	xor a
+
	ld e,Enemy.zh
	ld (de),a

	; Determine speed
	ld a,b
	ld hl,@speedVals
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary

@animate:
	ld e,Enemy.counter1
	ld a,(de)
	and $f0
	swap a
	ld hl,@animFrequencies
	rst_addAToHl
	ld b,(hl)
	ld a,b
	inc a
	jr nz,+
	call enemyAnimate
	ld b,$00
+
	ld a,(wFrameCounter)
	and b
	jp z,enemyAnimate
	ret

@animFrequencies:
	.db $ff $ff $ff $00 $00 $01 $03 $07

@speedVals:
	.db SPEED_c0 SPEED_c0 SPEED_c0 SPEED_80 SPEED_80 SPEED_40 SPEED_40 SPEED_20
	.db SPEED_20

peahat_counter1Vals:
	.db 180 180 210 210 240 240 0 0
