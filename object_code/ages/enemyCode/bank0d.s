; ==============================================================================
; ENEMYID_VERAN_SPIDER
; ==============================================================================
enemyCode0f:
	ld b,a

	; Kill spiders when a cutscene trigger occurs
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	or a
	ld a,b
	jr z,+
	ld a,ENEMYSTATUS_NO_HEALTH
+
	or a
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,_ecom_updateKnockback
	ret

@normalStatus:
	call _ecom_checkScentSeedActive
	jr z,++
	ld e,Enemy.speed
	ld a,SPEED_140
	ld (de),a
++
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw _veranSpider_state_uninitialized
	.dw _veranSpider_state_stub
	.dw _veranSpider_state_stub
	.dw _veranSpider_state_switchHook
	.dw _veranSpider_state_scentSeed
	.dw _ecom_blownByGaleSeedState
	.dw _veranSpider_state_stub
	.dw _veranSpider_state_stub
	.dw _veranSpider_state8
	.dw _veranSpider_state9
	.dw _veranSpider_stateA


_veranSpider_state_uninitialized:
	ld a,PALH_8a
	call loadPaletteHeader

	; Choose a random position roughly within the current screen bounds to spawn the
	; spider at. This prevents the spider from spawning off-screen. But, the width is
	; only checked properly in the last row; if this were spawned in a small room, the
	; spiders could spawn off-screen. (Large rooms aren't a problem since there is no
	; off-screen area to the right, aside from one column, which is marked as solid.)
--
	call getRandomNumber
	and $7f
	cp $70 + SCREEN_WIDTH
	jr nc,--

	ld c,a
	call objectSetShortPosition

	; Adjust position to be relative to screen bounds
	ldh a,(<hCameraX)
	add (hl)
	ldd (hl),a
	ld c,a

	dec l
	ldh a,(<hCameraY)
	add (hl)
	ld (hl),a
	ld b,a

	; If solid at this position, try again next frame.
	call getTileCollisionsAtPosition
	ret nz

	ld c,$08
	call _ecom_setZAboveScreen
	ld a,SPEED_60
	call _ecom_setSpeedAndState8

	ld l,Enemy.collisionType
	set 7,(hl)

	ld a,SND_FALLINHOLE
	call playSound
	jp objectSetVisiblec1


_veranSpider_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw _ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret

@substate3:
	ld b,$09
	jp _ecom_fallToGroundAndSetState


_veranSpider_state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jr z,_veranSpider_gotoState9

	call _ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	and $18
	add $04
	ld (de),a
	call _ecom_applyVelocityForSideviewEnemyNoHoles


;;
_veranSpider_updateAnimation:
	ld h,d
	ld l,Enemy.animCounter
	ld a,(hl)
	sub $03
	jr nc,+
	xor a
+
	inc a
	ld (hl),a
	jp enemyAnimate

;;
_veranSpider_gotoState9:
	ld h,d
	ld l,Enemy.state
	ld (hl),$09
	ld l,Enemy.speed
	ld (hl),SPEED_60
	ret


_veranSpider_state_stub:
	ret


; Falling from sky
_veranSpider_state8:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	ret nz

	; Landed on ground
	ld l,Enemy.speedZ
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.state
	inc (hl)

	; Enable scent seeds
	ld l,Enemy.var3f
	set 4,(hl)

	call objectSetVisiblec2
	ld a,SND_BOMB_LAND
	call playSound

	call _veranSpider_setRandomAngleAndCounter1
	jr _veranSpider_animate


; Moving in some direction for [counter1] frames
_veranSpider_state9:
	; Check if Link is along a diagonal relative to self?
	call objectGetAngleTowardEnemyTarget
	and $07
	sub $04
	inc a
	cp $03
	jr nc,@moveNormally

	; He is on a diagonal; if counter2 is zero, go to state $0a (charge at Link).
	ld e,Enemy.counter2
	ld a,(de)
	or a
	jr nz,@moveNormally

	call _ecom_updateAngleTowardTarget
	and $18
	add $04
	ld (de),a

	call _ecom_incState
	ld l,Enemy.speed
	ld (hl),SPEED_140
	ld l,Enemy.counter1
	ld (hl),120
	ret

@moveNormally:
	call _ecom_decCounter2
	dec l
	dec (hl) ; [counter1]--
	call nz,_ecom_applyVelocityForSideviewEnemyNoHoles
	jp z,_veranSpider_setRandomAngleAndCounter1

_veranSpider_animate:
	jp enemyAnimate


; Charging in some direction for [counter1] frames
_veranSpider_stateA:
	call _ecom_decCounter1
	jr z,++
	call _ecom_applyVelocityForSideviewEnemyNoHoles
	jp nz,_veranSpider_updateAnimation
++
	call _veranSpider_gotoState9
	ld l,Enemy.counter2
	ld (hl),$40


;;
_veranSpider_setRandomAngleAndCounter1:
	ld bc,$1870
	call _ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,b
	add $04
	ld (de),a
	ld e,Enemy.counter1
	ld a,c
	add $70
	ld (de),a
	ret


; ==============================================================================
; ENEMYID_EYESOAR_CHILD
;
; Variables:
;   relatedObj1: Pointer to ENEMYID_EYESOAR
;   relatedObj2: Pointer to INTERACID_0b?
;   var30: Distance away from Eyesoar (position in "circle arc")
;   var31: "Target" distance away from Eyesoar (var30 is moving toward this value)
;   var32: Angle offset for this child (each subid is a quarter circle apart)
;
; See also ENEMYID_EYESOAR variables.
; ==============================================================================
enemyCode11:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus

	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,enemyDie_uncounted

	call objectCreatePuff
	ld h,d
	ld l,Enemy.state
	ld (hl),$0c

	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.var30
	ld (hl),$00

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.health
	ld (hl),$04
	call objectSetInvisible

@normalStatus:
	ld a,Object.var39
	call objectGetRelatedObject1Var
	bit 1,(hl)
	ld b,h

	ld e,Enemy.state
	jr z,@runState
	ld a,(de)
	cp $0f
	jr nc,@runState
	cp $0c
	ld h,d
	jr z,++

	ld l,e
	ld (hl),$0f ; [state]
	ld l,Enemy.counter1
	ld (hl),$f0
++
	ld l,Enemy.var31
	ld (hl),$18

@runState:
	; Note: b == parent (ENEMYID_EYESOAR), which is used in some of the states below.
	ld a,(de)
	rst_jumpTable
	.dw _eyesoarChild_state_uninitialized
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state8
	.dw _eyesoarChild_state9
	.dw _eyesoarChild_stateA
	.dw _eyesoarChild_stateB
	.dw _eyesoarChild_stateC
	.dw _eyesoarChild_stateD
	.dw _eyesoarChild_stateE
	.dw _eyesoarChild_stateF
	.dw _eyesoarChild_state10


_eyesoarChild_state_uninitialized:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)

	ld e,Enemy.subid
	ld a,(de)
	ld hl,@initialAnglesForSubids
	rst_addAToHl

	ld e,Enemy.angle
	ld a,(hl)
	ld (de),a
	ld e,Enemy.var32
	ld (de),a
	ld a,$18
	call objectSetPositionInCircleArc

	ld e,Enemy.counter1
	ld a,90
	ld (de),a
	ld a,SPEED_100
	jp _ecom_setSpeedAndState8

@initialAnglesForSubids:
	.db ANGLE_UP, ANGLE_RIGHT, ANGLE_DOWN, ANGLE_LEFT



_eyesoarChild_state_stub:
	ret


; Wait for [counter1] frames before becoming visible
_eyesoarChild_state8:
	call _ecom_decCounter1
	ret nz
	ldbc INTERACID_0b,$02
	call objectCreateInteraction
	ret nz
	ld e,Enemy.relatedObj2
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	jp _ecom_incState


_eyesoarChild_state9:
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z

	call _ecom_incState
	ld l,Enemy.counter1
	ld (hl),$f0
	ld l,Enemy.zh
	ld (hl),$fe
	ld l,Enemy.var30
	ld (hl),$18
	jp objectSetVisiblec2


; Moving around Eyesoar in a circle
_eyesoarChild_stateA:
	ld h,b
	ld l,Enemy.var39
	bit 2,(hl)
	jr z,_eyesoarChild_updatePosition

	ld l,Enemy.var38
	ld a,(hl)
	and $f8
	ld e,Enemy.var31
	ld (de),a
	ld e,Enemy.state
	ld a,$0b
	ld (de),a

;;
_eyesoarChild_updatePosition:
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)

	; [this.var32] += [parent.var3b] (update angle by rotation speed)
	ld l,Enemy.var3b
	ld e,Enemy.var32
	ld a,(de)
	add (hl)
	and $1f
	ld e,Enemy.angle
	ld (de),a

	ld h,d
	ld l,Enemy.var30
	ld a,(hl)
	call objectSetPositionInCircleArc
	jp enemyAnimate


_eyesoarChild_stateB:
	; Check if we're the correct distance away
	ld h,d
	ld l,Enemy.var31
	ldd a,(hl)
	cp (hl) ; [var30]
	jr nz,_eyesoarChild_incOrDecHL

	ld l,e
	dec (hl) ; [state]

	; Mark flag in parent indicating we're in position
	ld h,b
	ld l,Enemy.var3a
	ld e,Enemy.subid
	ld a,(de)
	call setFlag
	jr _eyesoarChild_updatePosition


_eyesoarChild_incOrDecHL:
	ld a,$01
	jr nc,+
	ld a,$ff
+
	add (hl)
	ld (hl),a
	ld h,b
	jr _eyesoarChild_updatePosition


; Was just "killed"; waiting a bit before reappearing
_eyesoarChild_stateC:
	ld h,b
	ld l,Enemy.var39
	bit 0,(hl)
	jr nz,@stillInvisible
	call _ecom_decCounter1
	jr nz,@stillInvisible

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)
	call objectSetVisiblec2
	ld h,b
	jr _eyesoarChild_updatePosition

@stillInvisible:
	ld h,b
	ld e,Enemy.subid
	ld a,(de)
	ld bc,@data
	call addAToBc
	ld a,(bc)
	ld l,Enemy.var3a
	or (hl)
	ld (hl),a
	ret

@data:
	.db $11 $22 $44 $88


; Just reappeared
_eyesoarChild_stateD:
	; Update position relative to eyesoar
	ld h,b
	ld l,Enemy.var38
	ld a,(hl)
	and $f8
	ld h,d
	ld l,Enemy.var30
	cp (hl)
	jr nz,_eyesoarChild_incOrDecHL

	; Reached desired position, go back to state $0a
	ld l,Enemy.state
	ld (hl),$0a

	ld h,b
	jp _eyesoarChild_updatePosition


_eyesoarChild_stateE:
	ld h,b
	ld l,Enemy.var39
	bit 4,(hl)
	jp nz,_eyesoarChild_updatePosition

	ld a,$0b
	ld (de),a ; [state]
	jp _eyesoarChild_updatePosition


; Moving around randomly
_eyesoarChild_stateF:
	ld h,b
	ld l,Enemy.var39
	bit 3,(hl)
	jr nz,@stillMovingRandomly

	; Calculate the angle relative to Eyesoar it should move to
	ld l,Enemy.var3b
	ld e,Enemy.var32
	ld a,(de)
	add (hl)
	and $1f
	ld e,Enemy.angle
	ld (de),a

	call _ecom_incState

	; $18 units away from Eyesoar
	ld l,Enemy.var30
	ld (hl),$18

	jr _eyesoarChild_animate

@stillMovingRandomly:
	ld a,(wFrameCounter)
	and $0f
	jr nz,+
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
+
	call objectApplySpeed
	call _ecom_bounceOffScreenBoundary

_eyesoarChild_animate:
	jp enemyAnimate


; Moving back toward Eyesoar
_eyesoarChild_state10:
	; Load into wTmpcec0 the position offset relative to Eyesoar where we should be
	; moving to
	ld h,b
	ld l,Enemy.var3b
	ld a,(hl)
	ld e,Enemy.var32
	ld a,(de)
	add (hl)
	and $1f
	ld c,a
	ld a,$18
	ld b,SPEED_100
	call getScaledPositionOffsetForVelocity

	; Get parent.position + offset in bc
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld a,(wTmpcec0+1)
	add (hl)
	ld b,a
	ld l,Enemy.xh
	ld a,(wTmpcec0+3)
	add (hl)
	ld c,a

	; Store current position
	ld e,l
	ld a,(de)
	ldh (<hFF8E),a
	ld e,Enemy.yh
	ld a,(de)
	ldh (<hFF8F),a

	; Check if we've reached the target position
	cp b
	jr nz,++
	ldh a,(<hFF8E)
	cp c
	jr z,@reachedTargetPosition
++
	call _ecom_moveTowardPosition
	jr _eyesoarChild_animate

@reachedTargetPosition:
	; Wait for signal to change state
	ld l,Enemy.var39
	bit 1,(hl)
	ret nz

	ld e,Enemy.state
	ld a,$0e
	ld (de),a

	; Set flag in parent's var3a indicating we're good to go?
	ld e,Enemy.subid
	ld a,(de)
	add $04
	ld l,Enemy.var3a
	jp setFlag


.include "object_code/common/enemyCode/ironMask.s"


; ==============================================================================
; ENEMYID_VERAN_CHILD_BEE
; ==============================================================================
enemyCode1f:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,_ecom_updateKnockbackNoSolidity
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw _ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA


@state_uninitialized:
	ld a,SPEED_200
	call _ecom_setSpeedAndState8
	ld l,Enemy.counter1
	ld (hl),$10

	ld e,Enemy.subid
	ld a,(de)
	ld hl,@angleVals
	rst_addAToHl
	ld e,Enemy.angle
	ld a,(hl)
	ld (de),a
	jp objectSetVisible83

@angleVals:
	.db $10 $16 $0a


@state_stub:
	ret


@state8:
	call _ecom_decCounter1
	jr z,++
	call objectApplySpeed
	jr @animate
++
	ld (hl),$0c ; [counter1]
	ld l,e
	inc (hl) ; [state]
@animate:
	jp enemyAnimate


@state9:
	call _ecom_decCounter1
	jr nz,@animate
	ld l,e
	inc (hl) ; [state]
	call _ecom_updateAngleTowardTarget


@stateA:
	call objectApplySpeed
	call objectCheckWithinRoomBoundary
	jr c,@animate
	call decNumEnemies
	jp enemyDelete


; ==============================================================================
; ENEMYID_ANGLER_FISH_BUBBLE
; ==============================================================================
enemyCode26:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	call @popBubble

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	; Can bounce off walls 5 times before popping
	ld l,Enemy.counter1
	ld (hl),$05

	ld l,Enemy.speed
	ld (hl),SPEED_100

	ld a,Object.direction
	call objectGetRelatedObject1Var
	bit 0,(hl)
	ld c,$f4
	jr z,+
	ld c,$0c
+
	ld b,$00
	call objectTakePositionWithOffset
	call _ecom_updateAngleTowardTarget
	jp objectSetVisible81


; Bubble moving around
@state1:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMYID_ANGLER_FISH
	jr nz,@popBubble

	call objectApplySpeed
	call _ecom_bounceOffWallsAndHoles
	jr z,@animate

	; Each time it bounces off a wall, decrement counter1
	call _ecom_decCounter1
	jr z,@popBubble

@animate:
	jp enemyAnimate

@popBubble:
	ld h,d
	ld l,Enemy.state
	ld (hl),$02

	ld l,Enemy.counter1
	ld (hl),$08

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.knockbackCounter
	ld (hl),$00

	; 1 in 4 chance of item drop
	call getRandomNumber_noPreserveVars
	cp $40
	jr nc,++

	call getFreePartSlot
	jr nz,++
	ld (hl),PARTID_ITEM_DROP
	inc l
	ld (hl),ITEM_DROP_SCENT_SEEDS

	ld l,Part.invincibilityCounter
	ld (hl),$f0
	call objectCopyPosition
++
	; Bubble pop animation
	ld a,$01
	call enemySetAnimation
	jp objectSetVisible83


; Bubble in the process of popping
@state2:
	call _ecom_decCounter1
	jr nz,@animate
	jp enemyDelete


; ==============================================================================
; ENEMYID_ENABLE_SIDESCROLL_DOWN_TRANSITION
; ==============================================================================
enemyCode2b:
	ld e,Enemy.state
	ld a,(de)
	or a
	jp z,_ecom_incState

	ld hl,w1Link.xh
	ld a,(hl)
	cp $d0
	ret c

	ld l,<w1Link.yh
	ld a,(hl)
	ld l,<w1Link.speedZ+1
	add (hl)
	cp LARGE_ROOM_HEIGHT<<4 - 8
	ret c

	ld a,$80|DIR_DOWN
	ld (wScreenTransitionDirection),a
	ret
