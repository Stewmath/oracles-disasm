; ==================================================================================================
; ENEMY_GIANT_CUCCO
;
; Variables are the same as ENEMY_CUCCO.
; ==================================================================================================
enemyCode3b:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

	ld e,Enemy.var2a
	ld a,(de)
	res 7,a

	; Check if hit by anything other than Link or shield.
	cp ITEMCOLLISION_L1_SWORD
	jr c,@normalStatus

	ld h,d
	ld l,Enemy.var30
	inc (hl)

	; NOTE: The cucco starts with 0 health. It's constantly reset to $40 here. This
	; isn't a problem in Seasons, but in Ages this seems to trigger a bug causing its
	; collisions to get disabled. See enemies.s for details.
	ld l,Enemy.health
	ld (hl),$40

	ld l,Enemy.state
	ld a,(hl)
	cp $0a
	jr nc,@normalStatus
	ld (hl),$0a
	ld l,Enemy.zh
	ld (hl),$00

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw giantCucco_state_uninitialized
	.dw cucco_state_stub
	.dw cucco_state_grabbed
	.dw cucco_state_stub
	.dw cucco_state_stub
	.dw cucco_state_stub
	.dw cucco_state_stub
	.dw cucco_state_stub
	.dw cucco_state8 ; States 8 and 9 same as normal cucco (wandering around)
	.dw cucco_state9
	.dw giantCucco_stateA
	.dw giantCucco_stateB


giantCucco_state_uninitialized:
	ld a,SPEED_c0
	call ecom_setSpeedAndState8
	ld a,$30
	call setScreenShakeCounter
	jp objectSetVisiblec1


; Hit with anything other than Link or shield
giantCucco_stateA:
	ld e,Enemy.var30
	ld a,(de)
	cp $08
	jr c,@runAway

	; Hit at least 8 times
	call ecom_incState

	ld l,Enemy.var32
	ld (hl),$00

	ld a,SND_TELEPORT
	jp playSound

@runAway:
	call ecom_updateCardinalAngleAwayFromTarget
	call cucco_setAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr giantCucco_animate


; Charging toward Link after being hit 8 times
giantCucco_stateB:
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
	call cucco_setAnimationFromAngle
	call objectApplySpeed

giantCucco_animate:
	jp enemyAnimate


;;
cucco_setAnimationFromAngle:
	ld h,d
	ld l,Enemy.angle
	ld a,(hl)
	and $0f
	ret z

	ldd a,(hl)
	and $10
	swap a
	xor $01
	cp (hl) ; hl == direction
	ret z
	ld (hl),a
	jp enemySetAnimation


cucco_zVals:
	.db $00 $ff $ff $fe $fe $fe $fd $fd
	.db $fd $fd $fe $fe $fe $ff $ff $00


;;
cucco_checkSpawnCuccoAttacker:
	ld h,d
	ld l,Enemy.var33
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret nz
+
	; Must have been hit at least 16 times
	ld l,Enemy.var30
	ld a,(hl)
	cp $10
	ret c

	ld b,PART_CUCCO_ATTACKER
	call ecom_spawnProjectile

	ld e,Enemy.var30
	ld a,(de)
	sub $10
	and $1e
	rrca
	ld hl,@var33Vals
	rst_addAToHl
	ld e,Enemy.var33
	ld a,(hl)
	ld (de),a
	ret

@var33Vals:
	.db $1e $1a $18 $16 $14 $12 $10 $0e
	.db $0c


cucco_attacked:
	ld l,Enemy.health
	ld (hl),$40

	ld l,Enemy.state
	ld a,$0a
	cp (hl)
	jr z,++

	; Just starting to run away
	ld (hl),a
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ld l,Enemy.zh
	ld (hl),$00
++
	ld e,Enemy.var2a
	ld a,(de)
	rlca
	ret nc

	; Increment number of times hit
	ld l,Enemy.var30
	bit 5,(hl)
	jr nz,+
	inc (hl)
+
	ld a,SND_CHICKEN
	jp playSound


;;
; Cucco will transform into ENEMY_BABY_CUCCO (if not aggressive) or ENEMY_GIANT_CUCCO
; (if aggressive).
cucco_hitWithMysterySeed:
	ld l,Enemy.collisionType
	res 7,(hl)

	; Check if the cucco been hit 16 or more times
	ld l,Enemy.var30
	ld a,(hl)
	cp $10
	jr c,+
	ld a,ENEMY_GIANT_CUCCO
	jr ++
+
	ld a,ENEMY_BABY_CUCCO
++
	ld e,Enemy.var31
	ld (de),a

	ldbc INTERAC_PUFF,$02
	call objectCreateInteraction
	ret nz

	ld e,Enemy.relatedObj1
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld e,Enemy.state
	ld a,$0b
	ld (de),a

	jp objectSetInvisible


;;
cucco_playChickenSoundEvery32Frames:
	ld h,d
	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	ret nz

	ld l,Enemy.var32
	dec (hl)
	ld a,(hl)
	and $1f
	ret nz
	ld a,SND_CHICKEN
	jp playSound
