; ==================================================================================================
; ENEMY_WALLMASTER
;
; Variables:
;   relatedObj1: For actual wallmaster (subid 1): reference to spawner.
;   relatedObj2: For spawner (subid 0): reference to actual wallmaster.
;   var30: Nonzero if collided with Link (currently warping him out)
; ==================================================================================================
enemyCode28:
	jr z,@normalStatus
	sub $03
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockback

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret nz

	; Link just touched the hand. If not experiencing knockback, begin warping Link
	; out.
	ld e,Enemy.knockbackCounter
	ld a,(de)
	or a
	ret nz

	ld h,d
	ld l,Enemy.var30
	ld (hl),$01

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.yh
	ldi a,(hl)
	ld (w1Link.yh),a
	inc l
	ld a,(hl)
	ld (w1Link.xh),a
	ret

@dead:
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	or a
	jr z,++
	ld h,a
	ld l,Enemy.relatedObj2+1
	ld (hl),$00
	ld l,Enemy.yh
	dec (hl)
++
	jp enemyDie_uncounted


@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw wallmaster_state_uninitialized
	.dw wallmaster_state1
	.dw wallmaster_state_stub
	.dw wallmaster_state_stub
	.dw wallmaster_state_stub
	.dw wallmaster_state_galeSeed
	.dw wallmaster_state_stub
	.dw wallmaster_state_stub
	.dw wallmaster_state8
	.dw wallmaster_state9
	.dw wallmaster_stateA
	.dw wallmaster_stateB
	.dw wallmaster_stateC
	.dw wallmaster_stateD


wallmaster_state_uninitialized:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jp nz,ecom_setSpeedAndState8

	ld h,d
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),180

	ld l,Enemy.relatedObj2
	ld (hl),Enemy.start
	ret


; Subid 0 (wallmaster spawner) stays in this state indefinitely; spawns a wallmaster every
; 2 seconds.
wallmaster_state1:
	; "yh" acts as the number of wallmasters remaining to spawn, for the spawner.
	ld e,Enemy.yh
	ld a,(de)
	or a
	jr z,@delete

	ld e,Enemy.relatedObj2+1
	ld a,(de)
	or a
	ret nz

	call ecom_decCounter1
	ret nz

	ld (hl),120

	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	call getTileCollisionsAtPosition
	ret nz

	push bc
	ld b,ENEMY_WALLMASTER
	call ecom_spawnUncountedEnemyWithSubid01
	pop bc
	ret nz
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld e,Enemy.relatedObj2+1
	ld a,h
	ld (de),a
	ret

@delete:
	call decNumEnemies
	call markEnemyAsKilledInRoom
	jp enemyDelete


wallmaster_state_galeSeed:
	call ecom_galeSeedEffect
	ret c

	; Tell spawner that this wallmaster is dead
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	or a
	jr z,++
	ld h,a
	ld l,Enemy.relatedObj2+1
	ld (hl),$00
++
	jp enemyDelete


wallmaster_state_stub:
	ret


; Spawning at Link's position, above the screen
wallmaster_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]++

	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_FLOORMASTER

	; Copy Link's position, set high Z position
	ld l,Enemy.zh
	ld (hl),$a0
	ld l,Enemy.yh
	ld a,(w1Link.yh)
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	ld (hl),a

	ld a,SND_FALLINHOLE
	call playSound
	jp objectSetVisiblec1


; Falling to ground
wallmaster_state9:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	jr z,@hitGround

	call wallmaster_flickerVisibilityIfHighUp

	; Chechk for collision with Link
	ld e,Enemy.var30
	ld a,(de)
	or a
	ret z
	ld e,Enemy.zh
	ld a,(de)
	ld (w1Link.zh),a
	ret

@hitGround:
	ld l,Enemy.counter1
	ld (hl),30
	ld l,Enemy.state
	inc (hl)
	ret


; Waiting on ground for [counter1] frames before moving back up
wallmaster_stateA:
	call ecom_decCounter1
	jr nz,++
	ld l,e
	inc (hl) ; [state]++
	ret
++
	ld a,(hl)
	cp 20 ; [counter1] == 20?
	jr c,++
	ret nz

	; Close hand when [counter1] == 20
	ld a,$01
	jp enemySetAnimation
++
	dec a
	jr nz,++

	; Set collisionType when [counter1] == 1?
	ld l,Enemy.collisionType
	ld a,(hl)
	and $80
	or ENEMY_WALLMASTER
	ld (hl),a
++
	ld l,Enemy.var30
	bit 0,(hl)
	ret z
	xor a
	ld (w1Link.visible),a
	ret


; Moving back up
wallmaster_stateB:
	call wallmaster_flickerVisibilityIfHighUp
	ld h,d
	ld l,Enemy.zh
	dec (hl)
	dec (hl)
	ld a,(hl)
	cp $a0
	ret nc

	; Moved high enough
	call objectSetInvisible
	ld l,Enemy.var30
	bit 0,(hl)
	jr z,++

	; We just pulled Link out, go to state $0d
	ld l,Enemy.state
	ld (hl),$0d
	ret
++
	ld l,Enemy.state
	inc (hl) ; [state] = $0c
	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.counter1
	ld (hl),120
	ret


; Waiting off-screen until time to attack again
wallmaster_stateC:
	call ecom_decCounter1
	ret nz

	ld l,e
	ld (hl),$08 ; [state] = 8
	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a
	jp enemySetAnimation


; Just dragged Link off-screen
wallmaster_stateD:
	; Go to substate 2 in LINK_STATE_GRABBED_BY_WALLMASTER.
	ld a,$02
	ld (w1Link.substate),a
	ret


;;
; Flickers visibility if very high up (zh < $b8)
wallmaster_flickerVisibilityIfHighUp:
	ld e,Enemy.zh
	ld a,(de)
	or a
	ret z
	cp $b8
	jp c,ecom_flickerVisibility
	cp $bc
	ret nc
	jp objectSetVisiblec1
