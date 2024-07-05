; ==================================================================================================
; INTERAC_D5_REVERSE_MOVING_ARMOS
; ==================================================================================================
interactionCode63:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,(wBlockPushAngle)
	or a
	ret z
	add $10
	and $1f
	add $04
	add a
	swap a
	and $03
	ld hl,@table_50da
	rst_addAToHl
	ld c,(hl)
	call objectGetShortPosition
	add c
	ld b,$ce
	ld c,a
	ldh (<hFF8C),a
	ld a,(bc)
	or a
	jr nz,@func_50e3
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_PUSHBLOCK
	ld l,$49
	ld a,(wBlockPushAngle)
	add $10
	and $1f
	ld (hl),a
	ldh (<hFF8B),a
	ld bc,$fe00
	call objectCopyPositionWithOffset
	call objectGetShortPosition
	ld l,$70
	ld (hl),a
	ld h,d
	ld l,$4b
	ldh a,(<hFF8C)
	call setShortPosition
	ld l,$44
	ld (hl),$01
	xor a
	ld (wBlockPushAngle),a
	ret
@table_50da:
	.db $f0 $01 $10 $ff
@state1:
	ld a,(wBlockPushAngle)
	or a
	ret z
@func_50e3:
	ld e,Interaction.state
	xor a
	ld (de),a
	ld (wBlockPushAngle),a
	ret
