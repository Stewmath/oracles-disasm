; ==================================================================================================
; ENEMY_CHEEP_CHEEP
;
; Variables:
;   var03: How far to travel (copied to counter1)
; ==================================================================================================
enemyCode2c:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockback

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw cheepCheep_state_uninitialized
	.dw cheepCheep_state_stub
	.dw cheepCheep_state_stub
	.dw cheepCheep_state_stub
	.dw cheepCheep_state_stub
	.dw ecom_blownByGaleSeedState
	.dw cheepCheep_state_stub
	.dw cheepCheep_state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw cheepCheep_subid00
	.dw cheepCheep_subid01


cheepCheep_state_uninitialized:
	ld a,SPEED_80
	call ecom_setSpeedAndState8
	jp objectSetVisible82


cheepCheep_state_stub:
	ret


cheepCheep_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw cheepCheep_subid00_state8
	.dw cheepCheep_state9
	.dw cheepCheep_stateA


; Initialize angle (left), counter1.
cheepCheep_subid00_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]++

	ld l,Enemy.angle
	ld (hl),ANGLE_LEFT

	ld l,Enemy.var03
	ld a,(hl)
	add a
	ld (hl),a
	ld l,Enemy.counter1
	ld (hl),a
	ret


; Moving until counter1 expires
cheepCheep_state9:
	call ecom_decCounter1
	jr nz,++
	ld (hl),60
	ld l,e
	inc (hl) ; [state]++
++
	call objectApplySpeed

cheepCheep_animate:
	jp enemyAnimate


; Waiting for 60 frames, then reverse direction
cheepCheep_stateA:
	call ecom_decCounter1
	jr nz,cheepCheep_animate

	ld e,Enemy.var03
	ld a,(de)
	ld (hl),a ; [counter1] = [var03]

	ld l,Enemy.state
	dec (hl)

	; Reverse angle
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ldd (hl),a

	; Reverse animation (in Enemy.direction variable)
	ld a,(hl)
	xor $01
	ld (hl),a
	jp enemySetAnimation


cheepCheep_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw cheepCheep_subid01_state8
	.dw cheepCheep_state9
	.dw cheepCheep_stateA


; Initialize angle (down), counter1.
cheepCheep_subid01_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]++
	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN

	ld l,Enemy.var03
	ld a,(hl)
	add a
	ld (hl),a
	ld l,Enemy.counter1
	ld (hl),a
	ret
