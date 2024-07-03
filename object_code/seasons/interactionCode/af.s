; ==============================================================================
; ???
; ==============================================================================
interactionCodeaf:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld e,$42
	ld a,(de)
	or a
	jr nz,@@subid1
	ld hl,table_6dd2
	jp func_6db4
@@subid1:
	ld h,d
	ld l,$50
	ld (hl),$14
	ret
@state1:
	ld e,$42
	ld a,(de)
	or a
	jr nz,state1_subid1
	ld a,($c4ab)
	or a
	ret nz
	ld h,d
	ld l,$70
	call decHlRef16WithCap
	ret nz
	call @@func_6d99
	ld e,$70
	ld a,(de)
	inc a
	ret nz
	ld hl,$cfde
	ld (hl),$01
	jp interactionDelete
@@func_6d99:
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_af
	inc l
	ld (hl),$01
	inc l
	ld e,$46
	ld a,(de)
	ld (hl),a
	call objectCopyPosition
+
	ld h,d
	ld l,$46
	inc (hl)
	ld a,(hl)
	ld hl,table_6dd2
	rst_addDoubleIndex
func_6db4:
	ldi a,(hl)
	ld e,$70
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ret
state1_subid1:
	ld a,($c4ab)
	or a
	ret nz
	call objectApplySpeed
	ld h,d
	ld l,$4b
	ldi a,(hl)
	ld b,a
	or a
	jp z,interactionDelete
	inc l
	ld c,(hl)
	jp interactionFunc_3e6d
table_6dd2:
	; var30 - var31
	.db $20 $00
	.db $e0 $00
	.db $20 $01
	.db $10 $01
	.db $f0 $00
	.db $60 $01
	.db $f0 $00
	.db $20 $01
	.db $70 $01
	.db $70 $01
	.db $60 $01
	.db $40 $01
	.db $50 $01
	.db $10 $01
	.db $60 $01
	.db $a0 $01
	.db $ff