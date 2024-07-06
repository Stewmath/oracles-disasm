; ==================================================================================================
; INTERAC_D7_4_ARMOS_BUTTON_PUZZLE
; ==================================================================================================
interactionCode66:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
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
	ld a,$27
	call objectMimicBgTile
	ld a,$06
	call objectSetCollideRadius
	ld l,$50
	ld (hl),$28
	ld l,$46
	ld (hl),$10
	inc l
	ld (hl),$02
	ld l,$4b
	dec (hl)
	dec (hl)
	push de
	call @@func_55c8
	pop de
	ld a,$71
	call playSound
	jp objectSetVisible82
@@state1:
	call objectApplySpeed
	call objectPreventLinkFromPassing
	call interactionDecCounter1
	ret nz
	ld (hl),$10
	inc l
	dec (hl)
	jr z,+
	call interactionCheckAdjacentTileIsSolid
	ret z
+
	call objectGetShortPosition
	ld c,a
	ld a,$27
	call setTile
	jp interactionDelete
@@func_55c8:
	call objectGetShortPosition
	ld c,a
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld b,$df
	ld a,(bc)
	ld b,a
	xor a
	ld ($ff00+R_SVBK),a
	ld a,b
	jp setTile
@subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld b,$df
	ld hl,@@table_5610
	ld a,$a3
-
	ld c,(hl)
	inc hl
	ld (bc),a
	dec e
	jr nz,-
	ld h,b
	ld l,$17
	ld (hl),$a0
	ld l,$3b
	ld (hl),$a0
	ld l,$5b
	ld (hl),$a0
	ld l,$57
	ld (hl),$a2
	xor a
	ld ($ff00+R_SVBK),a
	ret
@@table_5610:
	.db $35 $37 $39 $55
	.db $59 $75 $77 $79
@@state1:
	ld hl,wActiveTriggers
	bit 4,(hl)
	jr nz,+
	bit 0,(hl)
	jr z,+
	set 4,(hl)
	ld c,$32
	call nz,func_5694
+
	ld hl,wActiveTriggers
	bit 5,(hl)
	jr nz,+
	bit 1,(hl)
	jr z,+
	set 5,(hl)
	ld c,$52
	call nz,func_5694
+
	ld hl,wActiveTriggers
	bit 6,(hl)
	jr nz,+
	bit 2,(hl)
	jr z,+
	set 6,(hl)
	ld c,$95
	call nz,func_56a5
+
	ld hl,wActiveTriggers
	bit 7,(hl)
	jr nz,+
	bit 3,(hl)
	jr z,+
	set 7,(hl)
	ld c,$97
	call nz,func_56a5
+
	ld a,(wActiveTriggers)
	inc a
	ret nz
	call getThisRoomFlags
	bit 5,(hl)
	jp nz,interactionDelete
	ld e,$46
	ld a,$3c
	ld (de),a
	jp interactionIncState
@@state2:
	call interactionDecCounter1
	ret nz
	ld a,$a3
	call findTileInRoom
	jr nz,+
	ld a,$5a
	call playSound
	jp interactionDelete
+
	ldbc TREASURE_SMALL_KEY $01
	call createTreasure
	call objectCopyPosition
	jp interactionDelete
func_5694:
	ld b,$cf
-
	ld a,(bc)
	cp $27
	ld e,$18
	call z,func_56b8
	inc c
	ld a,c
	and $0f
	ret z
	jr -
func_56a5:
	ld b,$cf
-
	ld a,(bc)
	cp $27
	ld e,$10
	call z,func_56b8
	ld a,c
	sub $10
	ld c,a
	and $f0
	ret z
	jr -
func_56b8:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_D7_4_ARMOS_BUTTON_PUZZLE
	inc l
	ld (hl),$01
	push bc
	ld l,$4b
	call setShortPosition_paramC
	pop bc
	ld l,$49
	ld (hl),e
	ret
