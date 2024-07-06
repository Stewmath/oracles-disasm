; ==================================================================================================
; ENEMY_AQUAMENTUS
;
; Variables (subid 1, main body):
;   var31: Affects collision box?
;   var32/var33: Target position?
;   var34: Reference to subid 2 (sprites only)
;   var35: Reference to subid 3 (the horn)
;   var36: Counter for playing footstep sound
;   var37: ?
;
; Variables (subid 2, sprites only):
;   relatedObj1: Reference to subid 1 (main body)
;   relatedObj2: Reference to subid 3 (horn)
;   var30: Current animation
;
; Variables (subid 3, horn):
;   relatedObj2: Reference to subid 2 (sprites)
;   var30: Current animation
; ==================================================================================================
enemyCode78:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	dec a
	jr z,@justHit
	dec a
	jr z,@normalStatus

	; Dead
	ld e,Enemy.subid
	ld a,(de)
	sub $02
	jp z,enemyBoss_dead
	dec a
	jp nz,enemyDelete
	call ecom_killRelatedObj1
	call ecom_killRelatedObj2
	jp enemyDie_uncounted_withoutItemDrop

@justHit:
	ld e,Enemy.subid
	ld a,(de)
	sub $03
	jr nz,@normalStatus

	ld a,Object.invincibilityCounter
	call objectGetRelatedObject2Var
	ld e,l
	ld a,(de)
	ld (hl),a

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@state8OrHigher
	rst_jumpTable
	.dw aquamentus_state_uninitialized
	.dw aquamentus_state_spawner
	.dw aquamentus_state_stub
	.dw aquamentus_state_stub
	.dw aquamentus_state_stub
	.dw aquamentus_state_stub
	.dw aquamentus_state_stub
	.dw aquamentus_state_stub

@state8OrHigher
	dec b
	ld a,b
	rst_jumpTable
	.dw aquamentus_subid1
	.dw aquamentus_subid2
	.dw aquamentus_subid3


aquamentus_state_uninitialized:
	ld c,$20
	call ecom_setZAboveScreen

	; Check subid
	ld a,b
	or a
	jp nz,ecom_setSpeedAndState8

	; Subid is 0; go to state 1
	ld l,e
	inc (hl) ; [state] = 1
	ld a,ENEMY_AQUAMENTUS
	ld b,PALH_SPR_AQUAMENTUS
	jp enemyBoss_initializeRoom


aquamentus_state_spawner:
	ld a,(wcc93)
	or a
	ret nz

	ld b,$03
	call checkBEnemySlotsAvailable
	ret nz

	ld b,ENEMY_AQUAMENTUS
	call ecom_spawnUncountedEnemyWithSubid01
	ld c,h

	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl) ; [child.subid] = 2
	call aquamentus_initializeChildObject

	push hl
	call ecom_spawnUncountedEnemyWithSubid01
	ld (hl),$03 ; [child.subid] = 3
	call aquamentus_initializeChildObject

	ld e,h
	pop hl
	ld a,h
	ld h,c
	ld l,Enemy.var34
	ldi (hl),a ; [body.var34] = subid2
	ld (hl),e  ; [body.var35] = horn
	call objectCopyPosition
	jp enemyDelete


aquamentus_state_stub:
	ret


; Body hitbox + general logic
aquamentus_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw aquamentus_body_state8
	.dw aquamentus_body_state9
	.dw aquamentus_body_stateA
	.dw aquamentus_body_stateB
	.dw aquamentus_body_stateC
	.dw aquamentus_body_stateD
	.dw aquamentus_body_stateE
	.dw aquamentus_body_stateF

; Initialization
aquamentus_body_state8:
	ld bc,$020c
	call enemyBoss_spawnShadow
	ret nz

	ld h,d
	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_AQUAMENTUS_BODY

	ld l,Enemy.var32
	ld a,$50
	ldi (hl),a  ; [var32]
	ld (hl),$c0 ; [var33]

	ld l,Enemy.var31
	ld (hl),$01
	ld l,Enemy.counter1
	ld (hl),90
	ret


; Lowering down
aquamentus_body_state9:
	ld e,Enemy.zh
	ld a,(de)
	cp $f4
	jr nc,@doneLowering

	; Lower aquamentus based on his current height
	and $f0
	swap a
	ld hl,aquamentus_fallingSpeeds
	rst_addAToHl
	dec e
	ld a,(de)
	add (hl)
	ld (de),a
	inc e
	ld a,(de)
	adc $00
	ld (de),a
	jp aquamentus_playHoverSoundEvery32Frames

@doneLowering:
	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = $0a

	ld l,Enemy.var31
	ld (hl),$02
	ret


; Hovering in place before landing
aquamentus_body_stateA:
	call ecom_decCounter1
	jp nz,aquamentus_playHoverSoundEvery32Frames

	; Time to land on the ground

	ld (hl),60
	ld l,Enemy.zh
	ld (hl),$00

	ld l,e
	inc (hl) ; [state] = $0b

	ld l,Enemy.var31
	ld (hl),$04

	; Check whether to play boss music?
	ld l,Enemy.var37
	bit 0,(hl)
	jr nz,++
	inc (hl)
	ld a,MUS_BOSS
	ld (wActiveMusic),a
	call playSound
++
	ld a,$20

;;
aquamentus_body_pound:
	call setScreenShakeCounter
	ld a,SND_STRONG_POUND
	jp playSound


; Standing in place
aquamentus_body_stateB:
	call ecom_decCounter1
	ret nz
	ld (hl),150
	inc l
	ld (hl),$04 ; [counter2]

	ld l,Enemy.var36
	ld (hl),$18
	jp aquamentus_decideNextAttack


; Moving forward
aquamentus_body_stateC:
	call aquamentus_body_playFootstepSoundEvery24Frames
	call aquamentus_body_6694
	call ecom_decCounter1
	jr nz,@applySpeed

	inc l
	ldd a,(hl) ; [counter2]
	ld bc,aquamentus_projectileFireDelayCounters
	call addAToBc
	ld a,(bc)
	ldi (hl),a ; [counter1]
	dec (hl)   ; [counter2]--
	jr nz,@fireProjectiles

	ld l,Enemy.state
	inc (hl) ; [state] = $0d

	ld l,Enemy.var31
	ld (hl),$08
	ld l,Enemy.speed
	ld (hl),SPEED_80
	ret

@fireProjectiles:
	call aquamentus_body_chooseRandomLeftwardAngle
	call aquamentus_fireProjectiles
@applySpeed:
	jp objectApplySpeed


; Walking back to original position
aquamentus_body_stateD:
	call aquamentus_body_playFootstepSoundEvery18Frames
	call aquamentus_body_6694
	call aquamentus_body_checkReachedTargetPosition
	jr c,@gotoStateB

	call ecom_decCounter1
	call z,aquamentus_fireProjectiles
	jp ecom_moveTowardPosition

@gotoStateB:
	ld l,Enemy.counter1
	ld (hl),30
	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.var31
	ld (hl),$04
	ret


; Charge attack
aquamentus_body_stateE:
	call ecom_decCounter2
	ret nz

	ld e,Enemy.xh
	ld a,(de)
	cp $1c
	jr c,@onLeftSide

	; Begin charge

	ld a,(wFrameCounter)
	and $1f
	ld a,SND_SWORDSPIN
	call z,playSound
	ld a,(wFrameCounter)
	and $07
	jr nz,@applySpeed

	call getFreeInteractionSlot
	jr nz,@applySpeed

	; Create dust
	ld (hl),INTERAC_FALLDOWNHOLE
	inc l
	inc (hl) ; [subid] = 1
	ld bc,$1010
	call objectCopyPositionWithOffset

@applySpeed:
	jp objectApplySpeed

@onLeftSide:
	call ecom_decCounter1
	dec (hl)
	jr z,@gotoStateF

	; Play "pound" sound effect when he reaches the wall
	ld a,(hl)
	cp 148
	ret nz
	ld a,70
	jp aquamentus_body_pound

@gotoStateF:
	ld (hl),240 ; [counter1]
	inc l
	ld (hl),60 ; [counter2]

	ld l,Enemy.state
	inc (hl) ; [state] = $0f

	ld l,Enemy.zh
	ld (hl),$f8

	ld l,Enemy.var31
	ld (hl),$01

	ld l,Enemy.angle
	ld (hl),$08
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ret


aquamentus_body_stateF:
	call aquamentus_playHoverSoundEvery32Frames
	call ecom_decCounter2
	jr z,@moveBack

	; Rising up
	ld l,Enemy.zh
	ld a,(hl)
	cp $e8
	ret c
	ld b,$80
	jp aquamentus_body_subZ

@moveBack:
	call ecom_decCounter1
	jr z,@lowerDown

	; Moving back to original position (and maybe still rising up)
	ld a,(hl) ; [counter1]
	cp 210
	ld b,$c0
	call nc,aquamentus_body_subZ
	call aquamentus_body_checkReachedTargetPosition
	ret c
	jp ecom_moveTowardPosition

@lowerDown:
	ld l,Enemy.state
	ld (hl),$09
	ld l,Enemy.counter1
	ld (hl),30
	ret


; All sprites except horn
aquamentus_subid2:
	ld a,(de) ; [state]
	sub $08
	jr z,@state8

@state9:
	ld a,Object.var31
	call objectGetRelatedObject1Var
	ld b,(hl)

	; Copy main body's position
	ld a,d
	ld d,h
	ld h,a
	call objectCopyPosition
	ld d,h

	ld a,b
	call getHighestSetBit
	jr nc,aquamentus_animate

	ld hl,aquamentus_animations
	rst_addAToHl
	ld e,Enemy.var30
	ld a,(de)
	cp (hl)
	jr z,aquamentus_animate

	ld a,(hl)
	ld (de),a
	jp enemySetAnimation

@state8:
	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = 9

	ld l,Enemy.collisionType
	res 7,(hl)

	; Copy parent's horn reference to relatedObj2
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.var35
	ld e,Enemy.relatedObj2+1
	ld a,(hl)
	ld (de),a
	jp objectSetVisible81


; Horn & horn hitbox
aquamentus_subid3:
	ld a,(de)
	sub $08
	jr z,aquamentus_subid3_state8


aquamentus_subid3_state9:
	; Only draw the horn if the main sprite is also visible
	ld a,Object.visible
	call objectGetRelatedObject2Var
	ld e,l
	ld a,(hl)
	and $80
	ld b,a
	ld a,(de)
	and $7f
	or b
	ld (de),a

	call aquamentus_horn_updateAnimation

	; Get parent's position
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)

	; [horn.zh] = [body.zh] - 7
	ld l,Enemy.zh
	ld e,l
	ld a,(hl)
	sub $07
	ld (de),a

	; Y/X offsets for horn vary based on subid 2's animParameter
	ld l,Enemy.var34
	ld h,(hl)
	ld l,Enemy.animParameter
	ld a,(hl)
	cp $09
	jr c,+
	ld a,$05
+
	ld hl,aquamentus_hornXYOffsets
	rst_addDoubleIndex
	ld e,Enemy.yh
	ldi a,(hl)
	add b
	ld (de),a

	ld e,Enemy.xh
	ld a,(hl)
	add c
	ld (de),a

aquamentus_animate:
	jp enemyAnimate


aquamentus_subid3_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.collisionRadiusY
	ld (hl),$06
	inc l
	ld (hl),$03

	; Copy parent's subid2 reference to relatedObj2
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.var34
	ld e,Enemy.relatedObj2+1
	ld a,(hl)
	ld (de),a
	jp objectSetVisible81


;;
; @param	h	Child object
aquamentus_initializeChildObject:
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c
	inc l
	ld (hl),a
	jp objectCopyPosition

;;
; Chooses whether to charge (state $0e) or move forward (state $0c)
aquamentus_decideNextAttack:
	ld e,Enemy.xh
	ld a,(de)
	ld b,a
	ldh a,(<hEnemyTargetX)
	cp b
	ld a,$0c
	jr nc,@setState

	call getRandomNumber_noPreserveVars
	and $07
	ld c,a
	ldh a,(<hEnemyTargetX)
	rlca
	rlca
	and $03
	ld hl,aquamentus_chargeProbabilities
	rst_addAToHl
	ld a,c
	call checkFlag
	ld a,$0c
	jr z,@setState
	ld a,$0e

@setState:
	ld e,Enemy.state
	ld (de),a
	cp $0c
	jr z,@initializeMovement

	; Initialize charge attack
	call aquamentus_body_calculateAngleForCharge
	ld e,Enemy.counter2
	ld a,30
	ld (de),a

	ld a,$20
	ld e,SPEED_1c0

@setVar31AndSpeed:
	ld h,d
	ld l,Enemy.var31
	ld (hl),a
	ld l,Enemy.speed
	ld (hl),e

	ld e,Enemy.var31
	ld a,(de)
	call getHighestSetBit
	ret nc

	ld hl,aquamentus_collisionBoxSizes
	rst_addDoubleIndex
	ld e,Enemy.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

@initializeMovement:
	call aquamentus_body_chooseRandomLeftwardAngle
	ld a,$04
	ld e,SPEED_40
	jr @setVar31AndSpeed


;;
aquamentus_body_chooseRandomLeftwardAngle:
	call getRandomNumber_noPreserveVars
	and $07
	cp $07
	jr nz,+
	ld a,$03
+
	add $15
	ld e,Enemy.angle
	ld (de),a
	ret

;;
; Sets angle to move left, slightly up or down, depending on Link's position
aquamentus_body_calculateAngleForCharge:
	ld b,$02
	ldh a,(<hEnemyTargetY)
	cp $48
	jr c,@setAngle
	dec b
	cp $68
	jr c,@setAngle
	dec b

@setAngle:
	ld a,$17
	add b
	ld e,Enemy.angle
	ld (de),a
	ret

;;
; @param[out]	cflag	c if within 2 pixels of target position
aquamentus_body_checkReachedTargetPosition:
	ld h,d
	ld l,Enemy.var32
	call ecom_readPositionVars
	sub c
	add $02
	cp $05
	ret nc
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	ret

;;
; @param	b	Amount to subtract z value by (subpixels)
aquamentus_body_subZ:
	ld e,Enemy.z
	ld a,(de)
	sub b
	ld (de),a
	inc e
	ld a,(de)
	sbc $00
	ld (de),a
	ret

;;
aquamentus_fireProjectiles:
	ld e,Enemy.var31
	ld a,$10
	ld (de),a
	ld a,SND_DODONGO_OPEN_MOUTH
	call playSound
	ld b,PART_AQUAMENTUS_PROJECTILE
	jp ecom_spawnProjectile

;;
aquamentus_body_6694:
	ld e,Enemy.var34
	ld a,(de)
	ld h,a
	ld l,Enemy.animParameter
	ld a,(hl)
	inc a
	ret nz

	ld e,Enemy.state
	ld a,(de)
	cp $0c
	ld a,$04
	jr z,+
	add a
+
	ld e,Enemy.var31
	ld (de),a
	ret


;;
aquamentus_playHoverSoundEvery32Frames:
	ld a,(wFrameCounter)
	and $1f
	ret nz

	ld a,SND_AQUAMENTUS_HOVER
	jr aquamentus_playSound

;;
aquamentus_body_playFootstepSoundEvery18Frames:
	ld a,$12
	jr ++

;;
aquamentus_body_playFootstepSoundEvery24Frames:
	ld a,$18
++
	ld h,d
	ld l,Enemy.var36
	dec (hl)
	ret nz

	ld (hl),a
	ld a,SND_ROLLER

aquamentus_playSound:
	jp playSound

;;
aquamentus_horn_updateAnimation:
	ld a,Object.var34
	call objectGetRelatedObject1Var
	ld h,(hl)

	ld l,Enemy.animParameter
	ld a,(hl)
	inc a
	ld hl,@animations
	rst_addAToHl

	ld a,(hl)
	ld h,d
	ld l,Enemy.var30
	cp (hl)
	ret z

	ld (hl),a
	jp enemySetAnimation

@animations:
	.db $06 $05 $05 $05 $05 $06 $06 $06
	.db $07 $08

aquamentus_projectileFireDelayCounters:
	.db 0, 100, 60, 180, 180


; Each byte corresponds to one horizontal quarter of the screen. Aquamentus will charge if
; a randomly chosen bit from that byte is set. (Doesn't apply if Link is behind
; aquamentus.)
aquamentus_chargeProbabilities:
	.db $03 $31 $13 $33


aquamentus_collisionBoxSizes:
	.db $16 $08
	.db $16 $08
	.db $0a $0d
	.db $0a $0d
	.db $0a $0d
	.db $0c $14

aquamentus_animations:
	.db $00 $00 $01 $02 $03 $04


; Each byte is a z value to add depending on aquamentus's current height.
aquamentus_fallingSpeeds:
	.db $00 $f0 $f0 $f0 $f0 $f0 $f0 $e0
	.db $e0 $e0 $e0 $c0 $c0 $a0 $60 $30

aquamentus_hornXYOffsets:
	.db $d8 $f4
	.db $d7 $f4
	.db $e8 $f2
	.db $e7 $f2
	.db $e8 $f2
	.db $e8 $f8
	.db $e5 $f4
	.db $e8 $f2
	.db $0f $e8
