; ==================================================================================================
; ENEMY_SPINY_BEETLE
;
; Variables:
;   var03: $80 when stationary, $81 when charging Link. Child object (bush or rock) reads
;          this to determine relative Z position. Bit 7 is set to indicate it's grabbable.
;   var3b: Probably unused?
; ==================================================================================================
enemyCode1b:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards

	; ENEMYSTATUS_JUST_HIT
	; If Link just hit the enemy, start moving
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret nz

	ld e,Enemy.state
	ld a,(de)
	cp $08
	jr nz,@normalStatus
	call ecom_updateCardinalAngleTowardTarget
	jp @chargeAtLink

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
	; Spawn the bush or rock to hide under
	ld b,ENEMY_BUSH_OR_ROCK
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz

	ld e,l
	ld a,(de)
	ld (hl),a ; [child.subid] = [this.subid]

	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld e,Enemy.relatedObj2
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	call objectCopyPosition

	ld a,SPEED_e0
	call ecom_setSpeedAndState8

	ld l,Enemy.collisionRadiusY
	ld a,$03
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.var03
	ld (hl),$80

	; Change collisionType only for those hiding under rocks?
	dec l
	ld a,(hl)
	cp $02
	ret c

	; Borrow beamos collisions (nothing can kill it until rock is removed)
	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_BEAMOS
	ret


@state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @@substate1
	.dw @@substate2
	.dw ecom_fallToGroundAndSetState8

@@substate1:
@@substate2:
	ret


@state_stub:
	ret


; Waiting for Link to move close enough.
@state8:
	call @checkBushOrRockGone
	ret z
	call ecom_decCounter2
	ret nz

	ld b,$0c
	call objectCheckCenteredWithLink
	ret nc

	call ecom_updateCardinalAngleTowardTarget
	or a
	ret z ; For some reason he never moves up?

	ld a,$01
	call ecom_getTopDownAdjacentWallsBitset
	ret nz


@chargeAtLink:
	call ecom_incState ; [state] = 9
	ld l,Enemy.counter1
	ld (hl),$38
	ld l,Enemy.var03
	ld (hl),$81
	jp objectSetVisiblec3


; Moving toward Link
@state9:
	call @checkBushOrRockGone
	ret z
	call ecom_decCounter1
	jr z,++
	call ecom_applyVelocityForTopDownEnemyNoHoles
	jr nz,@animate
++
	ld h,d
	ld l,Enemy.counter2
	ld (hl),30

	ld l,Enemy.state
	dec (hl)

	ld l,Enemy.var03
	ld (hl),$80
	ld l,Enemy.var3b
	ld (hl),$00

	jp objectSetInvisible


; Just lost protection (bush or rock).
@stateA:
	call ecom_decCounter1
	jr nz,@animate
	inc (hl)
	ld l,e
	inc (hl)
	jr @animate


; Moving around randomly after losing protection.
@stateB:
	call ecom_decCounter1
	jr nz,++

	ld (hl),40
	call getRandomNumber_noPreserveVars
	and $1c
	ld e,Enemy.angle
	ld (de),a
	jr @animate
++
	call ecom_applyVelocityForSideviewEnemyNoHoles
@animate:
	jp enemyAnimate


;;
; Checks if the object we're hiding under is gone; if so, updates collisionType,
; collisiosRadius, visibility, and sets state to $0a
;
; @param[out]	zflag	z if the object it's hiding under is gone
@checkBushOrRockGone:
	ld e,Enemy.relatedObj2+1
	ld a,(de)
	or a
	ret nz

	ld h,d
	ld l,Enemy.state
	ld (hl),$0a
	ld l,Enemy.counter1
	ld (hl),60

	; Restore normal collisions
	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_SPINY_BEETLE

	ld l,Enemy.collisionRadiusY
	ld a,$06
	ldi (hl),a
	ld (hl),a
	call objectSetVisiblec3
	xor a
	ret
