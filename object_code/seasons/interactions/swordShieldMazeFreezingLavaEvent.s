; ==================================================================================================
; INTERAC_D8_FREEZING_LAVA_EVENT
; ==================================================================================================
interactionCode69:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
@subid0:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
@@state0:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
@@@substate0:
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete
	ld e,$4d
	ld a,(de)
	ld e,$43
	ld (de),a
	ld hl,@@@table_5976
	rst_addAToHl
	ld b,(hl)
	call getThisRoomFlags
	ld l,b
	bit 6,(hl)
	jp z,interactionDelete
	call getThisRoomFlags
	set 6,(hl)
	ld e,Interaction.substate
	ld a,$01
	ld (de),a
	ld a,$f0
	call playSound
	ld a,$ff
	ld (wActiveMusic),a
	ld a,$80
	ld ($cca4),a
	jr @@@substate1
@@@table_5976:
	.db $7e $7f $88 $89
@@@substate1:
	call func_5ae0
	ld a,($c4ab)
	or a
	ret nz
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	xor a
	inc e
	ld (de),a
	call getFreeInteractionSlot
	jp nz,interactionDelete
	ld (hl),INTERAC_D8_FREEZING_LAVA_EVENT
	inc l
	ld (hl),$01
	ld e,$4b
	ld a,(de)
	ld l,$4b
	jp setShortPosition
@@state1:
	ld a,($cfc0)
	inc a
	ret nz
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ld e,$43
	ld a,(de)
	ld hl,table_5b0d
	rst_addDoubleIndex
	ld e,$58
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld h,d
	ld l,$46
	ld (hl),$14
	inc l
	ld (hl),$03
	call fastFadeoutToWhite
@@state2:
	ld a,$3c
	call setScreenShakeCounter
	call interactionDecCounter1
	ret nz
	ld (hl),$14
	inc l
	dec (hl)
	jp nz,fastFadeoutToWhite
	ld l,$44
	inc (hl)
	call clearPaletteFadeVariablesAndRefreshPalettes
	call getFreeInteractionSlot
	jr nz,@@state3
	ld (hl),INTERAC_D8_FREEZING_LAVA_EVENT
	inc l
	ld (hl),$04
	ld e,$58
	ld l,e
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a
	ld l,$46
	ld (hl),$84
@@state3:
	ld a,$3c
	call setScreenShakeCounter
	ld a,($c4ab)
	or a
	ret nz
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$7a
	call playSound
	ld b,$d6
	call func_5af7
	ret nz
	jp interactionDelete
@func_5a0a:
	ld a,($cc57)
	inc a
	ld ($cc57),a
	call getActiveRoomFromDungeonMapPosition
	ld ($cc64),a
	ld a,($cfd0)
	ld ($cc66),a
	ld a,($cc49)
	or $80
	ld ($cc63),a
	xor a
	ld ($cc65),a
	ld a,$03
	ld (wWarpTransition2),a
	call getThisRoomFlags
	res 4,(hl)
	xor a
	ld ($cca4),a
	ld ($cc02),a
	jp interactionDelete
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectGetZAboveScreen
	ld e,$4f
	ld (de),a
	call objectSetVisiblec0
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_D8_FREEZING_LAVA_EVENT
	inc l
	ld (hl),$02
	ld e,$59
	ld a,h
	ld (de),a
	jp objectCopyPosition
@@state1:
	ld e,$59
	ld a,(de)
	ld h,a
	ld l,$4a
	ld e,l
	ld b,$06
	call copyMemoryReverse
	ld c,$08
	call objectUpdateSpeedZ_paramC
	ret nz
	ldbc INTERAC_D8_FREEZING_LAVA_EVENT $03
	call objectCreateInteraction
	jr nz,+
	ld a,$01
	ld ($cfc0),a
+
	jp interactionDelete
@subid2:
	ld e,Interaction.state
	ld a,(de)
	or a
	jr nz,+
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible83
+
	ld a,($cfc0)
	or a
	jp nz,interactionDelete
	jp interactionAnimate
@subid3:
	ld e,Interaction.state
	ld a,(de)
	or a
	jr nz,+
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible83
	ld a,$5c
	call playSound
+
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	ret nz
	ld a,$ff
	ld ($cfc0),a
	call objectGetShortPosition
	ld c,a
	ld a,$d5
	call setTile
	jp interactionDelete
@subid4:
	ld a,($c4ab)
	or a
	ret nz
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld b,$d7
	call func_5af7
	ret nz
	jp @func_5a0a
func_5ae0:
	ld hl,$d080
-
	ld a,(hl)
	or a
	call nz,func_5aef
	inc h
	ld a,h
	cp $e0
	jr c,-
	ret
func_5aef:
	xor a
	ld l,$9a
	ld (hl),a
	ld l,$80
	ld (hl),a
	ret
func_5af7:
	ld h,d
	ld l,$58
	ld e,l
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldi a,(hl)
	or a
	ret z
	ld c,a
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld a,b
	call setTile
	or d
	ret
table_5b0d:
	.dw table_5b15
	.dw table_5b3f
	.dw table_5b73
	.dw table_5bbb
table_5b15:
	.db $34 $44 $43 $45 $42 $46 $41 $47
	.db $53 $55 $52 $31 $37 $21 $27 $28
	.db $11 $17 $18 $51 $62 $61 $64 $66
	.db $67 $68 $74 $73 $75 $72 $76 $71
	.db $77 $81 $82 $83 $84 $85 $86 $87
	.db $88 $00
table_5b3f:
	.db $27 $37 $36 $47 $38 $46 $48 $35
	.db $39 $3a $4a $49 $59 $58 $57 $56
	.db $45 $44 $55 $54 $2a $1a $1b $53
	.db $63 $64 $4b $5b $5a $1c $2c $3c
	.db $6a $69 $68 $67 $66 $62 $76 $77
	.db $6b $5c $6c $7c $7b $7a $79 $78
	.db $72 $73 $74 $00
table_5b73:
	.db $37 $47 $57 $46 $56 $66 $67 $48
	.db $58 $68 $45 $55 $65 $49 $59 $69
	.db $64 $54 $44 $34 $5a $6a $6b $5b
	.db $4b $7b $7a $79 $5c $6c $7c $74
	.db $73 $63 $53 $43 $77 $78 $3a $2a
	.db $1a $33 $23 $22 $32 $42 $52 $62
	.db $72 $24 $14 $13 $03 $02 $12 $04
	.db $05 $3b $2b $1b $0b $2c $3c $4c
	.db $0a $09 $08 $0c $1c $06 $07 $00
table_5bbb:
	.db $79 $89 $88 $99 $8a $87 $97 $98
	.db $9a $9b $8b $76 $86 $9c $9d $8d
	.db $7d $6d $5d $2d $2c $2a $29 $4d
	.db $3d $4c $4a $3c $3b $49 $38 $3a
	.db $39 $75 $85 $65 $95 $84 $94 $27
	.db $26 $24 $00
