; ==================================================================================================
; PART_HOLES_FLOORTRAP
; Variables:
;   var30 - pointer to tile at part's position
;   $ccbf - set to 1 when button in hallway to D3 miniboss is pressed
; ==================================================================================================
partCode0a:
	ld e,Part.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subidStub
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	call @init_StoreTileAtPartInVar30
	ld l,Part.counter1
	ld (hl),$08
	ret
@@state1:
	; Proceed once button in D3 hallway to miniboss stepped on
	ld a,($ccbf)
	or a
	ret z

	call @breakFloorsAtInterval
	ret nz

	call @spreadVertical
	ret z

	call @spreadHorizontal
	ret z
	jp partDelete

@subidStub:
	jp partDelete

@subid2:
@subid3:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	call @init_StoreTileAtPartInVar30
	ld l,Part.counter1
	ld (hl),$20
	ret
@@state1:
	ld a,($ccbf)
	or a
	ret z
	call @breakFloorsAtInterval
	ret nz
	call seasonsFunc_10_63ed
	ret nz
	jp partDelete

@subid4:
	ld h,d
	ld l,Part.state
	ld a,(hl)
	or a
	jr nz,+
	; state 0
	ld (hl),$01
	ld l,Part.counter1
	ld (hl),$08
	inc l
	ld (hl),$00
	call @@setPositionToCrackTile
+
	; state 1
	ld a,$3c
	call setScreenShakeCounter
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,Part.yh
	ld c,(hl)
	ld a,TILEINDEX_BLANK_HOLE
	call breakCrackedFloor
@@setPositionToCrackTile:
	ld e,Part.counter2
	ld a,(de)
	ld hl,@@crackedTileTable
	rst_addDoubleIndex
	ld a,(hl)
	or a
	jp z,partDelete

	ldi a,(hl)
	ld e,Part.counter1
	ld (de),a

	ld a,(hl)
	ld e,Part.yh
	ld (de),a

	ld h,d
	ld l,Part.counter2
	inc (hl)
	ret
@@crackedTileTable:
	; counter1 - position of tile to break
	.db $1e $91
	.db $1e $81
	.db $01 $82
	.db $1d $71
	.db $01 $61
	.db $1d $83
	.db $01 $51
	.db $1d $84
	.db $01 $52
	.db $1d $85
	.db $01 $53
	.db $1d $86
	.db $01 $63
	.db $1d $87
	.db $01 $64
	.db $1d $88
	.db $01 $65
	.db $1d $89
	.db $01 $55
	.db $1d $79
	.db $01 $45
	.db $1d $69
	.db $01 $35
	.db $01 $68
	.db $1c $6a
	.db $01 $25
	.db $01 $58
	.db $1c $6b
	.db $01 $48
	.db $1d $5b
	.db $1e $38
	.db $1e $37
	.db $1e $36
	.db $00

@init_StoreTileAtPartInVar30:
	ld a,$01
	ld (de),a

	ld h,d
	ld l,Part.yh
	ld a,(hl)
	ld c,a

	ld b,>wRoomLayout
	ld a,(bc)

	ld l,Part.var30
	ld (hl),a
	ret

@breakFloorsAtInterval:
	call partCommon_decCounter1IfNonzero
	ret nz

	; counter back to $08
	ld (hl),$08
	ld l,Part.var30
	ld a,TILEINDEX_CRACKED_FLOOR
	cp (hl)
	ld a,TILEINDEX_HOLE
	jr z,+
	ld a,TILEINDEX_BLANK_HOLE
+
	ld l,Part.yh
	ld c,(hl)
	call breakCrackedFloor

	; proceed to below function
	xor a
	ret

@spreadVertical:
	ld h,$10
	jr @spread
@spreadHorizontal:
	ld h,$01
@spread:
	ld b,>wRoomLayout
	ld e,Part.var30
	ld a,(de)
	ld l,a

	ld e,Part.yh
	ld a,(de)
	ld e,a

	sub h
	ld c,a
	ld a,(bc)
	cp l
	jr z,+

	ld a,e
	add h
	ld c,a
	ld a,(bc)
	cp l
	ret nz
+
	ld a,c
	ld e,Part.yh
	ld (de),a
	ret

seasonsFunc_10_63ed:
	ld e,Part.var30
	ld a,(de)
	ld b,a
	ld c,$10
	ld hl,wRoomLayout
--
	ld a,b
	cp (hl)
	jr z,++
	ld a,l
	cp $ae
	ret z
	add c
	cp $f0
	jr nc,+
	cp $b0
	jr nc,+
	ld l,a
	jr --
+
	ld a,c
	cpl
	inc a
	ld c,a
	ld a,l
	add c
	inc a
	ld l,a
	jr --
++
	ld a,l
	ld e,Part.yh
	ld (de),a
	or d
	ret
