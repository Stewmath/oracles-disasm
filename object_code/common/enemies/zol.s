; ==================================================================================================
; ENEMY_ZOL
;
; Variables:
;   var30: 1 when the zol is out of the ground, 0 otherwise. (only for subid 0, and only
;          used to prevent the "jump" sound effect from playing more than once.)
; ==================================================================================================
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
	ld b,INTERAC_KILLENEMYPUFF
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
	ld b,ENEMY_GEL
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
