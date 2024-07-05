; ==================================================================================================
; PART_PLASMARINE_PROJECTILE
; ==================================================================================================
partCode43:
	jr nz,@delete

	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMY_PLASMARINE
	jr nz,@delete

	ld e,Part.state
	ld a,(de)
	or a
	jr z,@state0

@state1:
	; If projectile's color is different from plasmarine's color...
	ld l,Enemy.var32
	ld e,Part.subid
	ld a,(de)
	cp (hl)
	jr z,@noCollision

	; Check for collision.
	call checkObjectsCollided
	jr c,@collidedWithPlasmarine

@noCollision:
	ld a,(wFrameCounter)
	rrca
	jr c,@updateMovement

	call partCommon_decCounter1IfNonzero
	jp z,partDelete

	; Flicker visibility for 30 frames or less remaining
	ld a,(hl)
	cp 30
	jr nc,++
	ld e,Part.visible
	ld a,(de)
	xor $80
	ld (de),a
++
	; Slowly home in on Link
	inc l
	dec (hl) ; [this.counter2]--
	jr nz,@updateMovement
	ld (hl),$10
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards

@updateMovement:
	call objectApplySpeed
	call partCommon_checkOutOfBounds
	jp nz,partAnimate
	jr @delete

@collidedWithPlasmarine:
	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	jr nz,@noCollision

	ld (hl),24
	ld l,Enemy.health
	dec (hl)
	jr nz,++

	; Plasmarine is dead
	ld l,Enemy.collisionType
	res 7,(hl)
++
	ld a,SND_BOSS_DAMAGE
	call playSound
@delete:
	jp partDelete


@state0:
	ld l,Enemy.health
	ld a,(hl)
	cp $03
	ld a,SPEED_80
	jr nc,+
	ld a,SPEED_e0
+
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.speed
	ld (hl),a

	ld l,Part.counter1
	ld (hl),150 ; [counter1] (lifetime counter)
	inc l
	ld (hl),$08 ; [counter2]

	; Set color & animation
	ld l,Part.subid
	ld a,(hl)
	inc a
	ld l,Part.oamFlags
	ldd (hl),a
	ld (hl),a
	dec a
	call partSetAnimation

	; Move toward Link
	call objectGetAngleTowardEnemyTarget
	ld e,Part.angle
	ld (de),a

	jp objectSetVisible82
