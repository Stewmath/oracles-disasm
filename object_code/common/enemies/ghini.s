; ==================================================================================================
; ENEMY_GHINI
;
; Variables:
;   var30/31: Target Y/X position for subid 2 only
; ==================================================================================================
enemyCode17:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	jr c,@stunned
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ret

@stunned:
	ld e,Enemy.stunCounter
	ld a,(de)
	or a
	ret nz

	; Restore normal Z position when stun is over?
	ld e,Enemy.zh
	ld a,$fe
	ld (de),a
	ret

@dead:
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp z,enemyDie

	; For subid 1 only, kill all other ghinis with subid 1.
	ldhl FIRST_ENEMY_INDEX, Enemy.id
@nextGhini:
	ld a,(hl)
	cp ENEMY_GHINI
	jr nz,++
	inc l
	ldd a,(hl)
	dec a
	jr nz,++
	call ecom_killObjectH
	ld l,Enemy.id
++
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@nextGhini
	jp enemyDie


@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw ghini_subid00
	.dw ghini_subid01
	.dw ghini_subid02


@state_uninitialized:
	ld a,SPEED_80
	call ecom_setSpeedAndState8
	ld l,Enemy.zh
	ld (hl),$fe

	; Check for subid 1 only
	ld a,b
	dec a
	jr nz,++

	ld l,Enemy.counter1
	ld (hl),60
	ld l,Enemy.angle
	ld (hl),$10
	ld l,Enemy.collisionType
	res 7,(hl)
++
	jp objectSetVisiblec1


@state_stub:
	ret


; Normal ghini.
ghini_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9

@state8:
	; Set random angle, counter1
	ldbc $18,$7f
	call ecom_randomBitwiseAndBCE
	ld h,d
	ld l,Enemy.counter1
	ld a,$30
	add c
	ld (hl),a
	ld l,Enemy.angle
	ld (hl),b

	ld l,Enemy.state
	inc (hl)
	jp ghini_updateAnimationFromAngle

@state9:
	call ghini_updateMovement
	call ecom_decCounter1
	jr nz,++

	; Go back to state 8 to decide a new direction.
	ld l,Enemy.state
	dec (hl)
++
	jp enemyAnimate


; This type takes a second to spawn in, and killing one ghini of subid 1 makes all other
; die too?
ghini_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


; Fading in.
@state8:
	call ecom_decCounter1
	jr z,++

	; Flicker visibility
	ld a,(hl)
	and $01
	ret nz
	jp ecom_flickerVisibility
++
	; Make visible, enable collisions
	ld l,Enemy.visible
	set 7,(hl)
	ld l,Enemy.collisionType
	set 7,(hl)
	call @gotoStateC
	jr @animate


; Just wandering around until counter1 reaches 0.
@state9:
	call ghini_updateMovement
	ld a,(wFrameCounter)
	rrca
	jr nc,@animate
	call ecom_decCounter1
	jr z,@incState

	call getRandomNumber_noPreserveVars
	cp $08
	jr nc,@animate

	; Rare chance (1/8192 per frame) of moving directly toward Link
	; Otherwise just takes a new random angle
	ldbc $1f,$1f
	call ecom_randomBitwiseAndBCE
	or b
	ld a,c
	call z,objectGetAngleTowardEnemyTarget
	ld e,Enemy.angle
	ld (de),a
	call ghini_updateAnimationFromAngle
	jr @animate

@incState:
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$00
	jr @animate


; Gradually decrease speed for 128 frames
@stateA:
	ld h,d
	ld l,Enemy.counter1
	inc (hl)
	ld a,(hl)
	cp $80
	jp c,ghini_updateMovementAndSetSpeedFromCounter1

	ld (hl),$80
	ld l,e
	inc (hl) ; [state] = $0b
@animate:
	jp enemyAnimate


; Stop moving for 128 frames
@stateB:
	call ecom_decCounter1
	jr nz,@animate


@gotoStateC:
	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.counter1
	ld (hl),$7f
	ld l,Enemy.speed
	ld (hl),SPEED_20
	jr @animate


; Gradually increase speed for 128 frames
@stateC:
	call ecom_decCounter1
	jp nz,ghini_updateMovementAndSetSpeedFromCounter1

	ld l,e
	ld (hl),$09
	call getRandomNumber_noPreserveVars
	ld e,Enemy.counter1
	and $7f
	add $7f
	ld (de),a
	jr @animate


ghini_subid02:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB


; Choose a random target position to move toward
@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_40
	ld l,Enemy.counter1
	ld (hl),$24
	call ghini_chooseTargetPosition


; Grudually increasing speed while moving toward target
@state9:
	call ecom_decCounter1
	jr nz,++

	ld l,e
	inc (hl) ; [state] = $0a
	jr @stateA
++
	ld a,(hl)
	and $07
	jr nz,@stateA
	ld l,Enemy.speed
	ld a,(hl)
	add SPEED_20
	ld (hl),a


; Moving toward target
@stateA:
	ld h,d
	ld l,Enemy.var30
	call ecom_readPositionVars

	; Check that the target is at least 2 pixels away in either direction.
	sub c
	inc a
	cp $03
	jr nc,@moveTowardTarget
	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	jr nc,@moveTowardTarget

	; We've reached the target; go to state $0b.
	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.counter1
	ld (hl),$1c
	jr @stateB

@moveTowardTarget:
	call ecom_moveTowardPosition
	call ghini_updateAnimationFromAngle
@animate:
	jp enemyAnimate


; Gradually decreasing speed
@stateB:
	call ecom_decCounter1
	jr z,@gotoState8

	ld a,(hl)
	and $07
	jr nz,++
	ld l,Enemy.speed
	ld a,(hl)
	sub SPEED_20
	ld (hl),a
++
	call objectApplySpeed
	jr @animate

@gotoState8:
	ld l,e
	ld (hl),$08
	jr @state8


;;
; Sets speed, where it's higher if counter1 is lower.
ghini_updateMovementAndSetSpeedFromCounter1:
	call ghini_updateMovement
	ld e,Enemy.counter1
	ld a,(de)
	ld b,$00
	cp $2a
	jr c,++
	inc b
	cp $54
	jr c,++
	inc b
++
	ld a,b
	ld hl,@speeds
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	jr ghini_subid02@animate

@speeds:
	.db SPEED_80, SPEED_40, SPEED_20

;;
ghini_updateMovement:
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary
	ret z

;;
ghini_updateAnimationFromAngle:
	ld h,d
	ld l,Enemy.angle
	ldd a,(hl)
	cp $10
	ld a,$01
	jr c,+
	dec a
+
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
; Sets var30/var31 to target position for subid 2.
;
; Target position seems to always be somewhere around the center of the room, even moreso
; for large rooms.
;
ghini_chooseTargetPosition:
	ldbc $70,$70
	call ecom_randomBitwiseAndBCE
	ld a,b
	sub $20
	jr nc,+
	xor a
+
	ld b,a

	; b = [wRoomEdgeY]/2 + b - $28
	ld hl,wRoomEdgeY
	ldi a,(hl)
	srl a
	add b
	sub $28
	ld b,a

	; c = [wRoomEdgeX]/2 + c - $38
	ld a,(hl)
	srl a
	add c
	sub $38
	ld c,a
	ld h,d

	ld l,Enemy.var30
	ld (hl),b
	inc l
	ld (hl),c
	ret
