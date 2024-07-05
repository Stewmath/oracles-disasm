; ==================================================================================================
; ENEMY_MOLDORM
;
; Variables for head (subid 1):
;   var30: Tail 1 object index
;   var31: Tail 2 object index
;   var32: Animation index
;   var33: Angular speed (added to angle)
;
; Variables for tail (subids 2-3):
;   relatedObj1: Object to follow (either the head or the tail in front)
;   var30: Index for offset buffer
;   var31/var32: Parent object's position last frame
;   var33-var3b: Offset buffer. Stores the parent's movement offsets for up to 8 frames.
; ==================================================================================================
enemyCode4f:
	call moldorm_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jr nz,@knockback

	; ENEMYSTATUS_JUST_HIT
	; Only apply this to the head (subid 1)
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jr nz,@normalStatus

	; [tail1.invincibilityCounter] = [this.invincibilityCounter]
	ld e,Enemy.invincibilityCounter
	ld l,e
	ld a,(de)
	ld b,a
	ld e,Enemy.var30
	ld a,(de)
	ld h,a
	ld (hl),b

	; [tail2.invincibilityCounter] = [this.invincibilityCounter]
	inc e
	ld a,(de)
	ld h,a
	ld (hl),b
	ret

@dead:
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp nz,moldorm_tail_delete

	; Following code is for moldorm head only.

	; BUG: The following code is supposed to kill the moldorm's tails. However, in the JP/US
	; versions, it fails to specify the "l" parameter which would tell it which object type it's
	; supposed to kill. Therefore, the type of object that gets killed will depend on what the
	; value of the "l" register happens to be here!
	;
	; The value of the "l" register depends on the address of "enemyConveyorTilesTable"
	; (specifically which sub-table it read depending on the collision types). In the JP/US
	; versions this always ends up being in the range between C0-FF, meaning it will always
	; end up trying to kill a "part" object instead of an enemy object.
	;
	; It can result in stuff like this happening:
	; https://clips.twitch.tv/DepressedSmilingChoughBatChest-7PttcCvmsts5H_EU
	;
	; Anyway, this code is mostly unnecessary because moldorm tails will delete themselves if
	; their parent goes missing. It could still prevent an edge-case where a moldorm tail could
	; get attached to another enemy that spawned in during the exact moment where a moldorm
	; died; but this is a purely theoretical scenario (and could only occur if the enemy was
	; spawned by another enemy ie. a red zol, positioned between the moldorm head and tail in
	; memory).
	ld e,Enemy.var30
	ld a,(de)
	ld h,a
.ifdef ENABLE_EU_BUGFIXES
	ld l,e
.endif
	call ecom_killObjectH
	inc e
	ld a,(de)
	ld h,a
	call ecom_killObjectH

.ifdef ROM_SEASONS
	; moldorm guarding jewel
	ld a,(wActiveRoom)
	cp <ROOM_SEASONS_0f4
	jr nz,+
	ld a,(wActiveGroup)
	or a
	jr nz,+
	inc a
	ld ($cfc0),a
+
.endif
	jp enemyDie

@knockback:
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jr nz,@normalStatus
	jp ecom_updateKnockbackAndCheckHazards

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw moldorm_state_uninitialized
	.dw moldorm_state1
	.dw moldorm_state_stub
	.dw moldorm_state_stub
	.dw moldorm_state_stub
	.dw moldorm_state_stub
	.dw moldorm_state_stub
	.dw moldorm_state_stub

@normalState:
	dec b
	ld a,b
	rst_jumpTable
	.dw moldorm_head
	.dw moldorm_tail
	.dw moldorm_tail


moldorm_state_uninitialized:
	ld a,b
	or a
	jr nz,@notSpawner

@spawner:
	inc a
	ld (de),a ; [state] = 1
	jr moldorm_state1

@notSpawner:
	call ecom_setSpeedAndState8AndVisible
	ld a,b
	dec a
	ret z
	add $07
	jp enemySetAnimation


; Spawner; spawn the head and tails, then delete self.
moldorm_state1:
	ld b,$03
	call checkBEnemySlotsAvailable
	jp nz,objectSetVisible82

	; Spawn head
	ld b,ENEMY_MOLDORM
	call ecom_spawnUncountedEnemyWithSubid01

	; Spawn tail 1
	ld c,h
	push hl
	call ecom_spawnEnemyWithSubid01
	inc (hl) ; [subid] = 2
	call moldorm_tail_setRelatedObj1AndCopyPosition ; Follows head

	; Spawn tail 2
	ld c,h
	call ecom_spawnEnemyWithSubid01
	inc (hl)
	inc (hl) ; [subid] = 3
	call moldorm_tail_setRelatedObj1AndCopyPosition ; Follows tail1

	; [head.var30] = tail1
	ld b,h
	pop hl
	ld l,Enemy.var30
	ld (hl),c

	; [head.var31] = tail2
	inc l
	ld (hl),b

	; [head.enabled] = [this.enabled] (copy spawned index value)
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	call objectCopyPosition
	jp enemyDelete


moldorm_state_stub:
	ret


; Subid 1
moldorm_head:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$08

	ld l,Enemy.speed
	ld (hl),SPEED_100

	; Angular speed
	ld l,Enemy.var33
	ld (hl),$02

	call ecom_setRandomAngle
	jp moldorm_head_updateAnimationFromAngle


; Main state for head
@state9:
	call ecom_decCounter1
	jr nz,@applySpeed

	ld (hl),$08 ; [counter1]

	; Angle is updated every 8 frames.
	ld l,Enemy.var33
	ld e,Enemy.angle
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a
	call moldorm_head_updateAnimationFromAngle

	; 1 in 16 chance of inverting rotation every 8 frames
	call getRandomNumber_noPreserveVars
	and $0f
	jr nz,@applySpeed
	ld e,Enemy.var33
	ld a,(de)
	cpl
	inc a
	ld (de),a

@applySpeed:
	call ecom_bounceOffWallsAndHoles
	call nz,moldorm_head_updateAnimationFromAngle
	jp objectApplySpeed


moldorm_tail:
	ld e,Enemy.state
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	res 7,(hl)

	; Copy parent's current position into var31/var32
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.yh
	ld e,Enemy.var31
	ldi a,(hl)
	ld (de),a
	inc e
	inc l
	ld a,(hl)
	ld (de),a

	jp moldorm_tail_clearOffsetBuffer


; Main state for tail
@state9:
	; Check if parent deleted
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr z,moldorm_tail_delete

	; Get distance between parent's last and current Y position in high nibble of 'b'.
	; (Add 8 so it's positive.)
	ld l,Enemy.yh
	ld e,Enemy.var31
	ld a,(de)
	ld b,a
	ldi a,(hl)
	sub b
	add $08
	swap a
	ld b,a

	; Get distance between parent's last and current X position in low nibble of 'b'.
	inc e
	inc l
	ld a,(de)
	ld c,a
	ld a,(hl)
	sub c
	add $08
	or b
	ld b,a

	; Copy parent's Y/X to var31/var32
	ldd a,(hl)
	ld (de),a
	dec e
	dec l
	ld a,(hl)
	ld (de),a

	; Add the calculated position difference to the offset buffer starting at var33
	ld e,Enemy.var30
	ld a,(de)
	add Enemy.var33
	ld e,a
	ld a,b
	ld (de),a
	ld h,d
	ld l,Enemy.yh

	; Offset buffer index ++
	ld e,Enemy.var30
	ld a,(de)
	inc a
	and $07
	ld (de),a

	; Read next byte in offset buffer (value from 8 frames ago) to get the value to
	; add to our current position.
	add Enemy.var33
	ld e,a
	ld a,(de)
	ld b,a
	and $f0
	swap a
	sub $08
	add (hl) ; [yh]
	ldi (hl),a
	inc l
	ld a,b
	and $0f
	sub $08
	add (hl) ; [xh]
	ld (hl),a
	ret

;;
moldorm_tail_delete:
	call decNumEnemies
	jp enemyDelete


;;
; @param	h	Object to follow (either the head or the tail in front)
moldorm_tail_setRelatedObj1AndCopyPosition:
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c
	jp objectCopyPosition


;;
moldorm_head_updateAnimationFromAngle:
	ld e,Enemy.angle
	ld a,(de)
	add $02
	and $1c
	rrca
	rrca
	ld h,d
	ld l,Enemy.var32
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
moldorm_tail_clearOffsetBuffer:
	ld h,d
	ld l,Enemy.var33
	ld b,$02
	ld a,$88
--
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	dec b
	jr nz,--
	ret


;;
moldorm_checkHazards:
	ld b,a
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jr z,@checkHazards

	; Tails only; check if parent fell into a hazard
	ld a,Object.var3f
	call objectGetRelatedObject1Var
	ld a,(hl)
	and $07
	jr nz,@checkHazards
	ld a,b
	or a
	ret

@checkHazards:
	ld a,b
	jp ecom_checkHazardsNoAnimationForHoles
