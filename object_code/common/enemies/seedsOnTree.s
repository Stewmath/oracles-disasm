; ==================================================================================================
; ENEMY_SEEDS_ON_TREE
;
; Variables:
;   var03: Child "PART_SEED_ON_TREE" objects write here when Link touches them?
; ==================================================================================================
enemyCode5a:
	ld e,Enemy.state
	ld a,(de)
	or a
	jr nz,@state1


; Initialization
@state0:
	ld a,$01
	ld (de),a ; [state]

.ifdef ROM_AGES
	; Locate tree
	ld a,TILEINDEX_MYSTICAL_TREE_TL
	call findTileInRoom
	jp nz,interactionDelete ; BUG: Wrong function call! (see below)

	; Move to that position
	ld c,l
	ld h,d
	ld l,Enemy.yh
	call setShortPosition_paramC
	ld bc,$0808
	call objectCopyPositionWithOffset

	ld e,Enemy.subid
	ld a,(de)
	and $0f
	ld hl,wSeedTreeRefilledBitset
	call checkFlag
	jp z,interactionDelete

	; BUG: Above function call is wrong! Should be "enemyDelete"!
	; If a seed tree's seeds are exhausted, instead of deleting this object, it will
	; try to delete the interaction in the corresponding spot!
	; This is not be very noticeable, because often this will be in slot $d0, which
	; for interactions, is reserved for items from chests and stuff like that. But
	; that can be manipulated by digging up enemies from the ground...

	ld a,(de)
	swap a
	and $0f
	ldh (<hFF8B),a
.else
	ld e,Enemy.subid
	ld a,(de)
	ld b,a
	add a
	add b
	ld hl,@treeDataTable
	rst_addAToHl
	ldi a,(hl)
	ldh (<hFF8B),a
	ldi a,(hl)
	ld b,a
	ld a,(wRoomStateModifier)
	cp b
	jp nz,enemyDelete
	ld a,(hl)
	cpl
	ld e,Enemy.direction
	ld (de),a
	ld a,(wSeedTreeRefilledBitset)
	and (hl)
	jp z,enemyDelete
.endif

	; Spawn the 3 seed objects
	xor a
	call @addSeed
	ld a,$01
	call @addSeed
	ld a,$02
@addSeed:
	ld hl,@positionOffsets
	rst_addDoubleIndex
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	inc hl
	ld b,a
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	ld c,a

	call getFreePartSlot
	ld (hl),PART_SEED_ON_TREE
	inc l
	ldh a,(<hFF8B)
	ld (hl),a ; [subid]

	ld l,Part.yh
	ld (hl),b
	ld l,Part.xh
	ld (hl),c

	ld l,Part.relatedObj2
	ld (hl),Enemy.start
	inc l
	ld (hl),d
	ret

@positionOffsets:
	.db $f8 $00
	.db $00 $f8
	.db $00 $08

.ifdef ROM_SEASONS

; Data:
; - Seed type
; - Required season to grow
; - Bitmask checked against wSeedTreeRefilledBitset
@treeDataTable:
	.db $00, SEASON_WINTER, $80
	.db $04, SEASON_SUMMER, $40
	.db $01, SEASON_SPRING, $20
	.db $02, SEASON_AUTUMN, $10
	.db $03, SEASON_SUMMER, $08
	.db $03, SEASON_SUMMER, $04
.endif


@state1:
	; Waiting for one of the PART_SEED_ON_TREE objects to write to var03, indicating
	; that they were grabbed
	ld e,Enemy.var03
	ld a,(de)
	or a
	ret z

	; Mark seeds as taken
.ifdef ROM_AGES
	ld e,Enemy.subid
	ld a,(de)
	and $0f
	ld hl,wSeedTreeRefilledBitset
	call unsetFlag
.else
	ld e,Enemy.direction
	ld a,(de)
	ld hl,wSeedTreeRefilledBitset
	and (hl)
	ld (hl),a
.endif
	jp enemyDelete
