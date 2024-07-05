; ==================================================================================================
; PART_BLUE_STALFOS_PROJECTILE
;
; Variables:
;   var03: 0 for reflectable ball type, 1 otherwise
;   relatedObj1: Instance of ENEMY_BLUE_STALFOS
; ==================================================================================================
partCode3d:
	jr z,@normalStatus

	ld h,d
	ld l,Part.subid
	ldi a,(hl)
	or (hl)
	jr nz,@normalStatus

	; Check if hit Link
	ld l,Part.var2a
	ld a,(hl)
	res 7,a
	or a ; ITEMCOLLISION_LINK
	jp z,blueStalfosProjectile_hitLink

	; Check if hit Link's sword
	sub ITEMCOLLISION_L1_SWORD
	cp ITEMCOLLISION_SWORDSPIN - ITEMCOLLISION_L1_SWORD + 1
	jr nc,@normalStatus

	; Reflect the ball if not already reflected
	ld l,Part.state
	ld a,(hl)
	cp $04
	jr nc,@normalStatus

	ld (hl),$04
	ld l,Part.speed
	ld (hl),SPEED_200
	ld a,SND_UNKNOWN3
	call playSound

@normalStatus:
	ld e,Part.subid
	ld a,(de)
	rst_jumpTable
	.dw blueStalfosProjectile_subid0
	.dw blueStalfosProjectile_subid1


blueStalfosProjectile_subid0:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

; Initialization, deciding which ball type this should be
@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),40

	ld l,Part.yh
	ld a,(hl)
	sub $18
	ld (hl),a

	ld l,Part.speed
	ld (hl),SPEED_180

	push hl
	ld a,Object.var32
	call objectGetRelatedObject1Var
	ld a,(hl)
	inc a
	and $07
	ld (hl),a

	ld hl,@ballPatterns
	call checkFlag
	pop hl
	jr z,++

	; Non-reflectable ball
	ld (hl),SPEED_200
	ld l,Part.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO
	ld l,Part.var03
	inc (hl)
++
	ld a,SND_BLUE_STALFOS_CHARGE
	call playSound
	jp objectSetVisible81

; A bit being 0 means the ball will be reflectable. Cycles through the next bit every time
; a projectile is created.
@ballPatterns:
	.db %10101101


; Charging
@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate

	ld (hl),40 ; [counter1]
	inc l
	inc (hl) ; [counter2]
	ld a,(hl)
	cp $03
	jp c,partSetAnimation

	; Done charging
	ld (hl),20 ; [counter2]
	dec l
	ld (hl),$00 ; [counter1]

	ld l,e
	inc (hl) ; [state]

	ld l,Part.collisionType
	set 7,(hl)

	call objectGetAngleTowardEnemyTarget
	ld e,Part.angle
	ld (de),a

	ld e,Part.var03
	ld a,(de)
	add $02
	call partSetAnimation
	ld a,SND_BEAM1
	call playSound
	jr @animate


; Ball is moving (either version)
@state2:
	ld h,d
	ld l,Part.counter2
	dec (hl)
	jr nz,+
	ld l,e
	inc (hl) ; [state]
+
	call blueStalfosProjectile_checkShouldExplode
	jr blueStalfosProjectile_applySpeed


; Ball is moving (baby ball only)
@state3:
	call blueStalfosProjectile_checkShouldExplode
	jr blueStalfosProjectile_applySpeedAndDeleteIfOffScreen


; Ball was just reflected (baby ball only)
@state4:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	call objectGetAngleTowardEnemyTarget
	xor $10
	ld e,Part.angle
	ld (de),a
@animate:
	jp partAnimate


; Ball is moving after being reflected (baby ball only)
@state5:
	call blueStalfosProjectile_checkCollidedWithStalfos
	jp c,partDelete
	jr blueStalfosProjectile_applySpeedAndDeleteIfOffScreen


; Splits into 6 smaller projectiles (subid 1)
@state6:
	ld b,$06
	call checkBPartSlotsAvailable
	ret nz
	call blueStalfosProjectile_explode
	ld a,SND_BEAM
	call playSound
	jp partDelete


; Smaller projectile created from the explosion of the larger one
blueStalfosProjectile_subid1:
	ld e,Part.state
	ld a,(de)
	or a
	jr z,blueStalfosProjectile_subid1_uninitialized

blueStalfosProjectile_applySpeedAndDeleteIfOffScreen:
	call partCommon_checkOutOfBounds
	jp z,partDelete

blueStalfosProjectile_applySpeed:
	call objectApplySpeed
	jp partAnimate


blueStalfosProjectile_subid1_uninitialized:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.collisionType
	set 7,(hl)
	ld l,Part.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO

	ld l,Part.speed
	ld (hl),SPEED_1c0

	ld l,Part.damage
	ld (hl),-4

	ld l,Part.collisionRadiusY
	ld a,$02
	ldi (hl),a
	ld (hl),a

	add a ; a = 4
	call partSetAnimation
	jp objectSetVisible81


;;
; Explodes the projectile (sets state to 6) if it's the correct type and is close to Link.
; Returns from caller if so.
blueStalfosProjectile_checkShouldExplode:
	ld a,(wFrameCounter)
	and $07
	ret nz

	call partCommon_decCounter1IfNonzero
	ret nz

	ld c,$28
	call objectCheckLinkWithinDistance
	ret nc

	ld h,d
	ld l,Part.counter1
	dec (hl)
	ld e,Part.var03
	ld a,(de)
	or a
	ret z

	pop bc ; Discard return address

	ld l,Part.collisionType
	res 7,(hl)
	ld l,Part.state
	ld (hl),$06
	ret


;;
; @param[out]	cflag	c on collision
blueStalfosProjectile_checkCollidedWithStalfos:
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	call checkObjectsCollided
	ret nc

	ld l,Enemy.invincibilityCounter
	ld (hl),30
	ld l,Enemy.state
	ld (hl),$14
	ret


;;
; Explodes into six parts
blueStalfosProjectile_explode:
	ld c,$06
@next:
	call getFreePartSlot
	ld (hl),PART_BLUE_STALFOS_PROJECTILE
	inc l
	inc (hl) ; [subid] = 1

	call objectCopyPosition

	; Copy ENEMY_BLUE_STALFOS reference to new projectile
	ld l,Part.relatedObj1
	ld e,l
	ld a,(de)
	ldi (hl),a
	ld e,l
	ld a,(de)
	ld (hl),a

	; Set angle
	ld b,h
	ld a,c
	ld hl,@angleVals
	rst_addAToHl
	ld a,(hl)
	ld h,b
	ld l,Part.angle
	ld (hl),a

	dec c
	jr nz,@next
	ret

@angleVals:
	.db $00 $00 $05 $0b $10 $15 $1b

blueStalfosProjectile_hitLink:
	; [blueStalfos.state] = $10
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld (hl),$10

	jp partDelete
