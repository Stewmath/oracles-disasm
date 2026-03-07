; ==================================================================================================
; PART_KING_MOBLIN_BOMB
;
; Variables:
;   relatedObj1: Instance of ENEMY_KING_MOBLIN
;   var30: If nonzero, damage has been applied to Link
;   var31: Number of red flashes before it explodes
; ==================================================================================================
partCode3f:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw kingMoblinBomb_state0
	.dw common_kingMoblinBomb_state1
	.dw kingMoblinBomb_state2
	.dw kingMoblinBomb_state3
	.dw kingMoblinBomb_state4
	.dw kingMoblinBomb_state5
	.dw kingMoblinBomb_state6
	.dw kingMoblinBomb_state7
	.dw kingMoblinBomb_state8


kingMoblinBomb_state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.speed
	ld (hl),SPEED_220

	ld l,Part.yh
	ld a,(hl)
	add $08
	ld (hl),a

	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter1Values
	rst_addAToHl
	ld e,Part.counter1
	ld a,(hl)
	ld (de),a

	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	dec a
	ld hl,@numRedFlashes
	rst_addAToHl
	ld e,Part.var31
	ld a,(hl)
	ld (de),a

	jp objectSetVisiblec2

@counter1Values: ; One of these is chosen randomly.
	.db 120, 135, 160, 180

@numRedFlashes: ; Indexed by [kingMoblin.health] - 1.
	.db $06 $07 $08 $09 $0a $0c


; Bomb isn't doing anything except waiting to explode.
; This state's code is called by other states (2-4).
common_kingMoblinBomb_state1:
	ld e,Part.counter1
	ld a,(de)
	or a
	jr z,++
	ld a,(wFrameCounter)
	rrca
	ret c
++
	call partCommon_decCounter1IfNonzero
	ret nz

	ld l,Part.animParameter
	bit 0,(hl)
	jr z,@animate

	ld (hl),$00
	ld l,Part.counter2
	inc (hl)

	ld a,(hl)
	ld l,Part.var31
	cp (hl)
	jr nc,kingMoblinBomb_explode

@animate:
	jp partAnimate

	; Unused code snippet?
	or d
	ret

kingMoblinBomb_explode:
	ld l,Part.state
	ld (hl),$05

	ld l,Part.oamFlagsBackup
	ld a,$0a
	ldi (hl),a
	ldi (hl),a
	ld (hl),$0c ; [oamTileIndexBase]

	ld a,$01
	call partSetAnimation
	call objectSetVisible82
	ld a,SND_EXPLOSION
	call playSound
	xor a
	ret


; Being held by Link
kingMoblinBomb_state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @atRest

@justGrabbed:
	ld a,$01
	ld (de),a ; [substate] = 1
	xor a
	ld (wLinkGrabState2),a
	call objectSetVisiblec1

@beingHeld:
	call common_kingMoblinBomb_state1
	ret nz
	jp dropLinkHeldItem

@released:
	; Drastically reduce speed when Y < $30 (on moblin's platform), Z = 0,
	; and subid = 0.
	ld e,Part.yh
	ld a,(de)
	cp $30
	jr nc,@beingHeld

	ld h,d
	ld l,Part.zh
	ld e,Part.subid
	ld a,(de)
	or (hl)
	jr nz,@beingHeld

	; Reduce speed
	ld hl,w1ReservedItemC.speedZ+1
	sra (hl)
	dec l
	rr (hl)
	ld l,Item.speed
	ld (hl),SPEED_40

	jp common_kingMoblinBomb_state1

@atRest:
	ld e,Part.state
	ld a,$04
	ld (de),a

	call objectSetVisiblec2
	jr kingMoblinBomb_state4


; Being thrown. (King moblin sets the state to this.)
kingMoblinBomb_state3:
	call common_kingMoblinBomb_state1
	ret z

	ld c,$20
	call objectUpdateSpeedZAndBounce
	jr c,@doneBouncing

	ld a,SND_BOMB_LAND
	call z,playSound
	jp objectApplySpeed

@doneBouncing:
	ld a,SND_BOMB_LAND
	call playSound
	ld h,d
	ld l,Part.state
	inc (hl) ; [state] = 4


; Waiting to be picked up (by link or king moblin)
kingMoblinBomb_state4:
	call common_kingMoblinBomb_state1
	ret z
	jp objectAddToGrabbableObjectBuffer


; Exploding
kingMoblinBomb_state5:
	ld h,d
	ld l,Part.animParameter
	ld a,(hl)
	inc a
	jp z,partDelete

	dec a
	jr z,@animate

	ld l,Part.collisionRadiusY
	ldi (hl),a
	ld (hl),a
	call kingMoblinBomb_checkCollisionWithLink
	call kingMoblinBomb_checkCollisionWithKingMoblin
@animate:
	jp partAnimate


; States 6-8 might be unused? Bomb is chucked way upward, then explodes on the ground.
kingMoblinBomb_state6:
	ld bc,-$240
	call objectSetSpeedZ

	ld l,e
	inc (hl) ; [state] = 7

	ld l,Part.speed
	ld (hl),SPEED_c0

	ld l,Part.counter1
	ld (hl),$07

	; Decide angle to throw at based on king moblin's position
	ld a,Object.xh
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $50
	ld a,$07
	jr c,+
	ld a,$19
+
	ld e,Part.angle
	ld (de),a
	ret


kingMoblinBomb_state7:
	call partCommon_decCounter1IfNonzero
	ret nz

	ld l,e
	inc (hl) ; [state] = 8


kingMoblinBomb_state8:
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jp nc,objectApplySpeed

	ld h,d
	jp kingMoblinBomb_explode

;;
kingMoblinBomb_checkCollisionWithLink:
	ld e,Part.var30
	ld a,(de)
	or a
	ret nz

	call checkLinkVulnerable
	ret nc

	call objectCheckCollidedWithLink_ignoreZ
	ret nc

	call objectGetAngleTowardEnemyTarget

	ld hl,w1Link.knockbackCounter
	ld (hl),$10
	dec l
	ldd (hl),a ; [w1Link.knockbackAngle]
	ld (hl),20 ; [w1Link.invincibilityCounter]
	dec l
	ld (hl),$01 ; [w1Link.var2a] (TODO: what does this mean?)

	ld e,Part.damage
	ld l,<w1Link.damageToApply
	ld a,(de)
	ld (hl),a

	ld e,Part.var30
	ld a,$01
	ld (de),a
	ret

;;
kingMoblinBomb_checkCollisionWithKingMoblin:
	ld e,Part.relatedObj1+1
	ld a,(de)
	or a
	ret z

	; Check king moblin's collisions are enabled
	ld a,Object.collisionType
	call objectGetRelatedObject1Var
	bit 7,(hl)
	ret z

	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	ret nz

	call checkObjectsCollided
	ret nc

	ld l,Enemy.var2a
	ld (hl),$80|ITEMCOLLISION_BOMB
	ld l,Enemy.invincibilityCounter
	ld (hl),30

	ld l,Enemy.health
	dec (hl)
	ret
