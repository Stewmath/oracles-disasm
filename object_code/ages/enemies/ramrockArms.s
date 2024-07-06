; ==================================================================================================
; ENEMY_RAMROCK_ARMS
;
; Variables:
;   subid: ?
;   relatedObj1: ENEMY_RAMROCK
;   var30: ?
;   var32: Shields (subid 4): x-position relative to ramrock
;   var35: Number of times he's been hit in current phase
;   var36: ?
;   var37: ?
;   var38: Used by bomb phase?
; ==================================================================================================
enemyCode05:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw ramrockArm_state0
	.dw ramrockArm_state_stub
	.dw ramrockArm_state_stub
	.dw ramrockArm_state_stub
	.dw ramrockArm_state_stub
	.dw ramrockArm_state_stub
	.dw ramrockArm_state_stub
	.dw ramrockArm_state_stub
	.dw ramrockArm_state8

ramrockArm_state0:
	ld e,Enemy.subid
	ld a,(de)
	and $7f
	rst_jumpTable
	.dw @initSubid0
	.dw @initSubid0
	.dw @initSubid2
	.dw @initSubid2
	.dw @initSubid4
	.dw @initSubid4

@initSubid0:
	ld a,(de)
	ld b,a

	ld hl,ramrockArm_subid0And1XPositions
	rst_addAToHl
	ld a,(hl)
	ld h,d
	ld l,Enemy.xh
	ld (hl),a
	ld l,Enemy.yh
	ld (hl),$10
	ld l,Enemy.zh
	ld (hl),$f9

	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN
	ld l,Enemy.counter1
	ld (hl),$08
	ld a,$00
	add b
	call enemySetAnimation
	ld a,SPEED_180

@commonInit:
	call ecom_setSpeedAndState8
	jp objectSetVisiblec0

@initSubid2:
	ld a,(de)
	add $02 ; [subid]
	call enemySetAnimation
	call ramrockArm_setRelativePosition
	ld l,Enemy.zh
	ld (hl),$81
	jr @commonInit

@initSubid4:
	ld a,(de)
	sub $04
	ld b,a
	ld hl,ramrockArm_subid4And5Angles
	rst_addAToHl
	ld c,(hl)

	ld a,b
	ld hl,ramrockArm_subid4And5XPositions
	rst_addAToHl
	ld a,(hl)
	ld h,d
	ld l,Enemy.xh
	ldd (hl),a
	dec l
	ld (hl),$4e ; [yh]

	ld l,Enemy.angle
	ld (hl),c
	ld l,Enemy.zh
	ld (hl),$81

	ld l,Enemy.var32
	ld (hl),$04

	ld a,(de) ; [subid]
	add $02
	call enemySetAnimation
	jr @commonInit


ramrockArm_state_stub:
	ret


ramrockArm_state8:
	ld e,Enemy.subid
	ld a,(de)
	and $7f
	rst_jumpTable
	.dw ramrockArm_subid0
	.dw ramrockArm_subid0
	.dw ramrockArm_subid2
	.dw ramrockArm_subid2
	.dw ramrockArm_subid4
	.dw ramrockArm_subid4


; "Shields" in first phase
ramrockArm_subid0:
	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $04
	jr nz,@runStates

	ld e,Enemy.var31
	ld a,(de)
	or a
	jr nz,@runStates

	inc a
	ld (de),a
	ld e,Enemy.substate
	ld a,$06
	ld (de),a
	ld a,60
	ld e,Enemy.counter1
	ld (de),a

@runStates:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw ramrockArm_subid0_substate0
	.dw ramrockArm_subid0_substate1
	.dw ramrockArm_subid0_substate2
	.dw ramrockArm_subid0_substate3
	.dw ramrockArm_subid0_substate4
	.dw ramrockArm_subid0_substate5
	.dw ramrockArm_subid0_substate6


ramrockArm_subid0_substate0:
	call enemyAnimate
	call objectApplySpeed
	call ecom_decCounter1
	ret nz

	ld (hl),$08 ; [counter1]
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr nz,+
	dec a
+
	ld l,Enemy.angle
	add (hl)
	and $1f
	ld (hl),a
	and $0f
	cp $08
	ret nz

	; Angle is now directly left or right
	ld l,Enemy.substate
	inc (hl)
	ld l,Enemy.subid
	ld b,(hl)
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.subid
	inc (hl)
	ld a,$02
	add b
	jp enemySetAnimation


ramrockArm_subid0_substate1:
	call enemyAnimate
	call ramrockArm_setRelativePosition
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.subid
	ld a,$03
	cp (hl)
	ret nz
	jr ramrockArm_subid0_moveBackToRamrock


ramrockArm_subid0_substate2:
	call enemyAnimate
	call ramrockArm_setRelativePosition
	call ecom_decCounter2
	ret nz

	ld b,$04
	call objectCheckCenteredWithLink
	ret nc
	call objectGetAngleTowardLink
	cp $10
	ret nz

	call ecom_incSubstate
	ld l,Enemy.angle
	ld (hl),a
	ld l,Enemy.counter1
	ld (hl),$06
	ld l,Enemy.var30
	ld (hl),$00
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ld l,Enemy.subid
	ld a,$00
	add (hl)
	call enemySetAnimation
	ld a,SND_BIGSWORD
	jp playSound


ramrockArm_subid0_substate3:
	call objectApplySpeed
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	jr z,ramrockArm_subid0_moveBackToRamrock
	cp $80|ITEMCOLLISION_L1_SWORD
	jr z,@sword
	cp $80|ITEMCOLLISION_L2_SWORD
	jr z,@sword
	cp $80|ITEMCOLLISION_L3_SWORD
	jr nz,@moveTowardLink

@sword:
	ld e,Enemy.substate
	ld a,$05
	ld (de),a

	ld a,SPEED_200
	ld e,Enemy.speed
	ld (de),a
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	ld (de),a
	ret

@moveTowardLink:
	call ecom_getSideviewAdjacentWallsBitset
	jr nz,ramrockArm_subid0_moveBackToRamrock
	call ecom_decCounter1
	ret nz
	ld (hl),$06
	call objectGetAngleTowardLink
	jp objectNudgeAngleTowards


ramrockArm_subid0_moveBackToRamrock:
	ld e,Enemy.substate
	ld a,$04
	ld (de),a
	ld e,Enemy.speed
	ld a,SPEED_180
	ld (de),a

ramrockArm_subid0_setAngleTowardRamrock:
	call ramrockArm_getRelativePosition
	call objectGetRelativeAngle
	ld e,Enemy.angle
	ld (de),a
	ret


; Moving back towards Ramrock
ramrockArm_subid0_substate4:
	call objectApplySpeed
	call ramrockArm_subid0_setAngleTowardRamrock
	call ramrockArm_subid0_checkReachedRamrock
	ret nz
	ld a,SND_BOMB_LAND
	call playSound
	ld e,Enemy.substate
	ld a,$02
	ld (de),a
	ld e,Enemy.counter2
	ld a,60
	ld (de),a
	ld e,Enemy.subid
	ld a,(de)
	add $02
	jp enemySetAnimation


; Being knocked back after hit by sword
ramrockArm_subid0_substate5:
	call enemyAnimate
	ld e,Enemy.var30
	ld a,(de)
	or a
	jr nz,@noDamage
	ld a,Object.start
	call objectGetRelatedObject1Var
	call checkObjectsCollided
	jr nc,@noDamage

	ld e,Enemy.var30
	ld a,$01
	ld (de),a

	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	jr nz,@noDamage

	ld (hl),60
	ld l,Enemy.var35
	inc (hl)
	ld a,SND_BOSS_DAMAGE
	call playSound

@noDamage:
	xor a
	call ecom_getSideviewAdjacentWallsBitset
	jp z,objectApplySpeed

	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z
	jr ramrockArm_subid0_moveBackToRamrock


ramrockArm_subid0_substate6:
	ld e,Enemy.subid
	ld a,(de)
	add $04
	ld b,a
	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp b
	ret nz
	call ecom_decCounter1
	ret nz

	call objectCreatePuff
	ld a,Object.subid
	call objectGetRelatedObject1Var
	inc (hl)
	jp ramrockArm_deleteSelf


; Bomb grabber hands
ramrockArm_subid2:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw ramrockArm_subid2_substate0
	.dw ramrockArm_subid2_substate1
	.dw ramrockArm_subid2_substate2

ramrockArm_subid2_substate0:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld (hl),$07

	ld a,SND_SCENT_SEED
	call playSound
	jp ecom_incSubstate

ramrockArm_subid2_substate1:
	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $08
	ret nz

	ld h,d
	ld a,(hl)
	rrca
	jr c,ramrockArm_deleteSelf

	ld l,Enemy.visible
	res 7,(hl)
	jp ecom_incSubstate

ramrockArm_subid2_substate2:
	call ramrockArm_subid2_copyRamrockPosition
	ld l,Enemy.collisionType
	res 7,(hl)

	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0a
	jr z,@relatedSubid0a
	cp $09
	ret nz

@relatedSubid09:
	ld h,d
	ld l,Enemy.collisionType
	set 7,(hl)

	ld c,ITEM_BOMB
	call findItemWithID
	ret nz

	ld l,Item.yh
	ld b,(hl)
	ld l,Item.xh
	ld c,(hl)
	push hl
	ld e,$06
	call ramrockArm_checkPositionAtRamrock
	pop hl
	ret nz

	ld l,Item.zh
	ld a,(hl)
	or a
	jr z,++
	cp $fc
	ret c
++
	; Bomb is close enough
	ld l,Item.var2f
	set 4,(hl) ; Delete bomb

	ld a,Object.invincibilityCounter
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	ret nz
	ld (hl),60
	ld l,Enemy.var35
	inc (hl)
	ret

; Time to die
@relatedSubid0a:
	ld e,Enemy.subid
	ld a,$01
	ld (de),a
@nextPuff:
	call getFreeInteractionSlot
	ld (hl),INTERAC_PUFF
	push hl
	call ramrockArm_setRelativePosition
	pop hl
	call objectCopyPosition
	ld e,Enemy.subid
	ld a,(de)
	dec a
	ld (de),a
	jr z,@nextPuff

	ld a,$02
	ld (de),a ; [this.subid]

ramrockArm_deleteSelf:
	call decNumEnemies
	jp enemyDelete


; Shield hands
ramrockArm_subid4:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw ramrockArm_subid4_substate0
	.dw ramrockArm_subid4_substate1
	.dw ramrockArm_subid4_substate2
	.dw ramrockArm_subid4_substate3


ramrockArm_subid4_substate0:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	ld a,$06
	call objectSetCollideRadius
	ld bc,-$80
	call objectSetSpeedZ
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ld l,Enemy.counter2
	ld (hl),62
	jp ecom_incSubstate


ramrockArm_subid4_substate1:
	ld e,Enemy.zh
	ld a,(de)
	cp $f9
	ld c,$00
	jp nz,objectUpdateSpeedZ_paramC
	call ecom_decCounter2
	jp nz,objectApplySpeed

	call ecom_incSubstate
	ld e,Enemy.subid
	ld a,(de)
	rrca
	ret nc

	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld (hl),$0c

	ld a,PALH_84
	jp loadPaletteHeader


ramrockArm_subid4_substate2:
.ifndef REGION_JP
	ld a,Object.substate
	call objectGetRelatedObject1Var
	ld a,(hl)
	dec a
	jr z,@updateXPosition
.endif

	ld e,Enemy.var2a
	ld a,(de)
	rlca
	jr c,ramrockArm_subid4_collisionOccurred

	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0d
	jr z,ramrockArm_subid4_collisionOccurred

	cp $10
	jr nz,@updateXPosition

	call objectCreatePuff
	jr ramrockArm_deleteSelf

@updateXPosition:
	ld e,Enemy.var32
	ld a,(de)
	ld b,a
	cp $0c
	jr z,ramrockArm_subid4_updateXPosition
	inc a
	ld (de),a
	ld b,a

; @param	b	X-offset
ramrockArm_subid4_updateXPosition:
	ld e,Enemy.subid
	ld a,(de)
	rrca
	jr c,++
	ld a,b
	cpl
	inc a
	ld b,a
++
	ld a,Object.xh
	call objectGetRelatedObject1Var
	ld a,(hl)
	add b
	ld e,l
	ld (de),a
	ret

ramrockArm_subid4_collisionOccurred:
	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld (hl),Object.xh
	ld l,Enemy.var36
	ld (hl),$10
	jp ecom_incSubstate


ramrockArm_subid4_substate3:
	ld e,Enemy.var2a
	ld a,(de)
	rlca
	jr nc,++

	ld a,Object.var36
	call objectGetRelatedObject1Var
	ld (hl),$10
++
	ld e,Enemy.var32
	ld a,(de)
	sub $02
	cp $04
	jr nc,+
	ld b,$04
	jr ++
+
	ld (de),a
	ld b,a
	jr ramrockArm_subid4_updateXPosition
++
	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0d
	jr z,ramrockArm_subid4_updateXPosition

	ld e,Enemy.substate
	ld a,$02
	ld (de),a
	jr ramrockArm_subid4_updateXPosition


;;
ramrockArm_setRelativePosition:
	call ramrockArm_getRelativePosition
	ld h,d
	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c
	ret

;;
; @param[out]	zflag
ramrockArm_subid0_checkReachedRamrock:
	call ramrockArm_getRelativePosition
	ld e,$02

;;
; @param	bc	Position
; @param	e
ramrockArm_checkPositionAtRamrock:
	ld h,d
	ld l,Enemy.yh
	ld a,e
	add b
	cp (hl)
	jr c,label_10_212
	sub e
label_10_211:
	sub e
	cp (hl)
	jr nc,label_10_212
	ld l,Enemy.xh
	ld a,e
	add c
	cp (hl)
	jr c,label_10_212
	sub e
	sub e
	cp (hl)
	jr nc,label_10_212
	xor a
	ret
label_10_212:
	or d
	ret

;;
; @param[out]	bc	Relative position
ramrockArm_getRelativePosition:
	ld e,Enemy.subid
	ld a,(de)
	ld c,$0e
	rrca
	jr nc,+
	ld c,-$0e
+
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ldi a,(hl)
	add $08
	ld b,a
	inc l
	ld a,(hl) ; [object.xh]
	add c
	ld c,a
	ret

;;
ramrockArm_subid2_copyRamrockPosition:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ldi a,(hl)
	add $08
	ld b,a
	inc l
	ld a,(hl)
	ld h,d
	ld l,Enemy.xh
	ldd (hl),a
	dec l
	ld (hl),b
	ret

ramrockArm_subid0And1XPositions:
	.db $30 $c0

ramrockArm_subid4And5XPositions:
	.db $37 $b9

ramrockArm_subid4And5Angles:
	.db $08 $18
