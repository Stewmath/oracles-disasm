; ==================================================================================================
; PART_OCTOGON_DEPTH_CHARGE
;
; Variables:
;   var30: gravity
; ==================================================================================================
partCode48:
	jr z,@normalStatus

	; For subid 1 only, delete self on collision with anything?
	ld e,Part.subid
	ld a,(de)
	or a
	jp nz,partDelete

@normalStatus:
	ld e,Part.subid
	ld a,(de)
	or a
	ld e,Part.state
	jr z,octogonDepthCharge_subid0


; Small (split) projectile
octogonDepthCharge_subid1:
	ld a,(de)
	or a
	jr z,@state0

@state1:
	call objectApplySpeed
	call partCommon_checkTileCollisionOrOutOfBounds
	jp nz,partAnimate
	jp partDelete

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.collisionRadiusY
	ld a,$02
	ldi (hl),a
	ld (hl),a

	ld l,Part.speed
	ld (hl),SPEED_180
	ld a,$01
	call partSetAnimation
	jp objectSetVisible82


; Large projectile, before being split into 4 smaller ones (subid 1)
octogonDepthCharge_subid0:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,Object.visible
	call objectGetRelatedObject1Var
	ld a,(hl)

	ld h,d
	ld l,Part.state
	inc (hl)

	rlca
	jr c,@aboveWater

@belowWater:
	inc (hl) ; [state] = 2 (skips the "moving up" part)
	ld l,Part.counter1
	inc (hl)

	ld l,Part.zh
	ld (hl),$b8
	ld l,Part.var30
	ld (hl),$10

	; Choose random position to spawn at
	call getRandomNumber_noPreserveVars
	and $06
	ld hl,@positionCandidates
	rst_addAToHl
	ld e,Part.yh
	ldi a,(hl)
	ld (de),a
	ld e,Part.xh
	ld a,(hl)
	ld (de),a

	ld a,SND_SPLASH
	call playSound
	jr @setVisible81

@positionCandidates:
	.db $38 $48
	.db $38 $a8
	.db $78 $48
	.db $78 $a8

@aboveWater:
	; Is shot up before coming back down
	ld l,Part.var30
	ld (hl),$20

	ld l,Part.yh
	ld a,(hl)
	sub $10
	ld (hl),a

	ld a,SND_SCENT_SEED
	call playSound

@setVisible81:
	jp objectSetVisible81


; Above water: being shot up
@state1:
	ld h,d
	ld l,Part.zh
	dec (hl)
	dec (hl)

	ld a,(hl)
	cp $d0
	jr nc,@animate

	cp $b8
	jr nc,@flickerVisibility

	ld l,e
	inc (hl) ; [state] = 2

	ld l,Part.counter1
	ld (hl),30

	ld l,Part.collisionType
	res 7,(hl)

	ld l,Part.yh
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	inc l
	ldh a,(<hEnemyTargetX)
	ld (hl),a

	jp objectSetInvisible

@flickerVisibility:
	ld l,Part.visible
	ld a,(hl)
	xor $80
	ld (hl),a

@animate:
	jp partAnimate


; Delay before falling to ground
@state2:
	call partCommon_decCounter1IfNonzero
	ret nz

	ld l,e
	inc (hl) ; [state] = 3

	ld l,Part.collisionType
	set 7,(hl)
	jp objectSetVisiblec1


; Falling to ground
@state3:
	ld e,Part.var30
	ld a,(de)
	call objectUpdateSpeedZ
	jr nz,@animate

	; Hit ground; split into four, then delete self.
	call getRandomNumber_noPreserveVars
	and $04
	ld b,a
	ld c,$04

@spawnNext:
	call getFreePartSlot
	jr nz,++
	ld (hl),PART_OCTOGON_DEPTH_CHARGE
	inc l
	inc (hl) ; [subid] = 1
	ld l,Part.angle
	ld (hl),b
	call objectCopyPosition
	ld a,b
	add $08
	ld b,a
++
	dec c
	jr nz,@spawnNext

	ld a,SND_UNKNOWN3
	call playSound
	jp partDelete
