; ==================================================================================================
; INTERAC_ACCESSORY
; ==================================================================================================
interactionCode63:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

@state1:
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld l,Interaction.enabled
	ld a,(hl)
	or a
	jr z,@delete

	ld l,Interaction.var3b
	ld a,(hl)
	or a
	jr nz,@delete

	ld l,Interaction.visible
	bit 7,(hl)
	jp z,objectSetInvisible

	call objectSetVisible80
	ld bc,$f400
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr z,@takePositionWithOffset

	ld l,Interaction.animParameter
	ld a,(hl)
	push hl
	add a
	ld hl,@data
	rst_addDoubleIndex
	ld b,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld a,(hl)
	ld e,Interaction.visible
	ld (de),a
	inc hl

	; Set animation if it's changed
	ld e,Interaction.var3c
	ld a,(de)
	cp (hl)
	jr z,++
	ld a,(hl)
	ld (de),a
	push bc
	call interactionSetAnimation
	pop bc
++
	pop hl

@takePositionWithOffset:
	jp objectTakePositionWithOffset

@delete:
	jp interactionDelete


; Each row in this table is a set of values for one value of "relatedObj1.animParameter".
; This is only used when var03 is nonzero.
;
; Data format:
;   b0: Y offset
;   b1: X offset
;   b2: value for Interaction.visible
;   b3: Animation index
@data:
	.db $00 $f3 $80 $03
	.db $f3 $00 $80 $03
	.db $00 $0d $80 $03
	.db $f4 $ff $80 $03
	.db $f4 $00 $80 $03
	.db $f5 $00 $83 $03
	.db $f5 $00 $83 $0a
	.db $02 $04 $80 $00
	.db $02 $05 $80 $00
