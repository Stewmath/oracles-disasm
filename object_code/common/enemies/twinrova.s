; ==================================================================================================
; ENEMY_TWINROVA
;
; Variables:
;   var03: If bit 0 is unset, this acts as the "spawner" for the other twinrova object.
;          Bit 7: ?
;   relatedObj1: Reference to other twinrova object
;   relatedObj2: Reference to INTERAC_PUFF
;   var30: Anglular velocity (amount to add to angle)
;   var31: Counter used for z-position bobbing
;   var32: Bit 0: Nonzero while projectile is being fired?
;          Bit 1: Signal in merging cutscene
;          Bit 2: Signal to fire a projectile
;          Bit 3: Enable/disable z-position bobbing
;          Bit 4: Signal in merging cutscene
;          Bit 5: ?
;          Bit 6: Signal to do "death cutscene" if health is 0. Set by
;                 PART_RED_TWINROVA_PROJECTILE or PART_BLUE_TWINROVA_PROJECTILE.
;          Bit 7: If set, updates draw layer relative to Link
;   var33: Movement pattern (0-3)
;   var34: Position index (within the movement pattern)
;   var35/var36: Target position?
;   var37: Counter to update facing direction when it reaches 0?
;   var38: Index in "attack pattern"? (0-7)
;   var39: Some kind of counter?
; ==================================================================================================
enemyCode03:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus

	; Dead
	ld h,d
	ld l,Enemy.var32
	bit 6,(hl)
	jr z,@normalStatus

	ld l,Enemy.health
	ld (hl),$7f
	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.state
	ld (hl),$0d

	; Set variables in relatedObj1 (other twinrova)
	ld a,Object.health
	call objectGetRelatedObject1Var
	ld (hl),$7f
	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.state
	ld (hl),$0f

	ld a,SNDCTRL_STOPMUSIC
	call playSound

@normalStatus:
	call twinrova_updateZPosition
	call @runState
	ld e,Enemy.var32
	ld a,(de)
	bit 7,a
	jp nz,objectSetPriorityRelativeToLink_withTerrainEffects
	ret

@runState:
	call twinrova_checkFireProjectile
	call ecom_getSubidAndCpStateTo08
	jr nc,@state8OrHigher
	rst_jumpTable
	.dw twinrova_state_uninitialized
	.dw twinrova_state_spawner
	.dw twinrova_state_stub
	.dw twinrova_state_stub
	.dw twinrova_state_stub
	.dw twinrova_state_stub
	.dw twinrova_state_stub
	.dw twinrova_state_stub

@state8OrHigher:
	ld a,b
	rst_jumpTable
	.dw twinrova_subid0
	.dw twinrova_subid1


twinrova_state_uninitialized:
	ld a,ENEMY_TWINROVA
	ld (wEnemyIDToLoadExtraGfx),a
	ld a,$01
	ld (wLoadedTreeGfxIndex),a

	ld h,d
	ld l,Enemy.var03
	bit 0,(hl)
	ld a,SPEED_100
	jp nz,twinrova_initialize

	ld l,e
	inc (hl) ; [state] = 1

	xor a
	ld (w1Link.direction),a
	inc a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a


twinrova_state_spawner:
	ld b,ENEMY_TWINROVA
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz

	; [child.var03] = [this.var03] + 1
	inc l
	ld e,l
	ld a,(de)
	inc a
	ld (hl),a

	; [this.relatedObj1] = child
	; [child.relatedObj1] = this
	ld l,Enemy.relatedObj1
	ld e,l
	ld a,Enemy.start
	ld (de),a
	ldi (hl),a
	inc e
	ld a,h
	ld (de),a
	ld (hl),d

	ld a,h
	cp d
	ld a,SPEED_100
	jp nc,twinrova_initialize

	; Swap the twinrova objects; subid 0 must come before subid 1?
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	ld l,Enemy.subid
	dec (hl) ; [child.subid] = 0
	ld h,d
	inc (hl) ; [this.subid] = 1
	inc l
	inc (hl) ; [this.var03] = 1
	ld l,Enemy.state
	dec (hl) ; [this.state] = 0
	ret


twinrova_state_stub:
	ret


twinrova_subid0:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw twinrova_state8
	.dw twinrova_state9
	.dw twinrova_subid0_stateA
	.dw twinrova_subid0_stateB
	.dw twinrova_subid0_stateC
	.dw twinrova_stateD
	.dw twinrova_stateE
	.dw twinrova_stateF
	.dw twinrova_state10


; Cutscene before fight
twinrova_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.var32
	set 3,(hl)
	set 7,(hl)

	ld l,Enemy.counter1
	ld (hl),106

	ld l,Enemy.yh
	ld (hl),$08

	; Set initial x-position, oam flags, angle, and var30 based on subid
	ld l,Enemy.subid
	ld a,(hl)
	add a
	ld hl,@data
	rst_addDoubleIndex

	ld e,Enemy.xh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.oamFlagsBackup
	ldi a,(hl)
	ld (de),a
	inc e
	ld (de),a

	ld e,Enemy.angle
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a

	; Subid 0 only: show text
	ld e,Enemy.subid
	ld a,(de)
	or a
	ld bc,TX_2f04
	call z,showText

	call getRandomNumber_noPreserveVars
	ld e,Enemy.var31
	ld (de),a
	jp twinrova_updateAnimationFromAngle

; Data per subid: x-position, oam flags, angle, var30
@data:
	.db $c0 $02 $11 $01 ; Subid 0
	.db $30 $01 $0f $ff ; Subid 1


; Moving down the screen in the pre-fight cutscene
twinrova_state9:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	call ecom_decCounter1
	jr nz,@applySpeed

	ld (hl),$08 ; [counter1]
	inc l
	ld (hl),$12 ; [counter2]
	ld l,e
	inc (hl) ; [substate] = 1
	jr @animate

@substate1:
	call ecom_decCounter1
	jr nz,@applySpeed

	ld (hl),$08 ; [counter1]
	inc l
	dec (hl) ; [counter2]
	jr nz,@updateAngle

	ld l,e
	inc (hl) ; [substate] = 3
	inc l
	ld (hl),30 ; [counter1]

	call ecom_updateAngleTowardTarget
	call twinrova_calculateAnimationFromAngle
	ld (hl),a
	jp enemySetAnimation

@updateAngle:
	ld e,Enemy.angle
	ld l,Enemy.var30
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a
	call twinrova_updateAnimationFromAngle

@applySpeed:
	call objectApplySpeed
@animate:
	jp enemyAnimate

@substate2:
	call ecom_decCounter1
	jr nz,@animate

	ld l,e
	inc (hl) ; [substate] = 3

	ld e,Enemy.subid
	ld a,(de)
	or a
	ret nz
	ld bc,TX_2f05
	jp showText

@substate3:
	ldbc INTERAC_PUFF,$02
	call objectCreateInteraction
	ret nz
	ld a,h
	ld h,d
	ld l,Enemy.relatedObj2+1
	ldd (hl),a
	ld (hl),Interaction.start

	ld l,Enemy.substate
	inc (hl) ; [substate] = 4

	ld l,Enemy.var32
	res 7,(hl)
	jp objectSetInvisible

@substate4:
	; Wait for puff to finish
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z

	ld h,d
	ld l,Enemy.var32
	set 7,(hl)
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,CUTSCENE_FLAMES_FLICKERING
	ld (wCutsceneTrigger),a

	call ecom_updateAngleTowardTarget
	call twinrova_calculateAnimationFromAngle
	add $04
	ld (hl),a
	jp enemySetAnimation


; Fight just starting
twinrova_subid0_stateA:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0b

	ld a,MUS_TWINROVA
	ld (wActiveMusic),a
	call playSound
	jp twinrova_subid0_updateTargetPosition


; Moving normally
twinrova_subid0_stateB:
	ld a,(wFrameCounter)
	and $7f
	ld a,SND_FAIRYCUTSCENE
	call z,playSound

	call twinrova_moveTowardTargetPosition
	ret nc
	call twinrova_subid0_updateTargetPosition
	jr nz,@waypointChanged

	; Done this movement pattern
	call ecom_incState ; [state] = $0c
	ld l,Enemy.counter1
	ld (hl),30
	ret

@waypointChanged:
	call twinrova_checkAttackInProgress
	ret nz

	ld e,Enemy.var38
	ld a,(de)
	inc a
	and $07
	ld (de),a
	ld hl,@attackPattern
	call checkFlag
	jp nz,twinrova_chooseObjectToAttack
	ret

@attackPattern:
	.db %01110101


; Delay before choosing new movement pattern and returning to state $0b
twinrova_subid0_stateC:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	dec (hl) ; [state] = $0b

	; Choose random movement pattern
	call getRandomNumber_noPreserveVars
	and $03
	ld e,Enemy.var33
	ld (de),a
	inc e
	xor a
	ld (de),a ; [var34]

	jp twinrova_subid0_updateTargetPosition


; Health just reached 0
twinrova_stateD:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0e

	ld l,Enemy.zh
	ld (hl),$00
	ld l,Enemy.var32
	res 3,(hl)

	ld l,Enemy.angle
	bit 4,(hl)
	ld a,$0a
	jr z,+
	inc a
+
	jp enemySetAnimation


; Delay before showing text
twinrova_stateE:
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr nz,twinrova_animate

	ld e,Enemy.direction
	ld a,(de)
	add $04
	call enemySetAnimation

	call ecom_incState
	ld l,Enemy.zh
	dec (hl)
	ld bc,TX_2f09
	call showText
twinrova_animate:
	jp enemyAnimate


twinrova_stateF:
	call twinrova_rise2PixelsAboveGround
	jr nz,twinrova_animate

	; Wait for signal that twin has risen
	ld a,Object.var32
	call objectGetRelatedObject1Var
	bit 4,(hl)
	jr nz,@nextState

	call ecom_updateAngleTowardTarget
	call twinrova_updateMovingAnimation
	jr twinrova_animate

@nextState:
	call ecom_incState
	inc l
	ld (hl),$00 ; [substate] = 0

	ld l,Enemy.var32
	res 3,(hl)
	jr twinrova_animate


; Merging into one
twinrova_state10:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7

; Showing more text
@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate] = 1

	ld l,Enemy.var32
	res 1,(hl)
	res 0,(hl)

	ld l,Enemy.direction
	ld (hl),$00

	ld bc,-$3e0
	call objectSetSpeedZ

	ld e,Enemy.subid
	ld a,(de)
	or a
	ret nz
	ld bc,TX_2f0a
	jp showText

; Rising up above screen
@substate1:
	ld c,$08
	call objectUpdateSpeedZ_paramC
	ldh a,(<hCameraY)
	ld b,a
	ld l,Enemy.yh
	ld a,(hl)
	sub b
	jr nc,+
	ld a,(hl)
+
	ld b,a
	ld l,Enemy.zh
	ld a,(hl)
	cp $80
	jr c,++

	add b
	cp $f0
	jr c,@animate
++
	ld l,Enemy.substate
	inc (hl) ; [substate] = 2

	ld l,Enemy.var32
	set 1,(hl)
	ld l,Enemy.var32
	res 7,(hl)

	ld l,Enemy.counter1
	ld (hl),60
	jp objectSetInvisible

; Waiting for both twins to finish substate 1 (rise above screen)
@substate2:
	ld e,Enemy.subid
	ld a,(de)
	or a
	ret nz

	; Subid 0 only: wait for twin to finish substate 1
	ld a,Object.var32
	call objectGetRelatedObject1Var
	bit 1,(hl)
	ret z

	; Increment substate for both (now synchronized)
	ld l,Enemy.substate
	inc (hl)
	ld h,d
	inc (hl)
	ret

; Delay before coming back down
@substate3:
	call ecom_decCounter1
	ret nz

	ld (hl),48 ; [counter1]
	ld l,e
	inc (hl) ; [substate] = 4

	ld l,Enemy.zh
	ld (hl),$a0

	ld l,Enemy.angle
	ld e,Enemy.subid
	ld a,(de)
	or a
	ld (hl),$08
	jr z,+
	ld (hl),$18
+
	ld l,Enemy.var32
	set 7,(hl)
	call objectSetVisiblec2
	ld a,SND_WIND
	call playSound

; Circling down to ground
@substate4:
	ld bc,$5878
	ld e,Enemy.counter1
	ld a,(de)
	ld e,Enemy.angle
	call objectSetPositionInCircleArc

	ld e,Enemy.angle
	ld a,(de)
	add $08
	and $1f
	call twinrova_updateMovingAnimationGivenAngle

	ld h,d
	ld l,Enemy.zh
	inc (hl)
	ld a,(hl)
	rrca
	jr c,@animate

	; Every other frame, increment angle
	ld l,Enemy.angle
	ld a,(hl)
	inc a
	and $1f
	ld (hl),a
	ld l,Enemy.counter1
	dec (hl)
	jr nz,@animate

	dec l
	inc (hl) ; [substate] = 5
@animate:
	jp enemyAnimate

; Reached ground
@substate5:
	; Delete subid 1 (subid 0 will remain)
	ld e,Enemy.subid
	ld a,(de)
	or a
	jp nz,enemyDelete

	ld a,(wLinkDeathTrigger)
	or a
	ret nz

	inc a
	ld (wDisabledObjects),a
	ld (wDisableLinkCollisionsAndMenu),a

	ld h,d
	ld l,Enemy.substate
	inc (hl) ; [substate] = 6

	ld l,Enemy.oamFlagsBackup
	xor a
	ldi (hl),a
	ld (hl),a

	ld a,$0c
	call enemySetAnimation
	ld a,SND_TRANSFORM
	call playSound

	ld a,$02
	jp fadeinFromWhiteWithDelay

; Waiting for screen to fade back in from white
@substate6:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld h,d
	ld l,Enemy.substate
	inc (hl) ; [substate] = 7

	ld l,Enemy.var32
	res 0,(hl)

	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	ret

; Initiating next phase of fight
@substate7:
	; Find a free enemy slot. (Why does it do this manually instead of using
	; "getFreeEnemySlot"?)
	ld h,d
	ld l,Enemy.enabled
	inc h
@nextEnemy:
	ld a,(hl)
	or a
	jr z,@foundFreeSlot
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy
	ret

@foundFreeSlot:
	ld e,l
	ld a,(de)
	ldi (hl),a ; [child.enabled] = [this.enabled]
	ld (hl),ENEMY_MERGED_TWINROVA ; [child.id]
	call objectCopyPosition

	ld a,$01
	ld (wLoadedTreeGfxIndex),a

	jp enemyDelete


; Subid 1 is nearly identical to subid 0, it just doesn't do a few things like playing
; sound effects.
twinrova_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw twinrova_state8
	.dw twinrova_state9
	.dw twinrova_subid1_stateA
	.dw twinrova_subid1_stateB
	.dw twinrova_subid1_stateC
	.dw twinrova_stateD
	.dw twinrova_stateE
	.dw twinrova_stateF
	.dw twinrova_state10


; Fight just starting
twinrova_subid1_stateA:
	ld a,$0b
	ld (de),a ; [state] = $0b
	jp twinrova_subid1_updateTargetPosition


; Moving normally
twinrova_subid1_stateB:
	call twinrova_moveTowardTargetPosition
	ret nc
	call twinrova_subid1_updateTargetPosition
	ret nz

	; Done this movement pattern
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),30
	ret


; Delay before choosing new movement pattern and returning to state $0b
twinrova_subid1_stateC:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	dec (hl) ; [state] = $0b

	; Choose random movement pattern
	call getRandomNumber_noPreserveVars
	and $03
	ld e,Enemy.var33
	ld (de),a
	inc e
	xor a
	ld (de),a ; [var34]

	jp twinrova_subid1_updateTargetPosition


;;
; @param	a	Speed
twinrova_initialize:
	ld h,d
	ld l,Enemy.var03
	bit 7,(hl)
	jp z,ecom_setSpeedAndState8

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld l,Enemy.yh
	ld (hl),$56
	ld l,Enemy.xh
	ld (hl),$60

	ld e,Enemy.subid
	ld a,(de)
	or a
	ld a,$02
	jr z,++
	ld (hl),$90 ; [xh]
	dec a
++
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.state
	ld (hl),$0a

	ld l,Enemy.direction
	ld (hl),$ff
	ld l,Enemy.speed
	ld (hl),SPEED_140

	ld l,Enemy.var32
	set 3,(hl)
	set 7,(hl)

	call ecom_updateAngleTowardTarget
	call twinrova_calculateAnimationFromAngle
	add $04
	ld (hl),a
	jp enemySetAnimation

;;
twinrova_updateZPosition:
	ld h,d
	ld l,Enemy.var37
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
+
	ld l,Enemy.var32
	bit 3,(hl)
	ret z

	ld l,Enemy.var31
	dec (hl)
	ld a,(hl)
	and $07
	ret nz

	ld a,(hl)
	and $18
	swap a
	rlca
	ld hl,@levitationZPositions
	rst_addAToHl
	ld e,Enemy.zh
	ld a,(hl)
	ld (de),a
	ret

@levitationZPositions:
	.db -3, -4, -5, -4

;;
twinrova_checkFireProjectile:
	ld h,d
	ld l,Enemy.var32
	bit 0,(hl)
	ret z

	bit 2,(hl)
	jr nz,@fireProjectile

	ld l,Enemy.collisionType
	bit 7,(hl)
	ret z

	ld l,Enemy.var39
	ld a,(hl)
	or a
	ld e,Enemy.animParameter
	jr z,@var39Zero

	dec (hl) ; [var39]
	ld a,(de) ; [animParameter]
	inc a
	ret nz

@var39Zero:
	dec a
	ld (de),a ; [animParameter] = $ff

	ld e,Enemy.angle
	ld a,(de)
	call twinrova_calculateAnimationFromAngle
	ld (hl),a
	add $04
	jp enemySetAnimation

@fireProjectile:
	res 2,(hl) ; [var32]

	ld l,Enemy.direction
	ld (hl),$ff
	ld l,Enemy.var39
	ld (hl),240

	call @spawnProjectile
	call objectGetAngleTowardEnemyTarget
	cp $10
	ld a,$00
	jr c,+
	inc a
+
	add $08
	jp enemySetAnimation

;;
@spawnProjectile:
	ld b,PART_RED_TWINROVA_PROJECTILE
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr z,+
	ld b,PART_BLUE_TWINROVA_PROJECTILE
+
	jp ecom_spawnProjectile

;;
; Unused?
;
; @param	h	Object to set target position to
twinrova_setTargetPositionToObject:
	ld l,Enemy.yh
	ld e,l
	ld b,(hl)
	ld a,(de)
	ldh (<hFF8F),a
	ld l,Enemy.xh
	ld e,l
	ld c,(hl)
	ld a,(de)
	ldh (<hFF8E),a
	call ecom_moveTowardPosition
	jr twinrova_updateMovingAnimation


;;
twinrova_updateAnimationFromAngle:
	ld e,Enemy.angle
	ld a,(de)
	call twinrova_calculateAnimationFromAngle
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
twinrova_updateMovingAnimation:
	ld e,Enemy.angle
	ld a,(de)

;;
; @param	a	angle
twinrova_updateMovingAnimationGivenAngle:
	call twinrova_calculateAnimationFromAngle
	ret z

	bit 7,(hl)
	ret nz

	ld b,a
	ld e,Enemy.var37
	ld a,(de)
	or a
	ret nz

	ld a,30
	ld (de),a ; [var37]

	ld a,b
	ld (hl),a ; [direction]
	add $04
	jp enemySetAnimation


;;
; @param	a	Angle value
; @param[out]	hl	Enemy.direction
; @param[out]	zflag	z if calculated animation is the same as current animation
twinrova_calculateAnimationFromAngle:
	ld c,a
	add $04
	and $18
	swap a
	rlca
	ld b,a
	ld h,d
	ld l,Enemy.direction
	ld a,c
	and $07
	cp $04
	ld a,b
	ret z
	cp (hl)
	ret

;;
; @param[out]	zflag	z if reached the end of the movement pattern
twinrova_subid0_updateTargetPosition:
	ld hl,twinrova_subid0_targetPositions
	jr ++

;;
twinrova_subid1_updateTargetPosition:
	ld hl,twinrova_subid1_targetPositions
++
	ld e,Enemy.var37
	xor a
	ld (de),a

	ld e,Enemy.var34
	ld a,(de)
	ld b,a
	inc a
	ld (de),a

	dec e
	ld a,(de) ; [var33]
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld a,b
	rst_addDoubleIndex
	ld e,Enemy.var35
	ldi a,(hl)
	or a
	ret z

	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

;;
; @param[out]	cflag	c if reached target position
twinrova_moveTowardTargetPosition:
	ld h,d
	ld l,Enemy.var35
	call ecom_readPositionVars
	sub c
	inc a
	cp $03
	jr nc,@moveToward

	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	ret c

@moveToward:
	call ecom_moveTowardPosition
	call twinrova_updateMovingAnimation
	call enemyAnimate
	or d
	ret

;;
; Randomly chooses either this object or its twin to begin an attack
twinrova_chooseObjectToAttack:
	call getRandomNumber_noPreserveVars
	rrca
	ld h,d
	ld l,Enemy.var32
	jr nc,++

	ld a,Object.var32
	call objectGetRelatedObject1Var
++
	ld a,(hl)
	or $05
	ld (hl),a
	ret


;;
; Checks if an attack is in progress, unsets bit 0 of var32 when attack is done?
;
; @param[out]	zflag	nz if either twinrova is currently doing an attack
twinrova_checkAttackInProgress:
	ld h,d
	ld l,Enemy.var32
	bit 0,(hl)
	jr nz,++

	ld a,Object.var32
	call objectGetRelatedObject1Var
	bit 0,(hl)
	ret z
++
	ld l,Enemy.direction
	bit 7,(hl)
	ret nz

	ld l,Enemy.var32
	res 0,(hl)
	or d
	ret

;;
; @param[out]	zflag	z if Twinrova's risen to the desired height (-2)
twinrova_rise2PixelsAboveGround:
	ld h,d
	ld l,Enemy.zh
	ld a,(hl)
	cp $fe
	jr c,++
	dec (hl)
	ret
++
	ld l,Enemy.var32
	ld a,(hl)
	or $18
	ld (hl),a
	xor a
	ret

;;
; Unused?
twinrova_incState2ForSelfAndTwin:
	ld a,Object.substate
	call objectGetRelatedObject1Var
	inc (hl)
	ld h,d
	inc (hl)
	ret


twinrova_subid0_targetPositions:
	.dw @pattern0
	.dw @pattern1
	.dw @pattern2
	.dw @pattern3

@pattern0:
	.db $50 $58
	.db $90 $a0
	.db $90 $b8
	.db $58 $d0
	.db $20 $b8
	.db $20 $a0
	.db $90 $40
	.db $90 $28
	.db $58 $18
	.db $20 $28
	.db $20 $40
	.db $00
@pattern1:
	.db $50 $58
	.db $70 $c0
	.db $80 $c0
	.db $90 $90
	.db $90 $60
	.db $80 $30
	.db $70 $30
	.db $40 $c0
	.db $30 $c0
	.db $20 $90
	.db $20 $60
	.db $30 $30
	.db $40 $30
	.db $00
@pattern2:
	.db $50 $58
	.db $80 $80
	.db $80 $a0
	.db $68 $c0
	.db $38 $c0
	.db $20 $a0
	.db $20 $50
	.db $30 $40
	.db $00
@pattern3:
	.db $50 $58
	.db $60 $70
	.db $80 $70
	.db $90 $40
	.db $60 $28
	.db $50 $58
	.db $50 $98
	.db $60 $c8
	.db $88 $b8
	.db $88 $a0
	.db $20 $80
	.db $20 $70
	.db $00


twinrova_subid1_targetPositions:
	.dw @pattern0
	.dw @pattern1
	.dw @pattern2
	.dw @pattern3

@pattern0:
	.db $50 $98
	.db $90 $50
	.db $90 $38
	.db $58 $20
	.db $20 $38
	.db $20 $50
	.db $90 $b8
	.db $90 $c8
	.db $58 $d8
	.db $20 $c8
	.db $20 $b8
	.db $00
@pattern1:
	.db $50 $98
	.db $70 $30
	.db $80 $30
	.db $90 $60
	.db $90 $90
	.db $80 $c0
	.db $70 $c0
	.db $40 $30
	.db $30 $30
	.db $20 $60
	.db $20 $90
	.db $30 $c0
	.db $40 $c0
	.db $00
@pattern2:
	.db $50 $98
	.db $80 $70
	.db $80 $50
	.db $68 $30
	.db $38 $30
	.db $20 $50
	.db $20 $a0
	.db $30 $b0
	.db $00
@pattern3:
	.db $50 $98
	.db $50 $58
	.db $78 $48
	.db $90 $78
	.db $78 $a8
	.db $50 $20
	.db $30 $20
	.db $28 $40
	.db $60 $a0
	.db $50 $d0
	.db $30 $d0
	.db $28 $b0
	.db $00
