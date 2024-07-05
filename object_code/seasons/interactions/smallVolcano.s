; ==================================================================================================
; INTERAC_SMALL_VOLCANO
; ==================================================================================================
interactionCode51:
	call checkInteractionState
	jr z,@state0
	ld a,(wFrameCounter)
	and $0f
	ld a,$b3
	call z,playSound
	ld a,($cd18)
	or a
	jr nz,+
	ld a,($cd19)
	or a
	call z,func_7a9a
+
	call interactionDecCounter1
	ret nz
	call func_7abe
	ld e,$42
	ld a,(de)
	or a
	ld c,$07
	jr z,+
	ld c,$0f
+
	call getRandomNumber
	and c
	srl c
	inc c
	sub c
	ld c,a
	call getFreePartSlot
	ret nz
	ld (hl),PART_VOLCANO_ROCK
	ld e,$42
	inc l
	ld a,(de)
	ld (hl),a
	ld b,$00
	jp objectCopyPositionWithOffset
@state0:
	inc a
	ld (de),a
	ld ($ccae),a
	ld e,$42
	ld a,(de)
	ld hl,table_7acb
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,$58
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret
func_7a9a:
	ld h,d
	ld l,$58
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldi a,(hl)
	cp $ff
	jr nz,+
	pop hl
	jp interactionDelete
+
	ld ($cd18),a
	ldi a,(hl)
	ld ($cd19),a
	ld e,$70
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ld e,$58
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
func_7abe:
	call getRandomNumber_noPreserveVars
	ld h,d
	ld l,$70
	and (hl)
	inc l
	add (hl)
	ld l,$46
	ld (hl),a
	ret

table_7acb:
	.dw table_7acf
	.dw table_7ae8

table_7acf:
	; wScreenShakeCounterY - wScreenShakeCounterX - var30 - var31
	.db $00 $0f $00 $ff
	.db $0f $00 $00 $ff
	.db $96 $00 $0f $08
	.db $5a $5a $07 $03
	.db $00 $3c $1f $10
	.db $00 $78 $00 $ff
	.db $ff

table_7ae8:
	; wScreenShakeCounterY - wScreenShakeCounterX - var30 - var31
	.db $00 $1e $00 $ff
	.db $1e $00 $00 $ff
	.db $b4 $b4 $0f $08
	.db $3c $3c $1f $10
	.db $1e $00 $00 $ff
	.db $00 $78 $00 $ff
	.db $0f $0f $00 $ff
	.db $ff
