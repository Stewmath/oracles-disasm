; ==================================================================================================
; ENEMY_GIANT_GHINI
;
; Variables:
;   var30: Number of children alive
;   var32: Nonzero to begin charging at Link (written to by ENEMY_GIANT_GHINI_CHILD)
;   var33: Counter for Z-axis movement (reverses direction every 16 frames)
;   var34: The current "vertical half" of the screen it's moving toward
;   var35: Position the ghini is currently charging toward
; ==================================================================================================
enemyCode70:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus
	jp enemyBoss_dead

@normalStatus:
	call giantGhini_updateZPos
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw giantGhini_state_uninitialized
	.dw giantGhini_state_stub
	.dw giantGhini_state_stub
	.dw giantGhini_state_stub
	.dw giantGhini_state_stub
	.dw giantGhini_state_stub
	.dw giantGhini_state_stub
	.dw giantGhini_state_stub
	.dw giantGhini_state8
	.dw giantGhini_state9
	.dw giantGhini_stateA


giantGhini_state_uninitialized:
	ld a,ENEMY_GIANT_GHINI
	ld b,$00
	call enemyBoss_initializeRoom
	call ecom_setSpeedAndState8

	ld bc,$0040
	call objectSetSpeedZ

	ld l,Enemy.subid
	set 7,(hl)

	ld l,Enemy.counter1
	ld (hl),120

	ld l,Enemy.zh
	ld (hl),$f8

	ld l,Enemy.var33
	ld (hl),$10
	jp giantGhini_spawnChildren


giantGhini_state_stub:
	ret


; The ghini is spawning in before the fight starts
giantGhini_state8:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	; Wait for door to close
	ld a,($cc93)
	or a
	ret nz

	ld a,120
	ld e,Enemy.counter1
	ld (de),a

	inc e
	ld a,30
	ld (de),a ; [counter2]

	jp ecom_incSubstate

@substate1:
	call ecom_decCounter1
	ret nz

	ld (hl),60

	ld l,Enemy.subid
	res 7,(hl)

	ld b,$01
	ld c,$0c
	call enemyBoss_spawnShadow
	jp ecom_incSubstate

@substate2:
	; Flicker visibility
	ld e,Enemy.visible
	ld a,(de)
	xor $80
	ld (de),a

	call ecom_decCounter1
	ret nz

	; Finally begin the fight
	call enemyBoss_beginMiniboss
	call objectSetVisible80

giantGhini_gotoState9:
	xor a
	call enemySetAnimation

	call giantGhini_getTargetAngle
	ld h,d
	ld e,Enemy.angle
	ld (de),a

	ld l,Enemy.state
	ld (hl),$09

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	ld l,Enemy.counter1
	ld (hl),$02

	ld l,Enemy.var32
	ld (hl),$00

giantGhini_setChildRespawnTimer:
	call getRandomNumber
	and $03
	ld c,60
	call multiplyAByC
	ld e,Enemy.counter2
	ld a,l
	ld (de),a
	ret


; "Normal" state during battle
giantGhini_state9:
	ld e,Enemy.var32
	ld a,(de)
	or a
	jr nz,@beginCharge

	call enemyAnimate
	call objectApplySpeed

	; Nudge angle toward target every other frame
	call ecom_decCounter1
	jr nz,++
	ld (hl),$02
	call giantGhini_getTargetAngle
	call objectNudgeAngleTowards
++
	call ecom_decCounter2
	ret nz

	call giantGhini_setChildRespawnTimer
	ld e,Enemy.var30
	ld a,(de)
	or a
	ret nz
	call getRandomNumber
	and $03
	jp nz,giantGhini_spawnChildren

@beginCharge:
	ld a,$01
	call enemySetAnimation
	call ecom_incState

	ld l,Enemy.counter2
	ld (hl),150
	ld l,Enemy.speed
	ld (hl),SPEED_20

giantGhini_updateChargeTargetPosition:
	; Get Link's position, save that as the position we're charging toward
	ld hl,w1Link.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld a,(hl)
	ld c,a
	call getTileAtPosition
	ld a,l
	ld e,Enemy.var35
	ld (de),a

	call objectGetAngleTowardLink
	ld e,Enemy.angle
	ld (de),a
	ret


; Charging toward Link
giantGhini_stateA:
	call enemyAnimate

	; Increase speed every 4 frames
	call ecom_decCounter2
	ld a,(hl)
	and $03
	jr nz,++
	ld l,Enemy.speed
	ld a,(hl)
	cp SPEED_300
	jr z,++
	add SPEED_20
	ld (hl),a
++
	call objectApplySpeed

	ld e,Enemy.var32
	ld a,(de)
	or a
	call nz,giantGhini_updateChargeTargetPosition

	ld e,Enemy.var35
	ld a,(de)
	call convertShortToLongPosition
	ld e,Enemy.yh
	call objectGetRelativeAngle
	ld e,Enemy.angle
	ld (de),a

	call objectGetTileAtPosition
	ld e,Enemy.var35
	ld a,(de)
	cp l
	jp z,giantGhini_gotoState9
	ret


;;
giantGhini_updateZPos:
	ld c,$00
	call objectUpdateSpeedZ_paramC

	ld l,Enemy.var33
	ld a,(hl)
	dec a
	ld (hl),a
	ret nz

	ld a,$10
	ld (hl),a ; [var33]

	; Invert speedZ
	ld l,Enemy.speedZ
	ld a,(hl)
	cpl
	inc a
	ldi (hl),a
	ld a,(hl)
	cpl
	ld (hl),a
	ret


;;
giantGhini_spawnChildren:
	ld c,$03
@nextChild:
	ld b,ENEMY_GIANT_GHINI_CHILD
	call ecom_spawnEnemyWithSubid01
	ret nz

	ld e,Enemy.var30
	ld a,(de)
	inc a
	ld (de),a

	; [child.subid] = [this.subid] | index
	ld e,Enemy.subid
	ld a,(de)
	or c
	ld (hl),a

	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	call objectCopyPosition

	dec c
	jr nz,@nextChild
	ret


;;
; Decides on a position to move towards, for state 9 ("normal" state). It will target
; the horizontal center of the screen, with the Y-position one quarter away from the
; screen boundary (depends which side Link is on). The camera affects the target position.
;
; When Link moves beyond the half-screen boundary, the ghini recalculates its angle to
; face directly away from Link before it slowly moves toward him again.
;
; @param[out]	a	angle
giantGhini_getTargetAngle:
	ldh a,(<hCameraY)
	ld c,a
	ld a,(w1Link.yh)
	sub c
	ld b,((SCREEN_HEIGHT/4)<<4) + 8
	cp ((SCREEN_HEIGHT/2)<<4) + 8
	jr nc,+
	ld b,((SCREEN_HEIGHT*3/4)<<4) + 8
+
	ld e,Enemy.var34
	ld a,(de)
	cp b
	jr z,++

	; Link changed sides on the screen boundary

	ld a,b
	ld (de),a ; [var34]

	call objectGetAngleTowardLink
	xor $10
	ld e,Enemy.angle
	ld (de),a

	ld e,Enemy.counter1
	ld a,$0a
	ld (de),a
	jr giantGhini_getTargetAngle
++
	ld a,c
	add b
	ld b,a
	ldh a,(<hCameraX)
	add (SCREEN_WIDTH/2)<<4
	ld c,a
	jp objectGetRelativeAngle
