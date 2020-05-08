; ==============================================================================
; INTERACID_RUPEE_ROOM_RUPEES
; ==============================================================================
interactionCode1d:
	ld e,Interaction.state		; $45a0
	ld a,(de)		; $45a2
	rst_jumpTable			; $45a3
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $45a8
	ld (de),a		; $45aa
	ld e,Interaction.subid		; $45ab
	ld a,(de)		; $45ad
	ld b,a			; $45ae
	add a			; $45af
	add b			; $45b0
	ld hl,@@rupeeRoomTable		; $45b1
	rst_addAToHl			; $45b4
	ldi a,(hl)		; $45b5
	ld e,Interaction.var30		; $45b6
	ld (de),a		; $45b8
	ldi a,(hl)		; $45b9
	ld e,Interaction.var31		; $45ba
	ld (de),a		; $45bc
	ld a,(hl)		; $45bd
	inc e			; $45be
	; var32
	ld (de),a		; $45bf
	ret			; $45c0

@@rupeeRoomTable:
	; top-left coords of rupees grid
	dbw $23 wD2RupeeRoomRupees
	dbw $34 wD6RupeeRoomRupees

@state1:
	ld a,(wActiveTileIndex)		; $45c7
	; is a rupee tile
	cp $3c			; $45ca
	jr z,+			; $45cc
	cp $3d			; $45ce
	ret nz			; $45d0
+
	ld h,d			; $45d1
	ld l,Interaction.var30		; $45d2
	ld a,(hl)		; $45d4
	ld a,(wActiveTilePos)		; $45d5
	sub (hl)		; $45d8
	ld b,a			; $45d9
	ld l,Interaction.var31		; $45da
	ldi a,(hl)		; $45dc
	ld h,(hl)		; $45dd
	ld l,a			; $45de
	ld a,b			; $45df
	swap a			; $45e0
	and $0f			; $45e2
	rst_addAToHl			; $45e4
	ld a,b			; $45e5
	and $0f			; $45e6
	ld bc,bitTable		; $45e8
	add c			; $45eb
	ld c,a			; $45ec
	ld a,(bc)		; $45ed
	or (hl)			; $45ee
	ld (hl),a		; $45ef
	call getRandomNumber		; $45f0
	and $0f			; $45f3
	ld hl,@@chosenRupeeVal		; $45f5
	rst_addAToHl			; $45f8
	ld c,(hl)		; $45f9
	ld a,GOLD_JOY_RING		; $45fa
	call cpActiveRing		; $45fc
	jr z,@@doubleRupees	; $45ff
	ld a,RED_JOY_RING		; $4601
	call cpActiveRing		; $4603
	jr nz,@@giveRupees	; $4606

@@doubleRupees:
	inc c			; $4608

@@giveRupees:
	ld a,TREASURE_RUPEES		; $4609
	call giveTreasure		; $460b
	ld a,(wActiveTilePos)		; $460e
	ld c,a			; $4611
	ld a,TILEINDEX_STANDARD_FLOOR		; $4612
	jp setTile		; $4614

@@chosenRupeeVal:
	.db RUPEEVAL_001 RUPEEVAL_010 RUPEEVAL_010 RUPEEVAL_005
	.db RUPEEVAL_005 RUPEEVAL_005 RUPEEVAL_005 RUPEEVAL_001
	.db RUPEEVAL_001 RUPEEVAL_020 RUPEEVAL_001 RUPEEVAL_001
	.db RUPEEVAL_001 RUPEEVAL_001 RUPEEVAL_001 RUPEEVAL_001
