; ==================================================================================================
; ENEMY_EYESOAR
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
; ==================================================================================================
enemyCode7b:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,eyesoar_dead

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
	.dw eyesoar_state_uninitialized
	.dw eyesoar_state1
	.dw eyesoar_state_stub
	.dw eyesoar_state_switchHook
	.dw eyesoar_state_stub
	.dw eyesoar_state_stub
	.dw eyesoar_state_stub
	.dw eyesoar_state_stub
	.dw eyesoar_state8
	.dw eyesoar_state9
	.dw eyesoar_stateA
	.dw eyesoar_stateB
	.dw eyesoar_stateC
	.dw eyesoar_stateD
	.dw eyesoar_stateE


eyesoar_state_uninitialized:
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
	jp nz,ecom_setSpeedAndState8

	; BUG: This sets an invalid state!
	; 'a+1' == SPEED_80+1 == $15, a state which isn't defined.
	; Doesn't really matter, since this object will be deleted anyway...
	; But there are obscure conditions below where it returns before deleting itself.
	; Then this would become a problem. But those conditions probably never happen...
	inc a
	ld (de),a ; [state] = $15 (!)

	ld a,$ff
	ld b,$00
	call enemyBoss_initializeRoom


; Spawning "real" eyesoar and children.
eyesoar_state1:
	; If this actually returns here, the game could crash (see above note).
	ld b,$05
	call checkBEnemySlotsAvailable
	ret nz

	; Spawn the "real" version of the boss (subid 1).
	ld b,ENEMY_EYESOAR
	call ecom_spawnUncountedEnemyWithSubid01

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
	ld (hl),ENEMY_EYESOAR_CHILD
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


eyesoar_state_switchHook:
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
	jp ecom_incSubstate

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
	jp ecom_fallToGroundAndSetState


eyesoar_state_stub:
	ret


; Flickering into existence
eyesoar_state8:
	; Something about doors?
	ld a,($cc93)
	or a
	ret nz

	inc a
	ld (wDisabledObjects),a
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

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
eyesoar_state9:
	call ecom_decCounter1
	jr nz,eyesoar_animate

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	inc (hl)

	call enemyBoss_beginBoss
	jr eyesoar_animate


; Standing still for [counter1] frames?
eyesoar_stateA:
	call eyesoar_updateFormation
	call ecom_decCounter1
	jr nz,eyesoar_animate

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

	jr eyesoar_animate


; Moving until it reaches its target position
eyesoar_stateB:
	call eyesoar_updateFormation
	ld h,d
	ld l,Enemy.var36

	call ecom_readPositionVars
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
	jr eyesoar_animate
++
	call ecom_moveTowardPosition

eyesoar_animate:
	jp enemyAnimate


; Spinning in place after being switch hook'd
eyesoar_stateC:
	call ecom_decCounter1
	jr nz,eyesoar_animate

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_EYESOAR

	xor a
	call enemySetAnimation


; Moving back up into the air
eyesoar_stateD:
	ld h,d
	ld l,Enemy.z
	ld a,(hl)
	sub $80
	ldi (hl),a
	ld a,(hl)
	sbc $00
	ld (hl),a

	cp $fe
	jr nz,eyesoar_animate

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),240

	ld l,Enemy.var3a
	ld (hl),$0f

	ld l,Enemy.var39
	res 1,(hl)
	call eyesoar_chooseNewAngle


; Flying around kinda randomly
eyesoar_stateE:
	call ecom_decCounter1
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
	call z,eyesoar_chooseNewAngle
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr eyesoar_animate


;;
; Checks to update the "formation", that is, the distances away from Eyesoar for the
; children.
eyesoar_updateFormation:
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

	call ecom_decCounter2
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



eyesoar_dead:
	ld e,Enemy.collisionType
	ld a,(de)
	or a
	jr z,@doneKillingChildren

	ld e,Enemy.var30
@killNextChild:
	ld a,(de)
	ld h,a
	ld l,e
	call ecom_killObjectH
	inc e
	ld a,e
	cp Enemy.var36
	jr c,@killNextChild

@doneKillingChildren:
	jp enemyBoss_dead


;;
; Chooses an angle which roughly goes toward the center of the room, plus a small, random
; angle offset.
eyesoar_chooseNewAngle:
	; Get random angle offset in 'c'
	call getRandomNumber_noPreserveVars
	and $0f
	cp $09
	jr nc,eyesoar_chooseNewAngle

	ld c,a
	ld b,$00
	ld e,Enemy.yh
	ld a,(de)
	cp ((LARGE_ROOM_HEIGHT/2)<<4) + 8
	jr c,+
	inc b
+
	ld e,Enemy.xh
	ld a,(de)
	cp ((LARGE_ROOM_WIDTH/2)<<4) + 8
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
