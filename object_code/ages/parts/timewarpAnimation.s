; ==================================================================================================
; PART_TIMEWARP_ANIMATION
; ==================================================================================================
partCode2b:
	ld e,$c4
	ld a,(de)
	or a
	jr nz,@state1
	inc a
	ld (de),a
	ld h,d
	ld l,$c0
	set 7,(hl)
@state1:
	call objectApplySpeed
	ld e,$cb
	ld a,(de)
	add $04
	cp $f4
	jp nc,partDelete
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $03
	ld e,$c2
	ld a,(de)
	jr c,@relatedObj1_stateLessThan3
	bit 1,a
	jp nz,partDelete
@relatedObj1_stateLessThan3:
	ld l,$61
	xor (hl)
	rrca
	jp c,objectSetInvisible
	jp objectSetVisible83
