; ==================================================================================================
; INTERAC_TEMPLE_SINKING_EXPLOSION
; ==================================================================================================
interactionCode86:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	add a
	add b
	ld b,a
	ld h,d
	ld l,$62
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,b
	rst_addAToHl
	ld e,$62
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	call func_7cb3
	jp objectSetVisible81
@state1:
	ld hl,$cfd3
	ld a,(hl)
	inc a
	jp z,interactionDelete
	dec a
	and $7f
	ld b,a
	ld h,d
	ld l,$43
	ld a,(hl)
	cp b
	jr z,+
	ld (hl),b
	call func_7cb3
	jr ++
+
	ld e,$61
	ld a,(de)
	inc a
	call z,func_7cb3
++
	call interactionAnimate
	ld e,Interaction.subid
	ld a,(de)
	and $01
	ld b,a
	ld a,(wFrameCounter)
	and $01
	xor b
	jp z,objectSetInvisible
	jp objectSetVisible
func_7cb3:
	ld hl,$cfd3
	ld a,(hl)
	and $7f
	ld hl,table_7cd8
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,Interaction.subid
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,$4b
	call func_7ccd
	ld a,(hl)
	ld e,$4d
func_7ccd:
	ld b,a
	call getRandomNumber
	and $03
	sub $02
	add b
	ld (de),a
	ret
table_7cd8:
	.dw table_7ce2
	.dw table_7cec
	.dw table_7cf6
	.dw table_7d00
	.dw table_7d0a
table_7ce2:
	.db $79 $42
	.db $7b $4e
	.db $7e $5b
	.db $80 $70
	.db $81 $8a
table_7cec:
	.db $00 $38
	.db $6c $20
	.db $48 $40
	.db $3c $91
	.db $34 $64
table_7cf6:
	.db $2c $7e
	.db $1e $9e
	.db $50 $6e
	.db $28 $24
	.db $60 $20
table_7d00:
	.db $1c $18
	.db $44 $64
	.db $00 $5c
	.db $68 $70
	.db $74 $34
table_7d0a:
	.db $e0 $e0
	.db $7b $4e
	.db $7e $58
	.db $80 $68
	.db $81 $80
