; ==================================================================================================
; ENEMY_DODONGO
;
; Variables:
;   var30: Animation base?
;   var31: Corresponds to direction Link was facing when he picked Dodongo up
;   var32: Index in the "attack pattern" ($00-$0f).
;   var33: Animation index?
; ==================================================================================================
enemyCode79:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyBoss_dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw dodongo_state_uninitialized
	.dw dodongo_state_stub
	.dw dodongo_state_grabbed
	.dw dodongo_state_stub
	.dw dodongo_state_stub
	.dw dodongo_state_stub
	.dw dodongo_state_stub
	.dw dodongo_state_stub
	.dw dodongo_state8
	.dw dodongo_state9
	.dw dodongo_stateA
	.dw dodongo_stateB
	.dw dodongo_stateC
	.dw dodongo_stateD

dodongo_state_uninitialized:
	ld bc,$0208
	call enemyBoss_spawnShadow
	ret nz

	ld a,ENEMY_DODONGO
	ld b,PALH_SEASONS_81
	call enemyBoss_initializeRoom

	ld e,Enemy.var33
	ld a,$04
	ld (de),a
	call enemySetAnimation

	call ecom_setSpeedAndState8
	jp objectSetVisible82


dodongo_state_grabbed:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @landed

@justGrabbed:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	ld a,$20
	ld (wLinkGrabState2),a

	ld l,Enemy.var31
	ld a,(w1Link.direction)
	add a
	add a
	ld (hl),a

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.counter2
	ld (hl),$01

	ld l,Enemy.var30
	ld (hl),$ff

	jp objectSetVisible81

@beingHeld:
	call dodongo_updateAnimationWhileHeld
	jr z,@dropDodongo

	; Slow down Link's movement
	ld a,(wFrameCounter)
	and $03
	ret z
	ld hl,wLinkImmobilized
	set 5,(hl)
	ret

@dropDodongo:
	call dropLinkHeldItem
	ld h,d
	ld l,Enemy.substate
	ld (hl),$03
	inc l
	ld (hl),60 ; [counter1]

	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.direction
	ld a,(hl)
	jp enemySetAnimation

@released:
	ld h,d
	ld l,Enemy.collisionType
	bit 7,(hl)
	jr nz,++

	; Re-enable collisions, change animation?
	set 7,(hl)
	ld e,Enemy.direction
	ld a,(de)
	add $02
	call enemySetAnimation
++
	call dodongo_setInvincibilityAndPlaySoundIfInSpikes
	ret nz
	jr @inSpikes

@landed:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call dodongo_setInvincibilityAndPlaySoundIfInSpikes
	jp nz,dodongo_resetMovement

@inSpikes:
	ld h,d
	ld l,Enemy.var33
	dec (hl)
	call z,ecom_killObjectH

	ld l,Enemy.state
	ld (hl),$0c

	ld l,Enemy.counter2
	ld (hl),$04
	dec l
	ld (hl),30 ; [counter1]

	; If angle value not set, calculate angle based on direction?
	ld l,Enemy.angle
	bit 7,(hl)
	jr z,++
	dec l
	ldi a,(hl) ; [direction]
	add a
	xor $10
	ld (hl),a
++
	jp objectSetVisible82


dodongo_state_stub:
	ret


; Waiting for Link to enter room
dodongo_state8:
	ld a,(wcc93)
	or a
	ret nz

	ld a,$09
	ld (de),a ; [state]

	ld a,MUS_BOSS
	ld (wActiveMusic),a
	call playSound


; Deciding what direction to walk in
dodongo_state9:
	call dodongo_turnTowardLinkIfPossible
	ret nc

	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = $0a

	ld l,Enemy.speed
	ld (hl),SPEED_40

	; Decide how long to walk for
	call getRandomNumber_noPreserveVars
	and $07
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a

	; Set animation
	ld e,Enemy.angle
	ld a,(de)
	rrca
	dec e
	ld (de),a ; [direction]
	call enemySetAnimation

	; Set collision box based on facing direction
	ld e,Enemy.angle
	ld a,(de)
	and $08
	rrca
	rrca
	ld hl,@collisionRadii
	rst_addAToHl
	ld e,Enemy.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

@collisionRadii:
	.db $0c $08 ; Up/down
	.db $08 $10 ; Left/right

@counter1Vals: ; Potential lengths of time to walk for before attacking
	.db 160, 160, 120, 160, 120, 120, 120, 120


; Walking
dodongo_stateA:
	call dodongo_playStompSoundAtInterval
	call ecom_decCounter1
	jr nz,@walking

	call dodongo_updateAngleTowardLink
	jp c,dodongo_initiateNextAttack

	; Reset movement if Link is no longer lined up well
	jp dodongo_resetMovement

@walking:
	; If counter2 is nonzero, he's charging up, not moving
	call ecom_decCounter2
	jr nz,dodongo_doubleAnimate

	call dodongo_checkTileInFront
	jp nc,dodongo_resetMovement

	call objectApplySpeed
	ld e,Enemy.speed
	ld a,(de)
	cp SPEED_40
	jr z,dodongo_animate

dodongo_doubleAnimate:
	call enemyAnimate
dodongo_animate:
	jp enemyAnimate


; Opening mouth, preparing to fire
dodongo_stateB:
	ld e,Enemy.animParameter
	ld a,(de)
	dec a
	jp z,dodongo_checkEatBomb

	dec a
	jr nz,@animate

	ld (de),a ; [animParameter] = 0

	; Fire projectile
	ld b,PART_DODONGO_FIREBALL
	call ecom_spawnProjectile

	ld a,SND_BEAM2
	call playSound

	jr dodongo_animate

@animate:
	add $03
	jr nz,dodongo_animate
	jr dodongo_resetMovement


; In spikes?
dodongo_stateC:
	ld h,d
	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	ret nz

	; Delay before moving back
	call ecom_decCounter2
	ret nz

	ld l,Enemy.counter1
	ld a,(hl)
	cp 30
	jr nz,@moveBack

	ld l,Enemy.speed
	ld (hl),SPEED_140

	; Reverse angle
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ldd (hl),a

	rrca
	ld (hl),a ; [direction]
	call enemySetAnimation

@moveBack:
	call dodongo_playStompSoundAtInterval
	call ecom_decCounter1
	jr nz,++

	call dodongo_checkInSpikes
	jr nz,dodongo_resetMovement

	ld e,Enemy.counter1
	ld a,$0a
	ld (de),a
++
	call objectApplySpeed
	jr dodongo_doubleAnimate


; Just ate a bomb
dodongo_stateD:
	call objectAddToGrabbableObjectBuffer
	call objectPushLinkAwayOnCollision

	; When counter2 reaches 0, dodongo begins getting up
	call ecom_decCounter2
	ret nz

	call dodongo_updateAnimationWhileSlimmingDown
	jr z,dodongo_resetMovement

	ld l,Enemy.direction


;;
; @param	hl	Pointer to Enemy.direction
dodongo_updateAnimation:
	ld e,Enemy.var30
	ld a,(de)
	and $01
	add $02
	add (hl)
	jp enemySetAnimation

;;
dodongo_resetMovement:
	ld h,d
	ld l,Enemy.state
	ld (hl),$09

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.counter1
	xor a
	ldi (hl),a
	ld (hl),a ; [counter2]

	ld l,Enemy.direction
	ld a,(hl)
	jp enemySetAnimation


;;
; Either turns toward Link or, if facing a wall, turns in some other random direction.
;
; @param[out]	c	c if wasn't able to turn in any valid direction
dodongo_turnTowardLinkIfPossible:
	call ecom_updateCardinalAngleTowardTarget
	call dodongo_checkTileInFront
	ret c
	call ecom_setRandomCardinalAngle

	; Fall through

;;
; @param[out]	cflag	c if tile in front of dodongo is not a spike
dodongo_checkTileInFront:
	ld h,d
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	ld e,Enemy.angle
	ld a,(de)
	rrca
	rrca
	ld hl,@positionOffsets
	rst_addAToHl

	ldi a,(hl)
	add b
	ld b,a
	ld a,(hl)
	add c
	ld c,a
	call getTileAtPosition
	cp $a4
	scf
	ret z

	sub TILEINDEX_RESPAWNING_BUSH_CUT
	cp TILEINDEX_RESPAWNING_BUSH_READY - TILEINDEX_RESPAWNING_BUSH_CUT + 1
	ret

@positionOffsets:
	.db -13,  0
	.db   4, 17
	.db  13,  0
	.db   4,-17

;;
dodongo_playStompSoundAtInterval:
	ld e,Enemy.speed
	ld a,(de)
	cp SPEED_40
	ld b,$1f
	jr z,+
	ld b,$0f
+
	ld a,(wFrameCounter)
	and b
	ret nz
	ld a,SND_SCENT_SEED
	jp playSound

;;
; @param[out]	c	c if Link is at a good angle to charge him
dodongo_updateAngleTowardLink:
	ld c,$0c
	call objectCheckCenteredWithLink
	ret nc

	call objectGetAngleTowardEnemyTarget
	ld b,a
	ld e,Enemy.angle
	ld a,(de)
	sub b
	add $04
	cp $09
	ret


;;
; @param[out]	zflag	z if dodongo is ready to continue moving
dodongo_updateAnimationWhileSlimmingDown:
	ld e,Enemy.var30
	ld a,(de)
	inc a
	ld (de),a
	cp $11
	ret z

	ld l,Enemy.counter2
	cp $07
	jr c,++
	ld (hl),$08
	or d
	ret
++
	ld bc,@counter2Vals
	call addAToBc
	ld a,(bc)
	ld (hl),a ; [counter2]
	or d
	ret

@counter2Vals:
	.db 180, 20, 20, 16, 16, 10, 10

;;
dodongo_checkEatBomb:
	; Check bomb 1
	ld c,ITEM_BOMB
	call findItemWithID
	jr nz,@animate
	call @checkBombInRangeToEat
	jr z,@eatBomb

	; Check bomb 2
	ld c,ITEM_BOMB
	call findItemWithID_startingAfterH
	jr nz,@animate
	call @checkBombInRangeToEat
	jr z,@eatBomb
@animate:
	jp enemyAnimate

@eatBomb:
	; Signal bomb's deletion
	ld l,Item.var2f
	set 5,(hl)

	ld h,d
	ld l,Enemy.var30
	ld (hl),$00

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.state
	ld (hl),$0d

	ld l,Enemy.direction
	ldd a,(hl)
	ld (hl),120

	add $02
	call enemySetAnimation

	ld a,SND_DODONGO_EAT
	jp playSound

;;
; @param	h	Bomb object
; @param[out]	zflag	z if bomb shall be eaten
@checkBombInRangeToEat:
	; Is bomb being held?
	ld l,Item.var2f
	ld a,(hl)
	bit 6,a
	jr z,@notEaten

	; Don't eat if it's exploding or slated for delation?
	and $b0
	jr nz,@notEaten

	; Don't eat if it's being held
	ld l,Item.substate
	ld a,(hl)
	cp $02
	jr c,@notEaten

	; Get position at dodongo's mouth (based on direction it's moving in)
	push hl
	ld e,Enemy.angle
	ld a,(de)
	rrca
	rrca
	ld hl,@positionOffsets
	rst_addAToHl
	ldi a,(hl)
	ld c,(hl)
	ld h,d
	ld l,Enemy.yh
	add (hl)
	ld b,a
	ld l,Enemy.xh
	ld a,(hl)
	add c
	ld c,a

	; Check for collision with bomb
	pop hl
	ld l,Item.yh
	ld a,(hl)
	sub b
	add $0c
	cp $19
	jr nc,@notEaten

	ld l,Item.xh
	ld a,(hl)
	sub c
	add $08
	cp $11
	jr nc,@notEaten

	xor a
	ret

@notEaten:
	or d
	ret

@positionOffsets:
	.db -6,  0
	.db  0, 12
	.db 12,  0
	.db  0,-12

;;
; Determines next attack.
dodongo_initiateNextAttack:
	ld e,Enemy.var32
	ld a,(de)
	inc a
	and $0f
	ld (de),a
	ld hl,@attackPattern
	call checkFlag
	ld h,d
	jr z,@chargeAttack

	; Fireball attack (opening mouth)
	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.direction
	ld a,(hl)
	inc a
	call enemySetAnimation
	ld a,SND_DODONGO_OPEN_MOUTH
	jp playSound

@chargeAttack:
	ld l,Enemy.speed
	ld (hl),SPEED_140
	ld l,Enemy.counter2
	ld (hl),45
	dec l
	ld (hl),128 ; [counter1]
	ret

@attackPattern:
	dbrev %01101011, %00010110


;;
; @param[out]	zflag	z if in spikes
dodongo_setInvincibilityAndPlaySoundIfInSpikes:
	call dodongo_checkInSpikes
	ret nz

	ld e,Enemy.invincibilityCounter
	ld a,$30
	ld (de),a
	ld a,SND_BOSS_DAMAGE
	call playSound
	xor a
	ret

;;
; @param[out]	zflag	z if in spikes
dodongo_checkInSpikes:
	ld h,d
	ld l,Enemy.zh
	bit 7,(hl)
	ret nz
	ld l,Enemy.yh
	ldi a,(hl)
	add $05
	ld b,a
	inc l
	ld c,(hl)
	call getTileAtPosition
	cp TILEINDEX_SPIKES
	ret

;;
; @param[out]	zflag	z if king dodongo has regained normal weight and is ready to move
dodongo_updateAnimationWhileHeld:
	ld h,d
	ld l,Enemy.counter2
	dec (hl)
	jr nz,++
	call dodongo_updateAnimationWhileSlimmingDown
	ret z
++
	; Update animation based on Link's direction
	ld l,Enemy.var31
	ld a,(w1Link.direction)
	add a
	add a
	ld b,a
	sub (hl)
	ld (hl),b

	ld l,Enemy.direction
	add (hl)
	and $0c
	ld (hl),a

	call dodongo_updateAnimation
	or d
	ret
