; ==================================================================================================
; ENEMY_RIVER_ZORA
; ==================================================================================================
enemyCode08:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

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
	.dw @state_08
	.dw @state_09
	.dw @state_0a
	.dw @state_0b

@state_uninitialized:
	ld a,$09
	ld (de),a
	ret

@state_stub:
	ret


; Waiting under the water until time to resurface
@state_08:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	ret


; Resurfacing in a random position
@state_09:
	call getRandomNumber_noPreserveVars
	cp (SCREEN_WIDTH<<4)-8
	ret nc

	ld c,a
	ldh a,(<hCameraX)
	add c
	ld c,a

	ldh a,(<hCameraY)
	ld b,a
	ldh a,(<hRng2)
	res 7,a
	add b
	ld b,a

	call checkTileAtPositionIsWater
	ret nc

	; Tile is water; spawn here.
	ld c,l
	call objectSetShortPosition
	ld l,Enemy.counter1
	ld (hl),48

	ld l,Enemy.state
	inc (hl) ; [state] = $0a

	xor a
	call enemySetAnimation
	jp objectSetVisible83


; In the process of surfacing.
@state_0a:
	call ecom_decCounter1
	jr nz,@animate

	; Surfaced; enable collisions & set animation.
	ld l,e
	inc (hl)
	ld l,Enemy.collisionType
	set 7,(hl)
	ld a,$01
	jp enemySetAnimation


; Above water, waiting until time to fire projectile.
@state_0b:
	ld h,d
	ld l,Enemy.animParameter
	ld a,(hl)
	inc a
	jr z,@disappear

	dec a
	jr z,@animate

	; Make projectile
	ld (hl),$00
	ld b,PART_ZORA_FIRE
	call ecom_spawnProjectile
	jr nz,@animate
	ld l,Part.subid
	inc (hl)

@animate:
	jp enemyAnimate

@disappear:
	ld a,$08
	ld (de),a ; [state] = 8

	ld l,Enemy.collisionType
	res 7,(hl)

	call getRandomNumber_noPreserveVars
	and $1f
	add $18
	ld e,Enemy.counter1
	ld (de),a

	ld b,INTERAC_SPLASH
	call objectCreateInteractionWithSubid00
	jp objectSetInvisible
