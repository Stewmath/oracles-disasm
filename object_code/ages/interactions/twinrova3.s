; ==================================================================================================
; INTERAC_TWINROVA_3
;
; Variables:
;   var3c: A target position index for the data in var3e/var3f.
;   var3d: # of values in the position list (var3c must stop here).
;   var3e/var3f: A pointer to a list of target positions.
; ==================================================================================================
interactionCodebc:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid0
	.dw @initSubid1
	.dw @initSubid2
	.dw @initSubid3

@initSubid0:
@initSubid1:
	call @commonInit
	ld l,Interaction.zh
	ld (hl),$fb
	ld l,Interaction.subid
	ld a,(hl)
	call @readPositionTable
	jp @state1

@initSubid2:
	call @commonInit
	ld l,Interaction.zh
	ld (hl),$f0
	ld a,$02
	call @readPositionTable
	ld a,$04
	call interactionSetAnimation
	jp @state1

@initSubid3:
	call @commonInit
	ld a,$02
	call @readPositionTable
	ld a,$01
	call interactionSetAnimation
	jp @state1

@commonInit:
	call interactionInitGraphics
	call objectSetVisiblec0
	call interactionSetAlwaysUpdateBit
	call @loadOamFlags
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_200
	ld l,Interaction.zh
	ld (hl),$f8
	ld l,Interaction.direction
	ld (hl),$ff
	ret


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0State1
	.dw @subid0State1
	.dw @subid2State1
	.dw @subid2State1


@subid0State1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid0Substate0
	.dw @subid0Substate1
	.dw @subid0Substate2
	.dw @subid0Substate3
	.dw @subid0Substate4

@subid0Substate0:
	call @moveTowardTargetPosition
	call @updateAnimationIndex

	call @checkReachedTargetPosition
	call c,@nextTargetPosition
	jp nc,@animate

	; Exhausted position list
	ld h,d
	ld l,Interaction.substate
	ld (hl),$01
	ld l,Interaction.counter2
	ld (hl),40

	ld l,Interaction.subid
	ld a,(hl)
	or a
	jr nz,+

	ld a,$00
	jr +++
+
	cp $01
	jr nz,++

	ld a,$01
	jr +++
++
	ld a,$02
+++
	call interactionSetAnimation
	jp @animate

@subid0Substate1:
	call @updateFloating
	call @animate
	call interactionDecCounter2
	ret nz

	ld l,Interaction.substate
	inc (hl)
	ld l,Interaction.counter2
	ld (hl),40

@func_6eac:
	ld hl,wTmpcfc0.genericCutscene.cfc6
	inc (hl)
	ld a,(hl)
	cp $02
	ret nz
	ld (hl),$00
	ld hl,wTmpcfc0.genericCutscene.state
	set 0,(hl)
	ret

@subid0Substate2:
	call @updateFloating
	call @animate
	ld a,(wTmpcfc0.genericCutscene.state)
	bit 0,a
	ret nz
	call interactionDecCounter2
	ret nz

	ld l,Interaction.substate
	inc (hl)
	ld l,Interaction.direction
	ld (hl),$ff
	ld l,Interaction.subid
	ld a,(hl)
	add $04
	jp @readPositionTable

@subid0Substate3:
	call @moveTowardTargetPosition
	call @checkReachedTargetPosition
	call c,@nextTargetPosition
	jr c,@@looped

	call @moveTowardTargetPosition
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	call nz,@updateAnimationIndex
	call @checkReachedTargetPosition
	call c,@nextTargetPosition
	jr nc,@animate

@@looped:
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	jr c,++

	call @func_6eac
	jp interactionDelete
++
	call @func_6eac
	ld h,d
	ld l,Interaction.substate
	inc (hl)
	ret

@subid0Substate4:
	jp @animate


@subid2State1:
	call checkInteractionSubstate
	jr nz,++
	call @updateFloating
	call @animate
	ld a,(wTmpcfc0.genericCutscene.state)
	bit 0,a
	ret z
	call interactionIncSubstate
	ld l,Interaction.direction
	ld (hl),$ff
	ret
++
	jr @subid0Substate3

@animate:
	jp interactionAnimate

@loadOamFlags:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@oamFlags
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.oamFlags
	ld (de),a
	ret

@oamFlags:
	.db $02 $01 $00 $01

;;
; Updates z values to "float" up and down?
@updateFloating:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,@zValues
	rst_addAToHl
	ld e,Interaction.zh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

@zValues:
	.db $ff $fe $ff $00 $01 $02 $01 $00

;;
@moveTowardTargetPosition:
	ld h,d
	ld l,Interaction.var3c
	ld a,(hl)
	add a
	ld b,a

	ld e,Interaction.var3f
	ld a,(de)
	ld l,a
	ld e,Interaction.var3e
	ld a,(de)
	ld h,a

	ld a,b
	rst_addAToHl
	ld b,(hl)
	inc hl
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	jp objectApplySpeed

;;
; @param	bc	Pointer to position data (Y, X values)
; @param[out]	cflag	c if reached target position
@checkReachedTargetPosition:
	call @getCurrentPositionPointer
	ld l,Interaction.yh
	ld a,(bc)
	sub (hl)
	add $01
	cp $05
	ret nc
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	sub (hl)
	add $01
	cp $05
	ret

;;
@updateAnimationIndex:
	ld h,d
	ld l,Interaction.angle
	ld a,(hl)
	swap a
	and $01
	xor $01
	ld l,Interaction.direction
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation

;;
; @param[out]	cflag	c if we've exhausted the position list and we're looping
@nextTargetPosition:
	call @@setPositionToPointerData
	ld h,d
	ld l,Interaction.var3d
	ld a,(hl)
	ld l,Interaction.var3c
	inc (hl)
	cp (hl)
	ret nc
	ld (hl),$00
	scf
	ret

;;
@@setPositionToPointerData:
	call @getCurrentPositionPointer
	ld l,Interaction.y
	xor a
	ldi (hl),a
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.x
	xor a
	ldi (hl),a
	ld a,(bc)
	ld (hl),a
	ret

;;
; @param[out]	bc	Pointer to position data
@getCurrentPositionPointer:
	ld h,d
	ld l,Interaction.var3c
	ld a,(hl)
	add a
	push af
	ld e,Interaction.var3f
	ld a,(de)
	ld c,a
	ld e,Interaction.var3e
	ld a,(de)
	ld b,a
	pop af
	call addAToBc
	ret

;;
; Read values for var3f, var3e, var3d based on parameter
;
; @param	a	Index for table
@readPositionTable:
	add a
	ld hl,@table
	rst_addDoubleIndex
	ld e,Interaction.var3f
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.var3e
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.var3d
	ldi a,(hl)
	ld (de),a
	ret

@table:
	dwbb @positions0, $0b, $00
	dwbb @positions1, $0b, $00
	dwbb @positions2, $09, $00
	dwbb @positions3, $09, $00
	dwbb @positions4, $04, $00
	dwbb @positions5, $04, $00

@positions2:
	.db $54 $18
	.db $58 $0e
	.db $60 $08
	.db $68 $0c
	.db $72 $18
	.db $78 $28
	.db $80 $48
	.db $88 $68
	.db $90 $80
	.db $a0 $a0

@positions3:
	.db $54 $88
	.db $58 $92
	.db $60 $98
	.db $68 $94
	.db $72 $88
	.db $78 $78
	.db $80 $58
	.db $88 $38
	.db $90 $20
	.db $a0 $00

@positions0:
	.db $01 $40
	.db $29 $18
	.db $39 $10
	.db $45 $0c
	.db $51 $10
	.db $61 $18
	.db $71 $28
	.db $77 $38
	.db $79 $48
	.db $77 $58
	.db $71 $68
	.db $61 $78

@positions1:
	.db $01 $60
	.db $29 $88
	.db $39 $90
	.db $45 $94
	.db $51 $90
	.db $61 $88
	.db $71 $78
	.db $77 $68
	.db $79 $58
	.db $77 $48
	.db $71 $38
	.db $61 $28

@positions4:
	.db $5d $90
	.db $4d $98
	.db $39 $90
	.db $2d $78
	.db $29 $60

@positions5:
	.db $5d $10
	.db $4d $08
	.db $39 $10
	.db $2d $28
	.db $29 $40
