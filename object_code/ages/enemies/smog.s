; ==================================================================================================
; ENEMY_SMOG
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
; ==================================================================================================
enemyCode7c:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus
	jp enemyBoss_dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw smog_state_uninitialized
	.dw smog_state_stub
	.dw smog_state_stub
	.dw smog_state_stub
	.dw smog_state_stub
	.dw smog_state_stub
	.dw smog_state_stub
	.dw smog_state_stub
	.dw smog_state8


smog_state_uninitialized:
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
	call enemyBoss_beginBoss

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
	call ecom_decCounter2

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
	call smog_setCounterToFireProjectile
	ld e,Enemy.subid
	ld a,(de)
	and $0f
	ld hl,@subidSpeedTable
	rst_addAToHl
	ld a,(hl)
	jp ecom_setSpeedAndState8AndVisible

@subid5Init:
@subid6Init:
	ld a,ENEMY_SMOG
	ld b,$00
	call enemyBoss_initializeRoom
	call ecom_setSpeedAndState8
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


smog_state_stub:
	ret


smog_state8:
	ld e,Enemy.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw smog_state8_subid0
	.dw smog_state8_subid1
	.dw smog_state8_subid2
	.dw smog_state8_subid3
	.dw smog_state8_subid4
	.dw smog_state8_subid5
	.dw smog_deleteSelf

; Splitting into two?
smog_state8_subid0:
	call retIfTextIsActive
	call enemyAnimate
	call ecom_decCounter2
	ret nz

	call getFreeEnemySlot
	ld (hl),ENEMY_SMOG
	inc l
	ld (hl),$01 ; [child.subid]
	ld bc,$00f0
	call objectCopyPositionWithOffset

	call getFreeEnemySlot
	ld (hl),ENEMY_SMOG
	inc l
	ld (hl),$01 ; [child.subid]
	ld bc,$0010
	call objectCopyPositionWithOffset
	jr smog_deleteSelf

smog_state8_subid1:
	call enemyAnimate
	call ecom_decCounter2
	ret nz

smog_deleteSelf:
	call objectCreatePuff
	call decNumEnemies
	jp enemyDelete


; Small or medium-sized smog
smog_state8_subid2:
smog_state8_subid3:
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
	call ecom_decCounter2
	jp nz,enemyAnimate

	call getThisRoomFlags
	bit ROOMFLAG_BIT_40,a
	jr nz,smog_deleteSelf

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
	call smog_setCounterToFireProjectile
	ld b,PART_SMOG_PROJECTILE
	call ecom_spawnProjectile
	call objectCopyPosition

@doneShootingProjectile:
	call smog_decCounterToFireProjectile
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
	call smog_applySpeed
	call smog_checkHuggingWall
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
	jp smog_applySpeed

@checkHitWall:
	call smog_checkHitWall
	jr nz,@hitWall
	ret

@substate1:
	call smog_applySpeed
	call smog_checkHuggingWall
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
	call smog_checkHitWall
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
	call smog_updateAdjacentWallsBitset
	call smog_checkHitWall
	jr nz,@hitWall

@notHuggingWall:
	ld e,Enemy.substate
	xor a
	ld (de),a
	jp smog_applySpeed


; Large smog (can be attacked)
smog_state8_subid4:
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

	call ecom_updateAngleTowardTarget

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

	jp ecom_incSubstate

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
	jp smog_setCounterToFireProjectile

@parameter1:
	ld b,PART_SMOG_PROJECTILE
	call ecom_spawnProjectile
	ld l,Part.subid
	inc (hl)
	ld bc,$0800
	jp objectCopyPositionWithOffset

@parameter0:
	call smog_decCounterToFireProjectile
	jr z,++
	ld a,$05
	call enemySetAnimation
++
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary
	call ecom_decCounter1
	ret nz

	ld (hl),20
	ld l,Enemy.speed
	ld a,(hl)
	ret

; Stop while Link is shocked
@substate3:
	call ecom_decCounter2
	ret nz
	xor a
	ld (de),a
	ld l,Enemy.collisionType
	set 7,(hl)
	ret


smog_state8_subid5:
	ret


;;
; @param[out]	zflag	nz if hit a wall
smog_checkHitWall:
	ld e,Enemy.direction
	ld a,(de)
	swap a
	rrca
	inc e
	ld (de),a
	jr smog_checkAdjacentWallsBitset

smog_positionOffsets:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

;;
; @param[out]	zflag	nz if hugging a wall
smog_checkHuggingWall:
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
	ld hl,smog_positionOffsets
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
smog_checkAdjacentWallsBitset:
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
smog_applySpeed:
	; Update angle based on direction
	ld e,Enemy.direction
	ld a,(de)
	swap a
	rrca
	inc e
	ld (de),a
	call objectApplySpeed

smog_updateAdjacentWallsBitset:
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
smog_decCounterToFireProjectile:
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
smog_setCounterToFireProjectile:
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
	dbrel @subid2
	dbrel @subid3
	dbrel @subid4

@subid2:
	dbrel @subid2_0
	dbrel @subid2_1
	dbrel @subid2_2
	dbrel @subid2_3
@subid3:
	dbrel @subid3_0
	dbrel @subid3_1
	dbrel @subid3_2
	dbrel @subid3_3
@subid4:
	dbrel @subid4_0
	dbrel @subid4_1
	dbrel @subid4_2
	dbrel @subid4_3

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
