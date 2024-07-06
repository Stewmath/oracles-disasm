; ==================================================================================================
; ENEMY_CUCCO
;
; Shares some code with ENEMY_GIANT_CUCCO.
;
; Variables:
;   relatedObj1: INTERAC_PUFF object when transforming
;   var30: Number of times it's been hit (also read by PART_CUCCO_ATTACKER to decide
;          speed)
;   var31: Enemy ID to transform into, when a mystery seed is used on it
;   var32: Counter used while being held
;   var33: Counter until next PART_CUCCO_ATTACKER is spawned
; ==================================================================================================
enemyCode36:
	jr z,@normalStatus

	ld h,d
	ld l,Enemy.var2a
	ld a,(hl)
	cp $80|ITEMCOLLISION_MYSTERY_SEED
	jp z,cucco_hitWithMysterySeed

	; BUG: In JP version, attacking cuccos with gale seeds will put them into a glitched state
	; where they cannot take damage. In the US version they get blown away like normal enemies.
.ifndef ENABLE_US_BUGFIXES
	jp cucco_attacked
.else
	cp $80|ITEMCOLLISION_GALE_SEED
	jp nz,cucco_attacked
.endif

@normalStatus:
	call cucco_checkSpawnCuccoAttacker
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw cucco_state_uninitialized
	.dw cucco_state_stub
	.dw cucco_state_grabbed
	.dw cucco_state_stub
	.dw cucco_state_stub
	.dw ecom_blownByGaleSeedState
	.dw cucco_state_stub
	.dw cucco_state_stub
	.dw cucco_state8
	.dw cucco_state9
	.dw cucco_stateA
	.dw cucco_stateB


cucco_state_uninitialized:
	ld a,SPEED_80
	call ecom_setSpeedAndState8AndVisible

	ld l,Enemy.var3f
	set 5,(hl)
	ret


; Also used by ENEMY_GIANT_CUCCO
cucco_state_grabbed:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @holding
	.dw @checkOutOfScreenBounds
	.dw @landed

@justGrabbed:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.var32
	xor a
	ld (hl),a
	ld (wLinkGrabState2),a

	ld a,(w1Link.direction)
	srl a
	xor $01
	ld l,Enemy.direction
	ld (hl),a
	call enemySetAnimation

	ld a,SND_CHICKEN
	call playSound
	jp objectSetVisiblec1

@holding:
	call cucco_playChickenSoundEvery32Frames
	ld h,d
	ld l,Enemy.direction
	ld a,(w1Link.direction)
	srl a
	xor $01
	cp (hl)
	jr z,@checkOutOfScreenBounds
	ld (hl),a
	jp enemySetAnimation

@checkOutOfScreenBounds:
	ld e,Enemy.yh
	ld a,(de)
	cp SMALL_ROOM_HEIGHT<<4
	jr nc,++
	ld e,Enemy.xh
	ld a,(de)
	cp SMALL_ROOM_WIDTH<<4
	jp c,enemyAnimate
++
	jp enemyDelete

@landed:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0a

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.speed
	ld (hl),SPEED_100

	ld l,Enemy.counter1
	ld (hl),$01
	jp objectSetVisiblec2


cucco_state_stub:
	ret


; Standing still.
; Also used by ENEMY_GIANT_CUCCO.
cucco_state8:
	call objectAddToGrabbableObjectBuffer

	ld e,$3f
	ld bc,$031f
	call ecom_randomBitwiseAndBCE
	or e
	ret nz ; 63 in 64 chance of returning

	call ecom_incState

	ld l,Enemy.counter1
	ldi (hl),a ; [counter1] = 0

	ld a,$02
	add b
	ld (hl),a ; [counter2] = random value between 2-6 (number of hops)

	ld l,Enemy.angle
	ld a,c
	ld (hl),a
	jp cucco_setAnimationFromAngle


; Moving in some direction until [counter2] == 0.
; Also used by ENEMY_GIANT_CUCCO.
cucco_state9:
	call objectAddToGrabbableObjectBuffer
	ld h,d
	ld l,Enemy.counter1
	ld a,(hl)
	and $0f
	inc (hl)

	ld hl,cucco_zVals
	rst_addAToHl
	ld e,Enemy.zh
	ld a,(hl)
	ld (de),a
	or a
	jr nz,++

	; Just finished a hop
	call ecom_decCounter2
	jr nz,++

	; Stop moving
	ld l,Enemy.state
	dec (hl)
++
	call ecom_bounceOffWallsAndHoles
	call nz,cucco_setAnimationFromAngle
	call objectApplySpeed
cucco_animate:
	jp enemyAnimate


; Just landed after being thrown. Run away from Link indefinitely.
cucco_stateA:
	call objectAddToGrabbableObjectBuffer
	call ecom_updateCardinalAngleAwayFromTarget
	call cucco_setAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr cucco_animate


; In the process of transforming (into ENEMY_BABY_CUCCO or ENEMY_GIANT_CUCCO, based on
; var31)
cucco_stateB:
	ld a,Object.animParameter
	call objectGetRelatedObject1Var
	bit 7,(hl)
	ret z

	ld e,Enemy.var31
	ld a,(de)
	ld b,a
	ld c,$00
	jp objectReplaceWithID
