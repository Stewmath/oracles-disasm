; ==================================================================================================
; ENEMY_GLEEOK
;
; Variables (subid 1, main body):
;   var30-var37: Contain high bytes of other body parts with subids 2-9
;   var38: Bitfield of which 3 bits are used:
;     Bit 0: Set while one of the heads is performing one of the attacks 0-2 to block the other
;            head from the same attack range
;     Bit 1: Set whenever the left head is detached and floating through the room
;     Bit 2: Set whenever the right head is detached and floating through the room
;
; Variables (subids 2 and 3, heads):
;   var03: Attack pattern (0-5)
;   relatedObj1: Points to the main body
;   var30: Angle sequence index for movement in attack patterns 4 and 5
;   var31: Wait timer for next angle update in attack patterns 4 and 5
;   var39: Projectile target y for attack pattern 1
;   var3a: Projectile target x for attack pattern 1
;
; Variables (subids 4 to 9, neck segments):
;   relatedObj1: Points to the main body
;   relatedObj2: Points to the head on the same side
; ==================================================================================================
enemyCode06:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus
	; If main body has no health, consider the boss defeated
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp z,enemyBoss_dead
	ld e,Enemy.collisionType
	ld a,(de)
	or a
	jp z,enemyDie_uncounted_withoutItemDrop
	; Otherwise a head has no health, mark it as floating in main body variable
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	ld b,$02 ; left head
	jr z,+
	ld b,$04 ; right head
+
	ld a,Object.var38
	call objectGetRelatedObject1Var
	ld a,(hl)
	or b
	ld (hl),a
	; If this head is currently performing a fire attack and the other head is also attacking,
	; advance the other head to state $0c so it can pick a fire attack soon
	ld e,Enemy.state
	ld a,(de)
	cp $0b
	jr nz,+
	ld e,Enemy.var03
	ld a,(de)
	cp $03
	jr nc,+
	ld e,Enemy.subid
	ld a,(de)
	xor $01
	add Enemy.var30-2
	ld l,a
	ld h,(hl)
	ld l,Enemy.state
	ld a,(hl)
	cp $0b
	jr nz,+
	inc (hl)
+
	; Put head in state $0e (floating across the room)
	ld h,d
	ld l,Enemy.state
	ld (hl),$0e
	; Reset health and make immune to attacks
	ld l,Enemy.collisionType
	set 7,(hl)
	inc l
	ld (hl),ENEMYCOLLISION_PODOBOO ; [enemyCollisionMode]
	ld l,Enemy.health
	ld (hl),$19
	ld l,Enemy.knockbackAngle
	ld a,(hl)
	ld l,Enemy.angle
	ld (hl),a
	ld l,Enemy.speed
	ld (hl),SPEED_200
	ld l,Enemy.counter1
	ld (hl),150
	xor a
	jp enemySetAnimation

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,+
	rst_jumpTable
	.dw gleeok_state_uninitialized
	.dw gleeok_state_spawner
	.dw gleeok_state_stub
	.dw gleeok_state_stub
	.dw gleeok_state_stub
	.dw gleeok_state_stub
	.dw gleeok_state_stub
	.dw gleeok_state_stub
+
	dec b
	ld a,b
	rst_jumpTable
	.dw gleeok_body
	.dw gleeok_headLeft
	.dw gleeok_headRight
	.dw gleeok_neckTopLeft
	.dw gleeok_neckTopRight
	.dw gleeok_neckMiddleLeft
	.dw gleeok_neckMiddleRight
	.dw gleeok_neckBottomLeft
	.dw gleeok_neckBottomRight

; Initialize room or body part depending on subid
gleeok_state_uninitialized:
	ld a,b
	or a
	jp z,@initializeRoom
	call ecom_setSpeedAndState8AndVisible
	jp gleeok_initializeBodyPart

@initializeRoom:
	inc a
	ld (de),a ; [state]
	ld a,ENEMY_GLEEOK
	ld b,PALH_SEASONS_87
	call enemyBoss_initializeRoom

; Spawn the 9 body parts with references between main body and other parts, then delete self
gleeok_state_spawner:
	ld b,9
	call checkBEnemySlotsAvailable
	ret nz
	ld b,ENEMY_GLEEOK
	call ecom_spawnUncountedEnemyWithSubid01
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a
	ld l,Enemy.var30
	ld c,h
	; Spawn 8 enemy objects (2 heads and 6 neck segments)
	ld e,8
-
	push hl
	call ecom_spawnUncountedEnemyWithSubid01
	ld a,$0a
	sub e
	ld (hl),a ; [subid]
	; Make relatedObj1 point to main body
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c
	ld a,h
	pop hl
	ldi (hl),a ; [var30] through [var37]
	dec e
	jr nz,-
	jp enemyDelete

gleeok_state_stub:
	ret

; Main body
gleeok_body:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw gleeok_body_state8
	.dw gleeok_body_state9
	.dw gleeok_body_stateA
	.dw gleeok_body_stateB
	.dw gleeok_body_stateC
	.dw gleeok_body_stateD
	.dw gleeok_body_stateE
	.dw gleeok_body_stateF
	.dw gleeok_body_state10

; Start playing music once the shutter door is closed
gleeok_body_state8:
	ld a,(wcc93)
	or a
	ret nz
	ld h,d
	ld l,e
	inc (hl) ; [state]
	ld a,MUS_BOSS
	ld (wActiveMusic),a
	jp playSound

; Wait until both heads are floating
gleeok_body_state9:
	ld e,Enemy.var38
	ld a,(de)
	bit 1,a
	jr z,gleeok_body_animate
	bit 2,a
	jr z,gleeok_body_animate
	; Both heads are floating, prepare second phase
	ld h,d
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter2
	ld (hl),60
	; Set health of heads to 0 and disable their collision
	ld e,Enemy.var30
	ld a,(de)
	ld h,a
	ld l,Enemy.health
	xor a
	ld (hl),a ; left head
	ld l,Enemy.collisionType
	ld (hl),a
	inc e
	ld a,(de) ; [var31]
	ld h,a
	xor a
	ld (hl),a ; [collisionType]
	ld l,Enemy.health
	ld (hl),a ; right head
	; Make floor under main body no longer solid
	ld hl,wRoomCollisions+$16
	xor a ; Unnecessary
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld l,$26
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld a,SND_BOSS_DEAD
	call playSound
	ld a,SNDCTRL_STOPMUSIC
	jp playSound

; Flicker and transition to second phase
gleeok_body_stateA:
	call ecom_decCounter2
	jp nz,ecom_flickerVisibility
	ld bc,$020c
	call enemyBoss_spawnShadow
	jp nz,ecom_flickerVisibility
	ld h,d
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),30
	ld a,$04
	call enemySetAnimation

; Start playing music again
gleeok_body_stateB:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	inc (hl) ; [counter1] = 1
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.collisionType
	set 7,(hl)
	ld a,MUS_BOSS
	ld (wActiveMusic),a
	call playSound
	ld e,Enemy.state

; Start jump
gleeok_body_stateC:
	call ecom_decCounter1
	jr nz,+
	ld l,e
	inc (hl) ; [state]
	ld bc,$fdc0
	call objectSetSpeedZ
	jp objectSetVisible81
+
	ld a,(hl) ; [counter1]
	cp 10
	ret c

gleeok_body_animate:
	jp enemyAnimate

; Perform jump and shake the ground when landing
gleeok_body_stateD:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),150
	ld a,120
	call setScreenShakeCounter
	call objectSetVisible82
	ld a,SND_STRONG_POUND
	jp playSound

; Stun Link if he touches the ground within 15 frames after landing, then after waiting set the angle to face Link
gleeok_body_stateE:
	call ecom_decCounter1
	jr z,@prepareRunTowardsLink
	ld a,(hl) ; [counter1]
	cp 135
	jr c,gleeok_body_animate
	ld a,(w1Link.zh)
	rlca
	ret c
	ld hl,wLinkForceState
	ld a,$14
	ldi (hl),a
	ld (hl),$00 ; [wcc50]
	ret

@prepareRunTowardsLink:
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.speed
	ld (hl),SPEED_200
	call ecom_updateAngleTowardTarget
	jr gleeok_body_animate

; Run until a wall is encountered
gleeok_body_stateF:
	ld a,$01 ; Holes count as walls
	call ecom_getSideviewAdjacentWallsBitset
	jr nz,@reachedWall
	call objectApplySpeed
	jr gleeok_body_animate

@reachedWall:
	ld a,40
	call setScreenShakeCounter
	ld h,d
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_80
	; Bounce in opposite direction of running
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	ld bc,$fe80
	call objectSetSpeedZ
	jr gleeok_body_animate

; Perform bounce away from wall
gleeok_body_state10:
	call ecom_applyVelocityForSideviewEnemyNoHoles
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr nz,gleeok_body_animate
	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.counter1
	ld (hl),60
	jr gleeok_body_animate

; Left head
gleeok_headLeft:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw gleeok_headLeft_state8
	.dw gleeok_head_state9
	.dw gleeok_headLeft_stateA
	.dw gleeok_head_stateB
	.dw gleeok_head_stateC
	.dw gleeok_head_stateD
	.dw gleeok_head_stateE
	.dw gleeok_head_stateF
	.dw gleeok_head_state10
	.dw gleeok_head_state11

; Initialize head-specific properties
gleeok_headLeft_state8:
	ld h,d
	ld l,Enemy.angle
	ld (hl),$14
@rightHeadEntry:
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.counter1
	ld (hl),60
	ld l,Enemy.speed
	ld (hl),SPEED_80
	ret

; Increment state when counter1 reaches 0 after decrementing
gleeok_head_state9:
gleeok_head_state10:
	call ecom_decCounter1
	jp nz,objectApplySpeed
	ld l,e
	inc (hl) ; [state]
	ret

; Pick the next attack pattern
gleeok_headLeft_stateA:
	ld b,$04
@rightHeadEntry:
	; If other head is currently floating, pick one of the attacks 0-2
	ld a,Object.var38
	call objectGetRelatedObject1Var
	ld a,(hl)
	and b
	ld c,$03
	ld l,Enemy.var38
	jr nz,@lowAttackPattern ; Confusing order, this branch could have been 2 operations earlier
	; If the other head is doing one of the attacks 0-2, pick an attack 3-5
	bit 0,(hl)
	jr nz,@highAttackPattern
	; If right head, pick an attack 0-2
	ld e,Enemy.subid
	ld a,(de)
	cp $03
	jr z,@lowAttackPattern
	; If right head is in state $10 or $11 (just came back to main body after floating), pick an attack 0-2
	ld b,h
	ld l,Enemy.var31
	ld h,(hl)
	ld l,Enemy.state
	ld a,(hl)
	cp $10
	ld h,b
	jr nc,@lowAttackPattern
	; If Link is in the left half of the room, pick an attack 0-2, otherwise 3-5
	ldh a,(<hEnemyTargetX)
	cp $78
	jr nc,@highAttackPattern
@lowAttackPattern:
	ld l,Enemy.var38
	set 0,(hl)
	ld c,$00
@highAttackPattern:
	; If Link is in the top half of the room, pick attack 0 or 3
	ldh a,(<hEnemyTargetY)
	cp $58
	ld b,$00
	jr c,@setAttackPattern
	; If Link is near the bottom of the room (Y position $70 or greater), pick attack 2 or 5
	ld b,$02
	sub $70
	cp $40
	jr c,@setAttackPattern
	; Otherwise, choose randomly between attack 1/4 or 2/5
	call getRandomNumber
	and $01
	inc a
	ld b,a
@setAttackPattern:
	; [var03] = c+b
	ld h,d
	ld l,Enemy.var03
	ld a,c
	add b
	ld (hl),a
	ld l,Enemy.state
	inc (hl)
	inc l
	ld (hl),$00 ; [substate]
	ret

; Handle the current attack pattern
gleeok_head_stateB:
	ld e,Enemy.var03
	ld a,(de)
	ld e,Enemy.substate
	rst_jumpTable
	.dw @attackPattern0
	.dw @attackPattern1
	.dw @attackPattern2
	.dw @attackPattern3
	.dw @attackPattern4
	.dw @attackPattern5

; Shoot a single flame towards Link that explodes into smaller flames
@attackPattern0:
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

; Move to a fixed position below and to the side of the main body
@@substate0:
	ld bc,$3a60
	ld h,d
	ld l,Enemy.subid
	ld a,(hl)
	cp $02
	jr z,+
	ld c,$90
+
	ld l,Enemy.yh
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl) ; [xh]
	ldh (<hFF8E),a
	cp c
	jr nz,+
	ldh a,(<hFF8F)
	cp b
	jr z,++
+
	jp ecom_moveTowardPosition
++
	ld l,e
	inc (hl) ; [substate]
	ret

; Indicate visually that the head is about to fire a projectile
@@substate1:
	ld h,d
	ld l,e
	inc (hl) ; [substate]
	inc l
	ld (hl),30 ; [counter1]
	ld a,$01
	jp enemySetAnimation

; Fire a projectile
@@substate2:
	call ecom_decCounter1
	jr z,+
	ld a,(hl) ; [counter1]
	cp 8
	ret nz
	ld l,Enemy.yh
	ld a,(hl)
	sub $04
	ld (hl),a
	ld b,PART_GLEEOK_FLAME
	jp ecom_spawnProjectile
+
	ld l,Enemy.yh
	ld a,(hl)
	add $04
	ld (hl),a

; Increment state to $0c, and do the same for the other head if it is currently attacking
@finishProjectileAttack:
	; If other head is also in state $0b, move it to state $0c
	ld a,Object.var38
	call objectGetRelatedObject1Var
	res 0,(hl)
	ld e,Enemy.subid
	ld a,(de)
	sub $02
	xor $01
	add Enemy.var30
	ld l,a
	ld h,(hl)
	ld l,Enemy.state
	ld a,(hl)
	cp $0b
	jr nz,+
	inc (hl) ; [state] = $0c
+
	; Go to state $0c
	ld h,d
	ld e,l
	inc (hl) ; [state] = $0c
	ld l,Enemy.subid
	ld a,(hl)
	cp $02
	ret nz
	; For the left head, run state $0c code instantly
	jp gleeok_head_stateC

; Spawn 4 flames surrounding Link
@attackPattern1:
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

; Indicate visually that the head is about to fire a projectile and set up wait timer
@@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]
	ld l,Enemy.counter1
	ld (hl),40
	ld a,$01
	jp enemySetAnimation

; Store Link's current position as the projectile target
@@substate1:
	call ecom_decCounter1
	ret nz
	ld (hl),$41 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	ld l,Enemy.var39
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a ; [var3a]
	ret

; Spawn 4 projectiles surrounding the target position
@@substate2:
	call ecom_decCounter1
	jr z,@finishProjectileAttack
	ld a,(hl) ; [counter1]
	and $0f
	jr z,@spawnProjectile
	cp $08
	ret nz
	ld l,Enemy.yh
	ld a,(hl)
	add $02
	ld (hl),a
	ret

@spawnProjectile:
	ld l,Enemy.yh
	ld a,(hl)
	sub $02
	ld (hl),a
	call getFreePartSlot
	ret nz
	ld (hl),PART_GLEEOK_FLAME ; [Part.id]
	inc l
	inc (hl) ; [Part.subid]
	ld e,Enemy.counter1
	ld a,(de)
	and $30
	swap a
	ld bc,@projectileOffsetsFromTarget
	call addDoubleIndexToBc
	ld e,Enemy.var39
	ld a,(de)
	ld e,a
	ld a,(bc)
	add e
	ld l,Part.yh
	ldi (hl),a
	inc l
	inc bc
	ld e,Enemy.var3a
	ld a,(de)
	ld e,a
	ld a,(bc)
	add e
	ldi (hl),a ; [Part.xh]
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_PUFF
	ld bc,$0800
	jp objectCopyPositionWithOffset

; Projectile position offsets from target position
@projectileOffsetsFromTarget:
	.db $ec $00 ; Top
	.db $00 $ec ; Left
	.db $00 $14 ; Right
	.db $14 $00 ; Bottom

; Fire 2 waves of 3 flames
@attackPattern2:
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

; Indicate visually that the head is about to fire a projectile and set up counters
@@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]
	inc l
	ld (hl),8 ; [counter1]
	inc l
	ld (hl),2 ; [counter2]
	ld a,$01
	jp enemySetAnimation

; Wait until counter1 reaches 0
@@substate1:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [substate]
	ret

; Spawn projectile
@@substate2:
	ld b,PART_GLEEOK_FLAME
	call ecom_spawnProjectile
	ret nz
	ld l,Part.subid
	ld (hl),$02
	call ecom_decCounter2
	jp z,@finishProjectileAttack
	dec l
	ld (hl),20 ; [counter1]
	dec l
	dec (hl) ; [substate]
	ret

; Move to a fixed position, then wait there until the other head finishes a projectile attack
@attackPattern3:
	ld a,(de)
	rst_jumpTable
	.dw @attackPattern0@substate0
	.dw @ret
@ret:
	ret

; Move around until the other head finishes a projectile attack
@attackPattern4:
@attackPattern5:
	call @decrementAngleUpdateWait
	call z,gleeok_updateHeadAngle
	jp objectApplySpeed

@decrementAngleUpdateWait:
	ld h,d
	ld l,Enemy.var31
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret

; Go to state $0d and set up the timer of 2 seconds for it
gleeok_head_stateC:
	ld h,d
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.counter2
	ld (hl),120
	; After attack patterns 0 and 3, reset angle variables since the head went to its default position before
	ld l,Enemy.var03
	ld a,(hl)
	or a
	jr z,+
	cp $03
	jr nz,++
+
	ld l,Enemy.var30
	xor a
	ldi (hl),a
	ld (hl),a ; [var31]
++
	xor a
	jp enemySetAnimation

; Do not attack for 2 seconds, then go back to state $0a
gleeok_head_stateD:
	call ecom_decCounter2
	jr nz,gleeok_head_stateB@attackPattern4
	ld l,e
	ld (hl),$0a ; [state]
	ret

; Head is detached from main body and floating across the room
gleeok_head_stateE:
	ld a,(wFrameCounter)
	rrca
	jr c,+
	call ecom_decCounter1
	jr nz,+
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.speed
	ld (hl),SPEED_100
+
	call objectApplySpeed
	jp ecom_bounceOffScreenBoundary

; Head is floating back to its default position in a straight line
gleeok_head_stateF:
	ld h,d
	ld l,Enemy.subid
	ld a,(hl)
	cp $02
	ld bc,$2476
	jr z,+
	ld c,$7a
+
	ld l,Enemy.yh
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl) ; [xh]
	ldh (<hFF8E),a
	cp c
	jr nz,+
	ldh a,(<hFF8F)
	cp b
	jr z,++
+
	jp ecom_moveTowardPosition
++
	; Attach head to main body again
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_GLEEOK
	ld l,Enemy.speed
	ld (hl),SPEED_80
	ld l,Enemy.counter1
	ld (hl),60
	ld l,Enemy.var30
	xor a
	ldi (hl),a
	ld (hl),a ; [var31]
	ld l,Enemy.subid
	ld a,(hl)
	cp $02
	ld a,$14 ; left head moves down left
	ld b,$02
	jr z,+
	ld a,$0c ; right head moves down right
	ld b,$04
+
	ld l,Enemy.angle
	ld (hl),a
	; Mark head as no longer detached for main body
	ld a,Object.var38
	call objectGetRelatedObject1Var
	ld a,(hl)
	xor b
	ld (hl),a
	ret

; Wait until the other head is not attacking, then go back to state $0a
gleeok_head_state11:
	; If mirror image is in one of the states $0b to $0d (attacking), just move the head around without attacking
	ld e,Enemy.subid
	ld a,(de)
	sub $02
	xor $01
	add Object.var30
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,Enemy.state
	ld a,(hl)
	cp $0e
	jr nc,+
	cp $0a
	jp nz,gleeok_head_stateB@attackPattern4
+
	; Otherwise, go back to state $0a
	ld h,d
	ld (hl),$0a ; [state]
	; For the left head, run state $0a code instantly
	ld l,Enemy.subid
	ld a,(hl)
	cp $02
	ret nz
	jp gleeok_headLeft_stateA

; Right head
gleeok_headRight:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw gleeok_headRight_state8
	.dw gleeok_head_state9
	.dw gleeok_headRight_stateA
	.dw gleeok_head_stateB
	.dw gleeok_head_stateC
	.dw gleeok_head_stateD
	.dw gleeok_head_stateE
	.dw gleeok_head_stateF
	.dw gleeok_head_state10
	.dw gleeok_head_state11

gleeok_headRight_state8:
	ld h,d
	ld l,Enemy.angle
	ld (hl),$0c
	jp gleeok_headLeft_state8@rightHeadEntry

gleeok_headRight_stateA:
	ld b,$02
	jp gleeok_headLeft_stateA@rightHeadEntry

; Neck segments next to heads
gleeok_neckTopLeft:
gleeok_neckTopRight:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw gleeok_neckTop_state8
	.dw gleeok_neckTop_state9
	.dw gleeok_neck_stateA

; Initialize neck-specific properties
gleeok_neckTop_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO
	; Store reference to head on the same side in relatedObj2
	ld e,Enemy.subid
	ld a,(de)
	sub $04
	add Object.var30
	call objectGetRelatedObject1Var
	ld e,Enemy.relatedObj2+1
	ld a,(hl)
	ld (de),a
	dec e
	ld a,Enemy.start
	ld (de),a ; [relatedObj2]

; Update position based on the head on the same side, or turn invisible if head detached
gleeok_neckTop_state9:
	call gleeok_deleteSegmentIfHeadUnloaded
	call gleeok_getHeadVectorDividedBy4
	ret nz

	; [yh] = b*3+$24
	ld e,Enemy.yh
	ld a,b
	add a
	add b
	add $24
	ld (de),a
	ld e,Enemy.subid
	ld a,(de)
	cp $04
	ld b,$76
	jr z,+
	ld b,$7a
+
	; [xh] = c*3+b
	ld a,c
	add a
	add c
	add b
	ld e,Enemy.xh
	ld (de),a
	ret

; Wait for head on same side to connect with main body again
gleeok_neck_stateA:
	call gleeok_deleteSegmentIfHeadUnloaded
	ld e,Enemy.subid
	ld a,(de)
	rrca
	ld bc,$0276
	jr nc,+
	ld bc,$047a
+
	; Return if the head on the same side is detached
	ld a,Object.var38
	call objectGetRelatedObject1Var
	ld a,(hl)
	and b
	ret nz
	; Head is attached, become visible and active again
	ld h,d
	ld l,Enemy.state
	dec (hl)
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.yh
	ld (hl),$24
	ld l,Enemy.xh
	ld (hl),c
	jp objectSetVisible82

; Middle neck segments
gleeok_neckMiddleLeft:
gleeok_neckMiddleRight:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw gleeok_neckMiddle_state8
	.dw gleeok_neckMiddle_state9
	.dw gleeok_neck_stateA

; Initialize neck-specific properties
gleeok_neckMiddle_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO
	; Store reference to head on the same side in relatedObj2
	ld e,Enemy.subid
	ld a,(de)
	sub $06
	add Object.var30
	call objectGetRelatedObject1Var
	ld e,Enemy.relatedObj2+1
	ld a,(hl)
	ld (de),a
	dec e
	ld a,Enemy.start
	ld (de),a ; [relatedObj2]

; Update position based on the head on the same side, or turn invisible if head detached
gleeok_neckMiddle_state9:
	call gleeok_deleteSegmentIfHeadUnloaded
	call gleeok_getHeadVectorDividedBy4
	ret nz

	; [yh] = b*2+$24
	ld e,Enemy.yh
	ld a,b
	add a
	add $24
	ld (de),a
	ld e,Enemy.subid
	ld a,(de)
	cp $06
	ld b,$76
	jr z,+
	ld b,$7a
+
	; [xh] = c*2+b
	ld a,c
	add a
	add b
	ld e,Enemy.xh
	ld (de),a
	ret

; Neck segments next to main body
gleeok_neckBottomLeft:
gleeok_neckBottomRight:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw gleeok_neckBottom_state8
	.dw gleeok_neckBottom_state9
	.dw gleeok_neck_stateA

; Initialize neck-specific properties
gleeok_neckBottom_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO
	; Store reference to head on the same side in relatedObj2
	ld e,Enemy.subid
	ld a,(de)
	sub $08
	add Object.var30
	call objectGetRelatedObject1Var
	ld e,Enemy.relatedObj2+1
	ld a,(hl)
	ld (de),a
	dec e
	ld a,Enemy.start
	ld (de),a ; [relatedObj2]

; Update position based on the head on the same side, or turn invisible if head detached
gleeok_neckBottom_state9:
	call gleeok_deleteSegmentIfHeadUnloaded
	call gleeok_getHeadVectorDividedBy4
	ret nz

	; [yh] = b+$24
	ld e,Enemy.yh
	ld a,b
	add $24
	ld (de),a
	ld e,Enemy.subid
	ld a,(de)
	cp $08
	ld a,$76
	jr z,+
	ld a,$7a
+
	; [xh] = c+a
	add c
	ld e,Enemy.xh
	ld (de),a
	ret

gleeok_initializeBodyPart:
	dec b
	jr z,gleeok_initializeMainBody
	ld c,$76 ; even subid: left of main body
	ld l,Enemy.subid
	bit 0,(hl)
	jr z,+
	ld c,$7a ; odd subid: right of main body
+
	ld l,Enemy.yh
	ld (hl),$24
	ld l,Enemy.xh
	ld (hl),c
	ld l,Enemy.subid
	ld a,(hl)
	cp $04
	ret c
	; Not a head
	ld a,$02
	jp enemySetAnimation

gleeok_initializeMainBody:
	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.collisionRadiusY
	ld (hl),$0c
	inc l
	ld (hl),$0e ; [Enemy.collisionRadiusX]
	ld l,Enemy.yh
	ld (hl),$20
	ld l,Enemy.xh
	ld (hl),$78
	; Make floor under main body solid
	ld hl,wRoomCollisions+$16
	ld a,$0f
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld l,$26
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld a,$03
	call enemySetAnimation
	jp objectSetVisible83

; Called by body segments to delete them when the head on the same side is no longer loaded
gleeok_deleteSegmentIfHeadUnloaded:
	ld a,Object.id
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp ENEMY_GLEEOK
	ret z
	; Break out of Gleeok code
	pop hl
	jp enemyDelete

; Turns the given neck segment invisible and increments its state if the given head is
; in state $0e (floating across the room), otherwise computes the vector from the given
; head's default position to its current position, divided by 4
;
; @param	de	Pointer to a Gleeok neck segment (e irrelevant)
; @param	hl	Pointer to a Gleeok head (l irrelevant)
; @param[out]	zflag	Set if the head is not in state $0e, cleared otherwise
; @param[out]	b	If z is set: y component of the vector
; @param[out]	c	If z is set: x component of the vector
gleeok_getHeadVectorDividedBy4:
	ld l,Enemy.state
	ld a,(hl)
	cp $0e
	jr nz,@computeVector
	; Neck segment goes to state $0a and turns invisible
	ld h,d
	inc (hl) ; [state]
	ld l,Enemy.collisionType
	res 7,(hl)
	ld e,Enemy.visible
	ld a,(de)
	rlca
	ld b,INTERAC_KILLENEMYPUFF
	call c,objectCreateInteractionWithSubid00
	jp objectSetInvisible

@computeVector:
	; b = ([head.yh]-$24)/4
	ld l,Enemy.yh
	ldi a,(hl)
	sub $24
	sra a
	sra a
	ld b,a
	inc l
	ld e,Enemy.subid
	ld a,(de)
	rrca
	ld c,$76
	jr nc,+
	ld c,$7a
+
	; c = ([head.xh]-c)/4
	ld a,(hl) ; [xh]
	sub c
	sra a
	sra a
	ld c,a
	xor a
	ret

; Picks a sequence when needed, then gets the next angle from the sequence
; and sets the dedicated wait timer to 6
gleeok_updateHeadAngle:
	ld e,Enemy.var30
	ld a,(de)
	and $1f
	jr nz,+
	call getRandomNumber
	and $20
	ld (de),a
+
	ld a,(de)
	ld hl,gleeok_headAngleSequences
	rst_addAToHl
	ld e,Enemy.angle
	ld a,(hl)
	ld (de),a
	ld h,d
	ld l,Enemy.var30
	inc (hl)
	inc l
	ld (hl),6 ; [var31]
	ret

; 2 blocks of size $20, a random block is picked and the sequence advances every 6 frames
gleeok_headAngleSequences:
	.db $15 $16 $17 $17 $19 $19 $1a $1b
	.db $05 $06 $07 $07 $09 $09 $0a $0b
	.db $0b $0a $09 $09 $07 $07 $06 $05
	.db $1b $1a $19 $19 $17 $17 $16 $15
	.db $08 $08 $09 $09 $0a $0a $0b $0c
	.db $14 $15 $16 $16 $17 $17 $18 $18
	.db $18 $18 $19 $19 $1a $1a $1b $1c
	.db $04 $05 $06 $06 $07 $07 $08 $08
