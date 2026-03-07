; ==================================================================================================
; ENEMY_KEESE
;
; Variables (for subid 1 only, the one that moves as Link approaches):
;   var30: Amount to add to angle each frame. (Clockwise or counterclockwise turning)
; ==================================================================================================
enemyCode32:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ret

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw keese_state_uninitialized
	.dw keese_state_stub
	.dw keese_state_stub
	.dw keese_state_stub
	.dw keese_state_stub
	.dw ecom_blownByGaleSeedState
	.dw keese_state_stub
	.dw keese_state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw keese_subid00
	.dw keese_subid01


keese_state_uninitialized:
	call ecom_setSpeedAndState8
	call keese_initializeSubid
	jp objectSetVisible82


keese_state_stub:
	ret


keese_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw keese_subid00_state8
	.dw keese_subid00_state9
	.dw keese_subid00_stateA


; Resting for [counter1] frames
keese_subid00_state8:
	call ecom_decCounter1
	ret nz

	; Choose random angle and counter1
	ld bc,$1f3f
	call ecom_randomBitwiseAndBCE
	call ecom_incState

	ld l,Enemy.angle
	ld (hl),b
	ld l,Enemy.speed
	ld (hl),SPEED_c0

	ld a,$c0
	add c
	ld l,Enemy.counter1
	ld (hl),a

	ld a,$01
	call enemySetAnimation
	jr keese_animate


; Moving in some direction for [counter1] frames
keese_subid00_state9:
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary
	ld a,(wFrameCounter)
	rrca
	jr c,keese_animate

	call ecom_decCounter1
	jr z,@timeToStop

	; 1 in 16 chance, per frame, of randomly choosing a new angle to move in
	ld bc,$0f1f
	call ecom_randomBitwiseAndBCE
	or b
	jr nz,keese_animate

	ld e,Enemy.angle
	ld a,c
	ld (de),a
	jr keese_animate

@timeToStop:
	ld l,Enemy.state
	inc (hl)

keese_animate:
	jp enemyAnimate


; Decelerating until [counter1] counts up to $7f, when it stops completely.
keese_subid00_stateA:
	ld e,Enemy.counter1
	ld a,(de)
	cp $68
	jr nc,++
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary
++
	call keese_updateDeceleration
	ld h,d
	ld l,Enemy.counter1
	inc (hl)

	ld a,$7f
	cp (hl)
	ret nz

	; Full stop
	ld l,Enemy.state
	ld (hl),$08

	; Set counter1 randomly
	call getRandomNumber_noPreserveVars
	and $7f
	ld e,Enemy.counter1
	add $20
	ld (de),a
	xor a
	jp enemySetAnimation


keese_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw keese_subid01_state8
	.dw keese_subid02_state9


; Waiting for Link to approach
keese_subid01_state8:
	ld c,$31
	call objectCheckLinkWithinDistance
	ret nc

	call ecom_updateAngleTowardTarget
	call ecom_incState

	ld l,Enemy.speed
	ld (hl),SPEED_100

	; Turn clockwise or counterclockwise, based on var30
	ld e,Enemy.angle
	ld l,Enemy.var30
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a

	ld l,Enemy.counter1
	ld (hl),12
	inc l
	ld (hl),12 ; [counter2]

	ld a,$01
	jp enemySetAnimation


keese_subid02_state9:
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary
	call ecom_decCounter1
	jr nz,keese_animate

	ld (hl),12 ; [counter1]

	; Turn clockwise or counterclockwise, based on var30
	ld l,Enemy.var30
	ld e,Enemy.angle
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a

	ld l,Enemy.counter2
	dec (hl)
	jr nz,keese_animate

	; Done moving.
	ld l,Enemy.state
	dec (hl)
	call keese_chooseWhetherToReverseTurningAngle
	xor a
	jp enemySetAnimation


;;
; Every 16 frames (based on counter1) this updates the keese's speed as it's decelerating.
; Also handles the animation (which slows down).
keese_updateDeceleration:
	ld e,Enemy.counter1
	ld a,(de)
	and $0f
	jr nz,++

	ld a,(de)
	swap a
	ld hl,@speeds
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.speed
	ld (de),a
++
	ld e,Enemy.counter1
	ld a,(de)
	and $f0
	swap a
	ld hl,@bits
	rst_addAToHl
	ld a,(wFrameCounter)
	and (hl)
	jp z,enemyAnimate
	ret

@speeds:
	.db SPEED_c0, SPEED_80, SPEED_40, SPEED_40, SPEED_20, SPEED_20, SPEED_20, SPEED_20

@bits:
	.db $00 $00 $01 $01 $03 $03 $07 $00


;;
keese_initializeSubid:
	dec b
	jr z,@subid1

@subid0:
	; Just set how long to wait initially
	ld l,Enemy.counter1
	ld (hl),$20
	ret

@subid1:
	ld l,Enemy.zh
	ld (hl),$ff

	ld l,Enemy.var30
	ld (hl),$02

;;
; For subid 1 only, this has a 1 in 4 chance of deciding to reverse the turning angle
; (clockwise or counterclockwise).
keese_chooseWhetherToReverseTurningAngle:
	call getRandomNumber_noPreserveVars
	and $03
	ret nz

	ld e,Enemy.var30
	ld a,(de)
	cpl
	inc a
	ld (de),a
	ret
