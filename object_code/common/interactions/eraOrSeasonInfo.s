; ==================================================================================================
; INTERAC_ERA_OR_SEASON_INFO
; ==================================================================================================
interactionCodee0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a ; [state]

.ifdef ROM_AGES
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	rlca
.else
	ld a,(wLoadingRoomPack)
	inc a
	jr z,+
	ld a,(wRoomStateModifier)
+
.endif

	ld e,Interaction.subid
	ld (de),a

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.yh
	ld (hl),$0a
	ld l,Interaction.xh
	ld (hl),$b0
	jp objectSetVisible80

@state1:
	ld h,d
	ld l,Interaction.xh
	ld a,(hl)
	sub $04
	ld (hl),a
	cp $10
	ret nz
	ld l,e
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),40
	ret

@state2:
	call interactionDecCounter1
	ret nz
	ld l,e
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),$06
	ret

@state3:
	ld h,d
	ld l,Interaction.xh
	ld a,(hl)
	sub $06
	ld (hl),a
	ld l,Interaction.counter1
	dec (hl)
	ret nz
	jp interactionDelete
