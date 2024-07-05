; ==================================================================================================
; PART_MOBLIN_BOOMERANG
; ==================================================================================================
partCode21:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	res 7,a
	sub $01
	cp $03
	jr nc,@normalStatus
	ld e,$c4
	ld a,$02
	ld (de),a

@normalStatus:
	ld e,$d7
	ld a,(de)
	inc a
	jr z,@partDelete
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$2d
	inc l
	ld (hl),$06
	ld l,$d0
	ld (hl),$50
	jp objectSetVisible81

@state1:
	call objectCheckSimpleCollision
	jr nz,@func_53ee
	call partCommon_decCounter1IfNonzero
	jr z,@func_53ee
	call func_542a
@objectApplySpeed:
	call objectApplySpeed
@animate:
	jp partAnimate

@state2:
	call func_541a
	call func_53f5
	jr nc,@objectApplySpeed
	ld a,$18
	call objectGetRelatedObject1Var
	xor a
	ldi (hl),a
	ld (hl),a
@partDelete:
	jp partDelete

@func_53ee:
	ld e,$c4
	ld a,$02
	ld (de),a
	jr @animate

func_53f5:
	ld a,$0b
	call objectGetRelatedObject1Var
	push hl
	ld b,(hl)
	ld l,$8d
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,$c9
	ld (de),a
	pop hl
	ld e,$cb
	ld a,(de)
	sub (hl)
	add $04
	cp $09
	ret nc
	ld l,$8d
	ld e,$cd
	ld a,(de)
	sub (hl)
	add $04
	cp $09
	ret

func_541a:
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld e,$d0
	ld a,(de)
	add $05
	cp $50
	ret nc
	ld (de),a
	ret

func_542a:
	ld h,d
	ld l,$c7
	dec (hl)
	ret nz
	ld (hl),$06
	ld e,$d0
	ld a,(de)
	sub $05
	ret c
	ld (de),a
	ret
