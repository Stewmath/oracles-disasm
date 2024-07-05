; ==================================================================================================
; ENEMY_EYESOAR_CHILD
;
; Variables:
;   relatedObj1: Pointer to ENEMY_EYESOAR
;   relatedObj2: Pointer to INTERAC_0b?
;   var30: Distance away from Eyesoar (position in "circle arc")
;   var31: "Target" distance away from Eyesoar (var30 is moving toward this value)
;   var32: Angle offset for this child (each subid is a quarter circle apart)
;
; See also ENEMY_EYESOAR variables.
; ==================================================================================================
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
	; Note: b == parent (ENEMY_EYESOAR), which is used in some of the states below.
	ld a,(de)
	rst_jumpTable
	.dw eyesoarChild_state_uninitialized
	.dw eyesoarChild_state_stub
	.dw eyesoarChild_state_stub
	.dw eyesoarChild_state_stub
	.dw eyesoarChild_state_stub
	.dw eyesoarChild_state_stub
	.dw eyesoarChild_state_stub
	.dw eyesoarChild_state_stub
	.dw eyesoarChild_state8
	.dw eyesoarChild_state9
	.dw eyesoarChild_stateA
	.dw eyesoarChild_stateB
	.dw eyesoarChild_stateC
	.dw eyesoarChild_stateD
	.dw eyesoarChild_stateE
	.dw eyesoarChild_stateF
	.dw eyesoarChild_state10


eyesoarChild_state_uninitialized:
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
	jp ecom_setSpeedAndState8

@initialAnglesForSubids:
	.db ANGLE_UP, ANGLE_RIGHT, ANGLE_DOWN, ANGLE_LEFT



eyesoarChild_state_stub:
	ret


; Wait for [counter1] frames before becoming visible
eyesoarChild_state8:
	call ecom_decCounter1
	ret nz
	ldbc INTERAC_0b,$02
	call objectCreateInteraction
	ret nz
	ld e,Enemy.relatedObj2
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	jp ecom_incState


eyesoarChild_state9:
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z

	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$f0
	ld l,Enemy.zh
	ld (hl),$fe
	ld l,Enemy.var30
	ld (hl),$18
	jp objectSetVisiblec2


; Moving around Eyesoar in a circle
eyesoarChild_stateA:
	ld h,b
	ld l,Enemy.var39
	bit 2,(hl)
	jr z,eyesoarChild_updatePosition

	ld l,Enemy.var38
	ld a,(hl)
	and $f8
	ld e,Enemy.var31
	ld (de),a
	ld e,Enemy.state
	ld a,$0b
	ld (de),a

;;
eyesoarChild_updatePosition:
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


eyesoarChild_stateB:
	; Check if we're the correct distance away
	ld h,d
	ld l,Enemy.var31
	ldd a,(hl)
	cp (hl) ; [var30]
	jr nz,eyesoarChild_incOrDecHL

	ld l,e
	dec (hl) ; [state]

	; Mark flag in parent indicating we're in position
	ld h,b
	ld l,Enemy.var3a
	ld e,Enemy.subid
	ld a,(de)
	call setFlag
	jr eyesoarChild_updatePosition


eyesoarChild_incOrDecHL:
	ld a,$01
	jr nc,+
	ld a,$ff
+
	add (hl)
	ld (hl),a
	ld h,b
	jr eyesoarChild_updatePosition


; Was just "killed"; waiting a bit before reappearing
eyesoarChild_stateC:
	ld h,b
	ld l,Enemy.var39
	bit 0,(hl)
	jr nz,@stillInvisible
	call ecom_decCounter1
	jr nz,@stillInvisible

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)
	call objectSetVisiblec2
	ld h,b
	jr eyesoarChild_updatePosition

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
eyesoarChild_stateD:
	; Update position relative to eyesoar
	ld h,b
	ld l,Enemy.var38
	ld a,(hl)
	and $f8
	ld h,d
	ld l,Enemy.var30
	cp (hl)
	jr nz,eyesoarChild_incOrDecHL

	; Reached desired position, go back to state $0a
	ld l,Enemy.state
	ld (hl),$0a

	ld h,b
	jp eyesoarChild_updatePosition


eyesoarChild_stateE:
	ld h,b
	ld l,Enemy.var39
	bit 4,(hl)
	jp nz,eyesoarChild_updatePosition

	ld a,$0b
	ld (de),a ; [state]
	jp eyesoarChild_updatePosition


; Moving around randomly
eyesoarChild_stateF:
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

	call ecom_incState

	; $18 units away from Eyesoar
	ld l,Enemy.var30
	ld (hl),$18

	jr eyesoarChild_animate

@stillMovingRandomly:
	ld a,(wFrameCounter)
	and $0f
	jr nz,+
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
+
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary

eyesoarChild_animate:
	jp enemyAnimate


; Moving back toward Eyesoar
eyesoarChild_state10:
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
	call ecom_moveTowardPosition
	jr eyesoarChild_animate

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
