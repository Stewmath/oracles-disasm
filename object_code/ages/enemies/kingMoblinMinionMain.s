; ==================================================================================================
; ENEMY_KING_MOBLIN_MINION
;
; Variables:
;   relatedObj1: Instance of ENEMY_KING_MOBLIN
;   relatedObj2: Instance of PART_BOMB (smaller bomb thrown by this object)
; ==================================================================================================
enemyCode56_body:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw kingMoblinMinion_state0
	.dw enemyAnimate
	.dw kingMoblinMinion_state2
	.dw kingMoblinMinion_state3
	.dw kingMoblinMinion_state4
	.dw kingMoblinMinion_state5
	.dw kingMoblinMinion_state6
	.dw kingMoblinMinion_state7
	.dw kingMoblinMinion_state8
	.dw kingMoblinMinion_state9
	.dw kingMoblinMinion_stateA


kingMoblinMinion_state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Enemy.speed
	ld (hl),SPEED_200

	ld e,Enemy.subid
	ld a,(de)
	add a
	ld hl,@data
	rst_addDoubleIndex

	ld e,Enemy.counter1
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.direction
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a

	ld a,$02
	call enemySetAnimation
	jp objectSetVisiblec2

; Data format: counter1, direction, yh, xh
@data:
	.db  30, $03, $08, $18
	.db 150, $01, $08, $88



; Fight just started
kingMoblinMinion_state2:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 3

	ld l,Enemy.counter2
	ld (hl),$0c
	ld e,Enemy.direction
	ld a,(de)
	jp enemySetAnimation


; Delay before spawning bomb
kingMoblinMinion_state3:
	call ecom_decCounter2
	jr nz,kingMoblinMinion_animate

	ld b,PART_BOMB
	call ecom_spawnProjectile
	ret nz

	call ecom_incState

	ld a,$02
	jp enemySetAnimation


; Holding bomb for a bit
kingMoblinMinion_state4:
	call ecom_decCounter1
	ld l,e
	jr z,@jump

	ld a,(wScreenShakeCounterY)
	or a
	jr z,kingMoblinMinion_animate

	ld (hl),$07 ; [counter1]
	jr kingMoblinMinion_animate

@jump:
	inc (hl) ; [state] = 5
	ld l,Enemy.speedZ
	ld a,<(-$180)
	ldi (hl),a
	ld (hl),>(-$180)

kingMoblinMinion_animate:
	jp enemyAnimate


; Jumping in air
kingMoblinMinion_state5:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr z,@landed

	; Check for the peak of the jump
	ldd a,(hl)
	or (hl)
	ret nz

	call objectGetAngleTowardEnemyTarget
	ld b,a

	; [bomb.state]++
	ld a,Object.state
	call objectGetRelatedObject2Var
	inc (hl)

	; Set bomb to move toward Link
	ld l,Part.angle
	ld (hl),b
	ret

@landed:
	ld l,Enemy.state
	inc (hl) ; [state] = 6

	ld l,Enemy.counter1
	ld (hl),$10
	jr kingMoblinMinion_animate


; Delay before pulling out next bomb
kingMoblinMinion_state6:
	call ecom_decCounter1
	jr nz,kingMoblinMinion_animate

	ld (hl),200 ; [counter1]
	ld l,e
	ld (hl),$02 ; [state]

	jr kingMoblinMinion_animate


; ENEMY_KING_MOBLIN sets this object's state to 7 when defeated.
kingMoblinMinion_state7:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 8

	ld l,Enemy.counter1
	ld (hl),24

	; Calculate animation, store it in 'c'
	ld l,Enemy.subid
	ld a,(hl)
	add a
	inc a
	ld c,a

	; Get angle to throw bomb at
	ld a,(hl)
	ld hl,@subidBombThrowAngles
	rst_addAToHl
	ld b,(hl)

	ld a,Object.state
	call objectGetRelatedObject2Var
	inc (hl)

	ld l,Part.angle
	ld (hl),b

	ld l,Part.speed
	ld (hl),SPEED_160

	ld l,Part.speedZ
	ld a,<(-$100)
	ldi (hl),a
	ld (hl),>(-$100)

	ld l,Part.visible
	ld (hl),$81

	ld a,c
	jp enemySetAnimation

@subidBombThrowAngles:
	.db $0a $16


; Delay before hopping
kingMoblinMinion_state8:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.speedZ
	ld a,<(-$140)
	ldi (hl),a
	ld (hl),>(-$140)

	ld l,Enemy.subid
	bit 0,(hl)
	ld c,$f4
	jr z,+
	ld c,$0c
+
	ld b,$f8
	ld a,30
	call objectCreateExclamationMark


; Waiting to land on ground
kingMoblinMinion_state9:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	ld l,Enemy.state
	inc (hl) ; [state] = $0a

	ld l,Enemy.counter1
	ld (hl),12
	inc l
	ld (hl),$08 ; [counter2]

	xor a
	jp enemySetAnimation


; Running away
kingMoblinMinion_stateA:
	call ecom_decCounter2
	jr nz,@animate

	call ecom_decCounter1
	jr z,@delete

	call objectApplySpeed
@animate:
	jp enemyAnimate

@delete:
	; Write to var33 on ENEMY_KING_MOBLIN to request the screen transition to begin
	ld a,Object.var33
	call objectGetRelatedObject1Var
	ld (hl),$01
	jp enemyDelete


blackTower_getMovingFlamesNextTileCoords:
	ld e,$c2
	ld a,(de)
	ld hl,@table
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,$c7
	ld a,(de)
	rst_addAToHl
	ld b,(hl)
	ld a,b
	and $f0
	add $08
	ld e,$f0
	ld (de),a
	inc e
	ld a,b
	and $0f
	swap a
	add $08
	ld (de),a
	ret

@table:
	.dw @leftFlame
	.dw @topFlame
	.dw @rightFlame
	.dw @bottomFlame

@leftFlame:
	.db $51 $91 $93 $13 $19 $39 $3d $9d
	.db $97 $77 $7a $8a $00

@topFlame:
	.db $17 $13 $73 $7d $3d $39 $99 $91
	.db $61 $62 $00

@rightFlame:
	.db $5d $9d $95 $55 $51 $11 $1b $3b
	.db $35 $25 $26 $00

@bottomFlame:
	.db $97 $99 $79 $7d $9d $9b $3b $3d
	.db $1d $1b $3b $35 $55 $53 $93 $98
	.db $88 $00
