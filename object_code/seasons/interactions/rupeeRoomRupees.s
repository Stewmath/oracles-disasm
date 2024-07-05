; ==================================================================================================
; INTERAC_RUPEE_ROOM_RUPEES
; ==================================================================================================
interactionCode1d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	add a
	add b
	ld hl,@@rupeeRoomTable
	rst_addAToHl
	ldi a,(hl)
	ld e,Interaction.var30
	ld (de),a
	ldi a,(hl)
	ld e,Interaction.var31
	ld (de),a
	ld a,(hl)
	inc e
	; var32
	ld (de),a
	ret

@@rupeeRoomTable:
	; top-left coords of rupees grid
	dbw $23 wD2RupeeRoomRupees
	dbw $34 wD6RupeeRoomRupees

@state1:
	ld a,(wActiveTileIndex)
	; is a rupee tile
	cp $3c
	jr z,+
	cp $3d
	ret nz
+
	ld h,d
	ld l,Interaction.var30
	ld a,(hl)
	ld a,(wActiveTilePos)
	sub (hl)
	ld b,a
	ld l,Interaction.var31
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,b
	swap a
	and $0f
	rst_addAToHl
	ld a,b
	and $0f
	ld bc,bitTable
	add c
	ld c,a
	ld a,(bc)
	or (hl)
	ld (hl),a
	call getRandomNumber
	and $0f
	ld hl,@@chosenRupeeVal
	rst_addAToHl
	ld c,(hl)
	ld a,GOLD_JOY_RING
	call cpActiveRing
	jr z,@@doubleRupees
	ld a,RED_JOY_RING
	call cpActiveRing
	jr nz,@@giveRupees

@@doubleRupees:
	inc c

@@giveRupees:
	ld a,TREASURE_RUPEES
	call giveTreasure
	ld a,(wActiveTilePos)
	ld c,a
	ld a,TILEINDEX_STANDARD_FLOOR
	jp setTile

@@chosenRupeeVal:
	.db RUPEEVAL_001 RUPEEVAL_010 RUPEEVAL_010 RUPEEVAL_005
	.db RUPEEVAL_005 RUPEEVAL_005 RUPEEVAL_005 RUPEEVAL_001
	.db RUPEEVAL_001 RUPEEVAL_020 RUPEEVAL_001 RUPEEVAL_001
	.db RUPEEVAL_001 RUPEEVAL_001 RUPEEVAL_001 RUPEEVAL_001
