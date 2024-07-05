; ==================================================================================================
; ENEMY_PODOBOO_TOWER
;
; Variables:
;   var30: Base y-position. (Actual y-position changes as it emerges from the ground.)
; ==================================================================================================
enemyCode2d:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie_withoutItemDrop

	; ENEMYSTATUS_JUST_HIT or ENEMYSTATUS_KNOCKBACK
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_MYSTERY_SEED
	jp z,enemyDie_uncounted_withoutItemDrop

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD


@state_uninitialized:
	call ecom_setSpeedAndState8
	ld l,Enemy.var3f
	set 5,(hl)

	ld l,Enemy.counter1
	ld (hl),60

	ld l,Enemy.yh
	ld a,(hl)
	ld l,Enemy.var30
	ld (hl),a
	ret


@state_stub:
	ret


; Head is in the ground, flickering, for 60 frames
@state8:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld l,e
	inc (hl) ; [state]++
	ld l,Enemy.collisionType
	set 7,(hl)
	jp objectSetVisible82


; Rising up out of the ground
@state9:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z

	ld b,a
	call @updateCollisionRadiiAndYPosition
	ld a,b
	cp $0f
	ret nz

	; Fully emerged
	ld h,d
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),150
	inc l
	ld (hl),180 ; [counter2]


; Fully emerged from ground, firing at Link until counter2 reaches 0
@stateA:
	call @decCounter2Every4Frames
	jr nz,++
	ld l,e
	inc (hl) ; [state]++
	ld a,$01
	jp enemySetAnimation
++
	; Randomly fire projectile when [counter1] reaches 0
	call ecom_decCounter1
	jr nz,@animate

	ld (hl),150

	call getRandomNumber_noPreserveVars
	cp $b4
	jr nc,@animate

	ld b,PART_GOPONGA_PROJECTILE
	call ecom_spawnProjectile
@animate:
	jp enemyAnimate


; Moving back into the ground
@stateB:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z

	bit 7,a
	jr z,@updateCollisionRadiiAndYPosition

	; Head reached the ground
	call ecom_incState
	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.counter1
	ld (hl),60
	ret


; Head is in the ground, flickering, for 60 frames.
@stateC:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),180
	jp objectSetInvisible


; Waiting underground for [counter1] frames.
@stateD:
	call ecom_decCounter1
	ret nz
	ld (hl),60

	ld l,e
	ld (hl),$08 ; [state]

	xor a
	jp enemySetAnimation

;;
; Updates the podoboo tower's collision radius and y-position while it's emerging from the
; ground.
;
; @param	a	Index of data to read (multiple of 3)
@updateCollisionRadiiAndYPosition:
	sub $03
	ld hl,@data
	rst_addAToHl
	ld e,Enemy.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	ld e,Enemy.var30
	ld a,(de)
	add (hl)
	ld e,Enemy.yh
	ld (de),a

	ld e,Enemy.animParameter
	xor a
	ld (de),a
	ret

; b0: collisionRadiusY
; b1: collisionRadiusX
; b2: Offset for y-position
@data:
	.db $06 $04 $00
	.db $08 $04 $f9
	.db $0b $04 $f7
	.db $0f $04 $f4
	.db $12 $04 $f2

;;
@decCounter2Every4Frames:
	ld a,(wFrameCounter)
	and $03
	ret nz
	jp ecom_decCounter2
