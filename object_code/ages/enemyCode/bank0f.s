; ==============================================================================
; ENEMYID_GIANT_GHINI
;
; Variables:
;   var30: Number of children alive
;   var32: Nonzero to begin charging at Link (written to by ENEMYID_GIANT_GHINI_CHILD)
;   var33: Counter for Z-axis movement (reverses direction every 16 frames)
;   var34: The current "vertical half" of the screen it's moving toward
;   var35: Position the ghini is currently charging toward
; ==============================================================================
enemyCode70:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus
	jp _enemyBoss_dead

@normalStatus:
	call _giantGhini_updateZPos
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw _giantGhini_state_uninitialized
	.dw _giantGhini_state_stub
	.dw _giantGhini_state_stub
	.dw _giantGhini_state_stub
	.dw _giantGhini_state_stub
	.dw _giantGhini_state_stub
	.dw _giantGhini_state_stub
	.dw _giantGhini_state_stub
	.dw _giantGhini_state8
	.dw _giantGhini_state9
	.dw _giantGhini_stateA


_giantGhini_state_uninitialized:
	ld a,ENEMYID_GIANT_GHINI
	ld b,$00
	call _enemyBoss_initializeRoom
	call _ecom_setSpeedAndState8

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
	jp _giantGhini_spawnChildren


_giantGhini_state_stub:
	ret


; The ghini is spawning in before the fight starts
_giantGhini_state8:
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

	jp _ecom_incSubstate

@substate1:
	call _ecom_decCounter1
	ret nz

	ld (hl),60

	ld l,Enemy.subid
	res 7,(hl)

	ld b,$01
	ld c,$0c
	call _enemyBoss_spawnShadow
	jp _ecom_incSubstate

@substate2:
	; Flicker visibility
	ld e,Enemy.visible
	ld a,(de)
	xor $80
	ld (de),a

	call _ecom_decCounter1
	ret nz

	; Finally begin the fight
	call _enemyBoss_beginMiniboss
	call objectSetVisible80

_giantGhini_gotoState9:
	xor a
	call enemySetAnimation

	call _giantGhini_getTargetAngle
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

_giantGhini_setChildRespawnTimer:
	call getRandomNumber
	and $03
	ld c,60
	call multiplyAByC
	ld e,Enemy.counter2
	ld a,l
	ld (de),a
	ret


; "Normal" state during battle
_giantGhini_state9:
	ld e,Enemy.var32
	ld a,(de)
	or a
	jr nz,@beginCharge

	call enemyAnimate
	call objectApplySpeed

	; Nudge angle toward target every other frame
	call _ecom_decCounter1
	jr nz,++
	ld (hl),$02
	call _giantGhini_getTargetAngle
	call objectNudgeAngleTowards
++
	call _ecom_decCounter2
	ret nz

	call _giantGhini_setChildRespawnTimer
	ld e,Enemy.var30
	ld a,(de)
	or a
	ret nz
	call getRandomNumber
	and $03
	jp nz,_giantGhini_spawnChildren

@beginCharge:
	ld a,$01
	call enemySetAnimation
	call _ecom_incState

	ld l,Enemy.counter2
	ld (hl),150
	ld l,Enemy.speed
	ld (hl),SPEED_20

_giantGhini_updateChargeTargetPosition:
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
_giantGhini_stateA:
	call enemyAnimate

	; Increase speed every 4 frames
	call _ecom_decCounter2
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
	call nz,_giantGhini_updateChargeTargetPosition

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
	jp z,_giantGhini_gotoState9
	ret


;;
_giantGhini_updateZPos:
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
_giantGhini_spawnChildren:
	ld c,$03
@nextChild:
	ld b,ENEMYID_GIANT_GHINI_CHILD
	call _ecom_spawnEnemyWithSubid01
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
_giantGhini_getTargetAngle:
	ldh a,(<hCameraY)
	ld c,a
	ld a,(w1Link.yh)
	sub c
	ld b,(SCREEN_HEIGHT/4)<<4 + 8
	cp (SCREEN_HEIGHT/2)<<4 + 8
	jr nc,+
	ld b,(SCREEN_HEIGHT*3/4)<<4 + 8
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
	jr _giantGhini_getTargetAngle
++
	ld a,c
	add b
	ld b,a
	ldh a,(<hCameraX)
	add (SCREEN_WIDTH/2)<<4
	ld c,a
	jp objectGetRelativeAngle


; ==============================================================================
; ENEMYID_SWOOP
;
; Variables:
;   var30: Number of frames before swoop begins to stomp
;   var31: Target stomp position (short-form)
;   var32/var33: Target stomp position (long-form)
; ==============================================================================
enemyCode71:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp nz,@normalStatus
	jp _enemyBoss_dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw _swoop_state_uninitialized
	.dw _swoop_state_stub
	.dw _swoop_state_stub
	.dw _swoop_state_stub
	.dw _swoop_state_stub
	.dw _swoop_state_stub
	.dw _swoop_state_stub
	.dw _swoop_state_stub
	.dw _swoop_state8
	.dw _swoop_state9
	.dw _swoop_stateA
	.dw _swoop_stateB


_swoop_state_uninitialized:
	ld a,ENEMYID_SWOOP
	ld b,$00
	call _enemyBoss_initializeRoom
	call _ecom_setSpeedAndState8
	ld b,$01
	ld c,$08
	jp _enemyBoss_spawnShadow


_swoop_state_stub:
	ret


; Spawning in before the fight starts
_swoop_state8:
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

	call _ecom_incSubstate
	ld c,$08
	call _ecom_setZAboveScreen

	ld e,Enemy.counter1
	ld a,60
	ld (de),a

	inc e
	ld a,$02
	ld (de),a ; [counter2]

	call objectSetVisible82
	ld a,$02
	jp enemySetAnimation

; Falling to ground
@substate1:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	ld e,Enemy.counter2
	ld a,(de)
	or a
	jr z,@doneBouncing

	dec a
	ld (de),a
	jr nz,++

	ld a,$00
	call enemySetAnimation
	jr @doneBouncing
++
	ld bc,-$180
	call objectSetSpeedZ
	ld a,$0a
	call setScreenShakeCounter
	ld a,SND_DOORCLOSE
	jp playSound

@doneBouncing:
	call _ecom_decCounter1
	ret nz
	ld bc,TX_2f00
	call showText
	jp _ecom_incSubstate

@substate2:
	call retIfTextIsActive
	call _enemyBoss_beginMiniboss
	call _ecom_incSubstate
	jp _swoop_beginFlyingUp

@substate3:
	call _swoop_state9

	ld e,Enemy.state
	ld a,(de)
	cp $0a
	ret nz

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ret


; Flying upward
_swoop_state9:
	call _swoop_animate

	; Set Z-speed if just flapped wings
	ld a,(de)
	or a
	ld bc,-$100
	call nz,objectSetSpeedZ

	ld c,$08
	call objectUpdateSpeedZ_paramC
	call _ecom_decCounter2
	ret nz

	call _ecom_decCounter1
	jp nz,_swoop_flyFurtherUp

	ld (hl),60 ; [counter1]

	ld a,$0a
	ld l,Enemy.state
	ldi (hl),a
	ld (hl),$00 ; [substate]

	call _swoop_getAngerLevel
	ld hl,_swoop_framesBeforeAttacking
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.var30
	ld (de),a

	call objectGetAngleTowardLink
	ld e,Enemy.angle
	ld (de),a

	ld a,$00
	jp enemySetAnimation


; Flying around, getting closer to Link before stomping
_swoop_stateA:
	call _swoop_animate
	call _swoop_getAngerLevel

	ld hl,_swoop_speedVals
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.speed
	ld (de),a

	ld e,Enemy.var30
	ld a,(de)
	or a
	jr z,++
	dec a
	ld (de),a
	jr nz,@updatePosition
++
	ld c,$30
	call objectCheckLinkWithinDistance
	jr nc,@updatePosition

	call _ecom_incState
	inc l
	ld (hl),$00 ; [substate]
	ld l,Enemy.counter1
	ld (hl),30
	ret

@updatePosition:
	call _ecom_decCounter1
	jr nz,++
	call objectGetAngleTowardLink
	ld e,Enemy.angle
	ld (de),a
	ld e,Enemy.counter1
	ld a,60
	ld (de),a
++
	jp _ecom_applyVelocityForSideviewEnemy


; Stomping
_swoop_stateB:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw _swoop_stomp_substate2
	.dw _swoop_stomp_substate3

; Flapping wings quickly, telegraphing stomp is about to begin
@substate0:
	call _swoop_animate
	call _swoop_animate
	call _ecom_decCounter1
	jr z,@beginStomp

	ld a,(hl) ; [counter1]
	cp $0a
	ret nz

	; Decide on target position to stomp at, store in var31
	ld hl,w1Link.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl) ; [w1Link.xh]
	call getTileAtPosition
	ld a,l
	ld e,Enemy.var31
	ld (de),a

	; Convert to long-form, store in var32/var33
	call convertShortToLongPosition
	ld e,Enemy.var32
	ld a,b
	and $f0
	ld (de),a
	inc e
	ld a,c
	ld (de),a

	; Get angle toward stomp position
	ld e,Enemy.yh
	call objectGetRelativeAngle
	ld e,Enemy.angle
	ld (de),a
	ret

@beginStomp:
	call _ecom_incSubstate
	ld l,Enemy.speed
	ld (hl),SPEED_200

	ld l,Enemy.collisionType
	set 7,(hl)

	ld bc,$0000
	call objectSetSpeedZ
	ld a,$02
	jp enemySetAnimation

; Moving toward stomp position while falling to ground
@substate1:
	; Get target stomp position
	ld h,d
	ld l,Enemy.var32
	ldi a,(hl)
	ld c,(hl)
	ld b,a

	; Compare with current position
	ld e,Enemy.yh
	ld l,e
	ldi a,(hl)
	and $fe
	cp b
	jr nz,++
	inc l
	ld a,(hl)
	and $fe
	cp c
	jr z,+++
++
	; Must still move toward target position
	call objectGetRelativeAngle
	ld e,Enemy.angle
	ld (de),a
	call _ecom_applyVelocityForSideviewEnemy
+++
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	; Hit the ground.
	call _swoop_hitGround
	call _ecom_incSubstate
	ld e,Enemy.health
	ld a,(de)
	cp $0a
	jr nc,_swoop_setVisible

	; Health is low; will bounce either 2 or 3 times.
	inc (hl) ; [substate] = 3

	; [counter1] = number of bounces
	call getRandomNumber
	and $01
	inc a
	ld l,Enemy.counter1
	ld (hl),a

	ld l,Enemy.speed
	ld (hl),SPEED_100

	call objectGetAngleTowardLink
	ld e,Enemy.angle
	ld (de),a

_swoop_setSpeedZForBounce:
	ld bc,-$100
	jp objectSetSpeedZ

_swoop_setVisible:
	jp objectSetVisible82


; Completed stomp, about to fly back up.
_swoop_stomp_substate2:
	call _swoop_animate

	; Wait until animation signals to fly up again, or Link attacks
	ld e,Enemy.invincibilityCounter
	ld a,(de)
	and $7f
	jr nz,@flyBackUp

	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z

@flyBackUp:
	ld bc,$0000
	call objectSetSpeedZ

	ld l,Enemy.state
	ld a,$09
	ldi (hl),a
	ld (hl),$00 ; [substate]

	ld l,Enemy.collisionType
	res 7,(hl)

;;
_swoop_beginFlyingUp:
	ld l,Enemy.counter1
	ld (hl),$03 ; 3 flaps before he goes to next state

;;
_swoop_flyFurtherUp:
	ld l,Enemy.counter2
	ld (hl),$30 ; $30 frames per wing flap
	call objectSetVisible80
	ld a,$03
	jp enemySetAnimation


; Bouncing
_swoop_stomp_substate3:
	call _ecom_applyVelocityForSideviewEnemy
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	call _swoop_hitGround
	call _ecom_decCounter1
	jr nz,_swoop_setSpeedZForBounce

	ld l,Enemy.substate
	dec (hl)
	jp objectSetVisible82


;;
; @param[out]	a	Value from 0-2
_swoop_getAngerLevel:
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
_swoop_hitGround:
	ld a,$30
	call setScreenShakeCounter
	ld a,SND_DOORCLOSE
	call playSound

	; Replace tile at this position if it's of the appropriate type, and not solid.
	ld bc,$0500
	call objectGetRelativeTile
	ld c,l
	ld h,>wRoomCollisions
	ld a,(hl)
	cp $0f
	ret z

	ld h,>wRoomLayout
	ld a,(hl)
	cp $a2
	ret z
	cp $48
	ret z

	ld a,$48
	call setTile

	ld b,INTERACID_ROCKDEBRIS
	jp objectCreateInteractionWithSubid00


;;
; @param[out]	de	animParameter (if nonzero, just flapped wings)
_swoop_animate:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z
	ld a,SND_JUMP
	jp playSound

_swoop_speedVals:
	.db SPEED_80, SPEED_100, SPEED_180

_swoop_framesBeforeAttacking:
	.db 255, 150, 60


; ==============================================================================
; ENEMYID_SUBTERROR
;
; Variables:
;   var30: If nonzero, dirt is created at subterror's position every 8 frames.
;   var31: Counter until a new dirt object (PARTID_SUBTERROR_DIRT) is created.
; ==============================================================================
enemyCode72:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus
	jp _enemyBoss_dead

@normalStatus:
	ld e,Enemy.var30
	ld a,(de)
	or a
	call nz,_subterror_spawnDirtEvery8Frames
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw _subterror_state_uninitialized
	.dw _subterror_state_stub
	.dw _subterror_state_stub
	.dw _subterror_state_stub
	.dw _subterror_state_stub
	.dw _subterror_state_stub
	.dw _subterror_state_stub
	.dw _subterror_state_stub
	.dw _subterror_state8
	.dw _subterror_state9
	.dw _subterror_stateA
	.dw _subterror_stateB
	.dw _subterror_stateC


_subterror_state_uninitialized:
	ld a,ENEMYID_SUBTERROR
	ld b,PALH_be
	call _enemyBoss_initializeRoom
	call _ecom_setSpeedAndState8

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


_subterror_state_stub:
	ret


; Cutscene before fight
_subterror_state8:
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

	call _ecom_decCounter2
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

	call _ecom_incSubstate

	; Disable dirt animation
	ld l,Enemy.var30
	ld (hl),$00

	call objectGetTileAtPosition
	ld c,l
	ld a,TILEINDEX_DUNGEON_DUG_DIRT
	jp setTile

@substate1:
	call _subterror_retFromCallerIfAnimationUnfinished

	ld b,INTERACID_ROCKDEBRIS
	call objectCreateInteractionWithSubid00

	call _ecom_incSubstate

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
	call _ecom_decCounter1
	ret nz

	ld bc,TX_2f03
	call showText
	jp _ecom_incSubstate

@substate3:
	call retIfTextIsActive

	call _enemyBoss_beginMiniboss
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a


_subterror_digIntoGround:
	ld e,Enemy.state
	ld a,$09
	ld (de),a

	ld a,$04
	jp enemySetAnimation


; Digging into ground
_subterror_state9:
	call _subterror_retFromCallerIfAnimationUnfinished

	; Done digging, about to start moving around
_subterror_beginUndergroundMovement:
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

	call _subterror_getAngerLevel
	ld hl,_subterror_timeUntilDrillAttack
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.counter2
	ld (de),a

	ld a,SND_DIG
	call playSound
	jp _subterror_spawnDirt


; Currently in the ground, moving around
_subterror_stateA:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Staying underground for [counter1] frames before moving
@substate0:
	call _ecom_decCounter1
	ret nz

	call _ecom_incSubstate

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

	call _subterror_getAngerLevel
	ld hl,_subterror_speedVals
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.speed
	ld (de),a

	ld a,$0a
	call objectSetCollideRadius
	jp _subterror_spawnDirt

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
	call _ecom_getSideviewAdjacentWallsBitset
	jr z,++

	; Hit wall
	call _ecom_incSubstate
	ld l,Enemy.counter1
	ld (hl),90
	ld l,Enemy.visible
	res 7,(hl)
	ld l,Enemy.var30
	ld (hl),$00
	ret
++
	call _ecom_decCounter1
	call z,@resetUndergroundMovement
	call _ecom_decCounter2
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

	call _ecom_incState ; [state] = $0b
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
	call _ecom_decCounter2
	call _ecom_decCounter1
	ret nz
	ld l,Enemy.substate
	dec (hl)
	jp @resetUndergroundMovement


; Drilling
_subterror_stateB:
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
	call _ecom_decCounter1
	ret nz

	ld l,Enemy.counter1
	ld (hl),60
	ld a,$07
	call enemySetAnimation
	jp _ecom_incSubstate

@substate1:
	call _subterror_retFromCallerIfAnimationUnfinished
	call _subterror_beginUndergroundMovement
	ld e,Enemy.var30
	xor a
	ld (de),a
	ret


; Popping out of ground after shovel was used
_subterror_stateC:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call _ecom_applyVelocityForSideviewEnemy
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	ld e,Enemy.var2a
	ld (de),a ; [var2a] = 0

	ld e,Enemy.enemyCollisionMode
	ld a,ENEMYCOLLISION_STANDARD_MINIBOSS
	ld (de),a

	call _ecom_decCounter1
	jr z,++
	ld l,Enemy.counter1
	ld (hl),180
	jp _ecom_incSubstate
++
	ld bc,-$80
	jp objectSetSpeedZ

@substate1:
	ld e,Enemy.var2a
	ld a,(de)
	or a
	jr nz,++
	call enemyAnimate
	call _ecom_decCounter1
	ret nz
++
	call _ecom_incSubstate

	call getRandomNumber
	and $1c
	ld l,Enemy.angle
	ld (hl),a

	ld l,Enemy.speed
	ld (hl),SPEED_80

	call getRandomNumber
	and $03
	ld hl,_subterror_durationAboveGround
	rst_addAToHl
	ldi a,(hl)
	ld e,Enemy.counter1
	ld (de),a

	jp _subterror_setAnimationFromAngle

@substate2:
	call enemyAnimate

	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ld a,SND_LAND
	call nz,playSound

	call objectApplySpeed
	call _ecom_bounceOffWallsAndHoles
	call nz,_subterror_setAnimationFromAngle

	; Dig back into ground when [counter1] reaches 0
	call _ecom_decCounter1
	ret nz
	jp _subterror_digIntoGround


;;
_subterror_spawnDirtEvery8Frames:
	inc e
	ld a,(de) ; [var31]
	dec a
	ld (de),a
	ret nz

;;
_subterror_spawnDirt:
	ld e,Enemy.var31
	ld a,$07
	ld (de),a ; [var31] = 7
	dec e
	ld (de),a ; [var30] = 7

	ld b,PARTID_SUBTERROR_DIRT
	call _ecom_spawnProjectile

	call objectGetTileAtPosition
	ld c,l
	ld a,$ef
	jp setTile

;;
_subterror_retFromCallerIfAnimationUnfinished:
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
_subterror_getAngerLevel:
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
_subterror_setAnimationFromAngle:
	ld h,d
	ld l,Enemy.angle
	ldd a,(hl)
	add a
	swap a
	and $03
	ld (hl),a ; [direction]
	add $00
	jp enemySetAnimation


_subterror_speedVals: ; Chosen based on "anger level"
	.db SPEED_80 SPEED_100 SPEED_180

_subterror_timeUntilDrillAttack: ; Chosen based on "anger level"
	.db 120 90 60

_subterror_durationAboveGround: ; Chosen randomly
	.db 60 90 120 180


; ==============================================================================
; ENEMYID_ARMOS_WARRIOR
;
; Variables (for parent only, subid 1):
;   var30: "Turn" direction (should be 8 or -8)
;   var31: Shield
;   var32: Sword
;
; Variables (for shield only, subid 2):
;   relatedObj1: parent
;   relatedObj2: shield
;   var30: Animation index (0 or 1)
;   var31: Animation base (multiple of 2, for broken shield animation)
;   var32: Hits until destruction
;
; Variables (for sword only, subid 3):
;   relatedObj1: parent
;   relatedObj2: shield
;   var30/var31: Target position
;   var32/var33: Base position (yh and xh are manipulated by the animation to fix their
;                collision box, so need to be reset to these values each frame)
;   var34: If nonzero, checks for collision with shield
; ==============================================================================
enemyCode73:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus

	; ENEMYSTATUS_DEAD

	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp z,_enemyBoss_dead

	dec a
	jr nz,@delete

	; Subid 2 (shield) just destroyed

	; Destroy sword
	call _ecom_killRelatedObj2

	; Set some variables on parent
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld (hl),$0d

	ld l,Enemy.counter1
	ld (hl),90

	ld l,Enemy.invincibilityCounter
	ld (hl),$60

@delete:
	jp enemyDelete

@normalStatus:
	call _ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw _armosWarrior_state_uninitialized
	.dw _armosWarrior_state_spawner
	.dw _armosWarrior_state_stub
	.dw _armosWarrior_state_stub
	.dw _armosWarrior_state_stub
	.dw _armosWarrior_state_stub
	.dw _armosWarrior_state_stub
	.dw _armosWarrior_state_stub

@normalState:
	dec b
	ld a,b
	rst_jumpTable
	.dw _armosWarrior_parent
	.dw _armosWarrior_shield
	.dw _armosWarrior_sword


_armosWarrior_state_uninitialized:
	ld a,b
	or a
	jp nz,_ecom_setSpeedAndState8

	; Spawner only

	inc a
	ld (de),a ; [state] = 1
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,ENEMYID_ARMOS_WARRIOR
	jp _enemyBoss_initializeRoom


_armosWarrior_state_spawner:
	ld b,$03
	call checkBEnemySlotsAvailable
	ret nz

	ld c,$0c
	call _ecom_setZAboveScreen

	; Spawn parent
	ld b,ENEMYID_ARMOS_WARRIOR
	call _ecom_spawnUncountedEnemyWithSubid01
	ld c,h

	; Spawn shield
	call _ecom_spawnUncountedEnemyWithSubid01
	inc (hl) ; [shield.subid] = 2

	; [shield.relatedObj1] = parent
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c

	call objectCopyPosition
	push hl

	; Spawn sword
	call _ecom_spawnUncountedEnemyWithSubid01
	ld (hl),$03 ; [sword.subid] = 3

	; [sword.relatedObj1] = parent
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c

	call objectCopyPosition

	; [parent.var31] = shield
	; [parent.var32] = sword
	ld b,h
	pop hl
	ld a,h
	ld h,c
	ld l,Enemy.var31
	ldi (hl),a
	ld (hl),b

	call objectCopyPosition

	; Transfer enabled byte to parent
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	jp enemyDelete


_armosWarrior_state_stub:
	ret


_armosWarrior_parent:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw _armosWarrior_parent_state8
	.dw _armosWarrior_parent_state9
	.dw _armosWarrior_parent_stateA
	.dw _armosWarrior_parent_stateB
	.dw _armosWarrior_parent_stateC
	.dw _armosWarrior_parent_stateD
	.dw _armosWarrior_parent_stateE
	.dw _armosWarrior_parent_stateF
	.dw _armosWarrior_parent_state10


; Waiting for door to close
_armosWarrior_parent_state8:
	ld a,($cc93)
	or a
	ret nz

	ldbc $01,$08
	call _enemyBoss_spawnShadow
	ret nz

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_ARMOS_WARRIOR_PROTECTED
	jp objectSetVisible82


; Cutscene before fight starts (falling from sky)
_armosWarrior_parent_state9:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	; Hit the ground

	ld l,Enemy.substate
	inc (hl)

	inc l
	ld a,$1a
	ld (hl),a ; [counter1]
	ld (wScreenShakeCounterY),a
	ld (wScreenShakeCounterX),a

	; [sword.zh] = [parent.zh]
	ld l,Enemy.var32
	ld h,(hl)
	ld l,Enemy.zh
	ld e,l
	ld a,(de)
	ld (hl),a

	ld a,SND_STRONG_POUND
	jp playSound

@substate1:
	call _ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [substate]
	ld bc,TX_2f01
	jp showText

@substate2:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.counter1
	ld (hl),30

	call _enemyBoss_beginMiniboss
	ld a,$02
	jp enemySetAnimation

@substate3:
	call _ecom_decCounter1
	ret nz

	ld (hl),70 ; [counter1]
	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN

	ld l,e
	inc (hl) ; [substate]

	; [sword.yh] -= 2
	ld l,Enemy.var32
	ld h,(hl)
	ld l,Enemy.yh
	ld a,(hl)
	sub $02
	ldi (hl),a

	; [sword.xh] -= 1
	inc l
	dec (hl)

	xor a
	jp enemySetAnimation

; Sword moving up, parent moving down
@substate4:
	call _ecom_decCounter1
	jr nz,++

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.angle
	ld (hl),ANGLE_LEFT

	ld l,Enemy.var30
	ld (hl),$08
++
	call objectApplySpeed
	jp enemyAnimate


; Deciding which direction to move in next
_armosWarrior_parent_stateA:
	; If the armos is moving directly toward his sword, reverse direction
	ld e,Enemy.var32
	ld a,(de)
	ld h,a
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	call objectGetRelativeAngle
	add $04
	and $18
	ld b,a
	ld e,Enemy.angle
	ld a,(de)
	cp b
	jr nz,++

	; Reverse direction
	xor $10
	ld (de),a
	ld e,Enemy.var30
	ld a,(de)
	cpl
	inc a
	ld (de),a
++
	call _ecom_incState
	ld l,Enemy.counter1
	ld (hl),75
	jr _armosWarrior_parent_animate


; Moving in "box" pattern for [counter1] frames
_armosWarrior_parent_stateB:
	call _ecom_decCounter1
	jr nz,_armosWarrior_parent_updateBoxMovement
	ld l,e
	dec (hl) ; [state]

_armosWarrior_parent_updateBoxMovement:
	call _armosWarrior_parent_checkReachedTurningPoint
	jr nz,_armosWarrior_parent_animate

	; Hit one of the turning points in his movement pattern; turn 90 degrees
	ld h,d
	ld l,Enemy.var30
	ld e,Enemy.angle
	ld a,(de)
	add (hl)
	and $18
	ld (de),a

_armosWarrior_parent_animate:
	jp enemyAnimate


; Shield just hit
_armosWarrior_parent_stateC:
	call enemyAnimate
	call _ecom_decCounter1
	jr nz,_armosWarrior_parent_updateBoxMovement

	ld l,Enemy.state
	ld (hl),$0a

	; Set speed based on number of shield hits
	ld l,Enemy.var31
	ld h,(hl)
	ld l,Enemy.var32
	ld a,(hl)
	ld hl,_armosWarrior_parent_speedVals
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	ret


; Shield just destroyed
_armosWarrior_parent_stateD:
	call _ecom_decCounter1
	jr z,@gotoNextState

	; Create debris at random offset every 8 frames
	ld a,(hl)
	and $07
	ret nz

	call getRandomNumber_noPreserveVars
	ld c,a
	and $70
	swap a
	sub $04
	ld b,a
	ld a,c
	and $0f
	ld c,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_ROCKDEBRIS
	jp objectCopyPositionWithOffset

@gotoNextState:
	ld (hl),30 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_STANDARD_MINIBOSS

	ld l,Enemy.speed
	ld (hl),SPEED_200

	ld bc,TX_2f02
	call showText

	ld a,$01
	jp enemySetAnimation


; Standing still before charging Link
_armosWarrior_parent_stateE:
	call enemyAnimate
	call _ecom_decCounter1
	jr nz,_armosWarrior_parent_animate
	ld l,Enemy.state
	inc (hl)
	jp _ecom_updateAngleTowardTarget


; Charging
_armosWarrior_parent_stateF:
	call enemyAnimate
	ld a,$01
	call _ecom_getSideviewAdjacentWallsBitset
	jp z,objectApplySpeed

	; Hit wall

	call _ecom_incState
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a

	ld l,Enemy.speedZ
	ld a,<(-$180)
	ldi (hl),a
	ld (hl),>(-$180)

	ld l,Enemy.speed
	ld (hl),SPEED_100

	ld a,30
	call setScreenShakeCounter

	ld a,SND_STRONG_POUND
	jp playSound


; Recoiling from hitting wall
_armosWarrior_parent_state10:
	call enemyAnimate
	ld c,$16
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed

	; Hit ground

	ld h,d
	ld l,Enemy.state
	ld (hl),$0e

	ld l,Enemy.speed
	ld (hl),SPEED_200

	ld l,Enemy.counter1
	ld (hl),60
	ret


_armosWarrior_shield:
	ld a,(de)
	cp $08
	jr z,@state8

@state9:
	; Delete self if no hits remaining
	ld h,d
	ld l,Enemy.var32
	ld a,(hl)
	or a
	jp z,_ecom_killObjectH

	ld a,Object.animParameter
	call objectGetRelatedObject1Var
	ld e,Enemy.var30
	ld a,(de)
	cp (hl)
	jr z,++

	ld a,(hl)
	ld (de),a
	ld e,Enemy.var31
	ld a,(de)
	add (hl)
	call enemySetAnimation
++
	jp _armosWarrior_shield_updatePosition

; Uninitialized
@state8:
	ld a,($cc93)
	or a
	ret nz

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_ARMOS_WARRIOR_SHIELD

	ld l,Enemy.var32
	ld (hl),$03

	; [shield.relatedObj2] = sword (parent.var32)
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.var32
	ld e,Enemy.relatedObj2
	ld a,Enemy.start
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	ld e,Enemy.var31
	ld a,$03
	ld (de),a

	call enemySetAnimation
	call _armosWarrior_shield_updatePosition
	jp objectSetVisible81


_armosWarrior_sword:
	ld e,Enemy.state
	ld a,(de)
	cp $0b
	call nc,_armosWarrior_sword_playSlashSound

	ld e,Enemy.state
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw _armosWarrior_sword_state8
	.dw _armosWarrior_sword_state9
	.dw _armosWarrior_sword_stateA
	.dw _armosWarrior_sword_stateB
	.dw _armosWarrior_sword_stateC


; Waiting for door to close
_armosWarrior_sword_state8:
	ld a,($cc93)
	or a
	ret nz

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_ARMOS_WARRIOR_SWORD

	ld l,Enemy.speed
	ld (hl),SPEED_20

	call _armosWarrior_sword_setPositionAsHeld

	; [sword.relatedObj2] = shield (parent.var31)
	ld l,Enemy.var31
	ld e,Enemy.relatedObj2
	ld a,Enemy.start
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	ld a,$09
	call enemySetAnimation
	jp objectSetVisible80


; Waiting for initial cutscene to end, then moving upward before fight starts
_armosWarrior_sword_state9:
	ld a,Object.substate
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,_armosWarrior_sword_setPositionAsHeld

	sub $03
	ret c
	jr z,@parentSubstate3

	dec l
	ld a,(hl) ; [parent.state]
	cp $0a
	jr nc,@gotoStateA
	call _armosWarrior_sword_playSlashSound
	jp enemyAnimate

@gotoStateA:
	ld h,d
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$01

	; Save position
	ld e,Enemy.yh
	ld l,Enemy.var32
	ld a,(de)
	ldi (hl),a
	ld e,Enemy.xh
	ld a,(de)
	ld (hl),a
	ret

@parentSubstate3:
	ld h,d
	ld l,Enemy.counter1
	ld a,(hl)
	inc (hl)

	or a
	ld a,$0a
	jp z,enemySetAnimation

	ld l,Enemy.yh
	dec (hl)
	ret


; Staying still before charging toward Link
_armosWarrior_sword_stateA:
	call _ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_180

	ld l,Enemy.counter1
	ld (hl),150

	; Write target position to var30/var31
	ld l,Enemy.var30
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a

	call _ecom_updateAngleTowardTarget
	call enemyAnimate
	jp _armosWarrior_sword_updateCollisionBox


; Charging toward target position
_armosWarrior_sword_stateB:
	call _armosWarrior_sword_checkCollisionWithShield
	ld a,(wFrameCounter)
	and $03
	jr nz,++

	; Update angle toward target position every 4 frames
	ld h,d
	ld l,Enemy.var30
	call _ecom_readPositionVars
	call objectGetRelativeAngleWithTempVars
	ld e,Enemy.angle
	ld (de),a
++
	call _armosWarrior_sword_checkWentTooFar
	jr c,@beginSlowingDown

	; If within 28 pixels of target position, start slowing down
	ld l,Enemy.var30
	ld a,(hl)
	sub b
	add 28
	cp 57
	jr nc,@notSlowingDown
	inc l
	ld a,(hl)
	sub c
	add 28
	cp 57
	jr nc,@notSlowingDown

@beginSlowingDown:
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),$70

@notSlowingDown:
	call enemyAnimate

_armosWarrior_sword_updatePosition:
	call _ecom_applyVelocityForTopDownEnemy

	; Save position
	ld h,d
	ld l,Enemy.yh
	ld e,Enemy.var32
	ldi a,(hl)
	ld (de),a
	inc e
	inc l
	ld a,(hl)
	ld (de),a

	jp _armosWarrior_sword_updateCollisionBox


; Slowing down
_armosWarrior_sword_stateC:
	call _armosWarrior_sword_checkCollisionWithShield
	call _ecom_decCounter1
	jr z,@stoppedMoving

	ld a,(hl) ; [counter1]
	swap a
	rrca
	and $03
	ld hl,_armosWarrior_sword_speedVals
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a

	; Restore position (which was manipulated for shield collision detection)
	ld h,d
	ld l,Enemy.yh
	ld e,Enemy.var32
	ld a,(de)
	ldi (hl),a
	inc e
	inc l
	ld a,(de)
	ld (hl),a

	ld e,Enemy.counter1
	ld a,(de)
	cp 30
	jr nc,+
	rrca
+
	call nc,enemyAnimate
	jr _armosWarrior_sword_updatePosition

@stoppedMoving:
	ld e,Enemy.animParameter
	ld a,(de)
	cp $07
	jr z,@atRest
	ld (hl),$02 ; [counter1]
	jp enemyAnimate

@atRest:
	ld l,Enemy.state
	ld (hl),$0a
	ld l,Enemy.var34
	ld (hl),$00

	; Set counter1 (frames to rest) based on number of hits until shield destroyed
	ld a,Object.var32
	call objectGetRelatedObject2Var
	ld a,(hl)
	swap a
	rlca
	add 30
	ld e,Enemy.counter1
	ld (de),a

	ld a,$0a
	jp enemySetAnimation


;;
; Shield copies parent's position plus an offset
_armosWarrior_shield_updatePosition:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ldi a,(hl) ; [parent.yh]
	ld b,a
	inc l
	ldi a,(hl) ; [parent.xh]
	ld c,a

	inc l
	ld e,l
	ld a,(hl)
	ld (de),a ; [shield.zh] = [parent.zh]

	ld e,Enemy.var30
	ld a,(de)
	ld hl,_armosWarrior_shield_YXOffsets
	rst_addDoubleIndex
	ld e,Enemy.yh
	ldi a,(hl)
	add b
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	add c
	ld (de),a
	ret


;;
; Updates collisionRadiusY/X based on animParameter, also adds an offset to Y/X position.
_armosWarrior_sword_updateCollisionBox:
	ld e,Enemy.animParameter
	ld a,(de)
	add a
	ld hl,_armosWarrior_sword_collisionBoxes
	rst_addDoubleIndex

	ld e,Enemy.var32
	ld a,(de)
	add (hl)
	ld e,Enemy.yh
	ld (de),a

	inc hl
	ld e,Enemy.var33
	ld a,(de)
	add (hl)
	ld e,Enemy.xh
	ld (de),a
	inc hl

	ld e,Enemy.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret


;;
; Sets the sword's position assuming it's being held by the parent.
_armosWarrior_sword_setPositionAsHeld:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld bc,$f4fa
	jp objectTakePositionWithOffset

;;
_armosWarrior_sword_checkCollisionWithShield:
	ld e,Enemy.var34
	ld a,(de)
	dec a
	ret z

	; Check if sword and shield collide
	ld a,Object.collisionRadiusY
	call objectGetRelatedObject2Var
	ld c,Enemy.yh
	call @checkIntersection
	ret nc

	ld c,Enemy.xh
	ld l,Enemy.collisionRadiusX
	call @checkIntersection
	ret nc

	; They've collided

	ld e,Enemy.var34
	ld a,$01
	ld (de),a

	; Set various variables on the shield
	ld l,Enemy.invincibilityCounter
	ld (hl),$18

	; [Hits until destruction]--
	ld l,Enemy.var32
	dec (hl)

	ld l,Enemy.var31
	ld a,(hl)
	add $02
	ld (hl),a

	; h = [shield.relatedObj1] = parent
	ld l,Enemy.relatedObj1+1
	ld h,(hl)

	ld l,Enemy.counter1
	ld (hl),60

	ld l,Enemy.state
	ld (hl),$0c

	ld l,Enemy.speed
	ld (hl),SPEED_300

	ld l,Enemy.invincibilityCounter
	ld (hl),$18

	ld a,SND_BOSS_DAMAGE
	jp playSound

;;
; Checks for intersection on a position component given two objects.
@checkIntersection:
	; b = [sword.collisionRadius] + [shield.collisionRadius]
	ld e,l
	ld a,(de)
	add (hl)
	ld b,a

	; a = [sword.pos] - [shield.pos]
	ld l,c
	ld e,l
	ld a,(de)
	sub (hl)

	add b
	sla b
	inc b
	cp b
	ret


;;
; The armos always moves in a "box" pattern in his first phase, this checks if he's
; reached one of the "corners" of the box where he must turn.
;
; @param[out]	zflag	z if hit a turning point
_armosWarrior_parent_checkReachedTurningPoint:
	ld b,$31
	ld e,Enemy.yh
	ld a,(de)
	cp $30
	jr c,@hitCorner

	ld b,$7f
	cp $80
	jr nc,@hitCorner

	ld b,$bf
	ld e,Enemy.xh
	ld a,(de)
	cp $c0
	jr nc,@hitCorner

	ld b,$31
	cp $30
	jr c,@hitCorner

	call objectApplySpeed
	or d
	ret

@hitCorner:
	ld a,b
	ld (de),a
	xor a
	ret


;;
; @param[out]	bc	Position of sword
; @param[out]	cflag	c if the sword has gone to far and should stop now
_armosWarrior_sword_checkWentTooFar:
	; Fix position, store it in bc
	ld h,d
	ld l,Enemy.yh
	ld e,Enemy.var32
	ld a,(de)
	ldi (hl),a
	ld b,a
	inc e
	inc l
	ld a,(de)
	ld (hl),a
	ld c,a

	; Read in boundary data based on the angle, determine if the sword has gone past
	ld e,Enemy.angle
	ld a,(de)
	add $02
	and $1c
	rrca
	ld hl,_armosWarrior_sword_angleBoundaries
	rst_addAToHl

	ldi a,(hl)
	ld e,b
	call @checkPositionComponent
	jr c,++
	ld e,c
	ld a,(hl)
	call @checkPositionComponent
++
	ld h,d
	ret

;;
@checkPositionComponent:
	; If bit 0 of the data structure is set, it's an upper / left boundary
	bit 0,a
	jr nz,++
	cp e
	ret
++
	cp e
	ccf
	ret


_armosWarrior_shield_YXOffsets:
	.db $fb $03 ; Frame 0
	.db $fb $07 ; Frame 1


; This is a table of data values for various parts of the sword's animation, which adjusts
; its collision box.
;   b0: Y-offset
;   b1: X-offset
;   b2: collisionRadiusY
;   b3: collisionRadiusX
_armosWarrior_sword_collisionBoxes:
	.db $fc $00 $08 $03
	.db $fe $fe $06 $06
	.db $00 $fc $03 $08
	.db $02 $fe $06 $06
	.db $04 $ff $08 $03
	.db $02 $02 $06 $06
	.db $01 $04 $03 $08
	.db $fe $02 $06 $06


; Sword decelerates based on these values
_armosWarrior_sword_speedVals:
	.db SPEED_40, SPEED_80, SPEED_100, SPEED_140


; Parent chooses a speed from here based on how many hits the shield has taken
_armosWarrior_parent_speedVals:
	.db SPEED_180, SPEED_140, SPEED_100


; For each possible angle the sword can move in, this has Y and X boundaries where it
; should stop.
;   b0: Y-boundary. (If bit 0 is set, it's an upper boundary.)
;   b1: X-boundary. (If bit 0 is set, it's a left boundary.)
_armosWarrior_sword_angleBoundaries:
	.db $51 $fe ; Up
	.db $51 $98 ; Up-right
	.db $fe $98 ; Right
	.db $60 $98 ; Down-right
	.db $60 $fe ; Down
	.db $60 $51 ; Down-left
	.db $fe $51 ; Left
	.db $51 $51 ; Up-left

;;
_armosWarrior_sword_playSlashSound:
	ld a,(wFrameCounter)
	and $0f
	ret nz
	ld a,SND_SWORDSLASH
	jp playSound


; ==============================================================================
; ENEMYID_SMASHER
;
; Variables (ball, subid 0):
;   relatedObj1: parent
;   var30: Counter until the ball respawns
;
; Variables (parent, subid 1):
;   relatedObj1: ball
;   var30/var31: Target position (directly in front of ball object)
;   var32: Nonzero if already initialized
; ==============================================================================
enemyCode74:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jr z,@normalStatus
	jp _ecom_updateKnockback

@dead:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr nz,@mainDead

	; Ball dead
	call _smasher_ball_makeLinkDrop
	call objectCreatePuff
	jp enemyDelete

@mainDead:
	ld e,Enemy.collisionType
	ld a,(de)
	or a
	call nz,_ecom_killRelatedObj1
	jp _enemyBoss_dead

@normalStatus:
	call _smasher_ball_updateRespawnTimer
	call _ecom_getSubidAndCpStateTo08
	jr c,@commonState
	ld a,b
	or a
	jp z,_smasher_ball
	jp _smasher_parent

@commonState:
	rst_jumpTable
	.dw _smasher_state_uninitialized
	.dw _smasher_state_stub
	.dw _smasher_state_grabbed
	.dw _smasher_state_stub
	.dw _smasher_state_stub
	.dw _smasher_state_stub
	.dw _smasher_state_stub
	.dw _smasher_state_stub


_smasher_state_uninitialized:
	ld a,b
	or a
	jr nz,@alreadySpawnedParent

@initializeBall:
	ld b,a
	ld a,$ff
	call _enemyBoss_initializeRoom

	; Spawn parent
	ld b,ENEMYID_SMASHER
	call _ecom_spawnUncountedEnemyWithSubid01
	ret nz

	; [parent.enabled] = [ball.enabled]
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	; [ball.relatedObj1] = parent
	; [parent.relatedObj1] = ball
	ld l,Enemy.relatedObj1
	ld e,l
	ld a,Enemy.start
	ldi (hl),a
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld (hl),d

	call objectCopyPosition

	; If parent object has a lower index than ball object, swap them
	ld a,h
	cp d
	jr nc,@initialize

	ld l,Enemy.subid
	ld (hl),$80 ; Change former "parent" to "ball"
	ld e,l
	ld a,$01
	ld (de),a   ; Change former "ball" (this) to "parent"

@alreadySpawnedParent:
	dec a
	jr z,@gotoState8

	; Effectively clears bit 7 of parent's subid (should be $80 when it reaches here)
	ld e,Enemy.subid
	xor a
	ld (de),a

@initialize:
	ld a,$01
	call _smasher_setOamFlags

	ld l,Enemy.xh
	ld a,(hl)
	sub $20
	ld (hl),a

	ld a,$04
	call enemySetAnimation

@gotoState8:
	jp _ecom_setSpeedAndState8AndVisible


_smasher_state_grabbed:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @atRest

@justGrabbed:
	ld h,d
	ld l,e
	inc (hl)
	ld a,2<<4
	ld (wLinkGrabState2),a
	jp objectSetVisiblec1

@beingHeld:
	ret

@released:
	call _ecom_bounceOffWallsAndHoles
	jr z,++

	; Hit a wall; copy new angle to the "throw item" that's controlling this
	ld e,Enemy.angle
	ld a,(de)
	ld hl,w1ReservedItemC.angle
	ld (hl),a
++
	; Return if parent was already hit
	ld a,Object.invincibilityCounter
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	ret nz

	; Check if we've collided with parent
	ld l,Enemy.zh
	ld e,l
	ld a,(de)
	sub (hl)
	add $08
	cp $11
	ret nc
	call checkObjectsCollided
	ret nc

	; We've collided

	ld l,Enemy.invincibilityCounter
	ld (hl),$20
	ld l,Enemy.knockbackCounter
	ld (hl),$10

	ld l,Enemy.health
	dec (hl)

	; Calculate knockback angle for boss
	call _smasher_ball_loadPositions
	push hl
	call objectGetRelativeAngleWithTempVars
	pop hl
	ld l,Enemy.knockbackAngle
	ld (hl),a

	; Reverse knockback angle for ball
	xor $10
	ld hl,w1ReservedItemC.angle
	ld (hl),a

	ld a,SND_BOSS_DAMAGE
	jp playSound

@atRest:
	dec e
	ld a,$08
	ld (de),a ; [state] = 8
	jp objectSetVisiblec2


_smasher_state_stub:
	ret


_smasher_ball:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw _smasher_ball_state8
	.dw _smasher_ball_state9
	.dw _smasher_ball_stateA
	.dw _smasher_ball_stateB
	.dw _smasher_ball_stateC
	.dw _smasher_ball_stateD
	.dw _smasher_ball_stateE
	.dw _smasher_ball_stateF


; Initialization (or just reappeared after disappearing)
_smasher_ball_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_SMASHER_BALL
	ld l,Enemy.speed
	ld (hl),SPEED_a0


; Lying on ground, waiting for parent or Link to pick it up
_smasher_ball_state9:
	call objectAddToGrabbableObjectBuffer
	jp objectPushLinkAwayOnCollision


; Parent is picking up the ball
_smasher_ball_stateA:
	ld h,d
	ld l,Enemy.zh
	ldd a,(hl)
	cp $f4
	jr z,++

	; [ball.z] -= $0080 (moving up)
	ld a,(hl)
	sub <($0080)
	ldi (hl),a
	ld a,(hl)
	sbc >($0080)
	ld (hl),a
++
	; Move toward parent on Y/X axis
	ld a,Object.yh
	call objectGetRelatedObject1Var
	call _smasher_ball_loadPositions
	cp c
	jp nz,_ecom_moveTowardPosition
	ldh a,(<hFF8F)
	cp b
	jp nz,_ecom_moveTowardPosition

	; Reached parent's Y/X position; wait for Z as well
	ld e,Enemy.zh
	ld a,(de)
	cp $f4
	ret nz

	; Reached position; go to next state
	call _ecom_incState

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.speed
	ld (hl),SPEED_300
	jp objectSetVisiblec1


; This state is a signal for the parent, which will update the ball's state when it gets
; released.
_smasher_ball_stateB:
	ret


; Being thrown
_smasher_ball_stateC:
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jr c,@doneBouncing
	jr nz,++

	; Hit ground
	ld e,Enemy.speed
	ld a,(de)
	srl a
	ld (de),a
	call _smasher_ball_playLandSound
++
	call _ecom_bounceOffWallsAndHoles
	jp objectApplySpeed

@doneBouncing:
	ld h,d
	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.collisionType
	res 7,(hl)
	call objectSetVisiblec2

_smasher_ball_playLandSound:
	ld a,SND_BOMB_LAND
	jp playSound


; Disappearing (either after being thrown, or after a time limit)
_smasher_ball_stateD:
	call objectCreatePuff
	ret nz

	; If parent is picking up or throwing the ball, cancel that
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0b
	jr c,++
	ld (hl),$0d ; [parent.state]
	ld l,Enemy.oamFlagsBackup
	ld a,$03
	ldi (hl),a
	ld (hl),a
++
	call _ecom_incState

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.counter1
	ld (hl),60
	jp objectSetInvisible


; Ball is gone, will reappear after [counter1] frames
_smasher_ball_stateE:
	call _ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.zh
	ld (hl),-$20

	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a

	; Choose random position to spawn at
	call getRandomNumber_noPreserveVars
	and $0e
	ld hl,@spawnPositions
	rst_addAToHl
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a

	call objectCreatePuff
	jp objectSetVisiblec1

@spawnPositions:
	.db $38 $38
	.db $78 $38
	.db $38 $78
	.db $78 $78
	.db $38 $b8
	.db $78 $b8
	.db $58 $58
	.db $58 $98


; Ball is falling to ground after reappearing
_smasher_ball_stateF:
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jr c,@doneBouncing
	ret nz
	jp _smasher_ball_playLandSound

@doneBouncing:
	ld e,Enemy.state
	ld a,$08
	ld (de),a
	jp objectSetVisiblec2


_smasher_parent:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw _smasher_parent_state8
	.dw _smasher_parent_state9
	.dw _smasher_parent_stateA
	.dw _smasher_parent_stateB
	.dw _smasher_parent_stateC
	.dw _smasher_parent_stateD


; Initialization
_smasher_parent_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$01

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	; Don't do below function call if already initialized
	ld l,Enemy.var32
	bit 0,(hl)
	jr nz,_smasher_parent_state9

	inc (hl) ; [var32]
	call _enemyBoss_beginMiniboss


_smasher_parent_state9:
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $09
	jr z,@moveTowardBall

	; Ball unavailable; moving aronund in random angles

	call _ecom_decCounter1
	jr nz,@updateMovement

	; Time to choose a new angle
	ld (hl),60 ; [counter1]

	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@randomAngles
	rst_addAToHl
	ld e,Enemy.angle
	ld a,(hl)
	ld (de),a
	call _smasher_updateDirectionFromAngle

@updateMovement:
	call _ecom_applyVelocityForSideviewEnemyNoHoles
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr nz,@updateAnim

	call _smasher_hop
	ld e,Enemy.direction
	ld a,(de)
	inc a
	jp enemySetAnimation

@updateAnim:
	; Change animation when he reaches the peak of his hop (speedZ is zero)
	ldd a,(hl)
	or (hl)
	ret nz
	ld e,Enemy.direction
	ld a,(de)
	jp enemySetAnimation

@moveTowardBall:
	; Copy ball's Y-position to var30 (Y-position to move to)
	ld l,Enemy.yh
	ld e,Enemy.var30
	ldi a,(hl)
	ld (de),a

	; Calculate X-position to move to ($0e pixels to one side of the ball), then store
	; the value in var31
	inc l
	ld e,l
	ld a,(de) ; [parent.xh]
	cp (hl)   ; [ball.xh]
	ld a,$0e
	jr nc,+
	ld a,-$0e
+
	ld c,a

	add (hl) ; [ball.xh]
	ld b,a
	sub $18
	cp $c0
	jr c,++
	ld a,c
	cpl
	inc a
	add a
	add b
	ld b,a
++
	ld h,d
	ld l,Enemy.var31
	ld (hl),b

	; Goto next state to move toward the ball
	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.speed
	ld (hl),SPEED_100

	ld l,Enemy.var30
	call _ecom_readPositionVars
	call _smasher_updateAngleTowardPosition
	jp enemySetAnimation


@randomAngles: ; When ball is unavailable, smasher move randomly in one of these angles
	.db $06 $0a $16 $1a


; Moving toward ball on the ground
_smasher_parent_stateA:
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $09
	jr nz,_smasher_parent_linkPickedUpBall

	; Check if we've reached the target position in front of the ball
	ld h,d
	ld l,Enemy.var30
	call _ecom_readPositionVars
	sub c
	add $02
	cp $05
	jr nc,@movingTowardBall
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jr nc,@movingTowardBall

	; We've reached the position

	ld l,Enemy.state
	inc (hl) ; [parent.state]

	ld l,Enemy.zh
	ld (hl),$00

	ld a,$02
	call _smasher_setOamFlags

	ld a,Object.state
	call objectGetRelatedObject1Var
	inc (hl) ; [ball.state] = $0a

	; Face toward the ball? ('b' is still set to the y-position from before?)
	ld l,Enemy.xh
	ld c,(hl)
	call _smasher_updateAngleTowardPosition
	inc a
	jp enemySetAnimation

@movingTowardBall:
	call _ecom_moveTowardPosition

	ld e,Enemy.angle
	ld a,(de)
	call _smasher_updateDirectionFromAngle
	call enemySetAnimation

	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	jr _smasher_hop


_smasher_parent_linkPickedUpBall:
	; Stop chasing the ball
	ld h,d
	ld l,Enemy.state
	ld (hl),$09

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	ld l,Enemy.counter1
	ld (hl),60

	ld a,$03
	call _smasher_setOamFlags

	; Run away from Link
	call _ecom_updateCardinalAngleAwayFromTarget
	jp _smasher_updateDirectionFromAngle


; About to pick up ball
_smasher_parent_stateB:
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMYSTATE_GRABBED
	jr z,_smasher_parent_linkPickedUpBall

	; Wait for ball's state to update
	cp $0b
	ret c

	ld a,$03
	call _smasher_setOamFlags

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter2
	ld (hl),30

	ld l,Enemy.speed
	ld (hl),SPEED_40

;;
_smasher_hop:
	ld l,Enemy.speedZ
	ld a,<(-$c0)
	ldi (hl),a
	ld (hl),>(-$c0)
	ret


; Just picked up ball; hopping while moving slowly toward Link
_smasher_parent_stateC:
	call _smasher_updateAngleTowardLink
	inc a
	call enemySetAnimation

	call _ecom_decCounter2

	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr z,@hitGround

	call _ecom_applyVelocityForSideviewEnemyNoHoles

	; Update ball's position
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	call objectCopyPosition
	dec l
	ld e,l
	ld a,(de) ; [parent.zh]
	add $f4
	ld (hl),a ; [ball.zh]
	ret

@hitGround:
	ld e,Enemy.counter2
	ld a,(de)
	or a
	jp nz,_smasher_hop

	; Done hopping; go to next state to leap into the air

	ld a,>(-$1e0)
	ldd (hl),a
	ld (hl),<(-$1e0)

	ld l,Enemy.state
	inc (hl)

	ld a,$02
	jp _smasher_setOamFlags


; In midair just before throwing ball
_smasher_parent_stateD:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr nz,@inMidair

	; Hit the ground
	ld l,Enemy.state
	ld (hl),$08
	ret

@inMidair:
	ld a,Object.zh
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(de)
	add $f4
	ld (hl),a

	ld e,Enemy.speedZ+1
	ld a,(de)
	rlca
	jr nc,@movingDown

	; Moving up
	call _smasher_updateAngleTowardLink
	inc a
	jp enemySetAnimation

@movingDown:
	; Return if speedZ is nonzero (not at peak of jump)
	ld b,a
	dec e
	ld a,(de)
	or b
	ret nz

	; Throw the ball if its state is valid for this
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0b
	ret nz

	inc (hl) ; [ball.state]
	ld l,Enemy.angle
	ld e,l
	ld a,(de)
	ld (hl),a

	ld a,$03
	call _smasher_setOamFlags

	ld e,Enemy.direction
	ld a,(de)
	jp enemySetAnimation


;;
; @param[out]	a	direction value
_smasher_updateAngleTowardPosition:
	call objectGetRelativeAngleWithTempVars
	ld e,Enemy.angle
	ld (de),a
	jr _smasher_updateDirectionFromAngle

;;
_smasher_updateAngleTowardLink:
	call objectGetAngleTowardEnemyTarget
	ld e,Enemy.angle
	ld (de),a

;;
; @param	a	angle
; @param[out]	a	direction value
_smasher_updateDirectionFromAngle:
	ld b,a
	and $0f
	ret z
	ld a,b
	and $10
	xor $10
	swap a
	rlca
	ld e,Enemy.direction
	ld (de),a
	ret


;;
; @param	a	Value for oamFlags
_smasher_setOamFlags:
	ld h,d
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	ret

;;
; Loads positions into bc and hFF8E/hFF8F for subsequent call to
; "objectGetRelativeAngleWithTempVars".
;
; @param	h	Parent object
_smasher_ball_loadPositions:
	ld l,Enemy.yh
	ld e,l
	ld a,(de)
	ldh (<hFF8F),a
	ld b,(hl)
	ld l,Enemy.xh
	ld e,l
	ld a,(de)
	ldh (<hFF8E),a
	ld c,(hl)
	ret


;;
; Updates the ball's "respawn timer" and makes it disappear (goes to state $0d) when it
; hits zero.
_smasher_ball_updateRespawnTimer:
	; Return if this isn't the ball
	ld e,Enemy.subid
	ld a,(de)
	or a
	ret nz

	ld e,Enemy.state
	ld a,(de)
	cp $0d
	ret nc
	ld a,(wFrameCounter)
	rrca
	ret c

	ld h,d
	ld l,Enemy.var30
	inc (hl)
	ld a,(hl)
	cp 180
	ret c

	ld (hl),$00
	call _smasher_ball_makeLinkDrop
	ld e,Enemy.state
	ld a,$0d
	ld (de),a
	ret


;;
_smasher_ball_makeLinkDrop:
	ld e,Enemy.state
	ld a,(de)
	cp $02
	ret nz
	inc e
	ld a,(de)
	cp $02
	ret nc
	jp dropLinkHeldItem


; ==============================================================================
; ENEMYID_VIRE
;
; Variables (for main form, subid 0):
;   relatedObj2: INTERACID_PUFF?
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
; ==============================================================================
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
	jp z,_enemyBoss_dead

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
	call _ecom_getSubidAndCpStateTo08
	jr c,@commonState

	ld a,b
	or a
	jp z,_vire_mainForm
	jp _vire_batForm

@commonState:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw _vire_state_uninitialized
	.dw _vire_state_stub
	.dw _vire_state_stub
	.dw _vire_state_stub
	.dw _vire_state_stub
	.dw _vire_state_stub
	.dw _vire_state_stub
	.dw _vire_state_stub


_vire_state_uninitialized:
	ld a,SPEED_c0
	call _ecom_setSpeedAndState8

	ld a,b
	or a
	ret nz

	; "Main" vire only (not bat form)
	ld l,Enemy.zh
	ld (hl),$fc

	dec a ; a = $ff
	ld b,$00
	jp _enemyBoss_initializeRoom


_vire_state_stub:
	ret


_vire_mainForm:
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
	.dw _vire_mainForm_state8
	.dw _vire_mainForm_state9
	.dw _vire_mainForm_stateA
	.dw _vire_mainForm_stateB
	.dw _vire_mainForm_stateC
	.dw _vire_mainForm_stateD
	.dw _vire_mainForm_stateE
	.dw _vire_mainForm_stateF


; Mini-cutscene before starting fight
_vire_mainForm_state8:
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

	ldbc INTERACID_PUFF, $02
	call objectCreateInteraction
	ret nz

	; [relatedObj2] = INTERACID_PUFF
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
	call _ecom_decCounter1
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
	call _ecom_incState
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
_vire_mainForm_state9:
	call _ecom_decCounter1
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
_vire_mainForm_stateA:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call _vire_spawnOutsideCamera
	inc l
	ld (hl),20 ; [counter1]
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ret

; Moving slowly before charging
@substate1:
	call _ecom_decCounter1
	jp nz,_vire_mainForm_applySpeedAndAnimate

	; Begin charging
	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.speed
	ld (hl),SPEED_200
	call _ecom_updateAngleTowardTarget
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
	call _vire_checkOffScreen
	jp nc,_vire_mainForm_leftScreen
	call _ecom_decCounter1
	ld a,(hl)
	and $1f
	call z,_vire_mainForm_fireProjectile
	jp _vire_mainForm_applySpeedAndAnimate


; Circling Link, runs away if Link gets too close (similar to state D)
_vire_mainForm_stateB:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0: ; Also subid 0 for state D
	call _vire_spawnOutsideCamera
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

	call _ecom_decCounter1
	jr z,@beginCharge

	ld a,(hl)
	and $1f
	ld b,$01
	call z,_vire_mainForm_fireProjectileWithSubid
++
	call _vire_mainForm_checkLinkTooClose
	jp nc,_vire_mainForm_circleAroundScreen

; Begin charging; initially toward Link, but will run away if he gets too close or Link
; attacks
@beginCharge:
	ld l,Enemy.substate
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_200
	call _ecom_updateAngleTowardTarget
	jr @animate

; Charging toward Link
@substate2:
	call _vire_mainForm_checkLinkTooClose
	jr c,@updateAngleAway
	ld a,(wLinkUsingItem1)
	or a
	jr nz,@updateAngleAway
	call _vire_checkOffScreen
	jp nc,_vire_mainForm_leftScreen
	jp _vire_mainForm_applySpeedAndAnimate

; Charging away from Link
@updateAngleAway:
	ld l,e
	inc (hl) ; [substate]
	call _ecom_updateCardinalAngleAwayFromTarget
@animate:
	jp enemyAnimate

@substate3:
	call _vire_checkOffScreen
	jp nc,_vire_mainForm_leftScreen

	call _ecom_decCounter1
	ld a,(hl)
	and $1f
	ld b,$01
	call z,_vire_mainForm_fireProjectileWithSubid
	jp _vire_mainForm_applySpeedAndAnimate


; Vire creeps in from the screen edge to fire one projectile, then runs away
_vire_mainForm_stateC:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call _vire_spawnOutsideCamera
	inc l
	ld (hl),28 ; [counter1]
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ret

@substate1:
	call _ecom_decCounter1
	jp nz,_vire_mainForm_applySpeedAndAnimate

	ld (hl),12 ; [counter1]
	ld l,e
	inc (hl) ; [substate]

	ld b,$03
	call _vire_mainForm_fireProjectileWithSubid
	jr @animate

@substate2:
	call _ecom_decCounter1
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
	call _vire_checkOffScreen
	jp nc,_vire_mainForm_leftScreen
	jp _vire_mainForm_applySpeedAndAnimate


; Circling Link, runs away if Link attempts to attack (similar to state B)
_vire_mainForm_stateD:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw _vire_mainForm_stateB@substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw _vire_state_moveOffScreen

@substate1:
	ld a,(wFrameCounter)
	and $03
	jr nz,++

	call _ecom_decCounter1
	jr z,@beginCharge

	ld a,(hl)
	and $1f
	ld b,$01
	call z,_vire_mainForm_fireProjectileWithSubid
++
	call _vire_mainForm_checkLinkTooClose
	jp nc,_vire_mainForm_circleAroundScreen

; Begin charging; initially toward Link, but will run away if he gets too close or Link
; attacks
@beginCharge:
	ld l,Enemy.substate
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_200
	call _ecom_updateAngleTowardTarget
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
	call _ecom_updateCardinalAngleAwayFromTarget
	jr @animate

@moveOffScreen:
	call _vire_checkOffScreen
	jp nc,_vire_mainForm_leftScreen
	jp _vire_mainForm_applySpeedAndAnimate

@substate3:
	call _ecom_decCounter1
	jp nz,_vire_mainForm_applySpeedAndAnimate

	ld (hl),12 ; [counter1]
	ld l,e
	inc (hl) ; [substate]

	ld b,PARTID_VIRE_PROJECTILE
	call _ecom_spawnProjectile

	ld a,SND_SPLASH
	call playSound
	jr @animate

@substate4:
	call _ecom_decCounter1
	jr nz,@animate

	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.speed
	ld (hl),SPEED_1c0

	call _ecom_updateCardinalAngleAwayFromTarget
	jr @animate


_vire_state_moveOffScreen: ; Used by states D and E
	call _vire_checkOffScreen
	jp nc,_vire_mainForm_leftScreen
	jp _vire_mainForm_applySpeedAndAnimate


; Just took damage
_vire_mainForm_stateE:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw _vire_state_moveOffScreen

@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	inc l
	ld (hl),20 ; [counter1]

	ld l,Enemy.speed
	ld (hl),SPEED_300
	call _ecom_updateCardinalAngleAwayFromTarget

	ld e,Enemy.direction
	xor a
	ld (de),a

	ld e,Enemy.var32
	ld (de),a
	jp enemySetAnimation

@substate1:
	call _ecom_decCounter1
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
_vire_mainForm_stateF:
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
	call _ecom_decCounter1
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
	ld b,ENEMYID_VIRE
	call _ecom_spawnUncountedEnemyWithSubid01
	call @initBat

	call _ecom_spawnUncountedEnemyWithSubid01
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
	jp nz,_ecom_decCounter2

	; Vire defeated
	ld h,d
	ld l,Enemy.substate
	inc (hl)
	inc l
	ld (hl),60 ; [counter1]
	ld a,SNDCTRL_STOPMUSIC
	jp playSound

@substate3:
	call _ecom_decCounter1
	jp nz,_ecom_flickerVisibility

	ld (hl),$10 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	jp objectSetVisiblec1

@substate4:
	call _ecom_decCounter1
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
	ld b,PARTID_ITEM_DROP
	call _ecom_spawnProjectile
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

	call _vire_checkOffScreen
	jp c,objectApplySpeed

	; Vire is gone; cleanup
	call markEnemyAsKilledInRoom
	call decNumEnemies
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	jp enemyDelete


_vire_batForm:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw _vire_batForm_state8
	.dw _vire_batForm_state9
	.dw _vire_batForm_stateA
	.dw _vire_batForm_stateB
	.dw _vire_batForm_stateC
	.dw _vire_batForm_stateD


_vire_batForm_state8:
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
_vire_batForm_state9:
	call _ecom_decCounter1
	jr z,_vire_batForm_gotoStateA

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
	jr _vire_batForm_animate

_vire_batForm_gotoStateA:
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
	jr _vire_batForm_animate


_vire_batForm_stateA:
	call _vire_batForm_updateZPos

	ld a,Object.counter2
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr nz,++

.ifdef ROM_AGES
	call _ecom_incState
.else
	ld h,d
	ld l,Enemy.state
	inc (hl)
.endif

	ld l,Enemy.counter1
	ld (hl),$08
	ret
++
	call _vire_batForm_moveAwayFromLinkIfTooClose

	call objectGetAngleTowardEnemyTarget
	ld b,a
	ld e,Enemy.var30
	ld a,(de)
	add b
	and $1f
	ld e,Enemy.angle
	ld (de),a

	ld a,$02
	call _ecom_getSideviewAdjacentWallsBitset
	call z,objectApplySpeed

_vire_batForm_animate:
	jp enemyAnimate


; About to charge toward Link in [counter1] frames
_vire_batForm_stateB:
	call _ecom_decCounter1
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
_vire_batForm_stateC:
	ld h,d
	ld l,Enemy.var35
	call _ecom_readPositionVars
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
	jr _vire_batForm_animate

@notReachedPosition:
	ld l,Enemy.zh
	ld a,(hl)
	cp $fe
	jr nc,+
	inc (hl)
+
	call _ecom_moveTowardPosition
	jr _vire_batForm_animate


; Moving back up after charging
_vire_batForm_stateD:
	call _ecom_decCounter1
	jp z,_vire_batForm_gotoStateA

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
	call _ecom_getSideviewAdjacentWallsBitset
	call z,objectApplySpeed
	jr _vire_batForm_animate


;;
; Sets Vire's position to just outside the camera (along with corresponding angle), and
; increments substate.
;
; @param[out]	hl	Enemy.substate
_vire_spawnOutsideCamera:
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
_vire_mainForm_leftScreen:
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
_vire_checkOffScreen:
	ld e,Enemy.yh
	ld a,(de)
	cp (LARGE_ROOM_HEIGHT<<4)+8
	ret nc
	ld e,Enemy.xh
	ld a,(de)
	cp (LARGE_ROOM_WIDTH<<4)
	ret


;;
_vire_mainForm_circleAroundScreen:
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
_vire_mainForm_applySpeedAndAnimate:
	call objectApplySpeed
	jp enemyAnimate

;;
; @param[out]	cflag	c if Link is too close (Vire will flee)
_vire_mainForm_checkLinkTooClose:
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
_vire_mainForm_fireProjectile:
	call getRandomNumber_noPreserveVars
	and $01
	inc a
	ld b,a

;;
; @param	b	Subid
_vire_mainForm_fireProjectileWithSubid:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_VIRE_PROJECTILE
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
_vire_batForm_moveAwayFromLinkIfTooClose:
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
	jp _ecom_applyGivenVelocity


;;
_vire_batForm_updateZPos:
	call _ecom_decCounter1
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


; ==============================================================================
; ENEMYID_ANGLER_FISH
;
; Variables:
;   relatedObj1: reference to other subid (main <-> antenna)
; ==============================================================================
enemyCode76:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@justHit

	; ENEMYSTATUS_DEAD
	ld e,Enemy.subid
	ld a,(de)
	or a
	jp z,_enemyBoss_dead
	call _ecom_killRelatedObj1
	jp enemyDelete

@justHit:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr z,@fishHit

@antennaHit:
	ld a,Object.invincibilityCounter
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(de)
	ld (hl),a
	jr @normalStatus

@fishHit:
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_SCENT_SEED
	jr nz,@normalStatus

	ld h,d
	ld l,Enemy.state
	ld (hl),$0d

	ld l,Enemy.collisionType
	res 7,(hl)

	ld e,Enemy.direction
	ld a,(de)
	and $01
	add $04
	ld (de),a
	call enemySetAnimation

	ld b,INTERACID_EXPLOSION
	call objectCreateInteractionWithSubid00

@normalStatus:
	call _ecom_getSubidAndCpStateTo08
	jr c,@commonState
	ld a,b
	or a
	jp z,anglerFish_main
	jp _anglerFish_antenna

@commonState:
	rst_jumpTable
	.dw _anglerFish_state_uninitialized
	.dw _anglerFish_state_stub
	.dw _anglerFish_state_stub
	.dw _anglerFish_state_stub
	.dw _anglerFish_state_stub
	.dw _anglerFish_state_stub
	.dw _anglerFish_state_stub
	.dw _anglerFish_state_stub


_anglerFish_state_uninitialized:
	ld a,$ff
	ld b,$00
	call _enemyBoss_initializeRoom

	; If bit 7 of subid is set, it's already been initialized
	ld e,Enemy.subid
	ld a,(de)
	bit 7,a
	res 7,a
	ld (de),a
	jr nz,@doneInit

	; Subid 1 has no special initialization
	dec a
	jr z,@doneInit

	; Subid 0 initialization; spawn subid 1, set their relatedObj1 to each other
	ld b,ENEMYID_ANGLER_FISH
	call _ecom_spawnUncountedEnemyWithSubid01
	ret nz
	ld e,Enemy.relatedObj1
	ld l,e
	ld a,Enemy.start
	ld (de),a
	ldi (hl),a
	inc e
	ld (hl),d
	ld a,h
	ld (de),a

	; Make sure subid 0 comes before subid 1, otherwise swap them
	ld a,h
	cp d
	jr nc,@doneInit
	ld l,Enemy.subid
	ld (hl),$80
	ld e,l
	ld a,$01
	ld (de),a
@doneInit:
	jp _ecom_setSpeedAndState8


_anglerFish_state_stub:
	ret


anglerFish_main:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw anglerFish_main_state8
	.dw anglerFish_main_state9
	.dw anglerFish_main_stateA
	.dw anglerFish_main_stateB
	.dw anglerFish_main_stateC
	.dw anglerFish_main_stateD
	.dw anglerFish_main_stateE
	.dw anglerFish_main_stateF


; Waiting for Link to enter
anglerFish_main_state8:
	ld a,(w1Link.state)
	cp LINK_STATE_FORCE_MOVEMENT
	ret z
	call checkLinkVulnerable
	ret nc

	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,$42
	ld c,$80
	call setTile
	ld a,$52
	ld c,$90
	call setTile

	call _ecom_incState
	ld l,Enemy.counter1
	ld (hl),30
	ld a,SND_DOORCLOSE
	jp playSound


; Delay before starting fight
anglerFish_main_state9:
	call _ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.angle
	ld (hl),ANGLE_LEFT
	ld l,Enemy.speed
	ld (hl),SPEED_c0

	jp objectSetVisible82


; Falling to the ground, then the fight will begin
anglerFish_main_stateA:
	ld b,$0c
	ld a,$10
	call objectUpdateSpeedZ_sidescroll_givenYOffset
	jr c,@hitGround

	ld l,Enemy.speedZ+1
	ld a,(hl)
	cp $02
	ret c
	ld (hl),$02
	ret

@hitGround:
	call _enemyBoss_beginMiniboss
	call _ecom_incState

	ld l,Enemy.counter2
	ld (hl),180

_anglerFish_bounceOffGround:
	ld h,d
	ld l,Enemy.speedZ
	ld a,<(-$320)
	ldi (hl),a
	ld (hl),>(-$320)

	ld a,SND_POOF
	jp playSound


; Bouncing around normally
anglerFish_main_stateB:
	call _ecom_decCounter2
	call z,anglerFish_main_checkFireProjectile

_anglerFish_updatePosition:
	ld b,$0c
	ld a,$10
	call objectUpdateSpeedZ_sidescroll_givenYOffset
	jr nc,_anglerFish_applySpeed

	; Hit ground
	call _anglerFish_bounceOffGround

	call getRandomNumber_noPreserveVars
	and $10
	add $08
	ld e,Enemy.angle
	ld (de),a

	and $10
	xor $10
	swap a
	ld b,a
	ld e,Enemy.direction
	ld a,(de)
	and $01
	cp b
	call nz,_anglerFish_updateAnimation

_anglerFish_applySpeed:
	call objectApplySpeed
	call _ecom_bounceOffWallsAndHoles
	jp z,enemyAnimate

_anglerFish_updateAnimation:
	ld e,Enemy.direction
	ld a,(de)
	xor $01
	ld (de),a
	jp enemySetAnimation


; Firing a projectile
anglerFish_main_stateC:
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr z,@doneFiring
	dec a
	jr z,_anglerFish_updatePosition

	; Time to spawn the projectile
	xor a
	ld (de),a
	call getFreeEnemySlot_uncounted
	jr nz,_anglerFish_updatePosition

	ld (hl),ENEMYID_ANGLER_FISH_BUBBLE
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld a,SND_FALLINHOLE
	call playSound
	jr _anglerFish_updatePosition

@doneFiring:
	ld h,d
	ld l,Enemy.state
	dec (hl)

	ld l,Enemy.direction
	ld a,(hl)
	sub $02
	ld (hl),a
	call enemySetAnimation

	jr _anglerFish_updatePosition


; Just hit with a scent seed, falling to ground
anglerFish_main_stateD:
	ld a,$20
	call objectUpdateSpeedZ_sidescroll
	ret nc

	call _ecom_incState
	ld l,Enemy.counter1
	ld (hl),150
	ret


; Vulnerable for [counter1] frames
anglerFish_main_stateE:
	call _ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speedZ
	ld a,<(-$400)
	ldi (hl),a
	ld (hl),>(-$400)
	ret


; Bouncing back up after being deflated
anglerFish_main_stateF:
	ld a,$20
	call objectUpdateSpeedZ_sidescroll

	ld l,Enemy.speedZ+1
	ld a,(hl)
	or a
	jr nz,_anglerFish_applySpeed

	ld l,Enemy.state
	ld (hl),$0b

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.counter1
	ld (hl),180

	ld l,Enemy.direction
	ld a,(hl)
	sub $04
	ld (hl),a
	call enemySetAnimation

	ld a,SND_POOF
	jp playSound


_anglerFish_antenna:
	ld a,(de)
	cp $08
	jr z,@state8

@state9:
	ld a,Object.direction
	call objectGetRelatedObject1Var
	ld a,(hl)
	push hl

	ld hl,@positionOffsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)

	pop hl
	call objectTakePositionWithOffset
	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	jp nz,objectSetInvisible

	ld a,(wFrameCounter)
	rrca
	ret c
	jp _ecom_flickerVisibility

@positionOffsets:
	.db $f0 $f6
	.db $f0 $0a
	.db $f0 $f6
	.db $f0 $0a
	.db $fc $f7
	.db $fc $09

@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_ANGLER_FISH_ANTENNA

	ld l,Enemy.collisionRadiusY
	ld a,$03
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.oamTileIndexBase
	ld (hl),$1e

	ld l,Enemy.oamFlagsBackup
	ld a,$0d
	ldi (hl),a
	ld (hl),a

	ld a,$06
	jp enemySetAnimation

;;
; Changes state to $0c if conditions are appropriate to fire a projectile.
anglerFish_main_checkFireProjectile:
	ld e,Enemy.yh
	ld a,(de)
	cp $5c
	ret nc
	ld e,Enemy.xh
	ld a,(de)
	sub $38
	cp $70
	ret nc

	ld (hl),180
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.direction
	ld a,(hl)
	add $02
	ld (hl),a
	jp enemySetAnimation


; ==============================================================================
; ENEMYID_BLUE_STALFOS
;
; Variables (for subid 1, "main" enemy):
;   var30/var31: Destination position while moving
;   var32: Projectile pattern index; number from 0-7 which cycles through ball types.
;          (Used by PARTID_BLUE_STALFOS_PROJECTILE.)
;
; Variables (for subid 3, the afterimage):
;   var30/var31: Y/X position?
;   var32: Index in position differenc buffer?
;   var33-var3a: Position difference buffer?
; ==============================================================================
enemyCode77:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,_enemyBoss_dead
	dec a
	jr nz,@normalStatus

@normalStatus:
	call _ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw _blueStalfos_state_uninitialized
	.dw _blueStalfos_state_spawner
	.dw _blueStalfos_state_stub
	.dw _blueStalfos_state_stub
	.dw _blueStalfos_state_stub
	.dw _blueStalfos_state_stub
	.dw _blueStalfos_state_stub
	.dw _blueStalfos_state_stub

@normalState:
	dec b
	ld a,b
	rst_jumpTable
	.dw _blueStalfos_subid1
	.dw _blueStalfos_subid2
	.dw _blueStalfos_subid3


_blueStalfos_state_uninitialized:
	ld a,b
	sub $02
	call c,objectSetVisible82
	ld a,b
	or a
	jp nz,_ecom_setSpeedAndState8

	; Spawner (subid 0) only
	call _ecom_incState
	ld l,Enemy.zh
	ld (hl),$ff
	ld a,ENEMYID_BLUE_STALFOS
	jp _enemyBoss_initializeRoom


_blueStalfos_state_spawner:
	ld b,$03
	call checkBEnemySlotsAvailable
	ret nz

	; Spawn subid 1
	ld b,ENEMYID_BLUE_STALFOS
	call _ecom_spawnUncountedEnemyWithSubid01
	call objectCopyPosition
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	; Spawn subid 2
	ld c,h
	call _ecom_spawnUncountedEnemyWithSubid01
	inc (hl)

	; [subid2.relatedObj1] = subid1
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c

	call objectCopyPosition

	; Spawn subid 3
	call _ecom_spawnUncountedEnemyWithSubid01
	ld (hl),$03

	; [subid3.relatedObj1] = subid1
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c

	call objectCopyPosition

	jp enemyDelete


_blueStalfos_state_stub:
	ret


_blueStalfos_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw _blueStalfos_main_state08
	.dw _blueStalfos_main_state09
	.dw _blueStalfos_main_state0a
	.dw _blueStalfos_main_state0b
	.dw _blueStalfos_main_state0c
	.dw _blueStalfos_main_state0d
	.dw _blueStalfos_main_state0e
	.dw _blueStalfos_main_state0f
	.dw _blueStalfos_main_state10
	.dw _blueStalfos_main_state11
	.dw _blueStalfos_main_state12
	.dw _blueStalfos_main_state13
	.dw _blueStalfos_main_state14
	.dw _blueStalfos_main_state15
	.dw _blueStalfos_main_state16
	.dw _blueStalfos_main_state17


_blueStalfos_main_state08:
	ld bc,$010b
	call _enemyBoss_spawnShadow
	ret nz

	call _ecom_incState

	ld l,Enemy.speed
	ld (hl),SPEED_200
	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN
	ret


; Moving down before fight starts
_blueStalfos_main_state09:
	call objectApplySpeed
	ld e,Enemy.yh
	ld a,(de)
	cp $58
	jr nz,_blueStalfos_main_animate

	; Fight starts now
	call _ecom_incState

	ld l,Enemy.counter1
	ld (hl),$40
	ld l,Enemy.speed
	ld (hl),SPEED_20

	ld a,MUS_MINIBOSS
	ld (wActiveMusic),a
	call playSound

	ld e,$0f
	ld bc,$3030
	call _ecom_randomBitwiseAndBCE
	ld a,e
	jp _blueStalfos_main_moveToQuadrant


; Moving to position in var30/var31
_blueStalfos_main_state0a:
	ld h,d
	ld l,Enemy.var30
	call _ecom_readPositionVars
	sub c
	add $04
	cp $09
	jr nc,@moveToPosition

	ldh a,(<hFF8F)
	sub b
	add $04
	cp $09
	jr nc,@moveToPosition

	; Reached target position
	ld h,d
	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.counter1
	ld (hl),$10
	jr _blueStalfos_main_animate

@moveToPosition:
	call _blueStalfos_main_accelerate
	call _ecom_moveTowardPosition
	jr _blueStalfos_main_animate


; Reached position, standing still for [counter1] frames
_blueStalfos_main_state0b:
	call _ecom_decCounter1
	jr nz,_blueStalfos_main_animate

	ld l,e
	inc (hl) ; [state]

_blueStalfos_main_animate:
	jp enemyAnimate


; Decide which attack to do
_blueStalfos_main_state0c:
	ld e,Enemy.yh
	ld a,(de)
	add $10
	ld b,a
	ld e,Enemy.xh
	ld a,(de)
	add $04
	ld c,a

	; If Link is close enough, use the sickle on him
	ldh a,(<hEnemyTargetY)
	sub b
	add $14
	cp $29
	jr nc,@projectileAttack
	ldh a,(<hEnemyTargetX)
	sub c
	add $12
	cp $25
	jp c,_blueStalfos_main_beginSickleAttack

@projectileAttack:
	ld b,PARTID_BLUE_STALFOS_PROJECTILE
	call _ecom_spawnProjectile
	ret nz
	ld h,d
	ld l,Enemy.counter1
	ld (hl),120
	ld l,Enemy.state
	ld (hl),$0e
	ld a,$02
	jp enemySetAnimation


; Sickle attack
_blueStalfos_main_state0d:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr z,_blueStalfos_main_finishedAttack

	dec a
	ret nz

	ld a,$08
	ld (de),a ; [animParameter]

	ld a,SND_SWORDSPIN
	jp playSound


; Charging a projectile
_blueStalfos_main_state0e:
	call _ecom_decCounter1
	jr nz,_blueStalfos_main_animate

	ld (hl),60
	ld l,e
	inc (hl) ; [state]
	ld a,$03
	jp enemySetAnimation


; Just fired projectile
_blueStalfos_main_state0f:
	call _ecom_decCounter1
	ret nz

_blueStalfos_main_finishedAttack:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0a
	ld l,Enemy.counter1
	ld (hl),$40
	ld l,Enemy.speed
	ld (hl),SPEED_20
	xor a
	call enemySetAnimation
	jp _blueStalfos_main_decideNextPosition


; Link just turned into a baby; about to turn transparent and warp to top of room
_blueStalfos_main_state10:
	call _ecom_decCounter1
	jr nz,_blueStalfos_main_animate

	ld (hl),$10 ; [counter1]
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.collisionType
	res 7,(hl)
	ret


; Now transparent; waiting for [counter1] frames before warping
_blueStalfos_main_state11:
	call _ecom_decCounter1
	jp nz,_ecom_flickerVisibility

	ld (hl),$08 ; [counter1]
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.yh
	ld (hl),$0c
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	ld (hl),a

	xor a
	call enemySetAnimation
	jp objectSetInvisible


; Just warped to top of room; standing in place
_blueStalfos_main_state12:
	call _ecom_decCounter1
	jp nz,_ecom_flickerVisibility

	ld l,Enemy.angle
	ld (hl),$10

	ld l,e
	inc (hl) ; [state]

	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@speedTable
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a

	jp objectSetVisible82

@speedTable:
	.db SPEED_180, SPEED_1c0, SPEED_200, SPEED_300


; Moving down toward baby Link before attacking with sickle
_blueStalfos_main_state13:
	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	cp $18
	jp nc,objectApplySpeed

_blueStalfos_main_beginSickleAttack:
	ld e,Enemy.state
	ld a,$0d
	ld (de),a
	ld a,$01
	jp enemySetAnimation


; Just hit by PARTID_BLUE_STALFOS_PROJECTILE; turning into a small bat
_blueStalfos_main_state14:
	call _blueStalfos_createPuff
	ret nz

	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.collisionRadiusY
	ld (hl),$02
	inc l
	ld (hl),$06

	ld l,Enemy.counter1
	ld (hl),$f0
	inc l
	ld (hl),$00 ; [counter2]

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	call objectSetInvisible

	ld a,SND_SCENT_SEED
	call playSound

	ld a,$04
	jp enemySetAnimation


; Transforming into bat
_blueStalfos_main_state15:
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret nz

	call _ecom_incState

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLUE_STALFOS_BAT

	ld l,Enemy.zh
	ld (hl),$00

	jp objectSetVisiblec2


; Flying around as a bat
_blueStalfos_main_state16:
	call _ecom_decCounter1
	jr nz,@flyAround

	; Time to transform back into stalfos

	inc (hl) ; [counter1] = 1
	call _blueStalfos_createPuff
	ret nz

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLUE_STALFOS
	ld l,Enemy.zh
	ld (hl),$ff
	jp objectSetInvisible

@flyAround:
	call _ecom_decCounter2
	jr nz,++
	ld (hl),30 ; [counter2]
	call _ecom_setRandomAngle
++
	call _ecom_bounceOffWallsAndHoles
	call objectApplySpeed
	jp enemyAnimate


; Transforming back into stalfos
_blueStalfos_main_state17:
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret nz

	ld e,Enemy.collisionRadiusY
	ld a,$08
	ld (de),a
	inc e
	ld (de),a

	call _blueStalfos_main_finishedAttack
	ld a,SND_SCENT_SEED
	call playSound
	jp objectSetVisible82


; Hitbox for the sickle (invisible)
_blueStalfos_subid2:
	ld a,(de)
	sub $08
	jr z,_blueStalfos_initSubid2Or3

@state9:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMYID_BLUE_STALFOS
	jp nz,enemyDelete

	; [this.collisionType] = [subid0.collisionType]
	ld l,Enemy.collisionType
	ld e,l
	ld a,(hl)
	ld (de),a

	; Set collision and hitbox based on [subid0.animParameter]
	ld l,Enemy.animParameter
	ld a,(hl)
	cp $ff
	jr nz,+
	ld a,$0c
+
	ld bc,@positionAndHitboxTable
	call addAToBc

	ld l,Enemy.yh
	ld e,l
	ld a,(bc)
	add (hl)
	ld (de),a

	inc bc
	ld l,Enemy.xh
	ld e,l
	ld a,(bc)
	add (hl)
	ld (de),a

	inc bc
	ld e,Enemy.collisionRadiusY
	ld a,(bc)
	ld (de),a

	inc bc
	inc e
	ld a,(bc)
	ld (de),a

	; If collision size is 0, disable collisions
	or a
	ret nz
	ld h,d
	ld l,Enemy.collisionType
	res 7,(hl)
	ret

; Data format:
;   b0: Y offset
;   b1: X offset
;   b2: collisionRadiusY
;   b3: collisionRadiusX
@positionAndHitboxTable:
	.db $04 $0d $08 $03
	.db $f0 $04 $03 $0a
	.db $0c $06 $14 $0c
	.db $14 $fc $04 $0a
	.db $f4 $0e $04 $06
	.db $f6 $0c $04 $06
	.db $f4 $0a $04 $06
	.db $f2 $0c $04 $06
	.db $00 $00 $00 $00


_blueStalfos_initSubid2Or3:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLUE_STALFOS_SICKLE

	ld a,Object.zh
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(hl)
	ld (de),a
	ret


; "Afterimage" of blue stalfos visible while moving
_blueStalfos_subid3:
	ld a,(de)
	sub $08
	jr z,@state8

@state9:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMYID_BLUE_STALFOS
	jp nz,enemyDelete

	ld l,Enemy.state
	ld a,(hl)
	cp $12
	jp z,_blueStalfos_afterImage_resetPositionVars

	cp $14
	call nc,objectSetVisible82

	; Calculate Y-diff, update var30 (last frame's Y-position)
	ld l,Enemy.yh
	ld e,Enemy.var30
	ld a,(de)
	ld b,a
	ld a,(hl)
	sub b
	add $08
	and $0f
	swap a
	ld c,a
	ldi a,(hl)
	ld (de),a

	; Calculate X-diff, update var31 (last frame's Y-position)
	inc l
	inc e
	ld a,(de)
	ld b,a
	ld a,(hl)
	sub b
	add $08
	and $0f
	or c
	ld c,a
	ld a,(hl)
	ld (de),a

	; Write position difference to offset buffer
	ld e,Enemy.var32
	ld a,(de)
	add Enemy.var33
	ld e,a
	ld a,c
	ld (de),a

	; Increment index in offset buffer
	ld e,Enemy.var32
	ld a,(de)
	inc a
	and $07
	ld (de),a

	; Don't draw if difference is 0
	add Enemy.var33
	ld e,a
	ld a,(de)
	cp $88
	ld b,a
	jp z,objectSetInvisible

	; Update position based on offset, draw afterimage
	ld h,d
	ld l,Enemy.yh
	and $f0
	swap a
	sub $08
	add (hl)
	ldi (hl),a
	inc l
	ld a,b
	and $0f
	sub $08
	add (hl)
	ld (hl),a

	jp _ecom_flickerVisibility

@state8:
	call _blueStalfos_initSubid2Or3
	call _blueStalfos_afterImage_resetPositionVars
	ld l,Enemy.collisionType
	res 7,(hl)
	call objectSetVisible83
	jp objectSetInvisible


;;
; Decides the next position for the blue stalfos. It will always choose a different
; quadrant of the screen from the one it's in already.
_blueStalfos_main_decideNextPosition:
	ld e,$03
	ld bc,$3030
	call _ecom_randomBitwiseAndBCE

	ld h,e
	ld l,$00
	ld e,Enemy.yh
	ld a,(de)
	cp (LARGE_ROOM_HEIGHT<<4)/2
	jr c,+
	ld l,$02
+
	ld e,Enemy.xh
	ld a,(de)
	cp (LARGE_ROOM_WIDTH<<4)/2
	jr c,+
	inc l
+
	ld a,l
	add a
	add a
	add h


;;
; @param	a	Position index to use
; @param	bc	Offset to be added to target position
_blueStalfos_main_moveToQuadrant:
	ld hl,@quadrantList
	rst_addAToHl
	call @getLinkQuadrant
	cp (hl)
	jr z,@moveToLinksPosition

	ld a,(hl)
	ld hl,@targetPositions
	rst_addAToHl
	ld e,Enemy.var30
	ldi a,(hl)
	add b
	ld (de),a
	inc e
	ld a,(hl)
	add c
	ld (de),a
	ret

@moveToLinksPosition:
	ld e,Enemy.var30
	ldh a,(<hEnemyTargetY)
	sub $14
	ld (de),a
	inc e
	ldh a,(<hEnemyTargetX)
	ld (de),a
	ret

;;
; @param[out]	a	The quadrant of the screen Link is in.
;			(0/2/4/6 for up/left, up/right, down/left, down/right)
@getLinkQuadrant:
	ld e,$00
	ldh a,(<hEnemyTargetY)
	cp (LARGE_ROOM_HEIGHT<<4)/2
	jr c,+
	ld e,$02
+
	ldh a,(<hEnemyTargetX)
	cp (LARGE_ROOM_WIDTH<<4)/2
	jr c,+
	inc e
+
	ld a,e
	add a
	ret

@quadrantList:
	.db $02 $04 $06 $04 ; Currently in TL quadrant
	.db $00 $06 $04 $06 ; Currently in TR quadrant
	.db $00 $02 $06 $02 ; Currently in BL quadrant
	.db $00 $02 $04 $00 ; Currently in BR quadrant

@targetPositions:
	.dw $3828
	.dw $8828
	.dw $3868
	.dw $8868


;;
_blueStalfos_main_accelerate:
	ld e,Enemy.counter1
	ld a,(de)
	or a
	ret z

	dec a
	ld (de),a

	and $03
	ret nz

	ld e,Enemy.speed
	ld a,(de)
	add SPEED_20
	ld (de),a
	ret


;;
_blueStalfos_afterImage_resetPositionVars:
	; [this.position] = [parent.position]
	; (Also copy position to var30/var31)
	ld l,Enemy.yh
	ld e,l
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.var30

	ld (de),a
	inc l
	ld e,l
	ld a,(hl)
	ld (de),a
	ld e,Enemy.var31
	ld (de),a

	ld h,d
	ld l,Enemy.var32
	xor a
	ldi (hl),a

	; Initialize "position offset" buffer
	ld a,$88
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ret

;;
_blueStalfos_createPuff:
	ldbc INTERACID_PUFF,$02
	call objectCreateInteraction
	ret nz

	ld a,h
	ld h,d
	ld l,Enemy.relatedObj2+1
	ldd (hl),a
	ld (hl),Interaction.start
	ret


; ==============================================================================
; ENEMYID_PUMPKIN_HEAD
;
; Variables (body, subid 1):
;   relatedObj1: Reference to ghost
;   relatedObj2: Reference to head
;   var30: Stomp counter (stops stomping when it reaches 0)
;
; Variables (ghost, subid 2):
;   relatedObj1: Reference to body
;   var33/var34: Head's position (where ghost is moving toward)
;
; Variables (head, subid 3):
;   relatedObj1: Reference to body
;   var31: Link's direction last frame
;   var32: Head's orientation when it was picked up
; ==============================================================================
enemyCode78:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	jr @normalStatus

@dead:
	call _pumpkinHead_noHealth
	ret z

@normalStatus:
	call _ecom_getSubidAndCpStateTo08
	jr c,@commonState
	dec b
	ld a,b
	rst_jumpTable
	.dw _pumpkinHead_body
	.dw _pumpkinHead_ghost
	.dw _pumpkinHead_head

@commonState:
	rst_jumpTable
	.dw _pumpkinHead_state_uninitialized
	.dw _pumpkinHead_state_spawner
	.dw _pumpkinHead_state_grabbed
	.dw _pumpkinHead_state_stub
	.dw _pumpkinHead_state_stub
	.dw _pumpkinHead_state_stub
	.dw _pumpkinHead_state_stub
	.dw _pumpkinHead_state_stub


_pumpkinHead_state_uninitialized:
	ld a,b
	or a
	jp nz,_ecom_setSpeedAndState8

	; Subid 0 (spawner)
	inc a
	ld (de),a ; [state] = 1
	ld a,ENEMYID_PUMPKIN_HEAD
	ld b,$00
	jp _enemyBoss_initializeRoom


_pumpkinHead_state_spawner:
	; Wait for doors to close
	ld a,($cc93)
	or a
	ret nz

	ld b,$03
	call checkBEnemySlotsAvailable
	ret nz

	; Spawn body
	ld b,ENEMYID_PUMPKIN_HEAD
	call _ecom_spawnUncountedEnemyWithSubid01
	call objectCopyPosition
	ld c,h

	; Spawn ghost
	call _ecom_spawnUncountedEnemyWithSubid01
	call @commonInit

	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	; [body.relatedObj1] = ghost
	ld a,h
	ld h,c
	ld l,Enemy.relatedObj1+1
	ldd (hl),a
	ld (hl),Enemy.start

	; Spawn head
	call _ecom_spawnUncountedEnemyWithSubid01
	inc (hl)
	call @commonInit

	; [body.relatedObj2] = head
	ld a,h
	ld h,c
	ld l,Enemy.relatedObj2+1
	ldd (hl),a
	ld (hl),Enemy.start

	; Delete spawner
	jp enemyDelete

@commonInit:
	inc (hl) ; [subid]++

	; [relatedObj1] = body
	ld l,Enemy.relatedObj1
	ld (hl),Enemy.start
	inc l
	ld (hl),c

	jp objectCopyPosition


_pumpkinHead_state_grabbed:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @atRest

@justGrabbed:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	xor a
	ld (wLinkGrabState2),a

	ld l,Enemy.var31
	ld a,(w1Link.direction)
	ld (hl),a

	ld l,Enemy.direction
	ld e,Enemy.var32
	ld a,(hl)
	ld (de),a

	; [ghost.state] = $13
	ld a,Object.relatedObj1+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.state
	ld a,(hl)
	ld (hl),$13

	cp $13
	jr nc,++
	ld l,Enemy.zh
	ld (hl),$f8
	ld l,Enemy.invincibilityCounter
	ld (hl),$f4
++
	jp objectSetVisiblec1

@beingHeld:
	; Update animation based on Link's facing direction
	ld a,(w1Link.direction)
	ld h,d
	ld l,Enemy.var31
	cp (hl)
	ret z

	ld (hl),a

	ld l,Enemy.var32
	add (hl)
	and $03
	add a
	ld l,Enemy.direction
	ld (hl),a
	jp enemySetAnimation

@released:
	ret

@atRest:
	; [ghost.state] = $15
	ld a,Object.relatedObj1+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.state
	ld (hl),$15

	; [head.state] = $16
	ld h,d
	ld (hl),$16

	jp objectSetVisiblec2


_pumpkinHead_state_stub:
	ret


_pumpkinHead_body:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw _pumpkinHead_body_state08
	.dw _pumpkinHead_body_state09
	.dw _pumpkinHead_body_state0a
	.dw _pumpkinHead_body_state0b
	.dw _pumpkinHead_body_state0c
	.dw _pumpkinHead_body_state0d
	.dw _pumpkinHead_body_state0e
	.dw _pumpkinHead_body_state0f
	.dw _pumpkinHead_body_state10
	.dw _pumpkinHead_body_state11
	.dw _pumpkinHead_body_state12
	.dw _pumpkinHead_body_state13


; Initialization
_pumpkinHead_body_state08:
	ld bc,$0106
	call _enemyBoss_spawnShadow
	ret nz

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.oamFlags
	ld a,$01
	ldd (hl),a
	ld (hl),a

	call objectSetVisible83

	ld c,$08
	call _ecom_setZAboveScreen

	ld a,$0d
	jp enemySetAnimation


; Falling from ceiling
_pumpkinHead_body_state09:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN

	ld a,30

_pumpkinHead_body_shakeScreen:
	call setScreenShakeCounter
	ld a,SND_DOORCLOSE
	jp playSound


; Waiting for head to catch up with body
_pumpkinHead_body_state0a:
	ld a,Object.zh
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $f0
	ret c

	call _ecom_decCounter1
	ret nz

	call _pumpkinHead_body_chooseRandomStompTimerAndCount
	jr _pumpkinHead_body_beginMoving


; Walking around
_pumpkinHead_body_state0b:
	call pumpkinHead_body_countdownUntilStomp
	ret z

	call _ecom_decCounter1
	jr z,_pumpkinHead_body_chooseNextAction

	call _ecom_applyVelocityForSideviewEnemyNoHoles
	jr z,_pumpkinHead_body_chooseNextAction

	jp enemyAnimate


_pumpkinHead_body_chooseNextAction:
	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	ld b,a

	ld e,Enemy.angle
	ld a,(de)
	cp b
	jr nz,_pumpkinHead_body_beginMoving

	; Currently facing toward Link. 1 in 4 chance of head firing projectiles.
	call getRandomNumber_noPreserveVars
	cp $40
	jr c,_pumpkinHead_body_beginMoving

	; Head will fire projectiles.
	call _ecom_incState
	ld l,Enemy.counter1
	ld (hl),$38

	; [head.state] = $0b
	ld a,Object.state
	call objectGetRelatedObject2Var
	inc (hl)

	jr _pumpkinHead_body_updateAnimationFromAngle


; Head is firing projectiles; waiting for it to finish.
_pumpkinHead_body_state0c:
	call _ecom_decCounter1
	ret nz

_pumpkinHead_body_beginMoving:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0b

	ld l,Enemy.speed
	ld (hl),SPEED_80

	; Random duration of time to walk
	call getRandomNumber_noPreserveVars
	and $0f
	ld hl,_pumpkinHead_body_walkDurations
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a

	call _ecom_setRandomCardinalAngle

_pumpkinHead_body_updateAnimationFromAngle:
	ld e,Enemy.angle
	ld a,(de)
	swap a
	rlca
	ld b,a

	ld hl,_pumpkinHead_body_collisionRadiusXVals
	rst_addAToHl
	ld e,Enemy.collisionRadiusX
	ld a,(hl)
	ld (de),a

	ld a,b
	add $0b
	jp enemySetAnimation


_pumpkinHead_body_walkDurations:
	.db 30, 30, 60, 60, 60, 60,  60,  90
	.db 90, 90, 90, 90, 90, 120, 120, 120

_pumpkinHead_body_collisionRadiusXVals:
	.db $0c $08 $0c $08


; Preparing to stomp
_pumpkinHead_body_state0d:
	call _ecom_decCounter1
	jr z,_pumpkinHead_body_beginStomp

	ld a,(hl)
	rrca
	ret nc
	call _ecom_updateCardinalAngleTowardTarget
	jr _pumpkinHead_body_updateAnimationFromAngle

_pumpkinHead_body_beginStomp:
	ld l,Enemy.state
	ld (hl),$0e

	ld l,Enemy.speedZ
	ld a,<(-$3a0)
	ldi (hl),a
	ld (hl),>(-$3a0)

	ld l,Enemy.speed
	ld (hl),SPEED_100

	; [ghost.state] = $0c
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld (hl),$0c

	; [head.state] = $0e
	ld a,Object.state
	call objectGetRelatedObject2Var
	ld (hl),$0e

	; Update angle based on direction toward Link
	call _ecom_updateAngleTowardTarget
	add $04
	and $18
	swap a
	rlca
	ld b,a
	ld hl,_pumpkinHead_body_collisionRadiusXVals
	rst_addAToHl
	ld e,Enemy.collisionRadiusX
	ld a,(hl)
	ld (de),a

	ld a,b
	add $0b
	call enemySetAnimation
	jp objectSetVisible81


; In midair during stomp
_pumpkinHead_body_state0e:
	ld c,$30
	call objectUpdateSpeedZ_paramC
	jp nz,_ecom_applyVelocityForSideviewEnemyNoHoles

	; Hit ground

	ld l,Enemy.state
	inc (hl)

	ld e,Enemy.var30
	ld a,(de)
	dec a
	ld a,15
	jr nz,+
	ld a,30
+
	ld l,Enemy.counter1
	ld (hl),a

	ld a,20
	call _pumpkinHead_body_shakeScreen
	jp objectSetVisible83


; Landed after a stomp
_pumpkinHead_body_state0f:
	call _ecom_decCounter1
	ret nz

	ld l,Enemy.var30
	dec (hl)
	jr nz,_pumpkinHead_body_beginStomp
	jp _pumpkinHead_body_beginMoving


; Body has been destroyed
_pumpkinHead_body_state10:
	ret


; Head has moved up, body will now regenerate
_pumpkinHead_body_state11:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$08
	ld l,Enemy.angle
	ld (hl),$10
	jp objectCreatePuff


; Delay before making body visible
_pumpkinHead_body_state12:
	call _ecom_decCounter1
	ret nz

	ld (hl),30 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	call objectSetVisible83

	ld a,$0d
	jp enemySetAnimation


; Body has regenerated, waiting a moment before resuming
_pumpkinHead_body_state13:
	call _ecom_decCounter1
	ret nz

	ld l,Enemy.collisionType
	set 7,(hl)

	call _pumpkinHead_body_chooseRandomStompTimerAndCount
	jp _pumpkinHead_body_beginMoving


_pumpkinHead_ghost:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw _pumpkinHead_ghost_state08
	.dw _pumpkinHead_ghost_state09
	.dw _pumpkinHead_ghost_state0a
	.dw _pumpkinHead_ghost_state0b
	.dw _pumpkinHead_ghost_state0c
	.dw _pumpkinHead_ghost_state0d
	.dw _pumpkinHead_ghost_state0e
	.dw _pumpkinHead_ghost_state0f
	.dw _pumpkinHead_ghost_state10
	.dw _pumpkinHead_ghost_state11
	.dw _pumpkinHead_ghost_state12
	.dw _pumpkinHead_ghost_state13
	.dw _pumpkinHead_ghost_state14
	.dw _pumpkinHead_ghost_state15
	.dw _pumpkinHead_ghost_state16
	.dw _pumpkinHead_ghost_state17


; Initialization
_pumpkinHead_ghost_state08:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PUMPKIN_HEAD_GHOST

	ld l,Enemy.oamFlags
	ld a,$05
	ldd (hl),a
	ld (hl),a

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.collisionRadiusY
	ld a,$06
	ldi (hl),a
	ld (hl),a

	call objectSetVisible83
	ld c,$20
	call _ecom_setZAboveScreen

	ld a,$0a
	jp enemySetAnimation


; Falling from ceiling. (Also called by "head" state 9.)
_pumpkinHead_ghost_state09:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ld l,Enemy.zh
	ld a,(hl)
	cp $f0
	ret c

	ld (hl),$f0
	ld l,Enemy.state
	inc (hl)
	ret


; Waiting for head to fall into place
_pumpkinHead_ghost_state0a:
	; Check [head.zh]
	ld a,Object.relatedObj2+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.zh
	ld a,(hl)
	cp $f0
	ret nz

	ld e,Enemy.state
	ld a,$0b
	ld (de),a
	call objectSetInvisible


; Copy body's position
_pumpkinHead_ghost_state0b:
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	jp objectTakePosition


; Body just began stomping; is moving upward
_pumpkinHead_ghost_state0c:
	call _pumpkinHead_ghostOrHead_updatePositionWhileStompingUp
	ret nz

	call _ecom_incState
	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a
	call objectSetVisible81


; Body is stomping; moving downward
_pumpkinHead_ghost_state0d:
	ld c,$28
	call _pumpkinHead_ghostOrHead_updatePositionWhileStompingDown
	ret c

	ld (hl),$f0 ; [zh]
	ld l,Enemy.state
	inc (hl)
	jp objectSetVisible83


; Reached target z-position after stomping; waiting for head to catch up
_pumpkinHead_ghost_state0e:
	ld a,Object.relatedObj2+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.zh
	ld a,(hl)
	cp $ee
	ret c

	ld e,Enemy.state
	ld a,$0b
	ld (de),a
	jp objectSetInvisible


; Body just destroyed
_pumpkinHead_ghost_state0f:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speedZ
	ld a,<(-$120)
	ldi (hl),a
	ld (hl),>(-$120)

	jp objectSetInvisible


; Falling to ground after body disappeared
_pumpkinHead_ghost_state10:
	ld c,$28
	call objectUpdateSpeedZ_paramC
	ret nz

	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),$08
	ret


; Delay before going to next state?
_pumpkinHead_ghost_state11:
	call _ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [state]
	ret


; Waiting for head to be picked up
_pumpkinHead_ghost_state12:
	ret


; Link just grabbed the head; ghost runs away
_pumpkinHead_ghost_state13:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),60

	ld l,Enemy.speed
	ld (hl),SPEED_140
	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.collisionType
	set 7,(hl)
	call objectSetVisiblec2

	call _ecom_updateCardinalAngleAwayFromTarget

	ld a,$0a
	jp enemySetAnimation


; Falling to ground, then running away with angle computed earlier
_pumpkinHead_ghost_state14:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call _ecom_decCounter1
	jr nz,++

	ld l,Enemy.state
	inc (hl)
	call objectSetVisible82
++
	call _ecom_applyVelocityForSideviewEnemyNoHoles
	jp enemyAnimate


; Stopped running away, or head just landed on ground
_pumpkinHead_ghost_state15:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),120
	ld a,$09
	jp enemySetAnimation


; After [counter1] frames, will choose which direction to move in next
_pumpkinHead_ghost_state16:
	call _ecom_decCounter1
	jr nz,@checkHeadOnGround

	ld (hl),60 ; [counter1]
	ld l,e
	dec (hl)
	dec (hl) ; [state] = $14

	call getRandomNumber_noPreserveVars
	and $1c
	ld e,Enemy.angle
	ld (de),a
	jr @setAnim

@checkHeadOnGround:
	; Check [head.state] to see if head is at rest on the ground
	ld a,Object.relatedObj2+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.state
	ld a,(hl)
	cp $02
	jp z,enemyAnimate

	ld h,d
	inc (hl) ; [this.state]

	; Copy head's position, use that as target position to move toward.
	; [this.var33] = [head.yh]
	ld a,Object.relatedObj2+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.yh
	ld e,Enemy.var33
	ldi a,(hl)
	ld (de),a

	; [this.var34] = [head.xh]
	inc l
	inc e
	ld a,(hl)
	ld (de),a

@setAnim:
	ld a,$0a
	jp enemySetAnimation


; Moving toward head (or where head used to be)
_pumpkinHead_ghost_state17:
	ld h,d
	ld l,Enemy.var33
	call _ecom_readPositionVars
	sub c
	add $08
	cp $11
	jr nc,@moveTowardHead
	ldh a,(<hFF8F)
	sub b
	add $08
	cp $11
	jr nc,@moveTowardHead

	; Reached head.

	; Check [head.state] to see if it's being held
	ld a,Object.relatedObj2+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.state
	ld a,(hl)
	cp $02
	ret z

	ld (hl),$13 ; [head.state] = $13

	ld h,d
	ld (hl),$0b ; [this.state] = $0b

	ld l,Enemy.collisionType
	res 7,(hl)
	jp objectSetInvisible

@moveTowardHead:
	call _ecom_moveTowardPosition
	jp enemyAnimate


_pumpkinHead_head:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw _pumpkinHead_head_state08
	.dw _pumpkinHead_head_state09
	.dw _pumpkinHead_head_state0a
	.dw _pumpkinHead_head_state0b
	.dw _pumpkinHead_head_state0c
	.dw _pumpkinHead_head_state0d
	.dw _pumpkinHead_head_state0e
	.dw _pumpkinHead_head_state0f
	.dw _pumpkinHead_head_state10
	.dw _pumpkinHead_head_state11
	.dw _pumpkinHead_head_state12
	.dw _pumpkinHead_head_state13
	.dw _pumpkinHead_head_state14
	.dw _pumpkinHead_head_state15
	.dw _pumpkinHead_head_state16


; Initialization
_pumpkinHead_head_state08:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.angle
	ld (hl),$ff

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PUMPKIN_HEAD_HEAD

	ld l,Enemy.collisionRadiusY
	ld (hl),$06

	call objectSetVisible82
	ld c,$30
	call _ecom_setZAboveScreen

	ld a,$04
	ld b,$00

;;
_pumpkinHead_head_setAnimation:
	ld e,Enemy.direction
	ld (de),a
	add b
	ld b,a
	srl a
	ld hl,@collisionRadiusXVals
	rst_addAToHl
	ld e,Enemy.collisionRadiusX
	ld a,(hl)
	ld (de),a
	ld a,b
	jp enemySetAnimation

@collisionRadiusXVals:
	.db $08 $06 $08 $06


_pumpkinHead_head_state09:
	call _pumpkinHead_ghost_state09
	ret c

	ld a,MUS_BOSS
	ld (wActiveMusic),a
	jp playSound


; Head follows body. Called by other states.
_pumpkinHead_head_state0a:
	call objectSetPriorityRelativeToLink

	ld a,Object.animParameter
	call objectGetRelatedObject1Var
	ld a,(hl)
	push hl
	ld hl,@headZOffsets
	rst_addAToHl
	ldi a,(hl)
	ld c,a
	ld b,$00
	ld a,(hl)
	pop hl
	push af
	call objectTakePositionWithOffset

	pop af
	ld e,Enemy.zh
	ld (de),a

	; Check whether body's angle is different from head's angle
	ld l,Enemy.angle
	ld e,l
	ld a,(de)
	cp (hl)
	jp z,enemyAnimate

	ld a,(hl)
	ld (de),a
	rrca
	rrca
	ld b,$00
	jr _pumpkinHead_head_setAnimation

; Offsets for head relative to body. Indexed by body's animParameter.
;   b0: Y offset
;   b1: Z position
@headZOffsets:
	.db $00 $f0
	.db $01 $f0
	.db $00 $ef


; Preparing to fire projectiles
_pumpkinHead_head_state0b:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),20

	call _pumpkinHead_head_state0a

	ld e,Enemy.angle
	ld a,(de)
	rrca
	rrca
	ld b,$01
	jp _pumpkinHead_head_setAnimation


; Delay before firing projectile
_pumpkinHead_head_state0c:
	call _ecom_decCounter1
	jp nz,objectSetPriorityRelativeToLink

	; Fire projectile
	ld (hl),36 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.angle
	ld a,(hl)
	rrca
	rrca
	ld b,$00
	call _pumpkinHead_head_setAnimation
	call getFreePartSlot
	ret nz

	ld (hl),PARTID_PUMPKIN_HEAD_PROJECTILE
	ld l,Part.angle
	ld e,Enemy.angle
	ld a,(de)
	ld (hl),a
	call objectCopyPosition

	ld a,SND_VERAN_FAIRY_ATTACK
	jp playSound


; Delay after firing projectile
_pumpkinHead_head_state0d:
	call _ecom_decCounter1
	jp nz,objectSetPriorityRelativeToLink

	ld l,e
	ld (hl),$0a ; [state]
	jr _pumpkinHead_head_state0a


; Began a stomp; moving up
_pumpkinHead_head_state0e:
	call _pumpkinHead_ghostOrHead_updatePositionWhileStompingUp
	jr z,@movingDown

	; Update angle
	ld l,Enemy.angle
	ld e,l
	ld a,(de)
	cp (hl)
	ret z
	ld a,(hl)
	ld (de),a
	add $04
	and $18
	rrca
	rrca
	ld b,$00
	jp _pumpkinHead_head_setAnimation

@movingDown:
	call _ecom_incState
	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a
	call objectSetVisible80


; Body is stomping; moving down
_pumpkinHead_head_state0f:
	ld c,$20
	call _pumpkinHead_ghostOrHead_updatePositionWhileStompingDown
	ret c

	; Reached target position
	ld (hl),$f0 ; [zh]
	ld l,Enemy.state
	ld (hl),$0a
	jp objectSetVisible82


; Body just destroyed
_pumpkinHead_head_state10:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speedZ
	ld a,<(-$120)
	ldi (hl),a
	ld (hl),>(-$120)
	jp objectSetVisiblec2


; Head falling down after body destroyed
_pumpkinHead_head_state11:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),120
	ret


; Head is grabbable for 120 frames
_pumpkinHead_head_state12:
	call _ecom_decCounter1
	jp nz,_pumpkinHead_head_state16

	ld l,e
	inc (hl) ; [state]

	; [ghost.state] = $0b
	ld a,Object.relatedObj1+1
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.state
	ld (hl),$0b
	ret


; Ghost just re-entered head, or head timed out before Link grabbed it
_pumpkinHead_head_state13:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$10

	ld l,Enemy.collisionRadiusX
	ld (hl),$0a

	ld a,$08
	jp enemySetAnimation


; Delay before moving back up, respawning body
_pumpkinHead_head_state14:
	call _ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speedZ
	ld a,<(-$200)
	ldi (hl),a
	ld (hl),>(-$200)

	ld l,Enemy.collisionRadiusX
	ld (hl),$06
	ld a,$04
	jp enemySetAnimation


; Head moving up
_pumpkinHead_head_state15:
	ld c,$20
	call objectUpdateSpeedZ_paramC

	ld l,Enemy.zh
	ld a,(hl)
	cp $f1
	ret nc

	; Head has gone up high enough; respawn body now.

	ld (hl),$f0 ; [zh]

	ld l,Enemy.state
	ld (hl),$0a

	ld l,Enemy.collisionRadiusX
	ld (hl),$0c

	call objectSetVisible82

	; [body.state] = $11
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld (hl),$11

	; Copy head's position to ghost
	call objectCopyPosition

	; [ghost.zh]
	ld l,Enemy.zh
	ld (hl),$00

	ld a,$04
	ld b,$00
	jp _pumpkinHead_head_setAnimation


; Head has just come to rest after being thrown.
; Called by other states (to make it grabbable).
_pumpkinHead_head_state16:
	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	ret z
	call objectAddToGrabbableObjectBuffer
	jp objectPushLinkAwayOnCollision


;;
; @param[out]	zflag	z if time to stomp
pumpkinHead_body_countdownUntilStomp:
	ld a,(wFrameCounter)
	rrca
	ret c
	call _ecom_decCounter2
	ret nz

	ld l,Enemy.state
	ld (hl),$0d
	ld l,Enemy.counter1
	ld (hl),60

;;
; Randomly sets the duration until a stomp occurs, and the number of stomps to perform.
_pumpkinHead_body_chooseRandomStompTimerAndCount:
	ld bc,$0701
	call _ecom_randomBitwiseAndBCE
	ld a,b
	ld hl,@counter2Vals
	rst_addAToHl

	ld e,Enemy.counter2
	ld a,(hl)
	ld (de),a

	ld e,Enemy.var30
	ld a,c
	add $02
	ld (de),a
	xor a
	ret

@counter2Vals:
	.db 90, 120, 120, 120, 150, 150, 150, 180

;;
; @param[out]	zflag	z if body is moving down
_pumpkinHead_ghostOrHead_updatePositionWhileStompingUp:
	ld a,Object.speedZ+1
	call objectGetRelatedObject1Var
	bit 7,(hl)
	ret z

	call objectTakePosition
	ld e,Enemy.zh
	ld a,(de)
	sub $10
	ld (de),a
	ret

;;
; @param	c	Gravity
; @param[out]	hl	Enemy.zh
; @param[out]	cflag	nc if reached target z-position
_pumpkinHead_ghostOrHead_updatePositionWhileStompingDown:
	call objectUpdateSpeedZ_paramC
	ld l,Enemy.zh
	ld a,(hl)
	cp $f0
	ret nc

	push af
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	call objectTakePosition
	pop af
	ld e,Enemy.zh
	ld (de),a
	ret


;;
_pumpkinHead_noHealth:
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jr z,@bodyHealthZero
	dec a
	jr z,@ghostHealthZero

@headHealthZero:
	call objectCreatePuff
	ld h,d
	ld l,Enemy.state
	ldi a,(hl)
	cp $02
	jr nz,@delete

	ld a,(hl) ; [substate]
	cp $02
	call c,dropLinkHeldItem
@delete:
	jp enemyDelete

@ghostHealthZero:
	ld e,Enemy.collisionType
	ld a,(de)
	or a
	jr nz,++
	call _ecom_killRelatedObj1
	ld l,Enemy.relatedObj2+1
	ld h,(hl)
	call _ecom_killObjectH
++
	call _enemyBoss_dead
	xor a
	ret

@bodyHealthZero:
	; Delete self if ghost's health is 0
	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,enemyDelete

	; Otherwise, the body just disappears temporarily
	ld h,d
	ld l,Enemy.health
	ld (hl),$08

	ld l,Enemy.state
	ld (hl),$10

	ld l,Enemy.zh
	ld (hl),$00

	; [ghost.state] = $0f
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld (hl),$0f

	; [head.state] = $10
	ld a,Object.state
	call objectGetRelatedObject2Var
	ld (hl),$10

	call objectCreatePuff
	jp objectSetInvisible


; ==============================================================================
; ENEMYID_HEAD_THWOMP
;
; Variables:
;   direction: Current animation. Even numbers are face colors; odd numbers are
;              transitions.
;   var30: "Spin counter" used when bomb is thrown into head
;   var31: Which head the thwomp will settle on after throwing bomb in?
;   var32: Bit 0 triggers the effect of a bomb being thrown into head thwomp.
;   var33: Determines the initial angle of the circular projectiles' initial angle
;   var34: Counter which determines when head thwomp starts shooting fireballs / bombs
; ==============================================================================
enemyCode79:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,_enemyBoss_dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw _headThwomp_state_uninitialized
	.dw _headThwomp_state_stub
	.dw _headThwomp_state_stub
	.dw _headThwomp_state_stub
	.dw _headThwomp_state_stub
	.dw _headThwomp_state_stub
	.dw _headThwomp_state_stub
	.dw _headThwomp_state_stub
	.dw _headThwomp_state8
	.dw _headThwomp_state9
	.dw _headThwomp_stateA
	.dw _headThwomp_stateB
	.dw _headThwomp_stateC
	.dw _headThwomp_stateD
	.dw _headThwomp_stateE
	.dw _headThwomp_stateF
	.dw _headThwomp_state10
	.dw _headThwomp_state11


_headThwomp_state_uninitialized:
	ld a,ENEMYID_HEAD_THWOMP
	ld b,PALH_81
	call _enemyBoss_initializeRoom

	call _ecom_setSpeedAndState8
	ld l,Enemy.counter1
	ld (hl),18

	call _headThwomp_setSolidTilesAroundSelf
	jp objectSetVisible80


_headThwomp_state_stub:
	ret


; Waiting for Link to move up for fight to start
_headThwomp_state8:
	ld a,(w1Link.yh)
	cp $9c
	ret nc

	ld c,$a4
	ld a,$3d
	call setTile

	ld a,SND_DOORCLOSE
	call playSound

	ld a,$98
	ld (wLinkLocalRespawnY),a
	ld a,$48
	ld (wLinkLocalRespawnX),a

	call _ecom_incState

	ld l,Enemy.var34
	ld (hl),$f0

	call _enemyBoss_beginBoss


; Spinning normally
_headThwomp_state9:
	call _headThwomp_checkBombThrownIntoHead
	ret nz

	call _headThwomp_checkShootProjectile

	; Update rotation
	call _ecom_decCounter1
	ret nz

	ld e,Enemy.health
	ld a,(de)
	dec a
	ld bc,@rotationSpeeds
	call addDoubleIndexToBc

	ld e,Enemy.direction
	ld a,(de)
	inc a
	and $07
	ld (de),a
	rrca
	jr nc,+
	inc bc
+
	ld a,(bc)
	ld (hl),a
	ld a,SND_CLINK2
	call c,playSound
	ld a,(de)
	jp enemySetAnimation

@rotationSpeeds:
	.db $11 $07 ; $01 == [health]
	.db $14 $08 ; $02
	.db $17 $0a ; $03
	.db $1a $0b ; $04


; Bomb just thrown into head thwomp
_headThwomp_stateA:
	call _ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl) ; [state]
	inc l
	ld (hl),$00 ; [substate]
	ret


; Spinning after bomb was thrown into head
_headThwomp_stateB:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]
	inc l
	ld (hl),60 ; [counter1]

; Spinning at max speed
@substate1:
	call _ecom_decCounter1
	ld b,$08
	jp nz,_headThwomp_rotate

	ld l,e
	inc (hl) ; [substate]
	inc l
	ld (hl),$01 ; [counter1]
	inc l
	ld (hl),$02 ; [counter2]

	ld l,Enemy.var30
	ld (hl),$01

; Slower spinning
@substate2:
	call _ecom_decCounter1
	ret nz

	inc l
	dec (hl) ; [counter2]
	jr nz,++

	ld (hl),$02
	ld l,Enemy.var30
	inc (hl)
	ld a,(hl)
	cp $12
	jr nc,@startSlowestSpinning
++
	ld l,Enemy.var30
	ld a,(hl)
	ld l,Enemy.counter1
	ld (hl),a
	ld b,$08
	jp _headThwomp_rotate

@startSlowestSpinning:
	ld l,Enemy.counter1
	ld (hl),$01
	inc l
	ld (hl),$06 ; [counter2]
	ld l,e
	inc (hl) ; [substate]

; Slowest spinning; will stop when it reaches the target head
@substate3:
	call _ecom_decCounter1
	ret nz

	inc l
	ld a,(hl) ; [counter2]
	add $0c
	ldd (hl),a ; [counter2]
	ld (hl),a  ; [counter1]

	; Continue rotating if head color is wrong
	ld l,Enemy.direction
	ld a,(hl)
	ld l,Enemy.var31
	cp (hl)
	ld b,$08
	jp nz,_headThwomp_rotate

	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),$10
	ret


; Just reached the target head color
_headThwomp_stateC:
	call _ecom_decCounter1
	ret nz

	; Set state to number from $0d-$10 based on head color
	ld l,Enemy.direction
	ld a,(hl)
	srl a
	inc a
	ld l,e ; [state]
	add (hl)
	ld (hl),a

	inc l
	ld (hl),$00 ; [substate]
	ret


; Green face (shoots fireballs)
_headThwomp_stateD:
	inc e
	ld a,(de) ; [substate]
	or a
	jr nz,@substate1

@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	inc l
	ld (hl),$f0 ; [counter1]

	ld hl,wRoomCollisions+$47
	ld (hl),$00
	ret

@substate1:
	call _headThwomp_checkBombThrownIntoHead
	ret nz

	call _ecom_decCounter1
	jr z,@resumeSpinning

	ld a,(hl)
	cp 210
	call nc,enemyAnimate

	ld e,$c6
	ld a,(hl)
	and $1f
	ret nz
	ld b,PARTID_HEAD_THWOMP_FIREBALL
	jp _ecom_spawnProjectile

@resumeSpinning:
	ld l,Enemy.state
	ld (hl),$11
	ld l,Enemy.counter1
	ld (hl),$01
	ret


; Blue face (fires circular projectiles)
_headThwomp_stateE:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	inc l
	ld a,$08
	ldi (hl),a ; [counter1]
	ld (hl),a  ; [counter2] (number of times to fire)

	call getRandomNumber_noPreserveVars
	and $02
	jr nz,+
	ld a,$fe
+
	ld e,Enemy.var33
	ld (de),a
	ld hl,wRoomCollisions+$47
	ld (hl),$00
	ret

; Waiting a moment before starting to fire
@substate1:
	call _headThwomp_checkBombThrownIntoHead
	ret nz
	call _ecom_decCounter1
	jp nz,enemyAnimate

	ld (hl),$08 ; [counter1]
	ld l,Enemy.substate
	inc (hl)

	ld hl,wRoomCollisions+$47
	ld (hl),$03

	call getFreePartSlot
	jr nz,++
	ld (hl),PARTID_HEAD_THWOMP_CIRCULAR_PROJECTILE
	inc l
	ld e,Enemy.var33
	ld a,(de)
	ld (hl),a ; [part.subid]
	ld bc,$f800
	call objectCopyPositionWithOffset
++
	ld e,Enemy.direction
	ld a,(de)
	jp enemySetAnimation

; Cooldown after firing
@substate2:
	call _ecom_decCounter1
	jp nz,enemyAnimate

	ld (hl),30 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	ret

; Cooldown after firing; checks whether to fire again or return to normal state
@substate3:
	call _ecom_decCounter1
	ret nz

	inc l
	dec (hl) ; [counter2]
	jr z,@resumeSpinning

	; Fire again
	ld l,e
	ld (hl),$01 ; [substate]
	ld a,$08
	jr ++

@resumeSpinning:
	ld l,Enemy.state
	ld (hl),$11

	ld a,$10
++
	ld l,Enemy.counter1
	ld (hl),a

	ld hl,wRoomCollisions+$47
	ld (hl),$00
	ld e,Enemy.direction
	ld a,(de)
	add $08
	jp enemySetAnimation


; Purple face (stomps the ground)
_headThwomp_stateF:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),$02
	jp _headThwomp_unsetSolidTilesAroundSelf

; Falling
@substate1:
	ld a,$20
	call objectUpdateSpeedZ_sidescroll

	ld e,Enemy.yh
	ld a,(de)
	cp $90
	ret c

	ld h,d
	ld l,Enemy.substate
	inc (hl)

	inc l
	ld (hl),120 ; [counter1]

@poundGround: ; Also used by death code
	ld a,60
	ld (wScreenShakeCounterY),a

	ld a,SND_STRONG_POUND
	jp playSound

; Resting on ground
@substate2:
	call _ecom_decCounter1
	jr z,@beginMovingUp

	ld a,(hl) ; [counter1]
	cp 30
	ret c

	; Spawn falling rocks every 16 frames
	and $0f
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_3b
	ret

@beginMovingUp:
	ld l,e
	inc (hl) ; [substate]
	ret

; Moving back up
@substate3:
	ld h,d
	ld l,Enemy.y
	ld a,(hl)
	sub <($0080)
	ldi (hl),a
	ld a,(hl)
	sbc >($0080)
	ld (hl),a

	cp $56
	ret nz
	ld l,e
	inc (hl) ; [substate]
	ret

; Reached original position
@substate4:
	; Don't set tile solidity as long as Link is within 16 pixels (wouldn't want him
	; to get stuck)
	ld h,d
	ld l,Enemy.yh
	ld a,(w1Link.yh)
	sub (hl)
	add $10
	cp $21
	jr nc,@setSolidity

	ld l,Enemy.xh
	ld a,(w1Link.xh)
	sub (hl)
	add $10
	cp $21
	ret c

@setSolidity:
	ld l,Enemy.state
	ld (hl),$11
	ld l,Enemy.counter1
	ld (hl),$10
	jp _headThwomp_setSolidTilesAroundSelf


; Red face (takes damage)
_headThwomp_state10:
	inc e
	ld a,(de) ; [substate]
	or a
	jr nz,@substate1

@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	inc l
	ld (hl),120 ; [counter1]

	ld l,Enemy.invincibilityCounter
	ld (hl),$18

	ld l,Enemy.health
	dec (hl)
	jr nz,++

	; He's dead
	dec (hl)
	call _headThwomp_unsetSolidTilesAroundSelf
	ld a,TREE_GFXH_01
	ld (wLoadedTreeGfxIndex),a
++
	ld e,Enemy.health
	ld a,(de)
	inc a
	call nz,_headThwomp_dropHeart

	ld a,$10
	call enemySetAnimation
	ld a,SND_BOSS_DAMAGE
	jp playSound

@substate1:
	call _ecom_decCounter1
	jr z,@resumeSpinning

	; Run below code only if he's dead
	ld e,Enemy.health
	ld a,(de)
	inc a
	ret nz

	ld (hl),$ff

	ld a,$20
	call objectUpdateSpeedZ_sidescroll

	ld e,Enemy.yh
	ld a,(de)
	cp $90
	ret c

	; Trigger generic "boss death" code by setting health to 0 for real
	ld h,d
	ld l,Enemy.health
	ld (hl),$00
	jp _headThwomp_stateF@poundGround

@resumeSpinning:
	ld l,Enemy.state
	ld (hl),$11

	ld l,Enemy.counter1
	ld (hl),$10

	ld hl,wRoomCollisions+$47
	ld (hl),$00

	ld a,$0e
	jp enemySetAnimation


_headThwomp_state11:
	call _ecom_decCounter1
	jp nz,enemyAnimate

	inc (hl) ; [counter1]
	ld l,e
	ld (hl),$09 ; [state]

	ld l,Enemy.var34
	ld (hl),$f0
	ret


;;
_headThwomp_setSolidTilesAroundSelf:
	ld hl,wRoomCollisions+$46
	ld (hl),$01
	inc l
	inc l
	ld (hl),$02

	ld a,l
	add $0e
	ld l,a
	ld (hl),$05
	inc l
	ld (hl),$0f
	inc l
	ld (hl),$0a
	ret

;;
_headThwomp_unsetSolidTilesAroundSelf:
	ld hl,wRoomCollisions+$46
	xor a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld l,$56
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ret


;;
; @param	b	Animation base
_headThwomp_rotate:
	ld e,Enemy.direction
	ld a,(de)
	inc a
	and $07
	ld (de),a

	add b
	call enemySetAnimation

	ld e,Enemy.direction
	ld a,(de)
	rrca
	ret c
	ld a,SND_CLINK2
	jp playSound


;;
; If a bomb is thrown into head thwomp, this sets the state to $0a.
;
; @param[out]	zflag	z if no bomb entered head thwomp
_headThwomp_checkBombThrownIntoHead:
	ldhl FIRST_DYNAMIC_ITEM_INDEX,Item.start
@itemLoop:
	ld l,Item.id
	ld a,(hl)
	cp ITEMID_BOMB
	jr nz,@nextItem

	ld l,Item.state
	ldi a,(hl)
	dec a
	jr z,@isNonExplodingBomb
	ld a,(hl)
	cp $02
	jr c,@nextItem

@isNonExplodingBomb:
	; Check if bomb is in the right position to enter thwomp
	ld l,Item.yh
	ldi a,(hl)
	sub $50
	add $0c
	cp $19
	jr nc,@nextItem
	inc l
	ld a,(hl)
	sub $78
	add $0c
	cp $19
	jr c,@bombEnteredThwomp

@nextItem:
	inc h
	ld a,h
	cp LAST_DYNAMIC_ITEM_INDEX+1
	jr c,@itemLoop

	ld e,Enemy.var32
	ld a,(de)
	rrca
	jr c,@triggerBombEffect

	xor a
	ret

@bombEnteredThwomp:
	ld l,Item.var2f
	set 5,(hl)

@triggerBombEffect:
	ld h,d
	ld l,Enemy.var32
	set 0,(hl)

	ld e,Enemy.direction
	ld a,(de)
	bit 0,a
	jr nz,@betweenTwoHeads

	ld l,Enemy.var31
	ld (hl),a

	ld l,Enemy.var32
	ld (hl),$00

	ld l,Enemy.state
	ld (hl),$0a

	ld l,Enemy.counter1
	ld (hl),$06

	call enemySetAnimation

	ld hl,wRoomCollisions+$47
	ld (hl),$03
	or d
	ret

@betweenTwoHeads:
	call _ecom_decCounter1
	ret nz

	ld b,$00
	call _headThwomp_rotate
	jr @triggerBombEffect

;;
_headThwomp_dropHeart:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_ITEM_DROP
	inc l
	ld (hl),ITEM_DROP_HEART
	ld bc,$1400
	jp objectCopyPositionWithOffset

;;
_headThwomp_checkShootProjectile:
	ld a,(wFrameCounter)
	rrca
	ret c

	ld h,d
	ld l,Enemy.var34
	dec (hl)
	jr nz,+
	ld (hl),$f0
+
	ld a,(hl)
	cp 90
	ret nc
	and $0f
	ret nz

	call getRandomNumber_noPreserveVars
	and $07
	jr z,@dropBomb

	ld b,PARTID_HEAD_THWOMP_FIREBALL
	jp _ecom_spawnProjectile

@dropBomb:
	ld b,$02
	call checkBPartSlotsAvailable
	ret nz

	; Spawn bomb drop
	call getFreePartSlot
	ld (hl),PARTID_ITEM_DROP
	inc l
	ld (hl),ITEM_DROP_BOMBS
	call objectCopyPosition

	; Spawn bomb drop "physics" object?
	ld b,h
	call getFreePartSlot
	ld (hl),PARTID_HEAD_THWOMP_BOMB_DROPPER

	ld l,Part.relatedObj1
	ld a,Part.start
	ldi (hl),a
	ld (hl),b

	jp objectCopyPosition


; ==============================================================================
; ENEMYID_SHADOW_HAG
;
; Variables:
;   counter2: Number of times to spawn bugs before shadows separate
;   var30: Number of bugs on-screen
;   var31: Set if the hag couldn't spawn because Link was in a bad position
; ==============================================================================
enemyCode7a:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus

	; Dead. Delete all "children" objects.
	ld e,Enemy.collisionType
	ld a,(de)
	or a
	jr z,@dead
	ldhl FIRST_ENEMY_INDEX, Enemy.start
@killNext:
	ld l,Enemy.id
	ld a,(hl)
	cp ENEMYID_SHADOW_HAG_BUG
	call z,_ecom_killObjectH
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@killNext
@dead:
	jp _enemyBoss_dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw _shadowHag_state_uninitialized
	.dw _shadowHag_state_stub
	.dw _shadowHag_state_stub
	.dw _shadowHag_state_stub
	.dw _shadowHag_state_stub
	.dw _shadowHag_state_stub
	.dw _shadowHag_state_stub
	.dw _shadowHag_state_stub
	.dw _shadowHag_state8
	.dw _shadowHag_state9
	.dw _shadowHag_stateA
	.dw _shadowHag_stateB
	.dw _shadowHag_stateC
	.dw _shadowHag_stateD
	.dw _shadowHag_stateE
	.dw _shadowHag_stateF
	.dw _shadowHag_state10
	.dw _shadowHag_state11
	.dw _shadowHag_state12
	.dw _shadowHag_state13

_shadowHag_state_uninitialized:
	ld a,ENEMYID_SHADOW_HAG
	ld b,$00
	call _enemyBoss_initializeRoom
	ld a,SPEED_80
	jp _ecom_setSpeedAndState8


_shadowHag_state_stub:
	ret


_shadowHag_state8:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

; Wait for door to close, then begin cutscene
@substate0:
	ld a,($cc93)
	or a
	ret nz

	inc a
	ld (wDisabledObjects),a

	ld bc,$0104
	call _enemyBoss_spawnShadow
	ret nz

	ld h,d
	ld l,Enemy.substate
	inc (hl)
	ld l,Enemy.angle
	ld (hl),$18
	ld l,Enemy.zh
	ld (hl),$ff

	; Set position to Link's position
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	add $04
	ldi (hl),a
	inc l
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ret

; Moving left to center of room
@substate1:
	ld e,Enemy.xh
	ld a,(de)
	cp ((LARGE_ROOM_WIDTH/2)<<4)+8
	jp nc,objectApplySpeed

	call _shadowHag_beginEmergingFromShadow
	ld h,d
	ld l,Enemy.substate
	inc (hl)

	inc l
	ld (hl),$10 ; [counter1]

	ld l,Enemy.zh
	ld (hl),$00
	jp _ecom_killRelatedObj2

; Emerging from shadow
@substate2:
	call _shadowHag_updateEmergingFromShadow
	ret nz

	ld e,Enemy.substate
	ld a,$03
	ld (de),a
	dec a
	jp enemySetAnimation

; Delay before showing textbox
@substate3:
	call _ecom_decCounter1
	jr nz,@animate

	ld (hl),$08
	ld l,e
	inc (hl)
	ld bc,TX_2f2b
	jp showText

@substate4:
	call _ecom_decCounter1
	jr nz,@animate
	call _shadowHag_beginReturningToGround
	call _enemyBoss_beginBoss
@animate:
	jp enemyAnimate


; Currently in the ground, showing eyes
_shadowHag_state9:
	call _ecom_decCounter2
	jp nz,shadowHag_updateReturningToGround

	dec l
	ld a,(hl)
	or a
	jr z,@spawnShadows

	dec (hl)
	jp _ecom_flickerVisibility

@spawnShadows:
	ld b,$04
	call checkBPartSlotsAvailable
	ret nz

	ldbc PARTID_SHADOW_HAG_SHADOW,$04
--
	call _ecom_spawnProjectile
	dec c
	ld l,Part.angle
	ld (hl),c
	jr nz,--

	; Go to state A
	call _ecom_incState
	ld l,Enemy.counter1
	ld (hl),150
	inc l
	ld (hl),$04 ; [counter2]

	ld l,Enemy.collisionType
	res 7,(hl)
	jp objectSetInvisible


; Shadows chasing Link
_shadowHag_stateA:
	ld a,(wFrameCounter)
	rrca
	ret c
	call _ecom_decCounter1
	ret nz

	; Time for shadows to reconverge.

	dec (hl) ; [counter1] = $ff
	ld l,e
	inc (hl) ; [state] = $0b

	call getRandomNumber_noPreserveVars
	and $06
	ld hl,@targetPositions
	rst_addAToHl
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a
	ret

; When the shadows reconverge, one of these positions is chosen randomly.
@targetPositions:
	.db $38 $48
	.db $38 $b8
	.db $78 $48
	.db $78 $b8


; Shadows reconverging to target position
_shadowHag_stateB:
	ld e,Enemy.counter2
	ld a,(de)
	or a
	ret nz

	; All shadows have now returned.

	; Decide how many times to spawn bugs before shadows separate again
	call getRandomNumber_noPreserveVars
	and $01
	add $02
	ld e,Enemy.counter2
	ld (de),a

_shadowHag_initStateC:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.collisionType
	ld (hl),$80|ENEMYID_PODOBOO

	ld l,Enemy.collisionRadiusY
	ld (hl),$03
	inc l
	ld (hl),$05

	call objectSetVisible83
	ld a,$04
	jp enemySetAnimation


; Delay before spawning bugs
_shadowHag_stateC:
	call _ecom_decCounter1
	jr nz,++
	ld (hl),$41
	ld l,e
	inc (hl)
++
	jp enemyAnimate


; Spawning bugs
_shadowHag_stateD:
	call enemyAnimate
	call _ecom_decCounter1
	jr z,@doneSpawningBugs

	; Spawn bug every 16 frames
	ld a,(hl)
	and $0f
	ret nz

	; Maximum of 7 at a time
	ld e,Enemy.var30
	ld a,(de)
	cp $07
	ret nc

	; Spawn bug
	ld b,ENEMYID_SHADOW_HAG_BUG
	call _ecom_spawnUncountedEnemyWithSubid01
	ret nz

	; [child.relatedObj1] = this
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	; [child.position] = [this.position]
	call objectCopyPosition

	ld h,d
	ld l,Enemy.var30
	inc (hl)
	ret

@doneSpawningBugs:
	call _ecom_incState
	ld l,Enemy.counter1
	ld (hl),30
	ret


; Done spawning bugs; delay before the hag herself spawns in
_shadowHag_stateE:
	call _ecom_decCounter1
	jp nz,_ecom_flickerVisibility

	ld e,Enemy.var31
	ld a,(de)
	or a
	ld a,90
	jr z,++
	xor a
	ld (de),a
	ld a,150
++
	ld (hl),a ; [counter1] = a

	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.collisionType
	res 7,(hl)
	jp objectSetInvisible


; Waiting for Link to be in a position where the hag can spawn behind him
_shadowHag_stateF:
	call _ecom_decCounter1
	jr z,@couldntSpawn

	call _shadowHag_chooseSpawnPosition
	ret nz
	ld e,Enemy.yh
	ld a,b
	ld (de),a
	ld e,Enemy.xh
	ld a,c
	ld (de),a
	call _shadowHag_beginEmergingFromShadow
	jp _ecom_incState

@couldntSpawn:
	ld e,Enemy.var31
	ld a,$01
	ld (de),a

	inc l
	dec (hl) ; [counter2]--
	jp nz,_shadowHag_initStateC

	call _shadowHag_beginReturningToGround
	ld a,$04
	jp enemySetAnimation


; Spawning out of ground to attack Link
_shadowHag_state10:
	call _shadowHag_updateEmergingFromShadow
	ret nz

	call _ecom_incState

	ld l,Enemy.collisionType
	ld (hl),$80|ENEMYID_SHADOW_HAG

	ld l,Enemy.speed
	ld (hl),SPEED_180
	ld l,Enemy.counter1
	ld (hl),30
	ld l,Enemy.direction
	ld (hl),$ff

	ld l,Enemy.collisionRadiusY
	ld (hl),$0c
	inc l
	ld (hl),$08

	call _ecom_updateCardinalAngleTowardTarget
	jp _ecom_updateAnimationFromAngle


; Delay before charging at Link
_shadowHag_state11:
	call _shadowHag_checkLinkLookedAtHag
	jr z,_shadowHag_doneCharging

	call _ecom_decCounter1
	ret nz
	ld (hl),60

	ld l,Enemy.state
	inc (hl)

_shadowHag_animate:
	jp enemyAnimate


; Charging at Link
_shadowHag_state12:
	call _shadowHag_checkLinkLookedAtHag
	jr z,_shadowHag_doneCharging

	call _ecom_decCounter1
	jr z,_shadowHag_doneCharging

	ld e,Enemy.yh
	ld a,(de)
	sub $12
	cp (LARGE_ROOM_HEIGHT<<4)-$32
	jr nc,_shadowHag_doneCharging

	ld e,Enemy.xh
	ld a,(de)
	sub $18
	cp (LARGE_ROOM_WIDTH<<4)-$30
	jr nc,_shadowHag_doneCharging
	call objectApplySpeed
	jr _shadowHag_animate


_shadowHag_doneCharging:
	call _ecom_decCounter2
	jp z,_shadowHag_beginReturningToGround

	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.collisionType
	ld (hl),$80|ENEMYID_PODOBOO
	ld a,$06
	jp enemySetAnimation


; Delay before spawning bugs again
_shadowHag_state13:
	call _ecom_decCounter1
	jr nz,shadowHag_updateReturningToGround
	jp _shadowHag_initStateC


;;
_shadowHag_beginEmergingFromShadow:
	ld a,$05
	call enemySetAnimation
	call objectSetVisible82
	ld e,Enemy.yh
	ld a,(de)
	sub $04
	ld (de),a
	ret

;;
; @param[out]	zflag	z if done emerging? (animParameter was $ff)
_shadowHag_updateEmergingFromShadow:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	ret z

	; If [animParameter] == 1, y -= 8? (To center the hitbox maybe?)
	sub $02
	ret nz
	ld (de),a

	ld e,Enemy.yh
	ld a,(de)
	sub $08
	ld (de),a
	or d
	ret

;;
shadowHag_updateReturningToGround:
	call enemyAnimate

	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z
	bit 7,a
	ret nz

	dec a
	ld hl,@yOffsets
	rst_addAToHl

	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld (de),a

	ld e,Enemy.animParameter
	xor a
	ld (de),a
	ret

@yOffsets:
	.db $08 $04

;;
; Sets state to 9 & initializes stuff
_shadowHag_beginReturningToGround:
	ld h,d
	ld l,Enemy.state
	ld (hl),$09

	ld l,Enemy.counter1
	ld (hl),90
	inc l
	ld (hl),30 ; [counter2]

	; Make hag invincible
	ld l,Enemy.collisionType
	ld (hl),$80|ENEMYID_PODOBOO

	ld l,Enemy.collisionRadiusY
	ld (hl),$03
	inc l
	ld (hl),$05

	ld a,$06
	jp enemySetAnimation

;;
; Chooses position to spawn at for charge attack based on Link's facing direction.
;
; @param[out]	bc	Spawn position
; @param[out]	zflag	nz if Link is too close to the wall to spawn in
_shadowHag_chooseSpawnPosition:
	ld a,(w1Link.direction)
	ld hl,@spawnOffsets
	rst_addDoubleIndex

	ld a,(w1Link.yh)
	add (hl)
	ld b,a
	sub $1c
	cp $80
	jr nc,@invalid

	inc hl
	ld a,(w1Link.xh)
	ld e,a
	add (hl)
	ld c,a
	cp $f0
	jr nc,@invalid

	sub e
	jr nc,++
	cpl
	inc a
++
	rlca
	jp nc,getTileCollisionsAtPosition

@invalid:
	or d
	ret

@spawnOffsets:
	.db $40 $00
	.db $08 $c0
	.db $c0 $00
	.db $08 $40

;;
; @param[out]	zflag	z if Link looked at the hag
_shadowHag_checkLinkLookedAtHag:
	call objectGetAngleTowardEnemyTarget
	add $14
	and $18
	swap a
	rlca
	ld b,a
	ld a,(w1Link.direction)
	cp b
	ret


; ==============================================================================
; ENEMYID_EYESOAR
;
; Variables:
;   var30-var35: Object indices of children
;   var36/var37: Target Y/X position for state $0b
;   var38: The distance each child should be from Eyesoar (the value they're moving
;          toward)
;   var39: Bit 4: Set when children should return?
;          Bit 3: Unset to make the children start moving back to Eyesoar (after using
;                 switch hook on him)
;          Bit 2: Set while eyesoar is in his "dazed" state (Signals children to start
;                 moving around randomly)
;          Bit 1: Set to indicate the children should start moving again as normal after
;                 returning to Eyesoar
;          Bit 0: While set, children don't respawn?
;   var3a: Bits 0-3: set when corresponding children have reached their target distance
;                    away from eyesoar?
;          Bits 4-7: set when corresponding children have reached their target position
;                    relative to eyesoar after using the switch hook on him?
;   var3b: Current "angle" (rotation offset for children)
;   var3c: Counter until bit 0 of var39 gets reset
; ==============================================================================
enemyCode7b:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,_eyesoar_dead

	; ENEMYSTATUS_JUST_HIT or ENEMYSTATUS_KNOCKBACK

	; TODO: Checking for mystery seed? Why?
	ld h,d
	ld l,Enemy.var2a
	ld a,(hl)
	cp $80|ITEMCOLLISION_MYSTERY_SEED
	jr nz,@normalStatus
	ld l,Enemy.var3c
	ld (hl),$78
	ld l,Enemy.var39
	set 0,(hl)

@normalStatus:
	ld h,d
	ld l,Enemy.var3c
	ld a,(hl)
	or a
	jr z,++
	dec (hl)
	jr nz,++

	ld l,Enemy.var39
	res 0,(hl)
++
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw _eyesoar_state_uninitialized
	.dw _eyesoar_state1
	.dw _eyesoar_state_stub
	.dw _eyesoar_state_switchHook
	.dw _eyesoar_state_stub
	.dw _eyesoar_state_stub
	.dw _eyesoar_state_stub
	.dw _eyesoar_state_stub
	.dw _eyesoar_state8
	.dw _eyesoar_state9
	.dw _eyesoar_stateA
	.dw _eyesoar_stateB
	.dw _eyesoar_stateC
	.dw _eyesoar_stateD
	.dw _eyesoar_stateE


_eyesoar_state_uninitialized:
	ld h,d
	ld l,Enemy.counter1
	ld (hl),60

	ld l,Enemy.zh
	ld (hl),$fe

	; Check for subid 1
	ld l,Enemy.subid
	ld a,(hl)
	or a
	ld a,SPEED_80
	jp nz,_ecom_setSpeedAndState8

	; BUG: This sets an invalid state!
	; 'a+1' == SPEED_80+1 == $15, a state which isn't defined.
	; Doesn't really matter, since this object will be deleted anyway...
	; But there are obscure conditions below where it returns before deleting itself.
	; Then this would become a problem. But those conditions probably never happen...
	inc a
	ld (de),a ; [state] = $15 (!)

	ld a,$ff
	ld b,$00
	call _enemyBoss_initializeRoom


; Spawning "real" eyesoar and children.
_eyesoar_state1:
	; If this actually returns here, the game could crash (see above note).
	ld b,$05
	call checkBEnemySlotsAvailable
	ret nz

	; Spawn the "real" version of the boss (subid 1).
	ld b,ENEMYID_EYESOAR
	call _ecom_spawnUncountedEnemyWithSubid01

	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a
	call objectCopyPosition

	; Spawn 4 children.
	ld l,Enemy.var30
	ld b,h
	ld c,$04

@spawnChildLoop:
	push hl
	call getFreeEnemySlot_uncounted
	ld (hl),ENEMYID_EYESOAR_CHILD
	inc l
	dec c
	ld (hl),c ; [child.subid]

	ld l,Enemy.relatedObj1+1
	ld a,b
	ldd (hl),a
	ld (hl),Enemy.start
	ld a,h
	pop hl
	ldi (hl),a ; [var30+i] = child object index
	jr nz,@spawnChildLoop

	jp enemyDelete


_eyesoar_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	; Signal children to run around randomly
	ld h,d
	ld l,Enemy.var39
	ld a,(hl)
	or $0a
	ldd (hl),a

	; Jdust var38 (distance away children should be)?
	ld a,(hl)
	and $07
	or $18
	ld (hl),a

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_EYESOAR_VULNERABLE
	ld l,Enemy.counter1
	ld (hl),150
	ld l,Enemy.direction
	ld (hl),$00
	jp _ecom_incSubstate

@substate1:
	ret

@substate2:
	ld e,Enemy.direction
	ld a,(de)
	or a
	ret nz

	inc a
	ld (de),a
	jp enemySetAnimation

@substate3:
	ld b,$0c
	jp _ecom_fallToGroundAndSetState


_eyesoar_state_stub:
	ret


; Flickering into existence
_eyesoar_state8:
	; Something about doors?
	ld a,($cc93)
	or a
	ret nz

	inc a
	ld (wDisabledObjects),a
	call _ecom_decCounter1
	jp nz,_ecom_flickerVisibility

	ld (hl),60  ; [counter1]
	inc l
	ld (hl),180 ; [counter2]

	; [var3a] = $ff (all children are in place at the beginning)
	ld l,Enemy.var3a
	dec (hl)

	ld l,e
	inc (hl) ; [state]
	jp objectSetVisiblec2


; Waiting [counter1] frames until fight begins
_eyesoar_state9:
	call _ecom_decCounter1
	jr nz,_eyesoar_animate

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	inc (hl)

	call _enemyBoss_beginBoss
	jr _eyesoar_animate


; Standing still for [counter1] frames?
_eyesoar_stateA:
	call _eyesoar_updateFormation
	call _ecom_decCounter1
	jr nz,_eyesoar_animate

	ld l,Enemy.state
	inc (hl)

	; Decide on target position (written to var36/var37)
	ld l,Enemy.var36
	ldh a,(<hEnemyTargetY)
	ld b,a
	sub $40
	cp $30
	jr c,++
	cp $c0
	ld b,$40
	jr nc,++
	ld b,$70
++
	ld a,b
	ldi (hl),a ; [var36]

	ldh a,(<hEnemyTargetX)
	ld b,a
	sub $40
	cp $70
	jr c,++
	cp $c0
	ld b,$40
	jr nc,++
	ld b,$b0
++
	ld (hl),b ; [var37]

	jr _eyesoar_animate


; Moving until it reaches its target position
_eyesoar_stateB:
	call _eyesoar_updateFormation
	ld h,d
	ld l,Enemy.var36

	call _ecom_readPositionVars
	sub c
	add $02
	cp $05
	jr nc,++
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jr nc,++

	ld l,Enemy.state
	dec (hl)
	ld l,Enemy.counter1
	ld (hl),60
	jr _eyesoar_animate
++
	call _ecom_moveTowardPosition

_eyesoar_animate:
	jp enemyAnimate


; Spinning in place after being switch hook'd
_eyesoar_stateC:
	call _ecom_decCounter1
	jr nz,_eyesoar_animate

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_EYESOAR

	xor a
	call enemySetAnimation


; Moving back up into the air
_eyesoar_stateD:
	ld h,d
	ld l,Enemy.z
	ld a,(hl)
	sub $80
	ldi (hl),a
	ld a,(hl)
	sbc $00
	ld (hl),a

	cp $fe
	jr nz,_eyesoar_animate

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),240

	ld l,Enemy.var3a
	ld (hl),$0f

	ld l,Enemy.var39
	res 1,(hl)
	call _eyesoar_chooseNewAngle


; Flying around kinda randomly
_eyesoar_stateE:
	call _ecom_decCounter1
	jr nz,++
	ld l,Enemy.var39
	res 3,(hl)
	set 4,(hl)
++
	ld l,Enemy.var3a
	ld a,(hl)
	inc a
	jr nz,++

	; All children dead?
	dec l
	res 4,(hl) ; [var39]
	ld l,e
	ld (hl),$0a ; [state]

	ld l,Enemy.counter1
	ld (hl),$01 ; [counter1]
	inc l
	ld (hl),$08 ; [counter2]
++
	ld l,Enemy.counter1
	ld a,(hl)
	and $3f
	call z,_eyesoar_chooseNewAngle
	call _ecom_applyVelocityForSideviewEnemyNoHoles
	jr _eyesoar_animate


;;
; Checks to update the "formation", that is, the distances away from Eyesoar for the
; children.
_eyesoar_updateFormation:
	; Check all children are at their target distance away from Eyesoar
	ld e,Enemy.var3a
	ld a,(de)
	ld c,a
	and $f0
	cp $f0
	ret nz

	; Increment angle offset for children
	ld a,(wFrameCounter)
	and $03
	jr nz,++
	ld e,Enemy.var3b
	ld a,(de)
	inc a
	and $1f
	ld (de),a
++
	; Check that all children are in formation
	inc c
	jr nz,@notInFormation

	call _ecom_decCounter2
	ret nz
	ld (hl),180

	; Signal children to begin moving to new distance away from eyesoar
	ld l,Enemy.var39
	set 2,(hl)
	ld l,Enemy.var3a
	ld (hl),$f0

	; Choose new distance away
	ld e,Enemy.var38
	ld a,(de)
	inc a
	and $07
	ld b,a
	ld hl,distancesFromEyesoar
	rst_addAToHl
	ld a,(hl)
	or b
	ld (de),a
	ret

@notInFormation:
	ld e,Enemy.var39
	ld a,(de)
	res 2,a
	ld (de),a
	ret

; Distances away from Eyesoar for the children
distancesFromEyesoar:
	.db $18 $28 $30 $20 $30 $18 $28 $20



_eyesoar_dead:
	ld e,Enemy.collisionType
	ld a,(de)
	or a
	jr z,@doneKillingChildren

	ld e,Enemy.var30
@killNextChild:
	ld a,(de)
	ld h,a
	ld l,e
	call _ecom_killObjectH
	inc e
	ld a,e
	cp Enemy.var36
	jr c,@killNextChild

@doneKillingChildren:
	jp _enemyBoss_dead


;;
; Chooses an angle which roughly goes toward the center of the room, plus a small, random
; angle offset.
_eyesoar_chooseNewAngle:
	; Get random angle offset in 'c'
	call getRandomNumber_noPreserveVars
	and $0f
	cp $09
	jr nc,_eyesoar_chooseNewAngle

	ld c,a
	ld b,$00
	ld e,Enemy.yh
	ld a,(de)
	cp (LARGE_ROOM_HEIGHT/2)<<4 + 8
	jr c,+
	inc b
+
	ld e,Enemy.xh
	ld a,(de)
	cp (LARGE_ROOM_WIDTH/2)<<4 + 8
	jr c,+
	set 1,b
+
	ld a,b
	ld hl,@angleVals
	rst_addAToHl
	ld a,(hl)
	add c
	and $1f
	ld e,Enemy.angle
	ld (de),a
	ret

@angleVals:
	.db $08 $00 $10 $18


; ==============================================================================
; ENEMYID_SMOG
;
; Variables:
;   var03: Phase of fight (0-3)
;   counter2: Stops movement temporarily (when sword collision occurs)
;   var30: "Adjacent walls bitset" (bitset of solid walls around smog, similar to the
;          variable used for special objects)
;   var31: Position of the tile it's "hugging"
;   var32: Number of frames to wait for a wall before disappearing and respawning
;   var33: Original value of "direction" (for subid 2 respawning)
;   var34/var35: Original Y/X position (for subid 2 respawning)
;   var36: Counter until "fire projectile" animation will begin
; ==============================================================================
enemyCode7c:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus
	jp _enemyBoss_dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw _smog_state_uninitialized
	.dw _smog_state_stub
	.dw _smog_state_stub
	.dw _smog_state_stub
	.dw _smog_state_stub
	.dw _smog_state_stub
	.dw _smog_state_stub
	.dw _smog_state_stub
	.dw _smog_state8


_smog_state_uninitialized:
	ld e,Enemy.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init
	.dw @subid3Init
	.dw @subid4Init
	.dw @subid5Init
	.dw @subid6Init

@subid0Init:
	ld bc,TX_2f26
	call showText
	ld e,Enemy.counter2
	ld a,60
	ld (de),a
	ld a,$04
	jr @setAnimationAndCommonInit

@subid1Init:
	ld e,Enemy.counter2
	ld a,120
	ld (de),a
	ld a,$00
	jr @setAnimationAndCommonInit

@subid2Init:
	call _enemyBoss_beginBoss

	ld h,d
	ld e,Enemy.direction
	ld l,Enemy.var33
	ld a,(de)
	ldi (hl),a

	ld e,Enemy.yh
	ld a,(de)
	ldi (hl),a
	ld e,Enemy.xh
	ld a,(de)
	ld (hl),a

	ld a,$04
	call @initCollisions
	ld a,$00
	jr @setAnimationAndCommonInit

@subid3Init:
	call _ecom_decCounter2

	ld l,Enemy.collisionType
	res 7,(hl)
	ret nz
	set 7,(hl)

	ld a,(wNumEnemies)
	cp $02
	jr z,@subid4Init

	; BUG?
	ld e,Interaction.counter2
	ld a,60
	ld (de),a
	ld a,$06
	call @initCollisions

	ld a,$02
	jr @setAnimationAndCommonInit

@subid4Init:
	ld a,$04
	ld (de),a ; [subid] = 4

	ld a,TILEINDEX_DUNGEON_a3
	ld c,$11
	call setTile

	ld a,$04

@setAnimationAndCommonInit:
	call enemySetAnimation
	call _smog_setCounterToFireProjectile
	ld e,Enemy.subid
	ld a,(de)
	and $0f
	ld hl,@subidSpeedTable
	rst_addAToHl
	ld a,(hl)
	jp _ecom_setSpeedAndState8AndVisible

@subid5Init:
@subid6Init:
	ld a,ENEMYID_SMOG
	ld b,$00
	call _enemyBoss_initializeRoom
	call _ecom_setSpeedAndState8
	ld l,Enemy.collisionType
	res 7,(hl)
	ret

;;
; @param	a	Collision radius
@initCollisions:
	call objectSetCollideRadius
	ld l,Enemy.enemyCollisionMode
	ld a,ENEMYCOLLISION_PROJECTILE_WITH_RING_MOD
	ld (hl),a
	ret

@subidSpeedTable:
	.db SPEED_00
	.db SPEED_00
	.db SPEED_e0
	.db SPEED_80
	.db SPEED_40


_smog_state_stub:
	ret


_smog_state8:
	ld e,Enemy.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw _smog_state8_subid0
	.dw _smog_state8_subid1
	.dw _smog_state8_subid2
	.dw _smog_state8_subid3
	.dw _smog_state8_subid4
	.dw _smog_state8_subid5
	.dw _smog_deleteSelf

; Splitting into two?
_smog_state8_subid0:
	call retIfTextIsActive
	call enemyAnimate
	call _ecom_decCounter2
	ret nz

	call getFreeEnemySlot
	ld (hl),ENEMYID_SMOG
	inc l
	ld (hl),$01 ; [child.subid]
	ld bc,$00f0
	call objectCopyPositionWithOffset

	call getFreeEnemySlot
	ld (hl),ENEMYID_SMOG
	inc l
	ld (hl),$01 ; [child.subid]
	ld bc,$0010
	call objectCopyPositionWithOffset
	jr _smog_deleteSelf

_smog_state8_subid1:
	call enemyAnimate
	call _ecom_decCounter2
	ret nz

_smog_deleteSelf:
	call objectCreatePuff
	call decNumEnemies
	jp enemyDelete


; Small or medium-sized smog
_smog_state8_subid2:
_smog_state8_subid3:
	ld e,Enemy.var2a
	ld a,(de)
	bit 7,a
	jr z,@noCollision

	and $7f
	cp ITEMCOLLISION_L1_SWORD
	jr c,@noCollision
	cp ITEMCOLLISION_SWORD_HELD+1
	jr nc,@noCollision

	; If sword collision occurred, stop movement briefly?
	ld e,Enemy.counter2
	ld a,30
	ld (de),a

@noCollision:
	call _ecom_decCounter2
	jp nz,enemyAnimate

	call getThisRoomFlags
	bit ROOMFLAG_BIT_40,a
	jr nz,_smog_deleteSelf

	call enemyAnimate

	; If animParameter is nonzero, shoot projectile
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	jr z,@doneShootingProjectile

	ld e,Enemy.subid
	ld a,(de)
	and $0f
	add a
	add -4
	call enemySetAnimation
	call _smog_setCounterToFireProjectile
	ld b,PARTID_SMOG_PROJECTILE
	call _ecom_spawnProjectile
	call objectCopyPosition

@doneShootingProjectile:
	call _smog_decCounterToFireProjectile
	jr z,@runSubstate

	ld e,Enemy.subid
	ld a,(de)
	and $0f
	add a
	add -3
	call enemySetAnimation

@runSubstate:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Just spawned, or need to redetermine what direction to move in based on surrounding
; walls
@substate0:
	call _smog_applySpeed
	call _smog_checkHuggingWall
	jr nz,@checkHitWall

	ld l,Enemy.var32
	ld (hl),$10

@gotoState1:
	; Update direction based on angle
	ld e,Enemy.angle
	ld a,(de)
	add a
	swap a
	dec e
	ld (de),a

	; Go to substate 1
	ld e,Enemy.substate
	ld a,$01
	ld (de),a
	jp _smog_applySpeed

@checkHitWall:
	call _smog_checkHitWall
	jr nz,@hitWall
	ret

@substate1:
	call _smog_applySpeed
	call _smog_checkHuggingWall
	jr nz,@notHuggingWall

	; The wall being hugged disappeared.

	; Check if this is a small or medium smog.
	ld l,Enemy.subid
	ld a,(hl)
	and $0f
	cp $02
	jr nz,@mediumSmog

	; It's a small smog. Decrement counter before respawning
	ld l,Enemy.var32
	dec (hl)
	jr nz,@gotoState1

	; Respawn
	call objectCreatePuff
	ld h,d
	ld l,Enemy.var33
	ld e,Enemy.direction
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a
	call objectCreatePuff
	jr @notHuggingWall

@mediumSmog:
	; Just keep moving forward until we hit a wall
	call _smog_checkHitWall
	ret z

@hitWall:
	; Rotate direction clockwise or counterclockwise
	ld b,$01
	ld e,Enemy.subid
	ld a,(de)
	bit 7,a
	jr z,+
	ld b,$ff
+
	ld e,Enemy.direction
	ld a,(de)
	sub b
	and $03
	ld (de),a
	ld e,Enemy.substate
	ld a,$02
	ld (de),a
	ret

; Moving normally along wall
@substate2:
	call _smog_updateAdjacentWallsBitset
	call _smog_checkHitWall
	jr nz,@hitWall

@notHuggingWall:
	ld e,Enemy.substate
	xor a
	ld (de),a
	jp _smog_applySpeed


; Large smog (can be attacked)
_smog_state8_subid4:
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_ELECTRIC_SHOCK
	jr nz,++

	; Link attacked the boss and got shocked.
	ld a,$03
	ld e,Enemy.substate
	ld (de),a
	ld a,70
	ld e,Enemy.counter2
	ld (de),a
++
	call enemyAnimate
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,$01
	ld (de),a ; [substate] = 1
	dec a
	ld e,Enemy.speed
	ld (de),a

	call _ecom_updateAngleTowardTarget

	ld e,Enemy.counter1
	ld a,20
	ld (de),a

; Speeding up
@substate1:
	call @func_72b2
	ret nz

	add SPEED_20
	ld (hl),a
	cp SPEED_c0
	ret nz

	jp _ecom_incSubstate

; Slowing down
@substate2:
	call @func_72b2
	ret nz

	sub SPEED_20
	ld (hl),a
	ret nz

	ld l,Enemy.substate
	ld (hl),a ; [substate] = 0
	ret

;;
; @param[out]	zflag	z if counter1 reached 0 (should update speed)
@func_72b2:
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	jr z,@parameter0

	dec a
	jr nz,@parameter1

	ld a,$04
	call enemySetAnimation
	jp _smog_setCounterToFireProjectile

@parameter1:
	ld b,PARTID_SMOG_PROJECTILE
	call _ecom_spawnProjectile
	ld l,Part.subid
	inc (hl)
	ld bc,$0800
	jp objectCopyPositionWithOffset

@parameter0:
	call _smog_decCounterToFireProjectile
	jr z,++
	ld a,$05
	call enemySetAnimation
++
	call objectApplySpeed
	call _ecom_bounceOffScreenBoundary
	call _ecom_decCounter1
	ret nz

	ld (hl),20
	ld l,Enemy.speed
	ld a,(hl)
	ret

; Stop while Link is shocked
@substate3:
	call _ecom_decCounter2
	ret nz
	xor a
	ld (de),a
	ld l,Enemy.collisionType
	set 7,(hl)
	ret


_smog_state8_subid5:
	ret


;;
; @param[out]	zflag	nz if hit a wall
_smog_checkHitWall:
	ld e,Enemy.direction
	ld a,(de)
	swap a
	rrca
	inc e
	ld (de),a
	jr _smog_checkAdjacentWallsBitset

_smog_positionOffsets:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

;;
; @param[out]	zflag	nz if hugging a wall
_smog_checkHuggingWall:
	ld b,$ff
	ld e,Enemy.subid
	ld a,(de)
	bit 7,a
	jr z,+
	ld b,$01
+
	; Get direction clockwise or counterclockwise from current direction
	ld e,Enemy.direction
	ld a,(de)
	sub b
	and $03
	ld c,a

	; Set "angle" value perpendicular to "direction" value
	swap a
	rrca
	inc e
	ld (de),a

	; Get position offset in direction smog is moving in
	ld a,c
	ld hl,_smog_positionOffsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a

	; Put the position of the next tile in var31
	call objectGetRelativeTile
	ld h,>wRoomCollisions
	ld e,Enemy.var31
	ld a,l
	and $0f
	ld c,a
	ld a,l
	swap a
	and $0f
	add c
	ld (de),a

;;
; Checks if there is a wall in the direction of the "angle" variable. (Angle could be
; facing forward, or in the direction of the wall being hugged, depending when this is
; called.)
;
; @param[out]	zflag	nz if a wall exists
_smog_checkAdjacentWallsBitset:
	ld h,d
	ld l,Enemy.angle
	ld a,(hl)
	bit 3,a
	jr z,@upOrDown

@leftOrRight:
	ld l,Enemy.var30
	ld b,(hl)
	bit 4,a
	ld a,$03
	jr z,+
	ld a,$0c
+
	and b
	ret

@upOrDown:
	ld l,Enemy.var30
	ld c,(hl)
	bit 4,a
	ld a,$30
	jr nz,+
	ld a,$c0
+
	and c
	ret

;;
; Applies speed and updates "adjacentWallsBitset"
_smog_applySpeed:
	; Update angle based on direction
	ld e,Enemy.direction
	ld a,(de)
	swap a
	rrca
	inc e
	ld (de),a
	call objectApplySpeed

_smog_updateAdjacentWallsBitset:
	; Clear collision value of wall being hugged?
	ld e,Enemy.var30
	xor a
	ld (de),a

	; Update each bit of adjacent walls bitset
	ld h,d
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	ld a,$01
	ldh (<hFF8B),a
	ld hl,@offsetTable
@loop:
	ldi a,(hl)
	add b
	ld b,a
	ldi a,(hl)
	add c
	ld c,a
	push hl
	call getTileAtPosition
	ld h,>wRoomCollisions
	ld a,(hl)
	or a
	jr z,+
	scf
+
	pop hl
	ldh a,(<hFF8B)
	rla
	ldh (<hFF8B),a
	jr nc,@loop

	ld e,Enemy.var30
	ld (de),a
	ret

@offsetTable:
	.db $f7 $f8
	.db $00 $0f
	.db $11 $f1
	.db $00 $0f
	.db $f0 $f0
	.db $0f $00
	.db $f1 $11
	.db $0f $00

;;
; @param[out]	zflag	nz if smog should begin "firing projectile" animation
_smog_decCounterToFireProjectile:
	ld e,Enemy.var36
	ld a,(de)
	or a
	ret z

	dec a
	ld (de),a
	jr nz,@zflag

	or d
	ret
@zflag:
	xor a
	ret


;;
; For given values of subid and var03, this reads one of four randomly chosen values and
; puts that value into var36 (counter until next projectile is fired).
_smog_setCounterToFireProjectile:
	ld e,Enemy.subid
	ld a,(de)
	and $0f
	sub $02
	ld hl,@table
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	inc e
	ld a,(de) ; [var03]
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	call getRandomNumber
	and $03
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.var36
	ld (de),a
	ret

@table:
	.db @subid2 - CADDR
	.db @subid3 - CADDR
	.db @subid4 - CADDR

@subid2:
	.db @subid2_0 - CADDR
	.db @subid2_1 - CADDR
	.db @subid2_2 - CADDR
	.db @subid2_3 - CADDR
@subid3:
	.db @subid3_0 - CADDR
	.db @subid3_1 - CADDR
	.db @subid3_2 - CADDR
	.db @subid3_3 - CADDR
@subid4:
	.db @subid4_0 - CADDR
	.db @subid4_1 - CADDR
	.db @subid4_2 - CADDR
	.db @subid4_3 - CADDR

@subid2_0:
	.db $78 $f0 $ff $ff
@subid2_1:
	.db $78 $78 $b4 $f0
@subid2_2:
	.db $50 $50 $64 $78
@subid2_3:
	.db $32 $32 $3c $50

@subid3_0:
	.db $00 $00 $00 $00
@subid3_1:
	.db $50 $78 $96 $b4
@subid3_2:
	.db $32 $50 $96 $b4
@subid3_3:
	.db $32 $50 $64 $96

@subid4_0:
	.db $5a $78 $64 $96
@subid4_1:
	.db $1e $28 $32 $3c
@subid4_2:
	.db $14 $1e $32 $3c
@subid4_3:
	.db $14 $1e $28 $32


; ==============================================================================
; ENEMYID_OCTOGON
;
; Variables:
;   var03: Where it actually is? (0 = above water, 1 = below water)
;   counter2: Counter until it moves above or below the water?
;   relatedObj1: Reference to other instance of ENEMYID_OCTOGON?
;   var30: Index in "target position list"?
;   var31/var32: Target position to move to
;   var33/var34: Original Y/X position when this screen was entered
;   var35: Counter for animation purposes?
;   var36: Counter which, when 0 is reached, invokes a change of state (ie. fire at link
;          instead of moving around)
;   var37: Health value from when octogon appeared here (used to decide when to surface or
;          not)
; ==============================================================================
enemyCode7d:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@justHit

	; Dead
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jp z,enemyDelete

	ld e,Enemy.collisionType
	ld a,(de)
	or a
	call nz,_ecom_killRelatedObj1
	jp _enemyBoss_dead

@justHit:
	ld a,Object.invincibilityCounter
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(de)
	ld (hl),a

	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr z,@normalStatus

	; Check if enough damage has been dealt to rise above or below the water
	ld h,d
	ld l,Enemy.health
	ld e,Enemy.var37
	ld a,(de)
	sub (hl)
	cp $0a
	jr c,+
	ld l,Enemy.counter2
	ld (hl),$01
+
	ld e,Enemy.health
	ld a,(de)
	or a
	jr nz,@normalStatus

	; Health just reached 0
	ld hl,wGroup5Flags+(<ROOM_AGES_52d)
	set 7,(hl)
	ld l,<ROOM_AGES_536
	set 7,(hl)
	ld a,MUS_BOSS
	ld (wActiveMusic),a
	ret

@normalStatus:
	call @doJumpTable

	ld h,d
	ld l,Enemy.var34
	ld e,Enemy.xh
	ld a,(de)
	ldd (hl),a
	ld e,Enemy.yh
	ld a,(de)
	ld (hl),a
	ld l,Enemy.direction
	ld a,(hl)
	cp $10
	jr c,+
	ld a,$08
+
	and $0c
	rrca
	ld hl,@offsetData
	rst_addAToHl

	; Add offsets to Y/X position
	ld a,(de)
	add (hl)
	ld (de),a
	ld e,Enemy.xh
	inc hl
	ld a,(de)
	add (hl)
	ld (de),a

	; Store some persistent variables?

	ld hl,wTmpcfc0.octogonBoss.var03
	ld e,Enemy.var03
	ld a,(de)
	ldi (hl),a

	ld e,Enemy.direction
	ld a,(de)
	ldi (hl),a ; [wTmpcfc0.octogonBoss.direction]

	ld e,Enemy.health
	ld a,(de)
	ldi (hl),a ; [wTmpcfc0.octogonBoss.health]

	ld e,Enemy.var33
	ld a,(de)
	ldi (hl),a ; [wTmpcfc0.octogonBoss.var33]
	inc e
	ld a,(de) ; [var34]
	ldi (hl),a ; [wTmpcfc0.octogonBoss.var34]

	ld e,Enemy.var30
	ld a,(de)
	ld (hl),a ; [wTmpcfc0.octogonBoss.var30]
	ret

@offsetData:
	.db $f8 $00
	.db $00 $08
	.db $08 $00
	.db $00 $f8

@doJumpTable:
	ld e,Enemy.state
	ld a,(de)
	cp $08
	ld e,Enemy.subid
	jr c,@state8OrLess

	ld a,(de)
	rst_jumpTable
	.dw _octogon_subid0
	.dw _octogon_subid1
	.dw _octogon_subid2


@state8OrLess:
	rst_jumpTable
	.dw _octogon_state_uninitialized
	.dw _octogon_state_stub
	.dw _octogon_state_stub
	.dw _octogon_state_stub
	.dw _octogon_state_stub
	.dw _octogon_state_stub
	.dw _octogon_state_stub
	.dw _octogon_state_stub


_octogon_state_uninitialized:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr nz,@notSubid2

	ld e,Enemy.enemyCollisionMode
	ld a,ENEMYCOLLISION_OCTOGON_SHELL
	ld (de),a
	jp _ecom_setSpeedAndState8

@notSubid2:
	ld a,ENEMYID_OCTOGON
	ld (wEnemyIDToLoadExtraGfx),a
	ld a,PALH_88
	call loadPaletteHeader

	ld hl,wTmpcfc0.octogonBoss.loadedExtraGfx
	ld a,(hl)
	or a
	jr nz,++
	inc (hl)
	call _enemyBoss_initializeRoomWithoutExtraGfx
++
	; Create "child" with subid 2? They will reference each other with relatedObj2.
	call getFreeEnemySlot_uncounted
	ret nz
	ld (hl),ENEMYID_OCTOGON
	inc l
	ld (hl),$02 ; [child.subid]
	ld l,Enemy.relatedObj1
	ld e,l
	ld a,Enemy.start
	ld (de),a
	ldi (hl),a
	inc e
	ld a,h
	ld (de),a
	ld (hl),d

	ld a,SPEED_100
	call _ecom_setSpeedAndState8

	ld l,Enemy.var35
	ld (hl),$0c ; [this.var35]
	inc l
	ld (hl),120 ; [var36]

	ld l,Enemy.subid
	ld a,(hl)
	add a
	ld b,a
	call objectSetVisible83

	; Load persistent variables

	ld hl,wTmpcfc0.octogonBoss.var30
	ld e,Enemy.var30
	ldd a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ldd a,(hl)
	ld (de),a
	ld e,Enemy.yh
	ldd a,(hl)
	ld (de),a
	ld e,Enemy.health
	ldd a,(hl)
	ld (de),a
	ld e,Enemy.var37
	ld (de),a
	ld e,Enemy.direction
	ldd a,(hl)
	ld (de),a
	ld e,Enemy.var03
	ld a,(hl)
	ld (de),a

	add b
	rst_jumpTable
	.dw @subid0_0
	.dw @subid0_1
	.dw @subid1_0
	.dw @subid1_1

@subid0_0:
	call _octogon_fixPositionAboveWater

	ld h,d
	ld l,Enemy.counter2
	ld (hl),120

	ld l,Enemy.var30
	ld a,(hl)
	inc a
	jp z,_octogon_chooseRandomTargetPosition

	call _octogon_loadTargetPosition
	ret z
	dec hl
	dec hl
	dec hl
	ld a,(hl)
	ld e,Enemy.direction
	ld (de),a
	jp enemySetAnimation

@subid0_1:
	call _octogon_fixPositionAboveWater
	jp _octogon_loadNormalSubmergedAnimation

@subid1_0:
	ld h,d
	ld l,Enemy.collisionType
	res 7,(hl)

	; Delete child object (subid 2)
	ld a,Object.start
	call objectGetRelatedObject1Var
	ld b,$40
	call clearMemory

	jp objectSetInvisible

@subid1_1:
	ld a,$01
	ld (wTmpcfc0.octogonBoss.posNeedsFixing),a

	ld h,d
	ld l,Enemy.oamFlagsBackup
	ld a,$06
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.counter1
	ld (hl),90
	inc l
	ld (hl),150 ; [counter2]

	ld l,Enemy.var31
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a

	call _ecom_updateAngleTowardTarget
	add $04
	and $18
	rrca
	ld e,Enemy.direction
	ld (de),a
	call enemySetAnimation

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_BUBBLE
	inc l
	inc (hl) ; [bubble.subid] = 1
	ld l,Interaction.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d
	ret


_octogon_state_stub:
	ret


_octogon_subid0:
	; Initialize Y/X position
	ld h,d
	ld l,Enemy.var33
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a

	; Check if submerged
	ld e,Enemy.var03
	ld a,(de)
	or a
	ld e,Enemy.state
	ld a,(de)
	jp nz,_octogon_subid0BelowWater

	sub $08
	rst_jumpTable
	.dw _octogon_subid0AboveWater_state8
	.dw _octogon_subid0AboveWater_state9
	.dw _octogon_subid0AboveWater_stateA
	.dw _octogon_subid0AboveWater_stateB
	.dw _octogon_subid0AboveWater_stateC
	.dw _octogon_subid0AboveWater_stateD
	.dw _octogon_subid0AboveWater_stateE
	.dw _octogon_subid0AboveWater_stateF
	.dw _octogon_subid0AboveWater_state10
	.dw _octogon_subid0AboveWater_state11


_octogon_subid0AboveWater_state8:
	; Wait for shutters to close
	ld a,($cc93)
	or a
	ret nz

	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	; Initialize music if necessary
	ld hl,wActiveMusic
	ld a,(hl)
	or a
	ret z
	ld (hl),$00
	ld a,MUS_BOSS
	jp playSound


; Moving normally around the room
_octogon_subid0AboveWater_state9:
	call _octogon_decVar36IfNonzero

	; Submerge into water after set amount of time
	ld a,(wFrameCounter)
	and $03
	jr nz,++
	ld l,Enemy.counter2
	dec (hl)
	jp z,_octogon_subid0_submergeIntoWater
++
	; Check if lined up to fire at Link.
	; BUG: Should set 'b', not 'c'? (b happens to be $0f here, so it works out ok.)
	ld c,$08
	call objectCheckCenteredWithLink
	jp nc,_octogon_updateMovementAndAnimation

	; If enough time has passed, begin firing at Link.
	ld h,d
	ld l,Enemy.var36
	ld a,(hl)
	or a
	jp nz,_octogon_updateMovementAndAnimation

	ld (hl),120 ; [var36]

	; Begin turning toward Link to fire.
	call objectGetAngleTowardEnemyTarget
	add $14
	and $18
	ld b,a
	ld e,Enemy.direction
	ld a,(de)
	and $0c
	add a
	cp b
	jp nz,_octogon_updateMovementAndAnimation

	ld h,d
	ld l,Enemy.state
	ld (hl),$0b

	ld l,Enemy.counter1
	ld (hl),$08
	ret


_octogon_subid0AboveWater_stateA:
_octogon_subid0_pauseMovement:
	call _ecom_decCounter1
	ret nz

	ld l,e
	dec (hl) ; [state]--

	ld l,Enemy.var30
	ld a,(hl)
	inc a
	ld (hl),a

	and $07
	jr nz,_octogon_loadTargetPosition


;;
_octogon_chooseRandomTargetPosition:
	call getRandomNumber
	and $18
	ld (hl),a

;;
; @param	hl	Pointer to index for a table
; @param[out]	hl	Pointer to some data
; @param[out]	zflag	z if animation changed
_octogon_loadTargetPosition:
	ld a,(hl)
	add a
	add (hl)
	ld hl,@targetPositionList
	rst_addAToHl
	ld e,Enemy.var31
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a ; [var32]
	ld e,Enemy.var03
	ld a,(de)
	or a
	ret nz

	ld a,(hl)
	bit 7,a
	ret nz

	ld e,Enemy.direction
	ld (de),a
	call enemySetAnimation
	xor a
	ret

; data format: target position (2 bytes), animation
@targetPositionList:
	.db $28 $38 $00
	.db $58 $30 $0c
	.db $88 $38 $ff
	.db $88 $78 $08
	.db $88 $b8 $ff
	.db $58 $c0 $04
	.db $28 $b8 $ff
	.db $28 $78 $00

	.db $28 $b8 $00
	.db $58 $c0 $04
	.db $88 $b8 $ff
	.db $88 $78 $08
	.db $88 $38 $ff
	.db $58 $30 $0c
	.db $28 $38 $ff
	.db $28 $78 $00

	.db $28 $38 $00
	.db $58 $30 $0c
	.db $88 $38 $ff
	.db $88 $78 $08
	.db $88 $38 $ff
	.db $58 $30 $0c
	.db $28 $38 $ff
	.db $28 $78 $00

	.db $28 $b8 $00
	.db $58 $c0 $04
	.db $88 $b8 $ff
	.db $88 $78 $08
	.db $88 $b8 $ff
	.db $58 $c0 $04
	.db $28 $b8 $ff
	.db $28 $78 $00


; Turning around to fire projectile (or just after doing so)?
_octogon_subid0AboveWater_stateB:
_octogon_subid0AboveWater_stateF:
	ld b,$06
	jr _octogon_subid0AboveWater_turningAround


; Turning around?
_octogon_subid0AboveWater_stateC:
	ld b,$18

_octogon_subid0AboveWater_turningAround:
	call _ecom_decCounter1
	ret nz

	ld (hl),b
	ld l,e
	inc (hl) ; [state]++

	ld l,Enemy.direction
	ld a,(hl)
	add $04
	and $0c
	ld (hl),a
	jp enemySetAnimation


; About to fire projectile?
_octogon_subid0AboveWater_stateD:
	call _ecom_decCounter1
	ret nz

	ld (hl),$08

	ld l,e
	inc (hl) ; [state] = $0e

	ld l,Enemy.direction
	ld a,(hl)
	add $02
	ld (hl),a
	jp enemySetAnimation


; Firing projectile
_octogon_subid0AboveWater_stateE:
	call _ecom_decCounter1
	ret nz

	ld (hl),40
	ld l,e
	inc (hl) ; [state] = $0f
	ld l,Enemy.direction
	inc (hl)
	ld a,(hl)
	call enemySetAnimation
	jp _octogon_fireOctorokProjectile


; Turning around after firing projectile?
_octogon_subid0AboveWater_state10:
	ld b,$0c
	jr _octogon_subid0AboveWater_turningAround


; Delay before resuming normal movement
_octogon_subid0AboveWater_state11:
	call _ecom_decCounter1
	ret nz
	ld l,e
	ld (hl),$09 ; [state]
	ret


; Octogon code where octogon itself is below water, and link is above water
_octogon_subid0BelowWater:
	sub $08
	rst_jumpTable
	.dw _octogon_subid0BelowWater_state8
	.dw _octogon_subid0BelowWater_state9
	.dw _octogon_subid0BelowWater_stateA
	.dw _octogon_subid0BelowWater_stateB
	.dw _octogon_subid0BelowWater_stateC
	.dw _octogon_subid0BelowWater_stateD


; Swimming normally
_octogon_subid0BelowWater_state8:
	call enemyAnimate

	; Check whether to play swimming sound
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	jr nz,++
	inc a
	ld (de),a
	ld a,SND_LINK_SWIM
	call playSound
++
	call _octogon_decVar36IfNonzero
	jp nz,_octogon_moveTowardTargetPosition

	; Reached target position
	ld (hl),90 ; [var36]
	call getRandomNumber
	cp $50
	jp nc,_octogon_moveTowardTargetPosition

	; Random chance of going to state $0a (firing projectile)
	ld l,Enemy.state
	ld (hl),$0a
	ld l,Enemy.counter1
	ld (hl),60
	jr _octogon_loadNormalSubmergedAnimation


; Waiting in place before moving again
_octogon_subid0BelowWater_state9:
	call _octogon_subid0_pauseMovement
_octogon_animate:
	jp enemyAnimate


; Delay before firing projectile
_octogon_subid0BelowWater_stateA:
	call _ecom_decCounter1
	jr z,@beginFiring

	ld a,(hl)
	and $07
	ret nz
	ld l,Enemy.direction
	ld a,(hl)
	xor $01
	ld (hl),a
	jp enemySetAnimation

@beginFiring:
	ld (hl),$08
	ld l,e
	inc (hl) ; [state] = $0b

_octogon_loadNormalSubmergedAnimation:
	ld e,Enemy.direction
	ld a,$12
	ld (de),a
	jp enemySetAnimation


; Firing projectile
_octogon_subid0BelowWater_stateB:
	call _ecom_decCounter1
	jr z,@fireProjectile

	ld a,(hl)
	cp $06
	ret nz

	ld l,Enemy.direction
	ld a,$14
	ld (hl),a
	jp enemySetAnimation

@fireProjectile:
	ld (hl),60 ; [counter1]
	ld l,e
	inc (hl) ; [state] = $0c
	ld b,PARTID_OCTOGON_DEPTH_CHARGE
	call _ecom_spawnProjectile
	jr _octogon_loadNormalSubmergedAnimation


; Delay before moving again
_octogon_subid0BelowWater_stateC:
	call _ecom_decCounter1
	jr nz,_octogon_animate

	ld l,Enemy.var36
	ld (hl),90

	ld l,e
	ld (hl),$08 ; [state]

	jr _octogon_animate


; Just submerged into water
_octogon_subid0BelowWater_stateD:
	call _ecom_decCounter1
	ret nz
	ld (hl),30

	ld l,e
	ld (hl),$08 ; [state]

	jr _octogon_loadNormalSubmergedAnimation


; Link is below water
_octogon_subid1:
	ld h,d
	ld l,Enemy.var33
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a

	ld e,Enemy.var03
	ld a,(de)
	or a
	ld e,Enemy.state
	ld a,(de)
	jp z,_octogon_subid1_aboveWater

	sub $08
	rst_jumpTable
	.dw _octogon_subid1_belowWater_state8
	.dw _octogon_subid1_belowWater_state9
	.dw _octogon_subid1_belowWater_stateA
	.dw _octogon_subid1_belowWater_stateB
	.dw _octogon_subid1_belowWater_stateC


; Normal movement (moving toward some target position decided already)
_octogon_subid1_belowWater_state8:
	call _octogon_decVar36IfNonzero
	jr nz,@normalMovement

	; var36 reached 0
	ld (hl),90

	; 50% chance to do check below...
	call getRandomNumber
	rrca
	jr nc,@normalMovement

	; If the direction toward Link has not changed...
	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	ld b,a
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	cp b
	ld h,d
	jr nz,@normalMovement

	; Go to state $0b (fire bubble projectile)
	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.counter1
	ld (hl),$08
	ld l,Enemy.direction
	ld a,(hl)
	and $0c
	add $02
	ld (hl),a
	jp enemySetAnimation

@normalMovement:
	; Will rise above water when counter2 reaches 0
	ld a,(wFrameCounter)
	and $03
	jr nz,++
	ld l,Enemy.counter2
	dec (hl)
	jp z,_octogon_beginRisingAboveWater
++
	call _ecom_decCounter1
	jr nz,_octogon_updateMovementAndAnimation

	ld (hl),60 ; [counter1]

	ld l,Enemy.state
	inc (hl) ; [state] = 9
	ret

;;
; Moves toward target position and updates animation + sound effects accordingly
_octogon_updateMovementAndAnimation:
	call _octogon_moveTowardTargetPosition

	ld h,d
	ld l,Enemy.var35
	dec (hl)
	ret nz

	ld (hl),$0c

	ld l,Enemy.direction
	ld a,(hl)
	xor $01
	ld (hl),a
	call enemySetAnimation

	ld e,Enemy.subid
	ld a,(de)
	or a
	ld a,SND_LINK_SWIM
	jp nz,playSound

	; Above-water only (subid 0)

;;
_octogon_doSplashAnimation:
	ld a,SND_SWORDSPIN
	call playSound

	; Splash animation
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_OCTOGON_SPLASH
	ld e,Enemy.direction
	ld a,(de)
	and $0c
	ld l,Interaction.direction
	ld (hl),a
	jp objectCopyPosition


; Waiting in place until counter1 reaches 0, then will charge at Link.
_octogon_subid1_belowWater_state9:
	call _ecom_decCounter1
	ret nz

	ld (hl),$0c ; [counter1]

	ld l,e
	inc (hl) ; [state] = $0a

	; Save Link's current position as target position to charge at
	ld l,Enemy.var31
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a

	; Do some weird math to decide animation
	call _ecom_updateAngleTowardTarget
	ld h,d
	ld l,Enemy.direction
	ld a,(hl)
	and $0c
	add a
	ld b,a

	ld e,Enemy.angle
	ld a,(de)
	sub b
	and $1f
	ld b,a
	sub $04
	cp $18
	ret nc

	bit 4,b
	ld a,$04
	jr z,+
	ld a,$0c
+
	add (hl)
	and $0c
	ld (hl),a
	jp enemySetAnimation


; Waiting for a split second before charging
_octogon_subid1_belowWater_stateA:
	call _ecom_decCounter1
	ret nz

	ld (hl),90

	ld l,e
	ld (hl),$08 ; [state]

	ld l,Enemy.angle
	ldd a,(hl)
	add $04
	and $18
	rrca
	ld (hl),a
	jp enemySetAnimation


; Delay before firing bubble
_octogon_subid1_belowWater_stateB:
	call _ecom_decCounter1
	ret nz

	ld (hl),60

	ld l,e
	inc (hl) ; [state] = $0c

	ld l,Enemy.direction
	inc (hl)
	ld a,(hl)
	call enemySetAnimation

	call getFreePartSlot
	jr nz,++
	ld (hl),PARTID_OCTOGON_BUBBLE
	call _octogon_initializeProjectile
++
	jp _octogon_doSplashAnimation


; Delay after firing bubble
_octogon_subid1_belowWater_stateC:
	call _ecom_decCounter1
	ret nz

	ld l,e
	ld (hl),$08 ; [state]

	ld l,Enemy.direction
	ld a,(hl)
	and $0c
	ld (hl),a
	jp enemySetAnimation


; Octogon is above water, but Link is below water
_octogon_subid1_aboveWater:
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA

@state8:
	call _ecom_decCounter1
	ret nz
	ld (hl),120
	ld b,PARTID_OCTOGON_DEPTH_CHARGE
	jp _ecom_spawnProjectile


; States $09-$0a used while moving to surface
@state9:
	call _ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state] = $0a

	ld l,Enemy.direction
	ld a,$11
	ld (hl),a
	call enemySetAnimation

	ld a,SND_ENEMY_JUMP
	call playSound

	ld bc,$0208
	jp _enemyBoss_spawnShadow

@stateA:
	ld h,d
	ld l,Enemy.z
	ld a,(hl)
	sub <($00c0)
	ldi (hl),a
	ld a,(hl)
	sbc >($00c0)
	ld (hl),a

	cp $d0
	ret nc

	cp $c0
	jp nz,_ecom_flickerVisibility

	ld (hl),$00

	ld l,e
	ld (hl),$08 ; [state] = 8

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.counter1
	ld (hl),60

	call objectSetInvisible
	jp _ecom_killRelatedObj1


; Invisible collision box for the shell
_octogon_subid2:
	ld a,Object.direction
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $10
	jr c,+
	ld a,$08
+
	and $0c
	push hl
	ld hl,@data
	rst_addAToHl

	ld e,Enemy.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	ldi a,(hl)
	ld c,(hl)
	ld b,a
	pop hl
	call objectTakePositionWithOffset
	pop hl
	ret

; Data format: collisionRadiusY, collisionRadiusX, Y position, X position
@data:
	.db $06 $0a $0e $00
	.db $0a $06 $00 $f2
	.db $06 $0a $f2 $00
	.db $0a $06 $00 $0e


;;
_octogon_subid0_submergeIntoWater:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0d
	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.var03
	ld (hl),$01
	ld l,Enemy.counter1
	ld (hl),$10
	ld l,Enemy.var36
	ld (hl),90
	ld l,Enemy.direction
	ld a,$15
	ld (hl),a
	jp enemySetAnimation


;;
_octogon_beginRisingAboveWater:
	ld h,d
	ld l,Enemy.state
	ld (hl),$09
	ld l,Enemy.var03
	ld (hl),$00

	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.var36
	ld (hl),90

	ld l,Enemy.direction
	ld a,$10
	ld (hl),a
	jp enemySetAnimation


;;
; Takes current position, fixes it to the closest valid spot above water, and decides
; a value for var30 (target position index).
_octogon_fixPositionAboveWater:
	ld a,(wTmpcfc0.octogonBoss.posNeedsFixing)
	or a
	ret z

	xor a
	ld (wTmpcfc0.octogonBoss.posNeedsFixing),a

	ld h,d
	ld l,Enemy.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)
	call _octogon_getClosestTargetPositionIndex
	ld l,e

	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	call _octogon_getClosestTargetPositionIndex

	; BUG: supposed to compare 'l' against 'e', not 'a'. As a result octogon may not
	; move out of the way properly if Link surfaces in the same position.
	; (In effect, it only matters when they're both around centre-bottom, and maybe
	; one other spot?)
	cp l
	ld a,l
	jr nz,++
	ld hl,@linkCompensationIndices
	rst_addAToHl
	ld a,(hl)
++
	add a
	ld hl,@data
	rst_addDoubleIndex
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a

	ld h,d
	ld l,e
	bit 7,a
	jp nz,_octogon_chooseRandomTargetPosition
	jp _octogon_loadTargetPosition

; Data format: Y, X, var30 (target position index), unused
@data:
	.db $28 $30 $01 $00
	.db $28 $78 $ff $00
	.db $28 $c0 $09 $00
	.db $58 $30 $02 $00
	.db $00 $00 $ff $00
	.db $58 $c0 $0a $00
	.db $88 $30 $0d $00
	.db $88 $78 $0c $00
	.db $88 $c0 $05 $00

; Corresponding index from this table is used if Link would have surfaced on top of
; octogon.
@linkCompensationIndices:
	.db $01 $00 $01 $06 $00 $08 $03 $08 $05

;;
_octogon_fireOctorokProjectile:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_OCTOROK_PROJECTILE

;;
; @param	h	Projectile (could be PARTID_OCTOROK_PROJECTILE or
;			PARTID_OCTOGON_BUBBLE)
_octogon_initializeProjectile:
	ld e,Enemy.direction
	ld a,(de)
	and $0c
	ld b,a
	add a
	ld l,Part.angle
	ld (hl),a

	ld a,b
	rrca
	push hl
	ld hl,@positionOffsets
	rst_addAToHl
	ldi a,(hl)
	ld b,a
	ld c,(hl)

	pop hl
	call objectCopyPositionWithOffset
	ld a,SND_STRIKE
	jp playSound

@positionOffsets:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

;;
_octogon_decVar36IfNonzero:
	ld h,d
	ld l,Enemy.var36
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret

;;
; Moves toward position stored in var31/var32. Increments state and sets counter1 to 30
; when it reaches that position.
_octogon_moveTowardTargetPosition:
	ld h,d
	ld l,Enemy.var31
	call _ecom_readPositionVars
	sub c
	inc a
	cp $03
	jp nc,_ecom_moveTowardPosition

	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	jp nc,_ecom_moveTowardPosition

	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),30
	ret


;;
; Given a position, this determines the "target position index" (value for var30) which
; that position most closely corresponds to.
;
; @param	bc	Position
; @param[out]	a
; @param[out]	e
_octogon_getClosestTargetPositionIndex:
	ld e,$00

@checkY:
	ld a,b
	cp $40
	jr c,@checkX
	ld e,$03
	cp $70
	jr c,@checkX

	ld e,$06
@checkX:
	ld a,c
	cp $50
	jr c,++
	inc e
	cp $a0
	jr c,++

	inc e
++
	ld a,e
	cp $04
	ret nz

	ld e,$00
	ld a,b
	cp $58
	jr c,+
	ld e,$06
+
	ld a,c
	cp $78
	ret c
	inc e
	inc e
	ret

; ==============================================================================
; ENEMYID_PLASMARINE
;
; Variables:
;   counter2: Number of times to do shock attack before firing projectiles
;   var30/var31: Target position?
;   var32: Color (0 for blue, 1 for red)
;   var33: ?
;   var34: Number of projectiles to fire in one attack
; ==============================================================================
enemyCode7e:
	jr z,@normalStatus

	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,_enemyBoss_dead

	; Hit by something
	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_PLASMARINE_SHOCK
	jr z,@normalStatus

	ld e,Enemy.var2a
	ld a,(de)
	res 7,a
	cp ITEMCOLLISION_L1_SWORD
	call nc,_plasmarine_state_switchHook@swapColor

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw _plasmarine_state_uninitialized
	.dw _plasmarine_state_stub
	.dw _plasmarine_state_stub
	.dw _plasmarine_state_switchHook
	.dw _plasmarine_state_stub
	.dw _plasmarine_state_stub
	.dw _plasmarine_state_stub
	.dw _plasmarine_state_stub
	.dw _plasmarine_state8
	.dw _plasmarine_state9
	.dw _plasmarine_stateA
	.dw _plasmarine_stateB
	.dw _plasmarine_stateC
	.dw _plasmarine_stateD
	.dw _plasmarine_stateE
	.dw _plasmarine_stateF


_plasmarine_state_uninitialized:
	ld a,SPEED_280
	call _ecom_setSpeedAndState8
	ld l,Enemy.angle
	ld (hl),$08

	ld l,Enemy.counter1
	ld (hl),$04

	ld l,Enemy.var30
	ld (hl),$58
	inc l
	ld (hl),$78

	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a

	ld a,ENEMYID_PLASMARINE
	ld b,$00
	call _enemyBoss_initializeRoom
	jp objectSetVisible83


_plasmarine_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justLatched
	.dw @beforeSwitch
	.dw @afterSwitch
	.dw @released

@justLatched:
	xor a
	ld e,Enemy.var33
	ld (de),a
	call enemySetAnimation
	jp _ecom_incSubstate

@afterSwitch:
	ld e,Enemy.var33
	ld a,(de)
	or a
	ret nz
	inc a
	ld (de),a
	ld a,SND_MYSTERY_SEED
	call playSound


; This is called from outside "plasmarine_state_switchHook" (ie. when sword slash occurs).
@swapColor:
	ld h,d
	ld l,Enemy.var32
	ld a,(hl)
	xor $01
	ld (hl),a
	inc a
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a


@beforeSwitch:
	ret


@released:
	ld b,$0a
	call _ecom_fallToGroundAndSetState
	ret nz
	ld l,Enemy.counter1
	ld (hl),60
	jp _plasmarine_decideNumberOfShockAttacks


_plasmarine_state_stub:
	ret


; Moving toward centre of room before starting fight
_plasmarine_state8:
	call _plasmarine_checkCloseToTargetPosition
	jr c,@reachedTarget

	call _ecom_decCounter1
	jr nz,++
	ld (hl),$04
	call objectGetRelativeAngleWithTempVars
	call objectNudgeAngleTowards
++
	call objectApplySpeed
	jr _plasmarine_animate

@reachedTarget:
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.counter1
	ld (hl),60
	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c
	jr _plasmarine_animate


; 60 frame delay before starting fight
_plasmarine_state9:
	call _ecom_decCounter1
	jr nz,_plasmarine_animate

	ld (hl),60 ; [counter1]
	ld l,e
	inc (hl) ; [state] = $0a

	ld l,Enemy.collisionType
	set 7,(hl)

	call _plasmarine_decideNumberOfShockAttacks
	call _enemyBoss_beginBoss
	xor a
	jp enemySetAnimation


; Standing in place before charging
_plasmarine_stateA:
	call _ecom_decCounter1
	jr nz,_plasmarine_animate

	inc (hl) ; [counter1] = 1

	ld l,Enemy.animParameter
	bit 0,(hl)
	jr z,_plasmarine_animate

	; Initialize stuff for state $0b (charge at Link)
	ld l,Enemy.counter1
	ld (hl),$0c
	ld l,e
	inc (hl) ; [state] = $0b
	ld l,Enemy.speed
	ld (hl),SPEED_300

	ld l,Enemy.var30
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a

_plasmarine_animate:
	jp enemyAnimate


; Charging toward Link
_plasmarine_stateB:
	call _ecom_decCounter1
	jr nz,++
	ld l,e
	inc (hl) ; [state] = $0c
++
	ld l,Enemy.speed
	ld a,(hl)
	sub SPEED_20
	ld (hl),a
	; Fall through

_plasmarine_stateC:
	call _plasmarine_checkCloseToTargetPosition
	jp nc,_ecom_moveTowardPosition

	; Reached target position.
	ld l,Enemy.counter2
	dec (hl)
	ld l,e
	jr z,@fireProjectiles

	; Do shock attack (state $0d)
	ld (hl),$0d ; [state]
	ld l,Enemy.counter1
	ld (hl),65

	ld l,Enemy.damage
	ld (hl),-8

	ld l,Enemy.var32
	ld a,(hl)
	add $04
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PLASMARINE_SHOCK
	ld a,$02
	jp enemySetAnimation

@fireProjectiles:
	ld (hl),$0e ; [state]
	ld l,Enemy.health
	ld a,(hl)
	dec a
	ld hl,@numProjectilesToFire
	rst_addAToHl
	ld e,Enemy.var34
	ld a,(hl)
	ld (de),a

	ld a,$01
	jp enemySetAnimation

; Takes health value as index, returns number of projectiles to fire in one attack
@numProjectilesToFire:
	.db $03 $03 $02 $02 $02 $01 $01


; Shock attack
_plasmarine_stateD:
	call _ecom_decCounter1
	jr z,@doneAttack

	ld a,(hl)
	and $0f
	ld a,SND_SHOCK
	call z,playSound

	; Update oamFlags based on animParameter
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ld b,$04
	jr z,+
	ld b,$01
+
	ld e,Enemy.var32
	ld a,(de)
	add b
	ld h,d
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	jr _plasmarine_animate

@doneAttack:
	ld (hl),60 ; [counter1]
	ld l,e
	ld (hl),$0a ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.damage
	ld (hl),-4

	ld l,Enemy.var32
	ld a,(hl)
	inc a
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PLASMARINE
	xor a
	jp enemySetAnimation


; Firing projectiles
_plasmarine_stateE:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	dec a
	jr z,@fire

	inc a
	ret z

	call _ecom_incState
	ld l,Enemy.counter1
	ld (hl),60
	xor a
	jp enemySetAnimation

@fire:
	ld (de),a ; [animParameter] = 0

	call getFreePartSlot
	ret nz
	ld (hl),PARTID_PLASMARINE_PROJECTILE
	inc l
	ld e,Enemy.oamFlags
	ld a,(de)
	dec a
	ld (hl),a ; [projectile.var03]

	ld l,Part.relatedObj1+1
	ld (hl),d
	dec l
	ld (hl),Enemy.start

	ld bc,$ec00
	call objectCopyPositionWithOffset
	ld a,SND_VERAN_FAIRY_ATTACK
	jp playSound


; Decides whether to return to state $0e (fire another projectile) or charge at Link again
_plasmarine_stateF:
	call _ecom_decCounter1
	jp nz,enemyAnimate

	ld l,Enemy.var34
	dec (hl)
	ld l,e
	jr z,@chargeAtLink

	dec (hl) ; [state] = $0e
	ld a,$01
	jp enemySetAnimation

@chargeAtLink:
	ld (hl),$0a
	ld l,Enemy.counter1
	ld (hl),30

;;
_plasmarine_decideNumberOfShockAttacks:
	call getRandomNumber_noPreserveVars
	and $01
	inc a
	ld e,Enemy.counter2
	ld (de),a
	ret

;;
; @param[out]	cflag	c if close enough to target position
_plasmarine_checkCloseToTargetPosition:
	ld h,d
	ld l,Enemy.var30
	call _ecom_readPositionVars
	sub c
	add $04
	cp $09
	ret nc
	ldh a,(<hFF8F)
	sub b
	add $04
	cp $09
	ret

; TODO: what is this? Unused data?
.db $ec $ec $ec $14 $14 $14 $14 $ec
.db $00 $e8 $e8 $00 $00 $18 $18 $00


; ==============================================================================
; ENEMYID_KING_MOBLIN
;
; Variables:
;   counter2: ?
;   relatedObj2: Instance of PARTID_KING_MOBLIN_BOMB
;   var30/var31: Object indices for two ENEMYID_KING_MOBLIN_MINION instances
;   var32: Target x-position to walk toward to grab bomb
;   var33: Signal from ENEMYID_KING_MOBLIN_MINION to trigger warp to the outside
; ==============================================================================
enemyCode7f:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead

	; Collision occurred

	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_BOMB
	jr nz,@normalStatus

	ld a,SND_BOSS_DAMAGE
	call playSound

	; Determine speed based on health
	ld e,Enemy.health
	ld a,(de)
	dec a
	ld hl,@speeds
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a

	jr @normalStatus

; Indexed by current health value
@speeds:
	.db SPEED_1c0, SPEED_1c0
	.db SPEED_140, SPEED_140
	.db SPEED_0c0, SPEED_0c0

@dead:
	call checkLinkCollisionsEnabled
	ret nc

	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld h,d
	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.health
	ld (hl),a ; [health] = $01

	ld l,Enemy.state
	ld (hl),$12

	ld l,Enemy.angle
	ld (hl),$00
	ld l,Enemy.speed
	ld (hl),SPEED_300

	ld l,Enemy.invincibilityCounter
	ld (hl),$00

	ld a,$06
	call enemySetAnimation

@normalStatus:
	ld e,Enemy.invincibilityCounter
	ld a,(de)
	or a
	ret nz

	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw _kingMoblin_state_uninitialized
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state8
	.dw _kingMoblin_state9
	.dw _kingMoblin_stateA
	.dw _kingMoblin_stateB
	.dw _kingMoblin_stateC
	.dw _kingMoblin_stateD
	.dw _kingMoblin_stateE
	.dw _kingMoblin_stateF
	.dw _kingMoblin_state10
	.dw _kingMoblin_state11
	.dw _kingMoblin_state12
	.dw _kingMoblin_state13
	.dw _kingMoblin_state14
	.dw _kingMoblin_state15


_kingMoblin_state_uninitialized:
	ld a,ENEMYID_KING_MOBLIN
	ld (wEnemyIDToLoadExtraGfx),a

	ld a,PALH_8c
	call loadPaletteHeader

	ld a,SNDCTRL_STOPMUSIC
	call playSound

	xor a
	ld (wDisableLinkCollisionsAndMenu),a
	dec a
	ld (wActiveMusic),a

	ld b,$02
	call checkBEnemySlotsAvailable
	ret nz

	call @spawnMinion
	ld e,Enemy.var30
	ld (de),a

	call @spawnMinion
	ld l,Enemy.subid
	inc (hl)
	ld e,Enemy.var31
	ld (de),a
	ld a,SPEED_c0
	call _ecom_setSpeedAndState8
	call objectSetVisible83
	ld a,$02
	jp enemySetAnimation

;;
; @param[out]	a,h	Object index
@spawnMinion:
	call getFreeEnemySlot_uncounted
	ld (hl),ENEMYID_KING_MOBLIN_MINION
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d
	ld a,h
	ret


_kingMoblin_state_stub:
	ret


; Waiting for Link to move in to start the fight
_kingMoblin_state8:
	ld hl,w1Link.xh
	ld a,(hl)
	sub $40
	cp $20
	jr nc,_kingMoblin_animate

	ld l,<w1Link.zh
	ld a,(hl)
	or a
	jr nz,_kingMoblin_animate

	ld l,<w1Link.direction
	ld (hl),DIR_UP

	call checkLinkVulnerable
	ret nc

	call clearAllParentItems
	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	; Make stairs disappear
	ld c,$61
	ld a,TILEINDEX_STANDARD_FLOOR
	call setTile

	; Poof at stairs
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERACID_PUFF
	ld l,Interaction.yh
	ld (hl),$68
	ld l,Interaction.xh
	ld (hl),$18
++
	call _ecom_incState
	ld l,Enemy.counter1
	ld (hl),$18

_kingMoblin_animate:
	jp enemyAnimate


; Delay before showing text
_kingMoblin_state9:
	call _ecom_decCounter1
	jr nz,_kingMoblin_animate

	ld l,e
	inc (hl) ; [state] = $0a

	call checkIsLinkedGame
	ld bc,TX_2f19
	jr z,+
	ld bc,TX_2f1a
+
	jp showText


; Starting fight
_kingMoblin_stateA:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0b

	ld l,Enemy.counter2
	ld (hl),30

	ld l,Enemy.var30
	ld b,(hl)
	ld c,e
	ld a,$02
	ld (bc),a ; [minion1.state] = $02
	inc l
	ld b,(hl)
	ld (bc),a ; [minion2.state] = $02

	call _enemyBoss_beginBoss
	xor a
	jp enemySetAnimation


; Facing backwards while picking up a bomb
_kingMoblin_stateB:
	call _ecom_decCounter2
	jr nz,_kingMoblin_animate

	ld b,PARTID_KING_MOBLIN_BOMB
	call _ecom_spawnProjectile
	ret nz

	call _ecom_incState

_kingMoblin_initBombPickupAnimation:
	ld e,Enemy.health
	ld a,(de)
	dec a
	ld hl,@counter2Vals
	rst_addAToHl
	ld e,Enemy.counter2
	ld a,(hl)
	ld (de),a

	ld a,$04
	jp enemySetAnimation

@counter2Vals:
	.db 10 20 28 45 45 45


; Will raise bomb over head in [counter2] frames?
_kingMoblin_stateC:
	call _kingMoblin_checkMoveToCentre
	ret nz

	call _ecom_decCounter2
	ret nz

	ld l,Enemy.state
	inc (hl) ; [state] = $0d

	; Set counter2 based on health
	ld l,Enemy.health
	ld a,(hl)
	dec a
	ld hl,@counter2Vals
	rst_addAToHl
	ld e,Enemy.counter2
	ld a,(hl)
	ld (de),a

	; Update bomb's position if it hasn't exploded
	ld a,Object.state
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $05
	jr z,+
	ld bc,$f0f2
	call objectCopyPositionWithOffset
+
	ld a,$02
	jp enemySetAnimation

; Indexed by [health]-1
@counter2Vals:
	.db 5, 10, 12, 15, 15, 15


; Delay before throwing bomb
_kingMoblin_stateD:
	call _kingMoblin_checkMoveToCentre
	ret nz

	call _ecom_decCounter2
	ret nz

	ld (hl),30
	ld l,Enemy.state
	inc (hl) ; [state] = $0e

	; Decide angle of bomb's movement based on link's position
	call objectGetAngleTowardEnemyTarget
	ld b,a
	sub $0c
	cp $07
	jr c,++

	ld b,$0c
	rlca
	jr c,++

	ld b,$13
++
	ld a,Object.state
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $05
	jr z,++

	; Throw bomb
	ld (hl),$03 ; [bomb.state] = $03
	ld l,Part.angle
	ld (hl),b
	ld l,Part.speedZ
	ld (hl),<(-$180)
	inc l
	ld (hl),>(-$180)
++
	ld a,$05
	jp enemySetAnimation


; Delay after throwing bomb
_kingMoblin_stateE:
	call _ecom_decCounter2
	ret nz
	ld l,e
	inc (hl) ; [state] = $0f
	ld a,$02
	jp enemySetAnimation


; Waiting for something to do
_kingMoblin_stateF:
	ld a,Object.id
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp PARTID_KING_MOBLIN_BOMB
	jp nz,_kingMoblin_moveToCentre

	; Do several checks to see if king moblin can pick up the bomb.

	; Is the state ok?
	ld l,Part.state
	ld a,(hl)
	cp $04
	jr nz,_kingMoblin_animate2

	; Is it above the ledge?
	ld l,Part.yh
	ldi a,(hl)
	cp $36
	jr nc,_kingMoblin_animate2

	; Is it reachable on the x axis?
	inc l
	ld a,(hl) ; [bomb.xh]
	sub $30
	cp $41
	jr nc,_kingMoblin_animate2

	; Bomb can be grabbed.

	; Is the bomb close enough to grab without walking?
	ld e,Enemy.xh
	ld a,(de)
	ld b,a
	sub (hl)
	add $08
	cp $11
	jr c,_kingMoblin_grabBomb

	; No; must move toward it
	ld a,(hl)
	cp b
	ld h,d
	ld l,Enemy.var32
	ld (hl),a
	ld b,$11 ; state $11
	jp _kingMoblin_setAngleStateAndAnimation

_kingMoblin_grabBomb:
	ld a,Object.state
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $05
	jr z,++
	ld (hl),$01
	ld bc,$0800
	call objectCopyPositionWithOffset
++
	ld h,d
	ld l,Enemy.state
	ld (hl),$0c
	jp _kingMoblin_initBombPickupAnimation


; Moving to centre of screen
_kingMoblin_state10:
	ld e,Enemy.xh
	ld a,(de)
	sub $4e
	cp $05
	jr nc,++

	ld h,d
	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.counter2
	ld (hl),30
	xor a
	jp enemySetAnimation
++
	call objectApplySpeed

_kingMoblin_animate2:
	jp enemyAnimate


; Moving toward bomb
_kingMoblin_state11:
	call _kingMoblin_checkMoveToCentre
	ret nz

	call objectApplySpeed
	ld h,d
	ld l,Enemy.xh
	ld e,Enemy.var32
	ld a,(de)
	sub (hl)
	add $08
	cp $11
	jr c,_kingMoblin_grabBomb
	jp enemyAnimate


; Just died
_kingMoblin_state12:
	call objectApplySpeed
	ld e,Enemy.yh
	ld a,(de)
	cp $0c
	ret nc

	call _ecom_incState

	ld l,Enemy.angle
	ld (hl),$10
	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.speedZ
	ld a,<(-$160)
	ldi (hl),a
	ld (hl),>(-$160)

	ld a,60
	jp setScreenShakeCounter


; Falling to ground
_kingMoblin_state13:
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jp nc,objectApplySpeed

	call _ecom_incState
	ld l,Enemy.counter1
	ld (hl),150
	ld l,Enemy.yh
	ld (hl),$20
	ret


; Wait for signal from ENEMYID_KING_MOBLIN_MINION to go to state $15?
_kingMoblin_state14:
	ld e,Enemy.var33
	ld a,(de)
	or a
	jr nz,@gotoState15

	ld a,(wFrameCounter)
	rrca
	ret c

	call _ecom_decCounter1
	ret nz

	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.counter2
	ld (hl),30
	xor a
	jp enemySetAnimation

@gotoState15:
	call _ecom_incState
	ld l,Enemy.counter2
	ld (hl),98
	ret


; All bombs at top of screen explode, then initiates warp outside
_kingMoblin_state15:
	call _ecom_decCounter2
	jr z,@warpOutside

	; Explosion every 32 frames
	ld a,(hl)
	dec a
	and $1f
	ret nz

	ld a,(hl)
	and $60
	rrca
	swap a
	ld hl,@explosionPositions
	rst_addAToHl

	ld c,(hl)
	ld b,$08
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_EXPLOSION
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c

	call getTileAtPosition
	ld c,l
	ld a,$a1
	jp setTile

@warpOutside:
	ld hl,wPresentRoomFlags+$09
	set 0,(hl)

	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call setGlobalFlag
	ld a,GLOBALFLAG_16
	call setGlobalFlag

	ld hl,@warpDest
	jp setWarpDestVariables

@explosionPositions:
	.db $68 $38 $58 $48

@warpDest:
	m_HardcodedWarpA ROOM_AGES_009, $00, $45, $03


;;
; Updates state and angle values to move king moblin to centre of screen, if there is no
; bomb on screen. Sets state to $10 while moving, $0b when reached centre.
;
; @param[out]	zflag	nz if state changed
_kingMoblin_checkMoveToCentre:
	ld a,Object.id
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp PARTID_KING_MOBLIN_BOMB
	ret z

;;
_kingMoblin_moveToCentre:
	ld h,d
	ld l,Enemy.xh
	ld a,(hl)
	sub $4e
	cp $05
	jr nc,@moveTowardCentre

	; Reached centre
	ld l,Enemy.counter2
	ld (hl),30
	ld b,$0b
	xor a
	jr _kingMoblin_setStateAndAnimation

@moveTowardCentre:
	cp $b0
	ld b,$10

_kingMoblin_setAngleStateAndAnimation:
	ld a,ANGLE_RIGHT
	jr nc,+
	ld a,ANGLE_LEFT
+
	ld e,Enemy.angle
	ld (de),a
	swap a
	rlca

_kingMoblin_setStateAndAnimation:
	ld l,Enemy.state
	ld (hl),b
	call enemySetAnimation
	or d
	ret
