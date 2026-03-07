; ==================================================================================================
; ENEMY_MAGUNESU
; ==================================================================================================
enemyCode3c:
	jr z,+
	sub $03
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockback
	ret
+
	call magunesuFunc_0d_6ccd
	call magunesuFunc_0d_6ce6
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
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
	.dw @stateE

@state0:
	call magunesuFunc_0d_6d06
	ld a,$14
	call ecom_setSpeedAndState8AndVisible
	jr @magunesuFunc_0d_6c54

@state_stub:
	ret

@state8:
	call magunesuFunc_0d_6d18
	call ecom_decCounter1
	jp nz,ecom_applyVelocityForTopDownEnemy
	ld l,Enemy.state
	inc (hl)
	ld a,$01
	jp enemySetAnimation

@state9:
	call enemyAnimate
	ld e,$a1
	ld a,(de)
	or a
	ret z
	dec a
	ld a,$05
	jp nz,magunesuFunc_0d_6ca9
	ld h,d
	ld l,$83
	ld (hl),$02
	ld l,$9b
	ld a,$02
	ldi (hl),a
	ld (hl),a
	ret

@stateA:
	call magunesuFunc_0d_6cb7
	ret nz
	ld l,e
	inc (hl)
	call magunesuFunc_0d_6d06
	ld a,$03
	jp enemySetAnimation

@stateB:
	call magunesuFunc_0d_6d18
	call ecom_decCounter1
	jp nz,ecom_applyVelocityForTopDownEnemy
	ld l,$84
	inc (hl)
	ld a,$04
	jp enemySetAnimation

@stateC:
	call enemyAnimate
	ld e,$a1
	ld a,(de)
	or a
	ret z
	dec a
	ld a,$02
	jr nz,magunesuFunc_0d_6ca9

@magunesuFunc_0d_6c54:
	ld h,d
	ld l,$83
	ld (hl),$00
	ld l,$9b
	ld a,$01
	ldi (hl),a
	ld (hl),a
	ret

@stateD:
	call magunesuFunc_0d_6cb7
	ret nz
	ld l,e
	ld (hl),$08
	call magunesuFunc_0d_6d06
	xor a
	jp enemySetAnimation

@stateE:
	call ecom_decCounter2
	jr nz,+
	ld l,$90
	ld (hl),$14
	ld l,e
	ld e,$83
	ld a,(de)
	or a
	ld (hl),$08
	ret z
	ld (hl),$0b
	ret
+
	call ecom_applyVelocityForTopDownEnemy
	ret nz
	call objectGetAngleTowardEnemyTarget
	xor $10
	ld h,d
	ld l,$89
	sub (hl)
	and $1f
	bit 4,a
	ld a,$08
	jr z,+
	ld a,$f8
+
	add (hl)
	and $18
	ld (hl),a
	xor a
	call ecom_getTopDownAdjacentWallsBitset
	ret z
	ld e,$89
	ld a,(de)
	xor $10
	ld (de),a
	ret

magunesuFunc_0d_6ca9:
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$86
	ld (hl),$1e
	call enemySetAnimation
	jp ecom_setRandomCardinalAngle

magunesuFunc_0d_6cb7:
	call ecom_decCounter1
	ret z
	ld a,(hl)
	cp $0f
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PART_GOPONGA_PROJECTILE
	ld bc,$0400
	call objectCopyPositionWithOffset
	or d
	ret

magunesuFunc_0d_6ccd:
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,magunesuTable_0d_6cde
	rst_addAToHl
	ld e,$8f
	ld a,(hl)
	ld (de),a
	ret

magunesuTable_0d_6cde:
	.db $fe $fd
	.db $fc $fb
	.db $fa $fb
	.db $fc $fd

magunesuFunc_0d_6ce6:
	ld a,(wMagnetGloveState)
	or a
	ret z
	call magunesuFunc_0d_6cf3
	ld b,$46
	jp ecom_applyGivenVelocity

magunesuFunc_0d_6cf3:
	call objectGetAngleTowardEnemyTarget
	ld c,a
	ld h,d
	ld l,$83
	ld a,(wMagnetGloveState)
	add (hl)
	bit 1,a
	ret nz
	ld a,c
	xor $10
	ld c,a
	ret

magunesuFunc_0d_6d06:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,magunesuTable_0d_6d14
	rst_addAToHl
	ld e,$86
	ld a,(hl)
	ld (de),a
	ret

magunesuTable_0d_6d14:
	.db $3c $78
	.db $78 $b4

magunesuFunc_0d_6d18:
	ld c,$30
	call objectCheckLinkWithinDistance
	ret nc
	pop hl
	ld h,d
	ld l,Enemy.state
	ld (hl),$0e
	ld l,$87
	ld (hl),$2d
	ld l,$90
	ld (hl),$3c
	call objectGetAngleTowardEnemyTarget
	sub $0c
	and $18
	ld e,$89
	ld (de),a
	ret
