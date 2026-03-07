; ==================================================================================================
; INTERAC_SPECIAL_WARP
; ==================================================================================================
interactionCode1f:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw specialWarp_subid0
	.dw specialWarp_subid1
	.dw specialWarp_subid2
	.dw specialWarp_subid3
	.dw specialWarp_subid4
	.dw specialWarp_subid5
	.dw specialWarp_subid6
	.dw specialWarp_subid7
	.dw specialWarp_subid8
	.dw specialWarp_subid9
	.dw specialWarp_subidA
	.dw specialWarp_subidB
	.dw specialWarp_subidC
	.dw specialWarp_subidD

specialWarp_subid0:
specialWarp_subid1:
	call checkInteractionState
	jr nz,+
	ld a,($cd00)
	and $01
	ret z
	ld a,$01
	ld (de),a
	call objectGetTileAtPosition
	ld (hl),$20
+
	ld a,($cc77)
	or a
	ret nz
	call objectGetTileAtPosition
	ld a,($ccb3)
	cp l
	ret nz
	ld (hl),$eb
	ld a,$81
	ld ($cca4),a
	jp interactionDelete

specialWarp_subid2:
specialWarp_subid3:
specialWarp_subid4:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld e,$42
	ld a,(de)
	sub $02
	add a
	ld hl,@table_51e5
	rst_addDoubleIndex
	ld e,$70
	ld b,$03
	call copyMemory
	ld e,$67
	ldi a,(hl)
	ld (de),a
	dec e
	ld a,$0a
	ld (de),a
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ld a,$01
	jr nc,+
	inc a
+
	ld e,$44
	ld (de),a
	ret

@table_51e5:
	.db $05 $bc $97 $10
	.db $05 $bd $97 $18
	.db $05 $0d $97 $18

	.db $00 $2e $61 $00
	.db $00 $2e $75 $00
	.db $00 $5a $54 $00

@state1:
	ld a,d
	ld (wDisableWarpTiles),a
	ld a,($cc48)
	cp $d1
	ret nz
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	xor a
	ld ($cc65),a
@setWarpVariables:
	ld h,d
	ld l,$70
	ldi a,(hl)
	ld (wWarpDestGroup),a
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ld a,(hl)
	ld (wWarpDestPos),a
	ld a,$03
	ld (wWarpTransition2),a
	ld a,$01
	ld (wScrollMode),a
	jp interactionDelete

@state2:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret c
	ld e,$44
	ld a,$01
	ld (de),a
	ret

specialWarp_subid5:
specialWarp_subid6:
specialWarp_subid7:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call specialWarp_subid4@state0
	xor a
	ld (wActiveMusic),a
	jp interactionSetAlwaysUpdateBit
@state1:
@state2:
	ld a,d
	ld ($ccab),a
	ld a,($cc48)
	cp $d1
	ret nz
	xor a
	ld ($ccab),a
	ld a,($cd00)
	and $01
	ret nz
	xor a
	ld ($cd00),a
	ld a,$ff
	ld ($cca4),a
	ld (wActiveMusic),a
	jr specialWarp_subid4@setWarpVariables

specialWarp_subid8:
specialWarp_subid9:
specialWarp_subidA:
specialWarp_subidB:
specialWarp_subidC:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	ld a,$02
	call objectSetCollideRadius
+
	ld a,($cc78)
	rlca
	ret nc
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	ld e,$42
	ld a,(de)
	sub $08
	ld hl,table_52a4
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ld a,(hl)
	ld (wWarpDestPos),a
	ld a,$87
	ld (wWarpDestGroup),a
	ld a,$01
	ld (wWarpTransition),a
@fadeoutTransition:
	ld a,$03
	ld (wWarpTransition2),a
	jp interactionDelete

table_52a4:
	.db $e0 $02
	.db $e1 $0b
	.db $e4 $02
	.db $e6 $02
	.db $e7 $0d

specialWarp_subidD:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	ld a,$02
	call objectSetCollideRadius
+
	ld a,($cc78)
	rlca
	ret nc
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	ld hl,$cc63
	ld (hl),$85
	inc l
	ld (hl),$12
	inc l
	ld (hl),$05
	inc l
	ld (hl),$29
	jr specialWarp_subidC@fadeoutTransition
