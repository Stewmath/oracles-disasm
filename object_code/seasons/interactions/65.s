; ==================================================================================================
; INTERAC_D6_CRYSTAL_TRAP_ROOM
; ==================================================================================================
interactionCode65:
	call returnIfScrollMode01Unset
	call func_5258
	jp nz,interactionDelete
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	call objectSetReservedBit1
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@notSubId0
	ld e,$46
	ld a,$78
	ld (de),a

	ld a,$02
	ld ($ff00+R_SVBK),a

	ld a,$80
	ld hl,$d000
	call @func_51c0

	ld hl,$d0a0
	call @func_51c0

	ld a,$0b
	ld hl,$d400
	call @func_51c0

	ld hl,$d4a0
	call @func_51c0

	xor a
	ld ($ff00+R_SVBK),a

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_D6_CRYSTAL_TRAP_ROOM
	inc l
	ld (hl),$01
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_D6_CRYSTAL_TRAP_ROOM
	inc l
	ld (hl),$02
	ret
@notSubId0:
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ret
@func_51c0:
	ld b,$20
-
	ldi (hl),a
	dec b
	jr nz,-
	ret
@state1:
	xor a
	ld ($ccab),a
	ld a,$3c
	ld ($cd19),a
	call interactionDecCounter1
	ret nz
	ld (hl),$78
	ld a,$01
	ld ($ccab),a
	ld hl,$cfd0
	inc (hl)
	call func_5261
	call func_545a
	call func_52d9
	call func_537e
	xor a
	ld ($ff00+R_SVBK),a
	ldh a,(<hActiveObject)
	ld d,a
	ld a,$70
	call playSound
	ld a,$0f
	ld ($cd18),a
	ld a,($cfd0)
	cp $09
	ret c
	call func_5258
	jp nz,interactionDelete
	ld a,$11
	ld ($cc6a),a
	ld a,$81
	ld ($cc6b),a
	jp interactionDelete
@state2:
	call func_5258
	jp nz,interactionDelete
	ld a,($cfd0)
	cp $09
	jr z,func_524d
	ld a,($cfd0)
	ld c,$08
	call multiplyAByC
	ld a,l
	add $10
	ld b,a
	ld hl,$d00b
	ld a,(hl)
	cp b
	jr nc,+
	ld (hl),b
+
	ld a,($cfd0)
	ld b,a
	ld a,$15
	sub b
	ld c,$08
	call multiplyAByC
	ld a,l
	sub $0e
	ld b,a
	ld hl,$d00b
	ld a,(hl)
	cp b
	ret c
	ld (hl),b
	ret
func_524d:
	ld a,$08
	call setScreenShakeCounter
	ld a,$58
	ld ($d00b),a
	ret
func_5258:
	ld a,(wActiveRoom)
	cp $c5
	ret z
	cp $c6
	ret
func_5261:
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld a,($cd09)
	cpl
	inc a
	swap a
	rlca
	ldh (<hFF8B),a
	xor a
	call func_5293
	ld a,$04
	call func_5293
	ld a,$08
	call func_5293
	ld a,$0c
	call func_5293
	ld a,$10
	call func_5293
	ld a,$14
	call func_5293
	ld a,$18
	call func_5293
	ld a,$1c
func_5293:
	ld hl,table_52a6
	rst_addAToHl
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	inc hl
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldh a,(<hFF8B)
	ld c,a
	ld b,$00
	add hl,bc
	jr func_52c6
table_52a6:
	.dw $d020 $d0c0
	.dw $d040 $d0e0
	.dw $d060 $d100
	.dw $d080 $d120
	.dw $d420 $d4c0
	.dw $d440 $d4e0
	.dw $d460 $d500
	.dw $d480 $d520
func_52c6:
	ld b,$20
--
	ld a,(hl)
	ld (de),a
	inc de
	inc l
	ld a,l
	and $1f
	jr nz,+
	ld a,l
	sub $20
	ld l,a
+
	dec b
	jr nz,--
	ret
func_52d9:
	push de
	ld a,($cfd0)
	add a
	ld hl,table_5326
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	inc hl
	push hl
	ld hl,$d400
	ld b,$05
	ld c,$02
	call queueDmaTransfer
	pop hl
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld hl,$d000
	ld b,$05
	ld c,$02
	call queueDmaTransfer
	ld a,($cfd0)
	add a
	ld hl,table_5352
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	inc hl
	push hl
	ld hl,$d460
	ld b,$05
	ld c,$02
	call queueDmaTransfer
	pop hl
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld hl,$d060
	ld b,$05
	ld c,$02
	call queueDmaTransfer
	pop de
	ret
table_5326:
	.db $01 $98 $00 $98
	.db $01 $98 $00 $98
	.db $21 $98 $20 $98
	.db $41 $98 $40 $98
	.db $61 $98 $60 $98
	.db $81 $98 $80 $98
	.db $a1 $98 $a0 $98
	.db $c1 $98 $c0 $98
	.db $e1 $98 $e0 $98
	.db $01 $99 $00 $99
	.db $21 $99 $20 $99
table_5352:
	.db $61 $9a $60 $9a
	.db $61 $9a $60 $9a
	.db $41 $9a $40 $9a
	.db $21 $9a $20 $9a
	.db $01 $9a $00 $9a
	.db $e1 $99 $e0 $99
	.db $c1 $99 $c0 $99
	.db $a1 $99 $a0 $99
	.db $81 $99 $80 $99
	.db $61 $99 $60 $99
	.db $41 $99 $40 $99
func_537e:
	ld a,($cfd0)
	or a
	ret z
	bit 0,a
	jr nz,func_53a1
	srl a
	swap a
	ld l,a
	ld a,$0f
	call func_53bb
	ld a,($cfd0)
	srl a
	ld b,a
	ld a,$0a
	sub b
	swap a
	ld l,a
	ld a,$0f
	jr func_53bb
func_53a1:
	inc a
	srl a
	swap a
	ld l,a
	ld a,$0c
	call func_53bb
	ld a,($cfd0)
	inc a
	srl a
	ld b,a
	ld a,$0a
	sub b
	swap a
	ld l,a
	ld a,$03
func_53bb:
	ld e,a
	ld b,$10
	ld h,$ce
-
	ld a,(hl)
	or e
	ldi (hl),a
	dec b
	jr nz,-
	ret
func_53c7:
	ld a,($cfd0)
	or a
	ret z
	bit 0,a
	ret nz
	srl a
	swap a
	ld l,a
	ld a,$b0
	call func_53e7
	ld a,($cfd0)
	srl a
	ld b,a
	ld a,$0a
	sub b
	swap a
	ld l,a
	ld a,$b2
func_53e7:
	ld b,$10
	ld h,$cf
-
	ldi (hl),a
	dec b
	jr nz,-
	ret

;;
; $02: D6 wall-closing room
roomTileChangesAfterLoad02_body:
	call func_537e
	call func_53c7
	ld hl,$d800
	ld de,$d0c0
	call func_5440
	ld hl,$d820
	ld de,$d0e0
	call func_5440
	ld hl,$dc00
	ld de,$d4c0
	call func_5440
	ld hl,$dc20
	ld de,$d4e0
	call func_5440
	ld hl,$da80
	ld de,$d100
	call func_5440
	ld hl,$daa0
	ld de,$d120
	call func_5440
	ld hl,$de80
	ld de,$d500
	call func_5440
	ld hl,$dea0
	ld de,$d520
	call func_5440
	jr func_545a
func_5440:
	ld a,$03
	ld ($ff00+R_SVBK),a
	push de
	ld de,$cd40
	ld b,$20
	call copyMemory
	pop de
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld hl,$cd40
	ld b,$20
	jp copyMemory

func_545a:
	ld a,($cfd0)
	or a
	ret z
	push de
	push hl
	ld hl,$d0c0
	ld de,$cd40
	ld b,$40
	ld c,$02
	call func_553a
	ld a,($cfd0)
	ld hl,table_5544
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld hl,$cd40
	ld b,$40
	ld c,$03
	call func_553a
	ld hl,$d100
	ld de,$cd40
	ld b,$40
	ld c,$02
	call func_553a
	ld a,($cfd0)
	ld hl,table_5558
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld hl,$cd40
	ld b,$40
	ld c,$03
	call func_553a
	ld hl,$d4c0
	ld de,$cd40
	ld b,$40
	ld c,$02
	call func_553a
	ld a,($cfd0)
	ld hl,table_5544
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,a
	ld a,(hl)
	add $04
	ld d,a
	ld hl,$cd40
	ld b,$40
	ld c,$03
	call func_553a
	ld hl,$d500
	ld de,$cd40
	ld b,$40
	ld c,$02
	call func_553a
	ld a,($cfd0)
	ld hl,table_5558
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,a
	ld a,(hl)
	add $04
	ld d,a
	ld hl,$cd40
	ld b,$40
	ld c,$03
	call func_553a
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld hl,$d800
	ld a,$80
	call func_552a
	ld hl,$dc00
	ld a,$0b
	call func_552a
	ld a,($cfd0)
	ld c,a
	ld b,$00
	ld a,$16
	sub c
	ld c,a
	ld a,$20
	call multiplyAByC
	ld c,l
	ld b,h
	ld hl,$d800
	add hl,bc
	ld a,$80
	push hl
	call func_552a
	pop hl
	ld bc,$0400
	add hl,bc
	ld a,$0b
	call func_552a
	xor a
	ld ($ff00+R_SVBK),a
	pop hl
	pop de
	ret
func_552a:
	ld e,a
	ld a,($cfd0)
	ld c,a
	ld a,e
--
	ld b,$20
-
	ldi (hl),a
	dec b
	jr nz,-
	dec c
	jr nz,--
	ret
func_553a:
	ld a,c
	ld ($ff00+R_SVBK),a
	call copyMemory
	xor a
	ld ($ff00+R_SVBK),a
	ret
table_5544:
	.db $00 $d8
	.db $20 $d8
	.db $40 $d8
	.db $60 $d8
	.db $80 $d8
	.db $a0 $d8
	.db $c0 $d8
	.db $e0 $d8
	.db $00 $d9
	.db $20 $d9
table_5558:
	.db $80 $da
	.db $60 $da
	.db $40 $da
	.db $20 $da
	.db $00 $da
	.db $e0 $d9
	.db $c0 $d9
	.db $a0 $d9
	.db $80 $d9
	.db $60 $d9
