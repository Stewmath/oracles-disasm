; ==================================================================================================
; INTERAC_D4_HOLES_FLOORTRAP_ROOM
; ==================================================================================================
interactionCodec5:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	call interactionIncState
	ld bc,d4floorTrapRoom_tilesToBreak
	jp d4floorTrapRoom_storeAddressOfFirstHoleTilePosition
@state1:
	ld a,($ccba)
	or a
	ret z
	ld a,$f1
	call @func_7aea
	ld a,$4d
	call playSound
	ld e,$47
	ld a,$20
	ld (de),a
	dec e
	ld a,$10
	ld (de),a
	jp interactionIncState
@func_7aea:
	ld c,$2c
	call setTile
	jp objectCreatePuff
@state2:
	ld a,(wFrameCounter)
	rrca
	ret c
	call interactionDecCounter1
	ret nz
	; counter2 into counter1
	inc l
	ldd a,(hl)
	ldi (hl),a
	
	rrca
	cp $04
	jr z,+
	ld (hl),a
+
	call d4floorTrapRoom_storeNextHoleTileAddressIntoHL
	ldi a,(hl)
	ld c,a
	call d4floorTrapRoom_storeIncrementedAddressOfNextHoleTile
	ld a,c
	or a
	jp z,interactionDelete
	ld a,TILEINDEX_BLANK_HOLE
	jp breakCrackedFloor
d4floorTrapRoom_tilesToBreak:
	.db $9d $8d $8c $9b $7b $8a $89 $98
	.db $77 $76 $86 $96 $74 $83 $72 $81
	.db $61 $21 $11 $22 $52 $33 $14 $44
	.db $35 $15 $16 $47 $37 $27 $17 $18
	.db $48 $49 $39 $19 $00
d4floorTrapRoom_storeAddressOfFirstHoleTilePosition:
	ld h,d
	ld l,$58
	ld (hl),c
	inc l
	ld (hl),b
	ret
d4floorTrapRoom_storeNextHoleTileAddressIntoHL:
	ld h,d
	ld l,$58
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ret
d4floorTrapRoom_storeIncrementedAddressOfNextHoleTile:
	ld e,$58
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret
