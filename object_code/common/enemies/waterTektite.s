; ==================================================================================================
; ENEMY_WATER_TEKTITE
; ==================================================================================================
enemyCode3a:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	ret z

	; ENEMYSTATUS_KNOCKBACK
	; Need special knockback code for special "solidity" properties (water is
	; traversible, everything else is solid)
	ld e,Enemy.speed
	ld a,(de)
	push af
	ld a,SPEED_200
	ld (de),a
	ld e,Enemy.knockbackAngle
	call waterTektite_getAdjacentWallsBitsetGivenAngle
	ld e,Enemy.knockbackAngle
	call ecom_applyVelocityGivenAdjacentWalls

	pop af
	ld e,Enemy.speed
	ld (de),a
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw waterTektite_state_uninitialized
	.dw waterTektike_state_stub
	.dw waterTektike_state_stub
	.dw waterTektike_state_stub
	.dw waterTektike_state_stub
	.dw ecom_blownByGaleSeedState
	.dw waterTektike_state_stub
	.dw waterTektike_state_stub
	.dw waterTektike_state8
	.dw waterTektike_state9


waterTektite_state_uninitialized:
	call objectSetVisible82

waterTektike_decideNewAngle:
	ld h,d
	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.counter1
	ld (hl),$40

	ld a,(wScentSeedActive)
	or a
	jr nz,@scentSeedActive

	; Random diagonal angle
	call getRandomNumber_noPreserveVars
	and $18
	add $04
	ld e,Enemy.angle
	ld (de),a
	jr waterTektike_animate

@scentSeedActive:
	ldh a,(<hFFB2)
	ldh (<hFF8F),a
	ldh a,(<hFFB3)
	ldh (<hFF8E),a
	ld l,Enemy.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)
	call objectGetRelativeAngleWithTempVars
	ld e,Enemy.angle
	ld (de),a
	jr waterTektike_animate


waterTektike_state_stub:
	ret


; Moving in some direction for [counter1] frames, at varying speeds.
waterTektike_state8:
	call ecom_decCounter1
	jr nz,++

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$08
	jr waterTektike_animate
++
	call waterTektike_setSpeedFromCounter1

	call waterTektite_getAdjacentWallsBitset
	ld e,Enemy.angle
	call ecom_applyVelocityGivenAdjacentWalls
	call ecom_bounceOffScreenBoundary

waterTektike_animate:
	jp enemyAnimate



; Not moving for [counter1] frames; then choosing new angle
waterTektike_state9:
	call ecom_decCounter1
	jr nz,waterTektike_animate
	jr waterTektike_decideNewAngle

;;
; Gets the "adjacent walls bitset" for the tektike; since this swims, water is
; traversable, everything else is not.
;
; This is identical to "fish_getAdjacentWallsBitsetForKnockback".
;
waterTektite_getAdjacentWallsBitset:
	ld e,Enemy.angle

;;
; @param	de	Angle variable
waterTektite_getAdjacentWallsBitsetGivenAngle:
	ld a,(de)
	call ecom_getAdjacentWallTableOffset

	ld h,d
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	ld hl,ecom_sideviewAdjacentWallOffsetTable
	rst_addAToHl

	ld a,$10
	ldh (<hFF8B),a
	ld d,>wRoomLayout
@nextOffset:
	ldi a,(hl)
	add b
	ld b,a
	and $f0
	ld e,a
	ldi a,(hl)
	add c
	ld c,a
	and $f0
	swap a
	or e
	ld e,a
	ld a,(de)
	sub TILEINDEX_PUDDLE
	cp TILEINDEX_FD-TILEINDEX_PUDDLE+1
	ldh a,(<hFF8B)
	rla
	ldh (<hFF8B),a
	jr nc,@nextOffset

	xor $0f
	ldh (<hFF8B),a
	ldh a,(<hActiveObject)
	ld d,a
	ret


;;
; @param	hl	Pointer to counter1
waterTektike_setSpeedFromCounter1:
	ld a,(hl)
	srl a
	srl a
	ld hl,@speedVals
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	ret

@speedVals:
	.db SPEED_020 SPEED_040 SPEED_080 SPEED_0c0 SPEED_100 SPEED_140 SPEED_140 SPEED_140
	.db SPEED_100 SPEED_100 SPEED_0c0 SPEED_0c0 SPEED_080 SPEED_080 SPEED_040 SPEED_040
