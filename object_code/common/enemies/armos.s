; ==================================================================================================
; ENEMY_ARMOS
;
; Variables:
;   subid: If bit 7 is set, it's a real armos; otherwise it's an armos spawner.
;   var31: The initial position of the armos (subid 1 only)
; ==================================================================================================
enemyCode1d:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,armos_dead

	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards

	; ENEMYSTATUS_JUST_HIT

	; For subid $80, if Link touches this position, activate the armos.
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret nz

	ld e,Enemy.subid
	ld a,(de)
	cp $80
	jr nz,@normalStatus

	ld h,d
	ld l,Enemy.state
	ld a,(hl)
	cp $09
	jr nc,@normalStatus
	ld (hl),$09
	ret

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw armos_uninitialized
	.dw armos_state1
	.dw armos_state_stub
	.dw armos_state_switchHook
	.dw armos_state_stub
	.dw armos_state_stub
	.dw armos_state_stub
	.dw armos_state_stub

@normalState:
	res 7,b
	ld a,b
	rst_jumpTable
	.dw armos_subid00
	.dw armos_subid01


armos_uninitialized:
	ld a,b
	bit 7,a
	jr z,@gotoState1

	add a
	ld hl,@oamFlagsAndSpeeds
	rst_addAToHl
	ld e,Enemy.oamFlags
	ldi a,(hl)
	ld (de),a
	dec e
	ld (de),a
	ld a,(hl)
	call ecom_setSpeedAndState8

	; Subid 1 gets more health
	ld l,Enemy.subid
	bit 0,(hl)
	jr z,+
	ld l,Enemy.health
	inc (hl)
+
	; Effectively disable collisions
	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_PODOBOO
	ret

@gotoState1:
	ld a,$01
	ld (de),a
	ret

@oamFlagsAndSpeeds:
	.db $05, SPEED_80 ; subid 0
	.db $04, SPEED_c0 ; subid 1


; For subid where bit 7 isn't set; spawn armos at all positions where their tiles are.
; (Enemy.yh currently contains the tile to replace, Enemy.xh is the new tile it becomes.)
armos_state1:
	ld e,Enemy.yh
	ld a,(de)
	ld b,a
	ld hl,wRoomLayout
	ld c,LARGE_ROOM_HEIGHT<<4
--
	ld a,(hl)
	cp b
	call z,armos_spawnArmosAtPosition
	inc l
	dec c
	jr nz,--

	call armos_clearKilledArmosBuffer
	call decNumEnemies
	jp enemyDelete


armos_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw @substate3


@substate1:
@substate2:
	ret

@substate3:
	ld b,$0b
	jp ecom_fallToGroundAndSetState


armos_state_stub:
	ret


armos_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw armos_subid00_state8
	.dw armos_state9
	.dw armos_subid00_stateA
	.dw armos_subid00_stateB
	.dw armos_subid00_stateC

; Waiting for Link to touch the statue (or for "$cca2" trigger?)
armos_subid00_state8:
	ld a,(wcca2)
	or a
	ret z
	ld a,$09
	ld (de),a
	ret


; The statue was just activated
armos_state9:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0a
	ld l,Enemy.counter1
	ld (hl),60
	ld l,Enemy.yh
	inc (hl)
	inc (hl)
	jp objectSetVisible82


; Flickering until it starts moving
armos_subid00_stateA:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld a,ENEMYCOLLISION_ACTIVE_RED_ARMOS

;;
; @param	a	EnemyCollisionMode
armos_beginMoving:
	ld l,e
	inc (hl) ; [state] = $0b

	; Enable normal collisions
	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_ARMOS

	inc l
	ldi (hl),a ; Set enemyCollisionMode

	; Set collisionRadiusY/X
	ld a,$06
	ldi (hl),a
	ld (hl),a

	call armos_replaceTileUnderSelf
	jp objectSetVisiblec2


; Choose a direction to move
armos_subid00_stateB:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0c

	ld l,Enemy.counter1
	ld (hl),61
	call ecom_setRandomCardinalAngle


; Moving in some direction for [counter1] frames
armos_subid00_stateC:
	call ecom_decCounter1
	call nz,ecom_applyVelocityForTopDownEnemyNoHoles
	jr nz,++
	ld e,Enemy.state
	ld a,$0b
	ld (de),a
++
	jp enemyAnimate


armos_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw armos_subid01_state8
	.dw armos_state9
	.dw armos_subid01_stateA
	.dw armos_subid02_stateB
	.dw armos_subid03_stateC


; Waiting for Link to approach the statue
armos_subid01_state8:
	call armos_subid00_state8
	ret nz

	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	add $18
	cp $31
	ret nc

	ld b,(hl)
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $18
	cp $31
	ret nc

	; Link has gotten close enough; activate the armos.
	ld a,(hl)
	and $f0
	swap a
	ld c,a
	ld a,b
	and $f0
	or c
	ld l,Enemy.var31
	ld (hl),a

	ld l,e
	inc (hl) ; [state] = 9
	ret


; Flickering until it starts moving
armos_subid01_stateA:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld a,ENEMYCOLLISION_ACTIVE_BLUE_ARMOS
	jp armos_beginMoving


; Choose random new direction & amount of time to move in that direction
armos_subid02_stateB:
	ld a,$0c
	ld (de),a ; [state] = $0c

	; Get counter1
	ldbc $03,$03
	call ecom_randomBitwiseAndBCE
	ld a,b
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a

	; 1 in 4 chance of moving directly toward Link
	ld a,c
	or a
	jp z,ecom_updateCardinalAngleTowardTarget
	jp ecom_setRandomCardinalAngle

@counter1Vals:
	.db 30, 45, 60, 75


; Moving in some direction for [counter1] frames
armos_subid03_stateC:
	call ecom_decCounter1
	jr z,++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr z,++
	jp enemyAnimate
++
	ld e,Enemy.state
	ld a,$0b
	ld (de),a
	ret

;;
; @param	l	Position to spawn at
armos_spawnArmosAtPosition:
	push bc
	push hl
	ld c,l

	ld b,ENEMY_ARMOS
	call ecom_spawnEnemyWithSubid01
	jr nz,@ret

	ld e,l
	ld a,(de)
	set 7,a
	ld (hl),a ; [child.subid] = [this.subid]|$80

	; [child.var30] = [this.xh] = tile to replace underneath new armos
	ld e,Enemy.xh
	ld l,Enemy.var30
	ld a,(de)
	ld (hl),a

	; Take short-form position in 'c', write to child's position
	ld l,e
	ld a,c
	and $0f
	swap a
	add $08
	ldd (hl),a
	dec l
	ld a,c
	and $f0
	add $06
	ld (hl),a
@ret:
	pop hl
	pop bc
	ret

;;
armos_dead:
	ld e,Enemy.subid
	ld a,(de)
	rrca
	jp nc,enemyDie

	; Subid 1 only: record the initial position of the armos that was killed.
	ld e,Enemy.var31
	ld a,(de)
	ld b,a
	ld hl,wTmpcfc0.armosStatue.killedArmosPositions-1
--
	inc l
	ld a,(hl)
	or a
	jr nz,--
	ld (hl),b
	jp enemyDie

;;
armos_clearKilledArmosBuffer:
	ld hl,wTmpcfc0.armosStatue.killedArmosPositions
	xor a
	ld b,$04
--
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	dec b
	jr nz,--
	ret

;;
; Replace the tile underneath the armos with [var30].
armos_replaceTileUnderSelf:
	call objectGetTileAtPosition
	ld c,l
	ld e,Enemy.var30
	ld a,(de)
	jp setTile
