; ==================================================================================================
; PART_33
; ==================================================================================================
partCode33:
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
	ld l,$d0
	ld (hl),$50
	ld b,$00
	ld a,($cc45)
	and $30
	jr z,+
	ld b,$20
	and $20
	jr z,+
	ld b,$e0
+
	ld a,($d00d)
	add b
	ld c,a
	sub $08
	cp $90
	jr c,+
	ld c,$08
	cp $d0
	jr nc,+
	ld c,$98
+
	ld b,$a0
	call objectGetRelativeAngle
	ld e,$c9
	ld (de),a
	jp objectSetVisible81
@state1:
	call objectApplySpeed
	ld e,$cb
	ld a,(de)
	cp $98
	jr c,@animate
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$c6
	ld (hl),$78
@animate:
	jp partAnimate
@state2:
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	jr @animate
