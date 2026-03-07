; ==================================================================================================
; ENEMY_SUBTERROR
;
; Variables:
;   var30: If nonzero, dirt is created at subterror's position every 8 frames.
;   var31: Counter until a new dirt object (PART_SUBTERROR_DIRT) is created.
; ==================================================================================================
enemyCode72:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus
	jp enemyBoss_dead

@normalStatus:
	ld e,Enemy.var30
	ld a,(de)
	or a
	call nz,subterror_spawnDirtEvery8Frames
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw subterror_state_uninitialized
	.dw subterror_state_stub
	.dw subterror_state_stub
	.dw subterror_state_stub
	.dw subterror_state_stub
	.dw subterror_state_stub
	.dw subterror_state_stub
	.dw subterror_state_stub
	.dw subterror_state8
	.dw subterror_state9
	.dw subterror_stateA
	.dw subterror_stateB
	.dw subterror_stateC


subterror_state_uninitialized:
	ld a,ENEMY_SUBTERROR
	ld b,PALH_be
	call enemyBoss_initializeRoom
	call ecom_setSpeedAndState8

	ld a,$07
	ld l,Enemy.var31
	ldd (hl),a ; [var31] = 7
	ld (hl),a  ; [var30] = 7

	ld l,Enemy.speed
	ld (hl),SPEED_180
	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN

	ld l,Enemy.counter2
	ld (hl),30
	ret


subterror_state_stub:
	ret


; Cutscene before fight
subterror_state8:
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

	call ecom_decCounter2
	ret nz

	; Move further down
	call objectApplySpeed
	ld e,Enemy.yh
	ld a,(de)
	cp $58
	ret c

	; Reached middle of screen, about to pop out

	ld a,SND_DIG
	call playSound

	ld a,$06
	call enemySetAnimation
	call objectSetVisiblec2

	call ecom_incSubstate

	; Disable dirt animation
	ld l,Enemy.var30
	ld (hl),$00

	call objectGetTileAtPosition
	ld c,l
	ld a,TILEINDEX_DUNGEON_DUG_DIRT
	jp setTile

@substate1:
	call subterror_retFromCallerIfAnimationUnfinished

	ld b,INTERAC_ROCKDEBRIS
	call objectCreateInteractionWithSubid00

	call ecom_incSubstate

	ld l,Enemy.counter1
	ld (hl),60

	ld bc,-$200
	call objectSetSpeedZ

	ld a,$05
	jp enemySetAnimation

@substate2:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	ld a,$02
	call enemySetAnimation
	call ecom_decCounter1
	ret nz

	ld bc,TX_2f03
	call showText
	jp ecom_incSubstate

@substate3:
	call retIfTextIsActive

	call enemyBoss_beginMiniboss
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a


subterror_digIntoGround:
	ld e,Enemy.state
	ld a,$09
	ld (de),a

	ld a,$04
	jp enemySetAnimation


; Digging into ground
subterror_state9:
	call subterror_retFromCallerIfAnimationUnfinished

	; Done digging, about to start moving around
subterror_beginUndergroundMovement:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0a
	inc l
	xor a
	ld (hl),a ; [substate]

	dec a
	ld l,Enemy.angle
	ld (hl),a ; [angle] = $ff

	ld l,Enemy.visible
	res 7,(hl)

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_SUBTERROR_UNDERGROUND

	ld l,Enemy.counter1
	ld (hl),60

	call subterror_getAngerLevel
	ld hl,subterror_timeUntilDrillAttack
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.counter2
	ld (de),a

	ld a,SND_DIG
	call playSound
	jp subterror_spawnDirt


; Currently in the ground, moving around
subterror_stateA:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Staying underground for [counter1] frames before moving
@substate0:
	call ecom_decCounter1
	ret nz

	call ecom_incSubstate

@resetUndergroundMovement:
	; Adjust angle toward Link?
	call objectGetAngleTowardLink
	ld c,a
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	cp c
	ld a,c
	jr nz,+
	add $08
	and $1f
+
	ld (de),a

	ld e,Enemy.counter1
	ld a,30
	ld (de),a

	call subterror_getAngerLevel
	ld hl,subterror_speedVals
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.speed
	ld (de),a

	ld a,$0a
	call objectSetCollideRadius
	jp subterror_spawnDirt

; Moving around until shovel is used or he starts drilling
@substate1:
	ld e,Enemy.var2a
	ld a,(de)
	sla a
	jr nc,@noShovel
	cp ITEMCOLLISION_SHOVEL<<1
	jr nz,@noShovel

	; Shovel was used; will now pop out of ground

	ld bc,-$100
	call objectSetSpeedZ
	ld l,Enemy.speed
	ld (hl),SPEED_100

	ld a,$0c
	ld l,Enemy.state
	ldi (hl),a
	xor a
	ld (hl),a ; [substate] = 0

	ld l,Enemy.var30
	ld (hl),a ; [var30] = 0

	inc a
	ld l,Enemy.counter1
	ld (hl),a ; [counter1] = 1

	ld l,Enemy.visible
	set 7,(hl)

	; Bounces away from Link
	call objectGetAngleTowardLink
	xor $10
	ld e,Enemy.angle
	ld (de),a

	ld a,$06
	call objectSetCollideRadius
	ld a,$05
	jp enemySetAnimation

@noShovel:
	call objectApplySpeed
	ld a,$01
	call ecom_getSideviewAdjacentWallsBitset
	jr z,++

	; Hit wall
	call ecom_incSubstate
	ld l,Enemy.counter1
	ld (hl),90
	ld l,Enemy.visible
	res 7,(hl)
	ld l,Enemy.var30
	ld (hl),$00
	ret
++
	call ecom_decCounter1
	call z,@resetUndergroundMovement
	call ecom_decCounter2
	ret nz

	; If Link is close enough, drill him
	ld c,$18
	call objectCheckLinkWithinDistance
	ret nc

	; "Transport" to the tile at Link's position
	ld hl,w1Link.yh
	ldi a,(hl)
	inc l
	ld c,(hl)
	ld b,a
	call getTileAtPosition
	ld c,l
	call convertShortToLongPosition_paramC
	ld e,Enemy.yh
	ld a,b
	ld (de),a
	ld e,Enemy.xh
	ld a,c
	ld (de),a

	call ecom_incState ; [state] = $0b
	inc l
	xor a
	ld (hl),a ; [substate] = 0

	ld l,Enemy.var30
	ld (hl),a ; [var30] = 0

	ld a,60
	ld l,Enemy.counter1
	ldi (hl),a
	sra a
	ld (hl),a ; [counter2] = 30

	ld a,$06
	call objectSetCollideRadius
	ld a,$06
	jp enemySetAnimation

; Hit a wall; pause before resuming
@substate2:
	call ecom_decCounter2
	call ecom_decCounter1
	ret nz
	ld l,Enemy.substate
	dec (hl)
	jp @resetUndergroundMovement


; Drilling
subterror_stateB:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld h,d
	ld l,Enemy.counter2
	ld a,(hl)
	or a
	jr z,@drilling

	dec (hl)
	ret nz

	; Just started drilling
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_SUBTERROR_DRILLING
	ld l,Enemy.visible
	set 7,(hl)
	ld a,SND_SHOCK
	call playSound

@drilling:
	call enemyAnimate
	call ecom_decCounter1
	ret nz

	ld l,Enemy.counter1
	ld (hl),60
	ld a,$07
	call enemySetAnimation
	jp ecom_incSubstate

@substate1:
	call subterror_retFromCallerIfAnimationUnfinished
	call subterror_beginUndergroundMovement
	ld e,Enemy.var30
	xor a
	ld (de),a
	ret


; Popping out of ground after shovel was used
subterror_stateC:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call ecom_applyVelocityForSideviewEnemy
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	ld e,Enemy.var2a
	ld (de),a ; [var2a] = 0

	ld e,Enemy.enemyCollisionMode
	ld a,ENEMYCOLLISION_STANDARD_MINIBOSS
	ld (de),a

	call ecom_decCounter1
	jr z,++
	ld l,Enemy.counter1
	ld (hl),180
	jp ecom_incSubstate
++
	ld bc,-$80
	jp objectSetSpeedZ

@substate1:
	ld e,Enemy.var2a
	ld a,(de)
	or a
	jr nz,++
	call enemyAnimate
	call ecom_decCounter1
	ret nz
++
	call ecom_incSubstate

	call getRandomNumber
	and $1c
	ld l,Enemy.angle
	ld (hl),a

	ld l,Enemy.speed
	ld (hl),SPEED_80

	call getRandomNumber
	and $03
	ld hl,subterror_durationAboveGround
	rst_addAToHl
	ldi a,(hl)
	ld e,Enemy.counter1
	ld (de),a

	jp subterror_setAnimationFromAngle

@substate2:
	call enemyAnimate

	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ld a,SND_LAND
	call nz,playSound

	call objectApplySpeed
	call ecom_bounceOffWallsAndHoles
	call nz,subterror_setAnimationFromAngle

	; Dig back into ground when [counter1] reaches 0
	call ecom_decCounter1
	ret nz
	jp subterror_digIntoGround


;;
subterror_spawnDirtEvery8Frames:
	inc e
	ld a,(de) ; [var31]
	dec a
	ld (de),a
	ret nz

;;
subterror_spawnDirt:
	ld e,Enemy.var31
	ld a,$07
	ld (de),a ; [var31] = 7
	dec e
	ld (de),a ; [var30] = 7

	ld b,PART_SUBTERROR_DIRT
	call ecom_spawnProjectile

	call objectGetTileAtPosition
	ld c,l
	ld a,$ef
	jp setTile

;;
subterror_retFromCallerIfAnimationUnfinished:
	call enemyAnimate
	ld h,d
	ld l,Enemy.animParameter
	ld a,(hl)
	or a
	ret nz
	pop af
	ret

;;
; @param[out]	a	Anger level (0-2)
subterror_getAngerLevel:
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
subterror_setAnimationFromAngle:
	ld h,d
	ld l,Enemy.angle
	ldd a,(hl)
	add a
	swap a
	and $03
	ld (hl),a ; [direction]
	add $00
	jp enemySetAnimation


subterror_speedVals: ; Chosen based on "anger level"
	.db SPEED_80 SPEED_100 SPEED_180

subterror_timeUntilDrillAttack: ; Chosen based on "anger level"
	.db 120 90 60

subterror_durationAboveGround: ; Chosen randomly
	.db 60 90 120 180
