; ==================================================================================================
; ENEMY_GOPONGA_FLOWER
; ==================================================================================================
enemyCode25:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

	ld e,Enemy.health
	ld a,(de)
	or a
	jp z,ecom_updateKnockback

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


@state_uninitialized:
	ld h,d
	ld l,Enemy.counter1
	ld (hl),90
	ld l,Enemy.subid
	ld a,(hl)
	or a
	jr z,++

	ld l,Enemy.oamTileIndexBase
	ld a,(hl)
	add $04
	ld (hl),a
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BIG_GOPONGA_FLOWER
++
	call ecom_setSpeedAndState8
	jp objectSetVisible83


@state_stub:
	ret


; Closed
@state8:
	call ecom_decCounter1
	ret nz
	ld (hl),60
	ld l,e
	inc (hl)
	ld a,$01
	jp enemySetAnimation


; Open, about to shoot a projectile
@state9:
	call ecom_decCounter1
	jr z,@closeFlower

	ld a,(hl)
	cp 40
	ret nz

	ld e,Enemy.subid
	ld a,(de)
	dec a
	call nz,getRandomNumber_noPreserveVars
	and $03
	ret nz
	ld b,PART_GOPONGA_PROJECTILE
	jp ecom_spawnProjectile

@closeFlower:
	ld e,Enemy.subid
	ld a,(de)
	ld bc,@counter1Vals
	call addAToBc
	ld a,(bc)
	ld (hl),a

	ld l,Enemy.state
	dec (hl)

	xor a
	jp enemySetAnimation


@counter1Vals: ; counter1 values per subid
	.db $78 $b4
