; ==================================================================================================
; PART_SMOG_PROJECTILE
; ==================================================================================================
partCode4a:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a ; [state] = 1

	call objectSetVisible81

	call objectGetAngleTowardLink
	ld e,Part.angle
	ld (de),a
	ld c,a

	ld a,SPEED_c0
	ld e,Part.speed
	ld (de),a

	; Check if this is a projectile from a large smog or a small smog
	ld e,Part.subid
	ld a,(de)
	or a
	jr z,@setAnimation

	; If from a large smog, change some properties
	ld a,SPEED_100
	ld e,Part.speed
	ld (de),a

	ld a,$05
	ld e,Part.oamFlags
	ld (de),a

	ld e,Part.enemyCollisionMode
	ld a,ENEMYCOLLISION_PODOBOO
	ld (de),a

	ld a,c
	call convertAngleToDirection
	and $01
	add $02

@setAnimation:
	call partSetAnimation

@state1:
	; Delete self if boss defeated
	call getThisRoomFlags
	bit 6,a
	jr nz,@delete

	ld a,(wNumEnemies)
	dec a
	jr z,@delete

	call objectCheckWithinScreenBoundary
	jr nc,@delete

	call objectApplySpeed

	; If large smog's projectile, return (it passes through everything)
	ld e,Part.subid
	ld a,(de)
	or a
	ret nz

	; Check for collision with items
	ld e,Part.var2a
	ld a,(de)
	or a
	jr nz,@beginDestroyAnimation

	; Check for collision with wall
	call partCommon_getTileCollisionInFront
	jr z,@state2

@beginDestroyAnimation:
	ld h,d
	ld l,Part.collisionType
	res 7,(hl)

	ld a,$02
	ld l,Part.state
	ld (hl),a

	dec a
	call partSetAnimation


@state2:
	call partAnimate
	ld e,Part.animParameter
	ld a,(de)
	or a
	ret z
@delete:
	jp partDelete
