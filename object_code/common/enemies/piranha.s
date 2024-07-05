; ==================================================================================================
; ENEMY_PIRANHA
;
; Variables:
;   zh: Equals 2 when underwater
;   var30: Current animation index
; ==================================================================================================
enemyCode1e:
	jr z,@normalStatus
	sub $03
	jr c,@stunned
	jp z,enemyDie
	dec a
	ret z

	; ENEMYSTATUS_KNOCKBACK

	ld e,Enemy.speed
	ld a,SPEED_200
	ld (de),a
	call fish_getAdjacentWallsBitsetForKnockback

	ld e,Enemy.knockbackAngle
	call ecom_applyVelocityGivenAdjacentWalls

	ld e,Enemy.speed
	ld a,SPEED_c0
	ld (de),a
	ret

@stunned:
	ld e,Enemy.zh
	ld a,(de)
	cp $02
	ret z
	or a
	ret nz
	jp fish_enterWater

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw fish_state_uninitialized
	.dw fish_state_stub
	.dw fish_state_stub
	.dw fish_state_stub
	.dw fish_state_stub
	.dw ecom_blownByGaleSeedState
	.dw fish_state_stub
	.dw fish_state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw fish_subid00
	.dw fish_subid01


fish_state_uninitialized:
	ld a,SPEED_80
	call ecom_setSpeedAndState8
	call objectSetVisible83

	ld l,Enemy.zh
	ld (hl),$02
	ld l,Enemy.angle
	ld (hl),ANGLE_RIGHT

	call fish_setRandomCounter1
	jp fish_updateAnimationFromAngle


fish_state_stub:
	ret


fish_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9


; Moving below water.
@state8:
	ld a,(wScentSeedActive)
	or a
	jr nz,++
	call ecom_decCounter1
	jr z,@leapOutOfWater
++
	call fish_updatePosition
	jp fish_checkReverseAngle

@leapOutOfWater:
	ld l,e
	inc (hl)
	ld l,Enemy.enemyCollisionMode
.ifdef ROM_AGES
	ld (hl),ENEMYCOLLISION_SWITCHHOOK_DAMAGE_ENEMY
.else
	ld (hl),ENEMYCOLLISION_STANDARD_ENEMY
.endif
	ld l,Enemy.zh
	ld (hl),$00

	ld l,Enemy.speedZ
	ld a,<(-$180)
	ldi (hl),a
	ld (hl),>(-$180)

	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ld b,INTERAC_SPLASH
	call objectCreateInteractionWithSubid00
	call objectSetVisiblec1
	ld b,$00
	jp fish_setAnimation


; Leaping outside the water.
@state9:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	jr z,fish_enterWater

	ld l,Enemy.speedZ
	ld a,(hl)
	or a
	jr nz,++
	inc l
	ld a,(hl)
	or a
	jr nz,++
	ld b,$01
	call fish_setAnimation
++
	jp fish_updatePosition


;;
fish_enterWater:
	ld h,d
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO
	ld l,Enemy.zh
	ld (hl),$02

	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.speed
	ld (hl),SPEED_80

	call fish_setRandomCounter1
	ld b,INTERAC_SPLASH
	call objectCreateInteractionWithSubid00
	call objectSetVisible83
	jp fish_updateAnimationFromAngle



fish_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8

@state8:
	ret

;;
; @param	cflag	c if we were able to move
fish_checkReverseAngle:
	ret c
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	ld (de),a

;;
fish_updateAnimationFromAngle:
	ld e,Enemy.angle
	ld a,(de)
	swap a
	rlca
	ld hl,@animations
	rst_addAToHl
	ld a,(hl)
	ld h,d
	ld l,Enemy.var30
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

@animations:
	.db $02 $01 $02 $00

;;
; Sets animation (3 or 5 is added to value passed if we're moving right or left)
;
; @param	b	Value to add to animation index
fish_setAnimation:
	ld e,Enemy.angle
	ld a,(de)
	swap a
	and $01
	ld a,$03
	jr nz,+
	ld a,$05
+
	add b
	ld h,d
	ld l,Enemy.var30
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation


;;
; @param[out]	cflag	c if we were able to move (tile in front of us is traversable)
fish_updatePosition:
	ld e,Enemy.angle
	ld a,(de)
	rrca
	rrca
	ld hl,@directionOffsets
	rst_addAToHl

	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	and $f0
	ld c,a

	inc hl
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	and $f0
	swap a

	or c
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	sub TILEINDEX_PUDDLE
	cp TILEINDEX_FD-TILEINDEX_PUDDLE+1
	ret nc
	call objectApplySpeed
	scf
	ret

@directionOffsets:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

;;
fish_setRandomCounter1:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret

@counter1Vals:
	.db $40 $50 $60 $70

;;
; Gets the "adjacent walls bitset" for the fish; since this swims, water is traversable,
; everything else is not.
;
; This is identical to "waterTektite_getAdjacentWallsBitsetGivenAngle".
;
; @param[out]	hFF8B	Bitset of adjacent walls
fish_getAdjacentWallsBitsetForKnockback:
	ld e,Enemy.knockbackAngle
	ld a,(de)
	call ecom_getAdjacentWallTableOffset

	ld h,d
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	ld hl,ecom_sideviewAdjacentWallOffsetTable
	rst_addAToHl

	ld a,$10
	ldh (<hFF8B),a
	ld d,>wRoomLayout
---
	ldi a,(hl)
	add b
	ld b,a
	and $f0
	ld e,a
	ldi a,(hl)
	add c
	ld c,a
	and $f0
	swap a
	or e
	ld e,a
	ld a,(de)
	sub TILEINDEX_PUDDLE
	cp TILEINDEX_FD-TILEINDEX_PUDDLE+1
	ldh a,(<hFF8B)
	rla
	ldh (<hFF8B),a
	jr nc,---

	xor $0f
	ldh (<hFF8B),a
	ldh a,(<hActiveObject)
	ld d,a
	ret
