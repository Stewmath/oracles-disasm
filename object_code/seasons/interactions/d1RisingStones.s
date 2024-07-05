; ==================================================================================================
; INTERAC_D1_RISING_STONES
; ==================================================================================================
interactionCode4b:
	ld e,$44
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
	ld e,$42
	ld a,(de)
	add a
	inc a
	ld e,$44
	ld (de),a
	jp interactionInitGraphics
@state1:
	ld a,$02
	ld (de),a
	ld a,$6f
	call playSound
	jp objectSetVisible81
@state2:
	ld e,$61
	ld a,(de)
	inc a
	jp z,interactionDelete
	jp interactionAnimate
@state3:
	ld a,$04
	ld (de),a
	call getRandomNumber_noPreserveVars
	ld b,a
	and $60
	swap a
	ld hl,@table_7260
	rst_addAToHl
	ld e,$54
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld a,b
	and $03
	ld hl,@table_7268
	rst_addAToHl
	ld e,$50
	ld a,(hl)
	ld (de),a
	call getRandomNumber_noPreserveVars
	ld b,a
	and $30
	swap a
	ld hl,@table_726c
	rst_addAToHl
	ld e,$70
	ld a,(hl)
	ld (de),a
	ld a,b
	and $0f
	ld hl,@table_7270
	rst_addAToHl
	ld e,$49
	ld a,(hl)
	ld (de),a
	inc a
	and $07
	cp $03
	jp c,objectSetVisible82
	jp objectSetVisible80
@state4:
	call objectApplySpeed
	ld e,$70
	ld a,(de)
	call objectUpdateSpeedZ
	ret nz
	jp interactionDelete
@state5:
	ld a,$06
	ld (de),a
	jp objectSetVisible81
@state6:
	call interactionDecCounter1
	jp z,interactionDelete
	jp interactionAnimate
@table_7260:
	; speedZ vals
	.db $c0 $fe $a0 $fe $a0 $fe $80 $fe
@table_7268:
	; speed vals
	.db $05 $0a $0a $14
@table_726c:
	; speedZ acceleration
	.db $0d $0e $0f $10
@table_7270:
	; angle vals
	.db $00 $01 $02 $03 $04 $05 $06 $07
	.db $01 $02 $03 $05 $06 $07 $02 $06
