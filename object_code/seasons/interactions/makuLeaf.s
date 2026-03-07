; ==================================================================================================
; INTERAC_MAKU_LEAF
; leaves during maku tree cutscenes
; Variables:
;   var03: pointer to another interactionCode48
;   var3a:
;   var3b:
;   var3c:
; ==================================================================================================
interactionCode48:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Interaction.var3a
	ld (hl),$01
	ld l,Interaction.subid
	ld a,(hl)
	or a
	ret z
	ld l,Interaction.state
	inc (hl)
	jp interactionInitGraphics

@state1:
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	ret nz
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_MAKU_LEAF
	ld e,Interaction.var03
	ld a,(de)
	ld l,e
	ld (hl),a
	dec l
	ld e,Interaction.counter1
	ld a,(de)
	inc a
	ld (de),a
	ld (hl),a
	cp $03
	jp z,interactionDelete
	jp @func_7002

@state2:
	ld a,$03
	ld (de),a
	ld h,d
	ld l,Interaction.subid
	ldi a,(hl)
	add (hl)
	ld hl,@table_701e
	rst_addDoubleIndex
	ld e,$4b
	ldi a,(hl)
	ld (de),a
	ld e,$4d
	ldi a,(hl)
	ld (de),a
	call @func_7012
	ld hl,@table_702c
	call @func_6fee
	ld a,$83
	call playSound
	ld a,$70
	ld e,$7c
	ld (de),a
	jp objectSetVisible80

@state3:
	call objectApplySpeed
	ld h,d
	ld l,Interaction.var3c
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ld a,$83
	call z,playSound
+
	ld l,$4d
	ld a,(hl)
	and $f0
	cp $f0
	jp z,interactionDelete
	ld l,$7b
	dec (hl)
	call z,@func_7018
	call interactionDecCounter1
	ret nz
	ld l,$78
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(hl)
	inc a
	jp z,interactionDelete

@func_6fee:
	ld e,$49
	ldi a,(hl)
	ld (de),a
	ld e,$46
	ldi a,(hl)
	ld (de),a
	ld e,$50
	ldi a,(hl)
	ld (de),a
	ld e,$78
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

@func_7002:
	ld e,Interaction.counter1
	ld a,(de)
	ld hl,@table_700e
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var3a
	ld (de),a
	ret

@table_700e:
	.db $01
	.db $3c
	.db $32
	.db $ff

@func_7012:
	ld e,Interaction.var3b
	ld a,$0b
	ld (de),a
	ret

@func_7018:
	ldbc INTERAC_SPARKLE $02
	call objectCreateInteraction

@table_701e:
	.db $18 $f2
	.db $00 $a8
	.db $d8 $c0
	.db $08 $c8
	.db $12 $cd
	.db $ea $e5
	.db $1a $ed

@table_702c:
	; angle - counter1 - speed
	.db $12 $0a $78
	.db $13 $09 $78
	.db $14 $08 $6e
	.db $15 $08 $6e
	.db $16 $08 $64
	.db $17 $06 $50
	.db $18 $04 $46
	.db $1a $04 $46
	.db $1c $05 $3c
	.db $1e $05 $3c
	.db $00 $06 $3c
	.db $02 $06 $3c
	.db $04 $05 $32
	.db $06 $04 $32
	.db $08 $02 $32
	.db $0a $01 $32
	.db $0c $02 $32
	.db $0e $04 $3c
	.db $10 $04 $3c
	.db $12 $06 $46
	.db $14 $06 $50
	.db $15 $0a $50
	.db $16 $0c $64
	.db $17 $16 $78
	.db $ff
