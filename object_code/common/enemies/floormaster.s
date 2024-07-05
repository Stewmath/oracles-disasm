; ==================================================================================================
; ENEMY_FLOORMASTER
;
; Variables for subids other than 0:
;   relatedObj1: Reference to spawner object (subid 0)
;   var30: Animation index
;   var31: Index for z-position to use while chasing Link (0-7)
;   var32: Angle relative to Link where floormaster should spawn
;
; Variables for spawner (subid 0):
;   var30: Number of floormaster currently spawned (they delete themselves after
;          disappearing into the ground)
;   var31/var32: Link's position last time a floormaster was spawned. If Link hasn't moved
;                far from here, the floormaster will spawn at a random angle relative to
;                him; otherwise it will spawn in the direction Link is moving.
;   var33: # floormasters to spawn. Children decrement this when they're killed.
;          (High nibble of original Y value.)
;   var34: Subid for child objects (high nibble of original X value, plus one)
; ==================================================================================================
enemyCode35:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackNoSolidity

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret nz

	; Grabbed Link
	ld h,d
	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.zh
	ld (hl),$fb

	call floormaster_updateAngleTowardLink
	add $04
	call enemySetAnimation

	; Move to halfway point between Link and floormaster
	ld h,d
	ld l,Enemy.yh
	ld a,(w1Link.yh)
	sub (hl)
	sra a
	add (hl)
	ld (hl),a

	ld l,Enemy.xh
	ld a,(w1Link.xh)
	sub (hl)
	sra a
	add (hl)
	ld (hl),a
	ret

@dead:
	ld a,Object.var30
	call objectGetRelatedObject1Var
	dec (hl)
	ld l,Enemy.var33
	dec (hl)
	jp enemyDie_uncounted

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw floormaster_state_uninitialized
	.dw floormaster_state1
	.dw floormaster_state_stub
	.dw floormaster_state_stub
	.dw floormaster_state_stub
	.dw floormaster_state_galeSeed
	.dw floormaster_state_stub
	.dw floormaster_state_stub
	.dw floormaster_state8
	.dw floormaster_state9
	.dw floormaster_stateA
	.dw floormaster_stateB
	.dw floormaster_stateC
	.dw floormaster_stateD


floormaster_state_uninitialized:
	ld h,d
	ld l,Enemy.counter1
	ld (hl),60
	ld l,e
	inc (hl) ; [state] = 1

	ld e,Enemy.subid
	ld a,(de)
	or a
	jp z,floormaster_initSpawner

	; Subid 1 only
	ld (hl),$08 ; [state] = 8
	ret


; State 1: only for subid 0 (spawner).
floormaster_state1:
	; Delete self if all floormasters were killed
	ld h,d
	ld l,Enemy.var33
	ld a,(hl)
	or a
	jr z,@delete

	; Return if all available floormasters have spawned already
	ld e,Enemy.var30
	ld a,(de)
	sub (hl)
	ret nc

	; Spawn another floormaster in [counter1] frames
	ld l,Enemy.counter1
	dec (hl)
	ret nz

	ld (hl),$01 ; [counter1]

	; Maximum of 3 on-screen at any given time
	ld l,Enemy.var30
	ld a,(hl)
	cp $03
	ret nc

	ld b,ENEMY_FLOORMASTER
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz

	ld e,Enemy.var34
	ld a,(de)
	ld (hl),a ; [child.subid] = [this.var34]

	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld h,d
	ld l,Enemy.var30
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),$80
	ret

@delete:
	call decNumEnemies
	call markEnemyAsKilledInRoom
	jp enemyDelete


floormaster_state_galeSeed:
	call ecom_galeSeedEffect
	ret c

	ld a,Object.var30
	call objectGetRelatedObject1Var
	dec (hl)
	ld l,Enemy.var33
	dec (hl)
	jp enemyDelete


floormaster_state_stub:
	ret


; States 8+ are for subids 1+ (not spawner objects; actual, physical floormasters).

; Choosing a position to spawn at.
floormaster_state8:
	; If Link is within 8 pixels of his position last time a floormaster was spawned,
	; the floormaster will spawn at a random angle relative to Link. Otherwise, it
	; will spawn in the direction Link is moving.
	call floormaster_checkLinkMoved8PixelsAway
	ld a,$00
	push bc
	call c,getRandomNumber_noPreserveVars
	pop bc

	ld e,a
	ld a,(w1Link.angle)
	add e
	and $1f
	ld e,Enemy.var32
	ld (de),a

	; Try various distances away from Link ($50 to $10)
	ld a,$50
	ldh (<hFF8A),a

@tryDistance:
	ldh a,(<hFF8A)
	sub $10
	jr z,@doneLoop
	ldh (<hFF8A),a

	push bc
	ld e,Enemy.var32
	call objectSetPositionInCircleArc
	pop bc

	; Check that this position candidate is valid.

	; a = abs([w1Link.xh] - [this.xh])
	ld a,(de)
	ld e,a
	ld a,(w1Link.xh)
	sub e
	jr nc,+
	cpl
	inc a
+
	cp $80
	jr nc,@tryDistance

	ld e,Enemy.yh
	ld a,(de)
	cp LARGE_ROOM_HEIGHT<<4
	jr nc,@tryDistance

	; Tile must not be solid
	push bc
	call objectGetTileCollisions
	pop bc
	jr nz,@tryDistance

	; Found a valid position. Go to state 9
	ld h,d
	ld l,Enemy.state
	ld (hl),$09

	ld l,Enemy.counter1
	ld (hl),$20

	call objectGetAngleTowardEnemyTarget
	ld b,a

	; Subid 1 only: angle must be a cardinal direction
	ld e,Enemy.subid
	ld a,(de)
	dec a
	ld a,b
	jr nz,+
	add $04
	and $18
+
	ld e,Enemy.angle
	ld (de),a

	; Decide animation to use
	cp $10
	ld a,$00
	jr nc,+
	inc a
+
	ld e,Enemy.var30
	ld (de),a
	call enemySetAnimation
	call objectSetVisiblec1

@doneLoop:
	; Copy Link's position to spawner.var31/var32
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.var31
	ld a,(w1Link.yh)
	ldi (hl),a
	ld a,(w1Link.xh)
	ld (hl),a
	ret


; Emerging from ground
floormaster_state9:
	ld e,Enemy.animParameter
	ld a,(de)
	dec a
	jp nz,enemyAnimate

	ld e,Enemy.state
	ld a,$0a
	ld (de),a

	ld e,Enemy.var30
	ld a,(de)
	add $02
	jp enemySetAnimation


; Floating in place for [counter1] frames before chasing Link
floormaster_stateA:
	call ecom_decCounter1
	jr z,@beginChasing

	ld a,(hl)
	srl a
	srl a
	ld hl,@zVals
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.zh
	ld (de),a
	ret

@beginChasing:
	ld (hl),$f0 ; [counter1]

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.state
	ld (hl),$0b

	call floormaster_updateAngleTowardLink
	ld b,a

	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.xh
	bit 5,(hl)

	; Certain subids have higher speed?
	ld h,d
	ld l,Enemy.speed
	ld (hl),SPEED_60
	jr z,+
	ld (hl),SPEED_a0
+
	ld a,b
	add $02
	call enemySetAnimation
	jr floormaster_animate

@zVals:
	.db $fb $fc $fd $fd $fe $fe $ff $ff


; Chasing Link
floormaster_stateB:
	call ecom_decCounter1
	jr nz,@stillChasing

	; Time to go back into ground
	ld l,Enemy.zh
	ld (hl),$00
	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,e
	ld (hl),$0d ; [state]

	ld l,Enemy.var30
	ld a,$06
	add (hl)
	jp enemySetAnimation

@stillChasing:
	ld e,Enemy.var30
	ld a,(de)
	ldh (<hFF8D),a

	call floormaster_updateAngleTowardLink
	ld b,a
	ldh a,(<hFF8D)
	cp b
	jr z,++
	ld a,$02
	add b
	call enemySetAnimation
++
	call floormaster_updateZPosition
	call floormaster_getAdjacentWallsBitset
	call ecom_applyVelocityGivenAdjacentWalls

floormaster_animate:
	jp enemyAnimate


; Grabbing Link
floormaster_stateC:
	ld e,Enemy.animParameter
	ld a,(de)
	dec a
	jr z,@makeLinkInvisible
	dec a
	jr z,@setZToZero
	dec a
	jr nz,floormaster_animate

	; [animParameter] == 3
	; Set substate for LINK_STATE_GRABBED_BY_WALLMASTER
	ld a,$02
	ld (w1Link.substate),a
	jp objectSetInvisible

@makeLinkInvisible: ; [animParameter] == 1
	ld (de),a
	ld (w1Link.visible),a

	ld e,Enemy.yh
	ld a,(w1Link.yh)
	ld (de),a
	ld e,Enemy.xh
	ld a,(w1Link.xh)
	ld (de),a
	ret

@setZToZero: ; [animParameter] == 2
	xor a
	ld (de),a
	ld e,Enemy.zh
	ld (de),a
	jr floormaster_animate


; Sinking into ground
floormaster_stateD:
	ld e,Enemy.animParameter
	ld a,(de)
	cp $03
	jr nz,floormaster_animate

	; Tell spawner that there's one less floormaster on-screen before deleting self
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.var30
	dec (hl)

	jp enemyDelete


;;
; @param[out]	a	Value written to var30 (0 if Link is to the left, 1 if right)
floormaster_updateAngleTowardLink:
	call @checkLinkCollisionsEnabled
	ret nc

	call objectGetAngleTowardLink
	ld b,a
	and $0f
	jr nz,++

	; Link is directly above or below the floormaster
	ld e,Enemy.angle
	ld a,b
	ld (de),a
	ld e,Enemy.var30
	ld a,(de)
	ret
++
	ld e,Enemy.subid
	ld a,(de)
	dec a
	ld a,b
	jr nz,@subid0

@subid1:
	; Only move in cardinal directions
	ld e,Enemy.angle
	and $f8
	ld (de),a

	cp $10
	ld a,$00
	jr nc,+
	inc a
+
	ld e,Enemy.var30
	ld (de),a
	ret

@subid0:
	ld e,Enemy.angle
	ld (de),a

	cp $10
	ld a,$00
	jr nc,+
	inc a
+
	ld e,Enemy.var30
	ld (de),a
	ret

;;
; @param[out]	cflag	c if Link's collisions are enabled
@checkLinkCollisionsEnabled:
	ld a,(w1Link.collisionType)
	rlca
	ret c
	ld e,Enemy.var30
	ld a,(de)
	ret


;;
floormaster_updateZPosition:
	ld e,Enemy.counter1
	ld a,(de)
	and $07
	ret nz

	ld e,Enemy.var31
	ld a,(de)
	inc a
	and $07
	ld (de),a
	ld hl,@zVals
	rst_addAToHl
	ld e,Enemy.zh
	ld a,(hl)
	ld (de),a
	ret

@zVals:
	.db $fb $fc $fd $fc $fb $fa $f9 $fa



;;
; Checks whether Link has moved 8 pixels away from his position last time a floormaster
; was spawned.
;
; @param[out]	bc	Link's position
; @param[out]	cflag	c if he's within 8 pixels
floormaster_checkLinkMoved8PixelsAway:
	ld a,Object.var31
	call objectGetRelatedObject1Var
	ld a,(w1Link.yh)
	ld b,a
	sub (hl)
	add $08
	cp $10
	ld a,(w1Link.xh)
	ld c,a
	ret nc

	inc l
	sub (hl) ; [var32]
	add $08
	cp $10
	ret


;;
floormaster_initSpawner:
	ld e,Enemy.yh
	ld a,(de)
	and $f0
	swap a
	ld e,Enemy.var33
	ld (de),a

	ld e,Enemy.xh
	ld a,(de)
	and $f0
	swap a
	inc a
	ld e,Enemy.var34
	ld (de),a
	ret

;;
; Only screen boundaries count as "walls" for floormaster.
floormaster_getAdjacentWallsBitset:
	ld a,$02
	jp ecom_getTopDownAdjacentWallsBitset
