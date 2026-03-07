; ==================================================================================================
; ENEMY_ITEM_DROP_PRODUCER
;
; Variables:
;   var30: Tile at position (item drop will spawn when this changes)
; ==================================================================================================
enemyCode59:
	ld e,Enemy.state
	ld a,(de)
	or a
	jr nz,@state1

@state0:
	; Initialization
	ld a,$01
	ld (de),a ; [state]
	call objectGetTileAtPosition
	ld e,Enemy.var30
	ld (de),a

@state1
	call objectGetTileAtPosition
	ld h,d
	ld l,Enemy.var30
	cp (hl)
	ret z

	; Tile has changed.

	; Delete self if Link can't get the item drop yet (ie. doesn't have bombs)
	ld e,Enemy.subid
	ld a,(de)
	call checkItemDropAvailable
	jp z,enemyDelete

	call getFreePartSlot
	ret nz
	ld (hl),PART_ITEM_DROP

	; [child.subid] = [this.subid]
	inc l
	ld e,Enemy.subid
	ld a,(de)
	ld (hl),a

	call objectCopyPosition
	call markEnemyAsKilledInRoom
	jp enemyDelete
