; ==================================================================================================
; PART_HEAD_THWOMP_BOMB_DROPPER
; ==================================================================================================
partCode40:
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $01
	jp nz,partDelete
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	ld a,$20
	call objectUpdateSpeedZ_sidescroll
	jp c,partDelete
	call objectApplySpeed
	ld a,$00
	call objectGetRelatedObject1Var
	jp objectCopyPosition

@state0:
	ld h,d
	ld l,e
	inc (hl)
	call getRandomNumber_noPreserveVars
	ld b,a
	and $03
	ld hl,@speedVals
	rst_addAToHl
	ld e,$d0
	ld a,(hl)
	ld (de),a
	ld a,b
	and $60
	swap a
	ld hl,@speedZVals
	rst_addAToHl
	ld e,$d4
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ldh a,(<hRng2)
	and $10
	add $08
	ld e,$c9
	ld (de),a
	ret

@speedVals:
	.db SPEED_080
	.db SPEED_0a0
	.db SPEED_0c0
	.db SPEED_0e0

@speedZVals:
	.dw -$300
	.dw -$320
	.dw -$340
	.dw -$360
