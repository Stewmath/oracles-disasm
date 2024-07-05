; ==================================================================================================
; INTERAC_GNARLED_KEYHOLE
; ==================================================================================================
interactionCode21:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interactionRunScript
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	call getThisRoomFlags
	bit 7,a
	jp nz,interactionDelete
	ld e,$44
	ld a,$01
	ld (de),a
	ld a,$01
	ld (wDisableWarpTiles),a
	call func_5469
	ld hl,mainScripts.gnarledKeyholeScript
	jp interactionSetScript
@state2:
	call interactionIncState
	ld l,$46
	ld (hl),$1e
	call setLinkForceStateToState08
	ld a,($cca4)
	or $80
	ld ($cca4),a
	call func_545d
@state3:
	call func_54ae
	call interactionDecCounter1
	jr nz,func_545d
	ld l,$47
	ld a,(hl)
	cp $04
	jr nc,+
	inc (hl)
	ld a,(hl)
	call func_549d
	ld a,$82
	call playSound
	ld e,$47
	ld a,(de)
	ld hl,@table_542d
	rst_addDoubleIndex
	dec e
	ldi a,(hl)
	ld (de),a
	ld a,(hl)
	or a
	jr z,func_5463
+
	ld l,$44
	inc (hl)
	jr func_5463
@table_542d:
	; counter1
	.db $1e $00
	.db $3c $00
	.db $2d $00
	.db $28 $00
	.db $23 $00
@state4:
	ld a,$09
	ld hl,table_5482
	ld bc,table_5494
	call func_5471
	xor a
	ld (wDisableWarpTiles),a
	ld ($cca4),a
	ld ($cc02),a
	ld a,$4d
	call playSound
	ld a,($cc62)
	ld (wActiveMusic),a
	call playSound
	jp interactionDelete

func_545d:
	ld a,$0f
	ld (wScreenShakeCounterX),a
	ret

func_5463:
	ld a,$04
	ld (wScreenShakeCounterY),a
	ret

func_5469:
	ld a,$09
	ld hl,table_5482
	ld bc,table_548b
func_5471:
	ld d,>wRoomCollisions
	ld e,a
-
	push de
	ldi a,(hl)
	ld e,a
	ld a,(bc)
	inc bc
	ld (de),a
	pop de
	dec e
	jr nz,-
	ldh a,(<hActiveObject)
	ld d,a
	ret
table_5482:
	.db $23 $24 $25
	.db $33 $34 $35
	.db $43 $44 $45
table_548b:
	; initial collisions
	.db $00 $00 $00
	.db $00 $00 $00
	.db $04 $0c $08
table_5494:
	; collisions after rising
	.db $01 $03 $02
	.db $0f $0f $0f
	.db $0f $0c $0f
func_549d:
	ld hl,table_54a9
	rst_addAToHl
	ld a,(hl)
	call uniqueGfxFunc_380b
	ldh a,(<hActiveObject)
	ld d,a
	ret
table_54a9:
	.db $20 $21 $22 $23 $04
func_54ae:
	ld a,(wFrameCounter)
	and $01
	ret nz
	call getRandomNumber_noPreserveVars
	ld e,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_D1_RISING_STONES
	inc l
	ld a,(wFrameCounter)
	and $06
	rrca
	ld bc,table_54e4
	call addAToBc
	ld a,(bc)
	ld (hl),a
	ld l,$4b
	ld a,e
	and $07
	sub $04
	add $48
	ldi (hl),a
	inc l
	ld a,e
	and $f8
	swap a
	rlca
	sub $10
	add $48
	ld (hl),a
	ret
table_54e4:
	.db $00 $01 $00 $00
