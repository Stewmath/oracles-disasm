; ==================================================================================================
; INTERAC_MAGNET_SPINNER
; ==================================================================================================
interactionCode7b:
	ld h,d
	ld l,$46
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	jr z,+
	ld a,d
	ld ($ccb0),a
+
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$07
	call objectSetCollideRadius
	jp objectSetVisible82
@state1:
	call objectGetTileAtPosition
	ld (hl),$3f
	call func_75e7
	call nc,interactionAnimate
	call objectPreventLinkFromPassing
	ret nc
	ld a,(wMagnetGloveState)
	or a
	jr z,@func_754e
	ld e,$61
	ld a,(de)
	or a
	ret nz
	ld c,$18
	call objectCheckLinkWithinDistance
	srl a
	ld e,$48
	ld (de),a
	ld b,a
	ld a,($d008)
	xor $02
	cp b
	ret nz
	call func_75e7
	ret c
	call interactionIncState
	jp func_75e1
@func_754e:
	ld a,($ccb0)
	or a
	ret nz
	ld c,$18
	call objectCheckLinkWithinDistance
	srl a
	ret nz
	ld a,($ccb4)
	cp $3f
	ret nz
	ld a,($d004)
	cp $01
	ret nz
	ld a,$02
	ld ($cc6a),a
	xor a
	ld ($cc6c),a
	ret
@state2:
	call func_75e1
	call interactionAnimate
	ld a,($cc79)
	or a
	jr z,@func_75bb
	bit 1,a
	jr z,@func_75bb
	ld e,$61
	ld a,(de)
	cp $ff
	jr z,@func_75a7
	add a
	ld c,a
	ld e,$48
	ld a,(de)
@func_758d:
	swap a
	rrca
	ld hl,@table_75c1
	rst_addAToHl
	ld b,$00
	add hl,bc
	ld e,$4b
	ld a,(de)
	add (hl)
	ld ($d00b),a
	inc hl
	ld e,$4d
	ld a,(de)
	add (hl)
	ld ($d00d),a
	ret
@func_75a7:
	ld e,$48
	ld a,(de)
	inc a
	and $03
	ldh (<hFF8B),a
	ld c,$00
	call @func_758d
	ldh a,(<hFF8B)
	xor $02
	ld ($d008),a
@func_75bb:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret
@table_75c1:
	.db $f0 $00 $f4 $04 $f8 $08 $fc $0c
	.db $00 $10 $04 $0c $08 $08 $0c $04
	.db $10 $00 $0c $fc $08 $f8 $04 $f4
	.db $00 $f0 $fc $f4 $f8 $f8 $f4 $fc
func_75e1:
	ld e,$46
	ld a,$14
	ld (de),a
	ret
func_75e7:
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	and $80
	ret z
	ld a,b
	and $07
	ld hl,wToggleBlocksState
	call checkFlag
	ret nz
	scf
	ret
