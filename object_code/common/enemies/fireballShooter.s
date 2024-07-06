; ==================================================================================================
; ENEMY_FIREBALL_SHOOTER
; ==================================================================================================
enemyCode50:
	dec a
	ret z
	dec a
	ret z
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw fireballShooter_state_uninitialized
	.dw fireballShooter_state1
	.dw fireballShooter_state_stub
	.dw fireballShooter_state_stub
	.dw fireballShooter_state_stub
	.dw fireballShooter_state_stub
	.dw fireballShooter_state_stub
	.dw fireballShooter_state_stub
	.dw fireballShooter_state8
	.dw fireballShooter_state9


fireballShooter_state_uninitialized:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld e,Enemy.subid
	ld a,(de)
	bit 7,a
	ret z
	ld (hl),$08 ; [state]
	ret


; "Spawner"; spawns shooters at each appropriate tile index, then deletes self.
fireballShooter_state1:
	xor a
	ldh (<hFF8D),a

	ld e,Enemy.yh
	ld a,(de)
	ld c,a ; c = tile index to spawn at

	ld hl,wRoomLayout
	ld b,LARGE_ROOM_HEIGHT<<4

@nextTile:
	ldi a,(hl)
	cp c
	jr nz,+++

	push bc
	push hl
	ld c,l
	dec c
	ld b,ENEMY_FIREBALL_SHOOTER
	call ecom_spawnUncountedEnemyWithSubid01
	jr nz,@delete

	; [child.subid] = [this.subid] | $80
	ld e,l
	ld a,(de)
	set 7,a
	ldi (hl),a

	; [child.var03] = ([hFF8D]+1)&3 (timing offset)
	ldh a,(<hFF8D)
	inc a
	and $03
	ldh (<hFF8D),a
	ld (hl),a

	; Set child's position
	ld a,c
	and $f0
	add $06
	ld l,Enemy.yh
	ldi (hl),a
	ld a,c
	and $0f
	swap a
	add $08
	inc l
	ld (hl),a

	pop hl
	pop bc
+++
	dec b
	jr nz,@nextTile

@delete:
	jp enemyDelete


fireballShooter_state_stub:
	ret


; Initialization for "actual" shooter (not spawner)
fireballShooter_state8:
	ld a,$09
	ld (de),a ; [state]

	ld e,Enemy.var03
	ld a,(de)
	ld hl,fireballShooter_timingOffsets
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret


; Main state for actual shooter
fireballShooter_state9:
	call fireballShooter_checkAllEnemiesKilled
	; BUG: This does NOT return if it's just deleted itself! This could cause counter1
	; to be dirty the next time an enemy is spawned in its former slot.

	; Wait for Link to be far enough away
	ld c,$24
	call objectCheckLinkWithinDistance
	ret c

	; Wait for cooldown
	call ecom_decCounter1
	ret nz

	ld b,PART_GOPONGA_PROJECTILE
	call ecom_spawnProjectile

	; Random cooldown between $c0-$c7
	call getRandomNumber_noPreserveVars
	and $07
	add $c0
	ld e,Enemy.counter1
	ld (de),a
	ret


fireballShooter_timingOffsets:
	.db $4e $7e $ae $de


;;
; For subid $81 only, this deletes itself when all enemies are killed.
fireballShooter_checkAllEnemiesKilled:
	ld e,Enemy.subid
	ld a,(de)
	cp $81
	ret nz
	ld a,(wNumEnemies)
	or a
	ret nz

.ifdef ENABLE_BUGFIXES
	; Workaround for above mentioned bug: this will return from the caller.
	pop bc
.endif

	jp enemyDelete
