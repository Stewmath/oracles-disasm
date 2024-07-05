; ==================================================================================================
; ENEMY_WIZZROBE
;
; Variables:
;   var30: The low byte of wWizzrobePositionReservations that this wizzrobe is using
;          (red wizzrobes only)
;   var31/var32: Target position (blue wizzrobes only)
; ==================================================================================================
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
	ld b,PART_WIZZROBE_PROJECTILE
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
	ld b,PART_WIZZROBE_PROJECTILE
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
	ld b,PART_WIZZROBE_PROJECTILE
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
