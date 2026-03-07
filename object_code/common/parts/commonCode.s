;;
; @param[out]	zflag	nz if there's a tile collision in the direction this part is
;			moving
partCommon_getTileCollisionInFront:
	ld e,Part.angle
	ld a,(de)

;;
; @param	a	Angle
; @param[out]	bc	Position
; @param[out]	zflag	nz if there's a tile collision in that direction
partCommon_getTileCollisionAtAngle:
	add $02
	and $1c
	rrca
	ld hl,partCommon_anglePositionOffsets
	rst_addAToHl
	ld e,Part.yh
	ld a,(de)
	add (hl)
	ld b,a
	ld e,Part.xh
	inc hl
	ld a,(de)
	add (hl)
	ld c,a
	jp getTileCollisionsAtPosition


; Position offsets used by specific angle values to check when it should be considered
; "off-screen".
partCommon_anglePositionOffsets:
	.db $fb $00 ; Up
	.db $fb $04 ; Up/right
	.db $00 $04 ; Right
	.db $04 $04 ; Down/right
	.db $04 $00 ; Down
	.db $04 $fb ; Down/left
	.db $00 $fb ; Left
	.db $fb $fb ; Up/left

;;
; @param	a	Angle
; @param[out]	zflag
partCommon_getTileCollisionAtAngle_allowHoles:
	call partCommon_getTileCollisionAtAngle
	ret z
	jr +++

;;
; @param[out]	cflag	c if there's a collision
partCommon_getTileCollisionInFront_allowHoles:
	call partCommon_getTileCollisionInFront
	ret z
+++
	add $01
	ret c ; Check for SPECIALCOLLISION_SCREEN_BOUNDARY
	dec a
	jp checkGivenCollision_allowHoles

;;
; Analagous to the "enemyStandardUpdate" function.
partCommon_standardUpdate:
	ld h,d
	ld l,Part.state
	ld a,(hl)
	or a
	jr z,@uninitialized

	ld l,Part.invincibilityCounter
	ld a,(hl)
	or a
	jr z,@doneUpdatingInvincibility
	rlca
	jr nc,++
	inc (hl)
	jr @doneUpdatingInvincibility
++
	dec (hl)

@doneUpdatingInvincibility:
	dec l
	bit 7,(hl) ; [Part.var2a]
	jr nz,@collision
	dec l
	ld a,(hl) ; [Part.health]
	or a
	jr z,@dead
	ld c,PARTSTATUS_NORMAL
	ret

@uninitialized:
	callab bank3f.partLoadGraphicsAndProperties
	ld e,Part.var3e
	ld a,$08 ; TODO: what's this
	ld (de),a
	ld c,PARTSTATUS_NORMAL
	ret

@collision:
	ld c,PARTSTATUS_JUST_HIT
	ret

@dead:
	ld c,PARTSTATUS_DEAD
	ret


;;
; Checks for collisions. Considers "screen boundaries" to be collisions.
;
; @param[out]	zflag	z if collision occurred
partCommon_checkTileCollisionOrOutOfBounds:
	call objectGetTileCollisions
	add $01 ; Check for SPECIALCOLLISION_SCREEN_BOUNDARY
	ret z
	call checkTileCollision_allowHoles
	ret c
	or d
	ret

;;
; @param[out]	zflag	z if out of bounds
partCommon_checkOutOfBounds:
	ld h,d
	ld l,Part.yh
	ld b,(hl)
	ld l,Part.xh
	ld c,(hl)

	call @roundAngleToDiagonal
	ld a,e
	rrca
	ld hl,partCommon_anglePositionOffsets
	rst_addAToHl

	ldi a,(hl)
	add b
	ld b,a
	ld a,(hl)
	add c
	ld c,a

	call getTileCollisionsAtPosition
	inc a
	ret

@roundAngleToDiagonal:
	ld l,Part.angle
	ld a,(hl)
	ld e,a
	and $07
	ret z
	ld a,e
	and $18
	add $04
	ld e,a
	ret

;;
; @param[out]	zflag	Set if counter1 is zero
partCommon_decCounter1IfNonzero:
	ld h,d
	ld l,Part.counter1
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret

;;
; Reverses direction & bounces upward when collisions are enabled?
partCommon_bounceWhenCollisionsEnabled:
	ld h,d
	ld l,Part.collisionType
	bit 7,(hl)
	ret z

	res 7,(hl)

	call partSetAnimation
	ld bc,-$e0
	call objectSetSpeedZ

	ld l,Part.counter1
	ld (hl),$20
	ld l,Part.speed
	ld (hl),SPEED_40
	ld l,Part.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	ret

;;
partCommon_updateSpeedAndDeleteWhenCounter1Is0:
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	call partAnimate
	jp objectApplySpeed

;;
partCommon_setPositionOffsetAndRadiusFromAngle:
	ld e,Part.angle
	ld a,(de)
	add $04
	and $18
	rrca
	ld hl,@data
	rst_addAToHl

	ld e,Part.yh
	ldi a,(hl)
	add b
	ld (de),a
	ld e,Part.xh
	ldi a,(hl)
	add c
	ld (de),a
	ld e,Part.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a ; Part.collisionRadiusX
	ret

; Data format: Y offset, X offset, collisionRadiusY, collisionRadiusX
@data:
	.db $f8 $fb $06 $03 ; DIR_UP
	.db $02 $08 $03 $06 ; DIR_RIGHT
	.db $08 $05 $06 $03 ; DIR_DOWN
	.db $02 $f8 $03 $06 ; DIR_LEFT

;;
partCommon_incSubstate:
	ld h,d
	ld l,Part.substate
	inc (hl)
	ret
