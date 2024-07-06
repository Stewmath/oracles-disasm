;;
; ITEM_28 (ricky/moosh attack?)
;
itemCode28:
	ld e,Item.state
	ld a,(de)
	or a
	jr nz,+

	; Initialization
	call itemIncState
	ld l,Item.counter1
	ld (hl),$14
	call itemLoadAttributesAndGraphics
	jr @calculatePosition
+
	call @calculatePosition
	call @tryToBreakTiles
	call itemDecCounter1
	ret nz
	jp itemDelete

@calculatePosition:
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_RICKY
	ld hl,@mooshData
	jr nz,+

	ld a,(w1Companion.direction)
	add a
	ld hl,@rickyData
	rst_addDoubleIndex
+
	jp itemInitializeFromLinkPosition


; b0/b1: collisionRadiusY/X
; b2/b3: Y/X offsets from Link's position

@rickyData:
	.db $10 $0c $f4 $00 ; DIR_UP
	.db $0c $12 $fe $08 ; DIR_RIGHT
	.db $10 $0c $08 $00 ; DIR_DOWN
	.db $0c $12 $fe $f8 ; DIR_LEFT

@mooshData:
	.db $18 $18 $10 $00


@tryToBreakTiles:
	ld hl,@rickyBreakableTileOffsets
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_RICKY
	jr z,@nextTile
	ld hl,@mooshBreakableTileOffsets

@nextTile:
	; Get item Y/X + offset in bc
	ld e,Item.yh
	ld a,(de)
	add (hl)
	ld b,a
	inc hl
	ld e,Item.xh
	ld a,(de)
	add (hl)
	ld c,a

	inc hl
	push hl
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_RICKY
	ld a,BREAKABLETILESOURCE_RICKY_PUNCH
	jr z,+
	ld a,BREAKABLETILESOURCE_MOOSH_BUTTSTOMP
+
	call tryToBreakTile
	pop hl
	ld a,(hl)
	cp $ff
	jr nz,@nextTile
	ret


; List of offsets from this object's position to try breaking tiles at

@rickyBreakableTileOffsets:
	.db $f8 $08
	.db $f8 $f8
	.db $08 $08
	.db $08 $f8
	.db $ff

@mooshBreakableTileOffsets:
	.db $00 $00
	.db $f0 $f0
	.db $f0 $00
	.db $f0 $10
	.db $00 $f0
	.db $00 $10
	.db $10 $f0
	.db $10 $00
	.db $10 $10
	.db $ff
