; ==================================================================================================
; INTERAC_MAKU_GATE_OPENING
; ==================================================================================================
interactionCode76:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d
	ld l,Interaction.state
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),30
	ld l,Interaction.subid
	ld a,(hl)
	or a
	ld hl,@frame0And1_subid0
	jr z,+
	ld hl,@frame0And1_subid1
+
	call @loadInterleavedTiles
	ld bc,@frame0_poof
	call @loadPoofs

@shakeScreen:
	ld a,$06
	call setScreenShakeCounter
	ld a,SND_DOORCLOSE
	jp playSound

@state1:
	call interactionDecCounter1
	ret nz
	ld hl,@frame0And1_subid0
	call @loadTiles
	ld bc,@frame1_poof
	call @loadPoofs
	call @shakeScreen
	ld h,d
	ld l,Interaction.state
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),30
	ret

@state2:
	call interactionDecCounter1
	ret nz
	ld hl,@frame2And3
	call @loadInterleavedTiles
	ld bc,@frame2_poof
	call @loadPoofs
	call @shakeScreen

	ld h,d
	ld l,Interaction.state
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),30
	ret

@state3:
	call interactionDecCounter1
	ret nz
	ld hl,@frame2And3
	call @loadTiles
	ld bc,@frame3_poof
	call @loadPoofs
	call @shakeScreen
	call getThisRoomFlags
	set 7,(hl)
	jp interactionDelete

@frame0And1_subid0:
	.db $02
	.db $74 $f9 $8e $03
	.db $75 $f9 $8e $01

@frame0And1_subid1:
	.db $02
	.db $74 $f9 $8c $03
	.db $75 $f9 $8c $01

@frame2And3:
	.db $02
	.db $73 $f9 $8c $03
	.db $76 $f9 $8c $01

@frame0_poof:
	.db $04
	.db $74 $48
	.db $74 $58
	.db $7c $48
	.db $7c $58

@frame1_poof:
	.db $04
	.db $74 $40
	.db $74 $60
	.db $7c $40
	.db $7c $60

@frame2_poof:
	.db $04
	.db $74 $38
	.db $74 $68
	.db $7c $38
	.db $7c $68

@frame3_poof:
	.db $04
	.db $74 $30
	.db $74 $70
	.db $7c $30
	.db $7c $70

;;
; @param	hl	Pointer to data
@loadInterleavedTiles:
	ldi a,(hl)
	ld b,a
@@next:
	ldi a,(hl)
	ldh (<hFF8C),a
	ldi a,(hl)
	ldh (<hFF8F),a
	ldi a,(hl)
	ldh (<hFF8E),a
	ldi a,(hl)
	push hl
	push bc
	call setInterleavedTile
	pop bc
	pop hl
	dec b
	jr nz,@@next
	ret

;;
; @param	hl	Pointer to data
@loadTiles:
	ldi a,(hl)
	ld b,a
@@next:
	ldi a,(hl)
	ld c,a
	ld a,(hl)
	push hl
	push bc
	call setTile
	pop bc
	pop hl
	inc hl
	inc hl
	inc hl
	dec b
	jr nz,@@next
	ret

;;
; @param	hl	Pointer to poof position data
@loadPoofs:
	ld a,(bc)
	inc bc
@@next:
	ldh (<hFF8B),a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_PUFF
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	inc bc
	ldh a,(<hFF8B)
	dec a
	jr nz,@@next
	ld a,SND_KILLENEMY
	jp playSound
