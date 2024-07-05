; ==================================================================================================
; ENEMY_STALFOS
; ==================================================================================================
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
	ld b,PART_STALFOS_BONE
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
