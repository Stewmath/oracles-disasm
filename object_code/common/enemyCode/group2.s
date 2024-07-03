; ==============================================================================
; ENEMYID_TEKTITE
;
; Variables:
;   var30: Gravity
;   var31: Minimum value for counter1 (lower value = more frequent jumping)
; ==============================================================================
enemyCode30:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_stub
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB


@state_uninitialized:
	; Subid 1 has lower value for var31, meaning more frequent jumps.
	ld h,d
	ld l,Enemy.subid
	bit 0,(hl)
	ld l,Enemy.var31
	ld (hl),90
	jr z,+
	ld (hl),45
+
	call getRandomNumber_noPreserveVars
	and $7f
	inc a
	ld e,Enemy.counter1
	ld (de),a
	ld a,SPEED_140
	jp ecom_setSpeedAndState8AndVisible


@state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret

@substate3:
	ld b,$08
	call ecom_fallToGroundAndSetState
	ret nz
	jp @gotoState8


@state_stub:
	ret


; Standing in place for [counter1] frames
@state8:
	call ecom_decCounter1
	jr nz,@animate

	; Set [counter1] to how long the crouch will last
	call getRandomNumber_noPreserveVars
	and $7f
	call ecom_incState
	ld l,Enemy.var31
	add (hl)
	ld l,Enemy.counter1
	ldi (hl),a
	ld (hl),$18
	ld a,$01
	jp enemySetAnimation
@animate:
	jp enemyAnimate


; Crouching before a leap
@state9:
	call ecom_decCounter2
	ret nz
	ld l,e
	inc (hl)
	ld a,$02
	jp enemySetAnimation


; About to start a leap
@stateA:
	ld a,$0b
	ld (de),a ; [state]

	call getRandomNumber_noPreserveVars
	and $07
	ld hl,@smallLeap
	jr nz,+
	ld hl,@bigLeap
+
	ld e,Enemy.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	; Gravity
	ld e,Enemy.var30
	ldi a,(hl)
	ld (de),a

	call ecom_updateAngleTowardTarget
	ld a,SND_ENEMY_JUMP
	call playSound
	jp objectSetVisiblec1


; speedZ, gravity
@smallLeap:
	dwb $feaa, $0e
@bigLeap:
	dwb $fe80, $0c


; Leaping
@stateB:
	call ecom_bounceOffScreenBoundary
	ld e,Enemy.var30
	ld a,(de)
	ld c,a
	call objectUpdateSpeedZ_paramC
	jp nz,ecom_applyVelocityForSideviewEnemy

;;
@gotoState8:
	call getRandomNumber_noPreserveVars
	and $7f
	ld h,d
	ld l,Enemy.var31
	add (hl)
	ld l,Enemy.counter1
	ld (hl),a
	ld l,Enemy.state
	ld (hl),$08
	xor a
	call enemySetAnimation
	jp objectSetVisiblec2


; ==============================================================================
; ENEMYID_STALFOS
; ==============================================================================
enemyCode31:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@normalStatus:
	call stalfos_checkJumpAwayFromLink
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw stalfos_state_uninitialized
	.dw stalfos_state_stub
	.dw stalfos_state_stub
	.dw stalfos_state_switchHook
	.dw stalfos_state_stub
	.dw ecom_blownByGaleSeedState
	.dw stalfos_state_stub
	.dw stalfos_state_stub
	.dw stalfos_state08
	.dw stalfos_state09
	.dw stalfos_state0a
	.dw stalfos_state0b
	.dw stalfos_state0c
	.dw stalfos_state0d
	.dw stalfos_state0e
	.dw stalfos_state0f
	.dw stalfos_state10


stalfos_state_uninitialized:
	ld a,SPEED_80
	jp ecom_setSpeedAndState8AndVisible


stalfos_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw ecom_fallToGroundAndSetState8

@substate1:
@substate2:
	ret


stalfos_state_stub:
	ret


; Choosing what to do next (move in a random direction, or shoot a bone an Link)
stalfos_state08:
	call stalfos_checkSubid3StompsLink
	; Above function call may pop its return address, ignoring everything below this

	call getRandomNumber_noPreserveVars
	and $07
	jp nz,stalfos_moveInRandomAngle

	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jp nz,stalfos_moveInRandomAngle

	; For subid 2 only, there's a 1 in 8 chance of getting here (shooting a bone at
	; Link)
	ld e,Enemy.state
	ld a,$0c
	ld (de),a
	ret


; Moving in some direction for [counter1] frames
stalfos_state09:
	call stalfos_checkSubid3StompsLink
	; Above function call may pop its return address, ignoring everything below this

	call ecom_decCounter1
	jr nz,++
	ld l,Enemy.state
	ld (hl),$08
++
	call ecom_bounceOffWallsAndHoles
	call objectApplySpeed
	jp enemyAnimate


; Just starting a jump away from Link
stalfos_state0a:
	ld bc,-$200
	call objectSetSpeedZ

	ld l,e
	inc (hl) ; [state]

	; Make him invincible while he's moving upward
	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.speed
	ld (hl),SPEED_140

	call ecom_updateCardinalAngleAwayFromTarget
	jp stalfos_beginJumpAnimation


; Jumping until hitting the ground
stalfos_state0b:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr z,@hitGround

	; Make him vulnerable to attack again once he starts moving down
	ld a,(hl) ; a = [speedZ]
	or a
	jr nz,++
	ld l,Enemy.collisionType
	set 7,(hl)
++
	jp ecom_applyVelocityForSideviewEnemy

@hitGround:
	ld a,SPEED_80
	call ecom_setSpeedAndState8
	xor a
	call enemySetAnimation
	jp objectSetVisiblec2


; Firing a projectile, then immediately going to state 9 to keep moving
stalfos_state0c:
	ld b,PARTID_STALFOS_BONE
	call ecom_spawnProjectile
	jr stalfos_moveInRandomAngle


; Stomping on Link
stalfos_state0d:
	ld c,$20
	call objectUpdateSpeedZ_paramC

	; Check if he's begun moving down yet
	ld a,(hl)
	or a
	jp nz,ecom_applyVelocityForSideviewEnemyNoHoles

	; He's begun moving down. Go to next state so he freezes in the air.
	ld l,Enemy.counter1
	ld (hl),$08
	ld l,Enemy.state
	inc (hl)
	ret


; Wait for 8 frames while hanging in the air mid-stomp
stalfos_state0e:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [state]
	ret


; Fall down for the stomp
stalfos_state0f:
	ld h,d
	ld l,Enemy.zh
	ld a,(hl)
	add $03
	ld (hl),a
	cp $80
	ret nc

	; Hit the ground
	xor a
	ld (hl),a ; [zh] = 0

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),30
	jp objectSetVisiblec2


; Laying on the ground for [counter1] frames until he starts moving again
stalfos_state10:
	call ecom_decCounter1
	ret nz


;;
; Go to state 9 with a freshly chosen angle
stalfos_moveInRandomAngle:
	ld e,$30
	ld bc,$1f0f
	call ecom_randomBitwiseAndBCE

	ld h,d
	ld l,Enemy.state
	ld (hl),$09
	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld a,$20
	add e
	ld l,Enemy.counter1
	ld (hl),a

	; 1 in 16 chance of moving toward Link; otherwise, move in random direction
	dec c
	ld a,b
	call z,objectGetAngleTowardEnemyTarget
	ld e,Enemy.angle
	ld (de),a
	xor a
	jp enemySetAnimation


;;
; For subid 3 only, if Link approaches close enough, it will jump toward Link to stomp on
; him (goes to state $0d).
stalfos_checkSubid3StompsLink:
	ld e,Enemy.subid
	ld a,(de)
	cp $03
	ret nz

	ld c,$1c
	call objectCheckLinkWithinDistance
	ret nc

	ld bc,-$240
	call objectSetSpeedZ

	ld l,Enemy.state
	ld (hl),$0d
	ld l,Enemy.speed
	ld (hl),SPEED_180

	pop hl ; Return from caller

	call ecom_updateAngleTowardTarget


;;
stalfos_beginJumpAnimation:
	ld a,$01
	call enemySetAnimation
	ld a,SND_ENEMY_JUMP
	call playSound
	jp objectSetVisiblec1


;;
; If Link is swinging something near this object, it will set its state to $0a if not
; already jumping.
stalfos_checkJumpAwayFromLink:
	; Not for subid 0
	ld e,Enemy.subid
	ld a,(de)
	or a
	ret z

	; Check specifically for w1WeaponItem being used?
	ld a,(wLinkUsingItem1)
	and $f0
	ret z

	ld e,Enemy.state
	ld a,(de)
	cp $0a
	ret nc

	ld c,$2c
	call objectCheckLinkWithinDistance
	ret nc

	ld e,Enemy.state
	ld a,$0a
	ld (de),a
	ret

;;
; Unused
stalfos_setState8:
	ld e,Enemy.state
	ld a,$08
	ld (de),a
	ret


; ==============================================================================
; ENEMYID_KEESE
;
; Variables (for subid 1 only, the one that moves as Link approaches):
;   var30: Amount to add to angle each frame. (Clockwise or counterclockwise turning)
; ==============================================================================
enemyCode32:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ret

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw keese_state_uninitialized
	.dw keese_state_stub
	.dw keese_state_stub
	.dw keese_state_stub
	.dw keese_state_stub
	.dw ecom_blownByGaleSeedState
	.dw keese_state_stub
	.dw keese_state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw keese_subid00
	.dw keese_subid01


keese_state_uninitialized:
	call ecom_setSpeedAndState8
	call keese_initializeSubid
	jp objectSetVisible82


keese_state_stub:
	ret


keese_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw keese_subid00_state8
	.dw keese_subid00_state9
	.dw keese_subid00_stateA


; Resting for [counter1] frames
keese_subid00_state8:
	call ecom_decCounter1
	ret nz

	; Choose random angle and counter1
	ld bc,$1f3f
	call ecom_randomBitwiseAndBCE
	call ecom_incState

	ld l,Enemy.angle
	ld (hl),b
	ld l,Enemy.speed
	ld (hl),SPEED_c0

	ld a,$c0
	add c
	ld l,Enemy.counter1
	ld (hl),a

	ld a,$01
	call enemySetAnimation
	jr keese_animate


; Moving in some direction for [counter1] frames
keese_subid00_state9:
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary
	ld a,(wFrameCounter)
	rrca
	jr c,keese_animate

	call ecom_decCounter1
	jr z,@timeToStop

	; 1 in 16 chance, per frame, of randomly choosing a new angle to move in
	ld bc,$0f1f
	call ecom_randomBitwiseAndBCE
	or b
	jr nz,keese_animate

	ld e,Enemy.angle
	ld a,c
	ld (de),a
	jr keese_animate

@timeToStop:
	ld l,Enemy.state
	inc (hl)

keese_animate:
	jp enemyAnimate


; Decelerating until [counter1] counts up to $7f, when it stops completely.
keese_subid00_stateA:
	ld e,Enemy.counter1
	ld a,(de)
	cp $68
	jr nc,++
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary
++
	call keese_updateDeceleration
	ld h,d
	ld l,Enemy.counter1
	inc (hl)

	ld a,$7f
	cp (hl)
	ret nz

	; Full stop
	ld l,Enemy.state
	ld (hl),$08

	; Set counter1 randomly
	call getRandomNumber_noPreserveVars
	and $7f
	ld e,Enemy.counter1
	add $20
	ld (de),a
	xor a
	jp enemySetAnimation


keese_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw keese_subid01_state8
	.dw keese_subid02_state9


; Waiting for Link to approach
keese_subid01_state8:
	ld c,$31
	call objectCheckLinkWithinDistance
	ret nc

	call ecom_updateAngleTowardTarget
	call ecom_incState

	ld l,Enemy.speed
	ld (hl),SPEED_100

	; Turn clockwise or counterclockwise, based on var30
	ld e,Enemy.angle
	ld l,Enemy.var30
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a

	ld l,Enemy.counter1
	ld (hl),12
	inc l
	ld (hl),12 ; [counter2]

	ld a,$01
	jp enemySetAnimation


keese_subid02_state9:
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary
	call ecom_decCounter1
	jr nz,keese_animate

	ld (hl),12 ; [counter1]

	; Turn clockwise or counterclockwise, based on var30
	ld l,Enemy.var30
	ld e,Enemy.angle
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a

	ld l,Enemy.counter2
	dec (hl)
	jr nz,keese_animate

	; Done moving.
	ld l,Enemy.state
	dec (hl)
	call keese_chooseWhetherToReverseTurningAngle
	xor a
	jp enemySetAnimation


;;
; Every 16 frames (based on counter1) this updates the keese's speed as it's decelerating.
; Also handles the animation (which slows down).
keese_updateDeceleration:
	ld e,Enemy.counter1
	ld a,(de)
	and $0f
	jr nz,++

	ld a,(de)
	swap a
	ld hl,@speeds
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.speed
	ld (de),a
++
	ld e,Enemy.counter1
	ld a,(de)
	and $f0
	swap a
	ld hl,@bits
	rst_addAToHl
	ld a,(wFrameCounter)
	and (hl)
	jp z,enemyAnimate
	ret

@speeds:
	.db SPEED_c0, SPEED_80, SPEED_40, SPEED_40, SPEED_20, SPEED_20, SPEED_20, SPEED_20

@bits:
	.db $00 $00 $01 $01 $03 $03 $07 $00


;;
keese_initializeSubid:
	dec b
	jr z,@subid1

@subid0:
	; Just set how long to wait initially
	ld l,Enemy.counter1
	ld (hl),$20
	ret

@subid1:
	ld l,Enemy.zh
	ld (hl),$ff

	ld l,Enemy.var30
	ld (hl),$02

;;
; For subid 1 only, this has a 1 in 4 chance of deciding to reverse the turning angle
; (clockwise or counterclockwise).
keese_chooseWhetherToReverseTurningAngle:
	call getRandomNumber_noPreserveVars
	and $03
	ret nz

	ld e,Enemy.var30
	ld a,(de)
	cpl
	inc a
	ld (de),a
	ret


; ==============================================================================
; ENEMYID_BABY_CUCCO
; ==============================================================================
enemyCode33:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw babyCucco_state_uninitialized
	.dw babyCucco_state_stub
	.dw babyCucco_state_grabbed
	.dw babyCucco_state_stub
	.dw babyCucco_state_stub
	.dw babyCucco_state_stub
	.dw babyCucco_state_stub
	.dw babyCucco_state_stub
	.dw babyCucco_state8
	.dw babyCucco_state9


babyCucco_state_uninitialized:
	ld a,SPEED_40
	jp ecom_setSpeedAndState8AndVisible


babyCucco_state_grabbed:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @landed

@justGrabbed:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.collisionType
	res 7,(hl)

	xor a
	ld (wLinkGrabState2),a

	ld a,(w1Link.direction)
	srl a
	xor $01
	ld l,Enemy.direction
	ld (hl),a
	call enemySetAnimation

	jp objectSetVisiblec1

@beingHeld:
	ld h,d
	ld l,Enemy.direction
	ld a,(w1Link.direction)
	srl a
	xor $01
	cp (hl)
	jr z,@released
	ld (hl),a
	jp enemySetAnimation

@released:
	ld e,Enemy.yh
	ld a,(de)
	cp SMALL_ROOM_HEIGHT<<4
	jr nc,@delete

	ld e,Enemy.xh
	ld a,(de)
	cp SMALL_ROOM_WIDTH<<4
	jp c,enemyAnimate
@delete:
	jp enemyDelete

@landed:
	ld h,d
	ld l,Enemy.state
	ld (hl),$08
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.direction
	ld (hl),$ff
	jp objectSetVisiblec2


babyCucco_state_stub:
	ret


babyCucco_state8:
	call objectAddToGrabbableObjectBuffer
	call objectSetPriorityRelativeToLink_withTerrainEffects

	call ecom_updateAngleTowardTarget
	call babyCucco_updateAnimationFromAngle

	ld c,$10
	call objectCheckLinkWithinDistance
	jr nc,@moveCloserToLink

	; If near Link, 1 in 64 chance of hopping (per frame)
	call getRandomNumber_noPreserveVars
	and $3f
	ret nz

	call ecom_incState
	ld l,Enemy.speedZ
	ld a,<($ff40)
	ldi (hl),a
	ld (hl),>($ff40)
	ret

@moveCloserToLink:
	call ecom_applyVelocityForSideviewEnemyNoHoles

babyCucco_animate:
	jp enemyAnimate


; Hopping
babyCucco_state9:
	ld c,$12
	call objectUpdateSpeedZ_paramC
	jr nz,babyCucco_animate

	ld l,Enemy.state
	dec (hl)
	ret


;;
babyCucco_updateAnimationFromAngle:
	ld e,Enemy.angle
	ld a,(de)
	cp $10
	ld a,$01
	jr c,+
	xor a
+
	ld h,d
	ld l,Enemy.direction
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation


; ==============================================================================
; ENEMYID_ZOL
;
; Variables:
;   var30: 1 when the zol is out of the ground, 0 otherwise. (only for subid 0, and only
;          used to prevent the "jump" sound effect from playing more than once.)
; ==============================================================================
enemyCode34:
	call ecom_checkHazardsNoAnimationForHoles
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazardsNoAnimationsForHoles

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.subid
	ld a,(de)
	or a
	ret z

	; Subid 1 only: Collision with anything except Link or a shield causes it to
	; split in two.
	ld e,Enemy.var2a
	ld a,(de)
	cp ITEMCOLLISION_LINK|$80
	jr z,@normalStatus

	res 7,a
	sub ITEMCOLLISION_L1_SHIELD
	cp ITEMCOLLISION_L3_SHIELD - ITEMCOLLISION_L1_SHIELD + 1
	ret c

	ld e,Enemy.state
	ld a,$0c
	ld (de),a
	ret

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw zol_state_uninitialized
	.dw zol_state_stub
	.dw zol_state_stub
	.dw zol_state_stub
	.dw zol_state_stub
	.dw ecom_blownByGaleSeedState
	.dw zol_state_stub
	.dw zol_state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw zol_subid00
	.dw zol_subid01


zol_state_uninitialized:
	ld a,b
	or a
	ld a,SPEED_c0
	jp z,ecom_setSpeedAndState8

	; Subid 1 only
	ld h,d
	ld l,Enemy.counter1
	ld (hl),$18
	ld l,Enemy.collisionType
	set 7,(hl)

	ld a,$04
	call enemySetAnimation
	jp ecom_setSpeedAndState8AndVisible


zol_state_stub:
	ret


zol_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw zol_subid00_state8
	.dw zol_subid00_state9
	.dw zol_subid00_stateA
	.dw zol_subid00_stateB
	.dw zol_subid00_stateC
	.dw zol_subid00_stateD


; Hiding in ground, waiting for Link to approach
zol_subid00_state8:
	ld c,$28
	call objectCheckLinkWithinDistance
	ret nc

	ld bc,-$200
	call objectSetSpeedZ

	ld l,Enemy.state
	inc (hl)

	; [counter2] = number of hops before disappearing
	ld l,Enemy.counter2
	ld (hl),$04

	jp objectSetVisiblec2


; Jumping out of ground
zol_subid00_state9:
	ld h,d
	ld l,Enemy.animParameter
	ld a,(hl)
	or a
	jr z,zol_animate

	ld l,Enemy.var30
	and (hl)
	jr nz,++
	ld (hl),$01
	ld a,SND_ENEMY_JUMP
	call playSound
++
	ld c,$28
	call objectUpdateSpeedZ_paramC
	ret nz

	; Landed on ground; go to next state
	call ecom_incState

	ld l,Enemy.counter1
	ld (hl),$30

	ld l,Enemy.collisionType
	set 7,(hl)
	inc a
	jp enemySetAnimation


; Holding still for [counter1] frames, preparing to hop toward Link
zol_subid00_stateA:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld bc,-$200
	call objectSetSpeedZ

	call ecom_updateAngleTowardTarget

	ld a,$02
	call enemySetAnimation

	ld a,SND_ENEMY_JUMP
	call playSound

zol_animate:
	jp enemyAnimate


; Hopping toward Link
zol_subid00_stateB:
	call ecom_applyVelocityForSideviewEnemy

	ld c,$28
	call objectUpdateSpeedZ_paramC
	ret nz

	; Hit the ground

	ld h,d
	ld l,Enemy.counter1
	ld (hl),$30
	inc l
	dec (hl) ; [counter2]-- (number of hops remaining)

	ld a,$0a
	ld b,$01
	jr nz,++

	; [counter2] == 0; go to state $0c, and disable collisions as we're disappearing
	; now
	ld l,Enemy.collisionType
	res 7,(hl)
	ld a,$0c
	ld b,$03
++
	ld l,Enemy.state
	ld (hl),a
	ld a,b
	jp enemySetAnimation


; Disappearing into the ground
zol_subid00_stateC:
	ld h,d
	ld l,Enemy.animParameter
	ld a,(hl)
	or a
	jr z,zol_animate

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),40

	ld l,Enemy.var30
	xor a
	ld (hl),a

	call enemySetAnimation
	jp objectSetInvisible


; Fully disappeared into ground. Wait [counter1] frames before we can emerge again
zol_subid00_stateD:
	call ecom_decCounter1
	ret nz

	ld l,e
	ld (hl),$08 ; [state]

	xor a
	jp enemySetAnimation


zol_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw zol_subid01_state8
	.dw zol_subid01_state9
	.dw zol_subid01_stateA
	.dw zol_subid01_stateB
	.dw zol_subid01_stateC
	.dw zol_subid01_stateD


; Holding still for [counter1] frames before deciding whether to hop or move forward
zol_subid01_state8:
	call ecom_decCounter1
	jr nz,zol_animate2

	; 1 in 8 chance of hopping toward Link
	call getRandomNumber_noPreserveVars
	and $07
	ld h,d
	ld l,Enemy.counter1
	jr z,@hopTowardLink

	; 7 in 8 chance of sliding toward Link
	ld (hl),$10 ; [counter1]
	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.speed
	ld (hl),SPEED_80
	call ecom_updateAngleTowardTarget
	jr zol_animate2

@hopTowardLink:
	ld (hl),$20 ; [counter1]
	ld l,Enemy.state
	ld (hl),$0a
	ld a,$05
	jp enemySetAnimation


; Sliding toward Link
zol_subid01_state9:
	call ecom_applyVelocityForSideviewEnemyNoHoles
	call ecom_bounceOffScreenBoundary

	call ecom_decCounter1
	jr nz,zol_animate2

	ld (hl),$18 ; [counter1]
	ld l,Enemy.state
	dec (hl)

zol_animate2:
	jp enemyAnimate


; Shaking before hopping toward Link
zol_subid01_stateA:
	call ecom_decCounter1
	jr nz,zol_animate2

	call ecom_incState

	ld l,Enemy.speedZ
	ld (hl),<(-$200)
	inc l
	ld (hl),>(-$200)

	ld l,Enemy.speed
	ld (hl),SPEED_100
	call ecom_updateAngleTowardTarget

	ld a,$02
	call enemySetAnimation
	ld a,SND_ENEMY_JUMP
	call playSound

	jp objectSetVisiblec1


; Hopping toward Link
zol_subid01_stateB:
	call ecom_applyVelocityForSideviewEnemy
	ld c,$28
	call objectUpdateSpeedZ_paramC
	ret nz

	; Hit ground
	ld h,d
	ld l,Enemy.counter1
	ld (hl),$18

	ld l,Enemy.state
	ld (hl),$08

	ld a,$04
	call enemySetAnimation
	jp objectSetVisiblec2


; Zol has been attacked, create puff, disable collisions, prepare to spawn two gels in the
; zol's place.
zol_subid01_stateC:
	ld b,INTERACID_KILLENEMYPUFF
	call objectCreateInteractionWithSubid00

	ld h,d
	ld l,Enemy.counter2
	ld (hl),18

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.state
	inc (hl)

	ld a,SND_KILLENEMY
	call playSound

	jp objectSetInvisible


; Zol has been attacked, spawn gels after [counter2] frames
zol_subid01_stateD:
	call ecom_decCounter2
	ret nz

	ld c,$04
	call zol_spawnGel
	ld c,-$04
	call zol_spawnGel

	call decNumEnemies
	jp enemyDelete

;;
; @param	c	X offset
zol_spawnGel:
	ld b,ENEMYID_GEL
	call ecom_spawnEnemyWithSubid01
	ret nz

	ld (hl),a ; [child.subid] = 0
	ld b,$00
	call objectCopyPositionWithOffset

	xor a
	ld l,Enemy.z
	ldi (hl),a
	ld (hl),a

	; Transfer "enemy index" to gel
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a
	ret


; ==============================================================================
; ENEMYID_FLOORMASTER
;
; Variables for subids other than 0:
;   relatedObj1: Reference to spawner object (subid 0)
;   var30: Animation index
;   var31: Index for z-position to use while chasing Link (0-7)
;   var32: Angle relative to Link where floormaster should spawn
;
; Variables for spawner (subid 0):
;   var30: Number of floormaster currently spawned (they delete themselves after
;          disappearing into the ground)
;   var31/var32: Link's position last time a floormaster was spawned. If Link hasn't moved
;                far from here, the floormaster will spawn at a random angle relative to
;                him; otherwise it will spawn in the direction Link is moving.
;   var33: # floormasters to spawn. Children decrement this when they're killed.
;          (High nibble of original Y value.)
;   var34: Subid for child objects (high nibble of original X value, plus one)
; ==============================================================================
enemyCode35:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackNoSolidity

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret nz

	; Grabbed Link
	ld h,d
	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.zh
	ld (hl),$fb

	call floormaster_updateAngleTowardLink
	add $04
	call enemySetAnimation

	; Move to halfway point between Link and floormaster
	ld h,d
	ld l,Enemy.yh
	ld a,(w1Link.yh)
	sub (hl)
	sra a
	add (hl)
	ld (hl),a

	ld l,Enemy.xh
	ld a,(w1Link.xh)
	sub (hl)
	sra a
	add (hl)
	ld (hl),a
	ret

@dead:
	ld a,Object.var30
	call objectGetRelatedObject1Var
	dec (hl)
	ld l,Enemy.var33
	dec (hl)
	jp enemyDie_uncounted

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw floormaster_state_uninitialized
	.dw floormaster_state1
	.dw floormaster_state_stub
	.dw floormaster_state_stub
	.dw floormaster_state_stub
	.dw floormaster_state_galeSeed
	.dw floormaster_state_stub
	.dw floormaster_state_stub
	.dw floormaster_state8
	.dw floormaster_state9
	.dw floormaster_stateA
	.dw floormaster_stateB
	.dw floormaster_stateC
	.dw floormaster_stateD


floormaster_state_uninitialized:
	ld h,d
	ld l,Enemy.counter1
	ld (hl),60
	ld l,e
	inc (hl) ; [state] = 1

	ld e,Enemy.subid
	ld a,(de)
	or a
	jp z,floormaster_initSpawner

	; Subid 1 only
	ld (hl),$08 ; [state] = 8
	ret


; State 1: only for subid 0 (spawner).
floormaster_state1:
	; Delete self if all floormasters were killed
	ld h,d
	ld l,Enemy.var33
	ld a,(hl)
	or a
	jr z,@delete

	; Return if all available floormasters have spawned already
	ld e,Enemy.var30
	ld a,(de)
	sub (hl)
	ret nc

	; Spawn another floormaster in [counter1] frames
	ld l,Enemy.counter1
	dec (hl)
	ret nz

	ld (hl),$01 ; [counter1]

	; Maximum of 3 on-screen at any given time
	ld l,Enemy.var30
	ld a,(hl)
	cp $03
	ret nc

	ld b,ENEMYID_FLOORMASTER
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz

	ld e,Enemy.var34
	ld a,(de)
	ld (hl),a ; [child.subid] = [this.var34]

	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld h,d
	ld l,Enemy.var30
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),$80
	ret

@delete:
	call decNumEnemies
	call markEnemyAsKilledInRoom
	jp enemyDelete


floormaster_state_galeSeed:
	call ecom_galeSeedEffect
	ret c

	ld a,Object.var30
	call objectGetRelatedObject1Var
	dec (hl)
	ld l,Enemy.var33
	dec (hl)
	jp enemyDelete


floormaster_state_stub:
	ret


; States 8+ are for subids 1+ (not spawner objects; actual, physical floormasters).

; Choosing a position to spawn at.
floormaster_state8:
	; If Link is within 8 pixels of his position last time a floormaster was spawned,
	; the floormaster will spawn at a random angle relative to Link. Otherwise, it
	; will spawn in the direction Link is moving.
	call floormaster_checkLinkMoved8PixelsAway
	ld a,$00
	push bc
	call c,getRandomNumber_noPreserveVars
	pop bc

	ld e,a
	ld a,(w1Link.angle)
	add e
	and $1f
	ld e,Enemy.var32
	ld (de),a

	; Try various distances away from Link ($50 to $10)
	ld a,$50
	ldh (<hFF8A),a

@tryDistance:
	ldh a,(<hFF8A)
	sub $10
	jr z,@doneLoop
	ldh (<hFF8A),a

	push bc
	ld e,Enemy.var32
	call objectSetPositionInCircleArc
	pop bc

	; Check that this position candidate is valid.

	; a = abs([w1Link.xh] - [this.xh])
	ld a,(de)
	ld e,a
	ld a,(w1Link.xh)
	sub e
	jr nc,+
	cpl
	inc a
+
	cp $80
	jr nc,@tryDistance

	ld e,Enemy.yh
	ld a,(de)
	cp LARGE_ROOM_HEIGHT<<4
	jr nc,@tryDistance

	; Tile must not be solid
	push bc
	call objectGetTileCollisions
	pop bc
	jr nz,@tryDistance

	; Found a valid position. Go to state 9
	ld h,d
	ld l,Enemy.state
	ld (hl),$09

	ld l,Enemy.counter1
	ld (hl),$20

	call objectGetAngleTowardEnemyTarget
	ld b,a

	; Subid 1 only: angle must be a cardinal direction
	ld e,Enemy.subid
	ld a,(de)
	dec a
	ld a,b
	jr nz,+
	add $04
	and $18
+
	ld e,Enemy.angle
	ld (de),a

	; Decide animation to use
	cp $10
	ld a,$00
	jr nc,+
	inc a
+
	ld e,Enemy.var30
	ld (de),a
	call enemySetAnimation
	call objectSetVisiblec1

@doneLoop:
	; Copy Link's position to spawner.var31/var32
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.var31
	ld a,(w1Link.yh)
	ldi (hl),a
	ld a,(w1Link.xh)
	ld (hl),a
	ret


; Emerging from ground
floormaster_state9:
	ld e,Enemy.animParameter
	ld a,(de)
	dec a
	jp nz,enemyAnimate

	ld e,Enemy.state
	ld a,$0a
	ld (de),a

	ld e,Enemy.var30
	ld a,(de)
	add $02
	jp enemySetAnimation


; Floating in place for [counter1] frames before chasing Link
floormaster_stateA:
	call ecom_decCounter1
	jr z,@beginChasing

	ld a,(hl)
	srl a
	srl a
	ld hl,@zVals
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.zh
	ld (de),a
	ret

@beginChasing:
	ld (hl),$f0 ; [counter1]

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.state
	ld (hl),$0b

	call floormaster_updateAngleTowardLink
	ld b,a

	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.xh
	bit 5,(hl)

	; Certain subids have higher speed?
	ld h,d
	ld l,Enemy.speed
	ld (hl),SPEED_60
	jr z,+
	ld (hl),SPEED_a0
+
	ld a,b
	add $02
	call enemySetAnimation
	jr floormaster_animate

@zVals:
	.db $fb $fc $fd $fd $fe $fe $ff $ff


; Chasing Link
floormaster_stateB:
	call ecom_decCounter1
	jr nz,@stillChasing

	; Time to go back into ground
	ld l,Enemy.zh
	ld (hl),$00
	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,e
	ld (hl),$0d ; [state]

	ld l,Enemy.var30
	ld a,$06
	add (hl)
	jp enemySetAnimation

@stillChasing:
	ld e,Enemy.var30
	ld a,(de)
	ldh (<hFF8D),a

	call floormaster_updateAngleTowardLink
	ld b,a
	ldh a,(<hFF8D)
	cp b
	jr z,++
	ld a,$02
	add b
	call enemySetAnimation
++
	call floormaster_updateZPosition
	call floormaster_getAdjacentWallsBitset
	call ecom_applyVelocityGivenAdjacentWalls

floormaster_animate:
	jp enemyAnimate


; Grabbing Link
floormaster_stateC:
	ld e,Enemy.animParameter
	ld a,(de)
	dec a
	jr z,@makeLinkInvisible
	dec a
	jr z,@setZToZero
	dec a
	jr nz,floormaster_animate

	; [animParameter] == 3
	; Set substate for LINK_STATE_GRABBED_BY_WALLMASTER
	ld a,$02
	ld (w1Link.substate),a
	jp objectSetInvisible

@makeLinkInvisible: ; [animParameter] == 1
	ld (de),a
	ld (w1Link.visible),a

	ld e,Enemy.yh
	ld a,(w1Link.yh)
	ld (de),a
	ld e,Enemy.xh
	ld a,(w1Link.xh)
	ld (de),a
	ret

@setZToZero: ; [animParameter] == 2
	xor a
	ld (de),a
	ld e,Enemy.zh
	ld (de),a
	jr floormaster_animate


; Sinking into ground
floormaster_stateD:
	ld e,Enemy.animParameter
	ld a,(de)
	cp $03
	jr nz,floormaster_animate

	; Tell spawner that there's one less floormaster on-screen before deleting self
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.var30
	dec (hl)

	jp enemyDelete


;;
; @param[out]	a	Value written to var30 (0 if Link is to the left, 1 if right)
floormaster_updateAngleTowardLink:
	call @checkLinkCollisionsEnabled
	ret nc

	call objectGetAngleTowardLink
	ld b,a
	and $0f
	jr nz,++

	; Link is directly above or below the floormaster
	ld e,Enemy.angle
	ld a,b
	ld (de),a
	ld e,Enemy.var30
	ld a,(de)
	ret
++
	ld e,Enemy.subid
	ld a,(de)
	dec a
	ld a,b
	jr nz,@subid0

@subid1:
	; Only move in cardinal directions
	ld e,Enemy.angle
	and $f8
	ld (de),a

	cp $10
	ld a,$00
	jr nc,+
	inc a
+
	ld e,Enemy.var30
	ld (de),a
	ret

@subid0:
	ld e,Enemy.angle
	ld (de),a

	cp $10
	ld a,$00
	jr nc,+
	inc a
+
	ld e,Enemy.var30
	ld (de),a
	ret

;;
; @param[out]	cflag	c if Link's collisions are enabled
@checkLinkCollisionsEnabled:
	ld a,(w1Link.collisionType)
	rlca
	ret c
	ld e,Enemy.var30
	ld a,(de)
	ret


;;
floormaster_updateZPosition:
	ld e,Enemy.counter1
	ld a,(de)
	and $07
	ret nz

	ld e,Enemy.var31
	ld a,(de)
	inc a
	and $07
	ld (de),a
	ld hl,@zVals
	rst_addAToHl
	ld e,Enemy.zh
	ld a,(hl)
	ld (de),a
	ret

@zVals:
	.db $fb $fc $fd $fc $fb $fa $f9 $fa



;;
; Checks whether Link has moved 8 pixels away from his position last time a floormaster
; was spawned.
;
; @param[out]	bc	Link's position
; @param[out]	cflag	c if he's within 8 pixels
floormaster_checkLinkMoved8PixelsAway:
	ld a,Object.var31
	call objectGetRelatedObject1Var
	ld a,(w1Link.yh)
	ld b,a
	sub (hl)
	add $08
	cp $10
	ld a,(w1Link.xh)
	ld c,a
	ret nc

	inc l
	sub (hl) ; [var32]
	add $08
	cp $10
	ret


;;
floormaster_initSpawner:
	ld e,Enemy.yh
	ld a,(de)
	and $f0
	swap a
	ld e,Enemy.var33
	ld (de),a

	ld e,Enemy.xh
	ld a,(de)
	and $f0
	swap a
	inc a
	ld e,Enemy.var34
	ld (de),a
	ret

;;
; Only screen boundaries count as "walls" for floormaster.
floormaster_getAdjacentWallsBitset:
	ld a,$02
	jp ecom_getTopDownAdjacentWallsBitset


; ==============================================================================
; ENEMYID_CUCCO
;
; Shares some code with ENEMYID_GIANT_CUCCO.
;
; Variables:
;   relatedObj1: INTERACID_PUFF object when transforming
;   var30: Number of times it's been hit (also read by PARTID_CUCCO_ATTACKER to decide
;          speed)
;   var31: Enemy ID to transform into, when a mystery seed is used on it
;   var32: Counter used while being held
;   var33: Counter until next PARTID_CUCCO_ATTACKER is spawned
; ==============================================================================
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


; Also used by ENEMYID_GIANT_CUCCO
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
; Also used by ENEMYID_GIANT_CUCCO.
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
; Also used by ENEMYID_GIANT_CUCCO.
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


; In the process of transforming (into ENEMYID_BABY_CUCCO or ENEMYID_GIANT_CUCCO, based on
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


; ==============================================================================
; ENEMYID_GIANT_CUCCO
;
; Variables are the same as ENEMYID_CUCCO.
; ==============================================================================
enemyCode3b:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

	ld e,Enemy.var2a
	ld a,(de)
	res 7,a

	; Check if hit by anything other than Link or shield.
	cp ITEMCOLLISION_L1_SWORD
	jr c,@normalStatus

	ld h,d
	ld l,Enemy.var30
	inc (hl)

	; NOTE: The cucco starts with 0 health. It's constantly reset to $40 here. This
	; isn't a problem in Seasons, but in Ages this seems to trigger a bug causing its
	; collisions to get disabled. See enemyTypes.s for details.
	ld l,Enemy.health
	ld (hl),$40

	ld l,Enemy.state
	ld a,(hl)
	cp $0a
	jr nc,@normalStatus
	ld (hl),$0a
	ld l,Enemy.zh
	ld (hl),$00

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw giantCucco_state_uninitialized
	.dw cucco_state_stub
	.dw cucco_state_grabbed
	.dw cucco_state_stub
	.dw cucco_state_stub
	.dw cucco_state_stub
	.dw cucco_state_stub
	.dw cucco_state_stub
	.dw cucco_state8 ; States 8 and 9 same as normal cucco (wandering around)
	.dw cucco_state9
	.dw giantCucco_stateA
	.dw giantCucco_stateB


giantCucco_state_uninitialized:
	ld a,SPEED_c0
	call ecom_setSpeedAndState8
	ld a,$30
	call setScreenShakeCounter
	jp objectSetVisiblec1


; Hit with anything other than Link or shield
giantCucco_stateA:
	ld e,Enemy.var30
	ld a,(de)
	cp $08
	jr c,@runAway

	; Hit at least 8 times
	call ecom_incState

	ld l,Enemy.var32
	ld (hl),$00

	ld a,SND_TELEPORT
	jp playSound

@runAway:
	call ecom_updateCardinalAngleAwayFromTarget
	call cucco_setAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr giantCucco_animate


; Charging toward Link after being hit 8 times
giantCucco_stateB:
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
	call cucco_setAnimationFromAngle
	call objectApplySpeed

giantCucco_animate:
	jp enemyAnimate


;;
cucco_setAnimationFromAngle:
	ld h,d
	ld l,Enemy.angle
	ld a,(hl)
	and $0f
	ret z

	ldd a,(hl)
	and $10
	swap a
	xor $01
	cp (hl) ; hl == direction
	ret z
	ld (hl),a
	jp enemySetAnimation


cucco_zVals:
	.db $00 $ff $ff $fe $fe $fe $fd $fd
	.db $fd $fd $fe $fe $fe $ff $ff $00


;;
cucco_checkSpawnCuccoAttacker:
	ld h,d
	ld l,Enemy.var33
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret nz
+
	; Must have been hit at least 16 times
	ld l,Enemy.var30
	ld a,(hl)
	cp $10
	ret c

	ld b,PARTID_CUCCO_ATTACKER
	call ecom_spawnProjectile

	ld e,Enemy.var30
	ld a,(de)
	sub $10
	and $1e
	rrca
	ld hl,@var33Vals
	rst_addAToHl
	ld e,Enemy.var33
	ld a,(hl)
	ld (de),a
	ret

@var33Vals:
	.db $1e $1a $18 $16 $14 $12 $10 $0e
	.db $0c


cucco_attacked:
	ld l,Enemy.health
	ld (hl),$40

	ld l,Enemy.state
	ld a,$0a
	cp (hl)
	jr z,++

	; Just starting to run away
	ld (hl),a
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ld l,Enemy.zh
	ld (hl),$00
++
	ld e,Enemy.var2a
	ld a,(de)
	rlca
	ret nc

	; Increment number of times hit
	ld l,Enemy.var30
	bit 5,(hl)
	jr nz,+
	inc (hl)
+
	ld a,SND_CHICKEN
	jp playSound


;;
; Cucco will transform into ENEMYID_BABY_CUCCO (if not aggressive) or ENEMYID_GIANT_CUCCO
; (if aggressive).
cucco_hitWithMysterySeed:
	ld l,Enemy.collisionType
	res 7,(hl)

	; Check if the cucco been hit 16 or more times
	ld l,Enemy.var30
	ld a,(hl)
	cp $10
	jr c,+
	ld a,ENEMYID_GIANT_CUCCO
	jr ++
+
	ld a,ENEMYID_BABY_CUCCO
++
	ld e,Enemy.var31
	ld (de),a

	ldbc INTERACID_PUFF,$02
	call objectCreateInteraction
	ret nz

	ld e,Enemy.relatedObj1
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld e,Enemy.state
	ld a,$0b
	ld (de),a

	jp objectSetInvisible


;;
cucco_playChickenSoundEvery32Frames:
	ld h,d
	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	ret nz

	ld l,Enemy.var32
	dec (hl)
	ld a,(hl)
	and $1f
	ret nz
	ld a,SND_CHICKEN
	jp playSound


; ==============================================================================
; ENEMYID_BUTTERFLY
; ==============================================================================
enemyCode37:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
.ifdef ROM_SEASONS
	; spring-only
	ld a,(wRoomStateModifier)
	or a
	jp nz,enemyDelete
.endif
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_40
	call ecom_setRandomAngle

	jp objectSetVisible81

@state1:
	ld bc,$1f1f
	call ecom_randomBitwiseAndBCE
	or b
	jr nz,++
	ld h,d
	ld l,Enemy.angle
	ld (hl),c
++
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary
	jp enemyAnimate


; ==============================================================================
; ENEMYID_GREAT_FAIRY
;
; Variables:
;   relatedObj2: Reference to INTERACID_PUFF
;   var30: Counter used to update Z-position as she floats up and down
;   var31: Number of hearts spawned (the ones that circle around Link)
; ==============================================================================
enemyCode38:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw greatFairy_state_uninitialized
	.dw greatFairy_state1
	.dw greatFairy_state2
	.dw greatFairy_state3
	.dw greatFairy_state4
	.dw greatFairy_state5
	.dw greatFairy_state6
	.dw greatFairy_state7
	.dw greatFairy_state8
	.dw greatFairy_state9


greatFairy_state_uninitialized:
	ld h,d
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.zh
	ld (hl),$f0
	ret


; Create puff
greatFairy_state1:
	call greatFairy_createPuff
	ret nz

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),$11
	ld a,MUS_FAIRY_FOUNTAIN
	ld (wActiveMusic),a
	ret


; Waiting for puff to disappear
greatFairy_state2:
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z

	call ecom_incState


; Waiting for Link to approach
greatFairy_state3:
	call greatFairy_checkLinkApproached
	jr nc,greatFairy_animate

	ld a,$80
	ld (wMenuDisabled),a

	ld a,DISABLE_COMPANION|DISABLE_LINK
	ld (wDisabledObjects),a

	ld hl,wLinkHealth
	ldi a,(hl)
	cp (hl)
	ld a,$04
	ld bc,TX_4100
	jr nz,++

	; Full health already
	ld e,Enemy.counter1
	ld a,30
	ld (de),a
	ld a,$08
	ld bc,TX_4105
++
	ld e,Enemy.state
	ld (de),a
	call showText

greatFairy_animate:
	call greatFairy_updateZPosition
	call enemyAnimate
	ld e,Enemy.yh
	ld a,(de)
	ld b,a
	ldh a,(<hEnemyTargetY)
	cp b
	jp c,objectSetVisiblec1
	jp objectSetVisiblec2


; Begin healing Link
greatFairy_state4:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$0c
	inc l
	ld (hl),$09 ; [counter2]


; Spawning hearts
greatFairy_state5:
	call greatFairy_playSoundEvery8Frames
	call ecom_decCounter1
	jr nz,greatFairy_animate

	ld (hl),$0c ; [counter1]
	inc l
	dec (hl) ; [counter2]
	jr z,@spawnedAllHearts
	call greatFairy_spawnCirclingHeart
	jr greatFairy_animate

@spawnedAllHearts:
	dec l
	ld (hl),30 ; [counter1]

	ld l,Enemy.state
	inc (hl)
	jr greatFairy_animate


; Hearts have all spawned, are now circling around Link
greatFairy_state6:
	call greatFairy_playSoundEvery8Frames
	call ecom_decCounter1
	jr nz,greatFairy_animate
	ld l,Enemy.state
	inc (hl)
	ld a,TREASURE_HEART_REFILL
	ld c,MAX_LINK_HEALTH
	call giveTreasure


; Waiting for all hearts to disappear
greatFairy_state7:
	call greatFairy_playSoundEvery8Frames
	ld e,Enemy.var31
	ld a,(de)
	or a
	jr nz,greatFairy_animate

	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),30


; About to disappear; staying in place for 30 frames
greatFairy_state8:
	call ecom_decCounter1
	jr nz,greatFairy_animate

	ld (hl),60 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,SND_FAIRYCUTSCENE
	call playSound


; Disappearing
greatFairy_state9:
	call ecom_decCounter1
	jp z,enemyDelete

	call greatFairy_animate

	; Flicker visibility
	ld h,d
	ld l,Enemy.counter1
	bit 0,(hl)
	ret nz
	ld l,Enemy.visible
	res 7,(hl)
	ret


;;
greatFairy_updateZPosition:
	ld h,d
	ld l,Enemy.var30
	dec (hl)
	ld a,(hl)
	and $07
	ret nz

	ld a,(hl)
	and $18
	swap a
	rlca
	sub $02
	bit 5,(hl)
	jr nz,++
	cpl
	inc a
++
	sub $10
	ld l,Enemy.zh
	ld (hl),a
	ret


;;
; @param[out]	cflag	c if Link approached
greatFairy_checkLinkApproached:
	call checkLinkVulnerable
	ret nc

	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	sub $10
	cp $21
	ret nc

	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $18
	cp $31
	ret

;;
greatFairy_spawnCirclingHeart:
	call getFreePartSlot
	ret nz

	ld (hl),PARTID_GREAT_FAIRY_HEART
	ld l,Part.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld h,d
	ld l,Enemy.var31
	inc (hl)
	ret


;;
greatFairy_createPuff:
	ldbc INTERACID_PUFF,$02
	call objectCreateInteraction
	ret nz

	ld a,h
	ld h,d
	ld l,Enemy.relatedObj2+1
	ldd (hl),a
	ld (hl),Interaction.start
	xor a
	ret

;;
greatFairy_playSoundEvery8Frames:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,SND_FAIRY_HEAL
	jp playSound


; ==============================================================================
; ENEMYID_FIRE_KEESE
;
; Variables:
;   var30: Distance away (in tiles) closest lit torch is
;   var31/var32: Position of lit torch it's moving towards to re-light itself
;   var33: Nonzero if fire has been shed (set to 2). Doubles as animation index?
;   var34: Position at which to search for a lit torch ($16 tiles are checked each frame,
;          so this gets incremented by $16 each frame)
;   var35: Angular rotation for subid 0. (set to -1 or 1 randomly on initialization, for
;          counterclockwise or clockwise movement)
; ==============================================================================
enemyCode39:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackNoSolidity

	; ENEMYSTATUS_JUST_HIT
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret nz

	; We collided with Link; if still on fire, transfer that fire to the ground.
	ld e,Enemy.var33
	ld a,(de)
	or a
	ret nz

	ld b,PARTID_FIRE
	call ecom_spawnProjectile

	ld h,d
	ld l,Enemy.oamFlags
	ld a,$01
	ldd (hl),a
	ld (hl),a

	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.damage
	ld (hl),-$04

	ld l,Enemy.var33
	ld (hl),$02

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	ld a,$03
	jp enemySetAnimation

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	cp $0b
	jr nc,fireKeese_stateBOrHigher
	rst_jumpTable
	.dw fireKeese_state_uninitialized
	.dw fireKeese_state_stub
	.dw fireKeese_state_stub
	.dw fireKeese_state_stub
	.dw fireKeese_state_stub
	.dw ecom_blownByGaleSeedState
	.dw fireKeese_state_stub
	.dw fireKeese_state_stub
	.dw fireKeese_state8
	.dw fireKeese_state9
	.dw fireKeese_stateA

fireKeese_stateBOrHigher:
	ld a,b
	rst_jumpTable
	.dw fireKeese_subid0
	.dw fireKeese_subid1


fireKeese_state_uninitialized:
	ld h,d
	ld l,Enemy.counter1
	ld (hl),$08

	ld l,Enemy.damage
	ld (hl),-$08

	bit 0,b
	ld l,e
	jr z,@subid0

@subid1:
	ld (hl),$0b ; [state]
	jp objectSetVisible82

@subid0:
	ld (hl),$0b ; [state]

	ld l,Enemy.zh
	ld (hl),-$1c

	ld l,Enemy.speed
	ld (hl),SPEED_80

	; Random angle
	ld bc,$1f01
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,b
	ld (de),a

	; Set var35 to 1 or -1 for clockwise or counterclockwise movement.
	ld a,c
	or a
	jr nz,+
	dec a
+
	ld e,Enemy.var35
	ld (de),a

	ld a,$01
	call enemySetAnimation
	jp objectSetVisiblec1


fireKeese_state_stub:
	ret


; Just lost fire; looks for a torch if one exists, otherwise it will keep flying around
; like normal.
fireKeese_state8:
	; Initialize "infinite" distance away from closest lit torch (none found yet)
	ld e,Enemy.var30
	ld a,$ff
	ld (de),a

	; Check all tiles in the room, try to find a lit torch to light self back on fire
	call objectGetTileAtPosition
	ld c,l
	ld l,$00
@nextTile:
	ld a,(hl)
	cp TILEINDEX_LIT_TORCH
	call z,fireKeese_addCandidateTorch
	inc l
	ld a,l
	cp LARGE_ROOM_HEIGHT<<4
	jr c,@nextTile

	; Check if one was found
	ld e,Enemy.var30
	ld a,(de)
	inc a
	ld h,d
	jr nz,@torchFound

	; No torch found. Go back to doing subid-specific movement.

	ld l,Enemy.subid
	bit 0,(hl)
	ld a,$0d
	jr z,++

	; Subid 1
	ld l,Enemy.counter1
	ld (hl),120
	ld a,$0c
++
	ld l,Enemy.state
	ld (hl),a
	ret

@torchFound:
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ld a,$03
	jp enemySetAnimation


; Moving towards a torch's position, marked in var31/var32
fireKeese_state9:
	ld h,d
	ld l,Enemy.var31
	call ecom_readPositionVars
	cp c
	jr nz,@notAtTargetPosition

	ldh a,(<hFF8F)
	cp b
	jr z,@atTargetPosition

@notAtTargetPosition:
	call fireKeese_moveToGround
	call ecom_moveTowardPosition
	jp enemyAnimate

@atTargetPosition:
	call fireKeese_moveToGround
	ret c

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),60

	ld a,$02
	jp enemySetAnimation


; Touched down on the torch; in the process of being lit back on fire
fireKeese_stateA:
	call ecom_decCounter1
	jr z,@gotoNextState

	ld a,(hl) ; [counter1]
	sub 30
	ret nz

	; [counter1] == 30
	ld l,Enemy.oamFlags
	ld a,$05
	ldd (hl),a
	ld (hl),a

	ld l,Enemy.damage
	ld (hl),-$08
	ld l,Enemy.var33
	xor a
	ld (hl),a
	jp enemySetAnimation

@gotoNextState:
	ld l,Enemy.angle
	ld a,(hl)
	add $10
	and $1f
	ld (hl),a

	ld l,Enemy.subid
	bit 0,(hl)
	ld a,$0d
	jr z,++

	; Subid 1
	ld l,Enemy.counter1
	ld (hl),120
	ld a,$0c
++
	ld (de),a
	ld a,$01
	jp enemySetAnimation


; Keese which move up and down on Z axis
fireKeese_subid0:
	call fireKeese_checkForNewlyLitTorch
	; Above function call may pop its return address, ignore everything below here

	ld e,Enemy.state
	ld a,(de)
	sub $0b
	rst_jumpTable
	.dw fireKeese_subid0_stateB
	.dw fireKeese_subid0_stateC
	.dw fireKeese_subid0_stateD


; Flying around on fire
fireKeese_subid0_stateB:
	call fireKeese_checkCloseToLink
	jr nc,@linkNotClose

	; Link is close
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),91
	ld l,Enemy.speed
	ld (hl),SPEED_a0

@linkNotClose:
	call ecom_decCounter1
	jr nz,++

	ld (hl),$08 ; [counter1]

	; Move clockwise or counterclockwise (var35 is randomly set to 1 or -1 on
	; initialization)
	ld e,Enemy.var35
	ld a,(de)
	ld l,Enemy.angle
	add (hl)
	and $1f
	ld (hl),a
++
	call objectApplySpeed
	call fireKeese_moveTowardCenterIfOutOfBounds
	jr fireKeese_animate


; Divebombing because Link got close enough
fireKeese_subid0_stateC:
	call ecom_decCounter1
	jr nz,++
	ld l,Enemy.state
	inc (hl)
	jr fireKeese_animate
++
	; Add some amount to Z-position
	ld a,(hl)
	and $f0
	swap a
	ld hl,fireKeese_subid0_zOffsets
	rst_addAToHl

	ld e,Enemy.z
	ld a,(de)
	add (hl)
	ld (de),a
	inc e
	ld a,(de)
	adc $00
	ld (de),a

	; Adjust angle toward Link
	call objectGetAngleTowardEnemyTarget
	ld b,a
	ld e,Enemy.counter1
	ld a,(de)
	and $03
	ld a,b
	call z,objectNudgeAngleTowards

fireKeese_updatePosition:
	call ecom_bounceOffScreenBoundary
	call objectApplySpeed

fireKeese_animate:
	jp enemyAnimate


; Moving back up after divebombing
fireKeese_subid0_stateD:
	ld h,d
	ld l,Enemy.z
	ld a,(hl)
	sub <($0040)
	ldi (hl),a
	ld a,(hl)
	sbc >($0040)
	ld (hl),a

	cp $e4
	jr nc,fireKeese_updatePosition

	ld l,e
	ld (hl),$0b ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.counter1
	ld (hl),$08
	jr fireKeese_animate


; Keese which has no Z-axis movement
fireKeese_subid1:
	call fireKeese_checkForNewlyLitTorch
	; Above function call may pop its return address, ignore everything below here

	ld e,Enemy.state
	ld a,(de)
	sub $0b
	rst_jumpTable
	.dw fireKeese_subid1_stateB
	.dw fireKeese_subid1_stateC
	.dw fireKeese_subid1_stateD


; Waiting [counter1] frames (8 frames) before moving
fireKeese_subid1_stateB:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	; Random angle
	ld bc,$1f3f
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,b
	ld (de),a

	; Random counter1 between $c0-$ff
	ld a,$c0
	add c
	ld e,Enemy.counter1
	ld (de),a

	; Set animation based on if on fire
	ld e,Enemy.var33
	ld a,(de)
	inc a
	call enemySetAnimation

	; Create fire when initially spawning
	ld e,Enemy.var33
	ld a,(de)
	or a
	ld b,PARTID_FIRE
	call z,ecom_spawnProjectile
	jp enemyAnimate


; Moving around randomly for [counter1]*2 frames
fireKeese_subid1_stateC:
	call fireKeese_updatePosition

	ld a,(wFrameCounter)
	and $01
	ret nz

	call ecom_decCounter1
	jr z,@gotoNextState

	; 1 in 16 chance of changing angle (every 2 frames)
	ld bc,$0f1f
	call ecom_randomBitwiseAndBCE
	or b
	ret nz
	ld e,Enemy.angle
	ld a,c
	ld (de),a
	ret

@gotoNextState:
	ld l,Enemy.state
	inc (hl)
	ret


; Slowing down, then stopping for a brief period
fireKeese_subid1_stateD:
	ld e,Enemy.counter1
	ld a,(de)
	cp $68
	jr nc,++

	call ecom_bounceOffScreenBoundary
	call objectApplySpeed
++
	call fireKeese_subid1_setSpeedAndAnimateBasedOnCounter1

	ld h,d
	ld l,Enemy.counter1
	inc (hl)
	ld a,$7f
	cp (hl)
	ret nz

	; Time to start moving again; go back to state $0b where we'll abruptly go fast.
	ld l,Enemy.state
	ld (hl),$0b

	ld e,Enemy.var33
	ld a,(de)
	call enemySetAnimation

	; Set counter1 to random value from $20-$9f
	call getRandomNumber_noPreserveVars
	and $7f
	ld e,Enemy.counter1
	add $20
	ld (de),a
	ret


;;
; Subid 1 slows down gradually in state $0d.
fireKeese_subid1_setSpeedAndAnimateBasedOnCounter1:
	ld e,Enemy.counter1
	ld a,(de)
	and $0f
	jr nz,++

	; Set speed based on value of counter1
	ld a,(de)
	swap a
	ld hl,fireKeese_subid1_speeds
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
++
	; Animate at some rate based on value of counter1
	ld e,Enemy.counter1
	ld a,(de)
	and $f0
	swap a
	ld hl,fireKeese_subid1_animFrequencies
	rst_addAToHl
	ld a,(wFrameCounter)
	and (hl)
	jp z,enemyAnimate
	ret


;;
; @param[out]	cflag	c if Link is within 32 pixels of keese in each direction
fireKeese_checkCloseToLink:
	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	add $20
	cp $41
	ret nc
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $20
	cp $41
	ret


;;
; Given the position of a torch, checks whether to update "position of closest known
; torch" (var31/var32).
;
; @param	c	Position of lit torch
fireKeese_addCandidateTorch:
	; Get Y distance
	ld a,c
	and $f0
	swap a
	ld b,a
	ld a,l
	and $f0
	swap a
	sub b
	jr nc,+
	cpl
	inc a
+
	ld b,a

	; Get X distance
	ld a,c
	and $0f
	ld e,a
	ld a,l
	and $0f
	sub e
	jr nc,+
	cpl
	inc a
+
	; Compare with closest candidate, return if farther away
	add b
	ld b,a
	ld e,Enemy.var30
	ld a,(de)
	cp b
	ret c

	; This is the closest torch found so far.
	ld a,b
	ld (de),a

	; Mark its position in var31/var32
	ld e,Enemy.var31
	ld a,l
	and $f0
	add $08
	ld (de),a
	inc e
	ld a,l
	and $0f
	swap a
	add $08
	ld (de),a
	ret


;;
; While the keese is not lit on fire, this function checks if any new lit torches suddenly
; appear in the room. If so, it sets the state to 8 and returns from the caller (discards
; return address).
fireKeese_checkForNewlyLitTorch:
	; Return if on fire already
	ld e,Enemy.var33
	ld a,(de)
	or a
	ret z

	; Check $16 tiles per frame, searching for a torch. (Searching all of them could
	; cause lag, especially with a lot of bats on-screen.)
	ld e,Enemy.var34
	ld a,(de)
	ld l,a
	ld h,>wRoomLayout
	ld b,$16
@loop:
	ldi a,(hl)
	cp TILEINDEX_LIT_TORCH
	jr z,@foundTorch
	dec b
	jr nz,@loop

	ld a,l
	cp LARGE_ROOM_HEIGHT<<4
	jr nz,+
	xor a
+
	ld (de),a
	ret

@foundTorch:
	pop hl ; Return from caller

	ld h,d
	ld l,e
	ld (hl),$00 ; [var34]

	; State 8 will cause the bat to move toward the torch.
	; (var31/var32 are not set here because the search will be done again in state 8.)
	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ret

;;
; @param[out]	cflag	nc if reached ground (or at most 6 units away)
fireKeese_moveToGround:
	ld e,Enemy.zh
	ld a,(de)
	or a
	ret z

	cp $fa
	ret nc

	; [Enemy.z] += $0080
	dec e
	ld a,(de)
	add <($0080)
	ld (de),a
	inc e
	ld a,(de)
	adc >($0080)
	ld (de),a
	scf
	ret


;;
fireKeese_moveTowardCenterIfOutOfBounds:
	ld e,Enemy.yh
	ld a,(de)
	cp LARGE_ROOM_HEIGHT<<4
	jr nc,@outOfBounds

	ld e,Enemy.xh
	ld a,(de)
	cp $f0
	ret c

@outOfBounds:
	ld e,Enemy.yh
	ld a,(de)
	ldh (<hFF8F),a
	ld e,Enemy.xh
	ld a,(de)
	ldh (<hFF8E),a

	ldbc ((LARGE_ROOM_HEIGHT/2)<<4) + 8, ((LARGE_ROOM_WIDTH/2)<<4) + 8
	call objectGetRelativeAngleWithTempVars
	ld c,a
	ld b,SPEED_100
	ld e,Enemy.angle
	jp objectApplyGivenSpeed


; Offsets for Z position, in subpixels.
fireKeese_subid0_zOffsets:
	.db $80 $60 $40 $30 $20 $20

; Speed values for subid 1, where it gradually slows down.
fireKeese_subid1_speeds:
	.db SPEED_c0 SPEED_80 SPEED_40 SPEED_40
	.db SPEED_20 SPEED_20 SPEED_20 SPEED_20

fireKeese_subid1_animFrequencies:
	.db $00 $00 $01 $01 $03 $03 $07 $00


; ==============================================================================
; ENEMYID_WATER_TEKTITE
; ==============================================================================
enemyCode3a:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	ret z

	; ENEMYSTATUS_KNOCKBACK
	; Need special knockback code for special "solidity" properties (water is
	; traversible, everything else is solid)
	ld e,Enemy.speed
	ld a,(de)
	push af
	ld a,SPEED_200
	ld (de),a
	ld e,Enemy.knockbackAngle
	call waterTektite_getAdjacentWallsBitsetGivenAngle
	ld e,Enemy.knockbackAngle
	call ecom_applyVelocityGivenAdjacentWalls

	pop af
	ld e,Enemy.speed
	ld (de),a
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw waterTektite_state_uninitialized
	.dw waterTektike_state_stub
	.dw waterTektike_state_stub
	.dw waterTektike_state_stub
	.dw waterTektike_state_stub
	.dw ecom_blownByGaleSeedState
	.dw waterTektike_state_stub
	.dw waterTektike_state_stub
	.dw waterTektike_state8
	.dw waterTektike_state9


waterTektite_state_uninitialized:
	call objectSetVisible82

waterTektike_decideNewAngle:
	ld h,d
	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.counter1
	ld (hl),$40

	ld a,(wScentSeedActive)
	or a
	jr nz,@scentSeedActive

	; Random diagonal angle
	call getRandomNumber_noPreserveVars
	and $18
	add $04
	ld e,Enemy.angle
	ld (de),a
	jr waterTektike_animate

@scentSeedActive:
	ldh a,(<hFFB2)
	ldh (<hFF8F),a
	ldh a,(<hFFB3)
	ldh (<hFF8E),a
	ld l,Enemy.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)
	call objectGetRelativeAngleWithTempVars
	ld e,Enemy.angle
	ld (de),a
	jr waterTektike_animate


waterTektike_state_stub:
	ret


; Moving in some direction for [counter1] frames, at varying speeds.
waterTektike_state8:
	call ecom_decCounter1
	jr nz,++

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$08
	jr waterTektike_animate
++
	call waterTektike_setSpeedFromCounter1

	call waterTektite_getAdjacentWallsBitset
	ld e,Enemy.angle
	call ecom_applyVelocityGivenAdjacentWalls
	call ecom_bounceOffScreenBoundary

waterTektike_animate:
	jp enemyAnimate



; Not moving for [counter1] frames; then choosing new angle
waterTektike_state9:
	call ecom_decCounter1
	jr nz,waterTektike_animate
	jr waterTektike_decideNewAngle

;;
; Gets the "adjacent walls bitset" for the tektike; since this swims, water is
; traversable, everything else is not.
;
; This is identical to "fish_getAdjacentWallsBitsetForKnockback".
;
waterTektite_getAdjacentWallsBitset:
	ld e,Enemy.angle

;;
; @param	de	Angle variable
waterTektite_getAdjacentWallsBitsetGivenAngle:
	ld a,(de)
	call ecom_getAdjacentWallTableOffset

	ld h,d
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	ld hl,ecom_sideviewAdjacentWallOffsetTable
	rst_addAToHl

	ld a,$10
	ldh (<hFF8B),a
	ld d,>wRoomLayout
@nextOffset:
	ldi a,(hl)
	add b
	ld b,a
	and $f0
	ld e,a
	ldi a,(hl)
	add c
	ld c,a
	and $f0
	swap a
	or e
	ld e,a
	ld a,(de)
	sub TILEINDEX_PUDDLE
	cp TILEINDEX_FD-TILEINDEX_PUDDLE+1
	ldh a,(<hFF8B)
	rla
	ldh (<hFF8B),a
	jr nc,@nextOffset

	xor $0f
	ldh (<hFF8B),a
	ldh a,(<hActiveObject)
	ld d,a
	ret


;;
; @param	hl	Pointer to counter1
waterTektike_setSpeedFromCounter1:
	ld a,(hl)
	srl a
	srl a
	ld hl,@speedVals
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	ret

@speedVals:
	.db SPEED_020 SPEED_040 SPEED_080 SPEED_0c0 SPEED_100 SPEED_140 SPEED_140 SPEED_140
	.db SPEED_100 SPEED_100 SPEED_0c0 SPEED_0c0 SPEED_080 SPEED_080 SPEED_040 SPEED_040


; ==============================================================================
; ENEMYID_SWORD_MOBLIN
; ENEMYID_SWORD_SHROUDED_STALFOS
; ENEMYID_SWORD_MASKED_MOBLIN
;
; Shares some code with ENEMYID_SWORD_DARKNUT.
;
; Variables:
;   var30: Nonzero if enemyCollisionMode was changed to ignore sword damage (due to the
;          enemy's sword blocking it)
; ==============================================================================
enemyCode3d:
enemyCode49:
enemyCode4a:
	call ecom_checkHazards
	call @runState
	jp swordEnemy_updateEnemyCollisionMode

@runState:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret
@dead:
	pop hl
	jp enemyDie

@normalStatus:
	call ecom_checkScentSeedActive
	jr z,++
	ld e,Enemy.speed
	ld a,SPEED_a0
	ld (de),a
++
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw swordEnemy_state_uninitialized
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_switchHook
	.dw swordEnemy_state_scentSeed
	.dw ecom_blownByGaleSeedState
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_stub
	.dw swordEnemy_state8
	.dw swordEnemy_state9
	.dw swordEnemy_stateA


swordEnemy_state_uninitialized:
	ld b,PARTID_ENEMY_SWORD
	call ecom_spawnProjectile
	ret nz

	call ecom_setRandomCardinalAngle
	call ecom_updateAnimationFromAngle

	ld a,SPEED_80
	call ecom_setSpeedAndState8AndVisible

	ld l,Enemy.counter1
	inc (hl)

	; Enable scent seeds
	ld l,Enemy.var3f
	set 4,(hl)

	jp swordEnemy_setChaseCooldown


swordEnemy_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret

@substate3:
	ld b,$09
	call ecom_fallToGroundAndSetState
	ld l,Enemy.counter1
	ld (hl),$10
	ret


swordEnemy_state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	ld h,d
	jp z,swordEnemy_gotoState8
	call ecom_updateAngleToScentSeed
	call ecom_updateAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemy
	call enemyAnimate
	jr swordEnemy_animate


swordEnemy_state_stub:
	ret


; Moving slowly in cardinal directions until Link get close.
swordEnemy_state8:
	call swordEnemy_checkLinkIsClose
	jp c,swordEnemy_beginChasingLink

	call ecom_decCounter1
	jp z,swordEnemy_chooseRandomAngleAndCounter1

	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,swordEnemy_animate

	; Hit a wall
	call ecom_bounceOffWallsAndHoles
	jp nz,ecom_updateAnimationFromAngle

swordEnemy_animate:
	jp enemyAnimate


; Started chasing Link (don't adjust angle until next state).
swordEnemy_state9:
	call ecom_decCounter1
	ret nz
	ld (hl),$60
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.speed
	ld (hl),SPEED_a0
	ret


; Chasing Link for [counter1] frames (adjusts angle appropriately).
swordEnemy_stateA:
	call ecom_decCounter1
	jp z,swordEnemy_gotoState8

	ld a,(hl)
	and $03
	jr nz,++
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
	call ecom_updateAnimationFromAngle
++
	call ecom_applyVelocityForSideviewEnemyNoHoles

	; Animate at double speed
	call enemyAnimate
	jr swordEnemy_animate


;;
; Reverts to state 8; wandering around in cardinal directions
swordEnemy_gotoState8:
	ld l,e
	ld (hl),$08 ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_80
	ld l,Enemy.angle
	ld a,(hl)
	add $04
	and $18
	ld (hl),a

	call ecom_updateAnimationFromAngle
	call swordEnemy_setChaseCooldown
	jr swordEnemy_animate


; ==============================================================================
; ENEMYID_SWORD_DARKNUT
; ==============================================================================
enemyCode48:
.ifdef ROM_AGES
	call ecom_checkHazards
.else
	call ecom_seasonsFunc_4446
.endif
	call @runState
	jp swordDarknut_updateEnemyCollisionMode

@runState:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	call nz,ecom_updateKnockbackAndCheckHazards
	jp swordDarknut_updateEnemyCollisionMode

@dead:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr nz,++
	ld hl,wKilledGoldenEnemies
	set 2,(hl)
++
	pop hl
	jp enemyDie

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw swordDarknut_state_uninitialized
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_switchHook
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_stub
	.dw swordDarknut_state8
	.dw swordDarknut_state9
	.dw swordDarknut_stateA


swordDarknut_state_uninitialized:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr nz,++
	ld a,(wKilledGoldenEnemies)
	bit 2,a
	jp nz,swordDarknut_delete
++
	jp swordEnemy_state_uninitialized


; Moving slowly in cardinal directions until Link get close.
; Identical to swordEnemy_state8.
swordDarknut_state8:
	call swordDarknut_checkLinkIsClose
	jr c,swordEnemy_beginChasingLink

	call ecom_decCounter1
	jr z,swordEnemy_chooseRandomAngleAndCounter1

	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,swordDarknut_animate

	; Hit a wall
	call ecom_bounceOffWallsAndHoles
	jp nz,ecom_updateAnimationFromAngle

swordDarknut_animate:
	jp enemyAnimate


; Started chasing Link (don't adjust angle until next state).
; Identical to swordEnemy_state9 except for the speed.
swordDarknut_state9:
	call ecom_decCounter1
	ret nz
	ld (hl),$60
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ret


; Chasing Link for [counter1] frames (adjusts angle appropriately).
; Identical to swordEnemy_stateA except for how quickly it turns toward Link.
swordDarknut_stateA:
	call ecom_decCounter1
	jp z,swordEnemy_gotoState8

	ld a,(hl)
	and $01
	jr nz,++
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
	call ecom_updateAnimationFromAngle
++
	call ecom_applyVelocityForSideviewEnemyNoHoles

	; Animate at double speed
	call enemyAnimate
	jr swordDarknut_animate

;;
swordEnemy_beginChasingLink:
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),$10
	call ecom_updateAngleTowardTarget
	jp ecom_updateAnimationFromAngle

;;
swordEnemy_chooseRandomAngleAndCounter1:
	ld bc,$3f07
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.counter1
	ld a,$50
	add b
	ld (de),a

	call @chooseAngle
	jp ecom_updateAnimationFromAngle

@chooseAngle:
	; 1 in 8 chance of moving toward Link
	ld a,c
	or a
	jp z,ecom_updateCardinalAngleTowardTarget
	jp ecom_setRandomCardinalAngle


;;
; @param[out]	cflag	c if Link is within 40 pixels of enemy in both directions (and
;			counter2, the timeout, has reached 0)
swordEnemy_checkLinkIsClose:
	call ecom_decCounter2
	ret nz

	; NOTE: Why does this use hFFB2, then hEnemyTargetX? It's mixing two position
	; variables.
	ld l,Enemy.yh
	ldh a,(<hFFB2)
	sub (hl)
	add $28
	cp $51
	ret nc
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $28
	cp $51
	ret

;;
; This is identical to the above function.
swordDarknut_checkLinkIsClose:
	call ecom_decCounter2
	ret nz

	; NOTE: Why does this use hFFB2, then hEnemyTargetX? It's mixing two position
	; variables.
	ld l,Enemy.yh
	ldh a,(<hFFB2)
	sub (hl)
	add $28
	cp $51
	ret nc
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $28
	cp $51
	ret


;;
; Sets counter2 to the number of frames to wait before chasing Link again. Higher subids
; have lower cooldowns.
swordEnemy_setChaseCooldown:
	ld e,Enemy.subid
	ld a,(de)
	ld bc,@counter2Vals
	call addAToBc
	ld e,Enemy.counter2
	ld a,(bc)
	ld (de),a
	ret

@counter2Vals:
	.db $14 $10 $0c


;;
; Updates enemyCollisionMode based on Link's angle relative to the enemy. In this way,
; Link's sword doesn't damage the enemy if positioned in such a way that their sword
; should block it.
swordEnemy_updateEnemyCollisionMode:
	ld b,$00
	ld e,Enemy.stunCounter
	ld a,(de)
	or a
	jr nz,++

	call swordEnemy_checkIgnoreCollision
	ld a,ENEMYCOLLISION_STALFOS_BLOCKED_WITH_SWORD
	ld b,$00
	jr nz,@setVars
++
	inc b
	ld e,Enemy.id
	ld a,(de)
	cp ENEMYID_SWORD_SHROUDED_STALFOS
	ld a,ENEMYCOLLISION_BURNABLE_ENEMY
	jr nz,@setVars
.ifdef ROM_AGES
	ld a,ENEMYCOLLISION_BURNABLE_ENEMY
.else
	ld a,ENEMYCOLLISION_BURNABLE_UNDEAD
.endif

@setVars:
	ld e,Enemy.enemyCollisionMode
	ld (de),a

	ld e,Enemy.var30
	ld a,b
	ld (de),a
	ret

;;
; Same as above, but with a different enemyCollisionMode for the darknut.
swordDarknut_updateEnemyCollisionMode:
	ld b,$00
	ld e,Enemy.stunCounter
	ld a,(de)
	or a
	jr nz,++

	call swordEnemy_checkIgnoreCollision
	ld a,ENEMYCOLLISION_DARKNUT_BLOCKED_WITH_SWORD
	ld b,$00
	jr nz,@setVars
++
	ld a,ENEMYCOLLISION_DARKNUT
	inc b

@setVars:
	ld e,Enemy.enemyCollisionMode
	ld (de),a

	ld e,Enemy.var30
	ld a,b
	ld (de),a
	ret

;;
; Check whether the angle between Link and the enemy is such that the collision should be
; ignored (due to the sword blocking it)
;
; Knockback is handled by PARTID_ENEMY_SWORD.
;
; @param[out]	zflag	z if sword hits should be ignored
swordEnemy_checkIgnoreCollision:
	ld e,Enemy.knockbackCounter
	ld a,(de)
	or a
	ret nz

	call objectGetAngleTowardEnemyTarget
	ld b,a
	ld e,Enemy.direction
	ld a,(de)
	add a
	ld hl,@angleBits
	rst_addDoubleIndex
	ld a,b
	jp checkFlag

@angleBits:
	.db $3f $00 $00 $00 ; DIR_UP
	.db $00 $3f $00 $00 ; DIR_RIGHT
	.db $00 $00 $3f $00 ; DIR_DOWN
	.db $00 $00 $f8 $01 ; DIR_LEFT


;;
swordDarknut_delete:
	call decNumEnemies
	jp enemyDelete


; ==============================================================================
; ENEMYID_PEAHAT
; ==============================================================================
enemyCode3e:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

	; ENEMYSTATUS_KNOCKBACK
	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_PEAHAT
	ret nz

@normalStatus:
	call peahat_updateEnemyCollisionMode
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw peahat_state_uninitialized
	.dw peahet_state_stub
	.dw peahet_state_stub
	.dw peahet_state_stub
	.dw peahet_state_stub
	.dw ecom_blownByGaleSeedState
	.dw peahet_state_stub
	.dw peahet_state_stub
	.dw peahat_state8
	.dw peahat_state9
	.dw peahat_stateA
	.dw peahat_stateB


peahat_state_uninitialized:
	call ecom_setSpeedAndState8AndVisible
	ld l,Enemy.counter1
	inc (hl)
	ret


peahet_state_stub:
	ret


; Stationary for [counter1] frames
peahat_state8:
	call ecom_decCounter1
	ret nz

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),$7f

	ld l,Enemy.speed
	ld (hl),SPEED_20

	ld l,Enemy.var30
	ld (hl),$0f
	call objectSetVisiblec1
	jr peahat_animate


; Accelerating
peahat_state9:
	call ecom_decCounter1
	jp nz,peahat_updatePosition

	ld l,Enemy.state
	inc (hl)

	call getRandomNumber_noPreserveVars
	and $07
	ld hl,peahat_counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	call ecom_setRandomAngle
	jr peahat_animate


; Flying around at top speed
peahat_stateA:
	call ecom_decCounter1
	jr z,@beginSlowingDown

	; Change angle every 32 frames
	ld a,(hl)
	and $1f
	call z,ecom_setRandomAngle

	call objectApplySpeed
	call ecom_bounceOffScreenBoundary
	jr peahat_animate

@beginSlowingDown:
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.counter1
	ld (hl),$00

peahat_animate:
	jp enemyAnimate


; Slowing down
peahat_stateB:
	ld h,d
	ld l,Enemy.counter1
	inc (hl)

	ld a,$80
	cp (hl)
	jp nz,peahat_updatePosition

	; Go to state 8 for $80 frames (if tile is non-solid) or 1 frame (if tile is
	; solid).
	ld (hl),$80 ; [counter1]
	push hl
	call objectGetTileCollisions
	pop hl
	jr z,+
	ld (hl),$01 ; [counter1]
+
	ld l,Enemy.state
	ld (hl),$08
	call objectSetVisiblec2
	jr peahat_animate


;;
peahat_updateEnemyCollisionMode:
	ld e,Enemy.zh
	ld a,(de)
	or a
	ld a,ENEMYCOLLISION_PEAHAT_VULNERABLE
	jr z,+
	ld a,ENEMYCOLLISION_PEAHAT
+
	ld e,Enemy.enemyCollisionMode
	ld (de),a
	ret

;;
; Adjusts speed based on counter1, updates position, animates.
peahat_updatePosition:
	ld e,Enemy.counter1
	ld a,(de)
	dec a
	cp $41
	jr nc,@animate

	and $78
	swap a
	rlca
	ld b,a
	sub $06
	jr c,+
	xor a
+
	ld e,Enemy.zh
	ld (de),a

	; Determine speed
	ld a,b
	ld hl,@speedVals
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary

@animate:
	ld e,Enemy.counter1
	ld a,(de)
	and $f0
	swap a
	ld hl,@animFrequencies
	rst_addAToHl
	ld b,(hl)
	ld a,b
	inc a
	jr nz,+
	call enemyAnimate
	ld b,$00
+
	ld a,(wFrameCounter)
	and b
	jp z,enemyAnimate
	ret

@animFrequencies:
	.db $ff $ff $ff $00 $00 $01 $03 $07

@speedVals:
	.db SPEED_c0 SPEED_c0 SPEED_c0 SPEED_80 SPEED_80 SPEED_40 SPEED_40 SPEED_20
	.db SPEED_20

peahat_counter1Vals:
	.db 180 180 210 210 240 240 0 0


; ==============================================================================
; ENEMYID_WIZZROBE
;
; Variables:
;   var30: The low byte of wWizzrobePositionReservations that this wizzrobe is using
;          (red wizzrobes only)
;   var31/var32: Target position (blue wizzrobes only)
; ==============================================================================
enemyCode40:
	call ecom_checkHazardsNoAnimationForHoles
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	jr @justHit

@justHit:
	; For red wizzrobes only...
	ld e,Enemy.subid
	ld a,(de)
	dec a
	ret nz

	ld e,Enemy.stunCounter
	ld a,(de)
	or a
	ret nz

	ld e,Enemy.var2a
	ld a,(de)
	cp ITEMCOLLISION_LINK|$80
	ret z

	; The wizzrobe is knocked out of its normal position; allow other wizzrobes to
	; spawn there
	jp wizzrobe_removePositionReservation

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw wizzrobe_state_uninitialized
	.dw wizzrobe_state_stub
	.dw wizzrobe_state_stub
	.dw wizzrobe_state_switchHook
	.dw wizzrobe_state_stub
	.dw ecom_blownByGaleSeedState
	.dw wizzrobe_state_stub
	.dw wizzrobe_state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw wizzrobe_subid0
	.dw wizzrobe_subid1
	.dw wizzrobe_subid2


wizzrobe_state_uninitialized:
	ld h,d
	ld l,Enemy.visible
	ld a,(hl)
	or $42
	ld (hl),a

	ld l,e
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr nz,@subid1Or2

@subid0:
	ld (hl),$08 ; [state]
	ld l,Enemy.counter1
	ld (hl),$50
	ret

@subid1Or2:
	dec a
	jr nz,@subid2

@subid1:
	ld (hl),$08 ; [state]
	ld hl,wWizzrobePositionReservations
	ld b,$10
	jp clearMemory

@subid2:
	ld (hl),$0b ; [state]
	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.counter1
	ld (hl),$08
	call ecom_setRandomCardinalAngle
	jp wizzrobe_setAnimationFromAngle


wizzrobe_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret

@substate3:
	call ecom_fallToGroundAndSetState
	ret nz

	ld l,Enemy.collisionType
	res 7,(hl)

	ld e,Enemy.subid
	ld a,(de)
	ld hl,@stateAndCounter1
	rst_addDoubleIndex

	ld e,Enemy.state
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret

@stateAndCounter1:
	.db $0b,  30 ; 0 == [subid]
	.db $0b, 150 ; 1
	.db $09,   0 ; 2


wizzrobe_state_stub:
	ret


; Green wizzrobe
wizzrobe_subid0:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw wizzrobe_subid0_state8
	.dw wizzrobe_subid0_state9
	.dw wizzrobe_subid0_stateA
	.dw wizzrobe_subid0_stateB


; Waiting [counter1] frames before spawning in
wizzrobe_subid0_state8:
	call ecom_decCounter1
	ret nz
	ld (hl),75
	ld l,e
	inc (hl) ; [state]
	jp objectSetVisiblec2


; Phasing in for [counter1] frames
wizzrobe_subid0_state9:
	call ecom_decCounter1
	jp nz,wizzrobe_checkFlickerVisibility

	ld (hl),72 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)

	call ecom_updateCardinalAngleTowardTarget
	jp wizzrobe_setAnimationFromAngle


; Fully phased in; standing there for [counter1] frames, and firing a projectile at some
; point
wizzrobe_subid0_stateA:
	call ecom_decCounter1
	jr z,@phaseOut

	; Fire a projectile when [counter1] == 52
	ld a,(hl)
	cp 52
	ret nz
	ld b,PARTID_WIZZROBE_PROJECTILE
	jp ecom_spawnProjectile

@phaseOut:
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	res 7,(hl)

	xor a
	jp enemySetAnimation


; Phasing out
wizzrobe_subid0_stateB:
	ld h,d
	ld l,Enemy.counter1
	inc (hl)
	ld a,(hl)
	cp 75
	jp c,wizzrobe_checkFlickerVisibility

	ld (hl),72 ; [counter1]
	ld l,e
	ld (hl),$08 ; [state]
	jp objectSetInvisible


; Red wizzrobe
wizzrobe_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw wizzrobe_subid1_state8
	.dw wizzrobe_subid1_state9
	.dw wizzrobe_subid1_stateA
	.dw wizzrobe_subid1_stateB


; Choosing a new position to spawn at
wizzrobe_subid1_state8:
	call wizzrobe_chooseSpawnPosition
	ret nz
	call wizzrobe_markSpotAsTaken
	ret z

	ld h,d
	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),60

	call ecom_updateCardinalAngleTowardTarget
	jp wizzrobe_setAnimationFromAngle


; Phasing in for [counter1] frames
wizzrobe_subid1_state9:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld (hl),72 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)
	jp objectSetVisiblec2


; Fully phased in; standing there for [counter1] frames, and firing a projectile at some
; point
wizzrobe_subid1_stateA:
	call ecom_decCounter1
	jr z,@phaseOut

	; Fire a projectile when [counter1] == 52
	ld a,(hl)
	cp 52
	ret nz
	ld b,PARTID_WIZZROBE_PROJECTILE
	jp ecom_spawnProjectile

@phaseOut:
	ld (hl),180 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	res 7,(hl)
	ret


; Phasing out
wizzrobe_subid1_stateB:
	call ecom_decCounter1
	jr z,@gotoState8

	ld a,(hl)
	cp 120
	ret c
	jp z,objectSetInvisible
	jp ecom_flickerVisibility

@gotoState8:
	ld l,e
	ld (hl),$08 ; [state]


;;
; Removes position reservation in "wWizzrobePositionReservations" allowing other wizzrobes
; to spawn here.
wizzrobe_removePositionReservation:
	ld h,d
	ld l,Enemy.var30
	ld l,(hl)
	ld h,>wWizzrobePositionReservations
	ld a,(hl)
	sub d
	ret nz
	ldd (hl),a
	ld (hl),a
	ret


; Blue wizzrobe
wizzrobe_subid2:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw wizzrobe_subid2_state8
	.dw wizzrobe_subid2_state9
	.dw wizzrobe_subid2_stateA
	.dw wizzrobe_subid2_stateB


; Currently phased in, attacking until [counter1] reaches 0 or it hits a wall
wizzrobe_subid2_state8:
	call ecom_decCounter1
	jr z,@phaseOut

	; Reorient toward Link in [counter2] frames
	inc l
	dec (hl) ; [counter2]
	jr nz,@updatePosition

	call ecom_updateCardinalAngleTowardTarget
	call wizzrobe_setAnimationFromAngle

	; Set random counter2 from $20-$5f
	call getRandomNumber_noPreserveVars
	and $3f
	add $20
	ld e,Enemy.counter2
	ld (de),a

@updatePosition:
	call wizzrobe_fireEvery32Frames
	call ecom_applyVelocityForSideviewEnemyNoHoles
	ret nz

@phaseOut:
	call ecom_incState
	ld l,Enemy.collisionType
	res 7,(hl)
	ret


; Currently phased out, choosing a target position
wizzrobe_subid2_state9:
	call wizzrobe_chooseSpawnPosition
	jp nz,ecom_flickerVisibility

	; Store target position
	ld h,d
	ld l,Enemy.var31
	ld (hl),b
	inc l
	ld (hl),c

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.zh
	dec (hl)

	call wizzrobe_setAngleTowardTargetPosition
	jr wizzrobe_setAnimationFromAngle


; Currently phased out, moving toward target position
wizzrobe_subid2_stateA:
	call wizzrobe_setAngleTowardTargetPosition
	call ecom_flickerVisibility
	call wizzrobe_checkReachedTargetPosition
	jp nc,objectApplySpeed

	; Reached target position
	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),$08

	ld l,Enemy.zh
	ld (hl),$00

	call ecom_updateCardinalAngleTowardTarget
	call wizzrobe_setAnimationFromAngle
	jp objectSetVisiblec2


; Standing still for [counter1] frames (8 frames) before phasing in and attacking again
wizzrobe_subid2_stateB:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld h,d
	ld l,e
	ld (hl),$08 ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)

	; Choose random counter1 between $80-$ff (how long to stay in state 8)
	ld bc,$7f3f
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.counter1
	ld a,b
	add $80
	ld (de),a

	; Choose random counter2 between $10-$4f (when to reorient toward Link)
	inc e
	ld a,c
	add $10
	ld (de),a

	call ecom_updateCardinalAngleTowardTarget
	call wizzrobe_setAnimationFromAngle
	jp objectSetVisiblec2

;;
wizzrobe_setAnimationFromAngle:
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	swap a
	rlca
	inc a
	jp enemySetAnimation

;;
; Flicker visibility when [counter1] < 45.
wizzrobe_checkFlickerVisibility:
	ld e,Enemy.counter1
	ld a,(de)
	cp 45
	ret c
	jp ecom_flickerVisibility

;;
; @param[out]	cflag	c if within 1 pixel of target position in both directions
wizzrobe_checkReachedTargetPosition:
	ld h,d
	ld l,Enemy.yh
	ld e,Enemy.var31
	ld a,(de)
	sub (hl)
	inc a
	cp $03
	ret nc
	ld l,Enemy.xh
	inc e
	ld a,(de)
	sub (hl)
	inc a
	cp $03
	ret


;;
wizzrobe_setAngleTowardTargetPosition:
	ld h,d
	ld l,Enemy.var31
	call ecom_readPositionVars
	call objectGetRelativeAngleWithTempVars
	ld e,Enemy.angle
	ld (de),a
	ret


;;
; Chooses a random position somewhere within the screen boundaries (accounting for camera
; position). It may choose a solid position (in which case this need to be called again).
;
; @param[out]	bc	Chosen position (long form)
; @param[out]	l	Chosen position (short form)
; @param[out]	zflag	nz if this tile has solidity
wizzrobe_chooseSpawnPosition:
	call getRandomNumber_noPreserveVars
	and $70 ; Value strictly under SCREEN_HEIGHT<<4
	ld b,a
	ldh a,(<hCameraY)
	add b
	and $f0
	add $08
	ld b,a
--
	call getRandomNumber
	and $f0
	cp SCREEN_WIDTH<<4
	jr nc,--

	ld c,a
	ldh a,(<hCameraX)
	add c
	and $f0
	add $08
	ld c,a
	jp getTileCollisionsAtPosition

;;
wizzrobe_fireEvery32Frames:
	ld e,Enemy.counter1
	ld a,(de)
	and $1f
	ret nz
	ld b,PARTID_WIZZROBE_PROJECTILE
	jp ecom_spawnProjectile


;;
; Marks a spot as taken in wWizzrobePositionReservations; the position is reserved so no
; other red wizzrobe can spawn there. If this position is already reserved, this returns
; with the zflag set.
;
; @param	l	Position
; @param[out]	zflag	z if position already reserved, or wWizzrobePositionReservations
;			is full
wizzrobe_markSpotAsTaken:
	push bc
	ld e,l
	ld b,$08
	ld c,b
	ld hl,wWizzrobePositionReservations
--
	ldi a,(hl)
	cp e
	jr z,@ret
	inc l
	dec b
	jr nz,--

	ld l,<wWizzrobePositionReservations
--
	ld a,(hl)
	or a
	jr z,@fillBlankSpot
	inc l
	inc l
	dec c
	jr nz,--
	jr @ret

@fillBlankSpot:
	ld (hl),e
	inc l
	ld (hl),d
	ld e,Enemy.var30
	ld a,l
	ld (de),a
	or d

@ret:
	pop bc
	ret


; ==============================================================================
; ENEMYID_CROW
; ENEMYID_BLUE_CROW
;
; Variables:
;   var30: "Base" animation index (direction gets added to this)
;   var31: Actual animation index
;   var32/var33: Target position (subid 1 only)
; ==============================================================================
enemyCode41:
enemyCode4c:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	ret z
	jp ecom_updateKnockbackNoSolidity

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw crow_state_uninitialized
	.dw crow_state_stub
	.dw crow_state_stub
	.dw crow_state_stub
	.dw crow_state_stub
	.dw ecom_blownByGaleSeedState
	.dw crow_state_stub
	.dw crow_state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw crow_subid0
	.dw crow_subid1


crow_state_uninitialized:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jp nz,ecom_setSpeedAndState8

	; Subid 0
	ld a,SPEED_140
	call ecom_setSpeedAndState8
	jp objectSetVisiblec1


crow_state_stub:
	ret


crow_subid0:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw crow_subid0_state8
	.dw crow_subid0_state9
	.dw crow_subid0_stateA


; Perched, waiting for Link to approach
crow_subid0_state8:
	call ecom_updateAngleTowardTarget
	call crow_setAnimationFromAngle

	; Check if Link has approached
	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	add $30
	cp $61
	ret nc

	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $18
	cp $31
	ret nc

	; Link has approached.
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),25

	ld l,Enemy.var30
	ld (hl),$02
	ret


; Moving up and preparing to charge at Link after [counter1] frames (25 frames)
crow_subid0_state9:
	call ecom_updateAngleTowardTarget
	call crow_setAnimationFromAngle
	call ecom_decCounter1
	jr z,@beginCharge

	ld a,(hl) ; [counter1]
	and $03
	jr nz,crow_subid0_animate

	ld l,Enemy.zh
	dec (hl)
	jr crow_subid0_animate

@beginCharge:
	inc l
	ld (hl),90 ; [counter2]

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.collisionType
	set 7,(hl)

	call ecom_updateAngleTowardTarget

	; Randomly add or subtract 4 from angle (will either overshoot or undershoot Link)
	call getRandomNumber_noPreserveVars
	and $04
	jr nz,+
	ld a,-$04
+
	ld b,a
	ld e,Enemy.angle
	ld a,(de)
	add b
	ld (de),a

	jr crow_subid0_animate


; Charging toward Link
crow_subid0_stateA:
	call crow_subid0_checkWithinScreenBounds
	jp nc,enemyDelete

	call ecom_decCounter2
	jr z,@applySpeed

	; Adjust angle toward Link every 8 frames
	ld a,(hl)
	and $07
	jr nz,@applySpeed

	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
	call crow_setAnimationFromAngle

@applySpeed:
	call objectApplySpeed

crow_subid0_animate:
	jp enemyAnimate


crow_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw crow_subid1_state8
	.dw crow_subid1_state9
	.dw crow_subid1_stateA
	.dw crow_subid1_stateB
	.dw crow_subid1_stateC
	.dw crow_subid1_stateD


; Checking whether it's ok to charge in right now
crow_subid1_state8:
	; Count the number of crows that are in state 9 or higher (number of crows that
	; are either about to or are already charging across the screen)
	ldhl FIRST_ENEMY_INDEX, Enemy.id
	ld b,$00
@nextEnemy:
	ld a,(hl)
	cp ENEMYID_CROW
	jr nz,++

	ld l,e ; l = state
	ldd a,(hl)
	dec l
	dec l
	cp $09
	jr c,++
	inc b
++
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	; Only allow 2 such crows at a time (this one needs to wait)
	ld a,b
	cp $02
	ret nc

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	or a
	ld a,60   ; 1st crow on-screen
	jr z,+
	ld a,240  ; 2nd crow on-screen
+
	ld (hl),a

	ld l,Enemy.var30
	ld (hl),$02
	ret


; Spawn in after [counter1] frames
crow_subid1_state9:
	call ecom_decCounter1
	ret nz

	; Determine spawn/target position data to read based on which screen quadrant Link
	; is in
	ld b,$00
	ldh a,(<hEnemyTargetY)
	cp (SMALL_ROOM_HEIGHT/2)<<4
	jr c,+
	ld b,$08
+
	ldh a,(<hEnemyTargetX)
	cp (SMALL_ROOM_WIDTH/2)<<4
	jr c,+
	set 2,b
+
	ld a,b
	ld hl,crow_offScreenSpawnData
	rst_addAToHl

	; Read in spawn position
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ldh (<hFF8F),a

	ld e,Enemy.xh
	ldi a,(hl)
	ld (de),a
	ldh (<hFF8E),a

	; Read in target position
	ld e,Enemy.var32
	ldi a,(hl)
	ld (de),a
	ld b,a

	inc e
	ld a,(hl)
	ld (de),a
	ld c,a

	; Set angle to target position
	call ecom_updateAngleTowardTarget

	call ecom_incState

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.zh
	ld (hl),-$06

	call crow_setAnimationFromAngle
	jp objectSetVisiblec1


; Moving into screen
crow_subid1_stateA:
	call crow_moveTowardTargetPosition
	jr nc,crow_subid1_animate

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),60

	call ecom_updateAngleTowardTarget
	call crow_setAnimationFromAngle

crow_subid1_animate:
	jp enemyAnimate


; Hovering in position for [counter1] frames before charging
crow_subid1_stateB:
	call ecom_decCounter1
	jr nz,crow_subid1_animate

	ld (hl),24  ; [counter1]
	inc l
	ld (hl),$00 ; [counter2]

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.var32
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a

	ld l,Enemy.speed
	ld (hl),SPEED_20
	jr crow_subid1_animate


; Moving, accelerating toward Link
crow_subid1_stateC:
	call crow_subid1_checkWithinScreenBounds
	jr nc,@outOfBounds

	call crow_updateAngleTowardLinkIfCounter1Zero
	call crow_updateSpeed
	call objectApplySpeed
	jr crow_subid1_animate

@outOfBounds:
	call ecom_incState
	jr crow_subid1_animate


; Moved out of bounds; go back to state 8 to eventually charge again
crow_subid1_stateD:
	ld h,d
	ld l,e
	ld (hl),$08 ; [state]

	ld l,Enemy.collisionType
	res 7,(hl)

	jp objectSetInvisible


;;
; Adjusts angle to move directly toward Link when [counter1] reaches 0. After this it
; underflows to 255, so the angle correction only happens once.
crow_updateAngleTowardLinkIfCounter1Zero:
	call ecom_decCounter1
	ret nz
	call ecom_updateAngleTowardTarget


;;
crow_setAnimationFromAngle:
	ld h,d
	ld l,Enemy.angle
	ld a,(hl)
	and $0f
	ret z

	bit 4,(hl)
	ld l,Enemy.var30
	ld a,(hl)
	jr nz,+
	inc a
+
	ld l,Enemy.var31
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
; Identical to crow_subid1_checkWithinScreenBounds.
;
; @param[out]	cflag	c if within screen bounds
crow_subid0_checkWithinScreenBounds:
	ld e,Enemy.yh
	ld a,(de)
	cp (SMALL_ROOM_HEIGHT<<4) + 8
	ret nc
	ld e,Enemy.xh
	ld a,(de)
	cp (SMALL_ROOM_WIDTH<<4) + 8
	ret

;;
; @param[out]	cflag	c if within 1 pixel of target position
crow_moveTowardTargetPosition:
	ld h,d
	ld l,Enemy.var32
	call ecom_readPositionVars
	sub c
	inc a
	cp $02
	jr nc,@moveToward

	ldh a,(<hFF8F)
	sub b
	inc a
	cp $02
	ret c

@moveToward:
	call ecom_moveTowardPosition
	call crow_setAnimationFromAngle
	or d
	ret

;;
; Updates speed based on counter2. For subid 1.
crow_updateSpeed:
	ld e,Enemy.counter2
	ld a,(de)
	cp $7f
	jr z,+
	inc a
	ld (de),a
+
	and $f0
	swap a
	ld hl,crow_speeds
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	ret


;;
; Identical to crow_subid0_checkWithinScreenBounds.
;
; @param[out]	cflag	c if within screen bounds
crow_subid1_checkWithinScreenBounds:
	ld e,Enemy.yh
	ld a,(de)
	cp (SCREEN_HEIGHT<<4) + 8
	ret nc
	ld e,Enemy.xh
	ld a,(de)
	cp (SCREEN_WIDTH<<4) + 8
	ret


; Speeds for subid 1; accerelates while chasing Link.
crow_speeds:
	.db SPEED_040 SPEED_080 SPEED_0c0 SPEED_100
	.db SPEED_140 SPEED_180 SPEED_1c0 SPEED_200

; Each row corresponds to a screen quadrant Link is in.
; Byte values:
;   b0/b1: Spawn Y/X position
;   b2/b3: Target Y/X position (position to move to before charging in)
crow_offScreenSpawnData:
	.db $60 $a0 $70 $90
	.db $60 $00 $70 $10
	.db $20 $a0 $10 $90
	.db $20 $00 $10 $10


; ==============================================================================
; ENEMYID_GEL
; ==============================================================================
enemyCode43:
	call ecom_checkHazardsNoAnimationForHoles
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

	; ENEMYSTATUS_JUST_HIT or ENEMYSTATUS_KNOCKBACK
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	jr nz,@normalStatus

	; Touched Link; attach self to him.
	ld e,Enemy.state
	ld a,$0c
	ld (de),a

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw gel_state_uninitialized
	.dw gel_state_stub
	.dw gel_state_stub
	.dw gel_state_stub
	.dw gel_state_stub
	.dw ecom_blownByGaleSeedState
	.dw gel_state_stub
	.dw gel_state_stub
	.dw gel_state8
	.dw gel_state9
	.dw gel_stateA
	.dw gel_stateB
	.dw gel_stateC
	.dw gel_stateD


gel_state_uninitialized:
	ld e,Enemy.counter1
	ld a,$10
	ld (de),a
	jp ecom_setSpeedAndState8AndVisible


gel_state_stub:
	ret


; Standing in place for [counter1] frames
gel_state8:
	call ecom_decCounter1
	jr nz,gel_animate

	; 1 in 8 chance of switching to "hopping" state
	call getRandomNumber_noPreserveVars
	and $07
	ld h,d
	jr nz,@inchForward

	; Prepare to hop
	ld l,Enemy.counter1
	ld (hl),$30

	ld l,Enemy.state
	ld (hl),$0a

	ld a,$02
	jp enemySetAnimation

@inchForward:
	ld l,Enemy.counter1
	ld (hl),$08

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.speed
	ld (hl),SPEED_40

	call ecom_updateAngleTowardTarget
	jr gel_animate


; Inching toward Link for [counter1] frames
gel_state9:
	call ecom_applyVelocityForSideviewEnemyNoHoles
	call ecom_decCounter1
	jr nz,gel_animate

	ld l,Enemy.state
	ld (hl),$08
	ld l,Enemy.counter1
	ld (hl),$10

gel_animate:
	jp enemyAnimate


; Preparing to hop toward Link
gel_stateA:
	call ecom_decCounter1
	jr nz,gel_animate

	call gel_beginHop
	jp ecom_updateAngleTowardTarget


; Hopping toward Link
gel_stateB:
	call ecom_applyVelocityForSideviewEnemy
	ld c,$28
	call objectUpdateSpeedZ_paramC
	ret nz

	; Just landed

	ld h,d
	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.counter1
	ld (hl),$10

	ld l,Enemy.collisionType
	set 7,(hl)
	jp objectSetVisiblec2


; Just latched onto Link
gel_stateC:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter2
	ld (hl),120

	ld a,$01
	jp enemySetAnimation


; Attached to Link, slowing him down
gel_stateD:
	ld a,(w1Link.yh)
	ld e,Enemy.yh
	ld (de),a
	ld a,(w1Link.xh)
	ld e,Enemy.xh
	ld (de),a

	call ecom_decCounter2
	jr z,@hopOff

	; If any button is pressed, counter2 goes down more quickly
	ld a,(wGameKeysJustPressed)
	or a
	jr z,++

	ld a,(hl) ; [counter2]
	sub $03
	jr nc,+
	ld a,$01
+
	ld (hl),a
++
	; Invert draw priority every 4 frames
	ld a,(hl)
	and $03
	jr nz,++
	ld l,Enemy.visible
	ld a,(hl)
	xor $07
	ld (hl),a
++
	; Disable use of sword
	ld hl,wccd8
	set 5,(hl)

	; Disable movement every other frame
	ld a,(wFrameCounter)
	rrca
	jr nc,gel_animate
	ld hl,wLinkImmobilized
	set 5,(hl)
	jr gel_animate

@hopOff:
	call gel_setAngleAwayFromLink
	jr gel_beginHop


;;
gel_beginHop:
	ld bc,-$200
	call objectSetSpeedZ

	ld l,Enemy.state
	ld (hl),$0b

	ld l,Enemy.speed
	ld (hl),SPEED_100

	xor a
	call enemySetAnimation

	ld a,SND_ENEMY_JUMP
	call playSound
	jp objectSetVisiblec1

;;
gel_setAngleAwayFromLink:
	ld a,(w1Link.angle)
	bit 7,a
	jp nz,ecom_setRandomAngle
	xor $10
	ld e,Enemy.angle
	ld (de),a
	ret


; ==============================================================================
; ENEMYID_PINCER
;
; Variables:
;   relatedObj1: Pointer to "head", aka subid 1 (only for body parts, subids 2+)
;   var31/var32: Base Y/X position (where it originates from)
;   var33: Amount extended (0 means still in hole)
;   var34: Copy of parent's "id" value. For body parts only.
; ==============================================================================
enemyCode45:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw pincer_state_uninitialized
	.dw pincer_state1
	.dw pincer_state_stub
	.dw pincer_state_stub
	.dw pincer_state_stub
	.dw pincer_state_stub
	.dw pincer_state_stub
	.dw pincer_state_stub

@normalState:
	dec b
	ld a,b
	rst_jumpTable
	.dw pincer_head
	.dw pincer_body
	.dw pincer_body
	.dw pincer_body


pincer_state_uninitialized:
	ld a,b
	or a
	jp nz,ecom_setSpeedAndState8

	; subid 0 only
	inc a
	ld (de),a ; [state] = 1


; Spawner only (subid 0): Spawn head and body parts, then delete self.
pincer_state1:
	ld b,$04
	call checkBEnemySlotsAvailable
	ret nz

	; Spawn head
	ld b,ENEMYID_PINCER
	call ecom_spawnUncountedEnemyWithSubid01
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a
	call objectCopyPosition

	; Spawn body parts
	ld c,h
	call ecom_spawnUncountedEnemyWithSubid01
	call pincer_setChildRelatedObj1
	; [child.subid] = 2 (incremented in above function call)

	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl)
	call pincer_setChildRelatedObj1
	; [child.subid] = 3

	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl)
	inc (hl)
	call pincer_setChildRelatedObj1
	; [child.subid] = 4

	; Spawner no longer needed
	jp enemyDelete


pincer_state_stub:
	ret


; Subid 1: Head of pincer (the "main" part, which is attackable)
pincer_head:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw pincer_head_state8
	.dw pincer_head_state9
	.dw pincer_head_stateA
	.dw pincer_head_stateB
	.dw pincer_head_stateC
	.dw pincer_head_stateD
	.dw pincer_head_stateE


; Initialization
pincer_head_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld e,Enemy.yh
	ld l,Enemy.var31
	ld a,(de)
	ldi (hl),a
	ld e,Enemy.xh
	ld a,(de)
	ld (hl),a
	ret


; Waiting for Link to approach
pincer_head_state9:
	ld c,$28
	call objectCheckLinkWithinDistance
	ret nc

	ld e,Enemy.state
	ld a,$0a
	ld (de),a
	jp objectSetVisible82


; Showing eyes as a "warning" that it's about to attack
pincer_head_stateA:
	ld e,Enemy.animParameter
	ld a,(de)
	dec a
	jp nz,enemyAnimate

	; Time to attack
	call ecom_incState

	ld l,Enemy.collisionType
	set 7,(hl)

	; Initial "extended" amount is 0
	ld l,Enemy.var33
	ld (hl),$00

	; "Dig up" the tile if coming from underground
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	ld a,BREAKABLETILESOURCE_SHOVEL
	call tryToBreakTile
.ifdef ROM_AGES
	; If in water, create a splash
	call objectCheckTileAtPositionIsWater
	jr nc,++

	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERACID_SPLASH
	ld bc,$fa00
	call objectCopyPositionWithOffset
++
.endif
	call ecom_updateAngleTowardTarget
	add $02
	and $1c
	rrca
	rrca
	inc a
	jp enemySetAnimation


; Extending toward target
pincer_head_stateB:
	call pincer_updatePosition

	ld e,Enemy.var33
	ld a,(de)
	add $02
	cp $20
	jr nc,@fullyExtended
	ld (de),a
	ret

@fullyExtended:
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$08
	ret


; Staying fully extended for several frames
pincer_head_stateC:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [state]
	ret


; Retracting
pincer_head_stateD:
	call pincer_updatePosition

	ld h,d
	ld l,Enemy.var33
	dec (hl)
	ret nz

	; Fully retracted
	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.collisionType
	res 7,(hl)
	jp objectSetInvisible


; Fully retracted; on cooldown
pincer_head_stateE:
	call ecom_decCounter1
	ret nz

	; Cooldown over
	ld l,e
	ld (hl),$09 ; [state]

	; Make sure Y/X position is fully fixed back to origin
	ld l,Enemy.var31
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a

	xor a
	jp enemySetAnimation


;;
; Subid 2-4: body of pincer (just decoration)
pincer_body:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9

; Initialization
@state8:
	ld a,$09
	ld (de),a ; [state]

	; Copy parent's base position (var31/var32)
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld e,Enemy.var31
	ldi a,(hl)
	ld (de),a
	inc l
	inc e
	ld a,(hl)
	ld (de),a

	ld e,Enemy.var34
	ld l,Enemy.id
	ld a,(hl)
	ld (de),a

	ld a,$09
	jp enemySetAnimation

@state9:
	; Check if parent was deleted
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Enemy.var34
	ld a,(de)
	cp (hl)
	jp nz,enemyDelete

	; Copy parent's angle, invincibilityCounter
	ld l,Enemy.angle
	ld e,l
	ld a,(hl)
	ld (de),a
	ld l,Enemy.invincibilityCounter
	ld e,l
	ld a,(hl)
	ld (de),a

	; Copy parent's visibility only if parent is in state $0b or higher
	ld l,Enemy.state
	ld a,(hl)
	cp $0b
	jr c,++

	ld l,Enemy.visible
	ld e,l
	ld a,(hl)
	ld (de),a
++
	call pincer_body_updateExtendedAmount
	jr pincer_updatePosition


;;
; Sets relatedObj1 of object 'h' to object 'c'.
; 'h' is part of the pincer's body, 'c' is the pincer's head.
; Also increments the body part's subid since that does need to be done...
pincer_setChildRelatedObj1:
	inc (hl) ; [subid]++
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c
	ret

;;
; Updates position based on "base position" (var31), angle, and distance extended (var33).
pincer_updatePosition:
	ld h,d
	ld l,Enemy.var31
	ld b,(hl)
	inc l
	ld c,(hl)
	inc l
	ld a,(hl)
	ld e,Enemy.angle
	jp objectSetPositionInCircleArc

;;
; Calculates value for var33 (amount extended) for a body part.
pincer_body_updateExtendedAmount:
	push hl
	ld e,Enemy.subid
	ld a,(de)
	sub $02
	rst_jumpTable
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid2:
	pop hl
	call @getExtendedAmountDividedByFour
	ld b,a
	add a
	add b
	ld (de),a
	ret

@subid3:
	pop hl
	call @getExtendedAmountDividedByFour
	add a
	ld (de),a
	ret

@subid4:
	pop hl
	call @getExtendedAmountDividedByFour
	ld (de),a
	ret

@getExtendedAmountDividedByFour:
	ld l,Enemy.var33
	ld e,l
	ld a,(hl)
	srl a
	srl a
	ret


; ==============================================================================
; ENEMYID_BALL_AND_CHAIN_SOLDIER
;
; Variables:
;   relatedObj2: reference to PARTID_SPIKED_BALL
;   counter1: Written to by PARTID_SPIKED_BALL?
;   var30: Signal for PARTID_SPIKED_BALL.
;          0: Ball should rotate at normal speed.
;          1: Ball should rotate at double speed.
;          2: Ball should be thrown at Link.
;   var31: State to return to after switch hook is used on enemy
; ==============================================================================
enemyCode4b:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus
	jp enemyDie

@normalStatus:
.ifdef ROM_AGES
	call ecom_checkHazards
.else
	call ecom_seasonsFunc_4446
.endif
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw ballAndChain_state_uninitialized
	.dw ballAndChain_state_stub
	.dw ballAndChain_state_stub
	.dw ballAndChain_state_switchHook
	.dw ballAndChain_state_stub
	.dw ballAndChain_state_stub
	.dw ballAndChain_state_stub
	.dw ballAndChain_state_stub
	.dw ballAndChain_state8
	.dw ballAndChain_state9
	.dw ballAndChain_stateA


ballAndChain_state_uninitialized:
	call ballAndChain_spawnSpikedBall
	ret nz

	ld a,SPEED_60
	call ecom_setSpeedAndState8AndVisible

	ld l,Enemy.var31
	ld (hl),$08
	ret


ballAndChain_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret

@substate3:
	ld e,Enemy.var31
	ld a,(de)
	ld b,a
	jp ecom_fallToGroundAndSetState


ballAndChain_state_stub:
	ret


; Waiting for Link to be close enough to attack
ballAndChain_state8:
	ld c,$38
	call objectCheckLinkWithinDistance
	jr nc,@moveTowardLink

	; Link is close enough
	call ecom_incState
	call ballAndChain_setDefaultState

	ld l,Enemy.counter1
	ld (hl),90

	; Signal PARTID_SPIKED_BALL to rotate faster
	ld l,Enemy.var30
	inc (hl)

	ld a,$01
	jp enemySetAnimation

@moveTowardLink:
	call ecom_updateAngleTowardTarget
	call ecom_applyVelocityForSideviewEnemyNoHoles

ballAndChain_animate:
	jp enemyAnimate


; Spinning up ball for [counter1] frames before attacking
ballAndChain_state9:
	call ecom_decCounter1
	jr nz,ballAndChain_animate

	inc (hl) ; [counter1]
	ld l,e
	inc (hl) ; [state]

	call ballAndChain_setDefaultState

	; Signal PARTID_SPIKED_BALL to begin throw toward Link
	ld l,Enemy.var30
	inc (hl)
	ret


; Waiting for PARTID_SPIKED_BALL to set this object's counter1 to 0 (signalling the throw
; is done)
ballAndChain_stateA:
	ld e,Enemy.counter1
	ld a,(de)
	or a
	ret nz

	; Throw done

	ld c,$38
	call objectCheckLinkWithinDistance
	ld h,d
	ld l,Enemy.state
	jr nc,@gotoState8

	; Link is close; attack again immediately
	dec (hl) ; [state] = 9
	call ballAndChain_setDefaultState
	ld l,Enemy.counter1
	ld (hl),90

	ld l,Enemy.var30
	dec (hl)
	ret

@gotoState8:
	; Link isn't close; go to state 8, waiting for him to be close enough
	ld (hl),$08 ; [state]
	call ballAndChain_setDefaultState

	ld l,Enemy.var30
	xor a
	ld (hl),a
	jp enemySetAnimation


;;
; @param[out]	zflag	z if spawned successfully
ballAndChain_spawnSpikedBall:
	; BUG: This checks for 4 enemy slots, but we actually need 4 part slots...
	ld b,$04
	call checkBEnemySlotsAvailable
	ret nz

	; Spawn the ball
	ld b,PARTID_SPIKED_BALL
	call ecom_spawnProjectile

	; Spawn the 3 parts of the chain. Their "relatedObj1" will be set to the ball (not
	; this enemy).
	ld c,h
	ld e,$01
@nextChain:
	call getFreePartSlot
	ld (hl),b
	inc l
	ld (hl),e
	ld l,Part.relatedObj1
	ld a,Part.start
	ldi (hl),a
	ld (hl),c
	inc e
	ld a,e
	cp $04
	jr nz,@nextChain
	ret


;;
; Sets state the enemy will return to after switch hook is used on it
;
; @param	hl	Pointer to state
ballAndChain_setDefaultState:
	ld a,(hl)
	ld l,Enemy.var31
	ld (hl),a
	ret


; ==============================================================================
; ENEMYID_HARDHAT_BEETLE
; ENEMYID_HARMLESS_HARDHAT_BEETLE
; ==============================================================================
enemyCode4d:
.ifdef ROM_AGES
enemyCode5f:
.endif
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8

@state_uninitialized:
.ifdef ROM_AGES
	ld e,Enemy.id
	ld a,(de)
	cp ENEMYID_HARMLESS_HARDHAT_BEETLE
	ld a,PALH_8d
	call z,loadPaletteHeader
.endif
	ld a,SPEED_60
	jp ecom_setSpeedAndState8AndVisible

@state_stub:
	ret

@state8:
	call ecom_updateAngleTowardTarget
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp enemyAnimate


.ifdef ROM_AGES
; ==============================================================================
; ENEMYID_LINK_MIMIC
;
; Shares code with ENEMYID_ARM_MIMIC.
; ==============================================================================
enemyCode64:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockback
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw armMimic_state_stub
	.dw armMimic_state_stub
	.dw armMimic_state_switchHook
	.dw armMimic_state_stub
	.dw ecom_blownByGaleSeedState
	.dw armMimic_state_stub
	.dw armMimic_state_stub
	.dw linkMimic_state8


@state_uninitialized:
	ld a,PALH_82
	call loadPaletteHeader
	call armMimic_uninitialized
	jp objectSetVisible83


linkMimic_state8:
	ld a,(wDisabledObjects)
	or a
	ret nz
	jr armMimic_state8
.endif


; ==============================================================================
; ENEMYID_ARM_MIMIC
;
; Shares code with ENEMYID_LINK_MIMIC.
;
; Variables:
;   var30: Animation index
; ==============================================================================
enemyCode4e:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw armMimic_uninitialized
	.dw armMimic_state_stub
	.dw armMimic_state_stub
	.dw armMimic_state_switchHook
	.dw armMimic_state_stub
	.dw ecom_blownByGaleSeedState
	.dw armMimic_state_stub
	.dw armMimic_state_stub
	.dw armMimic_state8


armMimic_uninitialized:
	ld e,Enemy.var30
	ld a,(w1Link.direction)
	add $02
	and $03
	ld (de),a
	call enemySetAnimation

	ld a,SPEED_100
	jp ecom_setSpeedAndState8AndVisible


armMimic_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw ecom_fallToGroundAndSetState8

@substate1:
@substate2:
	ret


armMimic_state_stub:
	ret


; Only "normal" state; simply moves in reverse of Link's direction.
armMimic_state8:
	; Check that Link is moving
	ld a,(wLinkAngle)
	inc a
	ret z

	add $0f
	and $1f
	ld e,Enemy.angle
	ld (de),a
	call ecom_applyVelocityForSideviewEnemyNoHoles

	ld h,d
	ld l,Enemy.var30
	ld a,(w1Link.direction)
	add $02
	and $03
	cp (hl)
	jr z,@animate

	ld (hl),a
	call enemySetAnimation
@animate:
	jp enemyAnimate


; ==============================================================================
; ENEMYID_MOLDORM
;
; Variables for head (subid 1):
;   var30: Tail 1 object index
;   var31: Tail 2 object index
;   var32: Animation index
;   var33: Angular speed (added to angle)
;
; Variables for tail (subids 2-3):
;   relatedObj1: Object to follow (either the head or the tail in front)
;   var30: Index for offset buffer
;   var31/var32: Parent object's position last frame
;   var33-var3b: Offset buffer. Stores the parent's movement offsets for up to 8 frames.
; ==============================================================================
enemyCode4f:
	call moldorm_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jr nz,@knockback

	; ENEMYSTATUS_JUST_HIT
	; Only apply this to the head (subid 1)
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jr nz,@normalStatus

	; [tail1.invincibilityCounter] = [this.invincibilityCounter]
	ld e,Enemy.invincibilityCounter
	ld l,e
	ld a,(de)
	ld b,a
	ld e,Enemy.var30
	ld a,(de)
	ld h,a
	ld (hl),b

	; [tail2.invincibilityCounter] = [this.invincibilityCounter]
	inc e
	ld a,(de)
	ld h,a
	ld (hl),b
	ret

@dead:
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp nz,moldorm_tail_delete

	; Following code is for moldorm head only.

	; BUG: The following code is supposed to kill the moldorm's tails. However, in the JP/US
	; versions, it fails to specify the "l" parameter which would tell it which object type it's
	; supposed to kill. Therefore, the type of object that gets killed will depend on what the
	; value of the "l" register happens to be here!
	;
	; The value of the "l" register depends on the address of "enemyConveyorTilesTable"
	; (specifically which sub-table it read depending on the collision types). In the JP/US
	; versions this always ends up being in the range between C0-FF, meaning it will always
	; end up trying to kill a "part" object instead of an enemy object.
	;
	; It can result in stuff like this happening:
	; https://clips.twitch.tv/DepressedSmilingChoughBatChest-7PttcCvmsts5H_EU
	;
	; Anyway, this code is mostly unnecessary because moldorm tails will delete themselves if
	; their parent goes missing. It could still prevent an edge-case where a moldorm tail could
	; get attached to another enemy that spawned in during the exact moment where a moldorm
	; died; but this is a purely theoretical scenario (and could only occur if the enemy was
	; spawned by another enemy ie. a red zol, positioned between the moldorm head and tail in
	; memory).
	ld e,Enemy.var30
	ld a,(de)
	ld h,a
.ifdef ENABLE_EU_BUGFIXES
	ld l,e
.endif
	call ecom_killObjectH
	inc e
	ld a,(de)
	ld h,a
	call ecom_killObjectH

.ifdef ROM_SEASONS
	; moldorm guarding jewel
	ld a,(wActiveRoom)
	cp <ROOM_SEASONS_0f4
	jr nz,+
	ld a,(wActiveGroup)
	or a
	jr nz,+
	inc a
	ld ($cfc0),a
+
.endif
	jp enemyDie

@knockback:
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jr nz,@normalStatus
	jp ecom_updateKnockbackAndCheckHazards

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw moldorm_state_uninitialized
	.dw moldorm_state1
	.dw moldorm_state_stub
	.dw moldorm_state_stub
	.dw moldorm_state_stub
	.dw moldorm_state_stub
	.dw moldorm_state_stub
	.dw moldorm_state_stub

@normalState:
	dec b
	ld a,b
	rst_jumpTable
	.dw moldorm_head
	.dw moldorm_tail
	.dw moldorm_tail


moldorm_state_uninitialized:
	ld a,b
	or a
	jr nz,@notSpawner

@spawner:
	inc a
	ld (de),a ; [state] = 1
	jr moldorm_state1

@notSpawner:
	call ecom_setSpeedAndState8AndVisible
	ld a,b
	dec a
	ret z
	add $07
	jp enemySetAnimation


; Spawner; spawn the head and tails, then delete self.
moldorm_state1:
	ld b,$03
	call checkBEnemySlotsAvailable
	jp nz,objectSetVisible82

	; Spawn head
	ld b,ENEMYID_MOLDORM
	call ecom_spawnUncountedEnemyWithSubid01

	; Spawn tail 1
	ld c,h
	push hl
	call ecom_spawnEnemyWithSubid01
	inc (hl) ; [subid] = 2
	call moldorm_tail_setRelatedObj1AndCopyPosition ; Follows head

	; Spawn tail 2
	ld c,h
	call ecom_spawnEnemyWithSubid01
	inc (hl)
	inc (hl) ; [subid] = 3
	call moldorm_tail_setRelatedObj1AndCopyPosition ; Follows tail1

	; [head.var30] = tail1
	ld b,h
	pop hl
	ld l,Enemy.var30
	ld (hl),c

	; [head.var31] = tail2
	inc l
	ld (hl),b

	; [head.enabled] = [this.enabled] (copy spawned index value)
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	call objectCopyPosition
	jp enemyDelete


moldorm_state_stub:
	ret


; Subid 1
moldorm_head:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$08

	ld l,Enemy.speed
	ld (hl),SPEED_100

	; Angular speed
	ld l,Enemy.var33
	ld (hl),$02

	call ecom_setRandomAngle
	jp moldorm_head_updateAnimationFromAngle


; Main state for head
@state9:
	call ecom_decCounter1
	jr nz,@applySpeed

	ld (hl),$08 ; [counter1]

	; Angle is updated every 8 frames.
	ld l,Enemy.var33
	ld e,Enemy.angle
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a
	call moldorm_head_updateAnimationFromAngle

	; 1 in 16 chance of inverting rotation every 8 frames
	call getRandomNumber_noPreserveVars
	and $0f
	jr nz,@applySpeed
	ld e,Enemy.var33
	ld a,(de)
	cpl
	inc a
	ld (de),a

@applySpeed:
	call ecom_bounceOffWallsAndHoles
	call nz,moldorm_head_updateAnimationFromAngle
	jp objectApplySpeed


moldorm_tail:
	ld e,Enemy.state
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	res 7,(hl)

	; Copy parent's current position into var31/var32
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.yh
	ld e,Enemy.var31
	ldi a,(hl)
	ld (de),a
	inc e
	inc l
	ld a,(hl)
	ld (de),a

	jp moldorm_tail_clearOffsetBuffer


; Main state for tail
@state9:
	; Check if parent deleted
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr z,moldorm_tail_delete

	; Get distance between parent's last and current Y position in high nibble of 'b'.
	; (Add 8 so it's positive.)
	ld l,Enemy.yh
	ld e,Enemy.var31
	ld a,(de)
	ld b,a
	ldi a,(hl)
	sub b
	add $08
	swap a
	ld b,a

	; Get distance between parent's last and current X position in low nibble of 'b'.
	inc e
	inc l
	ld a,(de)
	ld c,a
	ld a,(hl)
	sub c
	add $08
	or b
	ld b,a

	; Copy parent's Y/X to var31/var32
	ldd a,(hl)
	ld (de),a
	dec e
	dec l
	ld a,(hl)
	ld (de),a

	; Add the calculated position difference to the offset buffer starting at var33
	ld e,Enemy.var30
	ld a,(de)
	add Enemy.var33
	ld e,a
	ld a,b
	ld (de),a
	ld h,d
	ld l,Enemy.yh

	; Offset buffer index ++
	ld e,Enemy.var30
	ld a,(de)
	inc a
	and $07
	ld (de),a

	; Read next byte in offset buffer (value from 8 frames ago) to get the value to
	; add to our current position.
	add Enemy.var33
	ld e,a
	ld a,(de)
	ld b,a
	and $f0
	swap a
	sub $08
	add (hl) ; [yh]
	ldi (hl),a
	inc l
	ld a,b
	and $0f
	sub $08
	add (hl) ; [xh]
	ld (hl),a
	ret

;;
moldorm_tail_delete:
	call decNumEnemies
	jp enemyDelete


;;
; @param	h	Object to follow (either the head or the tail in front)
moldorm_tail_setRelatedObj1AndCopyPosition:
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c
	jp objectCopyPosition


;;
moldorm_head_updateAnimationFromAngle:
	ld e,Enemy.angle
	ld a,(de)
	add $02
	and $1c
	rrca
	rrca
	ld h,d
	ld l,Enemy.var32
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
moldorm_tail_clearOffsetBuffer:
	ld h,d
	ld l,Enemy.var33
	ld b,$02
	ld a,$88
--
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	dec b
	jr nz,--
	ret


;;
moldorm_checkHazards:
	ld b,a
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jr z,@checkHazards

	; Tails only; check if parent fell into a hazard
	ld a,Object.var3f
	call objectGetRelatedObject1Var
	ld a,(hl)
	and $07
	jr nz,@checkHazards
	ld a,b
	or a
	ret

@checkHazards:
	ld a,b
	jp ecom_checkHazardsNoAnimationForHoles


; ==============================================================================
; ENEMYID_FIREBALL_SHOOTER
; ==============================================================================
enemyCode50:
	dec a
	ret z
	dec a
	ret z
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw fireballShooter_state_uninitialized
	.dw fireballShooter_state1
	.dw fireballShooter_state_stub
	.dw fireballShooter_state_stub
	.dw fireballShooter_state_stub
	.dw fireballShooter_state_stub
	.dw fireballShooter_state_stub
	.dw fireballShooter_state_stub
	.dw fireballShooter_state8
	.dw fireballShooter_state9


fireballShooter_state_uninitialized:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld e,Enemy.subid
	ld a,(de)
	bit 7,a
	ret z
	ld (hl),$08 ; [state]
	ret


; "Spawner"; spawns shooters at each appropriate tile index, then deletes self.
fireballShooter_state1:
	xor a
	ldh (<hFF8D),a

	ld e,Enemy.yh
	ld a,(de)
	ld c,a ; c = tile index to spawn at

	ld hl,wRoomLayout
	ld b,LARGE_ROOM_HEIGHT<<4

@nextTile:
	ldi a,(hl)
	cp c
	jr nz,+++

	push bc
	push hl
	ld c,l
	dec c
	ld b,ENEMYID_FIREBALL_SHOOTER
	call ecom_spawnUncountedEnemyWithSubid01
	jr nz,@delete

	; [child.subid] = [this.subid] | $80
	ld e,l
	ld a,(de)
	set 7,a
	ldi (hl),a

	; [child.var03] = ([hFF8D]+1)&3 (timing offset)
	ldh a,(<hFF8D)
	inc a
	and $03
	ldh (<hFF8D),a
	ld (hl),a

	; Set child's position
	ld a,c
	and $f0
	add $06
	ld l,Enemy.yh
	ldi (hl),a
	ld a,c
	and $0f
	swap a
	add $08
	inc l
	ld (hl),a

	pop hl
	pop bc
+++
	dec b
	jr nz,@nextTile

@delete:
	jp enemyDelete


fireballShooter_state_stub:
	ret


; Initialization for "actual" shooter (not spawner)
fireballShooter_state8:
	ld a,$09
	ld (de),a ; [state]

	ld e,Enemy.var03
	ld a,(de)
	ld hl,fireballShooter_timingOffsets
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret


; Main state for actual shooter
fireballShooter_state9:
	call fireballShooter_checkAllEnemiesKilled
	; BUG: This does NOT return if it's just deleted itself! This could cause counter1
	; to be dirty the next time an enemy is spawned in its former slot.

	; Wait for Link to be far enough away
	ld c,$24
	call objectCheckLinkWithinDistance
	ret c

	; Wait for cooldown
	call ecom_decCounter1
	ret nz

	ld b,PARTID_GOPONGA_PROJECTILE
	call ecom_spawnProjectile

	; Random cooldown between $c0-$c7
	call getRandomNumber_noPreserveVars
	and $07
	add $c0
	ld e,Enemy.counter1
	ld (de),a
	ret


fireballShooter_timingOffsets:
	.db $4e $7e $ae $de


;;
; For subid $81 only, this deletes itself when all enemies are killed.
fireballShooter_checkAllEnemiesKilled:
	ld e,Enemy.subid
	ld a,(de)
	cp $81
	ret nz
	ld a,(wNumEnemies)
	or a
	ret nz

.ifdef ENABLE_BUGFIXES
	; Workaround for above mentioned bug: this will return from the caller.
	pop bc
.endif

	jp enemyDelete


; ==============================================================================
; ENEMYID_BEETLE
;
; Variables for spawner (subid 0):
;   var30: Number of beetles spawned in? It's never actually used, and it doesn't seem to
;          update correctly, so this was probably for some abandoned idea.
;
; Variables for actual beetles (subid 1+):
;   relatedObj1: Reference to spawner object (optional)
; ==============================================================================
enemyCode51:
	call beetle_checkHazards
	or a
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.subid
	ld a,(de)
	cp $02
	ret nz

	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret z

	ld h,d
	ld l,Enemy.state
	ld (hl),$0a

	ld l,Enemy.counter1
	ld (hl),$01
	ret

@dead:
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jr nz,++

	; Subid 1 only (falling from sky): Update spawner's var30.
	; Since the spawner spawns subid 2, this is probably broken... (not that it
	; matters since the spawner doesn't check its var30 anyway)
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	or a
	jr z,++
	ld a,Object.var30
	call objectGetRelatedObject1Var
	dec (hl)
++
	jp enemyDie

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw beetle_state_uninitialized
	.dw beetle_state_spawner
	.dw beetle_state_stub
	.dw beetle_state_switchHook
	.dw beetle_state_stub
	.dw beetle_state_galeSeed
	.dw beetle_state_stub
	.dw beetle_state_stub

@normalState:
	dec b
	ld a,b
	rst_jumpTable
	.dw beetle_subid1
	.dw beetle_subid2
	.dw beetle_subid3


beetle_state_uninitialized:
	ld a,b
	or a
	ld a,SPEED_80
	jp nz,ecom_setSpeedAndState8

	; Subid 0
	ld a,$01
	ld (de),a ; [state]


beetle_state_spawner:
	call ecom_decCounter2
	ret nz

	; Only spawn beetles when Link is close
	ld c,$20
	call objectCheckLinkWithinDistance
	ret nc

	ld e,Enemy.counter2
	ld a,90
	ld (de),a

	ld b,ENEMYID_BEETLE
	call ecom_spawnEnemyWithSubid01
	ret nz
	inc (hl) ; [subid] = 2
	jp objectCopyPosition


beetle_state_galeSeed:
	call ecom_galeSeedEffect
	ret c

	ld e,Enemy.relatedObj1+1
	ld a,(de)
	or a
	jr z,++

	ld h,a
	ld l,Enemy.var30
	dec (hl)
++
	call decNumEnemies
	jp enemyDelete


beetle_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret

@substate3:
	ld b,$0a
	jp ecom_fallToGroundAndSetState


beetle_state_stub:
	ret


; Falls from the sky
beetle_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw beetle_stateA


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)

	ld c,$08
	call ecom_setZAboveScreen

	call objectSetVisiblec1

	ld a,SND_FALLINHOLE
	jp playSound


; Falling in from above the screen
@state9:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	ret nz

	; [speedZ] = 0
	ld l,Enemy.speedZ
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.state
	inc (hl)

	call objectSetVisiblec2

	ld a,SND_BOMB_LAND
	call playSound

	call beetle_chooseRandomAngleAndCounter1
	jr beetle_animate


; Common beetle state
beetle_stateA:
	call ecom_decCounter1
	call z,beetle_chooseRandomAngleAndCounter1
	call ecom_applyVelocityForSideviewEnemyNoHoles

beetle_animate:
	jp enemyAnimate


; Spawns in instantly
beetle_subid2:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw beetle_stateA


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),30

	call ecom_updateCardinalAngleTowardTarget
	jp objectSetVisiblec2


; Moving toward Link for 30 frames, before starting random movement
@state9:
	call ecom_decCounter1
	jr nz,@keepMovingTowardLink

	inc (hl) ; [counter1] = 1
	ld l,e
	inc (hl) ; [state]
	jr beetle_stateA

@keepMovingTowardLink:
	ld a,(hl)
	cp 22
	jr nz,++
	ld l,Enemy.collisionType
	set 7,(hl)
++
	call ecom_applyVelocityForSideviewEnemy
	jr beetle_animate


; "Bounces in" when it spawns (dug up from the ground)
beetle_subid3:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw beetle_stateA


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speedZ
	ld a,<(-$102)
	ldi (hl),a
	ld (hl),>(-$102)

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	; Bounce in the direction Link is facing
	ld l,Enemy.angle
	ld a,(w1Link.direction)
	swap a
	rrca
	ld (hl),a

	jp objectSetVisiblec2


; Bouncing
@state9:
	ld c,$0e
	call objectUpdateSpeedZAndBounce
	jr c,@doneBouncing

	ld a,SND_BOMB_LAND
	call z,playSound

	; Enable collisions when it starts moving back down
	ld e,Enemy.speedZ+1
	ld a,(de)
	or a
	jr nz,++
	ld h,d
	ld l,Enemy.collisionType
	set 7,(hl)
++
	jp ecom_applyVelocityForSideviewEnemyNoHoles

@doneBouncing:
	call ecom_incState
	ld l,Enemy.speed
	ld (hl),SPEED_80


;;
beetle_chooseRandomAngleAndCounter1:
	ld bc,$071c
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,c
	ld (de),a

	ld a,b
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret

@counter1Vals:
	.db 15 30 30 60 60 60 90 90

;;
; Beetle has custom checkHazards function so it can decrease the spawner's var30 (number
; of spawned
beetle_checkHazards:
	ld b,a
	ld e,Enemy.state
	ld a,(de)
	cp $0a
	ld a,b
	ret c

	; Check if currently sinking in lava? (water doesn't count?)
	ld h,d
	ld l,Enemy.var3f
	bit 1,(hl)
	jr z,@checkHazards

	; When [counter1] == 59, decrement spawner's var30 if it exists?
	ld l,Enemy.counter1
	ld a,(hl)
	cp 59
	jr nz,@checkHazards

	ld l,Enemy.relatedObj1+1
	ld a,(hl)
	or a
	jr z,@checkHazards

	ld h,a
	ld l,Enemy.var30
	dec (hl)

@checkHazards:
	ld a,b
	jp ecom_checkHazards


; ==============================================================================
; ENEMYID_FLYING_TILE
;
; Variables:
;   var30/var31: Pointer to current address in flyingTile_layoutData
; ==============================================================================
enemyCode52:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp flyingTile_dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw flyingTile_state_uninitialized
	.dw flyingTile_state_spawner
	.dw flyingTile_state_stub
	.dw flyingTile_state_stub
	.dw flyingTile_state_stub
	.dw flyingTile_state_stub
	.dw flyingTile_state_stub
	.dw flyingTile_state_stub
	.dw flyingTile_state8
	.dw flyingTile_state9
	.dw flyingTile_stateA
	.dw flyingTile_stateB


flyingTile_state_uninitialized:
	ld e,Enemy.subid
	ld a,(de)
	rlca
	ld a,SPEED_1c0
	jp c,ecom_setSpeedAndState8

	; Subids $00-$7f only
	ld e,Enemy.state
	ld a,$01
	ld (de),a
	ret


flyingTile_state_spawner:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	inc l
	ld (hl),120 ; [counter1]

	ld e,Enemy.subid
	ld a,(de)
	ld hl,flyingTile_layoutData
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld e,Enemy.var03
	ldi a,(hl)
	ld (de),a


;;
; @param	hl	Address to save to var30/var31
@flyingTile_saveTileDataAddress:
	ld e,Enemy.var30
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

@substate1:
	call ecom_decCounter1
	ret nz

	ld (hl),60

	; Retrieve address in flyingTile_layoutData
	ld l,Enemy.var30
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	; Get next position to spawn tile at
	ldi a,(hl)
	ld c,a
	push hl

	call @flyingTile_saveTileDataAddress
	ld b,ENEMYID_FLYING_TILE
	call ecom_spawnEnemyWithSubid01
	jr nz,++

	; [child.subid] = [this.var03]
	ld l,Enemy.subid
	ld e,Enemy.var03
	ld a,(de)
	ld (hl),a

	ld l,Enemy.yh
	call setShortPosition_paramC
++
	pop hl
	ld a,(hl)
	or a
	ret nz

	; Spawned all tiles; delete the spawner.
	jp flyingTile_delete


flyingTile_state_stub:
	ret


; Initialization of actual flying tile (not spawner)
flyingTile_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)

	call flyingTile_overwriteTileHere
	jp objectSetVisiblec2


; Moving up before charging at Link
flyingTile_state9:
	ld h,d
	ld l,Enemy.z
	ld a,(hl)
	sub <($0080)
	ldi (hl),a
	ld a,(hl)
	sbc >($0080)
	ld (hl),a

	cp $fd
	jr nc,flyingTile_animate

	; Moved high enoguh
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.counter1
	ld (hl),$0f

flyingTile_animate:
	jp enemyAnimate


; Staying in place for [counter1] frames before charging Link
flyingTile_stateA:
	call ecom_decCounter1
	jr nz,flyingTile_animate

	ld l,e
	inc (hl) ; [state]

	call ecom_updateAngleTowardTarget
	jr flyingTile_animate


; Charging at Link
flyingTile_stateB:
	call objectApplySpeed
	call objectCheckTileCollision_allowHoles
	jr nc,flyingTile_animate


;;
flyingTile_dead:
	ld b,INTERACID_ROCKDEBRIS
	call objectCreateInteractionWithSubid00

;;
flyingTile_delete:
	call decNumEnemies
	jp enemyDelete

;;
; Overwrites the tile at this position with whatever it should become after a flying tile
; is created there (depends on subid).
flyingTile_overwriteTileHere:
	call objectGetShortPosition
	ld c,a
	ld e,Enemy.subid
	ld a,(de)
	and $0f
	ld hl,@tileReplacements
	rst_addAToHl
	ld a,(hl)
	jp setTile


@tileReplacements:
	.db $a0 $f3 $f4 $4c $a4


.ifdef ROM_AGES
flyingTile_layoutData:
	.dw @subid0
	.dw @subid1
	.dw @subid2

; First byte is value for var03 (subid for spawned children).
; All remaining bytes are positions at which to spawn flying tiles.
; Ends when it reads $00.
@subid0:
	.db $80
	.db $57 $56 $46 $47 $48 $58 $68 $67
	.db $66 $65 $55 $45 $36 $37 $38 $49
	.db $59 $69 $78 $77 $76 $54 $5a
	.db $00

@subid1:
	.db $80
	.db $57 $46 $48 $39 $35 $26 $37 $59
	.db $49 $38 $29 $28 $36 $45 $56 $58
	.db $27 $47 $55 $25
	.db $00

@subid2:
	.db $80
	.db $67 $54 $5a $47 $34 $3a $76 $38
	.db $78 $36 $58 $45 $49 $56 $65 $69
	.db $00
.else
flyingTile_layoutData:
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3

@subid0:
	.db $82
	.db $34 $66 $44 $56 $54 $46 $64 $36
	.db $35 $65 $45 $55
	.db $00
@subid1:
	.db $82
	.db $19 $59 $7c $79 $76 $73 $93
	.db $00
@subid2:
	.db $80
	.db $57 $46 $54 $66 $37 $77 $48 $68
	.db $5a $5b $27 $87 $45 $69 $65 $49
	.db $53 $36 $78 $38 $76 $44 $6a $64
	.db $4a $55 $59 $47 $67 $56 $58
	.db $00
@subid3:
	.db $80
	.db $36 $76 $38 $78 $44 $64 $4a $6a
	.db $26 $88 $75 $39 $35 $79 $43 $6b
	.db $63 $4b $37 $87 $77 $27 $53 $34
	.db $7a $74 $3a $28 $86 $5b
	.db $00
.endif


; ==============================================================================
; ENEMYID_DRAGONFLY
; ==============================================================================
enemyCode53:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw dragonfly_state0
	.dw dragonfly_state1
	.dw dragonfly_state2
	.dw dragonfly_state3
	.dw dragonfly_state4
	.dw dragonfly_state5


; Initialization
dragonfly_state0:
.ifdef ROM_SEASONS
	ld a,(wRoomStateModifier)
	cp SEASON_AUTUMN
	jp nz,enemyDelete
.endif
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.subid
	ld a,(hl)
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.zh
	ld (hl),-$08
	jp objectSetVisiblec1


; Choosing new direction to move in
dragonfly_state1:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$03

	ld l,Enemy.speed
	ld (hl),SPEED_200

	call getRandomNumber_noPreserveVars
	and $06
	ld c,a

	ld b,$00
	ld e,Enemy.yh
	ld a,(de)
	cp (SMALL_ROOM_HEIGHT/2)<<4
	jr c,+
	inc b
+
	ld e,Enemy.xh
	ld a,(de)
	cp (SMALL_ROOM_WIDTH/2)<<4
	jr c,+
	set 1,b
+
	ld a,b
	ld hl,@angleVals
	rst_addAToHl
	ld a,(hl)
	add c
	and $1f
	ld e,Enemy.angle
	ld (de),a

	; Update animation
	ld e,Enemy.angle
	ld a,(de)
	ld b,a
	and $0f
	ret z

	ld a,b
	cp $10
	ld a,$01
	jr c,+
	dec a
+
	jp enemySetAnimation

@angleVals:
	.db $08 $02 $12 $18


; Move in given direction for 3 frames at SPEED_200
dragonfly_state2:
	call dragonfly_applySpeed
	jr nz,@nextState

	call ecom_decCounter1
	jr nz,dragonfly_animate

@nextState:
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$0c

dragonfly_animate:
	jp enemyAnimate


; Slowing down over 12 frames, eventually reaching SPEED_140
dragonfly_state3:
	call dragonfly_applySpeed
	jr nz,@nextState

	call ecom_decCounter1
	jr z,@nextState

	ld a,(hl) ; [counter1]
	rrca
	jr nc,dragonfly_animate

	ld l,Enemy.speed
	ld a,(hl)
	sub SPEED_20
	ld (hl),a
	jr dragonfly_animate

@nextState:
	ld e,Enemy.state
	ld a,$04
	ld (de),a

	; Set counter1 somewhere in range $18-$1f
	call getRandomNumber_noPreserveVars
	and $07
	add $18
	ld e,Enemy.counter1
	ld (de),a
	jr dragonfly_animate


; Moving at SPEED_140 for between 24-31 frames
dragonfly_state4:
	call dragonfly_applySpeed
	jr nz,@nextState

	call ecom_decCounter1
	jr nz,dragonfly_animate

@nextState:
	call getRandomNumber_noPreserveVars
	and $7f
	add $20
	ld e,Enemy.counter1
	ld (de),a

	ld e,Enemy.state
	ld a,$05
	ld (de),a
	jr dragonfly_animate


; Holding still for [counter1] frames
dragonfly_state5:
	call ecom_decCounter1
	jr nz,dragonfly_animate

	ld l,e
	ld (hl),$01 ; [state]
	jr dragonfly_animate


;;
; @param[out]	zflag	nz if touched a wall
dragonfly_applySpeed:
	ld a,$02 ; Only screen boundaries count as walls
	call ecom_getSideviewAdjacentWallsBitset
	ret nz
	call objectApplySpeed
	xor a
	ret


; ==============================================================================
; ENEMYID_BUSH_OR_ROCK
;
; Variables:
;   var30: Enemy ID of parent object
; ==============================================================================
enemyCode58:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,@destroyed

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_grabbed
	.dw @state_switchHook
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8


@state_uninitialized:
	; Initialize enemyCollisionMode and load tile to mimic
	ld e,Enemy.subid
	ld a,(de)
	ld hl,@collisionAndTileData
	rst_addDoubleIndex

	ld e,Enemy.enemyCollisionMode
	ldi a,(hl)
	ld (de),a

	ld a,(hl)
	call objectMimicBgTile

	call @checkDisableDestruction
	call ecom_setSpeedAndState8
	call @copyParentPosition
	jr @setPriorityRelativeToLink


@collisionAndTileData:
	.db ENEMYCOLLISION_BUSH, TILEINDEX_OVERWORLD_BUSH_1 ; Subid 0
	.db ENEMYCOLLISION_BUSH, TILEINDEX_DUNGEON_BUSH     ; Subid 1
	.db ENEMYCOLLISION_ROCK, TILEINDEX_DUNGEON_POT      ; Subid 2
	.db ENEMYCOLLISION_ROCK, TILEINDEX_OVERWORLD_ROCK   ; Subid 3



@state_grabbed:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0: ; Just picked up
	ld h,d
	ld l,e
	inc (hl)

	ld l,Enemy.collisionType
	res 7,(hl)

	xor a
	ld (wLinkGrabState2),a
	call @makeParentEnemyVisibleAndRemoveReference
	jp objectSetVisible81

@@substate1: ; Being held
	ret

@@substate2: ; Being thrown
	ld h,d

	; No longer persist between screens
	ld l,Enemy.enabled
	res 1,(hl)

	ld l,Enemy.zh
	bit 7,(hl)
	ret nz

@@substate3:
	call objectSetPriorityRelativeToLink
	jr @makeDebrisAndDelete


@state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	call @makeParentEnemyVisibleAndRemoveReference
	jp ecom_incSubstate

@@substate1:
@@substate2:
	ret

@@substate3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	jr @makeDebrisAndDelete


@state_stub:
	ret


@state8:
	; Check if parent object's type has changed, if so, delete self?
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Enemy.var30
	ld a,(de)
	cp (hl)
	jp nz,enemyDelete

	ld l,Enemy.var03
	ld a,(hl)
	rlca
	call c,objectAddToGrabbableObjectBuffer
	call @copyParentPosition

@setPriorityRelativeToLink:
	jp objectSetPriorityRelativeToLink


@destroyed:
	call @makeParentEnemyVisibleAndRemoveReference

@makeDebrisAndDelete:
	ld e,Enemy.subid
	ld a,(de)
	ld hl,@debrisTypes
	rst_addAToHl
	ld b,(hl)
	call objectCreateInteractionWithSubid00
	jp enemyDelete

; Debris for each subid (0-3)
@debrisTypes:
	.db INTERACID_GRASSDEBRIS
	.db INTERACID_GRASSDEBRIS
	.db INTERACID_ROCKDEBRIS
	.db INTERACID_ROCKDEBRIS

;;
; Make parent visible, remove self from Parent.relatedObj2
@makeParentEnemyVisibleAndRemoveReference:
	ld a,Object.visible
	call objectGetRelatedObject1Var
	set 7,(hl)
	ld l,Enemy.relatedObj2
	xor a
	ldi (hl),a
	ld (hl),a
	ret

;;
; Copies parent position, with a Z offset determined by parent.var03.
@copyParentPosition:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	call objectTakePosition

	ld l,Enemy.var03
	ld a,(hl)
	and $03
	ld hl,@zVals
	rst_addAToHl
	ld e,Enemy.zh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

@zVals:
	.db $00 $fc $f8 $f4

;;
; Disable bush destruction for deku scrubs only.
@checkDisableDestruction:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a

	; Don't allow destruction of bush for deku scrubs
	cp ENEMYID_DEKU_SCRUB
	ret nz
	ld e,Enemy.enemyCollisionMode
	ld a,ENEMYCOLLISION_ROCK
	ld (de),a
	ret


; ==============================================================================
; ENEMYID_ITEM_DROP_PRODUCER
;
; Variables:
;   var30: Tile at position (item drop will spawn when this changes)
; ==============================================================================
enemyCode59:
	ld e,Enemy.state
	ld a,(de)
	or a
	jr nz,@state1

@state0:
	; Initialization
	ld a,$01
	ld (de),a ; [state]
	call objectGetTileAtPosition
	ld e,Enemy.var30
	ld (de),a

@state1
	call objectGetTileAtPosition
	ld h,d
	ld l,Enemy.var30
	cp (hl)
	ret z

	; Tile has changed.

	; Delete self if Link can't get the item drop yet (ie. doesn't have bombs)
	ld e,Enemy.subid
	ld a,(de)
	call checkItemDropAvailable
	jp z,enemyDelete

	call getFreePartSlot
	ret nz
	ld (hl),PARTID_ITEM_DROP

	; [child.subid] = [this.subid]
	inc l
	ld e,Enemy.subid
	ld a,(de)
	ld (hl),a

	call objectCopyPosition
	call markEnemyAsKilledInRoom
	jp enemyDelete


; ==============================================================================
; ENEMYID_SEEDS_ON_TREE
;
; Variables:
;   var03: Child "PARTID_SEED_ON_TREE" objects write here when Link touches them?
; ==============================================================================
enemyCode5a:
	ld e,Enemy.state
	ld a,(de)
	or a
	jr nz,@state1


; Initialization
@state0:
	ld a,$01
	ld (de),a ; [state]

.ifdef ROM_AGES
	; Locate tree
	ld a,TILEINDEX_MYSTICAL_TREE_TL
	call findTileInRoom
	jp nz,interactionDelete ; BUG: Wrong function call! (see below)

	; Move to that position
	ld c,l
	ld h,d
	ld l,Enemy.yh
	call setShortPosition_paramC
	ld bc,$0808
	call objectCopyPositionWithOffset

	ld e,Enemy.subid
	ld a,(de)
	and $0f
	ld hl,wSeedTreeRefilledBitset
	call checkFlag
	jp z,interactionDelete

	; BUG: Above function call is wrong! Should be "enemyDelete"!
	; If a seed tree's seeds are exhausted, instead of deleting this object, it will
	; try to delete the interaction in the corresponding spot!
	; This is not be very noticeable, because often this will be in slot $d0, which
	; for interactions, is reserved for items from chests and stuff like that. But
	; that can be manipulated by digging up enemies from the ground...

	ld a,(de)
	swap a
	and $0f
	ldh (<hFF8B),a
.else
	ld e,Enemy.subid
	ld a,(de)
	ld b,a
	add a
	add b
	ld hl,@treeDataTable
	rst_addAToHl
	ldi a,(hl)
	ldh (<hFF8B),a
	ldi a,(hl)
	ld b,a
	ld a,(wRoomStateModifier)
	cp b
	jp nz,enemyDelete
	ld a,(hl)
	cpl
	ld e,Enemy.direction
	ld (de),a
	ld a,(wSeedTreeRefilledBitset)
	and (hl)
	jp z,enemyDelete
.endif

	; Spawn the 3 seed objects
	xor a
	call @addSeed
	ld a,$01
	call @addSeed
	ld a,$02
@addSeed:
	ld hl,@positionOffsets
	rst_addDoubleIndex
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	inc hl
	ld b,a
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	ld c,a

	call getFreePartSlot
	ld (hl),PARTID_SEED_ON_TREE
	inc l
	ldh a,(<hFF8B)
	ld (hl),a ; [subid]

	ld l,Part.yh
	ld (hl),b
	ld l,Part.xh
	ld (hl),c

	ld l,Part.relatedObj2
	ld (hl),Enemy.start
	inc l
	ld (hl),d
	ret

@positionOffsets:
	.db $f8 $00
	.db $00 $f8
	.db $00 $08

.ifdef ROM_SEASONS

; Data:
; - Seed type
; - Required season to grow
; - Bitmask checked against wSeedTreeRefilledBitset
@treeDataTable:
	.db $00, SEASON_WINTER, $80
	.db $04, SEASON_SUMMER, $40
	.db $01, SEASON_SPRING, $20
	.db $02, SEASON_AUTUMN, $10
	.db $03, SEASON_SUMMER, $08
	.db $03, SEASON_SUMMER, $04
.endif


@state1:
	; Waiting for one of the PARTID_SEED_ON_TREE objects to write to var03, indicating
	; that they were grabbed
	ld e,Enemy.var03
	ld a,(de)
	or a
	ret z

	; Mark seeds as taken
.ifdef ROM_AGES
	ld e,Enemy.subid
	ld a,(de)
	and $0f
	ld hl,wSeedTreeRefilledBitset
	call unsetFlag
.else
	ld e,Enemy.direction
	ld a,(de)
	ld hl,wSeedTreeRefilledBitset
	and (hl)
	ld (hl),a
.endif
	jp enemyDelete


; ==============================================================================
; ENEMYID_TWINROVA_ICE
;
; Variables:
;   var3e: ?
; ==============================================================================
enemyCode5d:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

	; Hit something
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	jr z,@normalStatus

	res 7,a
	sub ITEMCOLLISION_L2_SHIELD
	cp ITEMCOLLISION_L3_SHIELD-ITEMCOLLISION_L2_SHIELD + 1
	call c,twinrovaIce_bounceOffShield
	call ecom_updateCardinalAngleAwayFromTarget

@normalStatus:
	ld e,Enemy.state
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

	ld l,Enemy.speed
	ld (hl),SPEED_1c0

	ld l,Enemy.counter1
	ld (hl),120

	ld l,Enemy.var3e
	ld (hl),$08

	ld a,SND_POOF
	call playSound
	jp objectSetVisible82


@state1:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl)


@state2:
	; Check if parent is dead
	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr z,@delete

	ld l,Enemy.state
	ld a,(hl)
	cp $0a
	jr z,@delete

	call objectApplySpeed
	call ecom_bounceOffWallsAndHoles
	ret z
	ld a,SND_CLINK
	jp playSound

@delete:
	call objectCreatePuff
	jp enemyDelete


;;
; This doesn't appear to do anything other than make a sound, because the angle is
; immediately overwritten after this is called?
twinrovaIce_bounceOffShield:
	ld a,(w1Link.direction)
	swap a
	ld b,a
	ld e,Enemy.angle
	ld a,(de)
	add b
	ld hl,@bounceTable
	rst_addAToHl
	ld e,Enemy.angle
	ld a,(hl)
	ld (de),a
	ld a,SND_CLINK
	jp playSound

@bounceTable:
	.db $10 $0f $0e $0d $0c $0b $0a $09
	.db $08 $07 $06 $05 $04 $03 $02 $01

	.db $00 $1f $1e $1d $1c $1b $1a $19
	.db $18 $17 $16 $15 $14 $13 $12 $11

	.db $10 $0f $0e $0d $0c $0b $0a $09
	.db $08 $07 $06 $05 $04 $03 $02 $01

	.db $00 $1f $1e $1d $1c $1b $1a $19
	.db $18 $17 $16 $15 $14 $13 $12 $11

	.db $10 $0f $0e $0d $0c $0b $0a $09
	.db $08 $07 $06 $05 $04 $03 $02 $01



; ==============================================================================
; ENEMYID_TWINROVA_BAT
; ==============================================================================
enemyCode5e:
	jr z,+
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie_uncounted
+
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMYID_MERGED_TWINROVA
	jp nz,enemyDelete

	ld e,Enemy.counter1
	ld a,(de)
	inc a
	and $1f
	ld a,SND_BOOMERANG
	call z,playSound

	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_200

	ld l,Enemy.counter2
	ld (hl),$50

	call getRandomNumber_noPreserveVars
	ld e,Enemy.counter1
	ld (de),a

	ld a,SND_VERAN_FAIRY_ATTACK
	call playSound
	jp objectSetVisible82


@state1:
	call @updateOamFlags
	call ecom_decCounter2
	jr nz,@animate

	ld l,e
	inc (hl) ; [state]
	call ecom_updateAngleTowardTarget


@state2:
	call @checkInBounds
	jp nc,enemyDelete

	call @updateOamFlags
	call objectApplySpeed
@animate:
	jp enemyAnimate


;;
; @param[out]	cflag	c if in bounds
@checkInBounds:
	ld e,Enemy.yh
	ld a,(de)
	cp LARGE_ROOM_HEIGHT<<4
	ret nc
	ld e,Enemy.xh
	ld a,(de)
	cp LARGE_ROOM_WIDTH<<4
	ret

;;
@updateOamFlags:
	call ecom_decCounter1
	ld a,(hl)
	and $04
	rrca
	rrca
	add $02
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	ret


; ==============================================================================
; ENEMYID_GANON_REVIVAL_CUTSCENE
;
; Variables:
;   var30: Copied to counter2?
;   var31: Nonzero if initialization has occurred? (spawner only)
; ==============================================================================
enemyCode60:
	ld e,Enemy.subid
	ld a,(de)
	or a
	ld e,Enemy.var31
	jr z,ganonRevivalCutscene_controller

	; This is an individual shadow in the cutscene.

	ld a,(de)
	or a
	jr nz,label_266

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_200

	call objectSetVisible83

	ld a,SND_WIND
	call playSound

label_266:
	ld bc,$5478
	ld e,Enemy.yh
	ld a,(de)
	ldh (<hFF8F),a
	ld e,Enemy.xh
	ld a,(de)
	ldh (<hFF8E),a
	sub c
	add $08
	cp $11
	jr nc,label_267

	ldh a,(<hFF8F)
	sub b
	add $08
	cp $11
	jp c,enemyDelete

label_267:
	; Nudge toward target every 8 frames
	ld a,(wFrameCounter)
	and $07
	jr nz,++
	call objectGetRelativeAngleWithTempVars
	call objectNudgeAngleTowards
++
	call objectApplySpeed
	jp ecom_flickerVisibility


ganonRevivalCutscene_controller:
	ld a,(de) ; [var31]
	or a
	jr nz,label_270

	; Just starting the cutscene

	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld h,d
	ld l,e
	inc (hl) ; [var31] = 1

	ld l,Enemy.var30
	ld (hl),$28

	call hideStatusBar

	ldh a,(<hActiveObject)
	ld d,a
	ld a,$0e
	call fadeoutToBlackWithDelay

	xor a
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a

label_270:
	call ecom_decCounter2
	ret nz

	; Check number of shadows spawned already
	dec l
	ld a,(hl) ; [counter1]
	cp $10
	inc (hl)
	jr nc,@delete

	call ganonRevivalCutscene_spawnShadow

	ld e,Enemy.var30
	ld a,(de)
	ld e,Enemy.counter2
	ld (de),a

	ld e,Enemy.var30
	ld a,(de)
	sub $04
	cp $10
	ret c
	ld (de),a
	ret

@delete:
	; Signal parent to move to next phase of cutscene?
	ld a,Object.counter1
	call objectGetRelatedObject1Var
	inc (hl)
	jp enemyDelete

;;
ganonRevivalCutscene_spawnShadow:
	call getFreeEnemySlot_uncounted
	ret nz

	ld (hl),ENEMYID_GANON_REVIVAL_CUTSCENE
	inc l
	inc (hl) ; [child.subid] = 1

	ld e,Enemy.counter1
	ld a,(de)
	and $07
	ld b,a
	add a
	add b
	ld bc,@shadowVariables
	call addAToBc

	ld l,Enemy.yh
	ld a,(bc)
	ldi (hl),a
	inc l
	inc bc
	ld a,(bc)
	ld (hl),a ; [xh]

	ld l,Enemy.angle
	inc bc
	ld a,(bc)
	ld (hl),a
	ret

; Byte 0: yh
; Byte 1: xh
; Byte 2: angle
@shadowVariables:
	.db $60 $f0 $19
	.db $b8 $d0 $00
	.db $90 $00 $02
	.db $40 $f0 $16
	.db $b8 $60 $1e
	.db $b8 $20 $05
	.db $90 $f0 $18
	.db $40 $00 $06
