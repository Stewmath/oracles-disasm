; ==================================================================================================
; ENEMY_CROW
; ENEMY_BLUE_CROW
;
; Variables:
;   var30: "Base" animation index (direction gets added to this)
;   var31: Actual animation index
;   var32/var33: Target position (subid 1 only)
; ==================================================================================================
enemyCode41:
enemyCode4c:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	ret z
	jp ecom_updateKnockbackNoSolidity

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw crow_state_uninitialized
	.dw crow_state_stub
	.dw crow_state_stub
	.dw crow_state_stub
	.dw crow_state_stub
	.dw ecom_blownByGaleSeedState
	.dw crow_state_stub
	.dw crow_state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw crow_subid0
	.dw crow_subid1


crow_state_uninitialized:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jp nz,ecom_setSpeedAndState8

	; Subid 0
	ld a,SPEED_140
	call ecom_setSpeedAndState8
	jp objectSetVisiblec1


crow_state_stub:
	ret


crow_subid0:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw crow_subid0_state8
	.dw crow_subid0_state9
	.dw crow_subid0_stateA


; Perched, waiting for Link to approach
crow_subid0_state8:
	call ecom_updateAngleTowardTarget
	call crow_setAnimationFromAngle

	; Check if Link has approached
	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	add $30
	cp $61
	ret nc

	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $18
	cp $31
	ret nc

	; Link has approached.
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),25

	ld l,Enemy.var30
	ld (hl),$02
	ret


; Moving up and preparing to charge at Link after [counter1] frames (25 frames)
crow_subid0_state9:
	call ecom_updateAngleTowardTarget
	call crow_setAnimationFromAngle
	call ecom_decCounter1
	jr z,@beginCharge

	ld a,(hl) ; [counter1]
	and $03
	jr nz,crow_subid0_animate

	ld l,Enemy.zh
	dec (hl)
	jr crow_subid0_animate

@beginCharge:
	inc l
	ld (hl),90 ; [counter2]

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.collisionType
	set 7,(hl)

	call ecom_updateAngleTowardTarget

	; Randomly add or subtract 4 from angle (will either overshoot or undershoot Link)
	call getRandomNumber_noPreserveVars
	and $04
	jr nz,+
	ld a,-$04
+
	ld b,a
	ld e,Enemy.angle
	ld a,(de)
	add b
	ld (de),a

	jr crow_subid0_animate


; Charging toward Link
crow_subid0_stateA:
	call crow_subid0_checkWithinScreenBounds
	jp nc,enemyDelete

	call ecom_decCounter2
	jr z,@applySpeed

	; Adjust angle toward Link every 8 frames
	ld a,(hl)
	and $07
	jr nz,@applySpeed

	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
	call crow_setAnimationFromAngle

@applySpeed:
	call objectApplySpeed

crow_subid0_animate:
	jp enemyAnimate


crow_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw crow_subid1_state8
	.dw crow_subid1_state9
	.dw crow_subid1_stateA
	.dw crow_subid1_stateB
	.dw crow_subid1_stateC
	.dw crow_subid1_stateD


; Checking whether it's ok to charge in right now
crow_subid1_state8:
	; Count the number of crows that are in state 9 or higher (number of crows that
	; are either about to or are already charging across the screen)
	ldhl FIRST_ENEMY_INDEX, Enemy.id
	ld b,$00
@nextEnemy:
	ld a,(hl)
	cp ENEMY_CROW
	jr nz,++

	ld l,e ; l = state
	ldd a,(hl)
	dec l
	dec l
	cp $09
	jr c,++
	inc b
++
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	; Only allow 2 such crows at a time (this one needs to wait)
	ld a,b
	cp $02
	ret nc

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	or a
	ld a,60   ; 1st crow on-screen
	jr z,+
	ld a,240  ; 2nd crow on-screen
+
	ld (hl),a

	ld l,Enemy.var30
	ld (hl),$02
	ret


; Spawn in after [counter1] frames
crow_subid1_state9:
	call ecom_decCounter1
	ret nz

	; Determine spawn/target position data to read based on which screen quadrant Link
	; is in
	ld b,$00
	ldh a,(<hEnemyTargetY)
	cp (SMALL_ROOM_HEIGHT/2)<<4
	jr c,+
	ld b,$08
+
	ldh a,(<hEnemyTargetX)
	cp (SMALL_ROOM_WIDTH/2)<<4
	jr c,+
	set 2,b
+
	ld a,b
	ld hl,crow_offScreenSpawnData
	rst_addAToHl

	; Read in spawn position
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ldh (<hFF8F),a

	ld e,Enemy.xh
	ldi a,(hl)
	ld (de),a
	ldh (<hFF8E),a

	; Read in target position
	ld e,Enemy.var32
	ldi a,(hl)
	ld (de),a
	ld b,a

	inc e
	ld a,(hl)
	ld (de),a
	ld c,a

	; Set angle to target position
	call ecom_updateAngleTowardTarget

	call ecom_incState

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.zh
	ld (hl),-$06

	call crow_setAnimationFromAngle
	jp objectSetVisiblec1


; Moving into screen
crow_subid1_stateA:
	call crow_moveTowardTargetPosition
	jr nc,crow_subid1_animate

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),60

	call ecom_updateAngleTowardTarget
	call crow_setAnimationFromAngle

crow_subid1_animate:
	jp enemyAnimate


; Hovering in position for [counter1] frames before charging
crow_subid1_stateB:
	call ecom_decCounter1
	jr nz,crow_subid1_animate

	ld (hl),24  ; [counter1]
	inc l
	ld (hl),$00 ; [counter2]

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.var32
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a

	ld l,Enemy.speed
	ld (hl),SPEED_20
	jr crow_subid1_animate


; Moving, accelerating toward Link
crow_subid1_stateC:
	call crow_subid1_checkWithinScreenBounds
	jr nc,@outOfBounds

	call crow_updateAngleTowardLinkIfCounter1Zero
	call crow_updateSpeed
	call objectApplySpeed
	jr crow_subid1_animate

@outOfBounds:
	call ecom_incState
	jr crow_subid1_animate


; Moved out of bounds; go back to state 8 to eventually charge again
crow_subid1_stateD:
	ld h,d
	ld l,e
	ld (hl),$08 ; [state]

	ld l,Enemy.collisionType
	res 7,(hl)

	jp objectSetInvisible


;;
; Adjusts angle to move directly toward Link when [counter1] reaches 0. After this it
; underflows to 255, so the angle correction only happens once.
crow_updateAngleTowardLinkIfCounter1Zero:
	call ecom_decCounter1
	ret nz
	call ecom_updateAngleTowardTarget


;;
crow_setAnimationFromAngle:
	ld h,d
	ld l,Enemy.angle
	ld a,(hl)
	and $0f
	ret z

	bit 4,(hl)
	ld l,Enemy.var30
	ld a,(hl)
	jr nz,+
	inc a
+
	ld l,Enemy.var31
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
; Identical to crow_subid1_checkWithinScreenBounds.
;
; @param[out]	cflag	c if within screen bounds
crow_subid0_checkWithinScreenBounds:
	ld e,Enemy.yh
	ld a,(de)
	cp (SMALL_ROOM_HEIGHT<<4) + 8
	ret nc
	ld e,Enemy.xh
	ld a,(de)
	cp (SMALL_ROOM_WIDTH<<4) + 8
	ret

;;
; @param[out]	cflag	c if within 1 pixel of target position
crow_moveTowardTargetPosition:
	ld h,d
	ld l,Enemy.var32
	call ecom_readPositionVars
	sub c
	inc a
	cp $02
	jr nc,@moveToward

	ldh a,(<hFF8F)
	sub b
	inc a
	cp $02
	ret c

@moveToward:
	call ecom_moveTowardPosition
	call crow_setAnimationFromAngle
	or d
	ret

;;
; Updates speed based on counter2. For subid 1.
crow_updateSpeed:
	ld e,Enemy.counter2
	ld a,(de)
	cp $7f
	jr z,+
	inc a
	ld (de),a
+
	and $f0
	swap a
	ld hl,crow_speeds
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	ret


;;
; Identical to crow_subid0_checkWithinScreenBounds.
;
; @param[out]	cflag	c if within screen bounds
crow_subid1_checkWithinScreenBounds:
	ld e,Enemy.yh
	ld a,(de)
	cp (SCREEN_HEIGHT<<4) + 8
	ret nc
	ld e,Enemy.xh
	ld a,(de)
	cp (SCREEN_WIDTH<<4) + 8
	ret


; Speeds for subid 1; accerelates while chasing Link.
crow_speeds:
	.db SPEED_040 SPEED_080 SPEED_0c0 SPEED_100
	.db SPEED_140 SPEED_180 SPEED_1c0 SPEED_200

; Each row corresponds to a screen quadrant Link is in.
; Byte values:
;   b0/b1: Spawn Y/X position
;   b2/b3: Target Y/X position (position to move to before charging in)
crow_offScreenSpawnData:
	.db $60 $a0 $70 $90
	.db $60 $00 $70 $10
	.db $20 $a0 $10 $90
	.db $20 $00 $10 $10
