;;
; @param[out]	zflag	nz if there's a tile collision in the direction this part is
;			moving
; @addr{4000}
_partCommon_getTileCollisionInFront:
	ld e,Part.angle		; $4000
	ld a,(de)		; $4002

;;
; @param	a	Angle
; @param[out]	bc	Position
; @param[out]	zflag	nz if there's a tile collision in that direction
; @addr{4003}
_partCommon_getTileCollisionAtAngle:
	add $02			; $4003
	and $1c			; $4005
	rrca			; $4007
	ld hl,_partCommon_anglePositionOffsets		; $4008
	rst_addAToHl			; $400b
	ld e,Part.yh		; $400c
	ld a,(de)		; $400e
	add (hl)		; $400f
	ld b,a			; $4010
	ld e,Part.xh		; $4011
	inc hl			; $4013
	ld a,(de)		; $4014
	add (hl)		; $4015
	ld c,a			; $4016
	jp getTileCollisionsAtPosition		; $4017


; Position offsets used by specific angle values to check when it should be considered
; "off-screen".
_partCommon_anglePositionOffsets:
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
; @addr{402a}
_partCommon_getTileCollisionAtAngle_allowHoles:
	call _partCommon_getTileCollisionAtAngle		; $402a
	ret z			; $402d
	jr +++			; $402e

;;
; @param[out]	cflag	c if there's a collision
; @addr{4030}
_partCommon_getTileCollisionInFront_allowHoles:
	call _partCommon_getTileCollisionInFront		; $4030
	ret z			; $4033
+++
	add $01			; $4034
	ret c ; Check for SPECIALCOLLISION_SCREEN_BOUNDARY
	dec a			; $4037
	jp checkGivenCollision_allowHoles		; $4038

;;
; Analagous to the "enemyStandardUpdate" function.
; @addr{403b}
partCommon_standardUpdate:
	ld h,d			; $403b
	ld l,Part.state		; $403c
	ld a,(hl)		; $403e
	or a			; $403f
	jr z,@uninitialized	; $4040

	ld l,Part.invincibilityCounter		; $4042
	ld a,(hl)		; $4044
	or a			; $4045
	jr z,@doneUpdatingInvincibility	; $4046
	rlca			; $4048
	jr nc,++		; $4049
	inc (hl)		; $404b
	jr @doneUpdatingInvincibility		; $404c
++
	dec (hl)		; $404e

@doneUpdatingInvincibility:
	dec l			; $404f
	bit 7,(hl) ; [Part.var2a]
	jr nz,@collision	; $4052
	dec l			; $4054
	ld a,(hl) ; [Part.health]
	or a			; $4056
	jr z,@dead	; $4057
	ld c,PARTSTATUS_NORMAL		; $4059
	ret			; $405b

@uninitialized:
	callab bank3f.partLoadGraphicsAndProperties		; $405c
	ld e,Part.var3e		; $4064
	ld a,$08 ; TODO: what's this
	ld (de),a		; $4068
	ld c,PARTSTATUS_NORMAL		; $4069
	ret			; $406b

@collision:
	ld c,PARTSTATUS_JUST_HIT		; $406c
	ret			; $406e

@dead:
	ld c,PARTSTATUS_DEAD		; $406f
	ret			; $4071


;;
; Checks for collisions. Considers "screen boundaries" to be collisions.
;
; @param[out]	zflag	z if collision occurred
; @addr{4072}
partCommon_checkTileCollisionOrOutOfBounds:
	call objectGetTileCollisions		; $4072
	add $01 ; Check for SPECIALCOLLISION_SCREEN_BOUNDARY
	ret z			; $4077
	call checkTileCollision_allowHoles		; $4078
	ret c			; $407b
	or d			; $407c
	ret			; $407d

;;
; @param[out]	zflag	z if out of bounds
; @addr{407e}
partCommon_checkOutOfBounds:
	ld h,d			; $407e
	ld l,Part.yh		; $407f
	ld b,(hl)		; $4081
	ld l,Part.xh		; $4082
	ld c,(hl)		; $4084

	call @roundAngleToDiagonal		; $4085
	ld a,e			; $4088
	rrca			; $4089
	ld hl,_partCommon_anglePositionOffsets		; $408a
	rst_addAToHl			; $408d

	ldi a,(hl)		; $408e
	add b			; $408f
	ld b,a			; $4090
	ld a,(hl)		; $4091
	add c			; $4092
	ld c,a			; $4093

	call getTileCollisionsAtPosition		; $4094
	inc a			; $4097
	ret			; $4098

@roundAngleToDiagonal:
	ld l,Part.angle		; $4099
	ld a,(hl)		; $409b
	ld e,a			; $409c
	and $07			; $409d
	ret z			; $409f
	ld a,e			; $40a0
	and $18			; $40a1
	add $04			; $40a3
	ld e,a			; $40a5
	ret			; $40a6

;;
; @param[out]	zflag	Set if counter1 is zero
; @addr{40a7}
partCommon_decCounter1IfNonzero:
	ld h,d			; $40a7
	ld l,Part.counter1		; $40a8
	ld a,(hl)		; $40aa
	or a			; $40ab
	ret z			; $40ac
	dec (hl)		; $40ad
	ret			; $40ae

;;
; Reverses direction & bounces upward when collisions are enabled?
; @addr{40af}
_partCommon_bounceWhenCollisionsEnabled:
	ld h,d			; $40af
	ld l,Part.collisionType		; $40b0
	bit 7,(hl)		; $40b2
	ret z			; $40b4

	res 7,(hl)		; $40b5

	call partSetAnimation		; $40b7
	ld bc,-$e0		; $40ba
	call objectSetSpeedZ		; $40bd

	ld l,Part.counter1		; $40c0
	ld (hl),$20		; $40c2
	ld l,Part.speed		; $40c4
	ld (hl),SPEED_40		; $40c6
	ld l,Part.angle		; $40c8
	ld a,(hl)		; $40ca
	xor $10			; $40cb
	ld (hl),a		; $40cd
	ret			; $40ce

;;
; @addr{40cf}
_partCommon_updateSpeedAndDeleteWhenCounter1Is0:
	call partCommon_decCounter1IfNonzero		; $40cf
	jp z,partDelete		; $40d2
	ld c,$0e		; $40d5
	call objectUpdateSpeedZ_paramC		; $40d7
	call partAnimate		; $40da
	jp objectApplySpeed		; $40dd

;;
; @addr{40e0}
_partCommon_setPositionOffsetAndRadiusFromAngle:
	ld e,Part.angle		; $40e0
	ld a,(de)		; $40e2
	add $04			; $40e3
	and $18			; $40e5
	rrca			; $40e7
	ld hl,@data		; $40e8
	rst_addAToHl			; $40eb

	ld e,Part.yh		; $40ec
	ldi a,(hl)		; $40ee
	add b			; $40ef
	ld (de),a		; $40f0
	ld e,Part.xh		; $40f1
	ldi a,(hl)		; $40f3
	add c			; $40f4
	ld (de),a		; $40f5
	ld e,Part.collisionRadiusY		; $40f6
	ldi a,(hl)		; $40f8
	ld (de),a		; $40f9
	inc e			; $40fa
	ld a,(hl)		; $40fb
	ld (de),a ; Part.collisionRadiusX
	ret			; $40fd

; Data format: Y offset, X offset, collisionRadiusY, collisionRadiusX
@data:
	.db $f8 $fb $06 $03 ; DIR_UP
	.db $02 $08 $03 $06 ; DIR_RIGHT
	.db $08 $05 $06 $03 ; DIR_DOWN
	.db $02 $f8 $03 $06 ; DIR_LEFT

;;
; @addr{410e}
_partCommon_incState2:
	ld h,d			; $410e
	ld l,Part.state2		; $410f
	inc (hl)		; $4111
	ret			; $4112
