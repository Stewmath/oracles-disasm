; ==================================================================================================
; ENEMY_HEAD_THWOMP
;
; Variables:
;   direction: Current animation. Even numbers are face colors; odd numbers are
;              transitions.
;   var30: "Spin counter" used when bomb is thrown into head
;   var31: Which head the thwomp will settle on after throwing bomb in?
;   var32: Bit 0 triggers the effect of a bomb being thrown into head thwomp.
;   var33: Determines the initial angle of the circular projectiles' initial angle
;   var34: Counter which determines when head thwomp starts shooting fireballs / bombs
; ==================================================================================================
enemyCode79:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyBoss_dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw headThwomp_state_uninitialized
	.dw headThwomp_state_stub
	.dw headThwomp_state_stub
	.dw headThwomp_state_stub
	.dw headThwomp_state_stub
	.dw headThwomp_state_stub
	.dw headThwomp_state_stub
	.dw headThwomp_state_stub
	.dw headThwomp_state8
	.dw headThwomp_state9
	.dw headThwomp_stateA
	.dw headThwomp_stateB
	.dw headThwomp_stateC
	.dw headThwomp_stateD
	.dw headThwomp_stateE
	.dw headThwomp_stateF
	.dw headThwomp_state10
	.dw headThwomp_state11


headThwomp_state_uninitialized:
	ld a,ENEMY_HEAD_THWOMP
	ld b,PALH_81
	call enemyBoss_initializeRoom

	call ecom_setSpeedAndState8
	ld l,Enemy.counter1
	ld (hl),18

	call headThwomp_setSolidTilesAroundSelf
	jp objectSetVisible80


headThwomp_state_stub:
	ret


; Waiting for Link to move up for fight to start
headThwomp_state8:
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

	call ecom_incState

	ld l,Enemy.var34
	ld (hl),$f0

	call enemyBoss_beginBoss


; Spinning normally
headThwomp_state9:
	call headThwomp_checkBombThrownIntoHead
	ret nz

	call headThwomp_checkShootProjectile

	; Update rotation
	call ecom_decCounter1
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
headThwomp_stateA:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl) ; [state]
	inc l
	ld (hl),$00 ; [substate]
	ret


; Spinning after bomb was thrown into head
headThwomp_stateB:
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
	call ecom_decCounter1
	ld b,$08
	jp nz,headThwomp_rotate

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
	call ecom_decCounter1
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
	jp headThwomp_rotate

@startSlowestSpinning:
	ld l,Enemy.counter1
	ld (hl),$01
	inc l
	ld (hl),$06 ; [counter2]
	ld l,e
	inc (hl) ; [substate]

; Slowest spinning; will stop when it reaches the target head
@substate3:
	call ecom_decCounter1
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
	jp nz,headThwomp_rotate

	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),$10
	ret


; Just reached the target head color
headThwomp_stateC:
	call ecom_decCounter1
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
headThwomp_stateD:
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
	call headThwomp_checkBombThrownIntoHead
	ret nz

	call ecom_decCounter1
	jr z,@resumeSpinning

	ld a,(hl)
	cp 210
	call nc,enemyAnimate

	ld e,$c6
	ld a,(hl)
	and $1f
	ret nz
	ld b,PART_HEAD_THWOMP_FIREBALL
	jp ecom_spawnProjectile

@resumeSpinning:
	ld l,Enemy.state
	ld (hl),$11
	ld l,Enemy.counter1
	ld (hl),$01
	ret


; Blue face (fires circular projectiles)
headThwomp_stateE:
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
	call headThwomp_checkBombThrownIntoHead
	ret nz
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld (hl),$08 ; [counter1]
	ld l,Enemy.substate
	inc (hl)

	ld hl,wRoomCollisions+$47
	ld (hl),$03

	call getFreePartSlot
	jr nz,++
	ld (hl),PART_HEAD_THWOMP_CIRCULAR_PROJECTILE
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
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld (hl),30 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	ret

; Cooldown after firing; checks whether to fire again or return to normal state
@substate3:
	call ecom_decCounter1
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
headThwomp_stateF:
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
	jp headThwomp_unsetSolidTilesAroundSelf

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
	call ecom_decCounter1
	jr z,@beginMovingUp

	ld a,(hl) ; [counter1]
	cp 30
	ret c

	; Spawn falling rocks every 16 frames
	and $0f
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PART_3b
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
	jp headThwomp_setSolidTilesAroundSelf


; Red face (takes damage)
headThwomp_state10:
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
	call headThwomp_unsetSolidTilesAroundSelf
	ld a,TREE_GFXH_01
	ld (wLoadedTreeGfxIndex),a
++
	ld e,Enemy.health
	ld a,(de)
	inc a
	call nz,headThwomp_dropHeart

	ld a,$10
	call enemySetAnimation
	ld a,SND_BOSS_DAMAGE
	jp playSound

@substate1:
	call ecom_decCounter1
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
	jp headThwomp_stateF@poundGround

@resumeSpinning:
	ld l,Enemy.state
	ld (hl),$11

	ld l,Enemy.counter1
	ld (hl),$10

	ld hl,wRoomCollisions+$47
	ld (hl),$00

	ld a,$0e
	jp enemySetAnimation


headThwomp_state11:
	call ecom_decCounter1
	jp nz,enemyAnimate

	inc (hl) ; [counter1]
	ld l,e
	ld (hl),$09 ; [state]

	ld l,Enemy.var34
	ld (hl),$f0
	ret


;;
headThwomp_setSolidTilesAroundSelf:
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
headThwomp_unsetSolidTilesAroundSelf:
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
headThwomp_rotate:
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
headThwomp_checkBombThrownIntoHead:
	ldhl FIRST_DYNAMIC_ITEM_INDEX,Item.start
@itemLoop:
	ld l,Item.id
	ld a,(hl)
	cp ITEM_BOMB
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
	call ecom_decCounter1
	ret nz

	ld b,$00
	call headThwomp_rotate
	jr @triggerBombEffect

;;
headThwomp_dropHeart:
	call getFreePartSlot
	ret nz
	ld (hl),PART_ITEM_DROP
	inc l
	ld (hl),ITEM_DROP_HEART
	ld bc,$1400
	jp objectCopyPositionWithOffset

;;
headThwomp_checkShootProjectile:
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

	ld b,PART_HEAD_THWOMP_FIREBALL
	jp ecom_spawnProjectile

@dropBomb:
	ld b,$02
	call checkBPartSlotsAvailable
	ret nz

	; Spawn bomb drop
	call getFreePartSlot
	ld (hl),PART_ITEM_DROP
	inc l
	ld (hl),ITEM_DROP_BOMBS
	call objectCopyPosition

	; Spawn bomb drop "physics" object?
	ld b,h
	call getFreePartSlot
	ld (hl),PART_HEAD_THWOMP_BOMB_DROPPER

	ld l,Part.relatedObj1
	ld a,Part.start
	ldi (hl),a
	ld (hl),b

	jp objectCopyPosition
