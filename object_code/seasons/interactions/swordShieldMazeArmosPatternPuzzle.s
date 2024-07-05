; ==================================================================================================
; INTERAC_D8_ARMOS_PATTERN_PUZZLE
; ==================================================================================================
interactionCode67:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	call getThisRoomFlags
	bit 5,(hl)
	jp nz,interactionDelete
	ld a,$0a
	call objectSetCollideRadius
	ld l,$44
	inc (hl)
	jp interactionInitGraphics
@state1:
	call objectCheckCollidedWithLink_notDead
	ret nc
	call getRandomNumber
	and $0f
	ld hl,@table_5727
	rst_addAToHl
	ld a,(hl)
	ld e,$43
	ld (de),a
	ld hl,@table_571f
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call interactionIncState
	ld a,$81
	ld ($cca4),a
	call objectSetVisible82
	call setCameraFocusedObject
	call func_57f3
	ld e,$79
	ld (de),a
	jp objectCreatePuff
@table_571f:
	.dw mainScripts.d8ArmosScript_pattern1
	.dw mainScripts.d8ArmosScript_pattern2
	.dw mainScripts.d8ArmosScript_pattern3
	.dw mainScripts.d8ArmosScript_pattern4
@table_5727:
	.db $00 $01 $02 $03
	.db $00 $01 $02 $03
	.db $00 $01 $02 $03
	.db $00 $01 $02 $03
@state2:
	ld a,(wFrameCounter)
	rrca
	jr nc,+
	ld a,$80
	ld h,d
	ld l,$5a
	xor (hl)
	ld (hl),a
+
	call interactionAnimate
	jp interactionRunScript
@state3:
	ld e,$5a
	xor a
	ld (de),a
	call func_57f3
	ld b,a
	ld e,$79
	ld a,(de)
	cp b
	ret z
	ld e,$43
	ld a,(de)
	ld hl,@table_579a
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,$78
	ld a,(de)
	rst_addAToHl
	ld a,(hl)
	cp b
	jr nz,@func_5792
	cp $1c
	jr z,@func_577f
	ld c,a
	ld a,(de)
	inc a
	ld (de),a
	ld a,b
	ld e,$79
	ld (de),a
@func_5775:
	ld a,$a2
	call setTile
	ld a,$62
	jp playSound
@func_577f:
	ld c,$1c
	call @func_5775
	call interactionIncState
	ld a,$4d
	call playSound
	ld hl,mainScripts.d8ArmosScript_giveKey
	jp interactionSetScript
@func_5792:
	ld a,$5a
	call playSound
	jp interactionDelete
@table_579a:
	.dw @@table_57a2
	.dw @@table_57b3
	.dw @@table_57c2
	.dw @@table_57d7
@@table_57a2:
	.db $9c $8c $7c $7d
	.db $6d $6c $6b $6a
	.db $5a $4a $3a $2a
	.db $1a $1b $2b $2c
	.db $1c
@@table_57b3:
	.db $9c $8c $7c $7d
	.db $6d $5d $4d $4c
	.db $4b $4a $3a $2a
	.db $1a $1b $1c
@@table_57c2:
	.db $9c $9b $9a $8a
	.db $8b $8c $8d $7d
	.db $7c $7b $7a $6a
	.db $5a $4a $3a $2a
	.db $2b $2c $2d $1d
	.db $1c
@@table_57d7:
	.db $9c $8c $7c $6c
	.db $5c $5b $6b $7b
	.db $7c $7d $6d $6c
	.db $6b $6a $5a $4a
	.db $3a $2a $1a $1b
	.db $1c
@state4:
	call interactionRunScript
	jp c,interactionDelete
	ret
func_57f3:
	ld hl,$d00b
	ldi a,(hl)
	add $04
	and $f0
	ld b,a
	inc l
	ld a,(hl)
	swap a
	and $0f
	or b
	ret
