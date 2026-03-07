; ==================================================================================================
; INTERAC_CREDITS_TEXT_VERTICAL
;
; Variables:
;   var30/var31: 16-bit counter?
; ==================================================================================================
interactionCodeaf:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,+
	ld hl,@data_66bc
	jp @storeVar30Value
+
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ret

@state1:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@subid1

	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld h,d
	ld l,Interaction.var30
	call decHlRef16WithCap
	ret nz

	call @spawnChild
	ld e,Interaction.var30
	ld a,(de)
	inc a
	ret nz

.ifdef ROM_AGES
	ld hl,wTmpcfc0.genericCutscene.cfdf
	ld (hl),$ff
.else
	ld hl,wTmpcfc0.genericCutscene.cfde
	ld (hl),$01
.endif

	jp interactionDelete

@spawnChild:
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERAC_CREDITS_TEXT_VERTICAL
	inc l
	ld (hl),$01 ; [child.subid] = 1
	inc l
	ld e,Interaction.counter1
	ld a,(de)
	ld (hl),a ; [child.var03]
	call objectCopyPosition
++
	ld h,d
	ld l,Interaction.counter1
	inc (hl)
	ld a,(hl)
	ld hl,@data_66bc
	rst_addDoubleIndex

@storeVar30Value:
	ldi a,(hl)
	ld e,Interaction.var30
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ret

@subid1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call objectApplySpeed
	ld h,d
	ld l,Interaction.yh
	ldi a,(hl)
	ld b,a
	or a
	jp z,interactionDelete
	inc l
	ld c,(hl) ; [xh]
	jp interactionFunc_3e6d

@data_66bc:
.ifdef ROM_AGES

.ifdef REGION_JP
	.dw $0020
	.dw $00e0
	.dw $0120
	.dw $0110
	.dw $00e0
	.dw $0160
	.dw $00e0
	.dw $0100
	.dw $0140
	.dw $0150
	.dw $0130
	.dw $0180
	.db $ff
.else ; REGION_US
	.dw $0020
	.dw $00e0
	.dw $0120
	.dw $0110
	.dw $00f0
	.dw $0160
	.dw $00f0
	.dw $0120
	.dw $0170
	.dw $0150
	.dw $0160
	.dw $0140
	.dw $0140
	.dw $0160
	.dw $0110
	.dw $0160
	.dw $01a0
	.db $ff
.endif

.else ;ROM_SEASONS
	.dw $0020
	.dw $00e0
	.dw $0120
	.dw $0110
	.dw $00f0
	.dw $0160
	.dw $00f0
	.dw $0120
	.dw $0170
	.dw $0170
	.dw $0160
	.dw $0140
	.dw $0150
	.dw $0110
	.dw $0160
	.dw $01a0
	.db $ff
.endif
