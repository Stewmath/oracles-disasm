; ==================================================================================================
; PART_4a
; ==================================================================================================
partCode4a:
	jp nz,partDelete
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$5a
	ld l,$e6
	ld a,$04
	ldi (hl),a
	ld (hl),a
	jp objectSetVisible81
	
@state1:
	call seasonsFunc_10_79ab
	ld e,$cb
	ld a,(de)
	cp $88
	jr c,@animate
	ld e,$c4
	ld a,$02
	ld (de),a
@animate:
	jp partAnimate
	
@state2:
	call objectApplySpeed
	ld e,$cb
	ld a,(de)
	cp $b8
	jr c,@animate
	jp partDelete
	
seasonsFunc_10_79ab:
	ld e,$f1
	ld a,(de)
	ld c,a
	ld b,$9a
	call objectGetRelativeAngle
	ld e,$c9
	ld (de),a
	jp objectApplySpeed
