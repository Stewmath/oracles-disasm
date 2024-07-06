; ==================================================================================================
; INTERAC_TWINROVA_FLAME
; ==================================================================================================
.ifdef ROM_AGES
interactionCodea9:
.else
interactionCodeb0:
.endif
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interactionAnimate
	.dw @state2

@state0:
	ld a,$01
	ld (de),a ; [state]

	ld e,Interaction.subid
	ld a,(de)
.ifdef ROM_AGES
	cp $06
.else
	cp $0b
.endif
	call nc,interactionIncState

.ifdef ROM_SEASONS
	or a
	jr nz,+
	ld a,$b0
	ld (wInteractionIDToLoadExtraGfx),a
	ld (wLoadedTreeGfxIndex),a
+
.endif

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit

	ld l,Interaction.subid
	ld a,(hl)
	ld b,a
.ifdef ROM_AGES
	cp $03
.else
	cp $08
.endif
	jr c,++
	call getThisRoomFlags
	and $80
	jp nz,interactionDelete

	ld a,(de) ; [subid]
.ifdef ROM_AGES
++
	and $03
.else
	sub $05
++
.endif
	add a
	add a
	add a
	ld l,Interaction.animCounter ; BUG(?): Won't point to the object after "getThisRoomFlags" call?
	add (hl)
	ld (hl),a
	ld a,b
	ld hl,@positions
	rst_addDoubleIndex
	ldi a,(hl)
.ifdef ROM_AGES
	ld c,(hl)
	ld b,a
	call interactionSetPosition
.else
	ld e,Interaction.yh
	ld (de),a
	inc e
	inc e
	ld a,(hl)
	ld (de),a
.endif
	jp objectSetVisiblec2

@positions:
.ifdef ROM_SEASONS
	.db $32 $78
	.db $50 $80
	.db $50 $70
.endif

	.db $40 $a8
	.db $40 $48
	.db $10 $78

.ifdef ROM_SEASONS
	.db $48 $30
	.db $48 $70
.endif

	.db $50 $a8
	.db $50 $48
	.db $20 $78

	.db $50 $a8
	.db $50 $48
	.db $20 $78

@state2:
	call interactionAnimate
	ld a,(wFrameCounter)
	rrca
	jp c,objectSetVisible
	jp objectSetInvisible
