; ==================================================================================================
; INTERAC_HORON_DOG_CREDITS
;
; Variables:
;   subid: Used as a sort of "state" variable?
;   var36: Target x-position
;   var37: ?
; ==================================================================================================
interactionCodeb9:
	ld e,Interaction.state
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

	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	ld hl,@counter1Vals
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.counter1
	ld (de),a

	ld a,b
	ld hl,@positions
	rst_addDoubleIndex
	ld b,(hl)
	inc hl
	ld a,(hl)
	ld c,a
	ld e,Interaction.var36
	ld (de),a

	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	ld e,Interaction.speed
	ld a,SPEED_100
	ld (de),a

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0Init
	.dw @jump
	.dw @jump
	.dw @subid3Init
	.dw @subid4Init
	.dw @subid5Init
	.dw @subid6Init
	.dw @subid7Init

@subid0Init:
	ld e,Interaction.angle
	ld a,$04
	ld (de),a
	ld h,d
	ld l,Interaction.counter1
	ld (hl),$e0
	inc hl
	ld (hl),$01 ; [counter2]

@jump:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@speedZVals
	rst_addDoubleIndex
	ld c,(hl)
	inc hl
	ld b,(hl)
	jp objectSetSpeedZ

@subid3Init:
	call @jump
	ld e,Interaction.speed
	ld a,SPEED_180
	ld (de),a
	jp @setZPosition

@subid4Init:
@subid5Init:
@subid6Init:
	call @jump
	ld e,Interaction.speed
	ld a,SPEED_40
	ld (de),a

@setZPosition:
	ld e,Interaction.subid
	ld a,(de)
	sub $03
	ld hl,@zPositions
	rst_addDoubleIndex
	ld e,Interaction.zh
	ldi a,(hl)
	ld (de),a
	dec e
	ld a,(hl)
	ld (de),a
	ret

@subid7Init:
	ld hl,mainScripts.horonDogCreditsScript
	jp interactionSetScript


@counter1Vals:
	.db 230, 90, 120, 190, 200, 210, 220, 250

@positions:
	.db $58 $38
	.db $48 $40
	.db $4c $60
	.db $48 $78
	.db $1a $2c
	.db $10 $38
	.db $0a $44
	.db $18 $a0

@speedZVals:
	.dw $ff40
	.dw $fee0
	.dw $ff00
	.dw $ffc0
	.dw $0036
	.dw $0036
	.dw $0036

@zPositions:
	.dw $ffe8 ; 3 == [subid]
	.dw $ffc8 ; 4
	.dw $ffc8 ; 5
	.dw $ffc8 ; 6

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionDecCounter1
	ret nz
	call objectSetVisible
	jp interactionIncSubstate


@substate1:
	call interactionAnimate
	call objectApplySpeed

	ld h,d
	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var36
	cp (hl)
	jr nz,@reachedTargetXPosition

	call interactionIncSubstate
	ld l,Interaction.zh
	ld (hl),$00
	ld l,Interaction.subid
	ld a,(hl)
	add a
	inc a
	jp interactionSetAnimation

@reachedTargetXPosition:
	ld e,Interaction.subid
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
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld e,Interaction.subid
	jp @jump

@subid3:
	ld c,$10

@label_0b_293:
	ld e,Interaction.var37
	ld a,(de)
	or a
	ret nz
	call objectUpdateSpeedZ_paramC
	ret nz

	ld h,d
	ld l,Interaction.var37
	inc (hl)

@subid7:
	ret

@subid4:
@subid5:
@subid6:
	ld c,$01
	jr @label_0b_293


@substate2:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@substate2_subidNot0

@substate2_subid0:
	ld b,a
	ld h,d
	ld l,Interaction.counter1
	call decHlRef16WithCap
	jr nz,@animate
	ld hl,wTmpcfc0.genericCutscene.cfdf
	ld (hl),$01
	ret

@substate2_subidNot0:
	cp $07
	jr nz,@animate

	call interactionRunScript
	ld e,Interaction.counter2
	ld a,(de)
	or a
	ret z

@animate:
	jp interactionAnimate
