; ==================================================================================================
; PART_DETECTION_HELPER
;
; Variables (for subid 0, the "controller"):
;   counter1: Countdown until firing another detection projectile forward
;   counter2: Countdown until firing another detection projectile in an arbitrary
;             direction (for close-range detection)
; ==================================================================================================
partCode0e:
	jp nz,partDelete
	ld e,Part.subid
	ld a,(de)
	ld e,Part.state
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3


; The "controller" (spawns other subids)
@subid0:
	ld a,(de)
	or a
	jr z,@subid0_state0

@subid0_state1:
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,partDelete

	; Copy parent's angle and position
	ld e,Part.angle
	ld a,l
	or Object.angle
	ld l,a
	ld a,(hl)
	ld (de),a
	call objectTakePosition

	; Countdown to spawn a "detection projectile" forward
	call partCommon_decCounter1IfNonzero
	jr nz,++

	ld (hl),$0f ; [counter1]
	ld e,Part.angle
	ld a,(de)
	ld b,a
	ld e,$01
	call @spawnCollisionHelper
++
	; Countdown to spawn "detection projectiles" to the sides, for nearby detection
	ld h,d
	ld l,Part.counter2
	dec (hl)
	ret nz

	ld (hl),$06 ; [counter2]

	ld l,Part.var03
	ld a,(hl)
	inc a
	and $03
	ld (hl),a

	ld c,a
	ld l,Part.angle
	ld b,(hl)
	ld e,$02
	call @spawnCollisionHelper
	ld e,$03


;;
; @param	b	Angle
; @param	c	var03
; @param	e	Subid
@spawnCollisionHelper:
	call getFreePartSlot
	ret nz
	ld (hl),PART_DETECTION_HELPER
	inc l
	ld (hl),e
	inc l
	ld (hl),c

	call objectCopyPosition
	ld l,Part.angle
	ld (hl),b

	ld l,Part.relatedObj1
	ld e,l
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a
	ret

@subid0_state0:
	ld h,d
	ld l,e
	inc (hl) ; [subid]

	ld l,Part.counter1
	inc (hl)
	inc l
	inc (hl) ; [counter2]
	ret


; This "moves" in a prescribed direction. If it hits Link, it triggers the guard; if it
; hits a wall, it deletes itself.
@subid1:
	ld a,(de)
	or a
	jr z,@subid1_state0


@subid1_state1:
	call objectCheckCollidedWithLink_ignoreZ
	jr c,@sawLink

	; Move forward, delete self if hit a wall
	call objectApplyComponentSpeed
	call objectCheckSimpleCollision
	ret z
	jr @delete

@sawLink:
	ld a,Object.var3b
	call objectGetRelatedObject1Var
	ld (hl),$ff
@delete:
	jp partDelete


@subid1_state0:
	inc a
	ld (de),a ; [state]

	; Determine collision radii depending on angle
	ld e,Part.angle
	ld a,(de)
	add $04
	and $08
	rrca
	rrca
	ld hl,@collisionRadii
	rst_addAToHl
	ld e,Part.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	jp @initSpeed

@collisionRadii:
	.db $02 $01 ; Up/down
	.db $01 $02 ; Left/right


; Like subid 1, but this only lasts for 4 frames, and it detects Link at various angles
; relative to the guard (determined by var03). Used for close-range detection in any
; direction.
@subid2:
@subid3:
	ld a,(de)
	or a
	jr z,@subid2_state0


@subid2_state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@subid1_state1
	jr @delete


@subid2_state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),$04

	ld l,Part.var03
	ld a,(hl)
	inc a
	add a
	dec l
	bit 0,(hl) ; [subid]
	jr nz,++
	cpl
	inc a
++
	ld l,Part.angle
	add (hl)
	and $1f
	ld (hl),a

;;
@initSpeed:
	ld h,d
	ld l,Part.angle
	ld c,(hl)
	ld b,SPEED_280
	ld a,$04
	jp objectSetComponentSpeedByScaledVelocity
