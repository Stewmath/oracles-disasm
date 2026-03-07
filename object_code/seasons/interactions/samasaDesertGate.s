; ==================================================================================================
; INTERAC_SAMASA_DESERT_GATE
; ==================================================================================================
interactionCode9e:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call getThisRoomFlags
	bit 7,(hl)
	jp nz,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	ld bc,table_604d
	ld l,$7b
	ld (hl),b
	inc hl
	ld (hl),c
	ret
@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
@substate0:
	call func_5f8c
	ld e,$79
	ld a,(de)
	cp $ff
	ret nz
	call interactionIncSubstate
	ld l,$7d
	ld (hl),$28
	ld a,$81
	ld (wDisabledObjects),a
	ld a,$80
	ld ($cc02),a
	ld hl,mainScripts.script7556
	jp interactionSetScript
@substate1:
	call func_5f87
	ret nz
	call interactionIncSubstate
	ld l,$7d
	ld (hl),$78
	ld a,$b8
	jp playSound
@substate2:
	call func_606a
	call func_5f87
	ret nz
	call interactionIncSubstate
	ld l,$7d
	ld (hl),$01
	ret
@substate3:
	call interactionRunScript
	call func_606a
	call func_5f87
	ret nz
	call func_602c
	jr z,@func_5f67
	ld h,d
	ld l,$7d
	ld (hl),$32
	ld a,$6f
	jp playSound
@func_5f67:
	call interactionIncSubstate
	ld l,$7d
	ld (hl),$28
	ret
@substate4:
	call func_5f87
	ret nz
	xor a
	ld ($cc02),a
	ld (wDisabledObjects),a
	ld a,$4d
	call playSound
	call getThisRoomFlags
	set 7,(hl)
	jp interactionDelete
func_5f87:
	ld h,d
	ld l,$7d
	dec (hl)
	ret
func_5f8c:
	call func_5fcd
	jr z,++
	call checkLinkID0AndControlNormal
	ret nc
	ld a,($cc46)
	bit 6,a
	jr z,func_5fa3
	ld c,$01
	ld b,$b0
	jp func_5fba
func_5fa3:
	ld a,($cc45)
	bit 6,a
	ret nz
++
	ld h,d
	ld l,$78
	ld a,$00
	cp (hl)
	ret z
	ld c,$00
	ld b,$b1
	call func_5fba
	jp func_6001
func_5fba:
	ld h,d
	ld l,$78
	ld (hl),c
	ld a,$13
	ld l,$79
	add (hl)
	ld c,a
	ld a,b
	call setTile
	ld a,$70
	jp playSound

func_5fcd:
	ld hl,table_5ff4
	ld a,(w1Link.yh)
	ld c,a
	ld a,(w1Link.xh)
	ld b,a
--
	; bc is xh, yh
	ldi a,(hl)
	or a
	ret z
	add $04
	sub c
	cp $09
	jr nc,+
	ldi a,(hl)
	add $03
	sub b
	cp $07
	jr nc,++
	ld a,(hl)
	ld e,$79
	ld (de),a
	or d
	ret
+
	inc hl
++
	inc hl
	jr --

table_5ff4:
	; Byte 0: yh of door
	; Byte 1: xh of door
	; Byte 2: door index for checking later
	.db $20 $38 $00
	.db $20 $48 $01
	.db $20 $58 $02
	.db $20 $68 $03
	.db $00

func_6001:
	ld h,d
	ld l,$7a
	ld a,(hl)
	ld bc,table_6024
	call addAToBc
	ld a,(bc)
	ld b,a
	ld l,$79
	ld a,(hl)
	ld l,$7a
	cp b
	jr nz,func_601c
	ld a,(hl)
	cp $07
	jr z,func_601f
	inc (hl)
	ret

func_601c:
	ld (hl),$00
	ret

func_601f:
	ld l,$79
	ld (hl),$ff
	ret

table_6024:
	; order of samasa gate-pushing
	.db $02 $02 $01 $00
	.db $00 $03 $03 $03

func_602c:
	ld e,$7b
	ld a,(de)
	ld h,a
	inc de
	ld a,(de)
	ld l,a
--
	ldi a,(hl)
	or a
	jr z,@func_6044
	cp $ff
	jr z,@ret
	ld c,a
	ldi a,(hl)
	push hl
	call setTile
	pop hl
	jr --
@func_6044:
	ld e,$7b
	ld a,h
	ld (de),a
	inc e
	ld a,l
	ld (de),a
	or d
@ret:
	ret

table_604d:
	; pairs of tile location - tile to replace with
	.db $03 TILEINDEX_SAND
	.db $13 TILEINDEX_COLLAPSING_SAMASA_GATE
	.db $00

	.db $13 TILEINDEX_SAND
	.db $04 TILEINDEX_SAND
	.db $14 TILEINDEX_COLLAPSING_SAMASA_GATE
	.db $00

	.db $14 TILEINDEX_SAND
	.db $05 TILEINDEX_SAND
	.db $15 TILEINDEX_COLLAPSING_SAMASA_GATE
	.db $00

	.db $15 TILEINDEX_SAND
	.db $06 TILEINDEX_SAND
	.db $16 TILEINDEX_COLLAPSING_SAMASA_GATE
	.db $00

	.db $16 TILEINDEX_SAND
	.db $ff

func_606a:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,$02
	jp setScreenShakeCounter
