; ==================================================================================================
; INTERAC_D5_4_CHEST_PUZZLE
; ==================================================================================================
interactionCode62:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
@subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @subid1
	.dw @subid1
@@state0:
	call getThisRoomFlags
	bit 5,(hl)
	jp nz,interactionDelete
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ld ($ccbb),a
	xor a
	ld ($cfd8),a
	ld ($cfd9),a
@@state1:
	ld a,(wNumEnemies)
	or a
	ret nz
	ld a,($cfd0)
	ld b,a
	ld c,$00
	call @@func_4fa5
	ld a,($cfd1)
	ld b,a
	ld c,$01
	call @@func_4fa5
	ld a,($cfd2)
	ld b,a
	ld c,$02
	call @@func_4fa5
	ld a,($cfd3)
	ld b,a
	ld c,$03
	call @@func_4fa5
	jp interactionDelete
@@func_4fa5:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_D5_4_CHEST_PUZZLE
	inc l
	ld (hl),$01
	ld l,$70
	ld (hl),b
	ld l,$43
	ld (hl),c
	ret
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
@@state0:
	ld a,$01
	ld (de),a
	ld e,$70
	ld a,(de)
	ld h,d
	ld l,$4b
	call setShortPosition
	ld l,$66
	ld (hl),$04
	inc l
	ld (hl),$06
	ld l,$46
	ld (hl),$1e
	call objectCreatePuff
@@state1:
	call interactionDecCounter1
	ret nz
	ld l,$44
	inc (hl)
	ld l,$70
	ld c,(hl)
	ld a,TILEINDEX_CHEST
	call setTile
@@state2:
	ld a,($cfd9)
	or a
	jp nz,func_5076
	call objectPreventLinkFromPassing
	ld a,(wcca2)
	or a
	ret z
	ld b,a
	ld e,$70
	ld a,(de)
	cp b
	ret nz
	ld a,($cfd8)
	ld b,a
	ld e,$43
	ld a,(de)
	cp b
	jr nz,@@func_5040
	inc a
	ld ($cfd8),a
	ld hl,$d040
	ld b,$40
	call clearMemory
	ld hl,$d040
	inc (hl)
	inc l
	ld (hl),$60
	inc l
	ld a,($cfd8)
	dec a
	ld bc,@@table_504b
	call addDoubleIndexToBc
	ld a,(bc)
	ld (hl),a
	inc l
	inc bc
	ld a,(bc)
	ld (hl),a
	ld bc,$f800
	call objectCopyPositionWithOffset
	ld e,Interaction.state
	ld a,$03
	ld (de),a
	ld a,$81
	ld ($cca4),a
	ret
@@func_5040:
	ld a,$5a
	call playSound
	ld a,$01
	ld ($cfd9),a
	ret
@@table_504b:
	; $d042 - $d043
	.db TREASURE_RUPEES      RUPEEVAL_070
	.db TREASURE_BOMBS       $01
	.db TREASURE_EMBER_SEEDS $00
	.db TREASURE_SMALL_KEY   $03
@@state3:
	ld a,($cfd9)
	or a
	jr nz,func_5076
	ret
@@state4:
	call interactionDecCounter1
	ret nz
	call objectCreatePuff
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMY_WHISP
	call objectCopyPosition
	ld e,$70
	ld a,(de)
	ld c,a
	ld a,TILEINDEX_STANDARD_FLOOR
	call setTile
	jp interactionDelete
func_5076:
	ld e,Interaction.state
	ld a,$04
	ld (de),a
	ld e,$46
	ld a,$3c
	ld (de),a
	ret
