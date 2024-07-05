; ==================================================================================================
; INTERAC_88
; ==================================================================================================
interactionCode88:
	call checkInteractionState
	jr nz,@nonZeroState
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$01
	ld (de),a
	ld e,$40
	ld a,(de)
	or $80
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible82
	call objectSetInvisible
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr z,+
	ld a,(wGfxRegs1.SCY)
	cpl
	inc a
+
	add $28
	ld l,$4b
	ld (hl),a
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,+
	call interactionIncSubstate
	ld hl,seasonsTable_09_7f33
	jp seasonsFunc_09_7f01
+
	ld a,GLOBALFLAG_SEASON_ALWAYS_SPRING
	call checkGlobalFlag
	jp nz,interactionDelete
	ld e,$46
	ld a,$3c
	ld (de),a
	ret
@nonZeroState:
	ld a,GLOBALFLAG_INTRO_DONE
	call checkGlobalFlag
	jr nz,+
	ld a,(wPaletteThread_mode)
	or a
	jp nz,interactionDelete
+
	call checkInteractionSubstate
	jr nz,+
	call interactionDecCounter1
	ret nz
	ld l,$46
	ld (hl),$3c
	call getRandomNumber_noPreserveVars
	and $01
	ret z
	call interactionIncSubstate
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,seasonsTable_09_7f2b
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp seasonsFunc_09_7f01
+
	ld e,$70
	ld a,(de)
	or a
	jr nz,seasonsFunc_09_7ee2
	ld a,$01
	ld (de),a
	ld e,$47
	ld a,(de)
	ld hl,seasonsTable_09_7f28
	rst_addAToHl
	ld a,(hl)
	call loadPaletteHeader
	ld a,$ff
	ld ($cd29),a
	ld a,(de)
	or a
	ld a,$d2
	call nz,playSound
	ld a,(de)
	cp $02
	jr z,+
	call objectSetInvisible
	jr seasonsFunc_09_7ee2
+
	call getRandomNumber
	and $01
	ld b,a
	ld a,$13
	jr z,+
	ld a,$8d
+
	ld e,$4d
	ld (de),a
	ld a,b
	call interactionSetAnimation
	call objectSetVisible

seasonsFunc_09_7ee2:
	ld e,$47
	ld a,(de)
	cp $02
	jr nz,+
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	jr nz,+
	call objectSetInvisible
+
	call interactionDecCounter1
	ret nz
	ld h,d
	ld l,$58
	ldi a,(hl)
	ld l,(hl)
	ld h,a
	inc hl
	inc hl

seasonsFunc_09_7f01:
	ld e,Interaction.relatedObj2
	ld a,h
	ld (de),a
	inc e
	ld a,l
	ld (de),a
	ldi a,(hl)
	inc a
	jr z,seasonsFunc_09_7f17
	ld e,$46
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld e,$70
	xor a
	ld (de),a
	ret

seasonsFunc_09_7f17:
	ld h,d
	ld l,$42
	ld a,(hl)
	or a
	jp z,interactionDelete
	ld l,$45
	ld (hl),$00
	ld l,$46
	ld (hl),$3c
	ret

seasonsTable_09_7f28:
	.db PALH_TILESET_ONOX_CASTLE_OUTSIDE_WINTER
	.db PALH_SEASONS_99
	.db PALH_SEASONS_9a

seasonsTable_09_7f2b:
	.dw seasonsTable_09_7f33
	.dw seasonsTable_09_7f33
	.dw seasonsTable_09_7f33
	.dw seasonsTable_09_7f33

seasonsTable_09_7f33:
	.db $3c $00
	.db $02 $01
	.db $04 $00
	.db $02 $02
	.db $78 $00
	.db $02 $01
	.db $02 $00
	.db $02 $01
	.db $02 $00
	.db $03 $01
	.db $01 $00
	.db $0c $02
	.db $3c $00
	.db $ff
