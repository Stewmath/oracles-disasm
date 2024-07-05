; ==================================================================================================
; PART_VERAN_PROJECTILE
; ==================================================================================================
partCode37:
	jp nz,partDelete

	ld e,Part.subid
	ld a,(de)
	or a
	jp nz,veranProjectile_subid1


; The "core" projectile spawner
veranProjectile_subid0:
	ld a,Object.collisionType
	call objectGetRelatedObject1Var
	bit 7,(hl)
	jr z,@delete

	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.zh
	ld (hl),$fc
	jp objectSetVisible81


; Moving upward
@state1:
	ld h,d
	ld l,Part.zh
	dec (hl)

	ld a,(hl)
	cp $f0
	jr nz,@animate

	; Moved high enough to go to next state

	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),129
	jr @animate


; Firing projectiles every 8 frames until counter1 reaches 0
@state2:
	call partCommon_decCounter1IfNonzero
	jr z,@delete

	ld a,(hl)
	and $07
	jr nz,@animate

	; Calculate angle in 'b' based on counter1
	ld a,(hl)
	rrca
	rrca
	and $1f
	ld b,a

	; Create a projectile
	call getFreePartSlot
	jr nz,@animate
	ld (hl),PART_VERAN_PROJECTILE
	inc l
	inc (hl) ; [subid] = 1

	ld l,Part.angle
	ld (hl),b

	call objectCopyPosition

@animate:
	jp partAnimate

@delete:
	ldbc INTERAC_PUFF,$80
	call objectCreateInteraction
	jp partDelete


; An individiual projectile
veranProjectile_subid1:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.speed
	ld (hl),SPEED_280

	ld l,Part.collisionRadiusY
	ld a,$04
	ldi (hl),a
	ld (hl),a

	call objectSetVisible81

	ld a,SND_VERAN_PROJECTILE
	call playSound

	ld a,$01
	jp partSetAnimation


; Moving to ground as well as in normal direction
@state1:
	ld h,d
	ld l,Part.zh
	inc (hl)
	jr nz,@state2

	ld l,e
	inc (hl) ; [state]


; Just moving normally
@state2:
	call objectApplySpeed
	call partCommon_checkTileCollisionOrOutOfBounds
	ret nz
	jp partDelete
