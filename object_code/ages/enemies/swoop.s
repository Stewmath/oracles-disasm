; ==================================================================================================
; ENEMY_SWOOP
;
; Variables:
;   var30: Number of frames before swoop begins to stomp
;   var31: Target stomp position (short-form)
;   var32/var33: Target stomp position (long-form)
; ==================================================================================================
enemyCode71:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp nz,@normalStatus
	jp enemyBoss_dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw swoop_state_uninitialized
	.dw swoop_state_stub
	.dw swoop_state_stub
	.dw swoop_state_stub
	.dw swoop_state_stub
	.dw swoop_state_stub
	.dw swoop_state_stub
	.dw swoop_state_stub
	.dw swoop_state8
	.dw swoop_state9
	.dw swoop_stateA
	.dw swoop_stateB


swoop_state_uninitialized:
	ld a,ENEMY_SWOOP
	ld b,$00
	call enemyBoss_initializeRoom
	call ecom_setSpeedAndState8
	ld b,$01
	ld c,$08
	jp enemyBoss_spawnShadow


swoop_state_stub:
	ret


; Spawning in before the fight starts
swoop_state8:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	; Wait for door to close
	ld a,($cc93)
	or a
	ret nz

	call ecom_incSubstate
	ld c,$08
	call ecom_setZAboveScreen

	ld e,Enemy.counter1
	ld a,60
	ld (de),a

	inc e
	ld a,$02
	ld (de),a ; [counter2]

	call objectSetVisible82
	ld a,$02
	jp enemySetAnimation

; Falling to ground
@substate1:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	ld e,Enemy.counter2
	ld a,(de)
	or a
	jr z,@doneBouncing

	dec a
	ld (de),a
	jr nz,++

	ld a,$00
	call enemySetAnimation
	jr @doneBouncing
++
	ld bc,-$180
	call objectSetSpeedZ
	ld a,$0a
	call setScreenShakeCounter
	ld a,SND_DOORCLOSE
	jp playSound

@doneBouncing:
	call ecom_decCounter1
	ret nz
	ld bc,TX_2f00
	call showText
	jp ecom_incSubstate

@substate2:
	call retIfTextIsActive
	call enemyBoss_beginMiniboss
	call ecom_incSubstate
	jp swoop_beginFlyingUp

@substate3:
	call swoop_state9

	ld e,Enemy.state
	ld a,(de)
	cp $0a
	ret nz

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ret


; Flying upward
swoop_state9:
	call swoop_animate

	; Set Z-speed if just flapped wings
	ld a,(de)
	or a
	ld bc,-$100
	call nz,objectSetSpeedZ

	ld c,$08
	call objectUpdateSpeedZ_paramC
	call ecom_decCounter2
	ret nz

	call ecom_decCounter1
	jp nz,swoop_flyFurtherUp

	ld (hl),60 ; [counter1]

	ld a,$0a
	ld l,Enemy.state
	ldi (hl),a
	ld (hl),$00 ; [substate]

	call swoop_getAngerLevel
	ld hl,swoop_framesBeforeAttacking
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.var30
	ld (de),a

	call objectGetAngleTowardLink
	ld e,Enemy.angle
	ld (de),a

	ld a,$00
	jp enemySetAnimation


; Flying around, getting closer to Link before stomping
swoop_stateA:
	call swoop_animate
	call swoop_getAngerLevel

	ld hl,swoop_speedVals
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.speed
	ld (de),a

	ld e,Enemy.var30
	ld a,(de)
	or a
	jr z,++
	dec a
	ld (de),a
	jr nz,@updatePosition
++
	ld c,$30
	call objectCheckLinkWithinDistance
	jr nc,@updatePosition

	call ecom_incState
	inc l
	ld (hl),$00 ; [substate]
	ld l,Enemy.counter1
	ld (hl),30
	ret

@updatePosition:
	call ecom_decCounter1
	jr nz,++
	call objectGetAngleTowardLink
	ld e,Enemy.angle
	ld (de),a
	ld e,Enemy.counter1
	ld a,60
	ld (de),a
++
	jp ecom_applyVelocityForSideviewEnemy


; Stomping
swoop_stateB:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw swoop_stomp_substate2
	.dw swoop_stomp_substate3

; Flapping wings quickly, telegraphing stomp is about to begin
@substate0:
	call swoop_animate
	call swoop_animate
	call ecom_decCounter1
	jr z,@beginStomp

	ld a,(hl) ; [counter1]
	cp $0a
	ret nz

	; Decide on target position to stomp at, store in var31
	ld hl,w1Link.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl) ; [w1Link.xh]
	call getTileAtPosition
	ld a,l
	ld e,Enemy.var31
	ld (de),a

	; Convert to long-form, store in var32/var33
	call convertShortToLongPosition
	ld e,Enemy.var32
	ld a,b
	and $f0
	ld (de),a
	inc e
	ld a,c
	ld (de),a

	; Get angle toward stomp position
	ld e,Enemy.yh
	call objectGetRelativeAngle
	ld e,Enemy.angle
	ld (de),a
	ret

@beginStomp:
	call ecom_incSubstate
	ld l,Enemy.speed
	ld (hl),SPEED_200

	ld l,Enemy.collisionType
	set 7,(hl)

	ld bc,$0000
	call objectSetSpeedZ
	ld a,$02
	jp enemySetAnimation

; Moving toward stomp position while falling to ground
@substate1:
	; Get target stomp position
	ld h,d
	ld l,Enemy.var32
	ldi a,(hl)
	ld c,(hl)
	ld b,a

	; Compare with current position
	ld e,Enemy.yh
	ld l,e
	ldi a,(hl)
	and $fe
	cp b
	jr nz,++
	inc l
	ld a,(hl)
	and $fe
	cp c
	jr z,+++
++
	; Must still move toward target position
	call objectGetRelativeAngle
	ld e,Enemy.angle
	ld (de),a
	call ecom_applyVelocityForSideviewEnemy
+++
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	; Hit the ground.
	call swoop_hitGround
	call ecom_incSubstate
	ld e,Enemy.health
	ld a,(de)
	cp $0a
	jr nc,swoop_setVisible

	; Health is low; will bounce either 2 or 3 times.
	inc (hl) ; [substate] = 3

	; [counter1] = number of bounces
	call getRandomNumber
	and $01
	inc a
	ld l,Enemy.counter1
	ld (hl),a

	ld l,Enemy.speed
	ld (hl),SPEED_100

	call objectGetAngleTowardLink
	ld e,Enemy.angle
	ld (de),a

swoop_setSpeedZForBounce:
	ld bc,-$100
	jp objectSetSpeedZ

swoop_setVisible:
	jp objectSetVisible82


; Completed stomp, about to fly back up.
swoop_stomp_substate2:
	call swoop_animate

	; Wait until animation signals to fly up again, or Link attacks
	ld e,Enemy.invincibilityCounter
	ld a,(de)
	and $7f
	jr nz,@flyBackUp

	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z

@flyBackUp:
	ld bc,$0000
	call objectSetSpeedZ

	ld l,Enemy.state
	ld a,$09
	ldi (hl),a
	ld (hl),$00 ; [substate]

	ld l,Enemy.collisionType
	res 7,(hl)

;;
swoop_beginFlyingUp:
	ld l,Enemy.counter1
	ld (hl),$03 ; 3 flaps before he goes to next state

;;
swoop_flyFurtherUp:
	ld l,Enemy.counter2
	ld (hl),$30 ; $30 frames per wing flap
	call objectSetVisible80
	ld a,$03
	jp enemySetAnimation


; Bouncing
swoop_stomp_substate3:
	call ecom_applyVelocityForSideviewEnemy
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	call swoop_hitGround
	call ecom_decCounter1
	jr nz,swoop_setSpeedZForBounce

	ld l,Enemy.substate
	dec (hl)
	jp objectSetVisible82


;;
; @param[out]	a	Value from 0-2
swoop_getAngerLevel:
	ld b,$00
	ld e,Enemy.health
	ld a,(de)
	cp $0a
	jr nc,++
	inc b
	cp $06
	jr nc,++
	inc b
++
	ld a,b
	ret

;;
swoop_hitGround:
	ld a,$30
	call setScreenShakeCounter
	ld a,SND_DOORCLOSE
	call playSound

	; Replace tile at this position if it's of the appropriate type, and not solid.
	ld bc,$0500
	call objectGetRelativeTile
	ld c,l
	ld h,>wRoomCollisions
	ld a,(hl)
	cp $0f
	ret z

	ld h,>wRoomLayout
	ld a,(hl)
	cp $a2
	ret z
	cp $48
	ret z

	ld a,$48
	call setTile

	ld b,INTERAC_ROCKDEBRIS
	jp objectCreateInteractionWithSubid00


;;
; @param[out]	de	animParameter (if nonzero, just flapped wings)
swoop_animate:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z
	ld a,SND_JUMP
	jp playSound

swoop_speedVals:
	.db SPEED_80, SPEED_100, SPEED_180

swoop_framesBeforeAttacking:
	.db 255, 150, 60
