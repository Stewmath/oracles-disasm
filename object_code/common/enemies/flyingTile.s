; ==================================================================================================
; ENEMY_FLYING_TILE
;
; Variables:
;   var30/var31: Pointer to current address in flyingTile_layoutData
; ==================================================================================================
enemyCode52:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp flyingTile_dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw flyingTile_state_uninitialized
	.dw flyingTile_state_spawner
	.dw flyingTile_state_stub
	.dw flyingTile_state_stub
	.dw flyingTile_state_stub
	.dw flyingTile_state_stub
	.dw flyingTile_state_stub
	.dw flyingTile_state_stub
	.dw flyingTile_state8
	.dw flyingTile_state9
	.dw flyingTile_stateA
	.dw flyingTile_stateB


flyingTile_state_uninitialized:
	ld e,Enemy.subid
	ld a,(de)
	rlca
	ld a,SPEED_1c0
	jp c,ecom_setSpeedAndState8

	; Subids $00-$7f only
	ld e,Enemy.state
	ld a,$01
	ld (de),a
	ret


flyingTile_state_spawner:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	inc l
	ld (hl),120 ; [counter1]

	ld e,Enemy.subid
	ld a,(de)
	ld hl,flyingTile_layoutData
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld e,Enemy.var03
	ldi a,(hl)
	ld (de),a


;;
; @param	hl	Address to save to var30/var31
@flyingTile_saveTileDataAddress:
	ld e,Enemy.var30
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

@substate1:
	call ecom_decCounter1
	ret nz

	ld (hl),60

	; Retrieve address in flyingTile_layoutData
	ld l,Enemy.var30
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	; Get next position to spawn tile at
	ldi a,(hl)
	ld c,a
	push hl

	call @flyingTile_saveTileDataAddress
	ld b,ENEMY_FLYING_TILE
	call ecom_spawnEnemyWithSubid01
	jr nz,++

	; [child.subid] = [this.var03]
	ld l,Enemy.subid
	ld e,Enemy.var03
	ld a,(de)
	ld (hl),a

	ld l,Enemy.yh
	call setShortPosition_paramC
++
	pop hl
	ld a,(hl)
	or a
	ret nz

	; Spawned all tiles; delete the spawner.
	jp flyingTile_delete


flyingTile_state_stub:
	ret


; Initialization of actual flying tile (not spawner)
flyingTile_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)

	call flyingTile_overwriteTileHere
	jp objectSetVisiblec2


; Moving up before charging at Link
flyingTile_state9:
	ld h,d
	ld l,Enemy.z
	ld a,(hl)
	sub <($0080)
	ldi (hl),a
	ld a,(hl)
	sbc >($0080)
	ld (hl),a

	cp $fd
	jr nc,flyingTile_animate

	; Moved high enoguh
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.counter1
	ld (hl),$0f

flyingTile_animate:
	jp enemyAnimate


; Staying in place for [counter1] frames before charging Link
flyingTile_stateA:
	call ecom_decCounter1
	jr nz,flyingTile_animate

	ld l,e
	inc (hl) ; [state]

	call ecom_updateAngleTowardTarget
	jr flyingTile_animate


; Charging at Link
flyingTile_stateB:
	call objectApplySpeed
	call objectCheckTileCollision_allowHoles
	jr nc,flyingTile_animate


;;
flyingTile_dead:
	ld b,INTERAC_ROCKDEBRIS
	call objectCreateInteractionWithSubid00

;;
flyingTile_delete:
	call decNumEnemies
	jp enemyDelete

;;
; Overwrites the tile at this position with whatever it should become after a flying tile
; is created there (depends on subid).
flyingTile_overwriteTileHere:
	call objectGetShortPosition
	ld c,a
	ld e,Enemy.subid
	ld a,(de)
	and $0f
	ld hl,@tileReplacements
	rst_addAToHl
	ld a,(hl)
	jp setTile


@tileReplacements:
	.db $a0 $f3 $f4 $4c $a4


.ifdef ROM_AGES
flyingTile_layoutData:
	.dw @subid0
	.dw @subid1
	.dw @subid2

; First byte is value for var03 (subid for spawned children).
; All remaining bytes are positions at which to spawn flying tiles.
; Ends when it reads $00.
@subid0:
	.db $80
	.db $57 $56 $46 $47 $48 $58 $68 $67
	.db $66 $65 $55 $45 $36 $37 $38 $49
	.db $59 $69 $78 $77 $76 $54 $5a
	.db $00

@subid1:
	.db $80
	.db $57 $46 $48 $39 $35 $26 $37 $59
	.db $49 $38 $29 $28 $36 $45 $56 $58
	.db $27 $47 $55 $25
	.db $00

@subid2:
	.db $80
	.db $67 $54 $5a $47 $34 $3a $76 $38
	.db $78 $36 $58 $45 $49 $56 $65 $69
	.db $00
.else
flyingTile_layoutData:
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3

@subid0:
	.db $82
	.db $34 $66 $44 $56 $54 $46 $64 $36
	.db $35 $65 $45 $55
	.db $00
@subid1:
	.db $82
	.db $19 $59 $7c $79 $76 $73 $93
	.db $00
@subid2:
	.db $80
	.db $57 $46 $54 $66 $37 $77 $48 $68
	.db $5a $5b $27 $87 $45 $69 $65 $49
	.db $53 $36 $78 $38 $76 $44 $6a $64
	.db $4a $55 $59 $47 $67 $56 $58
	.db $00
@subid3:
	.db $80
	.db $36 $76 $38 $78 $44 $64 $4a $6a
	.db $26 $88 $75 $39 $35 $79 $43 $6b
	.db $63 $4b $37 $87 $77 $27 $53 $34
	.db $7a $74 $3a $28 $86 $5b
	.db $00
.endif
