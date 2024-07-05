; ==================================================================================================
; ENEMY_VIRE
;
; Variables (for main form, subid 0):
;   relatedObj2: INTERAC_PUFF?
;   var30: Rotation angle?
;   var32: Used for animations?
;   var33: Health?
;   var34: Number of "bat children" alive. Will die when this reaches 0.
;   var37: Marks whether text has been shown as health goes down
;   var38: If nonzero, he won't spawn a fairy when defeated?
;
; Variables (for bat form, subid 1):
;   relatedObj1: Reference to main form (subid 0)
;   var30: Rotation angle?
;   var35/var36: Target position?
; ==================================================================================================
enemyCode75:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead

	; ENEMYSTATUS_JUST_HIT
	ld e,Enemy.subid
	ld a,(de)
	or a
	ld e,Enemy.health
	ld a,(de)
	jr z,++
	or a
	ret z
	jr @normalStatus
++
	ld h,d
	ld l,Enemy.var33
	cp (hl)
	jr z,@normalStatus

	ld (hl),a
	or a
	ret z

	ld l,Enemy.state
	ld (hl),$0e
	inc l
	ld (hl),$00
	ret

@dead:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr z,@subid0Dead

	; Subid 1 (bat child) death
	call objectCreatePuff
	ld a,Object.var34
	call objectGetRelatedObject1Var
	dec (hl)
	call z,objectCopyPosition
	jp enemyDelete

@subid0Dead:
	ld h,d
	ld l,Enemy.state
	ld a,(hl)
	cp $0f
	jp z,enemyBoss_dead

	ld (hl),$0f ; [state]
	inc l
	ld (hl),$00 ; [substate]
	inc l
	ld (hl),20 ; [counter1]

	ld l,Enemy.health
	ld (hl),$01

	ld l,Enemy.direction
	xor a
	ld (hl),a
	call enemySetAnimation

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr c,@commonState

	ld a,b
	or a
	jp z,vire_mainForm
	jp vire_batForm

@commonState:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw vire_state_uninitialized
	.dw vire_state_stub
	.dw vire_state_stub
	.dw vire_state_stub
	.dw vire_state_stub
	.dw vire_state_stub
	.dw vire_state_stub
	.dw vire_state_stub


vire_state_uninitialized:
	ld a,SPEED_c0
	call ecom_setSpeedAndState8

	ld a,b
	or a
	ret nz

	; "Main" vire only (not bat form)
	ld l,Enemy.zh
	ld (hl),$fc

	dec a ; a = $ff
	ld b,$00
	jp enemyBoss_initializeRoom


vire_state_stub:
	ret


vire_mainForm:
	ld e,Enemy.direction
	ld a,(de)
	or a
	jr z,@runState

	ld h,d
	ld l,Enemy.var32
	inc (hl)
	ld a,(hl)
	cp $18
	jr c,@runState

	xor a
	ld (hl),a ; [var32] = 0

	ld l,e
	ld (hl),a ; [direction] = 0
	call enemySetAnimation

@runState:
	ld e,Enemy.state
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw vire_mainForm_state8
	.dw vire_mainForm_state9
	.dw vire_mainForm_stateA
	.dw vire_mainForm_stateB
	.dw vire_mainForm_stateC
	.dw vire_mainForm_stateD
	.dw vire_mainForm_stateE
	.dw vire_mainForm_stateF


; Mini-cutscene before starting fight
vire_mainForm_state8:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	; Wait for Link to approach
	ldh a,(<hEnemyTargetY)
	sub $38
	cp $41
	ret nc
	ldh a,(<hEnemyTargetX)
	sub $50
	cp $51
	ret nc

	; Can't be dead...
	ld a,(wLinkDeathTrigger)
	or a
	ret nz

	ldbc INTERAC_PUFF, $02
	call objectCreateInteraction
	ret nz

	; [relatedObj2] = INTERAC_PUFF
	ld e,Enemy.relatedObj2+1
	ld a,h
	ld (de),a
	dec e
	ld a,Interaction.start
	ld (de),a

	ld e,Enemy.substate
	ld a,$01
	ld (de),a
	ld (wDisabledObjects),a ; DISABLE_LINK
	ld (wDisableLinkCollisionsAndMenu),a
	ret

@substate1:
	; Wait for puff to disappear
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z

	ld h,d
	ld l,Enemy.substate
	inc (hl)
	inc l
	ld (hl),$08 ; [counter1]
	jp objectSetVisiblec1

@substate2:
	; Show text in 8 frames
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl) ; [substate]
	ld bc,TX_2f12
	call checkIsLinkedGame
	jr z,+
	inc c ; TX_2f13
+
	jp showText

@substate3:
	; Disappear
	call objectCreatePuff
	ret nz

	; a == 0
	ld (wDisabledObjects),a
	ld (wDisableLinkCollisionsAndMenu),a

.ifdef ROM_AGES
	call ecom_incState
.else
	ld h,d
	ld l,Enemy.state
	inc (hl)
.endif

	inc l
	ldi (hl),a ; [substate] = 0
	ld (hl),90 ; [counter1]

	ld l,Enemy.health
	ld a,(hl)
	ld l,Enemy.var33
	ld (hl),a

	call objectSetInvisible
	ld a,MUS_MINIBOSS
	ld (wActiveMusic),a
	jp playSound


; Off-screen for [counter1] frames
vire_mainForm_state9:
	call ecom_decCounter1
	ret nz

	; Decide what to do next (health affects probability)
	ld e,Enemy.health
	ld a,(de)
	ld c,$08
	cp $0a
	jr c,++
	ld c,$04
	cp $10
	jr c,++
	ld c,$00
++
	call getRandomNumber
	and $07
	add c
	ld hl,@behaviourTable
	rst_addAToHl

	ld a,(hl)
	ld e,Enemy.state
	ld (de),a
	ret

; Vire chooses from 8 of these values, starting from index 0, 4, or 8 depending on health
; (starts from 0 when health is high).
@behaviourTable:
	.db $0a $0a $0b $0d $0a $0a $0a $0a
	.db $0b $0b $0c $0d $0a $0b $0c $0d


; Charges across screen
vire_mainForm_stateA:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call vire_spawnOutsideCamera
	inc l
	ld (hl),20 ; [counter1]
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ret

; Moving slowly before charging
@substate1:
	call ecom_decCounter1
	jp nz,vire_mainForm_applySpeedAndAnimate

	; Begin charging
	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.speed
	ld (hl),SPEED_200
	call ecom_updateAngleTowardTarget
	call getRandomNumber_noPreserveVars
	and $03
	sub $02
	ld b,a
	ld e,Enemy.angle
	ld a,(de)
	add b
	and $1f
	ld (de),a

; Charging across screen
@substate2:
	call vire_checkOffScreen
	jp nc,vire_mainForm_leftScreen
	call ecom_decCounter1
	ld a,(hl)
	and $1f
	call z,vire_mainForm_fireProjectile
	jp vire_mainForm_applySpeedAndAnimate


; Circling Link, runs away if Link gets too close (similar to state D)
vire_mainForm_stateB:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0: ; Also subid 0 for state D
	call vire_spawnOutsideCamera
	inc l
	ld (hl),120 ; [counter1]
	call getRandomNumber_noPreserveVars
	and $08
	jr nz,+
	ld a,$f8
+
	ld e,Enemy.var30
	ld (de),a
	ret

@substate1:
	ld a,(wFrameCounter)
	and $03
	jr nz,++

	call ecom_decCounter1
	jr z,@beginCharge

	ld a,(hl)
	and $1f
	ld b,$01
	call z,vire_mainForm_fireProjectileWithSubid
++
	call vire_mainForm_checkLinkTooClose
	jp nc,vire_mainForm_circleAroundScreen

; Begin charging; initially toward Link, but will run away if he gets too close or Link
; attacks
@beginCharge:
	ld l,Enemy.substate
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_200
	call ecom_updateAngleTowardTarget
	jr @animate

; Charging toward Link
@substate2:
	call vire_mainForm_checkLinkTooClose
	jr c,@updateAngleAway
	ld a,(wLinkUsingItem1)
	or a
	jr nz,@updateAngleAway
	call vire_checkOffScreen
	jp nc,vire_mainForm_leftScreen
	jp vire_mainForm_applySpeedAndAnimate

; Charging away from Link
@updateAngleAway:
	ld l,e
	inc (hl) ; [substate]
	call ecom_updateCardinalAngleAwayFromTarget
@animate:
	jp enemyAnimate

@substate3:
	call vire_checkOffScreen
	jp nc,vire_mainForm_leftScreen

	call ecom_decCounter1
	ld a,(hl)
	and $1f
	ld b,$01
	call z,vire_mainForm_fireProjectileWithSubid
	jp vire_mainForm_applySpeedAndAnimate


; Vire creeps in from the screen edge to fire one projectile, then runs away
vire_mainForm_stateC:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call vire_spawnOutsideCamera
	inc l
	ld (hl),28 ; [counter1]
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ret

@substate1:
	call ecom_decCounter1
	jp nz,vire_mainForm_applySpeedAndAnimate

	ld (hl),12 ; [counter1]
	ld l,e
	inc (hl) ; [substate]

	ld b,$03
	call vire_mainForm_fireProjectileWithSubid
	jr @animate

@substate2:
	call ecom_decCounter1
	jr nz,@animate

	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	ld l,Enemy.speed
	ld (hl),SPEED_200

@animate:
	jp enemyAnimate

@substate3:
	call vire_checkOffScreen
	jp nc,vire_mainForm_leftScreen
	jp vire_mainForm_applySpeedAndAnimate


; Circling Link, runs away if Link attempts to attack (similar to state B)
vire_mainForm_stateD:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw vire_mainForm_stateB@substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw vire_state_moveOffScreen

@substate1:
	ld a,(wFrameCounter)
	and $03
	jr nz,++

	call ecom_decCounter1
	jr z,@beginCharge

	ld a,(hl)
	and $1f
	ld b,$01
	call z,vire_mainForm_fireProjectileWithSubid
++
	call vire_mainForm_checkLinkTooClose
	jp nc,vire_mainForm_circleAroundScreen

; Begin charging; initially toward Link, but will run away if he gets too close or Link
; attacks
@beginCharge:
	ld l,Enemy.substate
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_200
	call ecom_updateAngleTowardTarget
@animate:
	jp enemyAnimate

; Charging toward Link
@substate2:
	ld a,(wLinkUsingItem1)
	or a
	jr z,@moveOffScreen

	ld h,d
	ld l,e
	inc (hl) ; [substate]
	inc l
	ld (hl),12 ; [counter1]
	ld l,Enemy.speed
	ld (hl),SPEED_300
	call ecom_updateCardinalAngleAwayFromTarget
	jr @animate

@moveOffScreen:
	call vire_checkOffScreen
	jp nc,vire_mainForm_leftScreen
	jp vire_mainForm_applySpeedAndAnimate

@substate3:
	call ecom_decCounter1
	jp nz,vire_mainForm_applySpeedAndAnimate

	ld (hl),12 ; [counter1]
	ld l,e
	inc (hl) ; [substate]

	ld b,PART_VIRE_PROJECTILE
	call ecom_spawnProjectile

	ld a,SND_SPLASH
	call playSound
	jr @animate

@substate4:
	call ecom_decCounter1
	jr nz,@animate

	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.speed
	ld (hl),SPEED_1c0

	call ecom_updateCardinalAngleAwayFromTarget
	jr @animate


vire_state_moveOffScreen: ; Used by states D and E
	call vire_checkOffScreen
	jp nc,vire_mainForm_leftScreen
	jp vire_mainForm_applySpeedAndAnimate


; Just took damage
vire_mainForm_stateE:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw vire_state_moveOffScreen

@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	inc l
	ld (hl),20 ; [counter1]

	ld l,Enemy.speed
	ld (hl),SPEED_300
	call ecom_updateCardinalAngleAwayFromTarget

	ld e,Enemy.direction
	xor a
	ld (de),a

	ld e,Enemy.var32
	ld (de),a
	jp enemySetAnimation

@substate1:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl) ; [substate]

	; Check whether to show text based on current health
	ld l,Enemy.health
	ld a,(hl)
	cp $10
	ret nc

	ld b,$01
	cp $0a
	jr nc,+
	inc b
+
	ld a,b
	ld l,Enemy.var37
	cp (hl)
	ret z

	ld (hl),a
	add <TX_2f13
	ld c,a
	ld b,>TX_2f00
	jp showText


; "Main form" died, about to split into bats
vire_mainForm_stateF:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [counter1]
	ld bc,TX_2f16
	jp showText

@substate1:
	ld b,$02
	call checkBEnemySlotsAvailable
	jp nz,enemyAnimate

	ld h,d
	ld l,Enemy.substate
	inc (hl)

	ld l,Enemy.var34
	ld (hl),$02

	call objectSetInvisible
	call objectCreatePuff

	; Spawn bats
	ld b,ENEMY_VIRE
	call ecom_spawnUncountedEnemyWithSubid01
	call @initBat

	call ecom_spawnUncountedEnemyWithSubid01
	inc a

@initBat:
	inc l
	ld (hl),a ; [var03] = a (0 or 1)
	rrca
	swap a
	jr nz,+
	ld a,$f8
+
	ld l,Enemy.var30 ; Bat's x-offset relative to vire
	ld (hl),a

	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d
	jp objectCopyPosition

@substate2:
	; Wait for "bat children" to be killed
	ld e,Enemy.var34
	ld a,(de)
	or a
	jp nz,ecom_decCounter2

	; Vire defeated
	ld h,d
	ld l,Enemy.substate
	inc (hl)
	inc l
	ld (hl),60 ; [counter1]
	ld a,SNDCTRL_STOPMUSIC
	jp playSound

@substate3:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld (hl),$10 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	jp objectSetVisiblec1

@substate4:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.angle
	ld (hl),$06
	ld l,Enemy.speed
	ld (hl),SPEED_300

	ld bc,TX_2f17
	call checkIsLinkedGame
	jr z,+
	inc c ; TX_2f18
+
	jp showText

@substate5:
	call checkIsLinkedGame
	jr z,@unlinked

@linked:
	ld e,Enemy.health
	xor a
	ld (de),a
	ret

@unlinked:
	; Spawn fairy if var38 is 0.
	ld e,Enemy.var38
	ld a,(de)
	or a
	jr nz,++
	inc a
	ld (de),a
	ld b,PART_ITEM_DROP
	call ecom_spawnProjectile
++
	call enemyAnimate

	ld h,d
	ld l,Enemy.z
	ld a,(hl)
	sub <($0080)
	ldi (hl),a
	ld a,(hl)
	sbc >($0080)
	ld (hl),a

	call vire_checkOffScreen
	jp c,objectApplySpeed

	; Vire is gone; cleanup
	call markEnemyAsKilledInRoom
	call decNumEnemies
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	jp enemyDelete


vire_batForm:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw vire_batForm_state8
	.dw vire_batForm_state9
	.dw vire_batForm_stateA
	.dw vire_batForm_stateB
	.dw vire_batForm_stateC
	.dw vire_batForm_stateD


vire_batForm_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.var30
	ld a,(hl)
	and $1f
	ld l,Enemy.angle
	ld (hl),a

	ld l,Enemy.counter1
	ld (hl),$10

	ld l,Enemy.health
	ld (hl),$01

	ld a,$02
	call enemySetAnimation
	jp objectSetVisiblec1


; Moving upward after charging (or after spawning)
vire_batForm_state9:
	call ecom_decCounter1
	jr z,vire_batForm_gotoStateA

	; Move up while zh > -$10
	ld l,Enemy.zh
	ldd a,(hl)
	cp $f0
	jr c,++
	ld a,(hl)
	sub <($00c0)
	ldi (hl),a
	ld a,(hl)
	sbc >($00c0)
	ld (hl),a
++
	call objectApplySpeed
	jr vire_batForm_animate

vire_batForm_gotoStateA:
	ld l,e
	ld (hl),$0a ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.collisionType
	set 7,(hl)

	call getRandomNumber_noPreserveVars
	ld e,Enemy.counter1
	ld (de),a

	; [mainForm.counter2] = 180
	ld a,Object.counter2
	call objectGetRelatedObject1Var
	ld (hl),180
	jr vire_batForm_animate


vire_batForm_stateA:
	call vire_batForm_updateZPos

	ld a,Object.counter2
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr nz,++

.ifdef ROM_AGES
	call ecom_incState
.else
	ld h,d
	ld l,Enemy.state
	inc (hl)
.endif

	ld l,Enemy.counter1
	ld (hl),$08
	ret
++
	call vire_batForm_moveAwayFromLinkIfTooClose

	call objectGetAngleTowardEnemyTarget
	ld b,a
	ld e,Enemy.var30
	ld a,(de)
	add b
	and $1f
	ld e,Enemy.angle
	ld (de),a

	ld a,$02
	call ecom_getSideviewAdjacentWallsBitset
	call z,objectApplySpeed

vire_batForm_animate:
	jp enemyAnimate


; About to charge toward Link in [counter1] frames
vire_batForm_stateB:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_200

	ld l,Enemy.var35
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ret


; Charging toward target position in var35/var36
vire_batForm_stateC:
	ld h,d
	ld l,Enemy.var35
	call ecom_readPositionVars
	sub c
	add $08
	cp $11
	jr nc,@notReachedPosition

	ldh a,(<hFF8F)
	sub b
	add $08
	cp $11
	jr nc,@notReachedPosition

	ld l,Enemy.zh
	ld a,(hl)
	cp $fa
	jr c,@notReachedPosition

	; Reached target position

	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.counter1
	ld (hl),20
	jr vire_batForm_animate

@notReachedPosition:
	ld l,Enemy.zh
	ld a,(hl)
	cp $fe
	jr nc,+
	inc (hl)
+
	call ecom_moveTowardPosition
	jr vire_batForm_animate


; Moving back up after charging
vire_batForm_stateD:
	call ecom_decCounter1
	jp z,vire_batForm_gotoStateA

	ld l,Enemy.zh
	ldd a,(hl)
	cp $f0
	jr c,++

	ld a,(hl)
	sub <($00c0)
	ldi (hl),a
	ld a,(hl)
	sbc >($00c0)
	ld (hl),a
++
	ld a,$02
	call ecom_getSideviewAdjacentWallsBitset
	call z,objectApplySpeed
	jr vire_batForm_animate


;;
; Sets Vire's position to just outside the camera (along with corresponding angle), and
; increments substate.
;
; @param[out]	hl	Enemy.substate
vire_spawnOutsideCamera:
	call getRandomNumber_noPreserveVars
	and $07
	ld b,a
	add a
	add b
	ld hl,@spawnPositions
	rst_addAToHl

	ld e,Enemy.yh
	ldh a,(<hCameraY)
	add (hl)
	ld (de),a
	inc hl
	ld e,Enemy.xh
	ldh a,(<hCameraX)
	add (hl)
	ld (de),a

	inc hl
	ld e,Enemy.angle
	ld a,(hl)
	ld (de),a

	ld h,d
	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.substate
	inc (hl)
	jp objectSetVisiblec1

; Data format:
;   b0: y (relative to hCameraY)
;   b1: x (relative to hCameraX)
;   b2: angle
@spawnPositions:
	.db $f8 $10 $10
	.db $f8 $90 $10
	.db $10 $f8 $08
	.db $10 $a8 $18
	.db $70 $f8 $08
	.db $70 $a8 $18
	.db $88 $10 $00
	.db $88 $90 $00

;;
; Vire has left the screen; set state to 9, where he'll wait for 90 frames before
; attacking again.
vire_mainForm_leftScreen:
	ld h,d
	ld l,Enemy.state
	ld (hl),$09
	inc l
	ld (hl),$00 ; [substate]
	inc l
	ld (hl),90 ; [counter1]

	ld l,Enemy.collisionType
	res 7,(hl)
	jp objectSetInvisible

;;
; @param[out]	cflag	c if left screen
vire_checkOffScreen:
	ld e,Enemy.yh
	ld a,(de)
	cp (LARGE_ROOM_HEIGHT<<4)+8
	ret nc
	ld e,Enemy.xh
	ld a,(de)
	cp (LARGE_ROOM_WIDTH<<4)
	ret


;;
vire_mainForm_circleAroundScreen:
	ldh a,(<hCameraY)
	add (SCREEN_HEIGHT<<3)+4
	ld b,a
	ldh a,(<hCameraX)
	add SCREEN_WIDTH<<3
	ld c,a
	push bc
	call objectGetRelativeAngle
	pop bc

	ld h,a
	ld e,Enemy.yh
	ld a,(de)
	sub b
	jr nc,+
	cpl
	inc a
+
	ld b,a
	cp $3e
	ld a,h
	jr nc,@setAngleAndSpeed

	ld e,Enemy.xh
	ld a,(de)
	sub c
	jr nc,+
	cpl
	inc a
+
	ld c,a
	cp $3e
	ld a,h
	jr nc,@setAngleAndSpeed

	ld a,b
	add c
	sub $42
	cp $08
	jr c,@offsetAngle

	rlca
	ld a,h
	jr nc,@setAngleAndSpeed

	xor $10

@setAngleAndSpeed:
	push hl
	ld e,Enemy.angle
	ld (de),a
	ld e,Enemy.speed
	ld a,SPEED_40
	ld (de),a
	call objectApplySpeed
	pop hl

@offsetAngle:
	ld e,Enemy.var30
	ld a,(de)
	add h
	and $1f
	ld e,Enemy.angle
	ld (de),a

	ld e,Enemy.speed
	ld a,SPEED_e0
	ld (de),a


;;
vire_mainForm_applySpeedAndAnimate:
	call objectApplySpeed
	jp enemyAnimate

;;
; @param[out]	cflag	c if Link is too close (Vire will flee)
vire_mainForm_checkLinkTooClose:
	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	add 30
	cp 61
	ret nc
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add 30
	cp 61
	ret


;;
vire_mainForm_fireProjectile:
	call getRandomNumber_noPreserveVars
	and $01
	inc a
	ld b,a

;;
; @param	b	Subid
vire_mainForm_fireProjectileWithSubid:
	call getFreePartSlot
	ret nz
	ld (hl),PART_VIRE_PROJECTILE
	inc l
	ld (hl),b ; [subid]

	ld l,Part.relatedObj1+1
	ld (hl),d
	dec l
	ld (hl),Enemy.start

	call objectCopyPosition
	ld a,SND_SPLASH
	call playSound

	ld e,Enemy.direction
	ld a,$01
	ld (de),a
	jp enemySetAnimation

;;
vire_batForm_moveAwayFromLinkIfTooClose:
	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	add 12
	cp 25
	ret nc
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add 12
	cp 25
	ret nc

	call objectGetAngleTowardEnemyTarget
	xor $10
	ld c,a
	ld b,SPEED_200
	jp ecom_applyGivenVelocity


;;
vire_batForm_updateZPos:
	call ecom_decCounter1
	ld a,(hl)
	and $1c
	rrca
	rrca
	ld hl,@zVals
	rst_addAToHl
	ld e,Enemy.zh
	ld a,(hl)
	ld (de),a
	ret

@zVals:
	.db $f0 $f1 $f0 $ef $ee $ed $ee $ef
