; ==================================================================================================
; PART_BRIDGE_SPAWNER
; ==================================================================================================
partCode0c:
	ld e,Part.state
	ld a,(de)
	or a
	call z,@state0

	call partCommon_decCounter1IfNonzero
	ret nz

	; Time to create the next bridge tile
	ld l,Part.angle
	ld a,(hl)
	ld hl,@tileValues
	rst_addDoubleIndex
	ld e,Part.counter2
	ld a,(de)
	rrca
	ldi a,(hl)
	jr nc,+
	ld a,(hl)
+
	ld b,a
	ld e,Part.yh
	ld a,(de)
	ld c,a
	push bc
	call setTileInRoomLayoutBuffer
	pop bc
	ld a,b
	call setTile
	ld a,SND_DOORCLOSE
	call playSound

	ld h,d
	ld l,Part.counter1
	ld (hl),$08
	inc l
	dec (hl) ; [counter2]
	jp z,partDelete

	; Move to next tile every other time (since bridges are updated in halves)
	ld a,(hl) ; [counter1]
	rrca
	ret c

	ld l,Part.angle
	ld a,(hl)
	ld bc,@directionVals
	call addAToBc
	ld a,(bc)
	ld l,Part.yh
	add (hl)
	ld (hl),a
	ret

@tileValues:
	.db TILEINDEX_VERTICAL_BRIDGE_DOWN,    TILEINDEX_VERTICAL_BRIDGE
	.db TILEINDEX_HORIZONTAL_BRIDGE_LEFT,  TILEINDEX_HORIZONTAL_BRIDGE
	.db TILEINDEX_VERTICAL_BRIDGE_UP,      TILEINDEX_VERTICAL_BRIDGE
	.db TILEINDEX_HORIZONTAL_BRIDGE_RIGHT, TILEINDEX_HORIZONTAL_BRIDGE

@directionVals:
	.db $f0 $01 $10 $ff

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1
	ld l,Part.counter1
	ld (hl),$08
	ret
