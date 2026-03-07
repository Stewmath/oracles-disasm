; ==================================================================================================
; PART_VERAN_ACID_POOL
; ==================================================================================================
partCode57:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@state0:
	call objectCenterOnTile
	call objectGetShortPosition
	ld e,$f0
	ld (de),a
	ld e,$c6
	ld a,$04
	ld (de),a
	ld a,SND_UNKNOWN3
	call playSound
	ld hl,@table_7d98
	ld a,$60
	jr @func_7de1

@table_7d98:
	.db $f0 $ff $01 $10

@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$04
	ld hl,@table_7da9
	ld a,$60
	jr @func_7de1

@table_7da9:
	.db $ef $f1 $0f $11

@state2:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$2d
	ld l,e
	inc (hl)
	ld l,$60
@func_7db7:
	ld e,$f0
	ld a,(de)
	ld c,a
	ld b,$cf
	ld a,(bc)
	sub $02
	cp $03
	ret c
	ld a,l
	jp setTile

@state3:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$04
	ld l,e
	inc (hl)

@state4:
	ld hl,@table_7da9
	ld a,$a0
	jr @func_7de1

@state5:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$04
	ld hl,@table_7d98
	ld a,$a0
@func_7de1:
	ldh (<hFF8B),a
	ld e,$f0
	ld a,(de)
	ld c,a
	ld b,$04
---
	push bc
	ldi a,(hl)
	add c
	ld c,a
	ld b,$cf
	ld a,(bc)
	cp $da
	jr z,+
	sub $02
	cp $03
	jr c,++
	ld b,$ce
	ld a,(bc)
	or a
	jr nz,++
+
	ldh a,(<hFF8B)
	push hl
	call setTile
	pop hl
++
	pop bc
	dec b
	jr nz,---
	ld h,d
	ld l,$c4
	inc (hl)
	ret

@state6:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,$a0
	call @func_7db7
	jp partDelete
