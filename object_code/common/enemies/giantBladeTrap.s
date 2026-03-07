; ==================================================================================================
; ENEMY_GIANT_BLADE_TRAP
; ==================================================================================================
enemyCode2a:
	; Return for ENEMYSTATUS_01 or ENEMYSTATUS_STUNNED
	dec a
	ret z
	dec a
	ret z

	call ecom_getSubidAndCpStateTo08
	jr c,@commonState
	ld a,b
	rst_jumpTable
	.dw giantBladeTrap_subid00
	.dw giantBladeTrap_subid01
	.dw giantBladeTrap_subid02
	.dw giantBladeTrap_subid03

@commonState:
	rst_jumpTable
	.dw giantBladeTrap_state_uninitialized
	.dw giantBladeTrap_state_stub
	.dw giantBladeTrap_state_stub
	.dw giantBladeTrap_state_stub
	.dw giantBladeTrap_state_stub
	.dw giantBladeTrap_state_stub
	.dw giantBladeTrap_state_stub
	.dw giantBladeTrap_state_stub


giantBladeTrap_state_uninitialized:
	call ecom_setSpeedAndState8
	jp objectSetVisible82


giantBladeTrap_state_stub:
	ret


giantBladeTrap_subid00:
	ret


giantBladeTrap_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw giantBladeTrap_subid01_state8
	.dw giantBladeTrap_subid01_state9
	.dw giantBladeTrap_subid01_stateA


; Choosing initial direction to move.
giantBladeTrap_subid01_state8:
	ld a,$09
	ld (de),a ; [state] = 9
	call giantBladeTrap_chooseInitialAngle
	ld e,Enemy.speed
	ld a,SPEED_80
	ld (de),a
	ret


; Move until hitting a wall.
giantBladeTrap_subid01_state9:
	call giantBladeTrap_checkCanMoveInDirection
	jp z,objectApplySpeed
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$10
	ret


; Wait 16 frames, then change directions and start moving again.
giantBladeTrap_subid01_stateA:
	call ecom_decCounter1
	ret nz

	ld l,e
	dec (hl) ; [state]--

	; Rotate angle clockwise
	ld l,Enemy.angle
	ld a,(hl)
	add $08
	and $18
	ld (hl),a
	ret


giantBladeTrap_subid02:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw giantBladeTrap_subid02_state8
	.dw giantBladeTrap_commonState9
	.dw giantBladeTrap_subid02_stateA


; Initialization
giantBladeTrap_subid02_state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),60
	ret


; Accelerate until hitting a wall.
giantBladeTrap_commonState9:
	call giantBladeTrap_updateSpeed
	call giantBladeTrap_checkCanMoveInDirection
	jp z,objectApplySpeed

	call ecom_incState

	; Round Y, X to center of tile
	ld l,Enemy.yh
	ld a,(hl)
	add $02
	and $f8
	ldi (hl),a
	inc l
	ld a,(hl)
	add $02
	and $f8
	ld (hl),a

	ld l,Enemy.counter1
	ld (hl),$10
	ret


; Hit a wall, waiting for a bit then changing direction.
giantBladeTrap_subid02_stateA:
	call ecom_decCounter1
	ret nz

	; Rotate angle clockwise
	ld e,Enemy.angle
	ld a,(de)
	add $08
	and $1f
	ld (de),a

	call giantBladeTrap_checkCanMoveInDirection
	jr z,@canMove

	; Can't move this way; try reversing direction.
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	ld (de),a
	call giantBladeTrap_checkCanMoveInDirection
	jr z,@canMove

	; Can't move backward either; try another direction.
	ld e,Enemy.angle
	ld a,(de)
	sub $08
	and $1f
	ld (de),a

@canMove:
	 ; Return to state 9
	ld h,d
	ld l,Enemy.state
	dec (hl)
	ld l,Enemy.counter1
	ld (hl),90
	ret


giantBladeTrap_subid03:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw giantBladeTrap_subid03_state8
	.dw giantBladeTrap_commonState9
	.dw giantBladeTrap_subid03_stateA


; Initialization
giantBladeTrap_subid03_state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.angle
	ld (hl),$10
	ld l,Enemy.counter1
	ld (hl),90
	ret


; Hit a wall, waiting for a bit then changing direction.
giantBladeTrap_subid03_stateA:
	call ecom_decCounter1
	ret nz

	; Rotate angle counterclockwise
	ld e,Enemy.angle
	ld a,(de)
	sub $08
	and $1f
	ld (de),a

	call giantBladeTrap_checkCanMoveInDirection
	jr z,@canMove

	; Can't move this way; try reversing direction.
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	ld (de),a
	call giantBladeTrap_checkCanMoveInDirection
	jr z,@canMove

	; Can't move backward either; try another direction.
	ld e,Enemy.angle
	ld a,(de)
	add $08
	and $1f
	ld (de),a

@canMove:
	; Return to state 9
	ld h,d
	ld l,Enemy.state
	dec (hl)
	ld l,Enemy.counter1
	ld (hl),90
	ret


;;
; Subid 1 only; check all directions, choose which way to go.
giantBladeTrap_chooseInitialAngle:
	call giantBladeTrap_checkCanMoveInDirection
	ld a,ANGLE_RIGHT
	jr nz,@setAngle

	ld e,Enemy.angle
	ld (de),a
	call giantBladeTrap_checkCanMoveInDirection
	ld a,ANGLE_DOWN
	jr nz,@setAngle

	ld e,Enemy.angle
	ld (de),a
	call giantBladeTrap_checkCanMoveInDirection
	ld a,ANGLE_LEFT
	jr nz,@setAngle

	xor a
@setAngle:
	ld e,Enemy.angle
	ld (de),a
	ret

;;
; Based on current angle value, this checks if it can move in that direction (it is not
; blocked by solid tiles directly ahead).
;
; @param[out]	zflag	z if it can move in this direction.
giantBladeTrap_checkCanMoveInDirection:
	ld e,Enemy.yh
	ld a,(de)
	ld b,a
	ld e,Enemy.xh
	ld a,(de)
	ld c,a

	ld e,Enemy.angle
	ld a,(de)
	rrca
	ld hl,@positionOffsets
	rst_addAToHl
	push de
	ld d,>wRoomCollisions
	call @checkTileAtOffsetSolid
	jr nz,+
	call @checkTileAtOffsetSolid
+
	pop de
	ret

;;
; @param	bc	Position
; @param	hl	Pointer to position offsets
; @param[out]	zflag	z if tile is solid
@checkTileAtOffsetSolid:
	ldi a,(hl)
	add b
	and $f0
	ld e,a
	ldi a,(hl)
	add c
	swap a
	and $0f
	or e
	ld e,a
	ld a,(de)
	or a
	ret

@positionOffsets:
	.db $ef $f8  $ef $07 ; DIR_UP
	.db $f8 $10  $07 $10 ; DIR_RIGHT
	.db $10 $f8  $10 $07 ; DIR_DOWN
	.db $f8 $ef  $07 $ef ; DIR_LEFT

;;
; Decrements counter1 and uses its value to determine speed. Lower values = higher speed.
giantBladeTrap_updateSpeed:
	ld e,Enemy.counter1
	ld a,(de)
	or a
	ret z
	ld a,(de)
	dec a
	ld (de),a

	and $f0
	swap a
	ld hl,@speeds
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	ret

@speeds:
	.db SPEED_280, SPEED_200, SPEED_180, SPEED_100, SPEED_80, SPEED_20
