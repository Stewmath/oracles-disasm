; ==================================================================================================
; ENEMY_RAMROCK
;
; Variables:
;   var30: Set to $01 by hands when they collide with ramrock
;   var35: Incremented by hands when hit by bomb?
;   var36: Written to by shield hands?
; ==================================================================================================
enemyCode07:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw ramrock_state0
	.dw ramrock_state_stub
	.dw ramrock_state_stub
	.dw ramrock_state_stub
	.dw ramrock_state_stub
	.dw ramrock_state_stub
	.dw ramrock_state_stub
	.dw ramrock_state_stub
	.dw ramrock_state8
	.dw ramrock_swordPhase
	.dw ramrock_bombPhase
	.dw ramrock_seedPhase
	.dw ramrock_glovePhase


ramrock_state0:
	ld a,ENEMY_RAMROCK
	ld b,PALH_83
	call enemyBoss_initializeRoom
	ld a,SPEED_100
	call ecom_setSpeedAndState8
	ld a,$04
	call enemySetAnimation
	ld b,$00
	ld c,$0c
	call enemyBoss_spawnShadow
	jp objectSetVisible81


ramrock_state_stub:
	ret


; Cutscene before fight
ramrock_state8:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ramrock_state8_substate0
	.dw ramrock_state8_substate1
	.dw ramrock_state8_substate2
	.dw ramrock_state8_substate3
	.dw ramrock_state8_substate4
	.dw ramrock_state8_substate5

ramrock_state8_substate0:
	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,($cc93)
	or a
	ret nz

	ld e,Enemy.stunCounter
	ld a,60
	ld (de),a
	jp ecom_incSubstate

ramrock_state8_substate1:
	ld e,Enemy.stunCounter
	ld a,(de)
	or a
	ret nz

	ld bc,-$80
	call objectSetSpeedZ
	ld c,$00
	call objectUpdateSpeedZ_paramC
	ld e,Enemy.zh
	ld a,(de)
	cp $f9
	ret nz

	ld c,$01
@spawnArm:
	ld b,ENEMY_RAMROCK_ARMS
	call ecom_spawnEnemyWithSubid01
	ld l,Enemy.subid
	ld (hl),c
	ld l,Enemy.relatedObj1
	ld (hl),Enemy.start
	inc l
	ld (hl),d
	dec c
	jr z,@spawnArm

	jp ecom_incSubstate

ramrock_state8_substate2:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	ret nz
	ld e,Enemy.counter1
	ld a,$02
	ld (de),a
	call ecom_incSubstate
	ld a,PALH_84
	jp loadPaletteHeader

ramrock_state8_substate3:
	call ecom_decCounter1
	ret nz
	call ecom_incSubstate
	ld a,SND_SWORD_OBTAINED
	call playSound
	ld l,Enemy.subid
	inc (hl)
	ld a,PALH_83
	jp loadPaletteHeader

ramrock_state8_substate4:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z
	call ecom_incSubstate
	ld l,Enemy.angle
	ld (hl),$00
	ld a,$00
	call enemySetAnimation

ramrock_state8_substate5:
	call enemyAnimate
	call objectApplySpeed
	ld e,Enemy.yh
	ld a,(de)
	cp $41
	ret nc

	; Fight begins
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call ecom_incState
	ld l,Enemy.angle
	ld (hl),$08
	ld l,Enemy.subid
	ld (hl),$03
	ld a,MUS_BOSS
	jp playSound


; "Fist" phase
ramrock_swordPhase:
	call enemyAnimate
	ld e,Enemy.var35
	ld a,(de)
	cp $03
	jr nc,+
	jp ramrock_updateHorizontalMovement
+
	xor a
	ld (de),a
	ld bc,$0000
	call objectSetSpeedZ
	call ecom_incState
	inc l
	ld (hl),$00
	ld l,Enemy.subid
	inc (hl)
	ld l,Enemy.counter2
	ld (hl),30
	ld a,$04
	jp enemySetAnimation


; "Bomb" phase
ramrock_bombPhase:
	call @func_68fe

	; Stop movement of any bombs that touch ramrock
	ld c,ITEM_BOMB
	call findItemWithID
	ret nz
	call checkObjectsCollided
	jr nc,++
	ld l,Item.angle
	ld (hl),$ff
++
	ld c,ITEM_BOMB
	call findItemWithID_startingAfterH
	ret nz
	call checkObjectsCollided
	ret nc
	ld l,Item.angle
	ld (hl),$ff
	ret

@func_68fe:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ramrock_bombPhase_substate0
	.dw ramrock_bombPhase_substate1
	.dw ramrock_bombPhase_substate2
	.dw ramrock_bombPhase_substate3
	.dw ramrock_bombPhase_substate4

ramrock_bombPhase_substate0:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ld e,Enemy.subid
	ld a,(de)
	cp $06
	ret nz
	call ecom_decCounter2
	ret nz

	; Spawn arms
	ld b,ENEMY_RAMROCK_ARMS
	call ecom_spawnEnemyWithSubid01
	ld l,Enemy.subid
	ld (hl),$02
	ld l,Enemy.relatedObj1
	ld (hl),Enemy.start
	inc l
	ld (hl),d

	ld b,ENEMY_RAMROCK_ARMS
	call ecom_spawnEnemyWithSubid01
	ld l,Enemy.subid
	ld (hl),$03
	ld l,Enemy.relatedObj1
	ld (hl),Enemy.start
	inc l
	ld (hl),d

	jp ecom_incSubstate

ramrock_bombPhase_substate1:
	ld e,Enemy.subid
	ld a,(de)
	cp $07
	ret nz

	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z
	ld bc,-$80
	call objectSetSpeedZ
	ld l,Enemy.subid
	ld (hl),$08
	ld a,$01
	call enemySetAnimation
	jp ecom_incSubstate

ramrock_bombPhase_substate2:
	ld c,$00
	call objectUpdateSpeedZ_paramC
	ld e,Enemy.zh
	ld a,(de)
	cp $f9
	ret nz

	ld a,SND_SWORD_OBTAINED
	call playSound

ramrock_bombPhase_gotoSubstate3:
	ld h,d
	ld l,Enemy.counter1
	ld a,$04
	ldi (hl),a
	ld (hl),50 ; [counter2]
	ld l,Enemy.substate
	ld (hl),$03
	ret

ramrock_bombPhase_substate3:
	ld e,Enemy.var38
	ld a,(de)
	sub $01
	ld (de),a
	jr nc,++
	ld a,30
	ld (de),a
	ld a,SND_BEAM1
	call playSound
++
	ld e,Enemy.var35
	ld a,(de)
	cp $03
	jr nc,label_10_237

	call enemyAnimate
	call ecom_applyVelocityForSideviewEnemy
	call ecom_decCounter2
	jr z,label_10_236

	call ecom_decCounter1
	ret nz

	ld (hl),$04
	call objectGetAngleTowardLink
	jp objectNudgeAngleTowards

label_10_236:
	call ecom_incSubstate
	ld a,$02
	jp enemySetAnimation

label_10_237:
	call ecom_incState
	inc l
	xor a
	ld (hl),a
	ld l,Enemy.var35
	ld (hl),a
	ld l,Enemy.subid
	ld (hl),$0a
	ld a,$04
	jp enemySetAnimation

ramrock_bombPhase_substate4:
	call enemyAnimate
	ld h,d
	ld l,Enemy.subid
	ld (hl),$08
	ld e,Enemy.animParameter
	ld a,(de)
	cp $01
	jr nz,++
	ld l,Enemy.subid
	ld (hl),$09
	ld a,SND_STRONG_POUND
	jp playSound
++
	rla
	ret nc
	ld a,$01
	call enemySetAnimation
	jp ramrock_bombPhase_gotoSubstate3


; "Seed" phase
ramrock_seedPhase:
	ld h,d
.ifndef REGION_JP
	ld l,Enemy.substate
	ld a,(hl)
	or a
	jr z,@runSubstate
	dec a
	jr z,@runSubstate
.endif

	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_MYSTERY_SEED
	jr c,@noSeedCollision
	cp $80|ITEMCOLLISION_GALE_SEED+1
	jr c,@seedCollision

@noSeedCollision:
	rlca
	jr nc,@noCollision

@otherCollision:
	ld l,Enemy.subid
	ld (hl),$0d
	ld l,Enemy.var36
	ld (hl),$10
	jr @runSubstate

@seedCollision:
	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	jr nz,@otherCollision

	ld (hl),60 ; [invincibilityCounter]
	ld l,Enemy.var35
	ld a,(hl)
	cp $03
	jr z,@seedPhaseEnd

	inc (hl)
	ld a,SND_BOSS_DAMAGE
	call playSound
	jr @runSubstate

@noCollision:
	ld l,Enemy.var36
	ld a,(hl)
	or a
	jr z,@runSubstate
	dec (hl)
	jr nz,@runSubstate

	ld l,Enemy.subid
	ld (hl),$0c

@runSubstate:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw ramrock_seedPhase_substate0
	.dw ramrock_seedPhase_substate1
	.dw ramrock_seedPhase_substate2
	.dw ramrock_seedPhase_substate3
	.dw ramrock_seedPhase_substate4
	.dw ramrock_seedPhase_substate5
	.dw ramrock_seedPhase_substate6

@seedPhaseEnd:
	ld l,Enemy.subid
	ld (hl),$10
	call ecom_incState
	inc l
	xor a
	ld (hl),a
	ld l,Enemy.var35
	ld (hl),a
	ret

ramrock_seedPhase_substate0:
	ld h,d
	ld bc,$4878
	ld l,Enemy.yh
	ldi a,(hl)
	cp b
	jr nz,@updateMovement

	inc l
	ld a,(hl)
	cp c
	jr nz,@updateMovement

	ld l,Enemy.subid
	inc (hl)
	ld l,Enemy.counter2
	ld (hl),$02

	ld c,$04
@spawnArm:
	ld b,ENEMY_RAMROCK_ARMS
	call ecom_spawnEnemyWithSubid01
	ld l,Enemy.subid
	ld (hl),c
	ld l,Enemy.relatedObj1
	ld (hl),Enemy.start
	inc l
	ld (hl),d
	inc c
	ld a,c
	cp $05
	jr z,@spawnArm

	jp ecom_incSubstate

@updateMovement:
	call objectGetRelativeAngle
	ld e,Enemy.angle
	ld (de),a
	jp objectApplySpeed

ramrock_seedPhase_substate1:
	ld e,Enemy.subid
	ld a,(de)
	cp $0c
	ret nz

	ld e,Enemy.counter2
	ld a,(de)
	or a
	jr nz,label_10_248

	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z

ramrock_seedPhase_6a94:
	ld e,Enemy.subid
	ld a,$0c
	ld (de),a

ramrock_seedPhase_resumeNormalMovement:
	ld h,d
	ld l,Enemy.substate
	ld (hl),$02
	ld l,Enemy.counter2
	ld (hl),120
	ld a,$00
	jp enemySetAnimation

label_10_248:
	call ecom_decCounter2
	ret nz
	ld l,Enemy.angle
	ld (hl),$08
	ld a,PALH_83
	call loadPaletteHeader
	ld a,SND_SWORD_OBTAINED
	jp playSound

; Moving normally
ramrock_seedPhase_substate2:
	call enemyAnimate
	call ramrock_updateHorizontalMovement

	call getRandomNumber
	rrca
	ret nc
	call ecom_decCounter2
	ret nz

	ld e,Enemy.subid
	ld a,(de)
	cp $0c
	ret nz

	call getRandomNumber
	and $03
	ld l,e
	jr z,@gotoNextSubstate

	ld (hl),$0f ; [counter2]
	ld l,Enemy.substate
	ld (hl),$06
	ld l,Enemy.counter1
	ld (hl),60

	ld b,PART_RAMROCK_SEED_FORM_ORB
	call ecom_spawnProjectile
	ld bc,$1000
	call objectCopyPositionWithOffset
	jr @setAnimation0

@gotoNextSubstate:
	ld (hl),$0e
	ld l,Enemy.angle
	ld (hl),$18
	call ecom_incSubstate

@setAnimation0:
	ld a,$00
	jp enemySetAnimation

ramrock_seedPhase_substate3:
	ld e,Enemy.subid
	ld a,(de)
	cp $0e
	jr nz,ramrock_seedPhase_resumeNormalMovement
	call ramrock_updateHorizontalMovement
	ret nz

	call ecom_incSubstate
	ld l,Enemy.counter1
	ld (hl),180
	inc l
	ld (hl),30 ; [counter2]

	ld b,PART_RAMROCK_SEED_FORM_LASER
	call ecom_spawnProjectile
	ld l,Part.subid
	ld (hl),$0e
	ld bc,$0400
	jp objectCopyPositionWithOffset

; Firing energy beam
ramrock_seedPhase_substate4:
	ld e,Enemy.subid
	ld a,(de)
	cp $0e
	jp nz,ramrock_seedPhase_resumeNormalMovement

	call ecom_decCounter2
	ret nz
	call ecom_decCounter1
	jr z,@gotoNextSubstate

	ld a,(hl)
	and $07
	ld a,SND_SWORDBEAM
	call z,playSound
	jp ramrock_updateHorizontalMovement

@gotoNextSubstate:
	call ecom_incSubstate
	ld l,Enemy.counter1
	ld (hl),90
	ld l,Enemy.subid
	ld (hl),$0c

ramrock_seedPhase_substate5:
	call ecom_decCounter1
	ret nz
	jp ramrock_seedPhase_resumeNormalMovement

ramrock_seedPhase_substate6:
	ld e,Enemy.subid
	ld a,(de)
	cp $0f
	jr nz,++
	call ecom_decCounter1
	ret nz
++
	jp ramrock_seedPhase_6a94


; "Bomb" phase
ramrock_glovePhase:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ramrock_glovePhase_substate0
	.dw ramrock_glovePhase_substate1
	.dw ramrock_glovePhase_substate2
	.dw ramrock_glovePhase_substate3
	.dw ramrock_glovePhase_substate4

ramrock_glovePhase_substate0:
	ld h,d
	ld bc,$4878
	ld l,Enemy.yh
	ldi a,(hl)
	cp b
	jr nz,@updateMovement

	inc l
	ld a,(hl)
	cp c
	jr nz,@updateMovement
	call ecom_incSubstate

	ld bc,$e001
@spawnArm:
	push bc
	ld b,PART_RAMROCK_GLOVE_FORM_ARM
	call ecom_spawnProjectile
	ld l,Part.subid
	ld (hl),c
	pop bc
	push bc
	ld c,b
	ld b,$18
	call objectCopyPositionWithOffset
	pop bc
	dec c
	ld a,$04
	jp nz,enemySetAnimation
	ld a,b
	cpl
	inc a
	ld b,a
	jr @spawnArm

@updateMovement:
	call objectGetRelativeAngle
	ld e,Enemy.angle
	ld (de),a
	jp objectApplySpeed

ramrock_glovePhase_substate1:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ld e,Enemy.var37
	ld a,(de)
	cp $03
	ret nz
	call ecom_incSubstate
	ld l,Enemy.counter2
	ld (hl),$02
	ld a,PALH_84
	jp loadPaletteHeader

ramrock_glovePhase_substate2:
	call ecom_decCounter2
	jr z,++
	ld a,SND_SWORD_OBTAINED
	call playSound
	ld a,PALH_83
	call loadPaletteHeader
++
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret nz
	ld a,$03
	call enemySetAnimation

ramrock_glovePhase_gotoSubstate3:
	ld bc,-$80
	call objectSetSpeedZ
	ld l,Enemy.subid
	ld (hl),$11
	ld l,Enemy.substate
	ld (hl),$03
	ld l,Enemy.angle
	ld (hl),$08
	ld l,Enemy.counter2
	ld (hl),120
	ret

ramrock_glovePhase_substate3:
	call enemyAnimate
	ld e,Enemy.zh
	ld a,(de)
	cp $f9
	ld c,$00
	call nz,objectUpdateSpeedZ_paramC

	call ramrock_glovePhase_updateMovement
	call ecom_decCounter2
	jr nz,ramrock_glovePhase_reverseDirection

	ld c,$50
	call objectCheckLinkWithinDistance
	jr nc,ramrock_glovePhase_reverseDirection

	ld h,d
	ld l,Enemy.subid
	ld a,$12
	ldi (hl),a
	call getRandomNumber
	and $01
	swap a
	ld (hl),a
	call getRandomNumber
	and $0f
	jr nz,+
	set 5,(hl)
+
	ld l,Enemy.substate
	ld (hl),$04
	ret

ramrock_glovePhase_substate4:
	ld e,Enemy.var35
	ld a,(de)
	cp $03
	jr z,@dead

	call enemyAnimate
	ld e,Enemy.var37
	ld a,(de)
	cp $03
	ret nz
	jr ramrock_glovePhase_gotoSubstate3

@dead:
	ld e,Enemy.health
	xor a
	ld (de),a
	jp enemyBoss_dead

;;
; Moves from side to side of the screen
ramrock_updateHorizontalMovement:
	call ecom_applyVelocityForSideviewEnemy
	ret nz
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	ld (de),a
	xor a
	ret

ramrock_glovePhase_reverseDirection:
	ld h,d
	ld l,Enemy.xh
	ld a,$c0
	cp (hl)
	jr c,++
	ld a,$28
	cp (hl)
	jr c,@applySpeed
	inc a
++
	ld (hl),a ; [xh]
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	ld (de),a
	xor a
@applySpeed:
	jp objectApplySpeed

;;
ramrock_glovePhase_updateMovement:
	ld hl,w1Link.yh
	ld e,Enemy.yh
	ld a,(de)
	cp (hl)
	jr nc,@label_10_262

	ld c,a
	ld a,(hl)
	sub c
	cp $40
	jr z,@ret
	jr c,@label_10_262

	ld a,(de)
	cp $50
	ld c,ANGLE_DOWN
	jr nc,@ret
	jr @moveInDirection

@label_10_262:
	ld a,(de) ; [yh]
	cp $41
	ld c,ANGLE_UP
	jr c,@ret

@moveInDirection:
	ld b,SPEED_80
	ld e,Enemy.angle
	call objectApplyGivenSpeed
@ret:
	ret
