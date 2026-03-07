; ==================================================================================================
; ENEMY_MOTHULA
;
; Variables:
;   var30: Angular speed (amount to add to angle; clockwise / counterclockwise)
;   var31: Index used to decide turning speed while circling around room
;   var32/var33: Target position
;   var34: Counter until mothula stops circling around room
;   var35: Counter to delay updating angle toward target position
;   var36: If nonzero, spawns baby moths instead of ring of fire
;   var37: Counter until mothula will shoot a fireball (while circling around room)
; ==================================================================================================
enemyCode7a:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw mothula_state_uninitialized
	.dw mothula_state_stub
	.dw mothula_state_stub
	.dw mothula_state_stub
	.dw mothula_state_stub
	.dw mothula_state_stub
	.dw mothula_state_stub
	.dw mothula_state_stub
	.dw mothula_state8
	.dw mothula_state9
	.dw mothula_stateA
	.dw mothula_stateB
	.dw mothula_stateC
	.dw mothula_stateD
	.dw mothula_stateE
	.dw mothula_stateF

@dead:
	call getThisRoomFlags
	set 7,(hl)

	; Set bit 7 of room flag in room 1 floor below
	ld a,(wDungeonFlagsAddressH)
	ld h,a
	ld l,$43
	set 7,(hl)
	jp enemyBoss_dead


mothula_state_uninitialized:
	ld a,ENEMY_MOTHULA
	ld b,PALH_SEASONS_82
	call enemyBoss_initializeRoom

	ld bc,$0108
	call enemyBoss_spawnShadow
	ret nz

	call ecom_setSpeedAndState8
	ld c,$10
	jp ecom_setZAboveScreen


mothula_state_stub:
	ret


mothula_state8:
	call objectSetVisible81

	ld a,(wFrameCounter)
	and $1f
	ld a,SND_AQUAMENTUS_HOVER
	call z,playSound

	; Move down
	ld c,$04
	call objectUpdateSpeedZ_paramC
	ld l,Enemy.zh
	ld a,(hl)
	cp $fe
	jr c,mothula_animate

	; Reached ground
	ld l,Enemy.state
	inc (hl) ; [state] = 9

	ld l,Enemy.counter1
	ld (hl),60
	call mothula_setTargetPositionToLeftOrRightSide

	ld a,MUS_BOSS
	ld (wActiveMusic),a
	jp playSound


; Delay before moving
mothula_state9:
	call ecom_decCounter1
	jr nz,mothula_animate

	inc l
	ld (hl),10 ; [counter2]
	ld l,e
	inc (hl) ; [state] = $0a
	call mothula_spawnChild


; Just beginning to move
mothula_stateA:
	call mothula_checkReachedTargetPosition
	jr nc,mothula_moveTowardTargetPosition

	ld l,Enemy.state
	inc (hl) ; [state] = $0b

	ld l,Enemy.counter1
	ld (hl),14
	ld l,Enemy.var37
	ld (hl),$50

	call mothula_initializeStateB
	jr mothula_stateB


; Circling around normally
mothula_stateB:
	call mothula_decVar34Every4Frames
	jr nz,@circlingAround

	; Time to return to center of room (state $0c)
	ld l,e
	inc (hl) ; [state] = $0c
	ld l,Enemy.counter1
	ld (hl),$00

	call mothula_chooseTargetPositionWithinHoles
	jr mothula_animate

@circlingAround:
	ld h,d
	ld l,Enemy.var37
	dec (hl)
	call z,mothula_spawnFireball

	; Increase speed every 10 frames
	call ecom_decCounter2
	jr nz,+++

	ld (hl),10 ; [counter2]
	ld l,Enemy.speed
	ld a,(hl)
	add SPEED_40
	cp SPEED_300 + 1
	jr nc,+++
	ld (hl),a
+++
	call ecom_decCounter1
	jr nz,mothula_applySpeedAndAnimate

	; Turn clockwise or counterclockwise
	ld l,Enemy.var30
	ld e,Enemy.angle
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a
	call mothula_updateAnimation
	call mothula_updateCounter1ForCirclingRoom
	jr nz,mothula_applySpeedAndAnimate

	ld e,Enemy.var31
	ld a,$0e
	ld (de),a
	call mothula_updateCounter1ForCirclingRoom

mothula_applySpeedAndAnimate:
	call objectApplySpeed
mothula_animate:
	jp enemyAnimate


; Returning to one of the two center spots
mothula_stateC:
	call mothula_checkReachedTargetPosition
	jr nc,mothula_moveTowardTargetPosition

	ld l,Enemy.state
	inc (hl) ; [state] = $0d
	xor a
	jp enemySetAnimation


mothula_moveTowardTargetPosition:
	call mothula_updateAngleTowardTargetPosition
	jr mothula_applySpeedAndAnimate


; Deciding how long to stand in place?
mothula_stateD:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0e

	ld bc,$0840
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.var36
	ld a,b
	ld (de),a

	ld e,Enemy.counter1
	ld a,120
	add c
	ld (de),a
	jr mothula_animate


; Standing in place
mothula_stateE:
	call ecom_decCounter1
	jr z,++
	call mothula_updateZPosAndOamFlagsForStateE
	jr mothula_animate
++
	inc l
	ld (hl),30 ; [counter1]
	ld l,e
	inc (hl) ; [state] = $0f

	ld l,Enemy.zh
	ld (hl),$fe

	ld l,Enemy.oamFlags
	ld a,$06
	ldd (hl),a
	ld (hl),a

	call mothula_spawnSomethingAfterStandingStill
	ld a,$08
	jp enemySetAnimation


; Delay before circling around room again
mothula_stateF:
	call ecom_decCounter2
	jr nz,mothula_animate

	ld l,e
	ld (hl),$0a ; [state] = $0a

	ld l,Enemy.counter2
	ld (hl),10
	dec l
	ld (hl),$00 ; [counter1]

	jp mothula_setTargetPositionToLeftOrRightSide


;;
; @param	hl	var37 (counter to spawn projectile)
mothula_spawnFireball:
	ld (hl),$50
	ld b,PART_GOPONGA_PROJECTILE
	jp ecom_spawnProjectile

;;
; Decides what to spawn after state $0e (small moth or ring of fireballs).
mothula_spawnSomethingAfterStandingStill:
	ld e,Enemy.var36
	ld a,(de)
	or a
	jr nz,mothula_spawnChild

	ld b,PART_MOTHULA_PROJECTILE_2
	call ecom_spawnProjectile
	ret nz

	ld l,Part.subid

;;
; Sets child object's subid to $80 normally, or $81 if mothula's health is $10 or less
;
; @param	hl	Pointer to child object's subid
mothula_initChild:
	ld b,$80
	ld e,Enemy.health
	ld a,(de)
	cp $10
	jr nc,+
	inc b
+
	ld (hl),b
	ret

;;
mothula_spawnChild:
	ld b,ENEMY_MOTHULA_CHILD
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz
	call mothula_initChild
	jp objectCopyPosition

;;
; Update mothula "bouncing" in place for state $0e
;
; @param	hl	counter1
mothula_updateZPosAndOamFlagsForStateE:
	ld a,(hl)
	cp 90
	ret nc

	and $0e
	rrca
	ld bc,@zPositions
	call addAToBc

	ld l,Enemy.zh
	ld a,(bc)
	ld (hl),a

	ld l,Enemy.var36
	ld b,(hl)
	srl b
	srl b
	ld l,Enemy.counter1
	ld a,(hl)
	and $01
	add b
	ld bc,@oamFlags
	call addAToBc
	ld l,Enemy.oamFlags
	ld a,(bc)
	ldd (hl),a
	ld (hl),a
	ret

@zPositions:
	.db $ff $fe $fd $fc $fb $fc $fd $fe

@oamFlags:
	.db $06 $04 ; Spawning baby moths
	.db $06 $05 ; Spawning ring of fire


;;
; @param[out]	cflag	c if reached target position
mothula_checkReachedTargetPosition:
	ld h,d
	ld l,Enemy.var32
	call ecom_readPositionVars
	sub c
	add $04
	cp $09
	ret nc
	ldh a,(<hFF8F)
	sub b
	add $04
	cp $09
	ret


;;
mothula_setTargetPositionToLeftOrRightSide:
	call getRandomNumber_noPreserveVars
	and $01
	jr nz,+
	dec a
+
	ld h,d
	ld l,Enemy.var30
	ld (hl),a

	ld a,$32
	ld b,$ba
	bit 7,(hl)
	jr z,+
	ld b,$36
+
	ld l,Enemy.var32
	ldi (hl),a
	ld (hl),b

	ld l,Enemy.angle
	ld (hl),$00
	ld l,Enemy.speed
	ld (hl),SPEED_100

	ld l,Enemy.var31
	ld (hl),$00
	ld l,Enemy.var35
	ld (hl),$06
	jr mothula_updateAnimation

;;
; Chooses a position in one of the two center areas
mothula_chooseTargetPositionWithinHoles:
	call getRandomNumber_noPreserveVars
	rrca
	ld a,$50
	ld b,$68
	jr c,+
	ld b,$88
+
	ld h,d
	ld l,Enemy.var32
	ldi (hl),a
	ld (hl),b
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ret

;;
mothula_updateAngleTowardTargetPosition:
	ld h,d
	ld l,Enemy.var35
	dec (hl)
	ret nz

	ld (hl),$06

	call objectGetRelativeAngleWithTempVars
	ld c,a
	call objectNudgeAngleTowards

;;
mothula_updateAnimation:
	ld h,d
	ld l,Enemy.angle
	ldd a,(hl)
	add $02
	and $1c
	rrca
	rrca
	cp (hl) ; [direction]
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
; Updates counter1 to decide how long until the angle will next be updated. This allows
; mothula to move in an oval pattern.
;
; @param[out]	zflag	z if completed a full circle (var31 should be reset)
mothula_updateCounter1ForCirclingRoom:
	ld h,d
	ld l,Enemy.var31
	ld a,(hl)
	inc (hl)
	ld b,a
	srl a
	ld hl,@counterVals
	rst_addAToHl
	ld a,(hl)
	rrc b
	jr c,+
	swap a
+
	and $0f
	ret z
	ld e,Enemy.counter1
	ld (de),a
	ret

; Each half-byte is a value for counter1, determining how fast mothula turns at various
; points during her movement.
@counterVals:
	.db $33 $48 $55 $66 $77 $7f $55 $54
	.db $32 $36 $32 $34 $55 $8f $76 $00


;;
; @param[out]	zflag	z if var34 reached 0
mothula_decVar34Every4Frames:
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld h,d
	ld l,Enemy.var34
	dec (hl)
	ret


;;
; Calculates appropriate angle, and decides how long to remain in state $0b (circling
; around room).
mothula_initializeStateB:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@var34Vals
	rst_addAToHl
	ld e,Enemy.var34
	ld a,(hl)
	ld (de),a

	ld e,Enemy.var30
	ld a,(de)
	dec a
	ld a,$0c
	jr z,+
	ld a,$14
+
	ld e,Enemy.angle
	ld (de),a
	jr mothula_updateAnimation

; Potential lengths of time for Mothula to circle around the room
@var34Vals:
	.db $35 $5b $5b $82
