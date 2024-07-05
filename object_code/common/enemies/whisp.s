; ==================================================================================================
; ENEMY_WHISP
; ==================================================================================================
enemyCode19:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

	ld e,Enemy.var2a
	ld a,(de)
	res 7,a
	sub ITEMCOLLISION_L1_BOOMERANG
	cp MAX_BOOMERANG_LEVEL
	jr nc,@normalStatus

	; Hit with boomerang
	ld e,Enemy.state
	ld a,(de)
	cp $09
	jr nc,@normalStatus
	ld a,$09
	ld (de),a

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw whisp_state_uninitialized
	.dw spark_state_stub
	.dw spark_state_stub
	.dw spark_state_stub
	.dw spark_state_stub
	.dw ecom_blownByGaleSeedState
	.dw spark_state_stub
	.dw spark_state_stub
	.dw whisp_state8
	.dw spark_state9
	.dw spark_stateA


whisp_state_uninitialized:
	call getRandomNumber_noPreserveVars
	and $18
	add $04
	ld e,Enemy.angle
	ld (de),a

	ld a,SPEED_c0
	call ecom_setSpeedAndState8

	jp objectSetVisible82


whisp_state8:
	call ecom_bounceOffWalls
	call objectApplySpeed
	jp enemyAnimate


;;
; Updates the spark's moving angle by checking for walls, updating angle appropriately.
; Sparks move by hugging walls.
spark_updateAngle:
	ld a,$01
	ldh (<hFF8A),a

	; Confirm that we're still up against a wall
	ld e,Enemy.angle
	ld a,(de)
	sub $08
	and $18
	call spark_checkWallInDirection
	jr c,++

	; The wall has gone missing, but don't update angle until we're centered by
	; 8 pixels.
	call spark_getTileOffset
	ret nz

	ld e,Enemy.angle
	ld a,(de)
	sub $08
	and $18
	ld (de),a
	ret
++
	; We're still hugging a wall, but check if we're running into one now.
	ld e,Enemy.angle
	ld a,(de)
	call spark_checkWallInDirection
	ret nc

	ld e,Enemy.angle
	ld a,(de)
	add $08
	and $18
	ld (de),a
	ret


;;
; @param[out]	a	Angle relative to enemy where wall is (only valid if cflag is set)
; @param[out]	cflag	c if there is a wall in any direction, nc otherwise
spark_getWallAngle:
	xor a
	call spark_checkWallInDirection
	ld a,$08
	ret c
	call spark_checkWallInDirection
	ld a,$10
	ret c
	call spark_checkWallInDirection
	ld a,$18
	ret c
	xor a
	ret

;;
; @param[out]	a	A value from 0-7, indicating the offset within a quarter-tile the
;			whisp is at. When this is 0, it needs to check for a direction
;			change?
spark_getTileOffset:
	ld e,Enemy.angle
	ld a,(de)
	bit 3,a
	jr nz,++
	ld e,Enemy.yh
	ld a,(de)
	and $07
	ret
++
	ld e,Enemy.xh
	ld a,(de)
	and $07
	ret

;;
; @param	a	Angle to check
; @param[out]	cflag	c if there's a solid wall in that direction
spark_checkWallInDirection:
	and $18
	rrca
	ld hl,@offsetTable
	rst_addAToHl
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld b,a

	inc hl
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	ld c,a

	push hl
	push bc
	call checkTileCollisionAt_disallowHoles
	pop bc
	pop hl
	ret c

	inc hl
	ldi a,(hl)
	add b
	ld b,a
	ld a,(hl)
	add c
	ld c,a
	jp checkTileCollisionAt_disallowHoles


; Each direction lists two position offsets to check for collisions at.
@offsetTable:
	.db $f7 $fc $00 $07 ; DIR_UP
	.db $fc $08 $07 $00 ; DIR_RIGHT
	.db $08 $fc $00 $07 ; DIR_DOWN
	.db $fc $f7 $07 $00 ; DIR_LEFT
