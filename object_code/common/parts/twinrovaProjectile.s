; ==================================================================================================
; PART_RED_TWINROVA_PROJECTILE
; PART_BLUE_TWINROVA_PROJECTILE
;
; Variables:
;   relatedObj1: Instance of ENEMY_TWINROVA that fired the projectile
;   relatedObj2: Instance of ENEMY_TWINROVA that could be hit by the projectile
; ==================================================================================================
partCode4b:
partCode4d:
	jr z,@normalStatus

	ld e,Part.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_L3_SHIELD
	jp z,partDelete

	cp $80|ITEMCOLLISION_LINK
	jr z,@normalStatus

	; Gets reflected
	call objectGetAngleTowardEnemyTarget
	xor $10
	ld h,d
	ld l,Part.angle
	ld (hl),a
	ld l,Part.state
	ld (hl),$03
	ld l,Part.speed
	ld (hl),SPEED_280

@normalStatus:
	; Check if twinrova is dead
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0d
	jp nc,@deleteWithPoof

	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.counter1
	ld (hl),30
	ld l,Part.speed
	ld (hl),SPEED_200

	; Transfer z-position to y-position
	ld l,Part.zh
	ld a,(hl)
	ld (hl),$00
	ld l,Part.yh
	add (hl)
	ld (hl),a

	; Get the other twinrova object, put it in relatedObj2
	ld a,Object.relatedObj1
	call objectGetRelatedObject1Var
	ld e,Part.relatedObj2
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	; Play sound depending which one it is
	ld e,Part.id
	ld a,(de)
	cp PART_RED_TWINROVA_PROJECTILE
	ld a,SND_BEAM1
	jr z,+
	ld a,SND_BEAM2
+
	call playSound
	call objectSetVisible81

; Being charged up
@state1:
	call partCommon_decCounter1IfNonzero
	jr z,@fire

	; Copy parent's position
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld bc,$ea00
	call objectTakePositionWithOffset
	xor a
	ld (de),a ; [zh] = 0
	jr @animate

@fire:
	call objectGetAngleTowardEnemyTarget
	ld e,Part.angle
	ld (de),a

	ld h,d
	ld l,Part.state
	inc (hl) ; [state] = 2

	ld l,Part.collisionType
	set 7,(hl)

; Moving
@state2:
	call objectApplySpeed
	call partCommon_checkOutOfBounds
	jr z,@delete
@animate:
	jp partAnimate

@state3:
	ld a,$00
	call objectGetRelatedObject2Var
	call checkObjectsCollided
	jr nc,@state2

	; Collided with opposite-color twinrova
	ld l,Enemy.invincibilityCounter
	ld (hl),20
	ld l,Enemy.health
	dec (hl)
	jr nz,++

	; Other twinrova's health is 0; set a signal.
	ld l,Enemy.var32
	set 6,(hl)
++
	; Decrement health of same-color twinrova as well
	ld a,Object.health
	call objectGetRelatedObject1Var
	dec (hl)

	ld a,SND_BOSS_DAMAGE
	call playSound
@delete:
	jp partDelete

@deleteWithPoof:
	call objectCreatePuff
	jp partDelete
