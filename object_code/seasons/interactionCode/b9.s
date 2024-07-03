; ==============================================================================
; INTERAC_b9
; ==============================================================================
interactionCodeb9:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2
	call objectSetInvisible
	ld e,$42
	ld a,(de)
	ld b,a
	ld hl,@@counter1Vals
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.counter1
	ld (de),a
	ld a,b
	ld hl,@@coordsToLookAt
	rst_addDoubleIndex
	ld b,(hl)
	inc hl
	ld a,(hl)
	ld c,a
	ld e,$76
	ld (de),a
	call objectGetRelativeAngle
	ld e,$49
	ld (de),a
	ld e,$50
	ld a,$28
	ld (de),a
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@setSpeedZ
	.dw @@setSpeedZ
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
	.dw @@subid6
	.dw @@subid7
@@subid0:
	ld e,$49
	ld a,$04
	ld (de),a
	ld h,d
	ld l,$46
	ld (hl),$e0
	inc hl
	ld (hl),$01
@@setSpeedZ:
	ld e,$42
	ld a,(de)
	ld hl,@@speedZValues
	rst_addDoubleIndex
	ld c,(hl)
	inc hl
	ld b,(hl)
	jp objectSetSpeedZ
@@subid3:
	call @@setSpeedZ
	ld e,$50
	ld a,$3c
	ld (de),a
	jp @@setZhAndZ
@@subid4:
@@subid5:
@@subid6:
	call @@setSpeedZ
	ld e,$50
	ld a,$0a
	ld (de),a
@@setZhAndZ:
	ld e,$42
	ld a,(de)
	sub $03
	ld hl,@@zhAndZvalues
	rst_addDoubleIndex
	ld e,$4f
	ldi a,(hl)
	ld (de),a
	dec e
	ld a,(hl)
	ld (de),a
	ret
@@subid7:
	ld hl,mainScripts.script7a81
	jp interactionSetScript
@@counter1Vals:
	.db $e6 $5a $78 $be
	.db $c8 $d2 $dc $fa
@@coordsToLookAt:
	.db $58 $38
	.db $48 $40
	.db $4c $60
	.db $48 $78
	.db $1a $2c
	.db $10 $38
	.db $0a $44
	.db $18 $a0
@@speedZValues:
	.dw -$0c0
	.dw -$120
	.dw -$100
	.dw -$040
	.dw  $036
	.dw  $036
	.dw  $036
@@zhAndZvalues:
	.db $e8 $ff
	.db $c8 $ff
	.db $c8 $ff
	.db $c8 $ff
	
@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
@@substate0:
	call interactionDecCounter1
	ret nz
	call objectSetVisible
	jp interactionIncSubstate
@@substate1:
	call interactionAnimate
	call objectApplySpeed
	ld h,d
	ld l,$4d
	ld a,(hl)
	ld l,$76
	cp (hl)
	jr nz,@@func_752b
	call interactionIncSubstate
	ld l,$4f
	ld (hl),$00
	ld l,$42
	ld a,(hl)
	add a
	inc a
	jp interactionSetAnimation
@@func_752b:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@@subid0
	.dw @@@subid1
	.dw @@@subid2
	.dw @@@subid3
	.dw @@@subid4
	.dw @@@subid5
	.dw @@@subid6
	.dw @@@subidStub
@@@subid0:
@@@subid1:
@@@subid2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld e,$42
	jp @state0@setSpeedZ
@@@subid3:
	ld c,$10
--
	ld e,$77
	ld a,(de)
	or a
	ret nz
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d
	ld l,$77
	inc (hl)
@@@subidStub:
	ret
@@@subid4:
@@@subid5:
@@@subid6:
	ld c,$01
	jr --
@@substate2:
	ld e,$42
	ld a,(de)
	or a
	jr nz,func_7573
	ld b,a
	ld h,d
	ld l,$46
	call decHlRef16WithCap
	jr nz,func_757f
	ld hl,$cfdf
	ld (hl),$01
	ret
func_7573:
	cp $07
	jr nz,func_757f
	call interactionRunScript
	ld e,$47
	ld a,(de)
	or a
	ret z
func_757f:
	jp interactionAnimate
