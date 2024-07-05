; ==================================================================================================
; ENEMY_AMBI_GUARD
;
; Variables:
;   relatedObj2: PART_DETECTION_HELPER; checks when Link is visible.
;   var30-var31: Movement script address
;   var32: Y-destination (reserved by movement script)
;   var33: X-destination (reserved by movement script)
;   var34: Bit 0 set when Link should be noticed; Bit 1 set once the guard has started
;          reacting to Link (shown exclamation mark).
;   var35: Nonzero if just hit with an indirect attack (moves more quickly)
;   var36: While this is nonzero, all "normal code" is ignored. It counts down to zero,
;          and once it's done, it sets var35 to 1 (move more quickly) and normal code
;          resumes. Used for the delay between noticing Link and taking action.
;   var37: Timer until guard "notices" scent seed.
;   var3a: When set to $ff, faces PART_DETECTION_HELPER?
;   var3b: When set to $ff, the guard immediately notices Link. (Written to by
;          PART_DETECTION_HELPER.)
; ==================================================================================================
enemyCode54:
	jr z,@normalStatus	 
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,ambiGuard_noHealth
	dec a
	jp nz,ecom_updateKnockback
	call ambiGuard_collisionOccured

@normalStatus:
	ld e,Enemy.subid
	ld a,(de)
	rlca
	jp c,ambiGuard_attacksLink


; Subids $00-$7f
ambiGuard_tossesLinkOut:
	call ambiGuard_checkSpottedLink
	call ambiGuard_checkAlertTrigger
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw ambiGuard_tossesLinkOut_uninitialized
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_galeSeed
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state8
	.dw ambiGuard_state9
	.dw ambiGuard_stateA
	.dw ambiGuard_stateB
	.dw ambiGuard_stateC
	.dw ambiGuard_stateD
	.dw ambiGuard_stateE
	.dw ambiGuard_tossesLinkOut_stateF
	.dw ambiGuard_tossesLinkOut_state10
	.dw ambiGuard_tossesLinkOut_state11


ambiGuard_tossesLinkOut_uninitialized:
	ld hl,ambiGuard_tossesLinkOut_scriptTable
	call objectLoadMovementScript

	call ambiGuard_commonInitialization
	ret nz

	ld e,Enemy.direction
	ld a,(de)
	jp enemySetAnimation


; NOTE: Guards don't seem to react to gale seeds? Is this unused?
ambiGuard_state_galeSeed:
	call ecom_galeSeedEffect
	ret c

	ld e,Enemy.var34
	ld a,(de)
	or a
	ld e,Enemy.var35
	call z,ambiGuard_alertAllGuards
	call decNumEnemies
	jp enemyDelete


ambiGuard_state_stub:
	ret


; Moving up
ambiGuard_state8:
	ld e,Enemy.var32
	ld a,(de)
	ld h,d
	ld l,Enemy.yh
	cp (hl)
	jr nc,@reachedDestination
	call objectApplySpeed
	jr ambiGuard_animate

@reachedDestination:
	ld a,(de)
	ld (hl),a
	jp ambiGuard_runMovementScript


; Moving right
ambiGuard_state9:
	ld e,Enemy.xh
	ld a,(de)
	ld h,d
	ld l,Enemy.var33
	cp (hl)
	jr nc,@reachedDestination
	call objectApplySpeed
	jr ambiGuard_animate

@reachedDestination:
	ld a,(hl)
	ld (de),a
	jp ambiGuard_runMovementScript


; Moving down
ambiGuard_stateA:
	ld e,Enemy.yh
	ld a,(de)
	ld h,d
	ld l,Enemy.var32
	cp (hl)
	jr nc,@reachedDestination
	call objectApplySpeed
	jr ambiGuard_animate

@reachedDestination:
	ld a,(hl)
	ld (de),a
	jp ambiGuard_runMovementScript


; Moving left
ambiGuard_stateB:
	ld e,Enemy.var33
	ld a,(de)
	ld h,d
	ld l,Enemy.xh
	cp (hl)
	jr nc,@reachedDestination
	call objectApplySpeed
	jr ambiGuard_animate

@reachedDestination:
	ld a,(de)
	ld (hl),a
	jp ambiGuard_runMovementScript


; Waiting
ambiGuard_stateC:
ambiGuard_stateE:
	call ecom_decCounter1
	jp z,ambiGuard_runMovementScript

ambiGuard_animate:
	jp enemyAnimate


; Standing in place for [counter1] frames, then turn the other way for 30 frames, then
; resume movemnet
ambiGuard_stateD:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	swap a
	rlca
	jp enemySetAnimation


; Begin moving toward Link after noticing him
ambiGuard_tossesLinkOut_stateF:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),90
	call ambiGuard_turnToFaceLink
	ld a,SND_WHISTLE
	jp playSound


; Moving toward Link until screen fades out and Link gets booted out
ambiGuard_tossesLinkOut_state10:
	call enemyAnimate
	call ecom_decCounter1
	jr z,++
	ld c,$18
	call objectCheckLinkWithinDistance
	jp nc,ecom_applyVelocityForSideviewEnemyNoHoles
++
	ld a,CUTSCENE_BOOTED_FROM_PALACE
	ld (wCutsceneTrigger),a
	ret


ambiGuard_tossesLinkOut_state11:
	ret


ambiGuard_attacksLink:
	call ambiGuard_checkSpottedLink
	call ambiGuard_checkAlertTrigger
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw ambiGuard_attacksLink_state_uninitialized
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_galeSeed
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state8
	.dw ambiGuard_state9
	.dw ambiGuard_stateA
	.dw ambiGuard_stateB
	.dw ambiGuard_stateC
	.dw ambiGuard_stateD
	.dw ambiGuard_stateE
	.dw ambiGuard_attacksLink_stateF
	.dw ambiGuard_attacksLink_state10
	.dw ambiGuard_attacksLink_state11


ambiGuard_attacksLink_state_uninitialized:
	ld h,d
	ld l,Enemy.subid
	res 7,(hl)

	ld hl,ambiGuard_attacksLink_scriptTable
	call objectLoadMovementScript

	ld h,d
	ld l,Enemy.subid
	set 7,(hl)

	call ambiGuard_commonInitialization
	ret nz

	ld e,Enemy.direction
	ld a,(de)
	jp enemySetAnimation


; Just noticed Link
ambiGuard_attacksLink_stateF:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter2
	ld a,(hl)
	or a
	jr nz,+
	ld (hl),60
+
	call ambiGuard_createExclamationMark
	jr ambiGuard_turnToFaceLink


; Looking at Link; counting down until he starts chasing him
ambiGuard_attacksLink_state10:
	call ecom_decCounter2
	jr z,@beginChasing

	ld a,(hl)
	cp 60
	ret nz

	ld a,SND_WHISTLE
	call playSound
	ld e,Enemy.var34
	jp ambiGuard_alertAllGuards

@beginChasing:
	dec l
	ld (hl),20 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_180
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_AMBI_GUARD_CHASING_LINK

;;
ambiGuard_turnToFaceLink:
	call ecom_updateCardinalAngleTowardTarget
	swap a
	rlca
	jp enemySetAnimation


; Currently chasing Link
ambiGuard_attacksLink_state11:
	call ecom_decCounter1
	jr nz,++
	ld (hl),20
	call ambiGuard_turnToFaceLink
++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp enemyAnimate

;;
; Deletes self if Veran was defeated, otherwise spawns PART_DETECTION_HELPER.
;
; @param[out]	zflag	nz if caller should return immediately (deleted self)
ambiGuard_commonInitialization:
	ld hl,wGroup4RoomFlags+$fc
	bit 7,(hl)
	jr z,++
	call enemyDelete
	or d
	ret
++
	call getFreePartSlot
	jr nz,++
	ld (hl),PART_DETECTION_HELPER
	ld l,Part.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld e,Enemy.relatedObj2
	ld a,Part.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld h,d
	ld l,Enemy.direction
	ldi a,(hl)
	swap a
	rrca
	ld (hl),a
	call objectSetVisiblec2
	xor a
	ret
++
	ld e,Enemy.state
	xor a
	ld (de),a
	ret

;;
ambiGuard_runMovementScript:
	call objectRunMovementScript

	; Update animation
	ld e,Enemy.angle
	ld a,(de)
	and $18
	swap a
	rlca
	jp enemySetAnimation

;;
; When var36 is nonzero, this counts it down, then sets var35 to nonzero when var36
; reaches 0. (This alerts the guard to start moving faster.) Also, all other guards
; on-screen will be alerted in this way.
;
; As long as var36 is nonzero, this "returns from caller" (discards return address).
ambiGuard_checkAlertTrigger:
	ld h,d
	ld l,Enemy.var36
	ld a,(hl)
	or a
	ret z

	pop bc ; return from caller

	dec (hl)
	ld a,(hl)
	dec a
	jr nz,@stillCountingDown

	; Check if in a standard movement state
	ld l,Enemy.state
	ld a,(hl)
	sub $08
	cp $04
	ret nc

	; Update angle, animation based on state
	ld b,a
	swap a
	rrca
	ld e,Enemy.angle
	ld (de),a
	ld a,b
	jp enemySetAnimation

@stillCountingDown:
	cp 59
	ret nz

	; NOTE: Why on earth is this sound played? SND_WHISTLE would make more sense...
	ld a,SND_MAKU_TREE_PAST
	call playSound

	; Alert all guards to start moving more quickly
	ld e,Enemy.var35


;;
; @param	de	Variable to set on the guards. "var34" to alert them to Link
;			immediately, "var35" to make them patrol faster.
ambiGuard_alertAllGuards:
	ldhl FIRST_ENEMY_INDEX,Enemy.enabled
---
	ld l,Enemy.id
	ld a,(hl)
	cp ENEMY_AMBI_GUARD
	jr nz,@nextEnemy

	ld a,h
	cp d
	jr z,@nextEnemy

	ld l,e
	ld a,(hl)
	or a
	jr nz,@nextEnemy

	inc (hl)
	bit 0,l
	jr z,@nextEnemy

	ld l,Enemy.var36
	ld (hl),60
@nextEnemy:
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,---
	ret


;;
; Checks for spotting Link, among other things?
ambiGuard_checkSpottedLink:
	ld a,(wScentSeedActive)
	or a
	jr nz,@scentSeed

@normalCheck:
	; Notice Link if playing the flute.
	; (Doesn't work properly for harp tunes?)
	ld a,(wLinkPlayingInstrument)
	or a
	jr nz,@faceLink

	; if var3a == $ff, turn toward part object?
	ld e,Enemy.var3a
	ld a,(de)
	inc a
	jr nz,@commonUpdate

	ld (de),a ; [var3a] = 0

	ld a,Object.yh
	call objectGetRelatedObject2Var
	ld b,(hl)
	ld l,Object.xh
	ld c,(hl)
	call objectGetRelativeAngle
	jr @alertGuardToMoveFast

@scentSeed:
	; When [var37] == 0, the guard notices the scent seed (turns toward it and has an
	; exclamation point).
	ld h,d
	ld l,Enemy.var37
	ld a,(hl)
	or a
	jr z,@noticedScentSeed

	ld a,(wFrameCounter)
	rrca
	jr c,@normalCheck
	dec (hl)
	jr @normalCheck

@noticedScentSeed:
	; Set the counter to more than the duration of a scent seed, so the guard only
	; turns toward it once...
	ld (hl),150 ; [var37]

@faceLink:
	call objectGetAngleTowardEnemyTarget

@alertGuardToMoveFast:
	; When reaching here, a == angle the guard should face
	ld h,d
	ld l,Enemy.var35
	inc (hl)
	inc l
	ld (hl),60 ; [var36]
	call ambiGuard_setAngle

@commonUpdate:
	; If [var3b] == $ff, notice Link immediately.
	ld h,d
	ld l,Enemy.var3b
	ld a,(hl)
	ld (hl),$00
	inc a
	jr nz,++
	ld l,Enemy.var34
	ld a,(hl)
	or a
	jr nz,++
	inc (hl) ; [var34]
	call ambiGuard_setCounter2ForAttackingTypeOnly
++
	ld e,Enemy.var34
	ld a,(de)
	rrca
	jr nc,@haventSeenLinkYet

	; Return if bit 1 of var34 set (already noticed Link)
	rrca
	ret c

	; Link is close enough to have been noticed. Do some extra checks for the "tossing
	; Link out" subids only.

	ld l,Enemy.subid
	bit 7,(hl)
	jr nz,@noticedLink

	call checkLinkCollisionsEnabled
	ret nc

	ld a,(w1Link.zh)
	rlca
	ret c

	; Link has been seen. Disable inputs, etc.

	ld a,$80
	ld (wMenuDisabled),a

	ld a,DISABLE_COMPANION|DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wDisableScreenTransitions),a

	; Wait for 60 frames
	ld e,Enemy.var36
	ld a,60
	ld (de),a

	call ambiGuard_createExclamationMark

@noticedLink:
	; Mark bit 1 to indicate the exclamation mark was shown already, etc.
	ld h,d
	ld l,Enemy.var34
	set 1,(hl)

	ld l,Enemy.state
	ld (hl),$0f

	; Delete PART_DETECTION_HELPER
	ld a,Object.health
	call objectGetRelatedObject2Var
	ld (hl),$00
	ret

@haventSeenLinkYet:
	; Was the guard hit with an indirect attack?
	inc e
	ld a,(de) ; [var35]
	rrca
	ret nc

	; He was; update speed, make exclamation mark.
	xor a
	ld (de),a

	ld l,Enemy.speed
	ld (hl),SPEED_140

	; fall through

;;
ambiGuard_createExclamationMark:
	ld a,45
	ld bc,$f408
	jp objectCreateExclamationMark


ambiGuard_collisionOccured:
	; If already noticed Link, return
	ld e,Enemy.var34
	ld a,(de)
	or a
	ret nz

	; Check whether attack type was direct or indirect
	ld h,d
	ld l,Enemy.var2a
	ld a,(hl)
	cp $92 ; Collisions up to & including ITEMCOLLISION_11 are "direct" attacks
	jr c,ambiGuard_directAttackOccurred

	cp $80|ITEMCOLLISION_GALE_SEED
	ret z

	; COLLISION_TYPE_SOMARIA_BLOCK or above (indirect attack)
	ld h,d
	ld l,Enemy.var35
	ld a,(hl)
	or a
	ret nz

	inc (hl) ; [var35] = 1 (make guard move move quickly)
	inc l
	ld (hl),90 ; [var36] (wait for 90 frames)

	ld l,Enemy.knockbackAngle
	ld a,(hl)
	xor $10

	; fall through


;;
; @param	a	Angle
ambiGuard_setAngle:
	add $04
	and $18
	ld e,Enemy.angle
	ld (de),a

	swap a
	rlca
	jp enemySetAnimation

;;
; A collision with one of Link's direct attacks (sword, fist, etc) occurred.
ambiGuard_directAttackOccurred:
	; Guard notices Link right away
	ld e,Enemy.var34
	ld a,$01
	ld (de),a

;;
; Does some initialization for "attacking link" type only, when they just notice Link.
ambiGuard_setCounter2ForAttackingTypeOnly:
	ld e,Enemy.subid
	ld a,(de)
	rlca
	ret nc

	; For "attacking Link" subids only, do extra initialization
	ld e,Enemy.counter2
	ld a,90
	ld (de),a
	ld e,Enemy.var36
	xor a
	ld (de),a
	ret


; Scampering away when health is 0
ambiGuard_noHealth:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.speedZ
	ld a,$00
	ldi (hl),a
	ld (hl),$ff

; Initial jump before moving away
@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	; Landed
	ld l,Enemy.substate
	inc (hl)

	ld l,Enemy.speedZ
	ld a,<(-$1c0)
	ldi (hl),a
	ld (hl),>(-$1c0)

	ld l,Enemy.speed
	ld (hl),SPEED_140

	ld l,Enemy.knockbackAngle
	ld a,(hl)
	ld l,Enemy.angle
	ld (hl),a

	add $04
	and $18
	swap a
	rlca
	jp enemySetAnimation

; Moving away until off-screen
@substate2:
	ld e,Enemy.yh
	ld a,(de)
	cp LARGE_ROOM_HEIGHT<<4
	jp nc,enemyDelete

	ld e,Enemy.xh
	ld a,(de)
	cp LARGE_ROOM_WIDTH<<4
	jp nc,enemyDelete

	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,enemyAnimate

	; Landed on ground
	ld l,Enemy.speedZ
	ld a,<(-$1c0)
	ldi (hl),a
	ld (hl),>(-$1c0)
	ret


; The tables below define the guards' patrol patterns.
; See include/movementscript_commands.s.
ambiGuard_tossesLinkOut_scriptTable:
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03
	.dw @subid04
	.dw @subid05
	.dw @subid06
	.dw @subid07
	.dw @subid08
	.dw @subid09
	.dw @subid0a
	.dw @subid0b
	.dw @subid0c

@subid00:
	.db SPEED_c0
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_left  $28
	ms_down  $58
	ms_right $68
	ms_loop  @@loop

@subid01:
	.db SPEED_c0
	.db DIR_RIGHT
@@loop:
	ms_right $30
	ms_state 15, $0d
	ms_right $58
	ms_wait  30
	ms_left  $30
	ms_state 15, $0d
	ms_left  $08
	ms_wait  30
	ms_loop  @@loop

@subid02:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $78
	ms_down  $18
	ms_wait  60
	ms_left  $38
	ms_down  $18
	ms_wait  60
	ms_right $58
	ms_loop  @@loop

@subid03:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $78
	ms_up    $38
	ms_wait  60
	ms_left  $18
	ms_down  $38
	ms_wait  60
	ms_right $48
	ms_loop  @@loop

@subid04:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $38
	ms_right $48
	ms_wait  60
	ms_left  $18
	ms_down  $38
	ms_wait  60
	ms_up    $18
	ms_right $48
	ms_state 15, $0d
	ms_wait  40
	ms_state 15, $0d
	ms_loop  @@loop

@subid05:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $38
	ms_state 15, $0d
	ms_wait  40
	ms_state 15, $0d
	ms_left  $38
	ms_down  $58
	ms_left  $38
	ms_wait  60
	ms_right $68
	ms_state 15, $0d
	ms_wait  40
	ms_state 15, $0d
	ms_loop  @@loop

@subid06:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $38
	ms_down  $48
	ms_right $38
	ms_wait  60
	ms_down  $68
	ms_left  $18
	ms_up    $18
	ms_loop  @@loop

@subid07:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_right $88
	ms_down  $68
	ms_left  $68
	ms_up    $48
	ms_left  $68
	ms_wait  60
	ms_loop  @@loop

@subid08:
	.db SPEED_80
	.db DIR_LEFT
@@loop:
	ms_left  $18
	ms_state 15, $0d
	ms_up    $18
	ms_state 15, $0d
	ms_right $78
	ms_state 15, $0d
	ms_down  $58
	ms_state 15, $0d
	ms_left  $48
	ms_loop  @@loop

@subid09:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $78
	ms_state 15, $0d
	ms_up    $18
	ms_state 15, $0d
	ms_left  $28
	ms_state 15, $0d
	ms_down  $58
	ms_state 15, $0d
	ms_right $58
	ms_loop  @@loop

@subid0a:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_wait  127
	ms_loop  @@loop

@subid0b:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_wait  127
	ms_loop  @@loop

@subid0c:
	.db SPEED_80
	.db DIR_LEFT
@@loop:
	ms_wait  127
	ms_loop  @@loop


ambiGuard_attacksLink_scriptTable:
	.dw @subid80
	.dw @subid81
	.dw @subid82
	.dw @subid83
	.dw @subid84
	.dw @subid85
	.dw @subid86
	.dw @subid87
	.dw @subid88
	.dw @subid89
	.dw @subid8a
	.dw @subid8b
	.dw @subid8c


@subid80:
	.db SPEED_c0
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_left  $28
	ms_down  $58
	ms_right $68
	ms_loop  @@loop

@subid81:
	.db SPEED_c0
	.db DIR_RIGHT
@@loop:
	ms_right $30
	ms_state 15, $0d
	ms_right $58
	ms_wait  30
	ms_left  $30
	ms_state 15, $0d
	ms_left  $08
	ms_wait  30
	ms_loop  @@loop

@subid82:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $88
	ms_left  $28
	ms_up    $48
	ms_state 15, $0d
	ms_down  $88
	ms_right $98
	ms_up    $28
	ms_left  $28
	ms_down  $48
	ms_state 15, $0d
	ms_up    $28
	ms_right $98
	ms_loop  @@loop

@subid83:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $58
	ms_right $d8
	ms_up    $28
	ms_left  $98
	ms_down  $58
	ms_right $d8
	ms_down  $88
	ms_left  $98
	ms_up    $78
	ms_loop  @@loop

@subid84:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_right $d8
	ms_down  $88
	ms_left  $18
	ms_loop  @@loop

@subid85:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $88
	ms_left  $18
	ms_up    $18
	ms_right $d8
	ms_loop  @@loop

@subid86:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $58
	ms_left  $28
	ms_up    $28
	ms_right $68
	ms_loop  @@loop

@subid87:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $c8
	ms_up    $28
	ms_left  $88
	ms_down  $58
	ms_loop  @@loop

@subid88:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $58
	ms_left  $58
	ms_down  $88
	ms_right $98
	ms_loop  @@loop

@subid89:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $28
	ms_left  $38
	ms_down  $88
	ms_right $98
	ms_loop  @@loop

@subid8a:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $98
	ms_right $c8
	ms_up    $18
	ms_left  $a8
	ms_wait  60
	ms_right $c8
	ms_down  $98
	ms_left  $a8
	ms_up    $18
	ms_wait  60
	ms_loop  @@loop

@subid8b:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_left  $28
	ms_down  $58
	ms_right $48
	ms_down  $98
	ms_left  $28
	ms_up    $58
	ms_right $48
	ms_loop  @@loop

@subid8c:
	.db SPEED_80
	.db DIR_LEFT
@@loop:
	ms_left  $78
	ms_wait  60
	ms_down  $58
	ms_wait  60
	ms_right $78
	ms_wait  60
	ms_up    $58
	ms_wait  60
	ms_loop  @@loop
