; ==================================================================================================
; INTERAC_b4
; ==================================================================================================
interactionCodeb4:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw twinrovaWitches_state0
	.dw twinrovaWitches_state1

twinrovaWitches_state0:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7
@subid0:
@subid1:
	call twinrovaWitches_state0Init
	ld l,$42
	ld a,(hl)
	call func_7266
	jp twinrovaWitches_state1
@subid2:
@subid3:
	call twinrovaWitches_state0Init
	ld l,$4f
	ld (hl),$fb
	ld l,$42
	ld a,(hl)
	call func_7266
	jp twinrovaWitches_state1
@subid4:
	call twinrovaWitches_state0Init
	ld l,$4f
	ld (hl),$f0
	ld a,$04
	call func_7266
	ld a,$04
	call interactionSetAnimation
	jp twinrovaWitches_state1
@subid5:
	call twinrovaWitches_state0Init
	ld a,$04
	call func_7266
	ld a,$01
	call interactionSetAnimation
	jp twinrovaWitches_state1
@subid6:
	call twinrovaWitches_state0Init
	ld l,$4f
	ld (hl),$00
	ld a,$05
	call interactionSetAnimation
	jp twinrovaWitches_state1
@subid7:
	call twinrovaWitches_state0Init
	ld l,$4f
	ld (hl),$00
	ld a,$06
	call interactionSetAnimation
	jp twinrovaWitches_state1

twinrovaWitches_state0Init:
	call interactionInitGraphics
	call objectSetVisiblec0
	call interactionSetAlwaysUpdateBit
	call twinrovaWitches_getOamFlags
	call interactionIncState
	ld l,$50
	ld (hl),$50
	ld l,$4f
	ld (hl),$f8
	ld l,$48
	ld (hl),$ff
	ret

twinrovaWitches_state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7
@subid0:
@subid1:
@subid2:
@subid3:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
@@substate0:
	call func_71ee
	call func_7220
	call func_720a
	call c,func_7232
	jp nc,@animate
	ld h,d
	ld l,$45
	ld (hl),$01
	ld l,$47
	ld (hl),$28
	ld l,$42
	ld a,(hl)
	cp $02
	jr nz,@@func_7105
	ld a,$00
	jr ++
@@func_7105:
	cp $03
	jr nz,@@func_710d
	ld a,$01
	jr ++
@@func_710d:
	ld a,$02
++
	call interactionSetAnimation
	jp @animate
@@substate1:
	call seasonsFunc_0a_71ce
	call @animate
	call interactionDecCounter2
	ret nz
	ld l,$45
	inc (hl)
	ld l,$47
	ld (hl),$28
@@func_7126:
	ld hl,$cfc6
	inc (hl)
	ld a,(hl)
	cp $02
	ret nz
	ld (hl),$00
	ld hl,$cfc0
	set 0,(hl)
	ret
@@substate2:
	call seasonsFunc_0a_71ce
	call @animate
	ld a,($cfc0)
	bit 0,a
	ret nz
	call interactionDecCounter2
	ret nz
	ld l,$45
	inc (hl)
	ld l,$48
	ld (hl),$ff
	ld l,$42
	ld a,(hl)
	add $04
	jp func_7266
@@substate3:
	ld e,$42
	ld a,(de)
	cp $02
	jr c,++
@@func_715c:
	call func_71ee
	call func_720a
	call c,func_7232
	jr c,+++
++
	call func_71ee
	ld e,$42
	ld a,(de)
	cp $04
	call nz,func_7220
	call func_720a
	call c,func_7232
	jr nc,@animate
+++
	ld e,$42
	ld a,(de)
	cp $02
	jr c,+
	cp $04
	jr c,++
+
	call @@func_7126
	jp interactionDelete
++
	call @@func_7126
	ld h,d
	ld l,$45
	inc (hl)
	ret
@@substate4:
	jp @animate
@subid4:
@subid5:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
@@substate0:
	call seasonsFunc_0a_71ce
	call @animate
	ld a,($cfc0)
	bit 0,a
	ret z
	call interactionIncSubstate
	ld l,$48
	ld (hl),$ff
	ret
@@substate1:
	jr @subid3@func_715c
@subid6:
@subid7:
	jp @animate
@animate:
	jp interactionAnimate

twinrovaWitches_getOamFlags:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@oamFlagsData
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.oamFlags
	ld (de),a
	ret

@oamFlagsData:
	.db $02 $01 $02 $01
	.db $00 $01 $02 $01

seasonsFunc_0a_71ce:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,table_71e6
	rst_addAToHl
	ld e,$4f
	ld a,(de)
	add (hl)
	ld (de),a
	ret
table_71e6:
	.db $ff $fe $ff $00
	.db $01 $02 $01 $00
	
func_71ee:
	ld h,d
	ld l,$7c
	ld a,(hl)
	add a
	ld b,a
	ld e,$7f
	ld a,(de)
	ld l,a
	ld e,$7e
	ld a,(de)
	ld h,a
	ld a,b
	rst_addAToHl
	ld b,(hl)
	inc hl
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,$49
	ld (de),a
	jp objectApplySpeed
	
func_720a:
	call func_7253
	ld l,$4b
	ld a,(bc)
	sub (hl)
	add $01
	cp $05
	ret nc
	inc bc
	ld l,$4d
	ld a,(bc)
	sub (hl)
	add $01
	cp $05
	ret
	
func_7220:
	ld h,d
	ld l,$49
	ld a,(hl)
	swap a
	and $01
	xor $01
	ld l,$48
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation
	
func_7232:
	call func_7242
	ld h,d
	ld l,$7d
	ld a,(hl)
	ld l,$7c
	inc (hl)
	cp (hl)
	ret nc
	ld (hl),$00
	scf
	ret
	
func_7242:
	call func_7253
	ld l,$4a
	xor a
	ldi (hl),a
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4c
	xor a
	ldi (hl),a
	ld a,(bc)
	ld (hl),a
	ret

func_7253:
	ld h,d
	ld l,$7c
	ld a,(hl)
	add a
	push af
	ld e,$7f
	ld a,(de)
	ld c,a
	ld e,$7e
	ld a,(de)
	ld b,a
	pop af
	call addAToBc
	ret

func_7266:
	add a
	add a
	ld hl,table_7279
	rst_addAToHl
	ld e,$7f
	ldi a,(hl)
	ld (de),a
	ld e,$7e
	ldi a,(hl)
	ld (de),a
	ld e,$7d
	ldi a,(hl)
	ld (de),a
	ret

table_7279:
	; var3f - var3e - var3d - unused
	; var3e/3f are pointers to below tables
	; var3d is index of last pair of entries in below tables
	dwbb table_7299 $08 $00
	dwbb table_72ab $08 $00
	dwbb table_72e5 $0b $00
	dwbb table_72fd $0b $00
	dwbb table_72bd $09 $00
	dwbb table_72d1 $09 $00
	dwbb table_7315 $04 $00
	dwbb table_731f $04 $00

table_7299:
	.db $22 $68 $28 $80 $2e $8a $34 $90
	.db $3a $8a $40 $80 $46 $68 $4a $50
	.db $50 $28
table_72ab:
	.db $22 $38 $28 $20 $2e $16 $34 $10
	.db $3a $16 $40 $20 $46 $38 $4a $50
	.db $50 $78
table_72bd:
	.db $54 $18 $58 $0e $60 $08 $68 $0c
	.db $72 $18 $78 $28 $80 $48 $88 $68
	.db $90 $80 $a0 $a0
table_72d1:
	.db $54 $88 $58 $92 $60 $98 $68 $94
	.db $72 $88 $78 $78 $80 $58 $88 $38
	.db $90 $20 $a0 $00
table_72e5:
	.db $01 $40 $29 $18 $39 $10 $45 $0c
	.db $51 $10 $61 $18 $71 $28 $77 $38
	.db $79 $48 $77 $58 $71 $68 $61 $78
table_72fd:
	.db $01 $60 $29 $88 $39 $90 $45 $94
	.db $51 $90 $61 $88 $71 $78 $77 $68
	.db $79 $58 $77 $48 $71 $38 $61 $28
table_7315:
	.db $5d $90 $4d $98 $39 $90 $2d $78
	.db $29 $60
table_731f:
	.db $5d $10 $4d $08 $39 $10 $2d $28
	.db $29 $40
