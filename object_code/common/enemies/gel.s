; ==================================================================================================
; ENEMY_GEL
; ==================================================================================================
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
